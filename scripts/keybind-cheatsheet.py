#!/usr/bin/env python3
"""Parse Hyprland Lua keybinding files and emit a cheatsheet.

Sources:
  keybindings.lua, noctaliaKeybindings.lua, submaps.lua, advanced.lua
  in /home/Thomas/.config/hypr/

Usage:
  keybind-cheatsheet.py            # rofi-ready lines: "KEY  |  DESCRIPTION"
  keybind-cheatsheet.py --json     # JSON array [{key, description, source, category}]
  keybind-cheatsheet.py --tsv      # tab-separated key/description/source/category
"""
import json
import re
import sys
from pathlib import Path

HYPR_DIR = Path("/home/Thomas/.config/hypr")
FILES = ["keybindings.lua", "noctaliaKeybindings.lua", "submaps.lua", "advanced.lua"]

CATEGORY_ORDER = [
    "Window",
    "Workspace",
    "Apps",
    "Noctalia",
    "Media",
    "Layout/Advanced",
    "Submap",
    "System",
]


def strip_comment(line: str) -> str:
    out = []
    in_str = False
    i = 0
    while i < len(line):
        c = line[i]
        if c == '"' and (i == 0 or line[i - 1] != "\\"):
            in_str = not in_str
            out.append(c)
            i += 1
        elif not in_str and c == "-" and i + 1 < len(line) and line[i + 1] == "-":
            break
        else:
            out.append(c)
            i += 1
    return "".join(out)


def collect_vars(text: str) -> dict:
    """Collect simple string locals, resolving `..` concatenations iteratively."""
    vars_: dict[str, str] = {}
    for line in text.splitlines():
        code = strip_comment(line).strip()
        m = re.match(r'local\s+(\w+)\s*=\s*(.+)$', code)
        if not m:
            continue
        name, rhs = m.group(1), m.group(2).strip()
        if name == "key":  # loop variable `local key = i % 10`
            continue
        if rhs.startswith("function"):
            continue
        vars_.setdefault(name, rhs)  # keep raw expr first
    resolved: dict[str, str] = {}
    for _ in range(10):
        changed = False
        for name, rhs in list(vars_.items()):
            if name in resolved:
                continue
            val = try_resolve_concat(rhs, resolved)
            if val is not None:
                resolved[name] = val
                changed = True
        if not changed:
            break
    return resolved


def try_resolve_concat(expr: str, vars_: dict) -> str | None:
    """Resolve a Lua `..` concatenation to a plain string, or None if not possible."""
    parts = split_top(expr, "..")
    out = []
    for p in parts:
        p = p.strip()
        if not p:
            continue
        if len(p) >= 2 and p.startswith('"') and p.endswith('"'):
            out.append(p[1:-1])
        elif p in vars_:
            out.append(vars_[p])
        elif re.fullmatch(r"-?\d+(\.\d+)?", p):
            out.append(p)
        else:
            return None  # function call, table, unknown symbol
    return "".join(out)


def split_top(expr: str, sep: str) -> list[str]:
    """Split expr on sep, ignoring separators inside strings/parens/braces."""
    parts, depth, in_str, cur = [], 0, False, []
    i = 0
    while i < len(expr):
        c = expr[i]
        if c == '"' and (i == 0 or expr[i - 1] != "\\"):
            in_str = not in_str
            cur.append(c)
            i += 1
        elif in_str:
            cur.append(c)
            i += 1
        elif c in "({[":
            depth += 1
            cur.append(c)
            i += 1
        elif c in ")}]":
            depth -= 1
            cur.append(c)
            i += 1
        elif depth == 0 and expr.startswith(sep, i):
            parts.append("".join(cur))
            cur = []
            i += len(sep)
        else:
            cur.append(c)
            i += 1
    parts.append("".join(cur))
    return parts


def split_first_arg(argstr: str) -> tuple[str, str]:
    """Split hl.bind(...) args into (key_expr, rest).

    Only the key expression is split off (it never contains a top-level
    comma); the rest is divided into action/opts separately because action
    bodies (anonymous functions, layout_bind tables) may contain top-level
    commas such as `for i = 1, #layouts do`.
    """
    depth, in_str, i = 0, False, 0
    while i < len(argstr):
        c = argstr[i]
        if c == '"' and (i == 0 or argstr[i - 1] != "\\"):
            in_str = not in_str
        elif not in_str:
            if c in "({[":
                depth += 1
            elif c in ")}]":
                depth -= 1
            elif c == "," and depth == 0:
                return argstr[:i].strip(), argstr[i + 1 :].strip()
        i += 1
    return argstr.strip(), ""


def split_action_opts(rest: str) -> tuple[str, str]:
    """Split trailing flat opts table (e.g. `{ description = "..." }`) from action."""
    m = re.search(r",\s*(\{[^{}]*\})\s*$", rest, re.DOTALL)
    if m:
        return rest[: m.start()].strip(), m.group(1)
    return rest.strip(), ""


def resolve_key(expr: str, vars_: dict) -> str | None:
    if ".. key" in expr or "..key" in expr:
        return None  # workspace loop rows are expanded manually
    val = try_resolve_concat(expr, vars_)
    if val is None:
        return None
    val = re.sub(r"\s+", " ", val).strip()
    val = re.sub(r"\s*\+\s*", " + ", val)
    return val


def extract_description(opts: str) -> str | None:
    if not opts:
        return None
    m = re.search(r'description\s*=\s*"([^"]+)"', opts)
    return m.group(1) if m else None


def extract_exec_cmd(action: str, vars_: dict) -> str | None:
    m = re.search(r"exec_cmd\s*\((.*)\)\s*$", action, re.DOTALL)
    if not m:
        return None
    inner = m.group(1).strip()
    # strip one layer of parens if the whole inner is wrapped (rare)
    val = try_resolve_concat(inner, vars_)
    return val.strip() if val else None


def humanize_noctalia(cmd: str) -> str:
    body = cmd[len("noctalia msg ") :] if cmd.startswith("noctalia msg ") else cmd
    pretty = {
        "panel-toggle launcher": "Toggle launcher panel",
        "panel-toggle control-center": "Toggle control center",
        "panel-toggle control-center media": "Toggle music panel",
        "panel-toggle control-center bluetooth": "Show bluetooth panel",
        "panel-toggle control-center network": "Show network panel",
        "panel-toggle control-center weather": "Show weather panel",
        "panel-toggle wallpaper": "Toggle wallpaper selector",
        "panel-toggle clipboard": "Show clipboard history",
        "panel-toggle session": "Show session menu",
        "settings-toggle": "Open settings",
        "bar-auto-hide-set": "Toggle bar auto-hide",
        "bluetooth-toggle": "Toggle bluetooth",
        "clipboard-clear": "Clear clipboard history",
        "caffeine-toggle": "Inhibit idle (caffeine)",
        "screenshot-region": "Screenshot region",
        "screenshot-fullscreen": "Screenshot fullscreen",
        "brightness-up": "Brightness up",
        "brightness-down": "Brightness down",
        "volume-up": "Volume up",
        "volume-down": "Volume down",
        "volume-mute": "Mute volume",
        "media toggle": "Play/pause media",
        "media next": "Next track",
        "media previous": "Previous track",
        "media stop": "Stop media",
        "wallpaper-random": "Random wallpaper",
        "wifi-toggle": "Toggle wifi",
        "window-switcher": "Window switcher (Alt-Tab)",
        "window-switcher hide": "Hide window switcher",
    }
    if body in pretty:
        return pretty[body]
    if body.startswith("plugin noctalia/screen_recorder"):
        return "Toggle Noctalia screen recorder"
    return "Noctalia: " + body


def infer(action: str, key: str, source: str, vars_: dict) -> str:
    a = re.sub(r"\s+", " ", action).strip()

    # advanced.lua custom functions (no dispatcher, no description)
    if source == "advanced.lua":
        if "special:minimized" in a or 'tag = "minimized"' in a or "tag:minimized" in a:
            return "Minimize window to special workspace / restore"
        if '"scrolling"' in a and "tiled_layout" in a:
            return "Cycle layout: scrolling → dwindle → master → monocle"
        if re.search(r"\bzoom\b", a) or "zoom_factor" in a:
            if "KP_ADD" in key:
                return "Zoom in (magnifier)"
            if "KP_SUBTRACT" in key:
                return "Zoom out (magnifier)"
            return "Toggle zoom (magnifier)"
        if "layout_bind" in a:
            maps = re.findall(r'(\w+)\s*=\s*hl\.dsp\.layout\("([^"]+)"\)', a)
            if maps:
                return "Layout action: " + ", ".join(f"{lay}: {cmd}" for lay, cmd in maps)
            return "Layout-aware window action (depends on current layout)"

    if "window.close" in a:
        return "Close window"
    m = re.search(r"focus\(\{\s*direction\s*=\s*\"(\w+)\"", a)
    if m:
        return f"Focus {m.group(1)}"
    m = re.search(r"window\.move\(\{\s*direction\s*=\s*\"(\w+)\"", a)
    if m:
        return f"Move window {m.group(1)}"
    m = re.search(r"window\.resize\(\{\s*x\s*=\s*(-?\d+)\s*,\s*y\s*=\s*(-?\d+)", a)
    if m:
        if key in ("left", "right", "up", "down"):
            return f"Resize window {key}"
        x, y = int(m.group(1)), int(m.group(2))
        if x > 0:
            return "Resize window right"
        if x < 0:
            return "Resize window left"
        if y > 0:
            return "Resize window down"
        if y < 0:
            return "Resize window up"
        return "Resize window"
    if 'workspace = "e+1"' in a or "workspace='e+1'" in a:
        return "Next workspace"
    if 'workspace = "e-1"' in a or "workspace='e-1'" in a:
        return "Previous workspace"
    if "window.float" in a:
        return "Toggle floating window"
    if "window.pseudo" in a:
        return "Pseudo-tiling"
    if "window.fullscreen" in a:
        return "Toggle fullscreen"
    if "toggle_special" in a:
        return "Toggle special workspace (scratchpad)"
    if "special:magic" in a:
        return "Move window to special workspace (magic)"
    if "mouse_down" in key:
        return "Previous workspace (scroll)"
    if "mouse_up" in key:
        return "Next workspace (scroll)"
    if "mouse:272" in key and "drag" in a:
        return "Drag window with mouse"
    if "mouse:273" in key and "resize" in a:
        return "Resize window with mouse"
    if "cycle_next" in a:
        return "Cycle to next window"
    if "bring_to_top" in a:
        return "Bring window to top"
    m = re.search(r'submap\(\s*"([^"]+)"\s*\)', a)
    if m:
        return "Exit submap (reset)" if m.group(1) == "reset" else f"Enter {m.group(1)} submap"
    if "scrolloverview.overview" in a:
        m2 = re.search(r'overview\("([^"]+)"\)', a)
        return f"Overview: {m2.group(1)}" if m2 else "Toggle window overview"
    if "scrolloverview.navigate" in a:
        m2 = re.search(r'navigate\("([^"]+)"\)', a)
        return f"Overview navigate {m2.group(1)}" if m2 else "Navigate overview"
    if "scrolloverview.window" in a:
        m2 = re.search(r'window\("([^"]+)"\)', a)
        return f"Overview window: {m2.group(1)}" if m2 else "Overview window action"
    if "exec_cmd" in a or "dsp.exec" in a:
        cmd = extract_exec_cmd(a, vars_)
        if cmd is None:
            return "Run command"
        if cmd.startswith("noctalia msg"):
            return humanize_noctalia(cmd)
        low = cmd.lower()
        if "wpctl set-volume" in low and "5%+" in cmd:
            return "Volume up"
        if "wpctl set-volume" in low and "5%-" in cmd:
            return "Volume down"
        if "wpctl set-mute" in low and "sink" in low:
            return "Mute volume"
        if "wpctl set-mute" in low and "source" in low:
            return "Mute microphone"
        if "brightnessctl" in low and "5%+" in cmd:
            return "Brightness up"
        if "brightnessctl" in low and "5%-" in cmd:
            return "Brightness down"
        if "playerctl next" in low:
            return "Next track"
        if "playerctl previous" in low:
            return "Previous track"
        if "play-pause" in low:
            return "Play/pause media"
        if "hyprpicker" in low:
            return "Color picker"
        if "hyprshutdown" in low or "hl.dsp.exit" in a:
            return "Shutdown / exit Hyprland"
        short = cmd if len(cmd) <= 70 else cmd[:67] + "..."
        return f"Run: {short}"
    # fallback: first 80 chars of normalized action
    short = a if len(a) <= 80 else a[:77] + "..."
    return f"Action: {short}"


def categorize(key: str, desc: str, action: str, source: str, submap: str) -> str:
    if submap or "submap(" in action:
        return "Submap"
    if source == "advanced.lua":
        return "Layout/Advanced"
    if source == "noctaliaKeybindings.lua" or "noctalia msg" in action:
        if key.startswith("XF86") or key == "Print" or " volume" in desc.lower() or "brightness" in desc.lower() or "media" in desc.lower() or "track" in desc.lower():
            return "Media"
        return "Noctalia"
    if key.startswith("XF86") or key in ("Print",) or "Volume" in desc or "Brightness" in desc or "playerctl" in action:
        return "Media"
    if "workspace" in action.lower() or "workspace" in desc.lower():
        return "Workspace"
    if "exec_cmd" in action or "Run:" in desc:
        if any(w in desc for w in ("Terminal", "Browser", "Editor", "File Manager", "Music", "Email", "Reddit", "Podcasts", "WGU", "AirDrop", "Resource Monitor", "Color Picker", "launcher")):
            return "Apps"
        return "System" if "Shutdown" in desc or "launcher" in desc.lower() else "Apps"
    return "Window"


def parse_file(path: Path) -> list[dict]:
    raw = path.read_text()
    vars_ = collect_vars(raw)
    # strip comments line-wise, keep line structure for submap tracking
    lines = [strip_comment(ln) for ln in raw.splitlines()]
    code = "\n".join(lines)

    # submap block spans: (start_offset, end_offset, name). Block openers are
    # `hl.define_submap("Name", ...)` lines; closers are bare `end)` lines
    # (inner anonymous functions close as `end, {...})`, so they don't collide).
    spans: list[tuple[int, int, str]] = []
    stack: list[tuple[str, int]] = []
    offset = 0
    for ln in lines:
        stripped = ln.strip()
        m = re.search(r'hl\.define_submap\s*\(\s*"([^"]+)"', stripped)
        if m:
            stack.append((m.group(1), offset))
        elif stripped == "end)" and stack:
            name, start = stack.pop()
            spans.append((start, offset, name))
        offset += len(ln) + 1

    def submap_for(pos: int) -> str:
        best = ""
        best_start = -1
        for s, e, name in spans:
            if s <= pos <= e and s > best_start:
                best, best_start = name, s
        return best

    entries = []
    for m in re.finditer(r"hl\.bind\s*\(", code):
        start = m.end()
        depth, in_str, i = 1, False, start
        while i < len(code) and depth > 0:
            c = code[i]
            if c == '"' and code[i - 1] != "\\":
                in_str = not in_str
            elif not in_str:
                if c == "(":
                    depth += 1
                elif c == ")":
                    depth -= 1
            i += 1
        argstr = code[start : i - 1]
        key_expr, rest = split_first_arg(argstr)
        action, opts = split_action_opts(rest)
        if not key_expr or not action:
            continue
        key = resolve_key(key_expr, vars_)
        if key is None:
            continue  # workspace loop rows added manually below
        sub = submap_for(m.start())
        desc = extract_description(opts)
        if desc is None:
            desc = infer(action, key, path.name, vars_)
        display_key = f"[{sub}] {key}" if sub else key
        entries.append(
            {"key": display_key, "description": desc, "source": path.name,
             "category": categorize(key, desc, action, path.name, sub)}
        )
    return entries


def expand_workspace_loop() -> list[dict]:
    entries = []
    for i in range(1, 11):
        key = i % 10
        entries.append({"key": f"SUPER + {key}", "description": f"Focus workspace {i}",
                        "source": "keybindings.lua", "category": "Workspace"})
        entries.append({"key": f"SUPER + SHIFT + {key}", "description": f"Move window to workspace {i}",
                        "source": "keybindings.lua", "category": "Workspace"})
    return entries


def load_all() -> list[dict]:
    entries: list[dict] = []
    for name in FILES:
        p = HYPR_DIR / name
        if p.exists():
            entries.extend(parse_file(p))
    entries.extend(expand_workspace_loop())
    # de-duplicate exact (key, description) pairs, keep first; tag remaining
    # same-key rows with their source file so conflicting binds are visible
    seen, uniq = set(), []
    for e in entries:
        k = (e["key"], e["description"])
        if k not in seen:
            seen.add(k)
            uniq.append(e)
    from collections import Counter

    counts = Counter(e["key"] for e in uniq)
    for e in uniq:
        if counts[e["key"]] > 1:
            e["description"] = f'{e["description"]} ({e["source"]})'
    order = {c: i for i, c in enumerate(CATEGORY_ORDER)}
    uniq.sort(key=lambda e: (order.get(e["category"], 99), e["key"]))
    return uniq


def main() -> None:
    entries = load_all()
    if "--json" in sys.argv:
        print(json.dumps(entries, indent=2))
    elif "--tsv" in sys.argv:
        for e in entries:
            print(f'{e["key"]}\t{e["description"]}\t{e["source"]}\t{e["category"]}')
    else:
        width = max([len(e["key"]) for e in entries] + [10])
        for e in entries:
            print(f'{e["key"].ljust(width)}  |  {e["description"]}')


if __name__ == "__main__":
    main()

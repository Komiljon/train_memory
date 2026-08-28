#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""postToolUse: после записи .dart — короткий список analyzer issues в контекст.

Молчим, если чисто. Не комментируем MCP analyze_files: агент и так видит tool_output.
"""

from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _common import (  # noqa: E402
    analyzer_issue_lines,
    find_dart,
    is_dart_file,
    read_hook_input,
    run_cmd,
    tool_input_as_dict,
    write_hook_output,
)


def main() -> None:
    payload = read_hook_input()
    tool_name = str(payload.get("tool_name") or "")
    if tool_name not in {"Write", "StrReplace", "search_replace", "Edit"}:
        write_hook_output({})
        return

    tool_input = tool_input_as_dict(payload.get("tool_input"))
    path = str(tool_input.get("path") or tool_input.get("file_path") or "")
    if not is_dart_file(path):
        write_hook_output({})
        return

    dart = find_dart()
    if not dart:
        write_hook_output({})
        return

    result = run_cmd([dart, "analyze", path], timeout=25)
    text = (result.stdout or "") + (result.stderr or "")
    if result.returncode == 0 and "No issues found" in text:
        write_hook_output({})
        return

    issues = analyzer_issue_lines(text)
    if not issues:
        write_hook_output({})
        return
    write_hook_output({"additional_context": f"analyzer:\n{issues}"})


if __name__ == "__main__":
    main()

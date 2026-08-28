#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""stop: если dart analyze красный — один короткий followup (loop_limit=1).

Полный отчёт анализатора в followup стоит целый лишний ход модели — только issue-строки.
"""

from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _common import (  # noqa: E402
    analyzer_issue_lines,
    find_dart,
    project_root,
    read_hook_input,
    run_cmd,
    write_hook_output,
)


def main() -> None:
    payload = read_hook_input()
    if str(payload.get("status") or "") != "completed":
        write_hook_output({})
        return

    dart = find_dart()
    if not dart:
        write_hook_output({})
        return

    result = run_cmd([dart, "analyze"], cwd=project_root(), timeout=40)
    text = ((result.stdout or "") + (result.stderr or "")).strip()
    if result.returncode == 0 and "No issues found" in text:
        write_hook_output({})
        return
    if result.returncode in {124, 127}:
        write_hook_output({})
        return

    issues = analyzer_issue_lines(text)
    if not issues:
        write_hook_output({})
        return
    write_hook_output({"followup_message": f"Исправь analyzer и остановись:\n{issues}"})


if __name__ == "__main__":
    main()

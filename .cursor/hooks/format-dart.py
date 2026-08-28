#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""afterFileEdit / afterTabFileEdit: UTF-8 без BOM + dart format.

BOM не уходит в контекст агента — только side-effect на диск.
"""

from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _common import (  # noqa: E402
    find_dart,
    is_dart_file,
    read_hook_input,
    run_cmd,
    strip_utf8_bom,
    write_hook_output,
)


def main() -> None:
    payload = read_hook_input()
    path = payload.get("file_path") or ""
    if path:
        strip_utf8_bom(path)

    if not is_dart_file(path):
        write_hook_output({})
        return

    dart = find_dart()
    if not dart:
        print("[hooks] dart format skipped: dart not found", file=sys.stderr)
        write_hook_output({})
        return

    result = run_cmd([dart, "format", "--line-length", "80", path], timeout=20)
    if result.returncode != 0:
        print(
            f"[hooks] dart format failed ({result.returncode}): {result.stderr}",
            file=sys.stderr,
        )
    write_hook_output({})


if __name__ == "__main__":
    main()

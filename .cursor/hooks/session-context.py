#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sessionStart: только env для хуков. Текст роли — в alwaysApply-правиле, не сюда.

additional_context на старте дублирует rules и жрёт токены каждой сессии.
"""

from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _common import find_dart, read_hook_input, write_hook_output  # noqa: E402


def main() -> None:
    read_hook_input()
    env: dict[str, str] = {"PYTHONDONTWRITEBYTECODE": "1"}
    dart = find_dart()
    if dart:
        dart_dir = os.path.dirname(dart)
        path = os.environ.get("PATH", "")
        if dart_dir not in path.split(os.pathsep):
            env["PATH"] = dart_dir + os.pathsep + path
        env["FLUTTER_SDK"] = os.path.dirname(dart_dir)
    write_hook_output({"env": env})


if __name__ == "__main__":
    main()

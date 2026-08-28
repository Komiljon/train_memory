#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""beforeMCPExecution: блок create_project; dart_fix — с подтверждения пользователя."""

from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _common import read_hook_input, write_hook_output  # noqa: E402


def main() -> None:
    payload = read_hook_input()
    tool_name = str(payload.get("tool_name") or "").lower()
    server = str(payload.get("mcp_server_name") or "").lower()

    if "create_project" in tool_name:
        write_hook_output(
            {
                "permission": "deny",
                "user_message": "MCP create_project отключён для train_memory.",
                "agent_message": "create_project выключен. Править текущий train_memory.",
            }
        )
        return

    is_dart_fix = tool_name == "dart_fix" or tool_name.endswith("dart_fix")
    if is_dart_fix and server in {"", "dart"}:
        write_hook_output(
            {
                "permission": "ask",
                "user_message": "dart_fix = dart fix --apply на весь корень. Подтверди.",
                "agent_message": "dart_fix массовый. Точечный фикс лучше руками.",
            }
        )
        return

    write_hook_output({"permission": "allow"})


if __name__ == "__main__":
    main()

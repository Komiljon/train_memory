#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""beforeShellExecution: политика CLI для Flutter-репозитория.

Не блокируем обычный `flutter test` / `flutter run` — часть MCP-tools
(format, tests, launch_app) по умолчанию выключена. Блокируем только то,
что ломает проект или обходит отключённый create_project.
"""

from __future__ import annotations

import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _common import project_root, read_hook_input, write_hook_output  # noqa: E402

# Команды создания нового приложения — в этом репо запрещены явно.
_CREATE = re.compile(
    r"\b(flutter\s+create|dart\s+create)\b",
    re.IGNORECASE,
)

# rm -rf / rm -fr … остаток командной строки разбираем как цели.
_RM_RF = re.compile(
    r"\brm\s+(-[a-zA-Z]*r[a-zA-Z]*f|[a-zA-Z]*f[a-zA-Z]*r)\b(?P<args>.*)$",
    re.IGNORECASE,
)

_FORCE_PUSH = re.compile(r"\bgit\s+push\b.*(--force|-f)\b", re.IGNORECASE)

# Одинарные и двойные кавычки shell/JSON — их содержимое не считается командой.
_QUOTED = re.compile(r"'[^']*'|\"[^\"]*\"")

# Каталоги исходников, которые нельзя сносить целиком через rm -rf.
_SOURCE_ROOTS = {"lib", "android", "ios", "test", "assets"}


def _command_without_quotes(command: str) -> str:
    """Убирает '...' и "...", чтобы echo/JSON не считались реальным вызовом.

    beforeShellExecution видит весь текст агентской команды, включая пайпы
    вроде echo '{"command":"flutter create"}' | python3.
    """
    return _QUOTED.sub(" ", command)


def _is_protected_rm_target(token: str) -> bool:
    """True, если цель rm лежит в исходниках приложения или в правилах Cursor.

    Разрешаем чистить кэш (.cursor/hooks/__pycache__, build/, .dart_tool/).
    Запрещаем rm -rf lib|android|ios|test|assets и rm -rf .cursor / .cursor/rules.
    """
    if token.startswith("-"):
        return False
    root = os.path.abspath(project_root())
    candidate = token if os.path.isabs(token) else os.path.join(root, token)
    candidate = os.path.abspath(candidate)
    try:
        rel = os.path.relpath(candidate, root)
    except ValueError:
        return False
    if rel.startswith(".."):
        return False
    parts = rel.replace("\\", "/").split("/")
    first = parts[0]
    if first in _SOURCE_ROOTS:
        return True
    if first == ".cursor":
        # Снос всего .cursor или rules/конфигов — нет. Кэш хуков — да.
        if len(parts) == 1:
            return True
        if parts[1] in {"rules", "mcp.json", "hooks.json"}:
            return True
        return False
    return False


def _is_destructive_rm(visible: str) -> bool:
    match = _RM_RF.search(visible)
    if not match:
        return False
    args = match.group("args") or ""
    for token in args.split():
        if _is_protected_rm_target(token):
            return True
    return False


def main() -> None:
    payload = read_hook_input()
    command = str(payload.get("command") or "")
    # Политику применяем к «голой» команде, не к строковым литералам внутри неё.
    visible = _command_without_quotes(command)

    if _CREATE.search(visible):
        write_hook_output(
            {
                "permission": "deny",
                "user_message": "Создание нового проекта запрещено: train_memory уже существует.",
                "agent_message": "Не создавай новый проект. Править текущий train_memory.",
            }
        )
        return

    if _is_destructive_rm(visible):
        write_hook_output(
            {
                "permission": "deny",
                "user_message": "Хук заблокировал рекурсивное удаление исходников.",
                "agent_message": "Не rm -rf исходники. Удаляй файлы инструментом Delete.",
            }
        )
        return

    if _FORCE_PUSH.search(visible):
        write_hook_output(
            {
                "permission": "deny",
                "user_message": "git push --force заблокирован хуком.",
                "agent_message": "Force-push запрещён.",
            }
        )
        return

    # Без agent_message на allow: те же подсказки уже в alwaysApply-правиле.
    write_hook_output({"permission": "allow"})


if __name__ == "__main__":
    main()

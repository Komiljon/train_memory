#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""beforeReadFile: не скармливаем модели keystore, подписи и секреты.

Агенту не нужны приватные ключи, чтобы писать Flutter-код. Если файл нужен
человеку — он откроет его сам вне агента.
"""

from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _common import read_hook_input, write_hook_output  # noqa: E402

# Сравниваем по нижнему регистру; путь нормализуем в posix-виде.
_BLOCKED_SUFFIXES = (
    ".jks",
    ".keystore",
    ".p8",
    ".p12",
    ".mobileprovision",
)
_BLOCKED_NAMES = {
    "key.properties",
    "keystore.properties",
    "secrets.properties",
    ".env",
    ".env.local",
    "credentials.json",
    "google-services.json",  # содержит ключи Firebase; не тащим в модель
    "googleservice-info.plist",
}


def _is_secret(path: str) -> bool:
    norm = path.replace("\\", "/").lower()
    name = os.path.basename(norm)
    if name in _BLOCKED_NAMES:
        return True
    return any(norm.endswith(suf) for suf in _BLOCKED_SUFFIXES)


def main() -> None:
    payload = read_hook_input()
    path = str(payload.get("file_path") or "")
    if path and _is_secret(path):
        write_hook_output(
            {
                "permission": "deny",
                "user_message": f"Чтение секрета заблокировано хуком: {os.path.basename(path)}",
            }
        )
        return
    write_hook_output({"permission": "allow"})


if __name__ == "__main__":
    main()

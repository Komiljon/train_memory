#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Общие утилиты Cursor hooks для Flutter-проекта train_memory.

Хуки общаются с Cursor через JSON на stdin/stdout. Любой print() в stdout
ломает протокол — логи только в stderr. Скрипты должны завершаться с кодом 0
и печатать один JSON-объект, даже если делать нечего.
"""

from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys
from typing import Any


def read_hook_input() -> dict[str, Any]:
    """Читает JSON-пейлоад хука из stdin. Пустой ввод → пустой dict."""
    raw = sys.stdin.read()
    if not raw.strip():
        return {}
    try:
        data = json.loads(raw)
    except json.JSONDecodeError as exc:
        print(f"[hooks] невалидный JSON на stdin: {exc}", file=sys.stderr)
        return {}
    return data if isinstance(data, dict) else {}


def write_hook_output(payload: dict[str, Any]) -> None:
    """Печатает ответ хука. Cursor читает ровно один JSON со stdout."""
    sys.stdout.write(json.dumps(payload, ensure_ascii=False))
    sys.stdout.flush()


def project_root() -> str:
    """Корень репозитория: CURSOR_PROJECT_DIR, иначе cwd хука (project root)."""
    return os.environ.get("CURSOR_PROJECT_DIR") or os.getcwd()


def find_dart() -> str | None:
    """Ищет бинарь dart в PATH (обычно flutter/bin/dart)."""
    dart = shutil.which("dart")
    if dart:
        return dart
    # Запасной путь разработческой машины, если PATH хука урезан.
    fallback = "/Users/macbook/aka/Develop/flutter/bin/dart"
    return fallback if os.path.isfile(fallback) else None


def run_cmd(
    args: list[str],
    *,
    cwd: str | None = None,
    timeout: int = 30,
) -> subprocess.CompletedProcess[str]:
    """Запускает команду, не бросая исключение по timeout — хук fail-open."""
    try:
        return subprocess.run(
            args,
            cwd=cwd or project_root(),
            capture_output=True,
            text=True,
            timeout=timeout,
            check=False,
        )
    except FileNotFoundError:
        return subprocess.CompletedProcess(args, 127, "", "executable not found")
    except subprocess.TimeoutExpired:
        return subprocess.CompletedProcess(args, 124, "", "timeout")


def is_dart_file(path: str | None) -> bool:
    """True, если путь указывает на исходник Dart (не generated)."""
    if not path:
        return False
    lower = path.replace("\\", "/").lower()
    if not lower.endswith(".dart"):
        return False
    # Сгенерированные файлы не форматим и не «чиним» хуками.
    basename = os.path.basename(lower)
    if basename.endswith(".g.dart") or basename.endswith(".freezed.dart"):
        return False
    return True


# Текстовые исходники, которые агент может сохранить с UTF-8 BOM (Windows/IDE).
_TEXT_SUFFIXES = (
    ".dart",
    ".kt",
    ".kts",
    ".swift",
    ".xml",
    ".gradle",
    ".properties",
    ".yaml",
    ".yml",
    ".json",
    ".md",
    ".mdc",
    ".txt",
    ".plist",
    ".arb",
    ".csv",
    ".html",
    ".css",
    ".gitignore",
    ".py",
    ".sh",
)

_UTF8_BOM = b"\xef\xbb\xbf"


def strip_utf8_bom(path: str | None) -> bool:
    """Снимает UTF-8 BOM, если он есть. Бинарники не трогает. True — файл переписан."""
    if not path or not os.path.isfile(path):
        return False
    lower = path.replace("\\", "/").lower()
    if not any(lower.endswith(suf) for suf in _TEXT_SUFFIXES):
        return False
    try:
        with open(path, "rb") as fh:
            data = fh.read()
        if not data.startswith(_UTF8_BOM):
            return False
        with open(path, "wb") as fh:
            fh.write(data[len(_UTF8_BOM) :])
    except OSError as exc:
        print(f"[hooks] strip BOM failed: {exc}", file=sys.stderr)
        return False
    return True


def clip(text: str, limit: int = 900) -> str:
    """Короткий хвост для additional_context / followup — меньше токенов."""
    text = text.strip()
    if len(text) <= limit:
        return text
    return text[:limit].rstrip() + "\n…"


def analyzer_issue_lines(text: str, *, max_lines: int = 8) -> str:
    """Оставляет только строки issues, без шапки Analyzing… и итогов.

    Полный `dart analyze` легко съедает тысячи токенов; агенту нужны file:line и код.
    """
    issues: list[str] = []
    for raw in text.splitlines():
        line = raw.strip()
        if not line:
            continue
        low = line.lower()
        if low.startswith("analyzing ") or "issues found" in low or "issue found" in low:
            continue
        if any(
            mark in low
            for mark in ("error •", "warning •", "info •", "error -", "warning -", "info -")
        ) or low.startswith(("error", "warning", "info")):
            issues.append(line)
    if not issues:
        # Нестандартный формат — берём не-пустые строки без шапки, но коротко.
        issues = [
            ln.strip()
            for ln in text.splitlines()
            if ln.strip() and not ln.lower().startswith("analyzing ")
        ]
    return clip("\n".join(issues[:max_lines]))


def tool_input_as_dict(tool_input: Any) -> dict[str, Any]:
    """tool_input в postToolUse иногда строка JSON, иногда уже объект."""
    if isinstance(tool_input, dict):
        return tool_input
    if isinstance(tool_input, str) and tool_input.strip():
        try:
            parsed = json.loads(tool_input)
            return parsed if isinstance(parsed, dict) else {}
        except json.JSONDecodeError:
            return {}
    return {}

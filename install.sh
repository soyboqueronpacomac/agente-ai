#!/bin/bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/GLOBAL_AGENT.md"

if [ ! -f "$SOURCE_FILE" ]; then
  echo "Error: no se encontró $SOURCE_FILE" >&2
  exit 1
fi

TARGETS=(
  "$HOME/.claude/CLAUDE.md"
  "$HOME/.codex/AGENTS.md"
  "$HOME/.copilot/AGENTS.md"
)

for target in "${TARGETS[@]}"; do
  target_dir="$(dirname "$target")"
  mkdir -p "$target_dir"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$SOURCE_FILE" ]; then
    echo "OK (ya configurado): $target"
    continue
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup="$target.bak.$(date +%s)"
    mv "$target" "$backup"
    echo "Aviso: se encontró configuración previa, respaldada en $backup"
  fi

  if ln -sf "$SOURCE_FILE" "$target" 2>/dev/null; then
    echo "OK (symlink): $target -> $SOURCE_FILE"
  elif cp "$SOURCE_FILE" "$target" 2>/dev/null; then
    echo "OK (copia, no se pudo symlinkar): $target"
  else
    echo "Error: no se pudo instalar en $target" >&2
  fi
done

echo "Listo."

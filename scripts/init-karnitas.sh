#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCHETYPE="$(cd "$SCRIPT_DIR/../archetype" && pwd)"

mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"
NAME="$(basename "$TARGET")"

rsync -a --exclude='.git' "$ARCHETYPE/" "$TARGET/" 2>/dev/null || cp -r "$ARCHETYPE/." "$TARGET/"
touch "$TARGET/.agents/runtime/logs/.gitkeep"

if command -v sed &>/dev/null; then
  sed -i "s/nombre-del-proyecto/$NAME/g; s/{{PROJECT_NAME}}/$NAME/g" \
    "$TARGET/.agents/index.json" "$TARGET/README.md" 2>/dev/null || true
fi

echo "OK KARNITAS -> $TARGET"
echo "  1. .agents/core/constraints.md"
echo "  2. cp .agents/specs/_templates/spec-template.md .agents/specs/001-feature/spec.md"

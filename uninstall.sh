#!/usr/bin/env bash
# Uninstaller for Omarchy Enhanced Indicators (azterisk.indicators)
# Author: Azteriisk

set -euo pipefail

PLUGIN_ID="azterisk.indicators"
TARGET_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins/$PLUGIN_ID"
SHELL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/shell.json"

echo "Removing $PLUGIN_ID..."

if [[ -f "$SHELL_CONFIG" ]]; then
  python3 - << 'PYEOF'
import json
from pathlib import Path

shell_file = Path.home() / ".config" / "omarchy" / "shell.json"
try:
    with open(shell_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    bar_layout = data.get("bar", {}).get("layout", {})
    for section in ("left", "center", "right"):
        items = bar_layout.get(section, [])
        bar_layout[section] = [x for x in items if not (isinstance(x, dict) and x.get("id") == "azterisk.indicators")]

    with open(shell_file, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)
except Exception:
    pass
PYEOF
fi

if [[ -d "$TARGET_DIR" ]]; then
  rm -rf "$TARGET_DIR"
fi

if command -v omarchy >/dev/null 2>&1; then
  omarchy restart shell 2>/dev/null || true
fi

echo "Omarchy Enhanced Indicators uninstalled successfully."

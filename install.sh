#!/usr/bin/env bash
# Installer for Omarchy Enhanced Indicators (azterisk.indicators)
# Author: Azteriisk

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ID="azterisk.indicators"
PLUGINS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins"
TARGET_DIR="$PLUGINS_DIR/$PLUGIN_ID"
SHELL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/shell.json"

echo "✨ Installing Omarchy Enhanced Indicators ($PLUGIN_ID)..."

# 1. Ensure target directory exists
mkdir -p "$TARGET_DIR"

# 2. Copy files if running outside plugins dir
if [ "$SCRIPT_DIR" != "$TARGET_DIR" ]; then
  cp -a "$SCRIPT_DIR/manifest.json" \
        "$SCRIPT_DIR/Indicators.qml" \
        "$SCRIPT_DIR/indicators" \
        "$SCRIPT_DIR/install.sh" \
        "$SCRIPT_DIR/uninstall.sh" \
        "$SCRIPT_DIR/README.md" "$TARGET_DIR/"
fi

chmod +x "$TARGET_DIR/install.sh" "$TARGET_DIR/uninstall.sh"

# 3. Configure shell.json
if [[ -f "$SHELL_CONFIG" ]]; then
  echo "  ⚙ Configuring shell.json for azterisk.indicators..."
  python3 - << 'PYEOF'
import json
from pathlib import Path

shell_file = Path.home() / ".config" / "omarchy" / "shell.json"
try:
    with open(shell_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    bar_layout = data.get("bar", {}).get("layout", {})
    center_items = bar_layout.get("center", [])
    if not any(isinstance(i, dict) and i.get("id") == "azterisk.indicators" for i in center_items):
        center_items.insert(0, {"id": "azterisk.indicators"})
        bar_layout["center"] = center_items

    with open(shell_file, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)
    print("     [OK] shell.json updated successfully")
except Exception as err:
    print(f"     [WARN] Could not update shell.json: {err}")
PYEOF
fi

# 4. Reload shell
if command -v omarchy >/dev/null 2>&1; then
  echo "  ✓ Reloading Omarchy shell..."
  omarchy restart shell 2>/dev/null || true
elif command -v omarchy-shell >/dev/null 2>&1; then
  omarchy-shell shell rescanPlugins 2>/dev/null || true
fi

echo "Omarchy Enhanced Indicators installed successfully."

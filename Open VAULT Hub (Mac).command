#!/bin/bash
# Double-click to open the VAULT hub with 3D preview and "Show in folder".
cd "$(dirname "$0")" || exit 1
if ! command -v python3 >/dev/null 2>&1; then
  echo "Python 3 is needed. macOS will offer to install it (Command Line Tools) - accept, then double-click this file again."
  xcode-select --install 2>/dev/null
  read -r -p "Press Return to close."
  exit 1
fi
exec python3 "_hub/serve_hub.py"

@echo off
rem Double-click to open the VAULT hub with 3D preview and "Show in folder".
cd /d "%~dp0"
title VAULT Hub
py -3 -c "import sys" >nul 2>&1
if %errorlevel%==0 (
  py -3 "_hub\serve_hub.py"
  goto :end
)
python -c "import sys" >nul 2>&1
if %errorlevel%==0 (
  python "_hub\serve_hub.py"
  goto :end
)
echo Python not found - using the built-in PowerShell server instead.
powershell -NoProfile -ExecutionPolicy Bypass -File "_hub\serve_hub.ps1"
:end

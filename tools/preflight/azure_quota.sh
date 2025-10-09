#!/usr/bin/env bash
set -euo pipefail
echo "Checking Azure subscription and provider state..."
az account show >/dev/null
az vm list-usage --location eastus >/dev/null
echo "Azure quota probe OK"

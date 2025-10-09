#!/usr/bin/env bash
if [ "$DEV_ONLY_BANNER" = "1" ]; then
  echo "⚠️ DEV-ONLY: This stack is bound to 127.0.0.1 and resource-capped. Do NOT expose publicly."
fi
exec "$@"

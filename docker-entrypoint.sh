#!/bin/sh
set -e

CONFIG_FILE="${ALL2API_CONFIG_PATH:-${ALL2API_CONFIG:-/app/config/config.yaml}}"
CONFIG_EXAMPLE="/app/config.yaml.example"

# Render provides PORT. Keep 8848 as the local/Docker Compose fallback.
export ALL2API_ADDR="${ALL2API_ADDR:-0.0.0.0:${PORT:-8848}}"

if [ ! -f "$CONFIG_FILE" ]; then
  # An explicitly configured Secret File must exist; do not silently use defaults.
  if [ "$CONFIG_FILE" != "/app/config/config.yaml" ]; then
    echo >&2 "[all2api] required config file not found: $CONFIG_FILE"
    exit 1
  fi

  echo "[all2api] config.yaml not found, copying from config.yaml.example..."
  mkdir -p "$(dirname "$CONFIG_FILE")"
  cp "$CONFIG_EXAMPLE" "$CONFIG_FILE"
  echo "[all2api] config.yaml created at $CONFIG_FILE"
fi

exec /app/all2api -config "$CONFIG_FILE"

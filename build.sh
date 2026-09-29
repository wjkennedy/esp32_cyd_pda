#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

# Keep PlatformIO's toolchains and packages independent of a possibly stale
# or non-writable user-level installation. Override this when a shared cache
# is preferred.
export PLATFORMIO_CORE_DIR="${PLATFORMIO_CORE_DIR:-$ROOT_DIR/.pio-home}"

ENV_NAME="${PIO_ENV:-esp32-cyd-024}"
ACTION="${1:-build}"

pio_args=(run -e "$ENV_NAME")
if [[ -n "${PORT:-}" ]]; then
    pio_args+=(--upload-port "$PORT" --monitor-port "$PORT")
fi

case "$ACTION" in
    build|compile)
        pio "${pio_args[@]}"
        ;;
    flash|upload)
        pio "${pio_args[@]}" -t upload
        ;;
    monitor)
        pio "${pio_args[@]}" -t monitor
        ;;
    clean)
        pio "${pio_args[@]}" -t clean
        ;;
    all)
        pio "${pio_args[@]}"
        pio "${pio_args[@]}" -t upload
        ;;
    *)
        echo "Usage: $0 [build|flash|monitor|clean|all]" >&2
        exit 2
        ;;
esac

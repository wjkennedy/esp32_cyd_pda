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
    web|webflash)
        # Produce the files consumed by esp-web-tools. Include FFat so a
        # first-time install does not boot into an unformatted storage prompt.
        pio "${pio_args[@]}"
        pio "${pio_args[@]}" -t buildfs
        WEB_DIR="$ROOT_DIR/Compiled version"
        mkdir -p "$WEB_DIR"
        cp ".pio/build/$ENV_NAME/bootloader.bin" "$WEB_DIR/ESP32CYD.ino.bootloader.bin"
        cp ".pio/build/$ENV_NAME/partitions.bin" "$WEB_DIR/ESP32CYD.ino.partitions.bin"
        cp ".pio/build/$ENV_NAME/firmware.bin" "$WEB_DIR/ESP32CYD.ino.bin"
        cp ".pio/build/$ENV_NAME/fatfs.bin" "$WEB_DIR/ESP32CYD.ino.fatfs.bin"
        cp "$PLATFORMIO_CORE_DIR/packages/framework-arduinoespressif32/tools/partitions/boot_app0.bin" "$WEB_DIR/boot_app0.bin"
        ;;
    *)
        echo "Usage: $0 [build|flash|monitor|clean|all|web]" >&2
        exit 2
        ;;
esac

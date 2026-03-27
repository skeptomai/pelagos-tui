#!/usr/bin/env bash
#
# Build pelagos-tui in release mode and install to /usr/local/bin.
#
# Usage:  ./scripts/install.sh [INSTALL_DIR]
#
# If run as a normal user, builds with your toolchain and uses sudo
# only to copy the binary. If run as root (e.g. in CI), skips sudo.
#
set -euo pipefail

INSTALL_DIR="${1:-/usr/local/bin}"

do_install() {
    local dst="$1"
    install -m 755 target/release/pelagos-tui "${dst}/pelagos-tui"
}

if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
    echo "Building pelagos-tui (release) as ${SUDO_USER}..."
    sudo -u "$SUDO_USER" cargo build --release
    echo "Installing to ${INSTALL_DIR}..."
    do_install "${INSTALL_DIR}"
elif [ "$(id -u)" -eq 0 ]; then
    echo "Building pelagos-tui (release)..."
    cargo build --release
    echo "Installing to ${INSTALL_DIR}..."
    do_install "${INSTALL_DIR}"
else
    echo "Building pelagos-tui (release)..."
    cargo build --release
    echo "Installing to ${INSTALL_DIR} (may prompt for sudo)..."
    sudo bash -c "$(declare -f do_install); do_install '${INSTALL_DIR}'"
fi

echo "Done. $(pelagos-tui --version 2>/dev/null || echo 'pelagos-tui installed')"

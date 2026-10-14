#!/usr/bin/env bash
set -e

DESTDIR="${DESTDIR:-/usr/local}"
BIN_DIR="${DESTDIR}/bin"

if [ "$(id -u)" -ne 0 ]; then
  echo "==> root privileges required to install to ${BIN_DIR}."
  echo "==> Re-running with sudo..."
  exec sudo "$0" "$@"
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing ea-fix to ${BIN_DIR}/ea-fix..."
mkdir -p "${BIN_DIR}"
cp "${DIR}/bin/ea-fix" "${BIN_DIR}/ea-fix"
chmod 755 "${BIN_DIR}/ea-fix"

echo ""
echo "=========================================================="
echo " ea-fix installed successfully to ${BIN_DIR}/ea-fix!"
echo "=========================================================="
echo "You can now run:"
echo "  ea-fix status               Check detected EA games & prefixes"
echo "  ea-fix fix                  Fix stuck EA app updates"
echo "  ea-fix install --stop-steam Auto-configure Steam launch options"
echo "  ea-fix uninstall            Remove Steam launch options"
echo "=========================================================="

#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="1.0.0"
PKG_NAME="ea-fix"
BUILD_DIR="${DIR}/build/${PKG_NAME}_${VERSION}_all"
DIST_DIR="${DIR}/dist"

echo "==> Building Debian package for ${PKG_NAME} v${VERSION}..."

rm -rf "${DIR}/build"
mkdir -p "${BUILD_DIR}/DEBIAN"
mkdir -p "${BUILD_DIR}/usr/bin"
mkdir -p "${BUILD_DIR}/usr/share/doc/${PKG_NAME}"
mkdir -p "${DIST_DIR}"

# 1. Install executable
cp "${DIR}/bin/ea-fix" "${BUILD_DIR}/usr/bin/ea-fix"
chmod 755 "${BUILD_DIR}/usr/bin/ea-fix"

# 2. Install documentation & license
cp "${DIR}/README.md" "${BUILD_DIR}/usr/share/doc/${PKG_NAME}/" 2>/dev/null || true
cp "${DIR}/LICENSE" "${BUILD_DIR}/usr/share/doc/${PKG_NAME}/copyright" 2>/dev/null || true

# 3. Control file
cat <<EOC > "${BUILD_DIR}/DEBIAN/control"
Package: ${PKG_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: all
Maintainer: Deniz Şengöz <dnzsngz1@users.noreply.github.com>
Depends: python3 (>= 3.6), procps
Recommends: steam-installer | steam
Homepage: https://github.com/dnzsngz1/ea-fix
Description: Proton EA App auto-repair and launch utility for Steam on Linux
 ea-fix fixes two major issues with EA games running via Steam Proton:
  1. EA App update loop: EA App downloads mandatory updates but fails to
     execute EADestager.exe under Wine, causing an immediate crash loop
     without any error code.
  2. "Verifying rights" hang: EA App can hang indefinitely while checking
     game ownership/license after a previous session.
 ea-fix detects EA Proton prefixes, applies pending updates via EADestager,
 and provides a robust self-healing launch wrapper for Steam.
EOC

# 4. Postinst script
cat <<'EOP' > "${BUILD_DIR}/DEBIAN/postinst"
#!/bin/sh
set -e
echo "---------------------------------------------------------"
echo " ea-fix v1.0.0 installed successfully!"
echo ""
echo " Quick usage:"
echo "   ea-fix status               Check detected EA games & prefixes"
echo "   ea-fix fix                  Apply stuck EA updates immediately"
echo "   ea-fix install --stop-steam Auto-configure Steam launch options"
echo "   ea-fix uninstall            Remove Steam launch wrapper"
echo "---------------------------------------------------------"
exit 0
EOP
chmod 755 "${BUILD_DIR}/DEBIAN/postinst"

# 5. Build package
dpkg-deb --build --root-owner-group "${BUILD_DIR}" "${DIST_DIR}/${PKG_NAME}_${VERSION}_all.deb"

echo "==> Package created: ${DIST_DIR}/${PKG_NAME}_${VERSION}_all.deb"

# Maintainer: Azteriisk <https://github.com/Azteriisk>
pkgname=omarchy-indicators-git
pkgver=1.0.0
pkgrel=1
pkgdesc="Enhanced Status Indicators bar widget for Omarchy Desktop Shell with Stay Awake & Idle integration"
arch=('any')
url="https://github.com/Azteriisk/omarchy-indicators"
license=('MIT')
depends=('quickshell' 'omarchy')
makedepends=('git')
provides=('omarchy-indicators')
conflicts=('omarchy-indicators')
_commit="25290b579eb5107140e6e0858c7a0063b656dbb0"
source=("${pkgname}::git+https://github.com/Azteriisk/omarchy-indicators.git#commit=${_commit}")
sha256sums=('SKIP')

pkgver() {
  cd "$srcdir/${pkgname}"
  if tag=$(git describe --long --tags --abbrev=7 2>/dev/null); then
    echo "$tag" | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g'
  else
    printf "1.0.0.r%s.%s\n" "$(git rev-list --count HEAD)" "$(git rev-parse --short=7 HEAD)"
  fi
}

package() {
  cd "$srcdir/${pkgname}"
  install -dm755 "$pkgdir/usr/share/omarchy/plugins/azterisk.indicators"
  cp -a manifest.json Indicators.qml indicators README.md "$pkgdir/usr/share/omarchy/plugins/azterisk.indicators/"
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}

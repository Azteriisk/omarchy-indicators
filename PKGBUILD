# Maintainer: Azteriisk
pkgname=omarchy-indicators-git
pkgver=1.0.0
pkgrel=1
pkgdesc="Enhanced Status Indicators bar widget for Omarchy Desktop Shell with Stay Awake & Idle integration"
arch=('any')
url="https://github.com/Azteriisk/omarchy-indicators"
license=('MIT')
depends=('quickshell' 'omarchy')
makedepends=('git')
source=("git+https://github.com/Azteriisk/omarchy-indicators.git")
sha256sums=('SKIP')

package() {
  cd "$srcdir/omarchy-indicators"
  install -dm755 "$pkgdir/usr/share/omarchy/plugins/azterisk.indicators"
  cp -a manifest.json Indicators.qml indicators README.md "$pkgdir/usr/share/omarchy/plugins/azterisk.indicators/"
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}

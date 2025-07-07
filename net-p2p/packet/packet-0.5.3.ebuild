# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85.0"

inherit cargo meson gnome2-utils xdg

DESCRIPTION="Quick Share client for Linux"
HOMEPAGE="https://github.com/nozwock/packet"
SRC_URI="https://github.com/nozwock/packet/releases/download/${PV}/${P}.tar.xz"
S=${WORKDIR}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/glib-2.82
	dev-libs/gobject-introspection
	>=gui-libs/gtk-4.15.3
	>=gui-libs/libadwaita-1.6
	"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/blueprint-compiler"

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

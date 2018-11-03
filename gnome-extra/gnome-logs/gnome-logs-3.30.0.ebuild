# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org gnome2-utils meson xdg virtualx

DESCRIPTION="Log messages and event viewer"
HOMEPAGE="https://wiki.gnome.org/Apps/Logs"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-libs/glib-2.43.90:2
	gnome-base/gsettings-desktop-schemas
	sys-apps/systemd:=
	>=x11-libs/gtk+-3.22.0:3
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	virtual/pkgconfig
	test? ( dev-util/desktop-file-utils )
"

src_configure() {
	local emesonargs=(
		-Dman=true 
		$(meson_use test tests)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
	gnome2_schemas_update
}

src_test() {
	virtx meson_src_test
}

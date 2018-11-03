# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="The Gnome System Monitor"
HOMEPAGE="https://help.gnome.org/users/gnome-system-monitor/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="systemd X"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/glib-2.56.0:2
	>=gnome-base/libgtop-2.37.0:2=
	>=x11-libs/gtk+-3.22.0:3[X(+)]
	>=dev-cpp/gtkmm-3.3.18:3.0
	>=dev-cpp/glibmm-2.46:2
	>=dev-libs/libxml2-2.0:2
	>=gnome-base/librsvg-2.35:2
	systemd? ( >=sys-apps/systemd-44:0= )
	X? ( >=x11-libs/libwnck-2.91.0:3 )
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use X wnck)
		$(meson_use systemd)
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

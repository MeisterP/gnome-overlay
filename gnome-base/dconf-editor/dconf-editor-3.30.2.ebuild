# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION="0.40"

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Graphical tool for editing the dconf configuration database"
HOMEPAGE="https://git.gnome.org/browse/dconf-editor"

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS=""

COMMON_DEPEND="
	dev-libs/appstream-glib
	>=dev-libs/glib-2.46.0:2
	>=gnome-base/dconf-0.25.1
	>=x11-libs/gtk+-3.22.27:3
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/dconf-0.22[X]
"

src_prepare() {
	default
	vala_src_prepare
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_pkg_postrm
	gnome2_schemas_update
}

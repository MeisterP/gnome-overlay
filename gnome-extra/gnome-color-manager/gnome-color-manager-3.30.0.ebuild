# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome.org gnome2-utils meson virtualx xdg

DESCRIPTION="Color profile manager for the GNOME desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-color-manager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="packagekit raw test"

RDEPEND="
	>=dev-libs/glib-2.25.9:2
	>=media-libs/lcms-2.2:2
	>=media-libs/libcanberra-0.10[gtk3]
	media-libs/libexif
	media-libs/tiff:0=

	>=x11-libs/gtk+-2.91.0:3
	>=x11-libs/vte-0.25.1:2.91
	>=x11-misc/colord-1.3.1:0=
	>=x11-libs/colord-gtk-0.1.20

	packagekit? ( app-admin/packagekit-base )
	raw? ( media-gfx/exiv2:0= )
"
# docbook-sgml-{utils,dtd:4.1} needed to generate man pages
DEPEND="${RDEPEND}
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	virtual/pkgconfig
"

src_configure() {
	# Always enable tests since they are check_PROGRAMS anyway
	local emesonargs=(
		$(meson_use raw exiv)
		$(meson_use packagekit)
		-Dtests=true
	)
	meson_src_configure

}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update

	if ! has_version media-gfx/argyllcms ; then
		elog "If you want to do display or scanner calibration, you will need to"
		elog "install media-gfx/argyllcms"
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}

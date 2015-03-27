# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="5"
GCONF_DEBUG="no" # --enable-debug only changes CFLAGS
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_{6,7} )
VALA_MIN_API_VERSION="0.17"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="GSound is a small library for playing system sounds"
HOMEPAGE="https://wiki.gnome.org/Projects/GSound"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"

IUSE="+introspection vala"

RDEPEND="
	>=dev-libs/glib-2.34:2
	media-libs/libcanberra
	>=dev-libs/gobject-introspection-1.2.9
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"
src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable vala)
}

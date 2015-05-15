# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="5"
GCONF_DEBUG="yes"

inherit gnome2

DESCRIPTION="A simple utility application to find and insert unusual characters"
HOMEPAGE="https://wiki.gnome.org/Design/Apps/CharacterMap"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ppc64 ~sh ~sparc x86 ~x86-fbsd"

COMMON_DEPEND="
	>=dev-libs/glib-2.32:2
	x11-libs/gdk-pixbuf
	x11-libs/pango
	>=dev-libs/gjs-1.43.3
	>=x11-libs/gtk+-3.4.0:3
	>=dev-libs/gobject-introspection-1.35.9
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	>=dev-libs/libunistring-0.9.2
	virtual/pkgconfig
"

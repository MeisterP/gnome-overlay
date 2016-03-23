# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

SLOT="0"
DESCRIPTION="Small library intended for internal use by GNOME Games"
HOMEPAGE="https://wiki.gnome.org/Apps/Games"

LICENSE="GPL-2+"

KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"

DEPEND="
	>=x11-libs/gtk+-3.19.2:3
	>=dev-libs/glib-2.40:2
	>=dev-libs/libgee-0.8
"

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	DOCS="COPYING NEWS README"
	gnome2_src_configure --disable-static
}


# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/anjuta/anjuta-3.14.1.ebuild,v 1.3 2015/03/15 13:19:29 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_4 )

inherit gnome2 autotools flag-o-matic python-single-r1

DESCRIPTION="Builder - Develop software for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Builder"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86 ~x86-fbsd"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	>=dev-libs/glib-2.44:2
	>=x11-libs/gtksourceview-3.16:3.0
	>=x11-libs/gtk+-3.16:3
	>=dev-libs/libgit2-glib-0.22.6
	sys-devel/clang
	${PYTHON_DEPS}

	>=dev-util/devhelp-3.15.92
	>=dev-libs/gobject-introspection-1.0
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-libs/gobject-introspection-common
	gnome-base/gnome-common
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	sed -e 's:python3-config:python3.4-config:g' \
		-i build/autotools/autoconf.d/post-am.m4 || die "sed failed"
	eautoreconf
	gnome2_src_prepare
}

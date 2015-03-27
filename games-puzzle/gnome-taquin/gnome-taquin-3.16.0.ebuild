# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/gnome-sudoku/gnome-sudoku-3.14.2.ebuild,v 1.5 2015/03/15 13:21:15 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
VALA_MIN_API_VERSION="0.26"

inherit gnome-games vala

DESCRIPTION="Taquin is a sliding-block puzzle game"
HOMEPAGE="https://wiki.gnome.org/ThreePointFifteen/Features/Taquin"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.40:2
	>=x11-libs/gtk+-3.15.3:3[introspection]
	>=gnome-base/librsvg-2.32
	>=media-libs/libcanberra-0.26[gtk3]
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-util/appdata-tools
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
	$(vala_depend)
"

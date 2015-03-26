# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/atomix/atomix-2.14.0.ebuild,v 1.9 2013/12/07 21:39:56 tupone Exp $

EAPI=5
GCONF_DEBUG="no"
VALA_MIN_API_VERSION="0.24"

inherit gnome-games vala

DESCRIPTION="a game where you build full molecules, from simple inorganic to extremely complex organic ones"
HOMEPAGE="http://ftp.gnome.org/pub/GNOME/sources/atomix/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=x11-libs/pango-1.36
	>=x11-libs/gtk+-3.15:3
	>=dev-libs/glib-2.40:2
	>=dev-libs/libxml2-2.4.23
	dev-perl/XML-Parser"

DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig
	>=dev-util/intltool-0.17"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	gnome-games_src_prepare
	vala_src_prepare
}

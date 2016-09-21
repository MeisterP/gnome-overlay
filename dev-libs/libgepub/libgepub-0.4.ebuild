# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2

DESCRIPTION="GObject based library for handling and rendering epub documents."
HOMEPAGE="https://github.com/GNOME/libgepub"

LICENSE="GPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-libs/glib-2.40
	virtual/pkgconfig
	net-libs/libsoup
	net-libs/webkit-gtk:4
	dev-libs/libxml2
	app-arch/libarchive
"

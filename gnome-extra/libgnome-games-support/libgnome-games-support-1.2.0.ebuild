# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2

DESCRIPTION="small library intended for internal use by GNOME Games, but it may be used by others."
HOMEPAGE="https://github.com/GNOME/gnome-autoar"

LICENSE="GPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/libgee:0.8
	>=dev-libs/glib-2.40
	>=x11-libs/gtk+-3.19.2:3
	virtual/pkgconfig
"

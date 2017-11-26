# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit eutils gnome2 multilib python-r1 meson

DESCRIPTION="Companion library to GObject and GTK+"
HOMEPAGE="https://github.com/chergert/libdazzle"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="
	x11-libs/gtk+:3
	dev-libs/gobject-introspection
"
DEPEND="${RDEPEND}
"

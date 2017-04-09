# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="An easy-to-use application that will help you to discover what to cook today"
HOMEPAGE="https://wiki.gnome.org/Apps/Recipes"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+spell +archive +sound"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=sys-devel/gettext-0.19.7
	spell? ( app-text/gspell )
	archive? ( app-arch/gnome-autoar )
	sound? ( media-libs/libcanberra )
	>=dev-libs/glib-2.42
	>=x11-libs/gtk+-3.22
"

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable spell gspell) \
		$(use_enable archive autoar) \
		$(use_enable sound canberra)
}

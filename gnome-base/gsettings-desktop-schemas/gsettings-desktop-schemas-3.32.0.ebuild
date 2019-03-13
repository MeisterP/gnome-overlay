# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 meson

DESCRIPTION="Collection of GSettings schemas for GNOME desktop"
HOMEPAGE="https://git.gnome.org/browse/gsettings-desktop-schemas"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+introspection"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/glib-2.31:2
	introspection? ( >=dev-libs/gobject-introspection-1.31.0:= )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use introspection)
	)
	meson_src_configure
}

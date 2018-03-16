# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome-meson vala

DESCRIPTION="Companion library to GObject and Gtk+"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libdazzle"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.56.0:2
	>=dev-libs/gobject-introspection-1.56.0:="

DEPEND="${RDEPEND}
	$(vala_depend)
	${PYTHON_DEPS}
	virtual/pkgconfig"

src_prepare() {
	gnome-meson_src_prepare
	vala_src_prepare
}

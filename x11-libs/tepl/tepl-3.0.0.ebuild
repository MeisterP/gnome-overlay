# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 virtualx

DESCRIPTION="Text editor product line"
HOMEPAGE="https://wiki.gnome.org/Projects/Tepl"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection test"

RDEPEND="
	>=dev-libs/glib-2.52:2
	>=x11-libs/gtk+-3.20
	>=x11-libs/gtksourceview-3.22
	>=dev-libs/libxml2-2.5
	app-i18n/uchardet
	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
"
DEPEND="${DEPEND}
	test? ( dev-util/valgrind )
	>=sys-devel/gettext-0.19.4
	>=dev-util/gtk-doc-am-1.25
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--enable-gvfs-metadata \
		$(use_enable introspection) \
		$(use_enable test valgrind)
}

src_test() {
	virtx emake check
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="Utilities for creating and parsing messages using MIME"
HOMEPAGE="http://spruce.sourceforge.net/gmime/ https://developer.gnome.org/gmime/stable/"

SLOT="3.0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs test vala"

RDEPEND="
	>=dev-libs/glib-2.32.0:2
	sys-libs/zlib
	vala? (
		$(vala_depend)
		>=dev-libs/gobject-introspection-1.30.0:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.8
	virtual/libiconv
	virtual/pkgconfig
	doc? ( app-text/docbook-sgml-utils )
	test? ( app-crypt/gnupg )
"

src_prepare() {
	gnome2_src_prepare
	use vala && vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable static-libs static) \
		$(use_enable vala)
}

src_compile() {
	gnome2_src_compile
	if use doc; then
		emake -C docs/tutorial html
	fi
}

src_install() {
	GACUTIL_FLAGS="/root '${ED}/usr/$(get_libdir)' /gacdir '${EPREFIX}/usr/$(get_libdir)' /package ${PN}" \
		gnome2_src_install

	if use doc ; then
		docinto tutorial
		dodoc -r docs/tutorial/html/
	fi
}

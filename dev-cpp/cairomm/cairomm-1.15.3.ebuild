# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 flag-o-matic multilib-minimal

DESCRIPTION="C++ bindings for the Cairo vector graphics library"
HOMEPAGE="http://cairographics.org/cairomm"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="aqua doc +svg X"

RDEPEND="
	>=x11-libs/cairo-1.12.10[aqua=,svg=,X=,${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2.5.1:3[${MULTILIB_USEDEP}]
	dev-cpp/mm-common
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-libs/libxslt
		media-gfx/graphviz )
"

src_prepare() {
	NOCONFIGURE=1 ./autogen.sh
	gnome2_src_prepare
}

multilib_src_configure() {
	append-cxxflags -std=c++17

	ECONF_SOURCE="${S}" gnome2_src_configure \
		--disable-tests \
		--disable-static --with-pic \
		$(multilib_native_use_enable doc documentation)
}

multilib_src_install() {
	gnome2_src_install
}

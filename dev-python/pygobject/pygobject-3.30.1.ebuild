# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} pypy )

inherit eutils gnome-meson python-r1 virtualx

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="https://wiki.gnome.org/Projects/PyGObject"

LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="+cairo examples test"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.38:2
	>=dev-libs/gobject-introspection-1.46.0:=
	virtual/libffi:=
	cairo? (
		>=dev-python/pycairo-1.11.1[${PYTHON_USEDEP}]
		x11-libs/cairo )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	cairo? ( x11-libs/cairo[glib] )
"

RDEPEND="${COMMON_DEPEND}
	!<dev-python/pygtk-2.13
	!<dev-python/pygobject-2.28.6-r50:2[introspection]
"

src_configure() {
	configuring() {
		gnome-meson_src_configure \
			-Dpython=${EPYTHON} \
			$(meson_use cairo pycairo)
	}

	python_foreach_impl run_in_build_dir configuring
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome-meson_src_compile
}

src_install() {
	python_foreach_impl run_in_build_dir gnome-meson_src_install

	dodoc -r examples
}

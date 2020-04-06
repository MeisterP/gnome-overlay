# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson pax-utils virtualx

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Gjs"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
IUSE="+cairo examples gtk readline +sysprof test"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/glib-2.58.0
	>=dev-libs/gobject-introspection-1.61.2:=

	readline? ( sys-libs/readline:0= )
	dev-lang/spidermonkey:68
	dev-libs/libffi:=
	cairo? ( x11-libs/cairo[X] )
"
DEPEND="${RDEPEND}
	sysprof? ( >=dev-util/sysprof-capture-3.33.2:3 )
	virtual/pkgconfig
	test? ( sys-apps/dbus
		>=x11-libs/gtk+-3.20:3 )
"

RESTRICT="!test? ( test )"

src_configure() {
	# FIXME: add systemtap/dtrace support, like in glib:2
	local emesonargs=(
		-Ddtrace=false
		-Dsystemtap=false
		$(meson_feature cairo)
		$(meson_feature readline)
		$(meson_feature sysprof profiler)
		$(meson_use !test skip_dbus_tests)
		$(meson_use !test skip_gtk_tests)
		-Dinstalled_tests=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins "${S}"/examples/*
	fi

	# Required for gjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/gjs-console"
}

src_test() {
	virtx emake check
}

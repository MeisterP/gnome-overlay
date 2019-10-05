# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 pax-utils virtualx

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Gjs"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
IUSE="+cairo examples gtk readline test"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/glib-2.58.0
	>=dev-libs/gobject-introspection-1.57.2:=

	readline? ( sys-libs/readline:0= )
	dev-lang/spidermonkey:60
	virtual/libffi:=
	cairo? ( x11-libs/cairo[X] )
"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

RESTRICT="!test? ( test )"

src_configure() {
	# FIXME: add systemtap/dtrace support, like in glib:2
	# FIXME: --enable-systemtap installs files in ${D}/${D} for some reason
	# XXX: Do NOT enable coverage, completely useless for portage installs

	#error: --enable-profiler requires sysprof-capture-3.pc
	gnome2_src_configure \
		--disable-systemtap \
		--disable-dtrace \
		--disable-profiler \
		--disable-code-coverage \
		$(use_with cairo cairo) \
		$(use_enable readline) \
		$(use_with test dbus-tests) \
		--disable-installed-tests \
		--without-gtk-tests
}

src_install() {
	# installation sometimes fails in parallel, bug #???
	gnome2_src_install -j1

	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins "${S}"/examples/*
	fi

	# Required for gjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/gjs-console"
}

src_test() {
	virtx dbus-run-session emake check || die
}

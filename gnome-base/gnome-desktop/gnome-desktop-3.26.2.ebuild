# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"

inherit gnome2 virtualx

DESCRIPTION="Libraries for the gnome desktop that are not part of the UI"
HOMEPAGE="https://git.gnome.org/browse/gnome-desktop"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="3/12" # subslot = libgnome-desktop-3 soname version
IUSE="debug +introspection udev"
KEYWORDS="~amd64 ~x86"

# cairo[X] needed for gnome-bg
COMMON_DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.53.0:2[dbus]
	sys-libs/libseccomp
	>=x11-libs/gdk-pixbuf-2.36.5:2[introspection?]
	>=x11-libs/gtk+-3.3.6:3[X,introspection?]
	x11-libs/cairo:=[X]
	x11-libs/libX11
	x11-misc/xkeyboard-config
	>=gnome-base/gsettings-desktop-schemas-3.5.91
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
	udev? (
		sys-apps/hwids
		virtual/libudev:= )
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-desktop-2.32.1-r1:2[doc]
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.40.6
	dev-util/itstool
	sys-devel/gettext
	x11-proto/xproto
	virtual/pkgconfig
"

# Includes X11/Xatom.h in libgnome-desktop/gnome-bg.c which comes from xproto

PATCHES=( "${FILESDIR}/disable-bubblewrap.patch")

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--with-gnome-distributor=Gentoo \
		--enable-desktop-docs \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable debug debug-tools) \
		$(use_enable introspection) \
		$(use_enable udev)
}

src_test() {
	virtx emake check
}

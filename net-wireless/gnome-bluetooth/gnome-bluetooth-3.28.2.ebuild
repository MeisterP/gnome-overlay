# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome-meson udev user

DESCRIPTION="Bluetooth graphical utilities integrated with GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeBluetooth"

LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1+"
SLOT="2/13" # subslot = libgnome-bluetooth soname version
IUSE="debug +introspection"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.38:2
	media-libs/libcanberra[gtk3]
	>=x11-libs/gtk+-3.12:3[introspection?]
	x11-libs/libnotify
	virtual/udev
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
"
RDEPEND="${COMMON_DEPEND}
	>=net-wireless/bluez-5
"
DEPEND="${COMMON_DEPEND}
	!net-wireless/bluez-gnome
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gtk-doc
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.40.0
	dev-util/itstool
	virtual/libudev
	virtual/pkgconfig
	x11-base/xorg-proto
"

pkg_setup() {
	enewgroup plugdev
}

src_configure() {
	gnome-meson_src_configure \
		-Dgtk_doc=true \
		-Dicon_update=false \
		$(meson_use introspection)
}

src_install() {
	gnome-meson_src_install
	udev_dorules "${FILESDIR}"/61-${PN}.rules
}
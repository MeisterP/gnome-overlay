# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome.org meson virtualx

DESCRIPTION="Library with common API for various GNOME modules"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-desktop/"
#SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${P}-patchset.tar.xz"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="3/17" # subslot = libgnome-desktop-3 soname version
IUSE="debug gtk-doc +introspection seccomp udev"
KEYWORDS="~amd64 ~x86"

# cairo[X] needed for gnome-bg
COMMON_DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.53.0:2
	>=x11-libs/gdk-pixbuf-2.36.5:2[introspection?]
	>=x11-libs/gtk+-3.3.6:3[X,introspection?]
	x11-libs/cairo:=[X]
	x11-libs/libX11
	x11-misc/xkeyboard-config
	>=gnome-base/gsettings-desktop-schemas-3.27.0
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
	seccomp? ( sys-libs/libseccomp )
	udev? (
		sys-apps/hwids
		virtual/libudev:= )
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-desktop-2.32.1-r1:2[doc]
	seccomp? ( sys-apps/bubblewrap )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gdbus-codegen
	gtk-doc? ( >=dev-util/gtk-doc-1.15 )
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	x11-base/xorg-proto
	virtual/pkgconfig
	media-libs/fontconfig
" 
# Includes X11/Xatom.h in libgnome-desktop/gnome-bg.c which comes from xorg-proto

meson_feature() {
	usex "$1" "-D${2-$1}=enabled" "-D${2-$1}=disabled"
}

src_configure() {
	local emesonargs=(
		-Dgnome_distributor=Gentoo
		-Ddate_in_gnome_version=false
		-Ddesktop_docs=true
		$(meson_use gtk-doc gtk_doc)
		$(meson_use debug debug_tools)
		$(meson_feature udev)
		-Dinstalled_tests=false
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

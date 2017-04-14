# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="A nice way to view information about use of system resources, like memory and disk space."
HOMEPAGE="https://wiki.gnome.org/Apps/Usage"

SRC_URI="https://git.gnome.org/browse/gnome-usage/snapshot/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
IUSE="+caps"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-lang/vala
	dev-libs/glib
	x11-libs/gtk+:3
	>=dev-util/meson-0.36
	>=gnome-base/libgtop-2.34.2
	>=net-libs/netinfo-ffi-0.3.1
	caps? ( sys-libs/libcap )
"

src_prepare() {
	rm -rf build
	default
}

src_configure() {
	meson --prefix=/usr build
}

src_compile() {
	ninja -v -C build
}

src_install() {
	export DESTDIR=${D}
	ninja -v -C build install
	if use caps; then
		setcap "cap_net_raw,cap_net_admin=eip" ${ED}/usr/bin/gnome-usage
	fi
	gnome2_src_install
}

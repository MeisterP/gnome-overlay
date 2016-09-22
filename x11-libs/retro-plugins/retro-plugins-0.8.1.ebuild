# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2

DESCRIPTION="Toolkit to write Gtk+ 3 based libretro frontends"
HOMEPAGE="https://git.gnome.org/browse/retro-gtk/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	=x11-libs/retro-gtk-${PV}
	dev-vcs/git
	virtual/pkgconfig
"

src_prepare() {
	eapply ${FILESDIR}/${P}-fix-build.patch
	cd ${S}/plugins/game-boy && git clone https://github.com/libretro/gambatte-libretro.git;
	#cd gambatte-libretro git checkout 24551644bee25534c12ccb6ddebd1e4266d727fe;

	cd ${S}/plugins/nes && git clone https://github.com/libretro/nestopia.git;
	cd ${S}/plugins/pc-engine && git clone https://github.com/libretro/beetle-pce-fast-libretro.git;
	cd ${S}/plugins/snes && git clone https://github.com/libretro/bsnes-libretro.git;
	cd ${S}/plugins/mame && git clone https://github.com/libretro/mame.git;
	cd ${S}/plugins/neo-geo-pocket && git clone https://github.com/libretro/beetle-ngp-libretro.git;
	cd ${S}/plugins/atari-2600 && git clone https://github.com/libretro/stella-libretro.git;
	cd ${S}/plugins/atari-7800 && git clone https://github.com/libretro/prosystem-libretro.git;
	cd ${S}/plugins/playstation && git clone https://github.com/libretro/pcsx_rearmed.git;
	cd ${S} && ./autogen.sh;
	default
}

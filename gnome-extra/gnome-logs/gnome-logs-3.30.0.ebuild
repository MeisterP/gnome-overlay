# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome-meson

DESCRIPTION="Log messages and event viewer"
HOMEPAGE="https://wiki.gnome.org/Apps/Logs"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-libs/glib-2.43.90:2
	gnome-base/gsettings-desktop-schemas
	sys-apps/systemd:=
	>=x11-libs/gtk+-3.22.0:3
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	virtual/pkgconfig
	test? ( dev-util/desktop-file-utils )
"

src_configure() {
	gnome-meson_src_configure \
		-Dman=true \
		$(meson_use test tests)
}

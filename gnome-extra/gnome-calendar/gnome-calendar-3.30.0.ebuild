# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome-meson

DESCRIPTION="Manage your online calendars with simple and modern interface"
HOMEPAGE="https://wiki.gnome.org/Apps/Calendar"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64" #libdazzle is only ~amd64
IUSE=""

RDEPEND="
	>=app-misc/geoclue-2.4.0:2.0
	>=dev-libs/glib-2.43.4:2
	>=x11-libs/gtk+-3.21.6:3
	>=gnome-extra/evolution-data-server-3.17.1:=
	>=dev-libs/libical-1.0.1:0=
	>=dev-libs/libgweather-3.27.2
	net-libs/libsoup:2.4
	>=net-libs/gnome-online-accounts-3.2.0:=
	>=gnome-base/gsettings-desktop-schemas-3.21.2
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.40.6
	>=dev-libs/libdazzle-3.28.0
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	gnome-meson_src_configure \
		-Ddocumentation=true \
		-Dtracing=false
}
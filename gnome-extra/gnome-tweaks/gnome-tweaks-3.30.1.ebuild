# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_{4,5,6} )

inherit gnome.org gnome2-utils meson python-r1 xdg

DESCRIPTION="Tool to customize GNOME 3 options"
HOMEPAGE="https://wiki.gnome.org/Apps/Tweaks"

LICENSE="GPL-2+"
SLOT="0"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	${PYTHON_DEPS}
	dev-libs/glib:2[dbus]
	>=dev-python/pygobject-3.10.2:3[${PYTHON_USEDEP}]
	>=gnome-base/gsettings-desktop-schemas-3.23.3
"
# g-s-d, gnome-desktop, gnome-shell etc. needed at runtime for the gsettings schemas
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-desktop-3.6.0.1:3=[introspection]
	>=x11-libs/gtk+-3.12:3[introspection]

	net-libs/libsoup:2.4[introspection]
	x11-libs/libnotify[introspection]

	>=gnome-base/gnome-settings-daemon-3
	>=gnome-base/gnome-shell-3.24
	>=gnome-base/nautilus-3
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
"

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_pkg_postrm
}

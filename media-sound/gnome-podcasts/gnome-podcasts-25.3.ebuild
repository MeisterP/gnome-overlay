# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo meson gnome2-utils xdg

RUST_MIN_VER="1.85.0"
ECARGO_VENDOR="${WORKDIR}/gnome-podcasts-${PV}/vendor"

DESCRIPTION="Podcast app for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Podcasts https://gitlab.gnome.org/World/podcasts"
SRC_URI="https://gitlab.gnome.org/World/podcasts/-/releases/${PV}/downloads/gnome-podcasts-${PV}.tar.xz"

LICENSE+="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD GPL-3+ ISC MIT MPL-2.0 UoI-NCSA Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-db/sqlite-3.20
	>=dev-libs/glib-2.82
	dev-libs/gobject-introspection
	>=dev-libs/openssl-1.0
	>=gui-libs/gtk-4.15.3
	>=gui-libs/libadwaita-1.8
	>=media-plugins/gst-plugins-meta-1.20[http]
	>=media-libs/gstreamer-1.22
	sys-apps/dbus
	>=x11-libs/gdk-pixbuf-2.0
	"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/25.3-unset-CARGO_HOME.patch" )

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

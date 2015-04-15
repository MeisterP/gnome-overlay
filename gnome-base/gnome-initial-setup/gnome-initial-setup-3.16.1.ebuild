# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-desktop/gnome-desktop-3.14.2.ebuild,v 1.3 2015/03/15 13:22:37 pacho Exp $

EAPI="5"
GCONF_DEBUG="yes"

inherit gnome2 virtualx

DESCRIPTION="GNOME initial setup"
HOMEPAGE="https://live.gnome.org/GnomeOS/Design/Whiteboards/InitialSetup"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="0"
IUSE="+networkmanager"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~x86-solaris"

# cairo[X] needed for gnome-bg
COMMON_DEPEND="
	networkmanager? (
		>=net-misc/networkmanager-0.9.6.4
	)
	>=dev-libs/glib-2.38:2
	>=x11-libs/gtk+-3.11.3:3
	>=dev-libs/gobject-introspection-0.9.7
	>=x11-libs/pango-1.32.5
	>=app-i18n/ibus-1.4.99
	>=gnome-base/gnome-desktop-3.7.5
	>=sys-auth/polkit-0.103
	>=gnome-base/gdm-3.8.3
	>=app-misc/geoclue-2.1.2
	sys-apps/accountsservice
	media-libs/fontconfig
	dev-libs/libgweather
	net-libs/gnome-online-accounts
	net-libs/rest:0.7
	dev-libs/json-glib
	app-crypt/libsecret
	dev-libs/libpwquality
	net-libs/webkit-gtk:4
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-desktop-2.32.1-r1:2[doc]
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-am-1.4
	>=dev-util/intltool-0.40.6
	sys-devel/gettext
	x11-proto/xproto
	>=x11-proto/randrproto-1.2
	virtual/pkgconfig
"

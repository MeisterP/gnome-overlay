# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/totem-pl-parser/totem-pl-parser-3.4.5.ebuild,v 1.2 2013/08/30 22:43:01 eva Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Playlist parsing library"
HOMEPAGE="http://projects.gnome.org/totem/ http://developer.gnome.org/totem-pl-parser/stable/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="archive crypt +introspection +quvi test"

RDEPEND="
	>=dev-libs/glib-2.31:2
	dev-libs/gmime:2.6
	>=net-libs/libsoup-2.43.0:2.4
	archive? ( >=app-arch/libarchive-2.8.4 )
	crypt? ( dev-libs/libgcrypt )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	quvi? ( >=media-libs/libquvi-0.9.1 )
"
DEPEND="${RDEPEND}
	!<media-video/totem-2.21
	dev-libs/gobject-introspection-common
	>=dev-util/intltool-0.35
	dev-util/gtk-doc-am
	>=gnome-base/gnome-common-3.6
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	test? (
		gnome-base/gvfs[http]
		sys-apps/dbus )
"
# eautoreconf needs:
#	dev-libs/gobject-introspection-common
#	>=gnome-base/gnome-common-3.6

src_prepare() {
	# Disable tests requiring network access, bug #346127
	sed -e 's:\(g_test_add_func.*/parser/resolution.*\):/*\1*/:' \
		-e 's:\(g_test_add_func.*/parser/parsing/itms_link.*\):/*\1*/:' \
		-i plparse/tests/parser.c || die "sed failed"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable archive libarchive) \
		$(use_enable crypt libgcrypt) \
		$(use_enable quvi) \
		$(use_enable introspection)
}

src_test() {
	# This is required as told by upstream in bgo#629542
	GVFS_DISABLE_FUSE=1 dbus-launch emake check || die "emake check failed"
}

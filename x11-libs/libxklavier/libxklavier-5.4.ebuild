# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxklavier/libxklavier-5.3.ebuild,v 1.2 2015/03/03 11:45:53 dlan Exp $

EAPI=5
inherit eutils libtool git-r3 autotools

DESCRIPTION="A library for the X Keyboard Extension (high-level API)"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/LibXklavier"

EGIT_REPO_URI="git://anongit.freedesktop.org/libxklavier"
EGIT_COMMIT="396955bd2ba2db34a42b3807b03155fcc11dfe50"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc +introspection"

RDEPEND="app-text/iso-codes
	>=dev-libs/glib-2.16
	dev-libs/libxml2
	x11-apps/xkbcomp
	x11-libs/libX11
	>=x11-libs/libXi-1.1.3
	x11-libs/libxkbfile
	>=x11-misc/xkeyboard-config-2.4.1-r3
	introspection? ( >=dev-libs/gobject-introspection-1.30 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	doc? ( >=dev-util/gtk-doc-1.4 )"

DOCS="AUTHORS ChangeLog CREDITS NEWS README"

src_prepare() {
	elibtoolize
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable doc gtk-doc) \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--with-xkb-base="${EPREFIX}"/usr/share/X11/xkb \
		--with-xkb-bin-base="${EPREFIX}"/usr/bin
}

src_install() {
	default

	nonfatal dosym /usr/share/doc/${PF}/html/${PN} /usr/share/gtk-doc/html/${PN}

	prune_libtool_files
}

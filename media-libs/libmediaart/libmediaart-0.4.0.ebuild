# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgee/libgee-0.12.1.ebuild,v 1.3 2014/03/09 11:55:23 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Library tasked with managing, extracting and handling media art caches"
HOMEPAGE="https://github.com/GNOME/libmediaart"

LICENSE="LGPL-2.1+"
SLOT="0.3"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-linux"

src_configure() {
	DOCS="AUTHORS NEWS README"
	gnome2_src_configure
}

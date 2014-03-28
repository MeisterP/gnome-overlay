# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gnome-disk-utility/gnome-disk-utility-3.8.2.ebuild,v 1.6 2013/09/28 09:46:17 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2

DESCRIPTION="GNOME Logs is a log viewer for the systemd journal"
HOMEPAGE="https://wiki.gnome.org/Apps/Logs"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"

DEPEND="
	>=x11-libs/gtk+-3.10.0:3
"

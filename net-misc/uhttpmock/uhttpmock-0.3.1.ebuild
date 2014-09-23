# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VALA_MIN_API_VERSION="0.26"
VALA_USE_DEPEND="vapigen"

inherit autotools vala

DESCRIPTION="uhttpmock is a project for mocking web service APIs which use HTTP or HTTP"
HOMEPAGE="https://gitorious.org/uhttpmock"
SRC_URI="https://tecnocode.co.uk/downloads/uhttpmock/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vala" # static

DEPEND="
	>=net-libs/libsoup-2.37.91
	>=dev-libs/glib-2.31:2
	"

src_prepare() {
	epatch_user
	use vala && epatch "${FILESDIR}/vapigen_fix_path.patch"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable vala)
}

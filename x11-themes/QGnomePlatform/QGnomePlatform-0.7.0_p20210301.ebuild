# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

MY_COMMIT=0636d3740f21b70543dd0eb323c37d9dfd130711

DESCRIPTION="A Qt Platform Theme aimed to accommodate GNOME settings"
HOMEPAGE="https://github.com/FedoraQt/QGnomePlatform"
SRC_URI="https://github.com/FedoraQt/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtdbus:5=
	>=dev-qt/qtwidgets-5.12:5=
	dev-qt/qtwayland:5=
	dev-qt/qtx11extras:5=
	x11-libs/gtk+:3[X]
	>=x11-themes/adwaita-qt-1.2.0_p20210228
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="Qt decoration plugin implementing Adwaita-like client-side decorations "
HOMEPAGE="https://github.com/FedoraQt/QAdwaitaDecorations"
SRC_URI="https://github.com/FedoraQt/QAdwaitaDecorations/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-qt/qtbase:6=[gui,wayland,widgets]
	dev-qt/qtdeclarative:6=
	dev-qt/qtwayland:6=
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT6=ON
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	#newenvd - 99qadwaitadecorations <<-EOF
	#	QT_WAYLAND_DECORATION=adwaita
	#EOF
}

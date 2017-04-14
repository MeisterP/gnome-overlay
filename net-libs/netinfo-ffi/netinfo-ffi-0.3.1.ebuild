# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="This is the C foreign function interface, so that you can call netinfo from C"
HOMEPAGE="https://github.com/kaegi/netinfo-ffi"
#SRC_URI="https://github.com/kaegi/netinfo-ffi/archive/v${PV}.tar.gz -> ${P}.tar.gz"
COMMIT="fb9a9092c8aa512d77092048a642c6c37ac3f09a"
SRC_URI="https://github.com/kaegi/netinfo-ffi/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${COMMIT}

src_compile() {
	cargo build --release --verbose || die
}

src_install() {
	doheader ${S}/src/netinfo.h
	dolib.a ${S}/target/release/libnetinfo.a
	dolib.so ${S}/target/release/libnetinfo.so
}

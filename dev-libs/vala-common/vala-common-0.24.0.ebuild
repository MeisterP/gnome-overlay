# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/vala-common/vala-common-0.22.1.ebuild,v 1.6 2014/02/22 21:21:16 pacho Exp $

EAPI="5"
GNOME_ORG_MODULE="vala"

inherit gnome.org

DESCRIPTION="Build infrastructure for packages that use Vala"
HOMEPAGE="https://wiki.gnome.org/Vala"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~arm-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE=""

DEPEND=""

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /usr/share/aclocal
	doins vala.m4 vapigen/vapigen.m4
	insinto /usr/share/vala
	doins vapigen/Makefile.vapigen
}

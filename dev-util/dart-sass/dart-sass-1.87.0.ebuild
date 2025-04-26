# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The reference implementation of Sass, written in Dart."
HOMEPAGE="https://sass-lang.com/dart-sass/"

SRC_URI="https://github.com/sass/dart-sass/releases/download/${PV}/${P}-linux-x64.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="*"

RDEPEND="!dev-ruby/sass"

src_install() {
	newbin - sass <<-EOF
		#!/bin/sh

		# This script drives the standalone dart-sass package, which bundles together a
		# Dart executable and a snapshot of dart-sass.

		exec "/opt/dart-sass/dart" "/opt/dart-sass/sass.snapshot" "\$@"
	EOF

	exeinto "/opt/dart-sass"
	doexe src/dart
	doexe src/sass.snapshot
}

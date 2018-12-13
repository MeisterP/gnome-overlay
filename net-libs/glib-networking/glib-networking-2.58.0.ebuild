# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome.org gnome2-utils meson multilib-minimal virtualx

DESCRIPTION="Network-related giomodules for glib"
HOMEPAGE="https://git.gnome.org/browse/glib-networking/"

LICENSE="LGPL-2+"
SLOT="0"
IUSE="+gnome +libproxy smartcard test +ssl"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/glib-2.56.0:2[${MULTILIB_USEDEP}]
	app-misc/ca-certificates
	>=net-libs/gnutls-3:=[${MULTILIB_USEDEP}]
	gnome? ( gnome-base/gsettings-desktop-schemas )
	libproxy? ( >=net-libs/libproxy-0.4.11-r1:=[${MULTILIB_USEDEP}] )
	smartcard? (
		>=app-crypt/p11-kit-0.18.4[${MULTILIB_USEDEP}]
		>=net-libs/gnutls-3:=[pkcs11,${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.19.4
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	test? ( sys-apps/dbus[X] )
"

src_prepare() {
	default
	# Disable SSLv3 requiring fallback test, which fails with net-libs/gnutls[-sslv3], bug 595952
	# https://bugzilla.gnome.org/show_bug.cgi?id=782853
	sed -i -e '/\/tls\/connection\/fallback\/SSL/d' "${S}"/tls/tests/connection.c || die
}

multilib_src_configure() {
	local emesonargs=(
		-Dstatic_modules=false \
		$(meson_use gnome gnome_proxy_support)
		$(meson_use libproxy libproxy_support)
		$(meson_use smartcard pkcs11_support)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	# XXX: non-native tests fail if glib-networking is already installed.
	# have no idea what's wrong. would appreciate some help.
	multilib_is_native_abi || return 0

	virtx meson_src_test
}

multilib_src_install() {
	meson_src_install
}

pkg_postinst() {
	multilib_pkg_postinst() {
		gnome2_giomodule_cache_update \
			|| die "Update GIO modules cache failed (for ${ABI})"
	}
	multilib_foreach_abi multilib_pkg_postinst
}

pkg_postrm() {
	multilib_pkg_postrm() {
		gnome2_giomodule_cache_update \
			|| die "Update GIO modules cache failed (for ${ABI})"
	}
	multilib_foreach_abi multilib_pkg_postrm
}

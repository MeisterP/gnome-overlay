# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome-meson vala

DESCRIPTION="A GNOME application for managing encryption keys"
HOMEPAGE="https://wiki.gnome.org/Apps/Seahorse"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
IUSE="debug ldap zeroconf"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-crypt/gcr-3.11.91:=
	>=dev-libs/glib-2.10:2
	>=x11-libs/gtk+-3.22:3
	>=app-crypt/libsecret-0.16[vala]
	>=net-libs/libsoup-2.33.92:2.4
	x11-misc/shared-mime-info

	net-misc/openssh
	>=app-crypt/gpgme-1
	>=app-crypt/gnupg-2.0.12

	ldap? ( net-nds/openldap:= )
	zeroconf? ( >=net-dns/avahi-0.6:= )
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-util/gdbus-codegen
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	gnome-meson_src_prepare
	vala_src_prepare
}

src_configure() {
	gnome-meson_src_configure \
		-Dhelp=true \
		-Dpgp-support=true \
		-Dcheck-compatible-gpg=true \
		-Dpkcs11-support=true \
		-Dkeyservers-support=true \
		-Dhkp-support=true \
		$(meson_use ldap ldap-support) \
		$(meson_use zeroconf key-sharing)
}

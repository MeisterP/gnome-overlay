# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org gnome2-utils meson systemd

DESCRIPTION="Virtual filesystem implementation for gio"
HOMEPAGE="https://wiki.gnome.org/Projects/gvfs"

LICENSE="LGPL-2+"
SLOT="0"

IUSE="afp archive bluray cdda +ftp fuse google gnome-keyring gnome-online-accounts gphoto2 +http ios mtp nfs policykit samba systemd test +udev udisks zeroconf"
REQUIRED_USE="
	cdda? ( udev )
	google? ( gnome-online-accounts )
	mtp? ( udev )
	udisks? ( udev )
	systemd? ( udisks )
"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-crypt/gcr:=
	>=dev-libs/glib-2.57.2:2
	dev-libs/libxml2:2
	afp? ( >=dev-libs/libgcrypt-1.2.2:0= )
	archive? ( app-arch/libarchive:= )
	bluray? ( media-libs/libbluray:= )
	ftp? ( net-misc/openssh )
	fuse? ( >=sys-fs/fuse-2.8.0:0 )
	gnome-keyring? ( app-crypt/libsecret )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.7.1:= )
	google? (
		>=dev-libs/libgdata-0.17.9:=[crypt,gnome-online-accounts]
		>=net-libs/gnome-online-accounts-3.17.1:= )
	gphoto2? ( >=media-libs/libgphoto2-2.5.0:= )
	http? ( >=net-libs/libsoup-2.42:2.4 )
	ios? (
		>=app-pda/libimobiledevice-1.2:=
		>=app-pda/libplist-1:= )
	mtp? (
		>=dev-libs/libusb-1.0.21
		>=media-libs/libmtp-1.1.12 )
	nfs? ( >=net-fs/libnfs-1.9.8 )
	policykit? (
		>=sys-auth/polkit-0.114
		sys-libs/libcap )
	samba? ( >=net-fs/samba-4[client] )
	systemd? ( >=sys-apps/systemd-206:0= )
	udev? (
		cdda? ( dev-libs/libcdio-paranoia )
		>=virtual/libgudev-147:=
		virtual/libudev:= )
	udisks? ( >=sys-fs/udisks-1.97:2 )
	zeroconf? ( >=net-dns/avahi-0.6 )
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/gtk-doc-am
	test? (
		>=dev-python/twisted-16
		|| (
			net-analyzer/netcat
			net-analyzer/netcat6 ) )
	!udev? ( >=dev-libs/libgcrypt-1.2.2:0 )
"
# test dependencies needed per https://bugzilla.gnome.org/700162

# Tests with multiple failures, this is being handled upstream at:
# https://bugzilla.gnome.org/700162
RESTRICT="test"

src_configure() {
	local emesonargs=(
		-Dgcr=true
		-Ddevel_utils=false
		-Dinstalled_tests=false
		-Dman=true
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
		$(meson_use policykit admin)
		$(meson_use afp)
		$(meson_use afp gcrypt)
		$(meson_use ios afc)
		$(meson_use archive)
		$(meson_use cdda)
		$(meson_use zeroconf dnssd)
		$(meson_use gnome-online-accounts goa)
		$(meson_use google)
		$(meson_use gphoto2)
		$(meson_use http)
		$(meson_use mtp)
		$(meson_use mtp libusb)
		$(meson_use nfs)
		$(meson_use ftp sftp)
		$(meson_use samba smb)
		$(meson_use udisks udisks2)
		$(meson_use bluray)
		$(meson_use fuse)
		$(meson_use udev gudev)
		$(meson_use gnome-keyring keyring)
		$(meson_use systemd logind)
	)
	meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_giomodule_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_giomodule_cache_update
}

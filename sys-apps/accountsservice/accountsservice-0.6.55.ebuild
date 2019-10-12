# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson systemd

DESCRIPTION="D-Bus interfaces for querying and manipulating user account information"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/AccountsService/"
SRC_URI="https://www.freedesktop.org/software/${PN}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="gtk-doc elogind +introspection selinux systemd"
REQUIRED_USE="^^ ( elogind systemd )"

CDEPEND="
	>=dev-libs/glib-2.44:2
	sys-auth/polkit
	elogind? ( >=sys-auth/elogind-229.4 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	systemd? ( >=sys-apps/systemd-186:0= )
"
DEPEND="${CDEPEND}
	dev-libs/libxslt
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.15
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	gtk-doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto )
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-accountsd )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.55-gentoo-system-users.patch
)

src_configure() {
	local emesonargs=(
		--localstatedir="${EPREFIX}"/var
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Dadmin_group="wheel"
		$(meson_use systemd)
		$(meson_use elogind)
		$(meson_use introspection)
		$(meson_use gtk-doc docbook)
		$(meson_use gtk-doc gtk_doc)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	keepdir /var/lib/AccountsService/icons
	keepdir /var/lib/AccountsService/users
}

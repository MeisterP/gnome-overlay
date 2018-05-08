# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome-meson readme.gentoo-r1

DESCRIPTION="A file manager for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Nautilus"

LICENSE="GPL-3"
SLOT="0"
IUSE="extensions gnome +introspection packagekit +previewer selinux"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	>=app-arch/gnome-autoar-0.2.1
	>=dev-libs/glib-2.55.1:2[dbus]
	>=x11-libs/pango-1.28.3
	>=x11-libs/gtk+-3.22.26:3[introspection?]
	>=dev-libs/libxml2-2.7.8:2
	>=gnome-base/gnome-desktop-3:3=

	gnome-base/dconf
	>=gnome-base/gsettings-desktop-schemas-3.8.0
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender

	>=app-misc/tracker-1:=
	extensions? ( >=media-libs/gexiv2-0.10.0 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
	selinux? ( >=sys-libs/libselinux-2 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=dev-util/gdbus-codegen-2.33
	>=dev-util/gtk-doc-1.10
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	x11-proto/xproto
"
RDEPEND="${COMMON_DEPEND}
	packagekit? ( app-admin/packagekit-base )
	extensions? ( !<gnome-extra/nautilus-sendto-3.0.1 )
"

PDEPEND="
	gnome? ( x11-themes/adwaita-icon-theme )
	previewer? ( >=gnome-extra/sushi-0.1.9 )
	extensions? ( >=gnome-extra/nautilus-sendto-3.0.1 )
	>=gnome-base/gvfs-1.14[gtk]
"

src_prepare() {
	if use previewer; then
		DOC_CONTENTS="nautilus uses gnome-extra/sushi to preview media files.
			To activate the previewer, select a file and press space; to
			close the previewer, press space again."
	fi
	gnome-meson_src_prepare
}

src_configure() {
	gnome-meson_src_configure \
		-Ddocs=true \
		-Dprofiling=false \
		-Ddisplay-tests=false \
		$(meson_use extensions) \
		$(meson_use packagekit) \
		$(meson_use selinux)
}

src_install() {
	use previewer && readme.gentoo_create_doc
	gnome-meson_src_install
}

pkg_postinst() {
	gnome-meson_pkg_postinst

	if use previewer; then
		readme.gentoo_print_elog
	else
		elog "To preview media files, emerge nautilus with USE=previewer"
	fi
}
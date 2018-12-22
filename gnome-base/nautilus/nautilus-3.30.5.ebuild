# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes" # Needed with USE 'sendto'

inherit gnome.org gnome2-utils meson readme.gentoo-r1 virtualx xdg

DESCRIPTION="A file manager for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Nautilus"

LICENSE="GPL-2+ LGPL-2+ FDL-1.1"
SLOT="0"
IUSE="exif gnome gtk-doc +introspection packagekit +previewer selinux extensions xmp"

KEYWORDS="~amd64 ~x86"

# FIXME: tests fails under Xvfb, but pass when building manually
# "FAIL: check failed in nautilus-file.c, line 8307"
# need org.gnome.SessionManager service (aka gnome-session) but cannot find it
RESTRICT="test"

# Require {glib,gdbus-codegen}-2.30.0 due to GDBus API changes between 2.29.92
# and 2.30.0
COMMON_DEPEND="
	>=app-arch/gnome-autoar-0.2.1
	>=dev-libs/glib-2.55.1:2[dbus]
	>=x11-libs/pango-1.28.3
	>=x11-libs/gtk+-3.22.27:3[introspection?]
	>=dev-libs/libxml2-2.7.8:2
	sys-libs/libseccomp

	>=gnome-base/gsettings-desktop-schemas-3.8.0
	x11-libs/libX11

	exif? ( >=media-libs/libexif-0.6.20 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
	selinux? ( >=sys-libs/libselinux-2 )
	>=app-misc/tracker-2:=
	app-misc/tracker-miners
	xmp? ( >=media-libs/exempi-2.1.0:2 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gdbus-codegen-2.33
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	x11-base/xorg-proto

	gtk-doc? ( dev-util/gtk-doc )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	packagekit? ( app-admin/packagekit-base )
	extensions? ( !<gnome-extra/nautilus-sendto-3.0.1 )
"
PDEPEND="
	gnome? ( x11-themes/adwaita-icon-theme )
	previewer? ( >=gnome-extra/sushi-0.1.9 )
	extensions? ( >=gnome-extra/nautilus-sendto-3.0.1 )
	>=gnome-base/gvfs-1.34
"

PATCHES=(
	# https://gitlab.gnome.org/GNOME/nautilus/issues/398
	"${FILESDIR}"/3.30.0-show-thumbnails.patch

	# https://gitlab.gnome.org/GNOME/gnome-desktop/issues/81
	"${FILESDIR}"/3.30.2-fix-bubblewrap.patch
)

src_prepare() {
	if use previewer; then
		DOC_CONTENTS="nautilus uses gnome-extra/sushi to preview media files.
			To activate the previewer, select a file and press space; to
			close the previewer, press space again."
	fi
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dprofiling=false
		-Dtests=none
		$(meson_use gtk-doc docs)
		$(meson_use extensions)
		$(meson_use introspection)
		$(meson_use packagekit)
		$(meson_use selinux)

	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

src_install() {
	use previewer && readme.gentoo_create_doc
	meson_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
	gnome2_schemas_update

	if use previewer; then
		readme.gentoo_print_elog
	else
		elog "To preview media files, emerge nautilus with USE=previewer"
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
	gnome2_schemas_update
}

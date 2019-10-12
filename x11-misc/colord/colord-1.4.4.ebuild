# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit bash-completion-r1 check-reqs meson user systemd udev vala

DESCRIPTION="System service to accurately color manage input and output devices"
HOMEPAGE="https://www.freedesktop.org/software/colord/"
SRC_URI="https://www.freedesktop.org/software/colord/releases/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0/2" # subslot = libcolord soname version
KEYWORDS="~amd64 ~x86"

IUSE="gtk-doc argyllcms examples extra-print-profiles +introspection scanner systemd +udev vala"
REQUIRED_USE="
	scanner? ( udev )
	vala? ( introspection )
"

COMMON_DEPEND="
	dev-db/sqlite:3=
	>=dev-libs/glib-2.44.0:2
	>=media-libs/lcms-2.6:2=
	argyllcms? ( media-gfx/argyllcms )
	introspection? ( >=dev-libs/gobject-introspection-0.9.8:= )
	>=sys-auth/polkit-0.104
	scanner? (
		media-gfx/sane-backends
		sys-apps/dbus )
	systemd? ( >=sys-apps/systemd-44:0= )
	udev? (
		virtual/udev
		virtual/libgudev:=
		virtual/libudev:=
	)
"
RDEPEND="${COMMON_DEPEND}
	!media-gfx/shared-color-profiles
	!<=media-gfx/colorhug-client-0.1.13
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	extra-print-profiles? ( media-gfx/argyllcms )
	vala? ( $(vala_depend) )
"

# FIXME: needs pre-installed dbus service files
RESTRICT="test"

# According to upstream comment in colord.spec.in, building the extra print
# profiles requires >=4G of memory
CHECKREQS_MEMORY="4G"

pkg_pretend() {
	use extra-print-profiles && check-reqs_pkg_pretend
}

pkg_setup() {
	use extra-print-profiles && check-reqs_pkg_setup
	enewgroup colord
	enewuser colord -1 -1 /var/lib/colord colord
}

src_prepare() {
	default
	use vala && vala_src_prepare

	# Adapt to Gentoo paths
	sed -i -e "s|find_program('spotread', required : false)|find_program('argyll-spotread', required : false)|" \
		meson.build || die

	# meson gnome.generate_vapi properly handles VAPIGEN and other vala
	# environment variables. It is counter-productive to check for an
	# unversioned vapigen, as that breaks versioned VAPIGEN usages.
	sed -i -e "s|find_program('vapigen')|find_program('true')|" \
		meson.build || die
}

src_configure() {
	local emesonargs=(
		--localstatedir="${EPREFIX}"/var
		$(meson_use argyllcms argyllcms_sensor)
		$(meson_use examples session_example)
		$(meson_use extra-print-profiles print_profiles)
		$(meson_use gtk-doc docs)
		$(meson_use scanner sane)
		$(meson_use systemd)
		$(meson_use udev udev_rules)
		$(meson_use vala vapi)
		-Dbash_completion=false
		-Ddaemon=true
		-Ddaemon_user=colord
		-Dinstalled_tests=false
		-Dlibcolordcompat=true
		-Dman=false #todo
		-Dreverse=false
		-Dtests=false
	)

	meson_src_configure
}


src_install() {
	meson_src_install

	newbashcomp data/colormgr colormgr

	# Ensure config and profile directories exist and /var/lib/colord/*
	# is writable by colord user
	keepdir /var/lib/colord/icc
	fowners colord:colord /var/lib/colord{,/icc}

	if use examples; then
		docinto examples
		dodoc examples/*.c
	fi
}

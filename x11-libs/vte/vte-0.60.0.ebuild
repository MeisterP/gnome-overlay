# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.32"

inherit gnome.org meson vala

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://wiki.gnome.org/Apps/Terminal/VTE"

LICENSE="LGPL-2+"
SLOT="2.91"
IUSE="+crypt debug glade +introspection systemd vala vanilla"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.40:2
	>=dev-libs/libpcre2-10.21
	dev-libs/fribidi
	dev-libs/icu
	>=x11-libs/gtk+-3.16:3[introspection?]
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses:0=
	sys-libs/zlib

	crypt?  ( >=net-libs/gnutls-3.2.7:0= )
	glade? ( >=dev-util/glade-3.9:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )
	systemd? ( >=sys-apps/systemd-220 )
"
DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig

	vala? ( $(vala_depend) )
"
RDEPEND="${RDEPEND}
	!x11-libs/vte:2.90[glade]
"

src_unpack() {
	default
	unpack "${FILESDIR}"/vte291-cntnr-precmd-preexec-scroll.tar.xz
}

src_prepare() {
	default

	if ! use vanilla; then
		# Part of https://src.fedoraproject.org/rpms/vte291/blob/f30/f/vte291-cntr-ntfy-scroll.patch
		# Patch distfile for 0.54 series is re-used, as only git hashes and co changed in patchset.
		# Adds OSC 777 support for desktop notifications in gnome-terminal or elsewhere
		eapply "${WORKDIR}"/vte291-cntnr-precmd-preexec-scroll.patch
	fi

	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dgtk3=true
		-Dgtk4=false
		-Dicu=true
		-Dfribidi=true
		-Da11y=true
		$(meson_use systemd _systemd)
		$(meson_use debug debugg)
		$(meson_use crypt gnutls)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	mv "${ED}"/etc/profile.d/vte{,-${SLOT}}.sh || die
}

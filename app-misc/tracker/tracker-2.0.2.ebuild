# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_5 )

inherit bash-completion-r1 gnome2 linux-info python-any-r1 vala systemd

DESCRIPTION="Desktop-neutral user information store, search tool and indexer"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/100"
KEYWORDS="~amd64 ~x86"
IUSE="networkmanager stemmer upower"

CDEPEND=">=dev-db/sqlite-3.20:=
	>=dev-libs/glib-2.44:2
	>=dev-libs/gobject-introspection-0.9.5:=
	>=dev-libs/icu-4.8.1.1:=
	>=dev-libs/json-glib-1.0
	>=dev-libs/libxml2-2.6
	>=net-libs/libsoup-2.40:2.4
	networkmanager? ( >=net-misc/networkmanager-0.8:= )
	stemmer? ( dev-libs/snowball-stemmer )
	>=sys-libs/libseccomp-2.0
	upower? ( || ( >=sys-power/upower-0.9 sys-power/upower-pm-utils ) )"

DEPEND="${CDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.8
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig"

RDEPEND="${CDEPEND}
	app-misc/tracker-miners"

function inotify_enabled() {
	if linux_config_exists; then
		if ! linux_chkconfig_present INOTIFY_USER; then
			ewarn "You should enable the INOTIFY support in your kernel."
			ewarn "Check the 'Inotify support for userland' under the 'File systems'"
			ewarn "option. It is marked as CONFIG_INOTIFY_USER in the config"
			die 'missing CONFIG_INOTIFY'
		fi
	else
		einfo "Could not check for INOTIFY support in your kernel."
	fi
}

pkg_setup() {
	linux-info_pkg_setup
	inotify_enabled

	python-any-r1_pkg_setup
}

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	local myconf=(
		--enable-tracker-fts
		--disable-functional-tests
		--disable-gcov
		--enable-gtk_doc
		--disable-unit-tests
		--enable-journal
		$(use_enable networkmanager network-manager)
		$(use_enable stemmer libstemmer)
		$(use_enable upower)
		--with-bash-completion-dir=$(get_bashcompdir)
		--with-unicode-support=libicu
	)

	econf "${myconf[@]}"
}

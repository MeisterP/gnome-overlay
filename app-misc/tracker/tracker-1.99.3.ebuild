# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit autotools bash-completion-r1 eutils gnome2 linux-info multilib python-any-r1 vala versionator virtualx meson

DESCRIPTION="A tagging metadata database, search tool and indexer"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/100"
IUSE="cue elibc_glibc exif ffmpeg firefox-bookmarks flac gif gstreamer
gtk iptc +jpeg libav +miner-fs mp3 nautilus networkmanager pdf playlist
seccomp stemmer test thunderbird +tiff upnp-av upower +vorbis +xml"

#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
KEYWORDS=""

REQUIRED_USE="
	?? ( gstreamer ffmpeg )
	cue? ( gstreamer )
	upnp-av? ( gstreamer )
	!miner-fs? ( !cue !exif !flac !gif !iptc !jpeg !mp3 !pdf !playlist !tiff !vorbis !xml )
"

# According to NEWS, introspection is non-optional
# glibc-2.12 needed for SCHED_IDLE (see bug #385003)
# seccomp is automagic, though we want to use it whenever possible (linux)
# >=media-libs/libmediaart-1.9:2.0 is suggested to be disabled for 1.10 for security;
# It is disable in configure in 1.12; revisit for 1.14/2 (configure flag)
RDEPEND="
	>=app-i18n/enca-1.9
	>dev-db/sqlite-3.20:=
	>=dev-libs/glib-2.44:2
	>=dev-libs/gobject-introspection-0.9.5:=
	>=dev-libs/icu-4.8.1.1:=
	>=dev-libs/json-glib-1.0
	>=media-libs/libpng-1.2:0=
	>=net-libs/libsoup-2.40:2.4
	>=x11-libs/pango-1:=
	sys-apps/util-linux
	virtual/imagemagick-tools[png,jpeg?]

	cue? ( media-libs/libcue )
	elibc_glibc? ( >=sys-libs/glibc-2.12 )
	exif? ( >=media-libs/libexif-0.6 )
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:0= )
	)
	firefox-bookmarks? ( || (
		>=www-client/firefox-4.0
		>=www-client/firefox-bin-4.0 ) )
	flac? ( >=media-libs/flac-1.2.1 )
	gif? ( media-libs/giflib:= )
	>=gnome-extra/libgsf-1.14.24
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0 )
	gtk? (
		>=x11-libs/gtk+-3:3 )
	iptc? ( media-libs/libiptcdata )
	>=sys-libs/libosinfo-0.2.9:=
	jpeg? ( virtual/jpeg:0 )
	upower? ( || ( >=sys-power/upower-0.9 sys-power/upower-pm-utils ) )
	mp3? ( >=media-libs/taglib-1.6 )
	networkmanager? ( >=net-misc/networkmanager-0.8:= )
	pdf? (
		>=x11-libs/cairo-1:=
		>=app-text/poppler-0.16[cairo,utils]
		>=x11-libs/gtk+-2.12:2 )
	playlist? ( >=dev-libs/totem-pl-parser-3 )
	>=net-libs/libgrss-0.7:0
	stemmer? ( dev-libs/snowball-stemmer )
	thunderbird? ( || (
		>=mail-client/thunderbird-5.0
		>=mail-client/thunderbird-bin-5.0 ) )
	tiff? ( media-libs/tiff:0 )
	>=media-libs/gupnp-dlna-0.9.4:2.0
	vorbis? ( >=media-libs/libvorbis-0.22 )
	xml? ( >=dev-libs/libxml2-2.6 )
	>=media-libs/exempi-2.1
	app-text/libgxps
	!gstreamer? ( !ffmpeg? ( || ( media-video/totem media-video/mplayer ) ) )
	seccomp? ( >=sys-libs/libseccomp-2.0 )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.8
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	test? (
		>=dev-libs/dbus-glib-0.82-r1
		>=sys-apps/dbus-1.3.1[X] )
"
PDEPEND="nautilus? ( ~gnome-extra/nautilus-tracker-tags-${PV} )"

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
	# Don't run 'firefox --version' or 'thunderbird --version'; it results in
	# access violations on some setups (bug #385347, #385495).
	create_version_script "www-client/firefox" "Mozilla Firefox" firefox-version.sh
	create_version_script "mail-client/thunderbird" "Mozilla Thunderbird" thunderbird-version.sh

	meson_src_prepare
	vala_src_prepare
	eapply_user
}

src_configure() {
	local emesonargs=(
		-D battery_detection=$(usex upower upower none)
		-D abiword=true
		-D dvi=true
		-D charset_detection=icu
		-D guarantee_metadata=true
		-D icon=true
		-D ps=true
		-D text=true
		-D fts=true
		-D writeback=true
		-D unicode_support=icu
		-D bash_completion="$(get_bashcompdir)"
		-D mp3=true
		-D stemmer=$(usex stemmer yes no)
		-D functional_tests=$(usex test true false)
	)

	if use gstreamer ; then
		emesonargs+=(
			-D generic_media_extractor=gstreamer
			-D gstreamer_backend=gupnp
		)
	elif use ffmpeg ; then
		emesonargs+=(-D generic_media_extractor=libav)
	else
		emesonargs+=(-D generic_media_extractor=none)
	fi

	meson_src_configure
}

src_install() {
	meson_src_install

	# Manually symlink extensions for {firefox,thunderbird}-bin
	if use firefox-bookmarks; then
		dosym ../../../share/xul-ext/trackerfox \
			/usr/$(get_libdir)/firefox-bin/extensions/trackerfox@bustany.org
	fi

	if use thunderbird; then
		dosym ../../../share/xul-ext/trackerbird \
			/usr/$(get_libdir)/thunderbird-bin/extensions/trackerbird@bustany.org
	fi
}

create_version_script() {
	# Create script $3 that prints "$2 MAX(VERSION($1), VERSION($1-bin))"

	local v=$(best_version ${1})
	v=${v#${1}-}
	local vbin=$(best_version ${1}-bin)
	vbin=${vbin#${1}-bin-}

	if [[ -z ${v} ]]; then
		v=${vbin}
	else
		version_compare ${v} ${vbin}
		[[ $? -eq 1 ]] && v=${vbin}
	fi

	echo -e "#!/bin/sh\necho $2 $v" > "$3" || die
	chmod +x "$3" || die
}

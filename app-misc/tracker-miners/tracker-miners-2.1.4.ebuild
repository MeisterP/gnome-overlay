# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2 vala systemd

DESCRIPTION="Collection of data extractors for Tracker"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/2.0"
KEYWORDS="~amd64 ~x86"

IUSE=" cue exif ffmpeg flac gif gsf gstreamer iptc +iso +jpeg libav +miner-fs
	mp3 pdf playlist rss stemmer +tiff upnp-av upower +vorbis +xml xmp xps"
REQUIRED_USE="
	?? ( gstreamer ffmpeg )
	cue? ( gstreamer )
	upnp-av? ( gstreamer )
	!miner-fs? ( !cue !exif !flac !gif !gsf !iptc !iso !jpeg !mp3 !pdf !playlist !tiff !vorbis !xml !xmp !xps )
"

RDEPEND=">=app-i18n/enca-1.9
	app-misc/tracker
	cue? ( media-libs/libcue )
	exif? ( >=media-libs/libexif-0.6 )
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:0= )
	)
	flac? ( >=media-libs/flac-1.2.1 )
	gif? ( media-libs/giflib:= )
	gsf? ( >=gnome-extra/libgsf-1.14.24 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0 )
	iptc? ( media-libs/libiptcdata )
	iso? ( >=sys-libs/libosinfo-0.2.9:= )
	jpeg? ( virtual/jpeg:0 )
	upower? ( || ( >=sys-power/upower-0.9 sys-power/upower-pm-utils ) )
	mp3? ( >=media-libs/taglib-1.6 )
	pdf? (
		>=x11-libs/cairo-1:=
		>=app-text/poppler-0.16[cairo,utils]
		>=x11-libs/gtk+-2.12:2 )
	playlist? ( >=dev-libs/totem-pl-parser-3 )
	rss? ( >=net-libs/libgrss-0.7:0 )
	stemmer? ( dev-libs/snowball-stemmer )
	tiff? ( media-libs/tiff:0 )
	upnp-av? ( >=media-libs/gupnp-dlna-0.9.4:2.0 )
	vorbis? ( >=media-libs/libvorbis-0.22 )
	xml? ( >=dev-libs/libxml2-2.6 )
	xmp? ( >=media-libs/exempi-2.1 )
	xps? ( app-text/libgxps )
	!gstreamer? ( !ffmpeg? ( || ( media-video/totem media-video/mplayer ) ) )
	>=sys-libs/libseccomp-2.0"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig"

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	local myconf=(
		--disable-gcov
		--disable-hal
		--disable-unit-tests
		--enable-abiword
		--enable-dvi
		--enable-enca
		--enable-extract
		--enable-guarantee-metadata
		--enable-icon
		--enable-journal
		--enable-libpng
		--enable-miner-apps
		--enable-ps
		--enable-text
		--enable-tracker-writeback
		--enable-unzip-ps-gz-files
		$(use_enable cue libcue)
		$(use_enable exif libexif)
		$(use_enable flac libflac)
		$(use_enable gif libgif)
		$(use_enable gsf libgsf)
		$(use_enable iptc libiptcdata)
		$(use_enable iso libosinfo)
		$(use_enable jpeg libjpeg)
		$(use_enable miner-fs)
		$(use_enable mp3)
		$(use_enable mp3 taglib)
		$(use_enable pdf poppler)
		$(use_enable playlist)
		$(use_enable rss miner-rss)
		$(use_enable stemmer libstemmer)
		$(use_enable tiff libtiff)
		$(use_enable upower)
		$(use_enable vorbis libvorbis)
		$(use_enable xml libxml2)
		$(use_enable xmp exempi)
		$(use_enable xps libgxps)
		--with-unicode-support=libicu
	)

	if use gstreamer ; then
		myconf+=( --enable-generic-media-extractor=gstreamer )
		if use upnp-av; then
			myconf+=( --with-gstreamer-backend=gupnp )
		else
			myconf+=( --with-gstreamer-backend=discoverer )
		fi
	elif use ffmpeg ; then
		myconf+=( --enable-generic-media-extractor=libav )
	else
		myconf+=( --enable-generic-media-extractor=none )
	fi

	econf "${myconf[@]}"
}

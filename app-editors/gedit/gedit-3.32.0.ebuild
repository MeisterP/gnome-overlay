# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python3_{4,5,6} )
VALA_MIN_API_VERSION="0.26"
VALA_USE_DEPEND="vapigen"

inherit eutils gnome2 multilib python-single-r1 vala virtualx meson

DESCRIPTION="A text editor for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Gedit"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"

IUSE="gtk-doc +introspection +python vala"
REQUIRED_USE="python? ( introspection ${PYTHON_REQUIRED_USE} )"

KEYWORDS="~amd64 ~x86"

# X libs are not needed for OSX (aqua)
COMMON_DEPEND="
	>=dev-libs/libxml2-2.5.0:2
	>=dev-libs/glib-2.44:2[dbus]
	>=x11-libs/gtk+-3.22.0:3[introspection?]
	>=x11-libs/gtksourceview-4.0.2:4[introspection?]
	>=dev-libs/libpeas-1.14.1[gtk]

	gnome-base/gsettings-desktop-schemas
	gnome-base/gvfs

	x11-libs/libX11

	introspection? ( >=dev-libs/gobject-introspection-0.9.3:= )
	python? (
		${PYTHON_DEPS}
		dev-python/pycairo[${PYTHON_USEDEP}]
		>=dev-python/pygobject-3:3[cairo,${PYTHON_USEDEP}]
		dev-libs/libpeas[python,${PYTHON_USEDEP}] )
	>=app-text/gspell-0.2.5:0=
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
"
DEPEND="${COMMON_DEPEND}
	${vala_depend}
	gtk-doc? (
		>=dev-util/gtk-doc-am-1
		app-text/docbook-xml-dtd:4.1.2 )
	dev-util/glib-utils
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use introspection)
		-Dplugins=true
		$(meson_use vala vapi)
		$(meson_use gtk-doc documentation)
	)
	meson_src_configure
}

src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die
	GSETTINGS_SCHEMA_DIR="${S}/data" virtx emake check
}

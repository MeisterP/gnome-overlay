# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="xml"
VALA_MIN_API_VERSION="0.28"

inherit eutils gnome.org meson python-single-r1 vala

DESCRIPTION="Official plugins for gedit"
HOMEPAGE="https://wiki.gnome.org/Apps/Gedit/ShippedPlugins"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE_plugins="charmap git terminal vala"
IUSE="+python ${IUSE_plugins}"
# python-single-r1 would request disabling PYTHON_TARGETS on libpeas
REQUIRED_USE="
	charmap? ( python )
	git? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	terminal? ( python )
"

RDEPEND="
	>=app-editors/gedit-3.16
	>=dev-libs/glib-2.32:2
	>=dev-libs/libpeas-1.14.1[gtk]
	>=x11-libs/gtk+-3.9:3
	>=x11-libs/gtksourceview-4.0.2:4
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=app-editors/gedit-3.16[introspection,python,${PYTHON_SINGLE_USEDEP}]
			dev-libs/libpeas[python,${PYTHON_SINGLE_USEDEP}]
			>=dev-python/dbus-python-0.82[${PYTHON_MULTI_USEDEP}]
			dev-python/pycairo[${PYTHON_MULTI_USEDEP}]
			dev-python/pygobject:3[cairo,${PYTHON_MULTI_USEDEP}]
		')
		>=x11-libs/gtk+-3.9:3[introspection]
		>=x11-libs/gtksourceview-4.0.2:4[introspection]
		x11-libs/pango[introspection]
		x11-libs/gdk-pixbuf:2[introspection]
	)
	charmap? ( >=gnome-extra/gucharmap-3:2.90[introspection] )
	git? ( >=dev-libs/libgit2-glib-0.0.6 )
	terminal? ( >=x11-libs/vte-0.52:2.91[introspection] )
	vala? ( $(vala_depend) )
" # vte-0.52+ for feed_child API compatibility
DEPEND="${RDEPEND}
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

pkg_setup() {
	use python && [[ ${MERGE_TYPE} != binary ]] && python-single-r1_pkg_setup
}

src_prepare() {
	default
	use vala && vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable python) \
		$(use_enable vala)
}

src_configure() {
	local emesonargs=(
		-Dplugin_bookmarks=true
		-Dplugin_drawspaces=true
		-Dplugin_wordcompletion=true
		-Dplugin_zeitgeist=false

		$(meson_use python plugin_bracketcompletion)
		$(meson_use python plugin_charmap)
		$(meson_use python plugin_codecomment)
		$(meson_use python plugin_colorpicker)
		$(meson_use python plugin_colorschemer)
		$(meson_use python plugin_commander)
		$(meson_use python plugin_git)
		$(meson_use python plugin_joinlines)
		$(meson_use python plugin_multiedit)
		$(meson_use python plugin_sessionsaver)
		$(meson_use python plugin_smartspaces)
		$(meson_use python plugin_synctex)
		$(meson_use python plugin_terminal)
		$(meson_use python plugin_textsize)
		$(meson_use python plugin_translate)

		$(meson_use vala plugin_findinfiles)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}

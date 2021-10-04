# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.52"

inherit vala meson gnome2-utils xdg

COMMIT="40c19ab2591763a482ebc79c82f1da32eea3bab6"

DESCRIPTION="Building blocks for modern GNOME applications."
HOMEPAGE="https://gitlab.gnome.org/GNOME/libadwaita"
SRC_URI="https://gitlab.gnome.org/GNOME/libadwaita/-/archive/${COMMIT}/libadwaita-${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples glade gtk-doc +introspection test +vala"
REQUIRED_USE="vala? ( introspection )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.44:2
	>=x11-libs/gtk+-3.24.1:3[introspection?]
	glade? ( dev-util/glade:3.10= )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
	>=gui-libs/gtk-4.0.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/sassc
	dev-libs/libxml2:2
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3 )
	vala? ( $(vala_depend) )
"

S="${WORKDIR}/$PN-${COMMIT}"

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dprofiling=false # -pg passing
		$(meson_feature introspection)
		$(meson_use vala vapi)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use test tests)
		$(meson_use examples)
		$(meson_feature glade glade_catalog)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

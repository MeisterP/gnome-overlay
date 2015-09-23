from __future__ import absolute_import
from ..version import get_last_local_version
from ..ebuild import create_ebuild

ATOM = 'net-libs/libsoup-gnome'


def run(new_version):
    print("check ebuild for %s" % ATOM)
    last_version = sorted(get_last_local_version(ATOM))[-1]
    if last_version < new_version:
        create_ebuild(ATOM, new_version)

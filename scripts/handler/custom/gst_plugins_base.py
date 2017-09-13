from ..version import get_last_local_version
from ..ebuild import create_ebuild

ATOMS = (
    'media-plugins/gst-plugins-cdparanoia',
    'media-plugins/gst-plugins-libvisual',
)


def run(new_version):
    for a in ATOMS:
        #print("check ebuild for %s" % a)
        last_version = sorted(get_last_local_version(a))[-1]
        if last_version < new_version:
            create_ebuild(a, new_version)

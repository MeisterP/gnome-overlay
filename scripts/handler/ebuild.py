from os import path, makedirs
import shutil
from commands import getoutput

from version import LOCAL_PREFIX, PORTAGE_PREFIX, get_last_local_version


def create_ebuild(atom, version):
    pkg_name = atom.split("/")[1]
    local_path = path.join(path.dirname(LOCAL_PREFIX), atom)
    if not path.exists(local_path):
        makedirs(local_path)
    last_overlay_version, last_portage_version = get_last_local_version(atom)
    ebuild_name = "%s-%s.ebuild" % (pkg_name, version.vstring)
    print("create %s" % ebuild_name)
    if not last_overlay_version or last_portage_version > last_overlay_version:
        print("copy ebuild from portage")
        shutil.copyfile(path.join(PORTAGE_PREFIX, atom, "%s-%s.ebuild" % (
        pkg_name, str(last_portage_version).replace('.post', '-r'))),
                        path.join(local_path, ebuild_name))
    else:
        print("move ebuild in overlay")
        shutil.move(path.join(local_path,
                              "%s-%s.ebuild" % (pkg_name, str(last_overlay_version).replace('.post', '-r'))),
                    path.join(local_path, ebuild_name))

    print getoutput('cd %s && sudo ebuild %s digest' % (local_path, ebuild_name))

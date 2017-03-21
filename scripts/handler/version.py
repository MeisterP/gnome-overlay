from ftplib import FTP
from os import path, listdir
from distutils.version import LooseVersion as Version
from re import compile
from pkg_resources import parse_version

version_regexp = compile("-(\d+(\.\d+)*(-r\d)?)")
ftp = FTP('ftp.gnome.org')
ftp.login()

PORTAGE_PREFIX = '/usr/portage/'
FTP_PREFIX = '/pub/gnome/sources/'
LOCAL_PREFIX = path.dirname(path.dirname(__file__))


def get_last_ftp_version(atom, slot=None):
    if slot:
        slot = Version(slot)
    ftp.cwd(FTP_PREFIX + atom)
    slots = []
    ftp.dir(lambda x: slots.append(Version(x.split()[-1])) if x.startswith('d') else None)
    awailable_slots = sorted(slots)
    if slot:
        if slot in awailable_slots:
            ftp.cwd(slot.vstring)
        else:
            last_slot = [s for s in awailable_slots if s <= slot][-1]
            ftp.cwd(last_slot.vstring)
    else:
        last_slot = awailable_slots[-1]
        ftp.cwd(last_slot.vstring)
    versions = []
    ftp.dir(lambda x: versions.append(Version(version_regexp.findall(x.split()[-1])[0][0])) if x.endswith(
        'tar.xz') else None)
    return sorted(versions)[-1]


def get_last_local_version(atom):
    def get_last_version(prefix, atom):
        versions = []
        if not path.exists(path.join(prefix, atom)):
            return Version('0')
        for f in listdir(path.join(prefix, atom)):
            if f.endswith(".ebuild"):
                versions.append(Version(parse_version(version_regexp.findall(f)[0][0]).base_version))

        if versions:
            return sorted(versions)[-1]
        return Version('0')

    last_portage_version = get_last_version(PORTAGE_PREFIX, atom)
    last_overlay_version = get_last_version(path.dirname(LOCAL_PREFIX), atom)
    return last_overlay_version, last_portage_version

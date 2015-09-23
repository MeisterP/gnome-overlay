from ftplib import FTP
from os import path, listdir
from pkg_resources import parse_version
from re import compile

version_regexp = compile("-(\d+\.\d+[\.\d+]*\d+(-r\d)?)")
ftp = FTP('ftp.gnome.org')
ftp.login()

PORTAGE_PREFIX = '/usr/portage/'
FTP_PREFIX = '/pub/gnome/sources/'
LOCAL_PREFIX = path.dirname(path.dirname(__file__))


def get_last_ftp_version(atom):
    ftp.cwd(FTP_PREFIX + atom)
    slots = []
    ftp.dir(lambda x: slots.append(parse_version(x.split()[-1])) if x.startswith('d') else None)
    last_slot = sorted(slots)[-1]
    ftp.cwd(last_slot.base_version)
    versions = set()
    ftp.dir(lambda x: versions.add(parse_version(version_regexp.findall(x.split()[-1])[0][0])) if x.endswith(
        'tar.xz') else None)
    return sorted(versions)[-1]


def get_last_local_version(atom):
    def get_last_version(prefix, atom):
        versions = set()
        if not path.exists(path.join(prefix, atom)):
            return None
        for f in listdir(path.join(prefix, atom)):
            if f.endswith(".ebuild"):
                versions.add(parse_version(version_regexp.findall(f)[0][0]))

        if versions:
            return sorted(versions)[-1]
        return None

    last_portage_version = get_last_version(PORTAGE_PREFIX, atom)
    last_overlay_version = get_last_version(path.dirname(LOCAL_PREFIX), atom)
    return last_overlay_version, last_portage_version

import aioftp
from os import path, listdir
from distutils.version import LooseVersion as Version
from re import compile
from pkg_resources import parse_version

version_regexp = compile("-(\d+(\.\d+)*(-r\d)?)")
host = 'ftp.gnome.org'

PORTAGE_PREFIX = '/usr/portage/'
FTP_PREFIX = '/pub/gnome/sources/'
LOCAL_PREFIX = path.dirname(path.dirname(__file__))


async def get_last_ftp_version(atom, slot=None):
    async with aioftp.ClientSession(host) as client:
        if slot:
            slot = Version(slot)
        await client.change_directory(FTP_PREFIX + atom)
        slots = []
        for p, info in (await client.list()):
            if info.get('type') == 'dir':
                slots.append(Version(str(p)))
        available_slots = sorted(slots)
        if slot:
            if slot in available_slots:
                await client.change_directory(slot.vstring)
            else:
                last_slot = [s for s in available_slots if s <= slot][-1]
                await client.change_directory(last_slot.vstring)
        else:
            last_slot = available_slots[-1]
            await client.change_directory(last_slot.vstring)
        versions = []
        for p, info in (await client.list()):
            if str(p).endswith('tar.xz'):
                versions.append(Version(version_regexp.findall(str(p))[0][0]))
        return sorted(versions)[-1]


def get_last_local_version(atom):
    def get_last_version(prefix):
        versions = []
        if not path.exists(path.join(prefix, atom)):
            return Version('0')
        for f in listdir(path.join(prefix, atom)):
            if f.endswith(".ebuild"):
                versions.append(Version(parse_version(version_regexp.findall(f)[0][0]).base_version))

        if versions:
            return sorted(versions)[-1]
        return Version('0')

    last_portage_version = get_last_version(PORTAGE_PREFIX)
    last_overlay_version = get_last_version(path.dirname(LOCAL_PREFIX))
    return last_overlay_version, last_portage_version

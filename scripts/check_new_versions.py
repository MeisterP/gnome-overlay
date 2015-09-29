#! env python2.7
# -*- coding: utf-8 -*-
from __future__ import absolute_import
from os import path
from handler.version import LOCAL_PREFIX, get_last_ftp_version, get_last_local_version
from handler.ebuild import create_ebuild
from handler import custom

custom_modules = [m for m in dir(custom) if not m.startswith('__')]


def main(config):
    for atom in config:
        atom = atom.strip()
        print("check %s" % atom)
        pkg_name = atom.split("/")[1]
        last_local_version = sorted(get_last_local_version(atom))[-1]
        print("local version: %s" % last_local_version.base_version)

        custom_handler = False
        only_local_check = False
        if pkg_name.replace("-", "_") in custom_modules:
            custom_handler = True
            mod = getattr(custom, pkg_name.replace("-", "_"))
            only_local_check = getattr(mod, 'ONLY_LOCAL_CHECK', False)

        if only_local_check:
            last_ftp_version = last_local_version
        else:
            last_ftp_version = get_last_ftp_version(pkg_name)
            print("ftp version: %s" % last_ftp_version.base_version)
            if last_ftp_version > last_local_version:
                create_ebuild(atom, last_ftp_version)

        if custom_handler:
            getattr(custom, pkg_name.replace("-", "_")).run(last_ftp_version)


if __name__ == '__main__':
    with open(path.join(LOCAL_PREFIX, 'apps_list.conf')) as config:
        main(config)

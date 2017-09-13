#! env python3
# -*- coding: utf-8 -*-
from __future__ import absolute_import

from datetime import datetime
from time import sleep
from os import path
import asyncio
from handler.version import LOCAL_PREFIX, get_last_ftp_version, get_last_local_version
from handler.ebuild import create_ebuild
from handler import custom

custom_modules = [m for m in dir(custom) if not m.startswith('__')]
loop = asyncio.get_event_loop()


async def check_atom_process(atom, slot):
    pkg_name = atom.split("/")[1]
    last_local_version = sorted(get_last_local_version(atom))[-1]
    print("local version: %s" % last_local_version.vstring)

    custom_handler = False
    only_local_check = False
    if pkg_name.replace("-", "_") in custom_modules:
        custom_handler = True
        mod = getattr(custom, pkg_name.replace("-", "_"))
        only_local_check = getattr(mod, 'ONLY_LOCAL_CHECK', False)

    if only_local_check:
        last_ftp_version = last_local_version
    else:
        last_ftp_version = await get_last_ftp_version(pkg_name, slot)
        print("ftp version: %s" % last_ftp_version.vstring)
        if last_ftp_version > last_local_version:
            create_ebuild(atom, last_ftp_version)

    print("check %s" % atom)

    if custom_handler:
        getattr(custom, pkg_name.replace("-", "_")).run(last_ftp_version)


async def check_atom(atom):
    e = atom.strip().split(":")
    atom = e[0]
    slot = e[1] if len(e) == 2 else None

    x = asyncio.ensure_future(check_atom_process(atom, slot))
    await x


async def bound_check(sem, atom):
    async with sem:
        await check_atom(atom)


async def main(conf):
    sem = asyncio.Semaphore(4)
    tasks = []
    for atom in conf:
        task = asyncio.ensure_future(bound_check(sem, atom))
        tasks.append(task)

    responses = asyncio.gather(*tasks)
    await responses


if __name__ == '__main__':
    start = datetime.now()
    with open(path.join(LOCAL_PREFIX, 'apps_list.conf')) as config:
        loop.run_until_complete(main(config))

    print("Finish at {} sec".format((datetime.now() - start)))

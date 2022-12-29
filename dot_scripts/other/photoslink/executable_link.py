#!/usr/bin/env python3

from os.path import join, expanduser, exists, splitext
import os

import osxphotos

def link(p, base = None):
    root = expanduser("~/Pictures/Links/")
    name = p.date.strftime("%Y%m%d%H%M%S")
    tree = base or join(str(p.date.year), str(p.date.month))
    basedir = join(root, tree)
    os.makedirs(basedir, exist_ok=True)
    print(p.uuid, "->", name, p.date.date())

    filename = name + splitext(p.original_filename)[1]
    dst = join(basedir, filename)
    if p.path == None:
        print(p.filename, "is irregular, skipping")
    elif os.path.exists(dst):
        print(filename, "is exists, skipping")
#       pass
    else:
        os.link(p.path, dst)

    if p.live_photo and p.path_live_photo != None:
        print(p.uuid, "is Live Photo")
        filename = name + splitext(p.path_live_photo)[1]
        dst = join(basedir, filename)
        if exists(dst):
            print(filename, "(Live) is exists, skipping")
#           pass
        else:
            os.link(p.path_live_photo, dst)


def main():
    db = os.path.expanduser("~/Pictures/Apple Photos/Photos Library.photoslibrary")
    photosdb = osxphotos.PhotosDB(db)

    photos = photosdb.photos()
    for p in photos[:]:
        link(p)
        if p.burst:
            for b in p.burst_photos:
                link(b)
        if p.favorite:
            link(p, "Favorites")

if __name__ == "__main__":
    main()

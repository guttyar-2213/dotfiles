#!/bin/bash
set -eu

mkdir -p ~/Pictures/Links/
cd ~/Pictures/Links/

osxphotos export \
 --directory "{created.year}/{created.mm}" \
 --filename "{created}-{created.hour}{created.min}{created.sec}-{original_name}" \
 --db "$HOME/Pictures/Apple Photos/Photos Library.photoslibrary" \
 --edited-suffix "-M" \
 --export-as-hardlink \
 --touch-file \
 --exportdb yymm.db \
 --update \
 --only-new \
 ./
 
osxphotos export \
 --directory "Favorites" \
 --filename "{created}-{created.hour}{created.min}{created.sec}-{original_name}" \
 --db "$HOME/Pictures/Apple Photos/Photos Library.photoslibrary" \
 --edited-suffix "-M" \
 --export-as-hardlink \
 --touch-file \
 --favorite \
 --exportdb xfav.db \
 --update \
 --only-new \
 ./

exit 0
 
osxphotos export \
 --directory "EXPORT/{created.year}/{created.mm}" \
 --filename "{created}-{created.hour}{created.min}{created.sec}-{original_name}" \
 --db "$HOME/Pictures/Apple Photos/Photos Library.photoslibrary" \
 --edited-suffix "-M" \
 --exiftool \
 --sidecar xmp \
 --sidecar-drop-ext \
 --download-missing \
 --preview-if-missing \
 --preview-suffix "-P" \
 --touch-file \
 --exportdb xpor.db \
 --report export.json \
 ./

exiftool -m -q -r -progress -d %Y-%m '-hardlink<fixed/$FileModifyDate/%f.$fileTypeExtension' 20*/
exiftool -m -q -r '-filename<%f.$fileTypeExtension' EXPORT
jq -s '. | flatten' *.json | less
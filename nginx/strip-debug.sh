#!/bin/sh -e
file="$(basename "$1")"
reldir="$(realpath --relative-to="/buildroot" .)"
objcopy --only-keep-debug --compress-debug-sections "$file" "$file.debug"
objcopy --add-gnu-debuglink="$file.debug" "$file"
mkdir -p "/buildroot/usr/lib/debug/$reldir"
mv -v "$file.debug" "/buildroot/usr/lib/debug/$reldir"
strip "$file"

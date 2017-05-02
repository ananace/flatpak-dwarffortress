#!/bin/sh

tar -xf df_linux.tar.bz2 --strip-components=1
md5sum libs/Dwarf_Fortress > ./md5sum
rm df_linux.tar.bz2
rm -rf df g_src/ libs/*.so*
cp /app/lib/libgraphics.so /app/dfhack/libs/
cp -r /app/dfhack/* .

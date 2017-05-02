#!/bin/sh

tar -xf df_linux.tar.bz2 --strip-components=1
rm df_linux.tar.bz2
rm -rf df g_src/ libs/*.so*

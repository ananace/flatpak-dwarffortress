#!/bin/bash

cd ~/df_linux || exit 1

DFHACK=""
STONESENSE=""

usage() {
    cat <<EOF
Usage: $0 [OPTION...]

Application data can be found in ~/.var/app/com.bay12games.DwarfFortress/df_linux/

If a dfhack init file has been created, then the default is to run dfhack.

Options:
 -d   Runs plain Dwarf Fortress
 -h   Runs dfhack, creating an init file if one doesn't already exist
 -s   Copies over files needed to run Stonesense
 -R   Copies raw files into the application data folder, for modding purposes
EOF
}

while getopts ":hsdR" opt; do
    case $opt in
        h)
            DFHACK="true"
            ;;
        s)
            STONESENSE="true"
            ;;
        d)
            DFHACK="false"
            ;;
        R)
            RAW="true"
            ;;
        \?)
            echo "Unknown option -$OPTARG"
            usage
            exit 1
            ;;
    esac
    shift
done

if [ ! -d /app/dfhack ]; then
    [ "$DFHACK" = "true" ] && ( echo "This version of com.bay12games.DwarfFortress does not come with dfhack support. Sorry."; exit 1; )
    DFHACK="false"
fi

DIRS=( data )
HACKDIRS=( )
FILES=( '*.txt' README.linux )

if [ -f dfhack.init ] && [ "$DFHACK" != "false" ]; then
    DFHACK="true"
fi

[ "$DFHACK" = "true" ] && HACKDIRS+=( hack dfhack-config )
[ "$STONESENSE" = "true" ] && HACKDIRS+=( stonesense )
[ "$RAW" = "true" ] && DIRS+=( raw )

for DIR in "${DIRS[@]}"; do
    cp -nr "/app/extra/$DIR" .
done
for DIR in "${HACKDIRS[@]}"; do
    cp -nr "/app/dfhack/$DIR" .
done
for PATTERN in "${FILES[@]}"; do
    for FILE in /app/extra/$PATTERN; do
        [ -f "$FILE" ] && cp -n "$FILE" .
    done
done

if [ "$DFHACK" = "true" ] && [ ! -f dfhack.init ]; then
    echo "Creating dfhack.init"
    cp /app/dfhack/dfhack.init-example dfhack.init
fi

if [ "$DFHACK" = "true" ] || [ -f dfhack.init ] && [ "$DFHACK" != "false" ]; then
    RC='.dfhackrc'
    if [ -r "$HOME/$RC" ]; then
        . "$HOME/$RC"
    fi

    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/app/dfhack/hack/libs:/app/dfhack/hack"
    export LD_PRELOAD="${PRELOAD_LIB:+/app/$PRELOAD_LIB:}/app/dfhack/hack/libdfhack.so"
fi

/app/extra/libs/Dwarf_Fortress "$@"

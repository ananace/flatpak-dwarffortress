#!/bin/bash

# XXX Build a runtime directory in /tmp?
cd ~/df_linux || exit 1

DFHACK=""

usage() {
    cat <<EOF
Usage: $0 [OPTION...]

Application data can be found in ~/.var/app/com.bay12games.DwarfFortress/df_linux/

By default, this will launch plain Dwarf Fortress.
If a dfhack init file exists then it will launch DFHack by default.

If a file named .dfrc exists in df_linux, then it will be sourced before launching Dwarf Fortress.
If a file named .dfhackrc exists in df_linux, then it will be sourced before setting up dfhack.

Options:
 -d   Runs plain Dwarf Fortress
 -h   Runs dfhack, creating an init file if one doesn't already exist
 -t   Run dfhack with TWBT
EOF
}

while getopts ":hsdtR" opt; do
    case $opt in
        t)
            DFHACK="true"
            TWBT="true"
            ;;
        h)
            DFHACK="true"
            ;;
        d)
            DFHACK="false"
            TWBT="false"
            ;;
        \?)
            echo "Unknown option -$OPTARG"
            usage
            exit 1
            ;;
    esac
    shift
done

if [ ! -d /app/dfhack/hack ]; then
    [ "$DFHACK" = "true" ] && ( echo "This version of com.bay12games.DwarfFortress does not come with dfhack support. Sorry."; exit 1; )
    DFHACK="false"
fi

if [ ! -d /app/twbt/hack ]; then
    [ "$TWBT" = "true" ] && ( echo "This version of com.bay12games.DwarfFortress does not come with TWBT support. Sorry."; exit 1; )
    TWBT="false"
fi

DIRS=( data raw )
HACKDIRS=( )
FILES=( '*.txt' README.linux )

[ -f dfhack.init ] && [ "$DFHACK" != "false" ] && DFHACK="true"

if [ "$DFHACK" = "true" ] && [ ! -t 0 ] && [ ! -t 1 ]; then
    # FIXME Can this be done, or maybe a separate terminal could be opened for handling dfhack?
    # TODO Show this message to the user
    echo "Trying to run dfhack outside of terminal, this won't work at the moment."
    DFHACK="false"
fi
[ "$DFHACK" = "true" ] && HACKDIRS+=( dfhack/hack dfhack/dfhack-config dfhack/stonesense )
[ "$TWBT" = "true" ] && HACKDIRS+=( twbt/hack twbt/data )

for DIR in "${DIRS[@]}"; do
    if [ ! -e "$DIR/.skip" ]; then
        cp -nr "/app/extra/$DIR" .
    fi
done
for DIR in "${HACKDIRS[@]}"; do
    if [ ! -e "$DIR/.skip" ]; then
        cp -nr "/app/$DIR" .
    fi
done
for PATTERN in "${FILES[@]}"; do
    for FILE in /app/extra/$PATTERN; do
        if [ ! -e ".$FILE.skip" ]; then
            [ -f "$FILE" ] && cp -n "$FILE" .
        fi
    done
done

# Don't overwrite user configuration by default
AUTOSKIP=( data/init/init.txt data/init/g_init.txt dfhack.init )

for FILE in "${AUTOSKIP[@]}"; do
    SKIPNAME="$(pwd)/$(dirname "$FILE")/.$(basename "$FILE").skip"
    [ -e "$SKIPNAME" ] || touch "$SKIPNAME"
done

if [ "$DFHACK" = "true" ] && [ ! -f dfhack.init ]; then
    echo "Creating dfhack.init"
    cp /app/dfhack/dfhack.init-example dfhack.init
fi

if [ "$DFHACK" = "true" ] || [ -f dfhack.init ] && [ "$DFHACK" != "false" ]; then
    RC='.dfhackrc'
    if [ -r "$RC" ]; then
        . "$RC"
    fi

    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/app/dfhack/hack/libs:/app/dfhack/hack"
    export LD_PRELOAD="${PRELOAD_LIB:+/app/$PRELOAD_LIB:}/app/dfhack/hack/libdfhack.so"
fi

if [ "$TWBT" = "true" ]; then
  sed -i 's;PRINT_MODE:2D;PRINT_MODE:TWBT;g' data/init/init.txt
fi

RC='.dfrc'
if [ -r "$RC" ]; then
    . "$RC"
fi

/app/extra/libs/Dwarf_Fortress "$@"

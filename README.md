Dwarf Fortress
==============

A pre-built version of 0.43.05 is available at;
```
$ flatpak --user install http://www.lysator.liu.se/~ace/dwarffortress.flatpakref
```

The application data when run can be found in `~/.var/app/com.bay12games.DwarfFortress/df_linux`

To run with dfhack, you might need to run from a terminal currently, it seems like `Terminal: true` in the .desktop file can misbehave.

Compilation info
----------------

This repo contains the data necessary to compile Dwarf Fortress into a Flatpak.
Currently supported versions are;

- 0.43.03 i386, w/ dfhack
- 0.43.05 i386 & x86\_64, w/ dfhack

To build and install/run the application locally you can do the following;
```
# Available options;
#   ARCH   - The architecture to use (i386, x86_64), defaults to the running arch.
#   BRANCH - The version to build, defaults to the latest version.

$ export BRANCH=0.43.03 ARCH=i386
$ make 
$ make install-repo
```

### TODO

- Improve install steps, strip down configure parameters to just what's needed
- Perhaps work the Dwarf Fortress folders into a more XDG-ish state
  (~/data, ~/cache, ~/config, etc)
  - Could probably generate a temporary file hierarchy with symlinks in /tmp on run.
  - Look into modding, make sure it's not going to break anything because of these changes.
    - Could probably do it as a two-step solution, the 'copy everything' one, and the XDG way.
- Make a proper readme
- Split DFHack out as an extension, to avoid rebuilding the entire application on DFHack updates.
  Would also let people use different versions to avoid bugs or glitches.

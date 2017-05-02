Dwarf Fortress
====

This repo contains the data necessary to compile Dwarf Fortress into a Flatpak.
Currently supported versions are;

- 0.43.03 i386, w/ dfhack
- 0.43.05 i386 & x86\_64, w/ dfhack

To build and install/run the application locally you can do the following;
```
$ # Available options;
$ #   ARCH   - The architecture to use (i386, x86_64), defaults to the running arch.
$ #   BRANCH - The version to build, defaults to the latest version.
$ export BRANCH=0.43.03 ARCH=i386
$ make 
$ make install-repo
```

The application data when run can be found in `~/.var/app/com.bay12games.DwarfFortress/df_linux`

### TODO

- Improve install steps, strip down configure parameters to just what's needed
- Perhaps work the Dwarf Fortress folders into a more XDG-ish state
  (~/data, ~/cache, ~/config, etc)
- Make a proper readme

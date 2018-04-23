Dwarf Fortress
==============

The latest version of the Flatpak (x86_64) can be [downloaded here](http://www.lysator.liu.se/~ace/dwarffortress.flatpakref).
```
$ flatpak --user install http://www.lysator.liu.se/~ace/dwarffortress.flatpakref
```

The application data when run can be found in `~/.var/app/com.bay12games.DwarfFortress/df_linux`

Compilation info
----------------

This repo contains the data necessary to compile Dwarf Fortress into a Flatpak.

#### Supported Versions
Currently supported versions are;

- 0.43.03 i386, w/ dfhack
- 0.43.05 i386 & x86\_64, w/ dfhack
- 0.44.02 i386 & x86\_64, w/ dfhack
- 0.44.07 i386 & x86\_64, w/ dfhack
- 0.44.09 i386 & x86\_64, w/ dfhack


#### Compilation Requirements

Version 0.9.2 or later of flatpak is needed in order to successfully build the Flatpak.

Run `flatpak --version` to determine what you currently use. 

If your distribution does not provide a suitable version, a third party repository may be needed to install an appropriate version. Consult the recommended [setup instructions](https://flatpak.org/setup/) for more info.

#### Build Overview
To build and install/run the application locally you can do the following;
```
# Available options;
#   ARCH    - The architecture to use (i386, x86_64), defaults to the running arch.
#   BRANCH  - The version to build, defaults to the latest version.
#   GPG_KEY - The GPG key to use for when signing a release, not used for devel

$ export BRANCH=0.43.03 ARCH=i386 GPG_KEY=1234567
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

Dwarf Fortress
====

This repo contains the data necessary to compile Dwarf Fortress into a Flatpak.

To build it you need the freedesktop platform and SDK, which can be installed in the following manner;
```
$ wget https://sdk.gnome.org/keys/gnome-sdk.gpg
$ flatpak --user remote-add --gpg-import=gnome-sdk.gpggnome http://sdk.gnome.org/repo
$ flatpak --user install gnome org.freedesktop.Sdk 1.4
$ flatpak --user install gnome org.freedesktop.Platform 1.4
```

To build and install/run the application you can do the following;
```
$ make
$ make install
$ make run
```

The application data can be found in `~/.var/app/com.bay12games.DwarfFortress/df_linux`

### TODO

- Clean up more unnecessary data
- Install dfhack
	- Add an option to boot dfhack or not
- Improve install steps, don't compile useless parts

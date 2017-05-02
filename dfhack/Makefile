INSTALL = /app/dwarf-fortress/dfhack

all: 
	true

$(INSTALL):
	cp -rt $(@D) dfhack.init-example dfhack-config/ hack/ stonesense/

install: $(INSTALL)

clean:
	true

.PHONY: all install clean

ID := com.bay12games.DwarfFortress
BUNDLE := dwarffortress.flatpak

USER := --user
BUILD_DIR ?= build
REPO ?= repo

MANIFEST = $(ID).json

all: $(BUNDLE)

build:
	flatpak-builder --arch=i386 --repo $(REPO) $(BUILD_DIR) $(MANIFEST)

$(BUNDLE): build
	flatpak build-bundle --arch=i386 $(REPO) $(BUNDLE) $(ID)

install: $(BUNDLE)
	flatpak $(USER) install --arch=i386 --bundle $(BUNDLE)

uninstall:
	flatpak $(USER) uninstall --arch=i386 $(ID)

run:
	flatpak run --arch=i386 $(ID)

clean-build:
	$(RM) -r $(BUILD_DIR)

clean: clean-build
	$(RM) $(BUNDLE)

.PHONY: all clean clean-build

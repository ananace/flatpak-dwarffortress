ID := com.bay12games.DwarfFortress
BUNDLE := dwarffortress.flatpak

USER := --user
BUILD_DIR ?= build
REPO ?= repo

MANIFEST = $(ID).json

all: $(BUNDLE)

build:
	flatpak-builder --repo $(REPO) $(BUILD_DIR) $(MANIFEST)

$(BUNDLE): build
	flatpak build-bundle $(REPO) $(BUNDLE) $(ID)

install: $(BUNDLE)
	flatpak $(USER) install --bundle $(BUNDLE)

uninstall:
	flatpak $(USER) uninstall $(ID)

run:
	flatpak run $(ID)

clean-build:
	$(RM) -r $(BUILD_DIR)

clean: clean-build
	$(RM) $(BUNDLE)

.PHONY: all clean clean-build

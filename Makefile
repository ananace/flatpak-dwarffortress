ID := com.bay12games.DwarfFortress
BUNDLE := dwarffortress.flatpak

USER := --user
BUILD_DIR ?= build
REPO ?= repo

ARCH ?= $(shell uname -m)
BRANCH ?= 0.43.05

MANIFEST = $(ID).json

all: build

build:
	flatpak-builder --arch=$(ARCH) --repo $(REPO) $(BUILD_DIR) $(MANIFEST)

$(BUNDLE): build
	flatpak build-bundle --arch=$(ARCH) $(REPO) $(BUNDLE) $(ID) $(BRANCH)

install: $(BUNDLE)
	flatpak $(USER) install --arch=$(ARCH) --bundle $(BUNDLE)

uninstall:
	flatpak $(USER) uninstall --arch=$(ARCH) $(ID) $(BRANCH)

run:
	flatpak run --arch=$(ARCH) --branch=$(BRANCH) $(ID)

clean-build:
	$(RM) -r $(BUILD_DIR)

clean: clean-build
	$(RM) $(BUNDLE)

.PHONY: all clean clean-build

ID := com.bay12games.DwarfFortress
BUNDLE := dwarffortress.flatpak

USER := --user
BUILD_DIR ?= build
REPO ?= repo

ARCH ?= $(shell uname -m)
BRANCH ?= 0.43.05

MANIFEST = $(ID).json

all: build

build: deps
	flatpak-builder --force-clean --arch=$(ARCH) --repo=$(REPO) --ccache --require-changes $(BUILD_DIR) $(MANIFEST)
	flatpak build-update-repo $(REPO)

deps:
	flatpak $(USER) remote-add --if-not-exists gnome --from https://sdk.gnome.org/gnome.flatpakrepo
	flatpak $(USER) install gnome org.gnome.Platform//3.24 org.gnome.Sdk//3.24 || true

$(BUNDLE): build
	flatpak build-bundle --arch=$(ARCH) $(REPO) $(BUNDLE) $(ID) $(BRANCH)

bundle: $(BUNDLE)

install-repo: build
	flatpak --user remote-add --no-gpg-verify --if-not-exists local-dwarffortress repo
	flatpak --user install local-dwarffortress $(ID)/$(ARCH)/$(BRANCH)

install: build
	flatpak $(USER) install --arch=$(ARCH) --bundle $(BUNDLE)

uninstall:
	flatpak $(USER) uninstall --arch=$(ARCH) $(ID) $(BRANCH)

run:
	flatpak run --arch=$(ARCH) --branch=$(BRANCH) $(ID)

clean:
	$(RM) -r $(BUILD_DIR)
	$(RM) $(BUNDLE)

.PHONY: all build bundle clean clean-build deps

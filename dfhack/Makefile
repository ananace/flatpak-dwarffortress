override ID       := com.bay12games.DwarfFortress.dfhack
override MANIFEST := $(ID).json

ARCH     := $(shell uname -m)
DF_VER   :=
HACK_VER :=

USER     := --user
REPO     := repo
GPG_KEY  :=

releases:
	make release DF_VER=0.43.03 HACK_VER=r1 ARCH=i386 REPO=repo-release GPG_KEY=$(GPG_KEY)
	make release DF_VER=0.43.05 HACK_VER=beta3 ARCH=i386 REPO=repo-release GPG_KEY=$(GPG_KEY)
	make release DF_VER=0.43.05 HACK_VER=beta3 ARCH=x86_64 REPO=repo-release GPG_KEY=$(GPG_KEY)

all: build

$(MANIFEST): $(MANIFEST).in
	if [ -z "$(DF_VER)" ] || [ -z "$(HACK_VER)" ]; then echo "You need to specify the Dwarf Fortress and DFHack versions to use"; exit 1; fi
	sed -e 's/@DF_VER@/$(DF_VER)/' -e 's/@HACK_VER@/$(HACK_VER)/' $< > $@

$(REPO):
	ostree init --mode=archive-z2 --repo=$(REPO)

deps:
	flatpak $(USER) remote-add --if-not-exists gnome --from https://sdk.gnome.org/gnome.flatpakrepo
	flatpak $(USER) install gnome org.gnome.Platform/$(ARCH)/3.24 org.gnome.Sdk/$(ARCH)/3.24 || true

build: deps $(MANIFEST) $(REPO)
	flatpak-builder --force-clean --arch=$(ARCH) --repo=$(REPO) --ccache --require-changes build $(MANIFEST)
	flatpak build-update-repo $(REPO)

release: deps $(MANIFEST) $(REPO)
	flatpak-builder --force-clean --arch=$(ARCH) --repo=$(REPO) --ccache --gpg-sign=$(GPG_KEY) build $(MANIFEST)
	flatpak build-update-repo --generate-static-deltas --gpg-sign=$(GPG_KEY) $(REPO)

.PHONY: all build release $(MANIFEST)

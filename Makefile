override BUNDLE   := dwarffortress.flatpak
override ID       := com.bay12games.DwarfFortress
override MANIFEST := $(ID).json
override USER     := --user

ARCH      ?= $(shell uname -m)
BRANCH    ?= 0.43.05
BUILD_DIR ?= build
REPO      ?= repo

# TODO: Make a generator script for this instead of having a messy makefile
ifeq ($(BRANCH),0.43.05)
ifeq ($(ARCH),x86_64)
	EXTRA_DATA = 856c13170e8beefb5419ae71ee26c85db9716b3ebd4c7348aa44b896bd490be4:11580594::http://bay12games.com/dwarves/df_43_05_linux.tar.bz2
else
	EXTRA_DATA = 0334e6b35ecc36949f5c60ffc1eb46fade3365b55a44f2e11fd4ae799ba7819a:12158550::http://bay12games.com/dwarves/df_43_05_linux32.tar.bz2
endif
else ifeq ($(BRANCH),0.43.03)
ifeq ($(ARCH),i386)
	EXTRA_DATA = 8725cb00188b4282fd5a3c4be10c3255f837b951ca48af90fa3a351e3a818337:13970214::http://bay12games.com/dwarves/df_43_03_linux.tar.bz2
else
	$(error Dwarf Fortress 0.43.03 and earlier only support 32-bit environments)
endif
else
	$(error Only Dwarf Fortress 0.43.03 and 0.43.05 can be built at the moment)
endif

all: build

$(MANIFEST): $(MANIFEST).in
	sed -e 's/@BRANCH@/$(BRANCH)/' -e 's|@EXTRA_DATA@|$(EXTRA_DATA)|' $< > $@

build: deps $(MANIFEST)
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

.PHONY: all build bundle clean clean-build deps $(MANIFEST)

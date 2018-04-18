override BUNDLE   := dwarffortress.flatpak
override ID       := com.bay12games.DwarfFortress
override MANIFEST := $(ID).json
override REL_REPO = $(REPO)-release

ARCH         := $(shell uname -m)
BRANCH       := 0.44.07
BUILD_DIR    := build
BUILDER_ARGS :=
REPO         := repo
SHELL        := bash # To support the 'echo -e'
USER         := --user

# TODO: Make a generator script for this instead of having a messy makefile
ifeq ($(BRANCH),0.44.07)
ifeq ($(ARCH),x86_64)
	EXTRA_DATA = 2b41550b486ebfdb7972f730607f7ed9e192c9b31633454606134eb2e57f25b6:11999119::http://bay12games.com/dwarves/df_44_07_linux.tar.bz2
else
	EXTRA_DATA = 347736edcd10a2506a29ea2acadaa27c2ad019f13f453830f141006d8ea72806:12613293::http://bay12games.com/dwarves/df_44_07_linux32.tar.bz2
endif
else ifeq ($(BRANCH),0.44.02)
ifeq ($(ARCH),x86_64)
	EXTRA_DATA = 504d0d9ea7d11d64cae0444ee2589bc4afdda7fbb5bb1276ddacac2ebb364bf0:11940967::http://bay12games.com/dwarves/df_44_02_linux.tar.bz2
else
	EXTRA_DATA = d0721cd577fcc14729b76754c30feb6fda7029275bb0a9b1f6bca940fd9b1ffb:12542806::http://bay12games.com/dwarves/df_44_02_linux32.tar.bz2
endif
else ifeq ($(BRANCH),0.43.05)
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

dwarffortress.flatpakref: dwarffortress.flatpakref.in
	sed -e 's|@BRANCH@|$(BRANCH)|' -e 's|@URL@|$(URL)|' -e 's|@GPG@|$(shell gpg2 --export $(GPG_KEY) | base64 -w0)|' $< > $@

deps:
	flatpak $(USER) remote-add --if-not-exists flathub --from https://flathub.org/repo/flathub.flatpakrepo
	flatpak $(USER) install -y gnome org.gnome.Platform/$(ARCH)/3.28 org.gnome.Sdk/$(ARCH)/3.28 || true
	if [ "$(shell echo -e "0.9.2\n$$(flatpak --version | awk '{print $$2}')" | sort -V | tail -n1)" = "0.9.2" ]; then cp deps/*.patch .; fi

$(REPO):
	ostree init --mode=archive-z2 --repo=$(REPO)

$(REL_REPO):
	ostree init --mode=archive-z2 --repo=$(REL_REPO)

build: deps $(MANIFEST) $(REPO)
	if [ "$(shell echo -e "0.9.2\n$$(flatpak --version | awk '{print $$2}')" | sort -V | tail -n1)" = "0.9.2" ]; then cp dfhack/*.desktop .; fi
	flatpak-builder $(BUILDER_ARGS) --force-clean --arch=$(ARCH) --repo=$(REPO) --ccache --require-changes $(BUILD_DIR) $(MANIFEST)
	flatpak build-update-repo $(REPO)

release: deps $(MANIFEST) $(REL_REPO)
	if [ -z "$(GPG_KEY)" ]; then echo "Must provide a GPG key to build a release version"; exit 1; fi
	flatpak-builder $(BUILDER_ARGS) --force-clean --arch=$(ARCH) --repo=$(REL_REPO) --ccache --gpg-sign=$(GPG_KEY) $(BUILD_DIR) $(MANIFEST)
	flatpak build-update-repo --generate-static-deltas --gpg-sign=$(GPG_KEY) $(REL_REPO)

$(BUNDLE): build
	flatpak build-bundle --arch=$(ARCH) $(REPO) $(BUNDLE) $(ID) $(BRANCH)

install-repo: build
	flatpak --user remote-add --no-gpg-verify --if-not-exists local-dwarffortress repo
	flatpak --user install local-dwarffortress $(ID)/$(ARCH)/$(BRANCH)

clean:
	$(RM) -r $(BUILD_DIR)
	$(RM) $(BUNDLE)

.PHONY: all build bundle clean deps $(MANIFEST)

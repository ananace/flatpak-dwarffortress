SKIP_BUILD = g_src/find_files.cpp g_src/ g_src/music_and_sound.cpp \
			 g_src/music_and_sound_fmodex.cpp g_src/renderer_curses.cpp

G_SRCS := $(filter-out $(SKIP_BUILD),$(wildcard g_src/*.cpp))
G_OBJS := $(G_SRCS:.cpp=.o)

CXX ?= g++
PKG_CONFIG ?= pkg-config

LIBS := ncursesw openal sndfile
RLIBS := glew glu gtk+-2.0 sdl SDL_image SDL_ttf zlib
CXXFLAGS ?= -O0 -pipe -Wall -Wextra
CXXFLAGS += $(shell $(PKG_CONFIG) --cflags $(LIBS) $(RLIBS)) -Dunix -Dlinux -fPIC -std=c++11 -D_GLIBCXX_USE_CXX11_ABI=0
LDFLAGS := $(shell $(PKG_CONFIG) --libs $(RLIBS))

LIBGRAPHICS = libs/libgraphics.so

INSTALL_PATH = /app/dwarf-fortress/
DF_APPLICATION = /app/bin/dwarf-fortress.bin
DF_DESKTOP = /app/share/applications/com.bay12games.DwarfFortress.desktop
DF_ICON = /app/share/icons/hicolor/256x256/apps/com.bay12games.DwarfFortress.png

all: $(LIBGRAPHICS)

$(LIBGRAPHICS): $(G_OBJS)
	$(CXX) -shared $(CXXFLAGS) $(LDFLAGS) $(G_OBJS) -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(INSTALL_PATH):
	mkdir -p $(@D)
	mv -t $(@D) *.txt README.linux data libs raw sdl

$(DF_APPLICATION):
	mkdir -p $(@D)
	mv $(@F) $@
	chmod +x $(@)

$(DF_DESKTOP):
	mkdir -p $(@D)
	mv $(@F) $@	

$(DF_ICON):
	mkdir -p $(@D)
	mv $(@F) $@	

pre-install:
	$(RM) -r g_src/
	$(RM) Makefile

install: $(LIBGRAPHICS) pre-install $(DF_APPLICATION) $(DF_DESKTOP) $(DF_ICON) $(INSTALL_PATH)

clean:
	$(RM) $(LIBGRAPHICS) $(G_OBJS)

.PHONY: all install pre-install

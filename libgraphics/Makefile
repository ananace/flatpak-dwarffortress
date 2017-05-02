SKIP_BUILD = g_src/find_files.cpp g_src/ g_src/music_and_sound.cpp \
             g_src/music_and_sound_fmodex.cpp g_src/renderer_curses.cpp \
             g_src/tetris.cpp

G_SRCS := $(filter-out $(SKIP_BUILD),$(wildcard g_src/*.cpp))
G_OBJS := $(G_SRCS:.cpp=.o)

PREFIX = /app
CXX ?= g++
PKG_CONFIG ?= pkg-config

LIBS := ncursesw openal sndfile
RLIBS := glew glu gtk+-2.0 sdl SDL_image SDL_ttf zlib
CXXFLAGS ?= -O2 -pipe -Wall -Wextra
CXXFLAGS += $(shell $(PKG_CONFIG) --cflags $(LIBS) $(RLIBS)) -Dunix -Dlinux -fPIC -std=c++11 -D_GLIBCXX_USE_CXX11_ABI=0
LDFLAGS := $(shell $(PKG_CONFIG) --libs $(RLIBS))

all: libgraphics.so

libgraphics.so: $(G_OBJS)
	$(CXX) -shared $(CXXFLAGS) $(LDFLAGS) $(G_OBJS) -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

install:
	install -m 0644 libgraphics.so $(PREFIX)/lib

clean:
	$(RM) $(LIBGRAPHICS) $(G_OBJS)

.PHONY: all clean install

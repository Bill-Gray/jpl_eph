# Makefile for gcc (and MinGW,  and clang)
# Usage: make [CLANG=Y] [W64=Y] [W32=Y] [MSWIN=Y] [tgt]
#
# [all|asc2eph|dump_eph|eph2asc|ftest|merge_de|testeph|sub_eph]
#
# Note 'all' does _not_ build 'sub_eph'.  'sub_eph', depends on the 'lunar'
# library,  available at https://github.com/Bill-Gray/lunar .  Get that,
# make and 'make install' it,  and _then_ do 'make sub_eph' if you really
# need the ability to extract a section of a DE ephemeris file.
#
#	'W32'/'W64' = cross-compile for 32- or 64-bit Windows,  using MinGW,
#        on a Linux/BSD box
#	'MSWIN' = compile for Windows,  using MinGW,  on a Windows machine
#	'CLANG' = use clang instead of GCC;  Linux/BSD only
# None of these: compile using g++ on Linux or BSD

# As CC is an implicit variable, a simple CC?=g++ doesn't work.
# We have to use this trick from https://stackoverflow.com/a/42958970
ifeq ($(origin CC),default)
	CC=gcc
	CPP=g++
endif
CFLAGS+=-Wall -O3 -Wextra -Werror -pedantic -I $(INSTALL_DIR)/include $(ADDED_CFLAGS)
RM=rm -f
LIB=-lm

ifdef DEBUG
	CFLAGS += -g
else
	CFLAGS += -DNDEBUG
endif

ifdef UCHAR
	CFLAGS += -funsigned-char
endif

# You can have your include files in ~/include and libraries in
# ~/lib,  in which case only the current user can use them;  or
# (with root privileges) you can install them to /usr/local/include
# and /usr/local/lib for all to enjoy.

PREFIX?=~
ifdef GLOBAL
	INSTALL_DIR=/usr/local
else
	INSTALL_DIR=$(PREFIX)
endif

ifdef CLANG
	CC=clang
	CPP=clang
endif


# I'm using 'mkdir -p' to avoid error messages if the directory exists.
# It may fail on very old systems,  and will probably fail on non-POSIX
# systems.  If so,  change to '-mkdir' and ignore errors.

ifdef MSWIN
	EXE=.exe
	MKDIR=-mkdir
else
	MKDIR=mkdir -p
endif

LIB_DIR=$(INSTALL_DIR)/lib

ifdef W64
	CC=x86_64-w64-mingw32-gcc
	CPP=x86_64-w64-mingw32-g++
 LIB_DIR=$(INSTALL_DIR)/win_lib
	EXE=.exe
endif

ifdef W32
	CC=i686-w64-mingw32-gcc
	CPP=i686-w64-mingw32-g++
 LIB_DIR=$(INSTALL_DIR)/win_lib32
	EXE=.exe
endif

all: asc2eph$(EXE) dump_eph$(EXE) eph2$(EXE) eph2asc$(EXE) ftest$(EXE) masses$(EXE) merge_de$(EXE) testeph$(EXE)

install:
	$(MKDIR) $(INSTALL_DIR)/include
	cp jpleph.h $(INSTALL_DIR)/include
	$(MKDIR) $(LIB_DIR)
	cp libjpl.a $(LIB_DIR)

uninstall:
	-rm $(INSTALL_DIR)/include/jpleph.h
	-rm $(LIB_DIR)/libjpl.a

libjpl.a: jpleph.o
	-$(RM) libjpl.a
	ar rv libjpl.a jpleph.o

.cpp.o:
	$(CPP) $(CPPFLAGS) $(CFLAGS) -c $<

.c.o:
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

asc2eph$(EXE):          asc2eph.o f_strtod.o
	$(CC) -o asc2eph$(EXE) asc2eph.o f_strtod.o $(LIB) $(LDFLAGS)

ftest$(EXE):          ftest.o f_strtod.o
	$(CC) -o ftest$(EXE) ftest.o f_strtod.o $(LDFLAGS)

eph2asc$(EXE):          eph2asc.o libjpl.a
	$(CC) -o eph2asc$(EXE) eph2asc.o libjpl.a $(LIB) $(LDFLAGS)

eph2$(EXE):             eph2.o libjpl.a
	$(CC) -o eph2$(EXE)    eph2.o libjpl.a $(LIB) $(LDFLAGS)

dump_eph$(EXE):          dump_eph.o libjpl.a
	$(CC) -o dump_eph$(EXE) dump_eph.o libjpl.a $(LIB) $(LDFLAGS)

masses$(EXE):          masses.o libjpl.a
	$(CC) -o masses$(EXE) masses.o libjpl.a $(LIB) $(LDFLAGS)

merge_de$(EXE):          merge_de.o libjpl.a
	$(CC) -o merge_de$(EXE) merge_de.o libjpl.a $(LIB) $(LDFLAGS)

sub_eph$(EXE):          sub_eph.o libjpl.a
	$(CC) -o sub_eph$(EXE) sub_eph.o libjpl.a -L $(LIB_DIR) -llunar $(LIB) $(LDFLAGS)

sub_eph.o: sub_eph.cpp
	$(CPP) $(CPPFLAGS) $(CFLAGS) -c -DTEST_MAIN sub_eph.cpp

testeph$(EXE):          testeph.o libjpl.a
	$(CC) -o testeph$(EXE) testeph.o libjpl.a $(LIB) $(LDFLAGS)

clean:
	$(RM) *.o
	$(RM) asc2eph$(EXE)
	$(RM) dump_eph$(EXE)
	$(RM) eph2asc$(EXE)
	$(RM) eph2$(EXE)
	$(RM) ftest$(EXE)
	$(RM) masses$(EXE)
	$(RM) merge_de$(EXE)
	$(RM) sub_eph$(EXE)
	$(RM) testeph$(EXE)
	$(RM) libjpl.a

# Gawk for the ipod.
#
# Cleaned up the Makfile. WHY do people insist on using GNU's Makefile tools?!
#
# Use it like a normal gawk. Becuase it is.
# 

srcdir = .

CC = arm-uclinux-elf-gcc
YACC = bison -y
LIBS = -lm 

LN = ln
LN_S = ln -s

DEFPATH = ".:$(datadir)"

CFLAGS = -g -O2 -Wl,-elf2flt
LDFLAGS = -O2 -Wl,-elf2flt

COMPFLAGS = $(CFLAGS) -DGAWK -I. -I$(srcdir) -DHAVE_CONFIG_H

# object files
AWKOBJS = array.o builtin.o eval.o field.o gawkmisc.o io.o main.o \
	missing.o msg.o node.o re.o version.o

ALLOBJS = $(AWKOBJS) awktab.o

# LIBOBJS
#	GNU and other stuff that gawk uses as library routines.
LIBOBJS= getopt.o getopt1.o regex.o dfa.o random.o $(ALLOCA)

# source and documentation files
SRC = array.c builtin.c eval.c field.c gawkmisc.c io.c main.c \
	missing.c msg.c node.c re.c version.c

ALLSRC= $(SRC) awktab.c

AWKSRC= awk.h awk.y custom.h $(ALLSRC) patchlevel.h protos.h random.h

LIBSRC = alloca.c dfa.c dfa.h regex.c regex.h getopt.h getopt.c getopt1.c random.c

COPIES = missing/system.c missing/tzset.c \
	missing/memcmp.c missing/memcpy.c missing/memset.c \
	missing/strncasecmp.c missing/strchr.c \
	missing/strerror.c missing/strtod.c \
	missing/strftime.c missing/strftime.3 
	
# Release of gawk.  There can be no leading or trailing white space here!
REL=3.0

# clear out suffixes list
.SUFFIXES:
.SUFFIXES: .c .o

.c.o:
	$(CC) -c $(COMPFLAGS) $<

# rules to build gawk
all:	gawk

config.h:	stamp-h

gawk:	$(ALLOBJS) $(LIBOBJS) $(REOBJS)
	$(CC) -o gawk $(LDFLAGS) $(ALLOBJS) $(LIBOBJS) $(REOBJS) $(LIBS)

$(ALLOBJS):	awk.h dfa.h regex.h config.h custom.h

$(LIBOBJS):	config.h custom.h

gawkmisc.o:	$(srcdir)
	$(CC) -c $(COMPFLAGS) -DDEFPATH='$(DEFPATH)' $(srcdir)/gawkmisc.c

getopt.o:	getopt.h

getopt1.o:	getopt.h

builtin.o: random.h

main.o:	patchlevel.h

awktab.c:	awk.y
	$(YACC) -v $(srcdir)/awk.y && \
	if test -f y.tab.c ; then mv y.tab.c ytab.c ; else true ; fi && \
	sed '/^extern char .malloc(), .realloc();$$/d' ytab.c >awktab.c && \
	rm ytab.c

# VMS POSIX make won't apply the default .c.o rule to awktab.o for some reason
awktab.o:	awktab.c awk.h
	$(CC) -c $(COMPFLAGS) $(srcdir)/awktab.c

alloca.o:	alloca.c


clean:
	rm -rf gawk *.o core y.output gawk.gdb
	cd test && $(MAKE) clean
	cd awklib && $(MAKE) clean

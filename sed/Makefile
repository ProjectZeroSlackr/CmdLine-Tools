# This is sed for the ipod.
#
# Cleaned up Makefile. WHY do people insist on using GNU's Makefile tools?!
#
# Anyway, use sed like you normally would.
#


srcdir = .
VPATH = .

CC = arm-uclinux-elf-gcc

DEFS =  -DSTDC_HEADERS=1 -DHAVE_STRING_H=1 -DHAVE_BCOPY=1 -DHAVE_MEMCPY=1 -DHAVE_ALLOCA_H=1
LIBS = 

CFLAGS = -g -Wl,-elf2flt
LDFLAGS = -g -Wl,-elf2flt

objs = sed.o utils.o rx.o getopt.o getopt1.o
srcs = sed.c utils.c rx.c getopt.c getopt1.c alloca.c

distfiles = COPYING COPYING.LIB ChangeLog README ABOUT.RX INSTALL Makefile.in \
  configure configure.in rx.h getopt.h $(srcs)

all_objs= $(objs) $(extra_objs)
all:	sed

.c.o:
	$(CC)   -c $(CPPFLAGS) $(DEFS) $(CFLAGS) -I$(srcdir) $<

sed:	$(all_objs)
	$(CC) -o $@ $(LDFLAGS) $(objs) $(LIBS)

sed.o rx.o: rx.h 
sed.o getopt1.o: getopt.h

clean:
	rm -f sed *.o core

alloca.o : alloca.c 

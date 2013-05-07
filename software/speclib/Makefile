
CFLAGS = -ggdb -Wall
LDFLAGS = -L. -lspec

LIB = libspec.a
LIBOBJ = speclib.o loader-ll.o

PROGS = spec-cl spec-fwloader spec-vuart # specmem


all: $(LIB) $(PROGS)

$(PROGS): $(LIB)

$(LIB): $(LIBOBJ)
	ar r $@ $^

loader-ll.o:	../kernel/loader-ll.c
		${CC} -c $^ -I .

clean:
	rm -f *.o $(LIB) $(PROGS) *~
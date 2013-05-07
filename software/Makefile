
OBJS = ad9516.o speclib/speclib.o filters.o

CFLAGS = -I../include -g -Imini_bone -Ispeclib -I.


all:	$(OBJS)
	gcc -o rf-test $(OBJS) -lm

clean:	
	rm -f $(OBJS) rf-test

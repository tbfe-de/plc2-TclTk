# Makefile to create loadable version (for tclsh) and
# stand-alone executable to try ackermann function
#
TCL_INCLUDES=/usr/include/tcl8.5
ackermann.so: ackermann.c ackermann_wrap.c
	gcc -O2 -shared -fPIC -I$(TCL_INCLUDES) ackermann.c ackermann_wrap.c -o $@
ackermann_wrap.c: ackermann.i
	swig -tcl ackermann.i
ackermann: ackermann.c
	gcc -O2 -DMAIN ackermann.c -o $@
clean:
	rm -f a.out core *.o ackermann_wrap.c
realclean: clean
	rm -f ackermann.so ackermann
        

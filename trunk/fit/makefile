LIBS = $(HOME)/LIBS
EXEC = $(HOME)/bin
BSLIO = $(LIBS)/bsl/dev/bslio.a
MLIB = $(LIBS)/sol/mlib.a
IOLIB = $(LIBS)/sol/iolib.a
OTLIB = $(HOME)/ccp13dist/libs/sos5/libotoko.a
X11INCLUDE = /usr/openwin/include
PGDIR = $(HOME)/pgplot5.1/solaris
PGLIB = -lpgplot -Bdynamic
#
FCOMP = -g
CCOMP = -g  -I$(X11INCLUDE)
FLINK = -Bstatic
#
CSOURCE = image.c scale_image.c putimage.c getimage.c XfDraw.c
HEADERS = fiximage.h fixextern.h fixproto.h fixdefs.h XfDraw.h
#
FIXFORT = PGFIX.f CENTRE.f CIRFIT.f CTILT.f EVPOLY.f FTOSTD.f LIST.f \
	REDUCE.f REPLACE.f ROTATE.f STOREC.f FLIST.f INTEG.f PGLINES.f \
	REFALL.f REFPAR.f RECIP.f RECTOFF.f
FIXINCL = FIXPAR.COM
#
FITFORT = PGFIT.f GETOTO.f
FITINCL = FIT.COM
#
COMFORT = PGFPLOT.f FUNCS.f FGAUSS.f FLORENTZ.f FPEARSON.f FPOLY.f \
	FVOIGT.f PSNINT.f VGTINT.f FDEBYE.f FDEXP.f FLEIB.f
#
COBJS = $(CSOURCE:.c=.o)
FIXOBJS = $(FIXFORT:.f=.o)
COMOBJS = $(COMFORT:.f=.o)
FITOBJS = $(FITFORT:.f=.o)
#
all: fixdev fitdev
#
fixdev: $(FIXOBJS) $(COMOBJS) $(COBJS)
	f77 -o $(EXEC)/$@ $(FIXOBJS) $(COMOBJS) $(COBJS) \
	$(MLIB) $(IOLIB) $(BSLIO) \
	-L$(PGDIR) $(PGLIB) -lX11 -ltermcap -B static
#
lfit: $(FITOBJS) $(COMOBJS)
	f77 -g -o $(EXEC)/$@  $(FLINK) $(FITOBJS) $(COMOBJS) \
	$(MLIB) $(IOLIB) $(OTLIB) \
	-L$(PGDIR) $(PGLIB) -lX11 -lcurses -ltermlib
#
$(COBJS): $(CSOURCE) $(HEADERS)
$(FIXOBJS): $(FIXFORT) $(FIXINCL)
$(FITOBJS): $(FITFORT) $(FITINCL)
$(COMOBJS): $(COMFORT) $(FITINCL)
#

.c.o:
	$(CC) -c $(CCOMP) $<
.f.o:
	$(FC) -c $(FCOMP) $<
#
clean:
	/bin/rm $(COBJS) $(FIXOBJS) $(COMOBJS)
#




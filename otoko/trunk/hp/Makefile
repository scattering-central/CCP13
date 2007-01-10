# Makefile for OTOKO.
# 28/09/89 GRM initial implementation 

PROGRAM   = otoko
PROGRAMX  = xotoko
INSTALDIR = ../../bin-hp/
LIBRARY   = ./otoko.a
XDISTRIB  = /usr/lib/X11R5
GHOSTLIB  = /nfs/ncdfs1/usr2/ghost/hp/lib
CC = cc

OBJS      = \
	aamain.o   absval.o   add.o      addcon.o   addnrm.o \
	algthm.o   aplot.o    askno.o    askyes.o   averag.o \
	back.o     besj.o     bsort.o    change.o   coplot.o \
	cosine.o   cosqt.o    cpk.o      cross.o    cumsum.o \
	cut.o      dawrt.o    deriv.o    deriv2.o   divcon.o \
	divide.o   divnrm.o   eofchar.o  errmsg.o \
	expon.o    fft1d.o    fill.o     fit.o      fjoin.o \
	fpk.o      fractn.o   frdata.o   frplot.o   frwfft.o \
	funct.o    g0plax.o   g0play.o   g0plyl.o   genfrm.o \
	genfun.o   getchn.o   getfil.o   gethdr.o   getins.o \
	getval.o   getxax.o   grmode.o   guinier.o  hdrgen.o \
	igets.o    iniplo.o   integ.o    interp.o   intseq.o \
	invfft.o   invlat.o   latice.o   length.o   linfit.o \
	logthm.o   lsq.o      maxval.o   merge.o    minmax.o \
	mirror.o   mplot.o    mulcon.o   mulnrm.o   mult.o \
	nback.o    oddeven.o  opnfil.o   optim.o    ot3plo.o \
	outfil.o   pack.o     pcc.o      peak.o     pekdes.o \
	pkk.o      plot.o     plot3d.o   ploton.o   pnt.o \
	poe.o      polcal.o   polnom.o   power.o    process.o \
	prtval.o   rback.o    rdhdr.o    remap.o    remzer.o \
	savplo.o   sback.o    select.o   sft.o      sft1d.o \
	shift.o    sine.o     sit.o      smooth.o   sort.o \
	spline.o   subnrm.o   sum.o      tg01b.o    trmode.o \
	upcase.o   vb06a.o    vc01a.o    vc03a.o    windo.o \
	xaxgen.o   xshift.o   zero.o     genitp.o   mulpnt.o \
	addfil.o   gauss.o    igets.o    flush.o    plotns.o


LIBS      = -L$(GHOSTLIB) -lghost -lgrid_t4010em -lt4010em
XLIBS     = -L$(GHOSTLIB) -lghost -lgrid_xghost -L$(XDISTRIB) -lX11
MLIBS     = -lcurses -ltermlib

CFLAGS    = -Dhpux -Aa
FFLAGS    = +O2
FORTRAN   = fort77
ARFLAGS   = rsv

.PRECIOUS: 	$(LIBRARY)
.SUFFIXES: .F

all:		library version xversion

version:	$(PROGRAM)

xversion:	$(PROGRAMX)

install:	
		mv $(PROGRAM)  $(INSTALDIR)
		chmod 711 $(INSTALDIR)/$(PROGRAM)

installx:	
		mv $(PROGRAMX) $(INSTALDIR)
		chmod 711 $(INSTALDIR)/$(PROGRAMX)

library:	$(OBJS)
		mv aamain.o aamain.oo
		ar $(ARFLAGS) $(LIBRARY) *.o
		mv aamain.oo aamain.o

clean:
		rm -f $(OBJS)

$(PROGRAM):	$(OBJS)
		$(FORTRAN) $(FFLAGS) -o $(PROGRAM) $(OBJS) $(LIBS) $(MLIBS) 

$(PROGRAMX):	$(OBJS)
		$(FORTRAN) $(FFLAGS) -o $(PROGRAMX) $(OBJS) $(XLIBS) $(MLIBS)


.f.o:
	$(FORTRAN) $(FFLAGS) -c $<

.F.o:
	/usr/ccs/lbin/cpp -P -Dhpux $< tmp.f
	$(FORTRAN) $(FFLAGS) -c tmp.f
	mv tmp.o $@
	rm tmp.f




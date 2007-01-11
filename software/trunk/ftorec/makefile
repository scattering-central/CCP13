FC = f77
FCOMP = -O
FLINK = 
#
EXEC = ../bin
BSLIO = ../libs/bslio.a
IOLIB = ../libs/iolib.a
#
FORT = FTOREC.f PARINP.f SETUP.f FILARR.f ARRFIL.f RECOUT.f ARSET.f AISET.f \
	CORTAB.f RECIP.f RECTOFF.f REVDAT.f
OBJS = $(FORT:.f=.o)
#
all: ftorec clean
#
ftorec: $(OBJS)
	$(FC) -o $(EXEC)/$@ $(FLINK) \
	$(OBJS) $(IOLIB) $(BSLIO) -ltermcap
#
.f.o:
	$(FC) -c $(FCOMP) $<
#
clean:
	/bin/rm $(OBJS)
#

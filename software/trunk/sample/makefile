FC = g77
FCOMP = -O
FLINK =
#
EXEC =.
BSLIO = C:/MinGW/home/libs/bin/bslio.a
IOLIB = C:/MinGW/home/libs/bin/iolib.a
MLIB = C:/MinGW/home/libs/bin/mlib.a
TERM = /lib/libtermcap.a -ltermcap
FORT = SAMPLE.f ROOTJ.f BESSD.f NMIN.f KCOF.f
OBJS = $(FORT:.f=.o)
#
all: sample clean
#
sample: $(OBJS)
	$(FC) -o $(EXEC)/$@ $(FLINK) \
	$(OBJS) $(MLIB) $(IOLIB) $(BSLIO) 
#
.f.o:
	$(FC) -c $(FCOMP) $<
#
clean:
	/bin/rm $(OBJS)
#

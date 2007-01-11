C     LAST UPDATE 25/08/02
C TF: 25.08.02 - recompiled with RCD's modified version of DLSQFIT
C     (DLSQFIT_aug02.f - see comments in source code - this version
C      outputs the covariance matrix from least squares runs)
C TF: 06.08.02 - recompiled with RCD's modified version of LMAXENT 
C     (LMAXENT_aug02.f -see comments in source code)
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      PROGRAM LSQINT
      IMPLICIT NONE
C
C Purpose: LSQINT provides an automatic method of intensity integration
C          for fibre diffraction patterns with options for background 
C          subtraction. The first stage is to calculate profiles for 
C          either Bragg sampled or continuous layer-line intensity.
C          A linear least-squares fitting procedure or a maximum 
C          entropy method is used to scale the profiles to the observed
C          data.
C
C          The fitted scale factors are then the integrated intensities.
C          It is then possible to refine the cell parameters and the
C          parameters defining the profiles by fixing the scale factors
C          and optimizing the fit by using Brent's PRAXIS method.
C          This process can be iterated with the profile
C          fitting to form an overall refinement procedure. 
C
C Calls  21: GETHDR, IMSIZE, RDCOMF, OUTFIL, DRAGON, OPNFIL, RFRAME,
C            BGCSYM, BGWSRT, BGWLSH, BGWLSI, GETBSL, DLSQFIT,LMAXENT, 
C            REPROF, REPORT, OPNNEW, ALLOUT, IMGCAL, WFRAME, RDINT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER MAXALL,MAXLAT,MAXDAT
      PARAMETER(MAXALL=50,MAXLAT=3,MAXDAT=262144)
      INTEGER NLLPX,JWIDTHAV,IPOINTX,IWIDTHAV,MPOINTX 
      PARAMETER(NLLPX=10000,JWIDTHAV=50)
      PARAMETER(IPOINTX=JWIDTHAV*NLLPX,IWIDTHAV=30)
      PARAMETER(MPOINTX=IWIDTHAV*IPOINTX)
C
C Local arrays:
C
      REAL RCELL(6),CELL(6),VALUES(10),PR(MAXALL),PINC(MAXALL)
      REAL B(MAXDAT),BB(MAXDAT),SIG(NLLPX+8)
      REAL PC1(5),PC2(5),SMOO(5),TENS(5)
      INTEGER IWID(5),JWID(5),ISEP(5),JSEP(5)
      INTEGER ITEM(20)
      CHARACTER*20 WORD(10),LABEL
C
C Local scalars:
C
      REAL A0,S0,R0,Z0,D0,T0,Q0,Q1,Q2,RFAC,DTOR,FTOL,DEF,RSCL,TCON,
     &     CFAC,SMIN,SFAC,PHIZ,PHIX,DMXDEF
      INTEGER I,II,J,IJ,IH,IK,IL,IFIT,ITMAX,MUL,MFD,NWORD,NVAL,MEITS
      INTEGER IRC,KPIC,IFRAME,IHFMAX,IFRMAX,NFRAME,NR,NZ,ICFRAME
      INTEGER IMEM,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
      INTEGER IHED,IDAT,IOUT,ICAL,NP,NWSTRT,NBACK
      INTEGER NPAR,MAXBUF,NPSD,NRSD,NSIZE
C++++++++The following need to be integer*8 on 64-bit machines++++++++++
      INTEGER NBUF,NBUF1,NBUF2
      INTEGER IBUF1,IBUF2,IBUF3,IBUF4,IBUF5,IBUF6,IBUF7,IBUF8,IBUF9
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      LOGICAL NEXT,BRAG,CONT,REFINE,CSTAR,CALC,NOFIT,SETZ,
     &        ENTROPY,FILEIN,PRECOM,FSIGMA
      CHARACTER*80 HEAD1,CHEAD1,CHEAD2,OUTBRG,NOFILE
      CHARACTER*20 ISGP,DFILE
      CHARACTER*13 HFNAM,CFNAM
      CHARACTER*4 CTYPE
      CHARACTER*1 CH
C
C Common arrays:
C
      REAL ALLINE(NLLPX+8),PSIG(MAXDAT),AD(MAXDAT)
      REAL ALLCEL(6,MAXLAT),LATLIM(6,MAXLAT),RADMM(MAXLAT)
      REAL SNORM(MAXLAT),SSCALE(NLLPX)
      INTEGER IHKL(4,NLLPX),INFO(3),ISIZE(5),MINFO(5,MAXLAT),
     &        MSIZE(5,MAXLAT),MBESS(MAXLAT),MLDIV(MAXLAT)
      INTEGER*2 JMIN(NLLPX),JMAX(NLLPX),IMIN(IPOINTX),IMAX(IPOINTX)
      CHARACTER*1 IDCIN(MPOINTX)
C
C Common scalars:
C
      REAL DELR,RMIN,DELZ,ZMIN
      REAL DMIN,DMAX,RADM,SN
      INTEGER IAMIN,IAMAX,JAMIN,JAMAX,NPIX,NRAST,IBACK,NLAT
      INTEGER L1,L2,NR1,NR2,NLLP,IORIG,JORIG,NPRD,NLDIV,NBESS
      INTEGER IFPIX,ILPIX,IFRAST,ILRAST
      LOGICAL SIGMA,POLAR
      INTEGER XPUNIT
      LOGICAL LXPLOR
C
C Common blocks:
C
      COMMON /INSPEC/ DELR,RMIN,DELZ,ZMIN,POLAR
      COMMON /POINTS/ NLLP,NPRD,INFO,IHKL
      COMMON /COEFFS/ JMIN,JMAX,IMIN,IMAX,IDCIN,ISIZE
      COMMON /LIMITS/ IAMIN,IAMAX,JAMIN,JAMAX,IORIG,JORIG
      COMMON /DLIMIT/ DMIN,DMAX,L1,L2,NR1,NR2,SN,NLDIV,NBESS,RADM
      COMMON /IMDATA/ NPIX,NRAST,IBACK,AD,PSIG,SIGMA
      COMMON /FITPAR/ ALLINE
      COMMON /IMAGE / IFPIX,ILPIX,IFRAST,ILRAST
      COMMON /LATICE/ NLAT,ALLCEL,MINFO,LATLIM,RADMM,MSIZE,MBESS,MLDIV
      COMMON /SCALES/ SNORM,SSCALE
      COMMON /CXPLOR/ LXPLOR,XPUNIT
C
C External Functions:
C
      REAL FALL
      EXTERNAL FALL
      INTEGER GETMEM
      EXTERNAL GETMEM
C
C Data:
C
      DATA IMEM /1/
      DATA IHED /10/, IDAT /11/, IOUT /12/, ICAL /13/
      DATA DTOR /0.017453293/
C
C-----------------------------------------------------------------------
C
C========Open log file on unit 4
C
      OPEN(UNIT=4,FILE='LSQINT.LOG',STATUS='UNKNOWN')
      WRITE(6,1000)
      WRITE(4,1000)
C
C========Set up defaults for global parameters
C
      LXPLOR = .FALSE.
      XPUNIT = 30
      MAXBUF = 64000000
      REFINE = .FALSE.
      CALC = .TRUE.
      NOFIT = .FALSE.
      FILEIN = .FALSE. 
      SETZ = .FALSE.
      ENTROPY = .FALSE.
      SIGMA = .FALSE.
      PRECOM = .TRUE.
      IBACK = 0
      NBACK = 0
      ITMAX = 20
      IFIT = 1 
      FTOL = 0.01
      DO 2 I=1,5
         PC1(I) = 0.0
         PC2(I) = 0.25
         IWID(I) = 10 
         JWID(I) = 10
         SMOO(I) = 1.0
         TENS(I) = 1.0
         ISEP(I) = 0
         JSEP(I) = 0
 2    CONTINUE
      DEF = 1.0
      RSCL = 0.3
      TCON = 0.1
      CFAC = 3.29
      MEITS = 100
      SMIN = 1.0
      SFAC = 0.0
      NLAT = 1
      NPRD = 0
      NP = 0
      DO 5 I=1,MAXALL
         PINC(I) = 0.0
 5    CONTINUE
C
C========Set up defaults for lattice specific parameters
C
      CSTAR = .FALSE.
      BRAG = .FALSE.
      CONT = .FALSE.
      DMIN = 0.0
      PHIX = 0.0
      PHIZ = 0.0
      L1 = 0
      L2 = -1
      ISGP = 'P1'
      ISIZE(1) = 1
      ISIZE(3) = 1
      ISIZE(4) = 1
      NLDIV = 1
      NBESS = 0
      RADM = 10000.0
      A0 = 0.001
      T0 = 0.001
      S0 = 3.0
      Q0 = 0.001
      Q1 = 0.0
      Q2 = 0.0
C
C========Start header file loop - read filename, image size, etc
C
 10   KPIC = 0
      CALL GETHDR(5,6,IHED,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,ILFR,
     &            IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF(IRC.NE.0)GOTO 9999
      IFRAME = IHFMAX + IFRMAX - 1
      OPEN(UNIT=IHED,FILE=HFNAM,STATUS='OLD')
      READ(IHED,'(A80)')HEAD1
      READ(IHED,1010)LABEL,NR,DELR,RMIN,NZ,DELZ,ZMIN
      CLOSE(UNIT=IHED)
      IF(DELR.EQ.0.0.OR.DELZ.EQ.0.0)STOP 'Not an FTOREC output file'
      POLAR = .FALSE.
      IF(LABEL(1:5).EQ.'POLAR')POLAR = .TRUE.
      IORIG = NINT(RMIN/DELR)
      JORIG = NINT(ZMIN/DELZ)
      CALL IMSIZE(5,6,NPIX,NRAST,IFPIX,ILPIX,IFRAST,ILRAST,IRC)
      IF(IRC.NE.0)GOTO 10
      WRITE(4,1015)HFNAM,NPIX,NRAST,IFPIX,ILPIX,IFRAST,ILRAST
      IAMIN = IFPIX + IORIG
      IAMAX = ILPIX + IORIG
      JAMIN = IFRAST + JORIG
      JAMAX = ILRAST + JORIG
      IF(POLAR)THEN
         NR1 = 1
         DMAX = RMIN + FLOAT(ILPIX)*DELR
      ELSE
         DMAX = MAX(RMIN+DELR*FLOAT(ILPIX),ZMIN+DELZ*FLOAT(ILRAST))
         NR1 = IFPIX
      ENDIF
      DMXDEF = DMAX
      NR2 = ILPIX
      WRITE(6,'(1X,A)')'Standard deviations file'
      CALL GETBSL(NPSD,NRSD,PSIG)
      FSIGMA = .FALSE.
      IF(NPSD.EQ.NPIX.AND.NRSD.EQ.NRAST)THEN
         FSIGMA = .TRUE.
      ELSE
         DO 15 IJ=1,NPIX*NRAST
            PSIG(IJ) = 1.0
 15      CONTINUE
      ENDIF
C
C========Read keyworded input
C
      WRITE(4,'(/1X,A15/)')'Keyworded input'
      NEXT = .TRUE.
  20  WRITE(6,'(1X,A8,$)')'LSQINT> '
      WRITE(4,'(1X,A8,$)')'LSQINT> '
      CALL RDCOMF(5,WORD,NWORD,VALUES,NVAL,ITEM,10,10,20,IRC)
      IF(IRC.EQ.2)GOTO 20 
      IF(IRC.EQ.1)GOTO 9999
      CALL WRTLOG(4,WORD,NWORD,VALUES,NVAL,ITEM,10,10,IRC)
      DO 25 I=1,NWORD
         CALL UPPER(WORD(I),10)
 25   CONTINUE
C
C========Check that first item on line is a word
C
      IF(ITEM(1).EQ.1)THEN
         WRITE(6,1060)
         WRITE(4,1060)
         GOTO 20 
      ELSEIF(ITEM(1).EQ.0)THEN
         GOTO 20
      ENDIF
      IF(NWORD.EQ.0)GOTO 20
C
C========RUN - end of keyworded input for last data file set
C
      IF(WORD(1)(1:4).EQ.'RUN '.OR.WORD(1)(1:4).EQ.'NEXT')THEN
         IF(WORD(1)(1:4).EQ.'RUN ')NEXT = .FALSE.
         WRITE(6,1100)NLAT
         WRITE(4,1100)NLAT
C
C========Either BRAG or CONT must be given
C
         IF(.NOT.BRAG.AND..NOT.CONT)THEN
            STOP '***Must use keywords CONT or BRAG'
         ELSEIF(CONT)THEN
C     
C========Setup INFO for continuous data
C
            MINFO(1,NLAT) = 0
            MINFO(2,NLAT) = 0
            MINFO(3,NLAT) = 0
            ALLCEL(1,NLAT) = CELL(1)
            RCELL(3) = 1.0/CELL(1)
C
C========Set up parameters for profile calculation
C
            PR(NP+1) = RCELL(3)
            PR(NP+2) = A0
            PR(NP+3) = S0
            PR(NP+4) = T0
            IF(L2.LT.0)L2 = INT(CELL(1)*DMAX)
            NR = NR2 - NR1 + 1
            NZ = L2 - L1 + 1
            MINFO(4,NLAT) = NR*NZ
            WRITE(6,1110)
            WRITE(4,1110)
            WRITE(6,1120)CELL(1)
            WRITE(4,1120)CELL(1)
            WRITE(6,1160)DMIN,DMAX
            WRITE(4,1160)DMIN,DMAX
            WRITE(6,1170)L1,L2,NR1,NR2
            WRITE(4,1170)L1,L2,NR1,NR2
            WRITE(6,1215)A0,S0,T0
            WRITE(4,1215)A0,S0,T0
            IF(REFINE)THEN
               WRITE(6,1217)PINC(NP+2),PINC(NP+3),PINC(NP+4),PINC(NP+1)
               WRITE(4,1217)PINC(NP+2),PINC(NP+3),PINC(NP+4),PINC(NP+1)
            ENDIF
            NP = NP + 4
         ELSE
C
C========Calculate reflection indices, multiplicities and D,R,Z
C
            ALLCEL(1,NLAT) = CELL(1)
            ALLCEL(2,NLAT) = CELL(2)
            ALLCEL(3,NLAT) = CELL(3)
            ALLCEL(4,NLAT) = CELL(4)
            ALLCEL(5,NLAT) = CELL(5)
            ALLCEL(6,NLAT) = CELL(6)
            CALL DRAGON(CELL,CSTAR,PHIZ,PHIX,ISGP,DMAX,DELR,DELZ,NLAT)
            CLOSE(UNIT=20)
            WRITE(CH,'(I1)')NLAT
            DFILE = 'DRAGON.OUT'//CH
            OPEN(UNIT=20,FILE=DFILE,STATUS='OLD')
            REWIND(20)
            READ(20,1030,ERR=9999)CTYPE,RCELL
            RCELL(4) = RCELL(4)*DTOR
            RCELL(5) = RCELL(5)*DTOR
            RCELL(6) = RCELL(6)*DTOR
 80         CONTINUE
            READ(20,1040,END=90,ERR=9999)IH,IK,IL,MUL,MFD,D0,R0,Z0
            IF(MFD.GT.0)THEN
               NPRD = NPRD + 1
               IHKL(1,NPRD) = IH
               IHKL(2,NPRD) = IK
               IHKL(3,NPRD) = IL
            ENDIF
            GOTO 80 
 90         CLOSE(UNIT=20)
C
C========Set up INFO for Bragg data, cell type, and parallel axis 
C
            MINFO(1,NLAT) = 1
            IF(CTYPE.EQ.'TRIG')THEN
               MINFO(2,NLAT) = 1
            ELSEIF(CTYPE.EQ.'TETR')THEN
               MINFO(2,NLAT) = 2
            ELSEIF(CTYPE.EQ.'ORTH')THEN
               MINFO(2,NLAT) = 3
            ELSEIF(CTYPE.EQ.'MON1')THEN
               MINFO(2,NLAT) = 4
            ELSEIF(CTYPE.EQ.'MON2')THEN
               MINFO(2,NLAT) = 5 
            ELSEIF(CTYPE.EQ.'MON3')THEN
               MINFO(2,NLAT) = 6 
            ELSEIF(CTYPE.EQ.'TRIC')THEN
               MINFO(2,NLAT) = 7 
            ELSE
               STOP '***Unrecognized cell type'
            ENDIF
            IF(CSTAR)THEN
               MINFO(3,NLAT) = 1
            ELSE
               MINFO(3,NLAT) = 0
            ENDIF 
            MINFO(4,NLAT) = NPRD
C
C========Set parameters for profile calculation and refinement
C
            PR(NP+1) = RCELL(3)
            PR(NP+2) = A0
            PR(NP+3) = S0
            PR(NP+4) = T0
            PR(NP+5) = RCELL(1)
            PR(NP+6) = Q0
            PR(NP+7) = Q1
            PR(NP+8) = Q2
            PR(NP+9) = RCELL(2)
            PR(NP+10) = RCELL(4)
            PR(NP+11) = RCELL(5)
            PR(NP+12) = RCELL(6)
            PR(NP+13) = PHIZ
            PR(NP+14) = PHIX
            IF(L2.LT.0)L2 = INT(DMAX/RCELL(3)) + 1
            WRITE(6,1090)
            WRITE(4,1090)
            IF(CSTAR)THEN
               WRITE(6,1130)PHIZ/DTOR,PHIX/DTOR
               WRITE(4,1130)PHIZ/DTOR,PHIX/DTOR 
            ELSE
               WRITE(6,1140)PHIZ/DTOR,PHIX/DTOR 
               WRITE(4,1140)PHIZ/DTOR,PHIX/DTOR 
            ENDIF
            WRITE(6,1160)DMIN,DMAX
            WRITE(4,1160)DMIN,DMAX
            WRITE(6,1200)A0,S0,T0,Q0,Q1,Q2
            WRITE(4,1200)A0,S0,T0,Q0,Q1,Q2
            IF(REFINE)THEN
               WRITE(6,1210)PINC(NP+2),PINC(NP+3),PINC(NP+4),PINC(NP+6),
     &              PINC(NP+7),PINC(NP+8),PINC(NP+5),PINC(NP+9),
     &              PINC(NP+1),PINC(NP+10),PINC(NP+11),PINC(NP+12)
               WRITE(4,1210)PINC(NP+2),PINC(NP+3),PINC(NP+4),PINC(NP+6),
     &              PINC(NP+7),PINC(NP+8),PINC(NP+5),PINC(NP+9),
     &              PINC(NP+1),PINC(NP+10),PINC(NP+11),PINC(NP+12)
               WRITE(6,1211)PINC(NP+13),PINC(NP+14)
               WRITE(4,1211)PINC(NP+13),PINC(NP+14)
            ENDIF
            NP = NP + 14
         ENDIF
C
C========Set up limits for multiple lattices
C
         LATLIM(1,NLAT) = FLOAT(L1)
         LATLIM(2,NLAT) = FLOAT(L2)
         LATLIM(3,NLAT) = FLOAT(NR1)
         LATLIM(4,NLAT) = FLOAT(NR2)
         LATLIM(5,NLAT) = DMIN
         LATLIM(6,NLAT) = DMAX
C
C========Sort out selection rule parameters
C
         MSIZE(1,NLAT) = ISIZE(1)
         MSIZE(2,NLAT) = ISIZE(2)
         MSIZE(3,NLAT) = ISIZE(3)
         MSIZE(4,NLAT) = ISIZE(4)
         MSIZE(5,NLAT) = ISIZE(5)
         MBESS(NLAT) = NBESS
         RADMM(NLAT) = RADM
         MLDIV(NLAT) = NLDIV
C     
C========This function calculates profiles and stores them in common
C========arrays. RFAC is meaningless at this point as we have no
C========intensity values
C
         IF(WORD(1)(1:4).EQ.'NEXT')NLAT = NLAT + 1
         IF(WORD(1)(1:4).EQ.'RUN ')RFAC = FALL(PR)
C
C========Reinitialize lattice specific parameters
C
         CSTAR = .FALSE.
         BRAG = .FALSE.
         CONT = .FALSE.
         DMIN = 0.0
         DMAX = DMXDEF
         PHIX = 0.0
         PHIZ = 0.0
         L1 = 0
         L2 = -1
         ISGP = 'P1'
         ISIZE(1) = 1
         ISIZE(3) = 1
         ISIZE(4) = 1
         NLDIV = 1
         NBESS = 0
         RADM = 10000.0
         A0 = 0.001
         T0 = 0.001
         S0 = 3.0
         Q0 = 0.001
         Q1 = 0.0
         Q2 = 0.0
C     
C========MAXB - maximum allowed number of bytes for least-squares/ME
C========workspace
C
      ELSEIF(WORD(1)(1:4).EQ.'MAXB')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,1070)
            WRITE(4,1070)
         ELSE
            MAXBUF = NINT(VALUES(1))
         ENDIF
C
C========XPLO - xplor style output file will be produced
C
      ELSEIF(WORD(1)(1:4).EQ.'XPLO')THEN
         LXPLOR = .TRUE.
C
C========BRAG - calculations will be performed for Bragg data
C
      ELSEIF(WORD(1)(1:4).EQ.'BRAG')THEN
         BRAG = .TRUE.
         CONT = .FALSE.
C
C========CONT - calculations performed for continuous data
C
      ELSEIF(WORD(1)(1:4).EQ.'CONT')THEN
         CONT = .TRUE.
         BRAG = .FALSE.
C
C========SPRE - following items contain profile parameters
C
      ELSEIF(WORD(1)(1:4).EQ.'SPRE')THEN
         IF(ITEM(2).NE.2)THEN
            WRITE(6,1060)
            WRITE(4,1060)
         ENDIF
         DO 30 I=2,NWORD
            IF(WORD(I)(1:4).EQ.'AWID')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  A0 = VALUES(I-1)*DTOR
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'SHAP')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  S0 = VALUES(I-1)
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'ZWID')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  T0 = VALUES(I-1)
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'R0WI')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  Q0 = VALUES(I-1)
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'R1WI')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  Q1 = VALUES(I-1)
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'R2WI')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  Q2 = VALUES(I-1)
               ENDIF
            ELSE
               WRITE(6,1080)
               WRITE(4,1080)
            ENDIF
 30      CONTINUE
C
C========CELL - following values contain cell parameters
C
      ELSEIF(WORD(1)(1:4).EQ.'CELL')THEN
         DO 40 I=1,NVAL
            IF(ITEM(I+1).NE.1)THEN 
               WRITE(6,1070)
               WRITE(4,1070)
            ELSE
               CELL(I) = VALUES(I)
            ENDIF
 40      CONTINUE
C
C========CSTA - sets axis parallel to Z as C*
C
      ELSEIF(WORD(1)(1:4).EQ.'CSTA')THEN
         CSTAR = .TRUE.
C
C========SPAC - space group symbol
C
      ELSEIF(WORD(1)(1:4).EQ.'SPAC')THEN
         ISGP = WORD(2)
C
C========BACK - type of background subtraction to be performed
C
      ELSEIF(WORD(1)(1:4).EQ.'BACK')THEN
         NWSTRT = 3
         IF(WORD(2)(1:4).EQ.'NONE')THEN
            IBACK = 0
         ELSEIF(WORD(2)(1:4).EQ.'CIRC')THEN
            IF(MOD(IBACK/2,2).EQ.0)IBACK = IBACK + 2
            NBACK = 1
         ELSEIF(WORD(2)(1:4).EQ.'WIND')THEN
            IF(MOD(IBACK/4,2).EQ.0)IBACK = IBACK + 4
            NBACK = 2
         ELSEIF(WORD(2)(1:4).EQ.'LFIT')THEN
            NWSTRT = 4
            NBACK = 3
            IF(MOD(IBACK/8,2).EQ.0)IBACK = IBACK + 8
            IF(WORD(3)(1:4).EQ.'FLAT')THEN
               IF(MOD(IBACK,2).EQ.0)IBACK = IBACK + 0
            ELSEIF(WORD(3)(1:4).EQ.'INCL')THEN
               IF(MOD(IBACK,2).EQ.0)IBACK = IBACK + 1
            ENDIF
         ELSEIF(WORD(2)(1:4).EQ.'GLOB')THEN
            IF(MOD(IBACK/16,2).EQ.0)IBACK = IBACK + 16
C
C========For backward compatibilty
C
         ELSEIF(WORD(3)(1:4).EQ.'INCL')THEN
            NWSTRT = 4
            IF(MOD(IBACK/8,2).EQ.0)IBACK = IBACK + 8
            IF(MOD(IBACK,2).EQ.0)IBACK = IBACK + 1
         ELSE
            WRITE(6,1080)
            WRITE(4,1080)
         ENDIF
         DO 45 I=NWSTRT,NWORD
            IF(WORD(I)(1:4).EQ.'XWID')THEN
               IWID(NBACK) = NINT(VALUES(I-2))
            ELSEIF(WORD(I)(1:4).EQ.'YWID')THEN
               JWID(NBACK) = NINT(VALUES(I-2))
            ELSEIF(WORD(I)(1:4).EQ.'XSEP')THEN
               ISEP(NBACK) = NINT(VALUES(I-2))
            ELSEIF(WORD(I)(1:4).EQ.'YSEP')THEN
               JSEP(NBACK) = NINT(VALUES(I-2))
            ELSEIF(WORD(I)(1:4).EQ.'LPIX')THEN
               PC1(NBACK) = VALUES(I-2)/100.0
            ELSEIF(WORD(I)(1:4).EQ.'HPIX')THEN
               PC2(NBACK) = VALUES(I-2)/100.0
            ELSEIF(WORD(I)(1:4).EQ.'SMOO')THEN
               SMOO(NBACK) = VALUES(I-2)
            ELSEIF(WORD(I)(1:4).EQ.'TENS')THEN
               TENS(NBACK) = VALUES(I-2)
            ELSE
               WRITE(6,1080)
               WRITE(4,1080)
            ENDIF
 45      CONTINUE
C
C========REFI - option for refining cell and profile parameters
C
      ELSEIF(WORD(1)(1:4).EQ.'REFI')THEN
         REFINE = .TRUE.
         IFIT = 2
         DO 50 I=2,NWORD
            IF(WORD(I)(1:4).EQ.'ITMA')THEN
               ITMAX = NINT(VALUES(I-1))
            ELSEIF(WORD(I)(1:4).EQ.'IFIT')THEN
               IFIT = NINT(VALUES(I-1))
            ELSEIF(WORD(I)(1:4).EQ.'TOLE')THEN
               FTOL = VALUES(I-1)
            ELSE
               WRITE(6,1080)
               WRITE(4,1080)
            ENDIF
 50      CONTINUE
C
C========LIMI - sets up d* limits for profile calculation for Bragg data
C========layer line limits and R limits for continuous data
C
      ELSEIF(WORD(1)(1:4).EQ.'LIMI')THEN
         IF(ITEM(2).NE.2)THEN
            WRITE(6,1060)
            WRITE(4,1060)
         ENDIF
         DO 60 I=2,NWORD
            IF(WORD(I)(1:4).EQ.'LAYE')THEN
               L1 = NINT(VALUES(2*(I-2)+1))
               L2 = NINT(VALUES(2*(I-1)))
            ELSEIF(WORD(I)(1:4).EQ.'RADI')THEN
               NR1 = NINT(VALUES(2*(I-2)+1))
               NR2 = NINT(VALUES(2*(I-1)))
            ELSEIF(WORD(I)(1:4).EQ.'DLIM')THEN
               DMIN = VALUES(2*(I-2)+1)
               DMAX = VALUES(2*(I-1))
            ELSE
               WRITE(6,1080)
               WRITE(4,1080)
            ENDIF
 60      CONTINUE
C
C========MAXE - Signals maximum entropy refinement
C
      ELSEIF(WORD(1)(1:4).EQ.'MAXE')THEN
         ENTROPY = .TRUE.
         DO 62 I=2,NWORD
            IF(WORD(I)(1:4).EQ.'DEFA')THEN
               DEF = VALUES(I-1)
            ELSEIF(WORD(I)(1:4).EQ.'RATE')THEN
               RSCL = VALUES(I-1)
            ELSEIF(WORD(I)(1:4).EQ.'TEST')THEN
               TCON = VALUES(I-1) 
            ELSEIF(WORD(I)(1:4).EQ.'CHIF')THEN
               CFAC = VALUES(I-1)
            ELSEIF(WORD(I)(1:4).EQ.'CYCL')THEN
               MEITS = NINT(VALUES(I-1))
            ELSE
               WRITE(6,1080)
               WRITE(4,1080)
            ENDIF
 62      CONTINUE 
C
C========SIGM - Sets up the standard deviations array for the observed
C========pixel values
C
      ELSEIF(WORD(1)(1:4).EQ.'SIGM')THEN
         SIGMA = .TRUE.
         FSIGMA = .FALSE.
         DO 64 I=2,NWORD
            IF(WORD(I)(1:4).EQ.'MINI')THEN
               SMIN = VALUES(I-1)
            ELSEIF(WORD(I)(1:4).EQ.'FACT')THEN
               SFAC = VALUES(I-1)
            ELSE
               WRITE(6,1080)
               WRITE(4,1080)
            ENDIF
 64      CONTINUE
C
C========SHIF - Sets shifts for cell and profile parameter refinement
C
      ELSEIF(WORD(1)(1:4).EQ.'SHIF')THEN
         DO 70 I=2,NWORD
            IF(WORD(I)(1:4).EQ.'AWID')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  PINC(NP+2) = VALUES(I-1)*DTOR
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'SHAP')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  PINC(NP+3) = VALUES(I-1)
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'ZWID')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  PINC(NP+4) = VALUES(I-1)
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'R0WI')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  PINC(NP+6) = VALUES(I-1)
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'R1WI')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  PINC(NP+7) = VALUES(I-1)
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'R2WI')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  PINC(NP+8) = VALUES(I-1)
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'ASTA')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  PINC(NP+5) = VALUES(I-1)
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'BSTA')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  PINC(NP+9) = VALUES(I-1)
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'CSTA')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  PINC(NP+1) = VALUES(I-1)
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'ALPH')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  PINC(NP+10) = VALUES(I-1)*DTOR
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'BETA')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  PINC(NP+11) = VALUES(I-1)*DTOR
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'GAMM')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  PINC(NP+12) = VALUES(I-1)*DTOR
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'PHIZ')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  PINC(NP+13) = VALUES(I-1)*DTOR
               ENDIF
            ELSEIF(WORD(I)(1:4).EQ.'PHIX')THEN
               IF(ITEM(2*I-1).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  PINC(NP+14) = VALUES(I-1)*DTOR
               ENDIF
            ELSE
               WRITE(6,1080)
               WRITE(4,1080)
            ENDIF
 70      CONTINUE
      ELSEIF(WORD(1)(1:4).EQ.'NOCA')THEN
         CALC = .FALSE.
      ELSEIF(WORD(1)(1:4).EQ.'NOFI')THEN
         NOFIT = .TRUE.
         IF(WORD(2)(1:4).EQ.'FILE')THEN
            WRITE(6,1075)
            WRITE(4,1075)
            CALL RDCOMF(5,NOFILE,NWORD,VALUES,NVAL,ITEM,1,1,80,IRC)
            IF(IRC.EQ.2)GOTO 20
            IF(IRC.EQ.1)GOTO 9999
            WRITE(4,'(A)')NOFILE
            IF(NOFILE.EQ.' ')THEN
               FILEIN = .FALSE.
            ELSE
               INQUIRE(FILE=NOFILE,EXIST=FILEIN)
               IF(.NOT.FILEIN)THEN
                  WRITE(6,1076)NOFILE 
                  WRITE(4,1076)NOFILE
               ENDIF
            ENDIF 
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'SETZ')THEN
         SETZ = .TRUE.
      ELSEIF(WORD(1)(1:4).EQ.'MISS')THEN
         DO 75 I=2,NWORD
            IF(ITEM(2*(I-1)).EQ.1)THEN 
               WRITE(6,1060)
               WRITE(4,1060)
            ENDIF 
            IF(ITEM(2*I-1).NE.1)THEN 
               WRITE(6,1070)
               WRITE(4,1070)
            ENDIF 
            IF(WORD(I)(1:4).EQ.'PHIZ')THEN
               PHIZ = VALUES(I-1)*DTOR 
            ELSEIF(WORD(I)(1:4).EQ.'PHIX')THEN
               PHIX = VALUES(I-1)*DTOR
            ENDIF
 75      CONTINUE
      ELSEIF(WORD(1)(1:4).EQ.'SELE')THEN
         IF(ITEM(2).NE.2)THEN
            WRITE(6,1060)
            WRITE(4,1060)
         ELSEIF(WORD(2)(1:4).EQ.'HELI')THEN
            NBESS = 10
            DO 76 I=3,NWORD
               IF(WORD(I)(1:4).EQ.'TURN')THEN
                  IF(ITEM(2*I-2).NE.1)THEN
                     WRITE(6,1070)
                     WRITE(4,1070)
                  ELSE
                     ISIZE(1) = NINT(ABS(VALUES(I-2)))
                  ENDIF
               ELSEIF(WORD(I)(1:4).EQ.'UNIT')THEN
                  IF(ITEM(2*I-2).NE.1)THEN
                     WRITE(6,1070)
                     WRITE(4,1070)
                  ELSE
                     ISIZE(2) = NINT(ABS(VALUES(I-2)))
                  ENDIF
               ELSEIF(WORD(I)(1:4).EQ.'STAR')THEN
                  IF(ITEM(2*I-2).NE.1)THEN
                     WRITE(6,1070)
                     WRITE(4,1070)
                  ELSE
                     ISIZE(3) = NINT(ABS(VALUES(I-2)))
                  ENDIF
               ELSEIF(WORD(I)(1:4).EQ.'STAC')THEN
                  IF(ITEM(2*I-2).NE.1)THEN
                     WRITE(6,1070)
                     WRITE(4,1070)
                  ELSE
                     ISIZE(4) = NINT(ABS(VALUES(I-2)))
                  ENDIF
               ELSEIF(WORD(I)(1:4).EQ.'BESS')THEN
                  IF(ITEM(2*I-2).NE.1)THEN
                     WRITE(6,1070)
                     WRITE(4,1070)
                  ELSE
                     NBESS = NINT(VALUES(I-2))
                  ENDIF
               ELSEIF(WORD(I)(1:4).EQ.'RADI')THEN
                  IF(ITEM(2*I-2).NE.1)THEN
                     WRITE(6,1070)
                     WRITE(4,1070)
                  ELSE
                     RADM = 8.0*ATAN(1.0)*VALUES(I-2)
                  ENDIF
               ELSE
                  WRITE(6,1080)
                  WRITE(4,1080)
               ENDIF
 76         CONTINUE
            IF(ISIZE(1).GT.ISIZE(2))THEN
               I = ISIZE(1)
               ISIZE(1) = ISIZE(2)
               ISIZE(2) = I
            ENDIF
            IF(ISIZE(1).EQ.0.OR.ISIZE(2).EQ.0)THEN
               NBESS = 0
               ISIZE(1) = 1
            ENDIF
         ELSEIF(WORD(2)(1:4).EQ.'MIXT')THEN
            DO 77 I=1,MIN(NVAL,5)
               IF(ITEM(I+2).NE.1)THEN
                  WRITE(6,1070)
                  WRITE(4,1070)
               ELSE
                  ISIZE(NLDIV) = NINT(ABS(VALUES(I)))
                  IF(ISIZE(NLDIV).GT.0)THEN
                     NLDIV = NLDIV + 1
                  ELSE
                     ISIZE(NLDIV) = 1
                  ENDIF
               ENDIF
 77         CONTINUE
            NLDIV = MAX(1,NLDIV-1)
         ELSE
            WRITE(6,1080)
            WRITE(4,1080)
         ENDIF
      ELSE
C
C========Check for unknown keyword
C
         WRITE(6,1080)
         WRITE(4,1080)
      ENDIF
      IF(NEXT)GOTO 20 
C
C========Report the consequences of the input to user
C
      IF(IBACK.EQ.0)THEN
         WRITE(6,1178)
         WRITE(4,1178)
      ENDIF
      IF(MOD(IBACK/2,2).EQ.1)THEN
         NBACK = 1
         IF(ISEP(NBACK).LE.0)ISEP(NBACK) = IWID(NBACK)
         IF(JSEP(NBACK).LE.0)JSEP(NBACK) = JWID(NBACK)
         WRITE(6,1179)SMOO(NBACK),TENS(NBACK),PC1(NBACK),PC2(NBACK)
         WRITE(4,1179)SMOO(NBACK),TENS(NBACK),PC1(NBACK),PC2(NBACK)
      ENDIF
      IF(MOD(IBACK/4,2).EQ.1)THEN
         NBACK = 2
         IF(ISEP(NBACK).LE.0)ISEP(NBACK) = IWID(NBACK)
         IF(JSEP(NBACK).LE.0)JSEP(NBACK) = JWID(NBACK)
         WRITE(6,1177)2*IWID(NBACK)+1,2*JWID(NBACK)+1,
     &        ISEP(NBACK),JSEP(NBACK),PC1(NBACK),PC2(NBACK)
         WRITE(4,1177)2*IWID(NBACK)+1,2*JWID(NBACK)+1,
     &        ISEP(NBACK),JSEP(NBACK),PC1(NBACK),PC2(NBACK)
      ENDIF
      IF(MOD(IBACK/8,2).EQ.1)THEN
         NBACK = 3
         IF(ISEP(NBACK).LE.0)ISEP(NBACK) = IWID(NBACK)
         IF(JSEP(NBACK).LE.0)JSEP(NBACK) = JWID(NBACK)
         IF(MOD(IBACK,2).EQ.0)THEN
            WRITE(6,1174)2*IWID(NBACK)+1,2*JWID(NBACK)+1,
     &           ISEP(NBACK),JSEP(NBACK),SMOO(NBACK),TENS(NBACK)
            WRITE(4,1174)2*IWID(NBACK)+1,2*JWID(NBACK)+1,
     &           ISEP(NBACK),JSEP(NBACK),SMOO(NBACK),TENS(NBACK)
         ELSE
            WRITE(6,1176)2*IWID(NBACK)+1,2*JWID(NBACK)+1,
     &           ISEP(NBACK),JSEP(NBACK),SMOO(NBACK),TENS(NBACK)
            WRITE(4,1176)2*IWID(NBACK)+1,2*JWID(NBACK)+1,
     &           ISEP(NBACK),JSEP(NBACK),SMOO(NBACK),TENS(NBACK)
         ENDIF
      ENDIF
      IF(MOD(IBACK/16,2).EQ.1)THEN
         WRITE(6,1175)
         WRITE(4,1175)
C
C========Can not have global background fitting and maximum entropy
C
         IF(ENTROPY)THEN
            WRITE(6,1260)
            WRITE(4,1260)
            ENTROPY = .FALSE.
         ENDIF
      ENDIF
      IF(CALC)THEN
         WRITE(6,1220)
         WRITE(4,1220)
         IF(NOFIT)THEN
            WRITE(6,1225)
            WRITE(4,1225)
         ENDIF
      ELSE
         WRITE(6,1230)
         WRITE(4,1230)
      ENDIF
      IF(ENTROPY)THEN
         WRITE(6,1232)DEF,RSCL,TCON,CFAC,MEITS
         WRITE(4,1232)DEF,RSCL,TCON,CFAC,MEITS
      ENDIF
      IF(SETZ)THEN
         WRITE(6,1237)
         WRITE(4,1237)
      ENDIF
      IF(SIGMA)THEN
         WRITE(6,1238)SMIN,SFAC
         WRITE(4,1238)SMIN,SFAC
      ENDIF
      IF(REFINE)THEN
         WRITE(6,1180)ITMAX,IFIT
         WRITE(4,1180)ITMAX,IFIT
         WRITE(6,1185)FTOL
         WRITE(4,1185)FTOL
      ELSE
         WRITE(6,1190)
         WRITE(4,1190)
      ENDIF
C
C========If the calculated diffraction pattern is required, prompt
C========for filename 
C
      IF(CALC)THEN
         WRITE(6,1150)
         WRITE(4,1150)
         CALL OUTFIL(5,6,CFNAM,CHEAD1,CHEAD2,IRC)
         WRITE(CHEAD2,1010)LABEL,NR,DELR,RMIN,NZ,DELZ,ZMIN
         WRITE(4,1105)CFNAM,CHEAD1,CHEAD2
         ICFRAME = 2*IFRAME
         CALL OPNNEW(ICAL,NPIX,NRAST,ICFRAME,CFNAM,IMEM,
     &               CHEAD1,CHEAD2,IRC)
         IF(IRC.NE.0)GOTO 130
      ENDIF
C
C========Read output filename
C
      IF(.NOT.NOFIT.OR.LXPLOR)THEN
         WRITE(6,1025)
         READ(5,'(A)',ERR=9999,END=9999)OUTBRG
         WRITE(4,1027)OUTBRG
      ENDIF
C
C========Loop over header filenames
C
      DO 120 I=1,IHFMAX
         CALL OPNFIL(IDAT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &               NFRAME,IRC)
         IF(IRC.EQ.0)THEN
            ISPEC = ISPEC + INCR
            DO 110 J=1,IFRMAX
               CALL RFRAME(IDAT,IFFR,NPIX,NRAST,AD,IRC)
               IF(IRC.NE.0)GOTO 130
               IFFR = IFFR + IFINC
               KPIC = KPIC + 1 
C
C========Initialize background array and variance array
C
               DO 95 IJ=1,NPIX*NRAST
                  B(IJ) = 0.0
                  BB(IJ) = 0.0
                  IF(AD(IJ).GT.0.0)THEN
                     IF(.NOT.FSIGMA.OR.PSIG(IJ).LE.0.0)THEN
                        IF(SMIN.GT.0.0)THEN
                           PSIG(IJ) = (SMIN+SFAC*SQRT(AD(IJ)))**2
                        ELSE
                           AD(IJ) = -1.0E+30
                        ENDIF
                     ELSE
                        PSIG(IJ) = PSIG(IJ)**2
                     ENDIF
                  ENDIF
 95            CONTINUE
               IF(.NOT.SIGMA)SIGMA = FSIGMA
C
C========Do NOFIT option then quit if required
C
               IF(NOFIT)THEN
                  IF(FILEIN)THEN
                     CALL RDINT(NOFILE,RCELL,ALLINE,SIG)
                  ELSE
                     DO 85 IJ=1,NLLP
                        ALLINE(IJ) = 1.0
 85                  CONTINUE
                  ENDIF
                  IF(LXPLOR)THEN
                     CALL ALLOUT(IOUT,OUTBRG,1,1,PR,SIG)
                  ENDIF
                  CALL IMGCAL(ALLINE,JMIN,JMAX,NLLP,NPAR,IMIN,IMAX,
     &                 IPOINTX,IDCIN,MPOINTX,AD,B,NPIX,NRAST,
     &                 0,1,ICAL)
                  GOTO 130
               ENDIF
C
C========Fit circularly symmetric background if required
C
               IF(MOD(IBACK/2,2).EQ.1)CALL BGCSYM(B,BB,SMOO(1),TENS(1),
     &                                            PC1(1),PC2(1))
C
C========Fit background with roving window method if required
C
               IF(MOD(IBACK/4,2).EQ.1)
     &              CALL BGWSRT(B,BB,IWID(2),JWID(2),ISEP(2),JSEP(2),
     &                          SMOO(2),TENS(2),PC1(2),PC2(2))
C
C========Loop over intensity fitting and profile refinement
C
               DO 100 II=1,IFIT
                  WRITE(6,1240)II
                  WRITE(4,1240)II
C
C========Fit background with roving window and least-squares if required
C
                  IF(MOD(IBACK/8,2).EQ.1)THEN
                     IF(MOD(IBACK,2).EQ.1)THEN
                        CALL BGWLSI(B,BB,IWID(3),JWID(3),
     &                       ISEP(3),JSEP(3),SMOO(3),TENS(3))
                     ELSE
                        CALL BGWLSH(B,BB,IWID(3),JWID(3),
     &                       ISEP(3),JSEP(3),SMOO(3),TENS(3))
                     ENDIF
                  ENDIF
C
C========Set up number parameters depending on background option
C
                  IF(MOD(IBACK/16,2).EQ.1)THEN
                     NPAR = NLLP + 8
                  ELSE
                     NPAR = NLLP
                  ENDIF
                  WRITE(6,1250)NLLP,NPAR
                  WRITE(4,1250)NLLP,NPAR
                  IF(ENTROPY)THEN
C
C========Calculate memory required for ME workspace
C
                     NSIZE = (ILPIX-IFPIX+1)*(ILRAST-IFRAST+1)
                     NBUF = 12*NSIZE
                     NBUF1 = 12*NPAR
                     NBUF2 = 4*NPAR
C     
C========Allocate memory for ME workspace
C
                     IRC = GETMEM(NBUF1,IBUF1)
                     IF(IRC.NE.1)STOP 'Error allocating memory'
                     IRC = GETMEM(NBUF,IBUF2)
                     IF(IRC.NE.1)STOP 'Error allocating memory'
                     IRC = GETMEM(NBUF2,IBUF3)
                     IF(IRC.NE.1)STOP 'Error allocating memory'
                     IRC = GETMEM(NBUF2,IBUF4)
                     IF(IRC.NE.1)STOP 'Error allocating memory'
C
C========Maximum entropy fitting for background subtracted image
C
                     CALL LMAXENT(II,NPAR,NSIZE,DEF,RSCL,TCON,CFAC,
     &                    MEITS,RFAC,SIG,%val(IBUF1),%val(IBUF2),
     &                    %val(IBUF3),%val(IBUF4))
C
C========Free workspace memory
C
                     CALL FREMEM(IBUF1)
                     CALL FREMEM(IBUF2)
                     CALL FREMEM(IBUF3)
                     CALL FREMEM(IBUF4)
                  ELSE
                     NBUF = 8*NPAR*NPAR
                     IF(NBUF.GT.MAXBUF)THEN
                        WRITE(6,2000)MAXBUF
                        WRITE(4,2000)MAXBUF
                        GOTO 9999
                     ENDIF
                     NBUF1 = 8*NPAR
                     NBUF2 = 4*NPAR
                     IRC = GETMEM(NBUF,IBUF1)
                     IF(IRC.NE.1)STOP 'Error allocating memory'
                     IRC = GETMEM(NBUF1,IBUF2)
                     IF(IRC.NE.1)STOP 'Error allocating memory'
                     IRC = GETMEM(NBUF1,IBUF3)
                     IF(IRC.NE.1)STOP 'Error allocating memory'
                     IRC = GETMEM(NBUF1,IBUF4)
                     IF(IRC.NE.1)STOP 'Error allocating memory'
                     IRC = GETMEM(NBUF1,IBUF5)
                     IF(IRC.NE.1)STOP 'Error allocating memory'
                     IRC = GETMEM(NBUF2,IBUF6)
                     IF(IRC.NE.1)STOP 'Error allocating memory'
                     IRC = GETMEM(NBUF2,IBUF7)
                     IF(IRC.NE.1)STOP 'Error allocating memory'
                     IRC = GETMEM(NBUF2,IBUF8)
                     IF(IRC.NE.1)STOP 'Error allocating memory'
                     IRC = GETMEM(NBUF2,IBUF9)
                     IF(IRC.NE.1)STOP 'Error allocating memory'
C
C========Linear least-squares fit for intensities and background
C
                     CALL DLSQFIT(JMIN,JMAX,NLLP,NPAR,IMIN,IMAX,
     &                            IPOINTX,IDCIN,MPOINTX,
     &                            SIG,RFAC,SETZ,
     &                            %val(IBUF1),%val(IBUF2),%val(IBUF3),
     &                            %val(IBUF4),%val(IBUF5),%val(IBUF6),
     &                            %val(IBUF7),%val(IBUF8),%val(IBUF9))
C
C========Free workspace memory
C
                     CALL FREMEM(IBUF1)
                     CALL FREMEM(IBUF2)
                     CALL FREMEM(IBUF3)
                     CALL FREMEM(IBUF4)
                     CALL FREMEM(IBUF5)
                     CALL FREMEM(IBUF6)
                     CALL FREMEM(IBUF7)
                     CALL FREMEM(IBUF8)
                     CALL FREMEM(IBUF9)
                  ENDIF
C
C========Refine profile and cell parameters if required
C
                  IF(REFINE.AND.II.LT.IFIT)THEN
                     CALL REPROF(PR,PINC,MINFO,NLAT,ITMAX,FTOL,RFAC)
                     CALL REPORT(MINFO,PR,NLAT)
                  ENDIF
 100           CONTINUE
C
C========Write calculated image if required
C
               IF(CALC)THEN
                  CALL IMGCAL(ALLINE,JMIN,JMAX,NLLP,NPAR,IMIN,IMAX,
     &                        IPOINTX,IDCIN,MPOINTX,AD,BB,NPIX,NRAST,
     &                        IBACK,KPIC,ICAL)
               ENDIF
C
C========Write output file
C
               CALL ALLOUT(IOUT,OUTBRG,KPIC,IFRAME,PR,SIG)
 110        CONTINUE
            CALL FCLOSE(IDAT)
         ENDIF
 120  CONTINUE
 130  CALL FCLOSE(IDAT) 
      IF(CONT)CALL FCLOSE(IOUT)
      IF(CALC)CALL FCLOSE(ICAL)
      STOP 'Normal stop'
 9999 STOP 'USER STOP'
C
 1000 FORMAT(/1X,'LSQINT: Fibre Diffraction Profile Fitting Program'/
     &       1X,'Latest updates:'/
     &       1X,'25/08/02 - DLSQFIT now outputs covariance matrix'/
     &       1X,'06/08/02 - modification to LMAXENT'/)
 1010 FORMAT(2X,A12,I5,2G12.5,I5,2G12.5)
 1015 FORMAT(1X,'Header filename: ',A13,7X,2I8/
     &       1X,'First and last pixels: ',2I8/
     &       1X,'First and last rasters:',2I8)
 1025 FORMAT(/1X,'Enter output file name: ',$)
 1027 FORMAT(/1X,'Output file name: ',A)
 1030 FORMAT(A4,6X,6E10.4)
 1040 FORMAT(1X,3I4,2I5,1X,3E14.6)
 1060 FORMAT(1X,'***Keyword expected')
 1070 FORMAT(1X,'***Value expected')
 1075 FORMAT(1X,'Enter intensity filename: ',$)
 1076 FORMAT(1X,'***File does not exist:  ',A80)
 1080 FORMAT(1X,'***Unrecognized keyword')
 1090 FORMAT(/1X,'Fitting will be performed for Bragg data')
 1100 FORMAT(1X,'Cell ',I1/)
 1105 FORMAT(1X,'Header filename: ',A13/
     &       1X,'header 1: ',A80/
     &       1X,'header 2: ',A80)
 1110 FORMAT(/1X,'Fitting will be performed for continuous data')
 1120 FORMAT(/1X,'c axis repeat: ',F12.4)
 1130 FORMAT(1X,'c* axis is parallel to Z'/
     &       1X,'Missetting angles: Phi_Z = ',F6.2,'  Phi_X = ',F6.2)
 1140 FORMAT(1X,'c axis is parallel to Z'/
     &       1X,'Missetting angles: Phi_Z = ',F6.2,'  Phi_X = ',F6.2)
 1150 FORMAT(/1X,'Calculated file...')
 1160 FORMAT(1X,'Minimum d* = ',F6.4,5X,'maximum d* = ',F6.4)
 1170 FORMAT(1X,'First layerline: ',I3,5X,'last layerline: ',I3/
     &       1X,'First radius: ',I4,5X,'last radius: ',I4)
 1174 FORMAT(/1X,'Background will be fitted locally by least-squares'/
     &       1X,'with a horizontal plane. The central heights of the'/
     &       1X,'planes will then be joined with a smoothing spline'/
     &       1X,'under tension'/
     &       10X,'Window size: ',I3,' x ',I3/
     &       10X,'Window separation: ',I3,' x ',I3/
     &       10X,'Smoothing: ',F5.2,5X,'Tension: ',F5.2)
 1175 FORMAT(/1X,'Background will be approximated by fitting a'/
     &       1X,'global function simultaneously with the intensities')
 1176 FORMAT(/1X,'Background will be fitted locally by least-squares'/
     &       1X,'and an inclined plane. The central heights of the'/
     &       1X,'planes will then be joined with a smoothing spline'/
     &       1X,'under tension'/
     &       10X,'Window size: ',I3,' x ',I3/
     &       10X,'Window separation: ',I3,' x ',I3/
     &       10X,'Smoothing: ',F5.2,5X,'Tension: ',F5.2)
 1177 FORMAT(/1X,'Background will be fitted by selecting points using'/
     &       1X,'the roving aperture method'/
     &       10X,'Window size: ',I3,' x ',I3/
     &       10X,'Window separation: ',I3,' x ',I3/
     &       10X,'Fractional range of sorted pixels: ',
     &           F5.3,' to ',F5.3)
 1178 FORMAT(/1X,'No background fitting will be done')
 1179 FORMAT(/1X,'A circularly-symmetric background will be fitted by'/
     &       1X,'assigning pixel values to radial bins and finding the'/
     &       1X,'the minimum value for each bin. The background will'/
     &       1X,'formed by fitting a smoothing spline under tension to'/
     &       1X,'the radial bin values'/
     &       10X,'Smoothing: ',F5.2,5X,'Tension: ',F5.2/
     &       10X,'Fractional range of sorted pixels: ',
     &           F5.3,' to ',F5.3)
 1180 FORMAT(1X,'Cell and profile parameters will be refined'/
     &       1X,I3,' cycles of refinement for ',I3,' fitting cycles')
 1185 FORMAT(1X,'R-factor shift tolerance for refinement =',F8.5)
 1190 FORMAT(1X,'Cell and profile parameters will not be refined')
 1200 FORMAT(1X,'Initial profile parameters:'/
     &       1X,'                             AWIDTH: ',F6.4/
     &       1X,'                             SHAPE : ',F6.2/
     &       1X,'                             ZWIDTH: ',F6.4/
     &       1X,'                            R0WIDTH: ',F6.4/
     &       1X,'                            R1WIDTH: ',F6.4/
     &       1X,'                            R2WIDTH: ',F6.4)
 1210 FORMAT(1X,'Shifts for parameter refinement:'/
     &       1X,'                                  AWIDTH: ',F8.6/ 
     &       1X,'                                  SHAPE : ',F8.5/
     &       1X,'                                  ZWIDTH: ',F8.6/
     &       1X,'                                 R0WIDTH: ',F8.6/
     &       1X,'                                 R1WIDTH: ',F8.6/
     &       1X,'                                 R2WIDTH: ',F8.6/
     &       1X,'                                   ASTAR: ',F8.6/
     &       1X,'                                   BSTAR: ',F8.6/
     &       1X,'                                   CSTAR: ',F8.6/
     &       1X,'                               ALPHASTAR: ',F8.6/
     &       1X,'                               BETASTAR : ',F8.6/
     &       1X,'                               GAMMASTAR: ',F8.6)
 1211 FORMAT(1X,'Shifts for missetting angles:'/
     &       1X,'                                    PHIZ: ',F8.4/
     &       1X,'                                    PHIX: ',F8.4)
 1215 FORMAT(1X,'Initial profile parameters:'/
     &       1X,'                             AWIDTH: ',F6.4/
     &       1X,'                             SHAPE : ',F6.2/
     &       1X,'                             ZWIDTH: ',F6.4)
 1217 FORMAT(1X,'Shifts for parameter refinement:'/ 
     &       1X,'                                  AWIDTH: ',F8.6/ 
     &       1X,'                                  SHAPE : ',F8.5/
     &       1X,'                                  ZWIDTH: ',F8.6/
     &       1X,'                                   CSTAR: ',F8.6)
 1220 FORMAT(1X,'Calculated image will be output')
 1225 FORMAT(1X,'Image of profiles only - no fitting')
 1230 FORMAT(1X,'Calculated image will not be output')
 1232 FORMAT(1X,'Maximum entropy fitting'/
     &       1X,'Default value for fitted intensities ',G12.5/
     &       1X,'Rate defining maximum stepsize       ',G12.5/
     &       1X,'Convergence criterion                ',G12.5/
     &       1X,'Factor defining target chi-squared   ',G12.5/
     &       1X,'Maximum number of iterations ',I5)
 1237 FORMAT(1X,'Negative intensities will be set to zero')
 1238 FORMAT(1X,'Standard deviations for pixel values are'/
     &       1X,'SIGMA(I) = ',G12.5,'   +  ',G12.5,' x SQRT(I)') 
 1240 FORMAT(/1X,'===Fitting cycle ',I4)
 1250 FORMAT(1X,'Number of peaks to fit: ',I5/
     &       1X,'Total number of parameters to fit: ',I5)
 1260 FORMAT(1X,'Global background with maximum entropy fitting is',
     &       1X,'not allowed'/'Switching to least-squares fitting')
 2000 FORMAT(1X,'Required least-squares workspace exceeds ',I9,
     *       1X,'bytes!'/
     &       1X,'Increase MAXBUF or install more memory')
      END

C     LAST UPDATE 22/04/97
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      PROGRAM FIT
      IMPLICIT NONE
C
C Purpose: Opens files, does line plots and peak fits.
C
C Calls  11: GETHDR , OPNFIL , OUTFIL , OPNNEW , ASK    , PAPER ,
C            PSPACE , FILNAM , FPLOT  , FRAME  , GREND 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Include file:
C
      INCLUDE 'FIT.COM'
C
C Parameter:
C
      DOUBLE PRECISION FACTOR
      PARAMETER(FACTOR=1.66510922231D0)
C
C Local variables:
C
      REAL    BUF(MAXDIM)
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,NCHAN,NFRAME,IMEM
      INTEGER ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
      INTEGER I,J,K,L,M,N,IM
      INTEGER ITERM,IPRINT,IUNIT,JUNIT,KUNIT,LUNIT
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM
      INTEGER ITEM(2),NW,NV
      REAL VAL
      CHARACTER*10 WORD
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
C ISPEC  : First header file of sequence
C LSPEC  : First header file of sequence
C MEM    : Positional or calibration data indicator
C IFFR   : First frame in sequence
C ILFR   : Last frame in sequence
C INCR   : Header file increment
C IFINC  : Frame increment
C HFNAM  : Header filename
C OFNAM  : Output header filename 
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C IMEM   : Output memory dataset
C NCHAN  : Nos. of pixels in image
C NFRAME : Nos. of frames in dataset
C ITERM  : Unit number for reading from terminal
C IPRINT : Unit number for writing to terminal
C IUNIT  : Unit for reading header file
C JUNIT  : Unit for reading data file
C KUNIT  : Unit for writing output file
C BUF   : Buffer for frame of input     
C
C FPLOT declarations:
C
      DOUBLE PRECISION A(MAXPAR),ASTDER(MAXPAR)
      REAL XPOS(MAXDIM),SIG(MAXDIM)
      REAL AREA,PI,SHAPE
      INTEGER IFLAG
      LOGICAL REPT,FIT,HCOPY,OTOUT,INIT,XAXIS,AUTO,AUTO1,SIGMA
      CHARACTER*12 CTYPE(7)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CHARACTER*80 NAMFIL
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C OTOKO initialization file declarations:
C 
      REAL SBUF(MAXDIM*MAXPAR)
      INTEGER NCHANI,NFRAMI,IFFRI,NCHANX,NFRAMX,NPKPAR
      CHARACTER*80 IHEAD1,IHEAD2
C
C OTOKO file output declarations:
C
      REAL O2BUF(MAXDIM,MAXPAR),O1BUF(MAXDIM)
      INTEGER IOFRAM,IOCHAN
C
C External functions:
C
      REAL PSNINT,VGTINT
      EXTERNAL PSNINT,VGTINT
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      INTEGER PGBEG
c      EXTERNAL PGBEG
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C Common block:
C
      INTEGER NPEAKS,NBAK,FEXP,NSELPK,KORIG
      LOGICAL LATCON
      DOUBLE PRECISION XORIG
      INTEGER FTYPE(20),VTABLE(MAXPAR)
      COMMON /FCOM  /NPEAKS,NBAK,FEXP,FTYPE,VTABLE,NSELPK
      COMMON /FCOM2 /XORIG,KORIG,LATCON
C
C Data:
C
      DATA  ITERM/5/ , IPRINT/6/ , IUNIT/10/ , JUNIT/11/ , KUNIT/12/ ,
     &      LUNIT/13/
      DATA  IMEM/1/ , PI /3.1415927/
      DATA  CTYPE /'Gaussian    ' , 'Lorentzian  ' , 'Pearson VII ' , 
     &             'Voigt       ' , 'Debye       ' , 'Dble expntl ' ,
     &             'Liebler     '/
C
C-----------------------------------------------------------------------
      WRITE(6,5000)
      CALL FLUSH(6)
C
C========Open FIT.OUT file
C
      OPEN(UNIT=KUNIT,STATUS='UNKNOWN',FILE='FIT.OUT')
C
C========Initialize graphics
C
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CALL PAPER(1)
      CALL PSPACE(0.1,0.9,0.1,0.9)
      CALL GPSTOP(0)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      IRC = PGBEG(0,'/XWINDOW',1,1)
c      IF(IRC.NE.1)GOTO 9999
c      CALL PGPAP(6.0,0.7)
c      CALL PGASK(.FALSE.)
c      CALL PGSVP(0.1,0.9,0.1,0.9)
c      CALL PGPAGE
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C========Start main file loop
C
 10   CONTINUE
C
C========Prompt for input file details
C
      WRITE(6,5010)
      CALL FLUSH(6)
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 9999
      IFRAME = IHFMAX + IFRMAX - 1
      WRITE(KUNIT,1010)HFNAM
      WRITE(KUNIT,1020)IFFR,ILFR,IFINC
      REPT = .FALSE.
C
C========Prompt for X-axis input
C
      XAXIS = .FALSE.
      CALL ASK('701 User-supplied X-axis',XAXIS,0)
      IF(XAXIS)THEN
         CALL GETOTO(XPOS,MAXDIM,1,NCHANX,NFRAMX,IHEAD1,IHEAD2,IRC)
         IF(IRC.EQ.0)THEN
            IF(NCHANX.NE.NCHAN.OR.NFRAMX.NE.1)THEN
               WRITE(6,2030)
               CALL FLUSH(6)
               XAXIS = .FALSE.
            ENDIF
         ELSE
            WRITE(6,2030)
            CALL FLUSH(6)
            XAXIS = .FALSE.
         ENDIF
      ENDIF
C
C========Prompt for peak fitting and associated files
C
      FIT = .TRUE.
      CALL ASK('702 Do you want to fit the data',FIT,0)
      IF(FIT)THEN
         INIT = .FALSE.
         CALL ASK('703 Read initial parameters from file',INIT,0)
         IF(INIT)THEN
            IFFRI = 0
            CALL GETOTO(SBUF,MAXDIM,MAXPAR,NCHANI,NFRAMI,IHEAD1,IHEAD2,
     &                  IRC)
            IF(IRC.NE.0)THEN
               INIT = .FALSE.
            ELSE
               READ(IHEAD2,'(I2)')NPEAKS
               READ(IHEAD2,'(3X,20(I1,1X))')(FTYPE(L),L=1,NPEAKS)
            ENDIF
         ENDIF
         SIGMA = .FALSE.
         CALL ASK('713 Read standard deviations from file',SIGMA,0)
         IF(SIGMA)THEN
            IFFRI = 0
            CALL GETOTO(SIG,MAXDIM,1,NCHANX,NFRAMX,IHEAD1,IHEAD2,
     &                  IRC)
            IF(IRC.NE.0)THEN
               WRITE(6,2040)
               CALL FLUSH(6)
               SIGMA = .FALSE.
            ENDIF
         ENDIF
         IF(.NOT.SIGMA)THEN
            DO 20 I=1,NCHAN
               SIG(I) = 1.0
 20         CONTINUE
         ENDIF             
         IOFRAM = 0
         IOCHAN = 0
         AUTO1 = .FALSE.
         AUTO = .FALSE.
         IF(IFFR.NE.ILFR)THEN
            CALL ASK('707 Automatic run after the first frame',AUTO1,0)
         ENDIF
      ENDIF
C
C========Prompt for hardcopy output
C
      HCOPY = .FALSE.
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CALL ASK('705 Do you require hardcopy output',HCOPY,0)
      IF(HCOPY)THEN
         WRITE(6,1000)
         CALL FLUSH(6)
         READ(ITERM,'(A80)',ERR=9999,END=9999)NAMFIL
         CALL FILNAM(NAMFIL)
      ENDIF
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C========No hardcopy at present
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C========Loop over specified headers
C
      DO 50 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
C
C========Loop over specified frames
C
            DO 40 J=1,IFRMAX
C
C========Read frames sequentially
C
               READ (JUNIT,REC=IFFR,ERR=9999)(BUF(K),K=1,NCHAN)
C
C========Fill out A with appropriate SBUF values
C
               IF(INIT)THEN
                  IFFRI = IFFRI + 1
                  IF(IFFRI.GT.NCHANI)THEN
                     WRITE(6,2020)IFFR - 1
                     CALL FLUSH(6)
                     INIT = .FALSE.
                  ELSE
                     K = 0
                     DO 45 M=1,NPEAKS
                        IF(FTYPE(M).EQ.1.OR.FTYPE(M).EQ.2)THEN
                           NPKPAR = 3
                        ELSEIF(FTYPE(M).EQ.3.OR.FTYPE(M).EQ.4)THEN
                           NPKPAR = 4
                        ELSEIF(FTYPE(M).EQ.5)THEN
                           NPKPAR = 3
                        ELSEIF(FTYPE(M).EQ.6)THEN
                           NPKPAR = 4
                        ELSEIF(FTYPE(M).EQ.7)THEN
                           NPKPAR = 6
                        ENDIF
                        DO 41 L=1,NPKPAR
                           IM = (10+(M-1)*10+L-1)*NCHANI + IFFRI
                           A(K+L) = DBLE(SBUF(IM))
 41                     CONTINUE
                        K = K + NPKPAR
 45                  CONTINUE
                     NBAK = INT(SBUF(IFFRI))
                     DO 46 M=NBAK+2,2,-1
                        K = K + 1
                        IM = (M-1)*NCHANI + IFFRI
                        A(K) = DBLE(SBUF(IM))
 46                  CONTINUE
                     FEXP = INT(SBUF(6*NCHANI+IFFRI))
                     DO 47 M=8,7+FEXP
                        K = K + 1
                        IM = (M-1)*NCHANI + IFFRI
                        A(K) = DBLE(SBUF(IM))
 47                  CONTINUE
                     IM = 9*NCHANI + IFFRI
                     XORIG = DBLE(SBUF(IM))
                  ENDIF
               ENDIF
C
C========Do plotting and fitting                   
C
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               CALL ERASE
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c               CALL PGPAGE 
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               WRITE(6,1005)IFFR
               CALL FLUSH(6)
               CALL FPLOT(BUF,NCHAN,REPT,FIT,A,ASTDER,INIT,NFRAMI,
     &                    XPOS,SIG,XAXIS,AUTO,IFLAG)
C
C========Exit if GUI demands it (i.e. ^D received)
C
               IF(IFLAG.EQ.-2)GOTO 60
C
C========Interpret A and write out parameters
C
               IF(FIT.AND.IFLAG.EQ.0)THEN
                  IOCHAN = IOCHAN + 1
C
C========Write out peaks parameters
C
                  WRITE(KUNIT,1030)IFFR
                  WRITE(6,1030)IFFR
                  CALL FLUSH(6)
                  IF(10*NPEAKS+10.GT.IOFRAM)IOFRAM = 10*NPEAKS + 10
                  M = 0
                  DO 30 L=1,NPEAKS
                     IF(FTYPE(L).EQ.1.OR.FTYPE(L).EQ.2)THEN
                        A(M+3) = ABS(A(M+3))
                        IF(FTYPE(L).EQ.1)THEN
                           AREA = SNGL(A(M+1)*A(M+3)/FACTOR)*SQRT(PI)
                        ELSE
                           AREA = SNGL(A(M+1)*A(M+3)/2.0D0)*PI
                        ENDIF
                        SHAPE = 0.0
                        N = 3
                     ELSEIF(FTYPE(L).EQ.3.OR.FTYPE(L).EQ.4)THEN
                        IF(FTYPE(L).EQ.3)THEN
                           AREA = PSNINT(A(M+1),A(M+3),A(M+4))
                        ELSE
                           AREA = VGTINT(A(M+1),A(M+3),A(M+4))
                        ENDIF
                        SHAPE = SNGL(A(M+4))
                        N = 4
                     ELSEIF(FTYPE(L).EQ.5)THEN
                        AREA = SNGL(A(M+1)*A(M+3))*SQRT(PI)*8.0/3.0
                        SHAPE = 0.0
                        N = 3
                     ELSEIF(FTYPE(L).EQ.6)THEN
                        AREA = 2.0*PI*SNGL(A(M+1)*A(M+4)*A(M+4)/
     &                                     (A(M+3)+A(M+4)))
     &                       /SIN(PI/(1.0+SNGL(A(M+4)/A(M+3))))
                        SHAPE = SNGL(A(M+4))
                        N = 4
                     ELSEIF(FTYPE(L).EQ.7)THEN
                        N = 6
                     ENDIF
                     IF(FTYPE(L).NE.7)THEN
                        WRITE(KUNIT,1035)L,CTYPE(FTYPE(L)),
     &                       (A(M+K),K=1,3),SHAPE,AREA
                        WRITE(6,1035)L,CTYPE(FTYPE(L)),
     &                       (A(M+K),K=1,3),SHAPE,AREA
                        O2BUF(IOCHAN,10*L+1) = SNGL(A(M+1))
                        O2BUF(IOCHAN,10*L+2) = SNGL(A(M+2))
                        O2BUF(IOCHAN,10*L+3) = SNGL(A(M+3))
                        O2BUF(IOCHAN,10*L+4) = SHAPE
                        O2BUF(IOCHAN,10*L+5) = AREA
                     ELSE
                        WRITE(KUNIT,1040)L,CTYPE(FTYPE(L)),
     &                       (A(M+K),K=1,6)
                        WRITE(6,1040)L,CTYPE(FTYPE(L)),
     &                       (A(M+K),K=1,6)
                        O2BUF(IOCHAN,10*L+1) = SNGL(A(M+1))
                        O2BUF(IOCHAN,10*L+2) = SNGL(A(M+2))
                        O2BUF(IOCHAN,10*L+3) = SNGL(A(M+3))
                        O2BUF(IOCHAN,10*L+4) = SNGL(A(M+4))
                        O2BUF(IOCHAN,10*L+5) = SNGL(A(M+5))
                        O2BUF(IOCHAN,10*L+6) = SNGL(A(M+6))
                     ENDIF
                     WRITE(KUNIT,1045)(ASTDER(M+K),K=1,N)
                     WRITE(6,1045)(ASTDER(M+K),K=1,N)
                     CALL FLUSH(6)
                     M = M + N
 30               CONTINUE
C
C========Write out background polynomial coefficients
C
                  WRITE(6,1050)NBAK,(K,K=0,4)
                  CALL FLUSH(6)
                  WRITE(KUNIT,1050)NBAK,(K,K=0,4)
                  WRITE(6,1060)(A(M+K),K=NBAK+1,1,-1)
                  CALL FLUSH(6)
                  WRITE(KUNIT,1060)(A(M+K),K=NBAK+1,1,-1)
                  WRITE(6,1065)(ASTDER(M+K),K=NBAK+1,1,-1)
                  CALL FLUSH(6)
                  WRITE(KUNIT,1065)(ASTDER(M+K),K=NBAK+1,1,-1)
                  O2BUF(IOCHAN,1) = NBAK
                  L = 1
                  DO 35 K=NBAK+1,1,-1
                     L = L + 1
                     O2BUF(IOCHAN,L) = SNGL(A(M+K))
 35               CONTINUE
                  IF(FEXP.GT.0)THEN
                     WRITE(6,1070)A(M+NBAK+2),A(M+NBAK+3)
                     CALL FLUSH(6)
                     WRITE(KUNIT,1070)A(M+NBAK+2),A(M+NBAK+3)
                     WRITE(6,1075)ASTDER(M+NBAK+2),ASTDER(M+NBAK+3)
                     CALL FLUSH(6)
                     WRITE(KUNIT,1075)ASTDER(M+NBAK+2),ASTDER(M+NBAK+3)
                     O2BUF(IOCHAN,7) = FEXP
                     L = 7
                     DO 36 K=NBAK+2,NBAK+FEXP+1
                        L = L + 1
                        O2BUF(IOCHAN,L) = SNGL(A(M+K))
 36                  CONTINUE
                  ENDIF
                  IF(LATCON)THEN
                     WRITE(6,1080)XORIG
                     CALL FLUSH(6)
                     WRITE(KUNIT,1080)XORIG
                     O2BUF(IOCHAN,10) = SNGL(XORIG)
                     IF(KORIG.GT.0)THEN
                        WRITE(6,1085)ASTDER(KORIG)
                        CALL FLUSH(6)
                        WRITE(KUNIT,1085)ASTDER(KORIG)
                     ENDIF
                  ENDIF
               ENDIF
C
C========Wait until ready for next plot
C
               IF(.NOT.FIT)THEN
                  IF(IFFR.NE.ILFR)THEN
                     WRITE(6,1090)
                     CALL FLUSH(6)
                     CALL RDCOMF(ITERM,WORD,NW,VAL,NV,ITEM,1,1,10,IRC)
                     IF(IRC.NE.0)THEN
                        IFLAG = -2
                        GOTO 60
                     ELSEIF(NW.GT.0)THEN
                        IF(WORD(1:2).EQ.'^D')THEN
                           IFLAG = -2
                           GOTO 60
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
               IF(IFLAG.EQ.0)REPT = .TRUE.
               IF(REPT.AND.AUTO1)AUTO = .TRUE.
               IFFR=IFFR+IFINC
 40         CONTINUE
            CLOSE (JUNIT)
         ENDIF
 50   CONTINUE
 60   CLOSE (JUNIT)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IF(HCOPY)CALL FILEND
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C========No hardcopy at present
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IF(FIT)THEN
         OTOUT = .TRUE.
         CALL ASK('704 Save parameters in a new OTOKO file',OTOUT,0)
         IF(OTOUT)THEN
            CALL OUTFIL(ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
            IF(IRC.NE.0)THEN
               WRITE(6,2000)
               OTOUT = .FALSE.
            ENDIF
         ENDIF
      ENDIF
      IF(OTOUT)THEN
         ICLO = 0
         JOP = 0
         IF(IOFRAM.GT.MAXPAR)THEN
            WRITE(6,2010)
            CALL FLUSH(6)
            IOFRAM = MAXPAR
         ENDIF
         WRITE(HEAD2,'(I2,1X,20(I1,1X))')NPEAKS,(FTYPE(L),L=1,NPEAKS)
         DO 80 I=1,IOFRAM
            IF(I.EQ.IOFRAM)ICLO = 1
            DO 70 J=1,IOCHAN
               O1BUF(J) = O2BUF(J,I)
 70         CONTINUE
            CALL DAWRT(LUNIT,OFNAM,IMEM,IOCHAN,IOFRAM,HEAD1,HEAD2,
     &           O1BUF,I,JOP,ICLO,IRC)
            IF(IRC.NE.0)THEN
               WRITE(6,2005)
               CALL FLUSH(6)
            ENDIF
 80      CONTINUE
      ENDIF
      IF(IFLAG.NE.-2)GOTO 10
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 9999 CALL GREND
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c 9999 CALL PGEND
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CLOSE(KUNIT)
      STOP  
C
 1000 FORMAT(1X,'900',
     &       1X,'Enter gridfile name: ',$)
 1005 FORMAT(/1X,'200',
     &       1X,'Plotting frame ',I4/)
 1010 FORMAT(/1X,'200'/
     &       1X,'Header filename: ',A20)
 1020 FORMAT(1X,'200',
     &       1X,'First frame ',I4,'  Last frame ',I4,'  Incr. ',I4)
 1030 FORMAT(/1X,'200'/
     &       1X,'Frame ',I4)
 1035 FORMAT(1X,'200',
     &       1X,'Peak ',I3,4X,A12/
     &       1X,'200',
     &       8X,'Height      Position    Width       Shape',
     &       7X,'Integrated'/
     &       1X,'Value',4X,5G12.5)
 1040 FORMAT(1X,'200',
     &       1X,'Peak ',I3,4X,A12/
     &       1X,'200',
     &       8X,'Scale       Position    Length      Number',
     &       6X,'Fraction    Flory'/
     &       1X,'Value',4X,6G12.5)
 1045 FORMAT(1X,'Std Err',2X,6G12.5)
 1050 FORMAT(/1X,'Background polynomial degree ',I3/
     &       1X,'200',6X,5(4X,'a',I1,6X))
 1060 FORMAT(1X,'Coeff',4X,5G12.5)
 1065 FORMAT(1X,'Std Err',2X,5G12.5)
 1070 FORMAT(/1X,'Exponential background'/
     &       10X,G12.5,' * exp(',G12.5,' * x)')
 1075 FORMAT(1X,'Std Err',2X,G12.5,7X,G12.5)
 1080 FORMAT(/1X,'Origin for lattice constraints = ',G12.5)
 1085 FORMAT(1X,'                       Std Err = ',G12.5)
 1090 FORMAT(1X,'806',
     &       1X,'Hit return for next frame or <ctrl-D> to exit'/
     &       1X,'200',
     &       1X,'Waiting to continue...')
 2000 FORMAT(1X,'400',
     &       1X,'Error opening output file')
 2005 FORMAT(1X,'400',
     &       1X,'Error writing binary output file')
 2010 FORMAT(1X,'300',
     &       1X,'Too many frames in output file - truncating')
 2020 FORMAT(/1X,'300',
     &       1X,'Warning - ',I4,' frames read - no more initialization',
     &       1X,'data'/)
 2030 FORMAT(1X,'300',
     &       1X,'Warning - invalid X-axis file - using default axis')
 2040 FORMAT(1X,'300',
     &       1X,'Warning - invalid standard deviation file -'
     &       1X,'using unit weights')
 5000 FORMAT(/1X,'200',
     &       1X,'FIT - 1-D peak fitting program'/
     &       1X,'Last update 22/04/97'/)
 5010 FORMAT(1X,'201 New input file')
      END                  





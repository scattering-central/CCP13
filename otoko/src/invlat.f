C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE INVLAT
      IMPLICIT NONE
C
C Purpose: Calculate inverse latice transform
C
      INCLUDE 'COMMON.FOR'
C
C Calls   7: APLOT  , DAWRT  , ERRMSG , GETHDR , GETVAL , GETXAX
C            OPNFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10),PI,TEMP
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,NCHAN,NFRAME
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NCHANX,NORDER
      INTEGER IOP,NVAL,I,J,K,L
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM,PFNAM
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
C KREC   : Output file record
C ISPEC  : First header file of sequence
C LSPEC  : Last header file in sequence
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
C NCHAN  : Nos. of data points in spectrum
C NFRAME : Nos. of time frames
C NCHANX :
C
      DATA  IMEM/1/ , PI/3.141592654/
C
C-----------------------------------------------------------------------
      WRITE (IPRINT,*) 'X-axis'
      CALL GETXAX (NCHANX,IRC)
      IF (IRC.NE.0) GOTO 999
10    ICLO=0
      JOP=0
      IOP=0
      KREC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      IFRAME=IHFMAX+IFRMAX-1
C
20    WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.EQ.0) GOTO 20
      NORDER=INT(VALUE(1))
C
      DO 90 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 80 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
               DO 40 K=1,NORDER
                  SP2(K)=0.0
                  SP3(K)=0.0
                  DO 30 L=1,NCHAN
                     TEMP=2.0*PI*XAX(L)*REAL(K)/XAX(NCHAN)
                     SP2(K)=SP2(K)+SP1(L)*COS(TEMP)
                     SP3(K)=SP3(K)+SP1(L)*SIN(TEMP)
30                CONTINUE
                  IF (SP3(K).LT.0.00001) SP3(K)=0.0
                  SP2(K)=SP2(K)*XAX(NCHAN)/REAL(NCHAN)
                  SP3(K)=SP3(K)*XAX(NCHAN)/REAL(NCHAN)
                  SP4(K)=SQRT(SP2(K)*SP2(K)+SP3(K)*SP3(K))
                  SP5(K)=ATAN2(SP3(K),SP2(K))
40             CONTINUE
               IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP4,NORDER)
               IF (KREC.GE.IFRAME) ICLO=1
               IF (KREC.EQ.1) THEN
                  WRITE (IPRINT,*) 'Modulus data'
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 100
                  WRITE (IPRINT,*) 'Phase data'
                  CALL OUTFIL (ITERM,IPRINT,PFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 100
               ENDIF
               CALL DAWRT (KUNIT,OFNAM,IMEM,NORDER,IFRAME,HEAD1,HEAD2,
     1                     SP4,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 100
               CALL DAWRT (LUNIT,PFNAM,IMEM,NORDER,IFRAME,HEAD1,HEAD2,
     1                     SP5,KREC,IOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 100
80          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
90    CONTINUE
100   CLOSE (UNIT=JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter number of diffraction orders: ',$)
      END

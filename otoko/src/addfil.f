C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE ADDFIL
      IMPLICIT NONE
C
C PURPOSE: Addition of single frame (or multiple) to part or series of
C          frames.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   6: ASKYES , APLOT  , DAWRT  , GETHDR , GETVAL , OPNFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    WEIGHT,VALUE(10)
      INTEGER ICLO,JOP,IRC,IMEM,KREC,IFRAME,NCHAN
      INTEGER ISPEC1,LSPEC1,MEM1,IFFR1,ILFR1,INCR1,IFINC1
      INTEGER ISPEC2,LSPEC2,MEM2,IFFR2,ILFR2,INCR2,IFINC2
      INTEGER IHFMX1,IFRMX1,IHFMX2,IFRMX2,NVAL,NCHAN2,I,K
      INTEGER NCHAN1,NFRAM1,NFRAM2,JFIRST,JLAST,ITEMP
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM1,HFNAM2,OFNAM
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMX1 : Nos. of frames in sequence
C IHFMX1 : Nos. of header file in sequence
C ISPEC1 : First header file in sequence
C LSPEC1 : Last header file in sequence
C MEM1   : Positional or calibration data indicator
C IFFR1  : First frame in sequence
C ILFR1  : Last frame in sequence
C INCR1  : Header file increment
C IFINC1 : Frame increment
C HFNAM1 : Header filename
C IFRMX2 : Nos. of frames in sequence
C IHFMX2 : Nos. of header file in sequence
C ISPEC2 : First header file in sequence
C LSPEC2 : Last header file in sequence
C MEM2   : Positional or calibration data indicator
C IFFR2  : First frame in sequence
C ILFR2  : Last frame in sequence
C INCR2  : Header file increment
C IFINC2 : Frame increment
C HFNAM2 : Header filename
C OFNAM  : Output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C KREC   : Output file record
C IMEM   : Output memory dataset
C NCHAN  : Nos of data points in spectrum 1
C NCHAN2 : Nos of data points in spectrum 2
C NFRAME : Nos of time frames
C WEIGHT : Weighting factors
C NVAL   : Nos. of numeric values entered
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
10    ICLO=0
      JOP=0
      KREC=0
C
      WRITE (6,*) 'Single file'
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM1,ISPEC1,LSPEC1,INCR1,MEM1,
     1             IFFR1,ILFR1,IFINC1,IHFMX1,IFRMX1,NCHAN1,IRC)
      IF (IRC.NE.0) GOTO 999
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM2,ISPEC2,LSPEC2,INCR2,MEM2,
     1             IFFR2,ILFR2,IFINC2,IHFMX2,IFRMX2,NCHAN2,IRC)
      IF (IRC.NE.0) GOTO 999
C
      NCHAN=NCHAN1
      IF (NCHAN2.GT.NCHAN) NCHAN=NCHAN2

      IFRAME=IHFMX2+IFRMX2-1
      ITEMP=IHFMX1+IFRMX1-1
      IF (ITEMP.GT.IFRAME) THEN
         CALL ERRMSG ('Error: In single file specification')
         GOTO 10
      ENDIF
C
      JFIRST=1
      JLAST=IFRAME
      IF (ITEMP.NE.IFRAME) THEN
 20      WRITE (IPRINT,1000) IFRAME
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 10
         IF (IRC.EQ.2) GOTO 20
         IF (NVAL.GE.1) JFIRST=INT(VALUE(1))
         IF (NVAL.GE.2) JLAST=INT(VALUE(2))
      ENDIF
C
      WEIGHT=1.0
 25   WRITE (IPRINT,1010)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 25
      IF (NVAL.GE.1) WEIGHT=VALUE(1)
C
      DO 40 I=1,IFRAME
C
         IF (I.EQ.1.OR.INCR2.NE.0) THEN
            CALL OPNFIL (LUNIT,HFNAM2,ISPEC2,MEM2,IFFR2,ILFR2,NCHAN2,
     1                   NFRAM2,IRC)
            IF (IRC.NE.0) GOTO 50
            ISPEC2=ISPEC2+INCR2
         ENDIF
C
         READ (LUNIT,REC=IFFR2) (SP2(K),K=1,NCHAN2)
         IFFR2=IFFR2+IFINC2
         KREC=KREC+1
         IF (INCR2.NE.0) CLOSE (UNIT=LUNIT)
C
         IF (I.GE.JFIRST.AND.I.LE.JLAST) THEN
            IF (I.EQ.JFIRST.OR.INCR1.NE.0) THEN
               CALL OPNFIL (JUNIT,HFNAM1,ISPEC1,MEM1,IFFR1,ILFR1,NCHAN1,
     1              NFRAM1,IRC)
               IF (IRC.NE.0) GOTO 50
               ISPEC1=ISPEC1+INCR1
            ENDIF
            IF (I.EQ.JFIRST.OR.ITEMP.GT.1) THEN
               READ (JUNIT,REC=IFFR1) (SP1(K),K=1,NCHAN1)
               IFFR1=IFFR1+IFINC1
               IF (INCR1.NE.0) CLOSE (UNIT=JUNIT)
            ENDIF
            DO 30 K=1,NCHAN
               SP2(K)=SP2(K)+SP1(K)*WEIGHT
 30         CONTINUE
         ENDIF
C
         IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP2,NCHAN)
         IF (KREC.GE.IFRAME) ICLO=1
         IF (KREC.EQ.1) THEN
            CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
            IF (IRC.NE.0) GOTO 50
         ENDIF
         CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1               SP2,KREC,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 50
40    CONTINUE
50    CLOSE (UNIT=JUNIT)
      CLOSE (UNIT=LUNIT)
      GOTO 10
999   RETURN
C
 1000 FORMAT (' Enter first & last frame for single file addition [1,',
     &     I4,']: ',$)
 1010 FORMAT (' Enter weights of single file [1.0]: ',$)
      END

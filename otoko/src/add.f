C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE ADD
      IMPLICIT NONE
C
C PURPOSE: WEIGHTED ADDITION OF TWO SPECTRA, CHANNEL PER CHANNEL.
C          (VECTOR SUM)
C
      INCLUDE 'COMMON.FOR'
C
C Calls   6: ASKYES , APLOT  , DAWRT  , GETHDR , GETVAL , OPNFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    WEIGHT(10)
      INTEGER ICLO,JOP,IRC,IMEM,KREC,IFRAME,NCHAN
      INTEGER ISPEC1,LSPEC1,MEM1,IFFR1,ILFR1,INCR1,IFINC1
      INTEGER ISPEC2,LSPEC2,MEM2,IFFR2,ILFR2,INCR2,IFINC2
      INTEGER IHFMX1,IFRMX1,IHFMX2,IFRMX2,NVAL,NCHAN2,I,K
      INTEGER NCHAN1,NCHAN3,NFRAM1,NFRAM2
      LOGICAL SAME,ASKYES
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
C SAME   : Same weighting factors to be used
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
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM1,ISPEC1,LSPEC1,INCR1,MEM1,
     1             IFFR1,ILFR1,IFINC1,IHFMX1,IFRMX1,NCHAN1,IRC)
      IF (IRC.NE.0) GOTO 999
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM2,ISPEC2,LSPEC2,INCR2,MEM2,
     1             IFFR2,ILFR2,IFINC2,IHFMX2,IFRMX2,NCHAN2,IRC)
      IF (IRC.NE.0) GOTO 999
C
      NCHAN=NCHAN1
      NCHAN3=NCHAN1
      IF (NCHAN2.GT.NCHAN3) NCHAN3=NCHAN2
      IF (NCHAN2.LT.NCHAN) NCHAN=NCHAN2
      IF (IHFMX1.LT.IHFMX2) IHFMX1=IHFMX2
      IF (IFRMX1.LT.IFRMX2) IFRMX1=IFRMX2
      IFRAME=IHFMX1+IFRMX1-1
C
      WRITE (IPRINT,1000)
      SAME=ASKYES (ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
C
      CALL FILL (SP3,NCHAN3,0.0)
      DO 40 I=1,IFRAME
C
         IF (I.EQ.1.OR.INCR1.NE.0) THEN
            CALL OPNFIL (JUNIT,HFNAM1,ISPEC1,MEM1,IFFR1,ILFR1,NCHAN1,
     1                   NFRAM1,IRC)
            IF (IRC.NE.0) GOTO 50
            ISPEC1=ISPEC1+INCR1
         ENDIF
         IF (I.EQ.1.OR.INCR2.NE.0) THEN
            CALL OPNFIL (LUNIT,HFNAM2,ISPEC2,MEM2,IFFR2,ILFR2,NCHAN2,
     1                   NFRAM2,IRC)
            IF (IRC.NE.0) GOTO 50
            ISPEC2=ISPEC2+INCR2
         ENDIF
C
         READ (JUNIT,REC=IFFR1) (SP1(K),K=1,NCHAN1)
         READ (LUNIT,REC=IFFR2) (SP2(K),K=1,NCHAN2)
         IFFR1=IFFR1+IFINC1
         IFFR2=IFFR2+IFINC2
         KREC=KREC+1
         IF (INCR1.NE.0) CLOSE (UNIT=JUNIT)
         IF (INCR2.NE.0) CLOSE (UNIT=LUNIT)
C
         IF (KREC.EQ.1.OR.(.NOT.SAME)) THEN
20          WRITE (IPRINT,1010)
            CALL GETVAL (ITERM,WEIGHT,NVAL,IRC)
            IF (IRC.EQ.1) GOTO 50
            IF (IRC.EQ.2) GOTO 20
            IF (NVAL.LT.2) WEIGHT(2)=1.0
            IF (NVAL.LT.1) WEIGHT(1)=1.0
         ENDIF
         DO 30 K=1,NCHAN
            SP3(K)=SP1(K)*WEIGHT(1)+SP2(K)*WEIGHT(2)
30       CONTINUE
C
         IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP3,NCHAN)
         IF (KREC.GE.IFRAME) ICLO=1
         IF (KREC.EQ.1) THEN
            CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
            IF (IRC.NE.0) GOTO 50
         ENDIF
         CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN3,IFRAME,HEAD1,HEAD2,
     1               SP3,KREC,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 50
40    CONTINUE
50    CLOSE (UNIT=JUNIT)
      CLOSE (UNIT=LUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Do you want the same constants for all for all spectra',
     1        ' [Y/N] [Y]: ',$)
1010  FORMAT (' Enter weights of first & second spectrum [1.0,1.0]: ',$)
      END

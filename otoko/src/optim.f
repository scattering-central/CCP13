C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE OPTIM
      IMPLICIT NONE
C
C Purpose: 
C
      INCLUDE 'COMMON.FOR'
C
C Calls   4: GETHDR , OPNFIL , APLOT  , DAWRT
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10)
      INTEGER ICLO,JOP,IRC,IMEM,KREC,IFRAME,NCHAN
      INTEGER ISPEC1,LSPEC1,MEM1,IFFR1,ILFR1,INCR1,IFINC1
      INTEGER ISPEC2,LSPEC2,MEM2,IFFR2,ILFR2,INCR2,IFINC2
      INTEGER IHFMX1,IFRMX1,IHFMX2,IFRMX2,NVAL,I,K
      INTEGER NCHAN2,ILRAN,IRRAN,ISTEP,IFINE,MODE,NFRAM1,NFRAM2
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
C NCHAN  : Nos of data points in spectrum
C NFRAME : Nos of time frames
C NVAL   : Nos. of numeric values entered
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
10    ICLO=0
      JOP=0
      KREC=0
C
      WRITE (IPRINT,*) 'Reference spectrum'
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM1,ISPEC1,LSPEC1,INCR1,MEM1,
     1             IFFR1,ILFR1,IFINC1,IHFMX1,IFRMX1,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM2,ISPEC2,LSPEC2,INCR2,MEM2,
     1             IFFR2,ILFR2,IFINC2,IHFMX2,IFRMX2,NCHAN2,IRC)
      IF (IRC.NE.0) GOTO 999
C
      IF ((IHFMX1+IFRMX1).NE.(IHFMX2+IFRMX2)) THEN
         CALL ERRMSG ('Error: Mismatched operation')
         GOTO 10
      ENDIF
      IF (NCHAN.NE.NCHAN2) THEN
         CALL ERRMSG ('Error: Mismatched channels')
         GOTO 10
      ENDIF
      IF (IHFMX1.LT.IHFMX2) IHFMX1=IHFMX2
      IF (IFRMX1.LT.IFRMX2) IFRMX1=IFRMX2
      IFRAME=IHFMX1+IFRMX1-1
11    WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 11
      IF (NVAL.LT.2) GOTO 11
      ILRAN=INT(VALUE(1))
      IRRAN=INT(VALUE(2))
12    WRITE (IPRINT,1010)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 12
      IF (NVAL.LT.1) GOTO 12
      ISTEP=INT(VALUE(1))
13    WRITE (IPRINT,1020)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 13
      IF (NVAL.LT.1) GOTO 13
      IFINE=INT(VALUE(1))
20    WRITE (IPRINT,1030)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.EQ.0) THEN
         MODE=0
      ELSE
         MODE=INT(VALUE(1))
         IF (MODE.LT.0.OR.MODE.GT.1) GOTO 20
      ENDIF          
C
      DO 40 I=1,IFRAME
C
         IF (I.EQ.1.OR.INCR1.NE.0) THEN
            CALL OPNFIL (JUNIT,HFNAM1,ISPEC1,MEM1,IFFR1,ILFR1,NCHAN,
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
         READ (JUNIT,REC=IFFR1) (SP1(K),K=1,NCHAN)
         READ (LUNIT,REC=IFFR2) (SP2(K),K=1,NCHAN)
         IFFR1=IFFR1+IFINC1
         IFFR2=IFFR2+IFINC2
         KREC=KREC+1
         IF (INCR1.NE.0) CLOSE (UNIT=JUNIT)
         IF (INCR2.NE.0) CLOSE (UNIT=LUNIT)
C
         IF (MODE.EQ.0) THEN
            CALL SHIFT(SP1,SP2,SP3,SP4,NCHAN,ILRAN,IRRAN,ISTEP,IFINE)
         ELSE
            CALL SHIFT(SP1,SP2,SP4,SP3,NCHAN,ILRAN,IRRAN,ISTEP,IFINE)
         ENDIF
C
         IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP3,NCHAN)
         IF (KREC.GE.IFRAME) ICLO=1
         IF (KREC.EQ.1) THEN
            CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
            IF (IRC.NE.0) GOTO 50
         ENDIF
         CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1               SP3,KREC,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 50
40    CONTINUE
50    CLOSE (UNIT=JUNIT)
      CLOSE (UNIT=LUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter limits where overlap should be calculated: ',$)
1010  FORMAT (' Enter nos. of steps/channel for overlap: ',$)
1020  FORMAT (' Enter +/- nos. of steps for fine search: ',$)
1030  FORMAT (' Enter [0] for shifted spectrum, [1] for residue',
     1        ' output. [0]: ',$)
      END

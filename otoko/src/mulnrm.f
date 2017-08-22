C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE MULNRM
      IMPLICIT NONE
C
C Purpose: Multiply and normalise data in a region of interest with a
C          calibration file. Data points outside the region of interest
C          are set to zero.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   7: APLOT  , DAWRT  , ERRMSG , FILL   , GETCHN , GETHDR
C            OPNFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER ICLO,JOP,IRC,IMEM,KREC,IFRAME
      INTEGER ISPEC1,LSPEC1,MEM1,IFFR1,ILFR1,INCR1,IFINC1
      INTEGER ISPEC2,LSPEC2,MEM2,IFFR2,ILFR2,INCR2,IFINC2
      INTEGER IHFMX1,IFRMX1,IHFMX2,IFRMX2,NCHAN2
      INTEGER NCHAN1,JCH1,JCH2,NFRAM1,NFRAM2,I,J,K
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
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
10    ICLO=0
      JOP=0
      KREC=0
      WRITE (IPRINT,*) 'Calibration file(s) '
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM1,ISPEC1,LSPEC1,INCR1,MEM1,
     1             IFFR1,ILFR1,IFINC1,IHFMX1,IFRMX1,NCHAN1,IRC)
      IF (IRC.NE.0) GOTO 999
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM2,ISPEC2,LSPEC2,INCR2,MEM2,
     1             IFFR2,ILFR2,IFINC2,IHFMX2,IFRMX2,NCHAN2,IRC)
      IF (IRC.NE.0) GOTO 10
C
      IFRAME=IHFMX2+IFRMX2-1
      IF (NCHAN1.LT.IFRAME) THEN
         CALL ERRMSG ('Error: Mismatched operation')
         GOTO 10
      ENDIF
      CALL FILL (SP3,NCHAN2,0.0)
      CALL GETCHN (ITERM,IPRINT,NCHAN2,JCH1,JCH2,IRC)
      IF (IRC.NE.0) GOTO 10
C
      DO 40 I=1,IHFMX2
C
         CALL OPNFIL (JUNIT,HFNAM1,ISPEC1,MEM1,IFFR1,ILFR1,NCHAN1,
     &                NFRAM1,IRC)
         IF (IRC.NE.0) GOTO 50
         ISPEC1=ISPEC1+INCR1
         CALL OPNFIL (LUNIT,HFNAM2,ISPEC2,MEM2,IFFR2,ILFR2,NCHAN2,
     &                NFRAM2,IRC)
         IF (IRC.NE.0) GOTO 50
         ISPEC2=ISPEC2+INCR2
C
         READ (JUNIT,REC=IFFR1) (SP1(K),K=1,NCHAN1)
C
         DO 30 J=1,IFRMX2
            READ (LUNIT,REC=IFFR2) (SP2(K),K=1,NCHAN2)
            KREC=KREC+1
C
            DO 20 K=JCH1,JCH2
               SP3(K)=SP2(K)*SP1(IFFR2)
20          CONTINUE
            IFFR2=IFFR2+IFINC2
            IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP3,NCHAN2)
            IF (KREC.GE.IFRAME) ICLO=1
            IF (KREC.EQ.1) THEN
               CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
               IF (IRC.NE.0) GOTO 50
            ENDIF
            CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN2,IFRAME,HEAD1,HEAD2,
     1                  SP3,KREC,JOP,ICLO,IRC)
            IF (IRC.NE.0) GOTO 50
30       CONTINUE
         CLOSE (UNIT=JUNIT)
         CLOSE (UNIT=LUNIT)
40    CONTINUE
50    CLOSE (UNIT=JUNIT)
      CLOSE (UNIT=LUNIT)
      GOTO 10
999   RETURN
C
      END

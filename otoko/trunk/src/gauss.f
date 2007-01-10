C     LAST UPDATE
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE gauss
      IMPLICIT NONE
C
C Purpose: Generate gaussian profiles
C
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
      REAL    PI,TEMP,XSQ,ZERO,SIGMA
      INTEGER ICLO,JOP,IRC,IMEM,KREC
      INTEGER ISPEC1,LSPEC1,MEM1,IFFR1,ILFR1,INCR1,IFINC1
      INTEGER ISPEC2,LSPEC2,MEM2,IFFR2,ILFR2,INCR2,IFINC2
      INTEGER ISPEC3,LSPEC3,MEM3,IFFR3,ILFR3,INCR3,IFINC3
      INTEGER IHFMX1,IFRMX1,NCHAN1,NFRAM1
      INTEGER IHFMX2,IFRMX2,NCHAN2,NFRAM2
      INTEGER IHFMX3,IFRMX3,NCHAN3,NFRAM3
      INTEGER JCH1,JCH2,I,J,K,NCHAN4
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM1,HFNAM2,HFNAM3,OFNAM
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
      DATA  PI/3.141592654/
C
C-----------------------------------------------------------------------
10    ICLO=0
      JOP=0
      KREC=0
C
      write (iprint,*) 'Sigma (halfwidth) data: '
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM1,ISPEC1,LSPEC1,INCR1,MEM1,
     &             IFFR1,ILFR1,IFINC1,IHFMX1,IFRMX1,NCHAN1,IRC)
      IF (IRC.NE.0) GOTO 999
C 
      write (iprint,*) 'Channels for centre of gaussian'
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM2,ISPEC2,LSPEC2,INCR2,MEM2,
     &             IFFR2,ILFR2,IFINC2,IHFMX2,IFRMX2,NCHAN2,IRC)
      IF (IRC.NE.0) GOTO 10

      write (iprint,*) 'Integrated intensities'
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM3,ISPEC3,LSPEC3,INCR3,MEM3,
     &             IFFR3,ILFR3,IFINC3,IHFMX3,IFRMX3,NCHAN3,IRC)
      IF (IRC.NE.0) GOTO 10
C 
      NCHAN4=512
      CALL GETCHN (ITERM,IPRINT,NCHAN4,JCH1,JCH2,IRC)
      IF (IRC.NE.0) GOTO 10
C
C========READ THE sigma, centre channel & intensity files
C
      CALL OPNFIL (JUNIT,HFNAM1,ISPEC1,MEM1,IFFR1,ILFR1,NCHAN1,
     &             NFRAM1,IRC)
      IF (IRC.NE.0) GOTO 50
      CALL OPNFIL (KUNIT,HFNAM2,ISPEC2,MEM2,IFFR2,ILFR2,NCHAN2,
     &                NFRAM2,IRC)
      IF (IRC.NE.0) GOTO 50
      CALL OPNFIL (LUNIT,HFNAM3,ISPEC3,MEM3,IFFR3,ILFR3,NCHAN3,
     &                NFRAM3,IRC)
      IF (IRC.NE.0) GOTO 50
C
C========READ CALIBRATION FILES FOR BUFFER AND DATA
C
      READ (JUNIT,REC=IFFR1) (SP1(K),K=1,NCHAN1)
      READ (KUNIT,REC=IFFR2) (SP2(K),K=1,NCHAN2)
      READ (LUNIT,REC=IFFR3) (SP3(K),K=1,NCHAN3)

      DO 40 I=1,NCHAN1
         SIGMA=SP1(I)
         ZERO=SP2(I)
         TEMP=1.0/((SIGMA)*SQRT(PI))    
         DO 30 J=1,NCHAN4
            XSQ=(REAL(J)-ZERO)*(REAL(J)-ZERO)
            SP4(J)=TEMP*EXP(-XSQ/(SIGMA*SIGMA))*SP3(I)
 30      CONTINUE
C
         KREC=KREC+1
         IF (NCHAN1.EQ.1) CALL APLOT (ITERM,IPRINT,SP4,NCHAN4)
         IF (KREC.GE.NCHAN1) ICLO=1
         IF (KREC.EQ.1) THEN
            CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
            IF (IRC.NE.0) GOTO 50
         ENDIF
         CALL DAWRT (MUNIT,OFNAM,IMEM,NCHAN4,NCHAN1,HEAD1,HEAD2,
     1        SP4,KREC,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 50
 40   CONTINUE

 50   CLOSE (UNIT=JUNIT)
      CLOSE (UNIT=KUNIT)
      CLOSE (UNIT=LUNIT)
      GOTO 10
999   RETURN
      END

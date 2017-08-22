C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE INTEG
      IMPLICIT NONE
C
C Purpose: Integrate a series of data files.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   5: APLOT  , DAWRT  , GETCHN , GETHDR , OPNFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    SUM
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,MFRAME,NPOINT
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,JCH1,JCH2
      INTEGER NCHAN,NFRAME,I,J,K
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM
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
C JCH1   : First channel of interest
C JCH2   : Last channel of interest
C SUM    : Integral of spectrum
C NPOINT : Nos. of channels to write
C MFRAME : Nos. of frames to write
C
      DATA  IMEM/1/ , ICLO/1/ , KREC/1/ , MFRAME/1/
C
C-----------------------------------------------------------------------
C
10    JOP=0
      NPOINT=0
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
      CALL GETCHN (ITERM,IPRINT,NCHAN,JCH1,JCH2,IRC)
      IF (IRC.NE.0) GOTO 10
      DO 40 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 30 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               NPOINT=NPOINT+1
               SUM=0.0
               DO 20 K=JCH1,JCH2
                  SUM=SUM+SP1(K)
20             CONTINUE
               SP2(NPOINT)=SUM
30          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
40    CONTINUE
      IF (IFRAME.EQ.1) THEN
         WRITE(IPRINT,1000) SUM
      ELSE
         CALL APLOT (ITERM,IPRINT,SP2,NPOINT)
         CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
         IF (IRC.EQ.0) THEN
            CALL DAWRT (KUNIT,OFNAM,IMEM,NPOINT,MFRAME,HEAD1,HEAD2,
     1                  SP2,KREC,JOP,ICLO,IRC)
         ENDIF
      ENDIF
      GOTO 10
999   RETURN
C
1000  FORMAT (' Integral value is : ',G13.5)
      END

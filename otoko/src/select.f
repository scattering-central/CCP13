C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SELECT
      IMPLICIT NONE
C
C Purpose: Select
C
      INCLUDE 'COMMON.FOR'
C
C CALLS   7: APLOT  , DAWRT  , FILL   , GETCHN , GETHDR , GETVAL
C            OPNFIL
C CALLED BY: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10)
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,NCHAN,NFRAME
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
      INTEGER ICH1,ICH2,ISHIFT,NVAL,I,J,K,L
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
C ICH1   : First channel of interest
C ICH2   : Last channel of interest
C ISHIFT : Nos of channel to be shifted
C VALUE  : Numeric values entered at terminal
C NVAL   : Nos. of values entered at terminal
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
10    ICLO=0
      JOP=0
      KREC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      IFRAME=IHFMAX+IFRMAX-1
      CALL FILL (SP2,NCHAN,0.0)
      CALL GETCHN (ITERM,IPRINT,NCHAN,ICH1,ICH2,IRC)
      IF (IRC.NE.0) GOTO 10
20    WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.LT.1) GOTO 20
      ISHIFT=INT(VALUE(1))
      DO 50 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 40 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
C
               DO 30 K=ICH1,ICH2
                  L=K+ISHIFT
                  IF (L.GE.1.AND.L.LE.NCHAN) SP2(L)=SP1(K)
30             CONTINUE
C
               IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP2,NCHAN)
               IF (KREC.GE.IFRAME) ICLO=1
               IF (KREC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 60
               ENDIF
               CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1                     SP2,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 60
40          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
50    CONTINUE
60    CLOSE (UNIT=JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter number of channels (+ve shifts right, -ve ',
     1        'shift left): ',$)
      END

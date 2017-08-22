C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE ADDCON
      IMPLICIT NONE
C
C Purpose: Add a constant to a selected range in spectrum.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   9: APLOT  , ASKYES , DAWRT  , ERRMSG , FILL   , GETCHN
C            GETVAL , GETHDR , OPNFIL , 
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    CONST(10)
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,NCHAN,NFRAME,IMEM,JCH1
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL,I,J,K,JCH2
      LOGICAL SAME,RZERO,ASKYES
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
C CONST  : Weighting factor
C SAME   : Same weighting factors to be used
C RZERO  : Zero data outside selected range
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
      IFRAME=IHFMAX+IFRMAX-1
C
      CALL GETCHN (ITERM,IPRINT,NCHAN,JCH1,JCH2,IRC)
      IF (IRC.NE.0) GOTO 10
      CALL FILL (SP2,NCHAN,0.0)
      WRITE (IPRINT,1000)
      RZERO=ASKYES (ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
      WRITE (IPRINT,1010)
      SAME=ASKYES (ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
C
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
               IF (KREC.EQ.1.OR.(.NOT.SAME)) THEN
20                WRITE (IPRINT,1020)
                  CALL GETVAL (ITERM,CONST,NVAL,IRC)
                  IF (IRC.EQ.1) GOTO 60
                  IF (IRC.EQ.2) GOTO 20
                  IF (NVAL.EQ.0) CONST(1)=1.0
               ENDIF
               DO 30 K=1,NCHAN
                  IF (K.GE.JCH1.AND.K.LE.JCH2) THEN
                     SP2(K)=SP1(K)+CONST(1)
                  ELSEIF (.NOT.RZERO) THEN
                     SP2(K)=SP1(K)
                  ENDIF
30             CONTINUE
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
1000  FORMAT (' Zero output outside range [Y/N] [Y]: ',$)
1010  FORMAT (' Do you want the same constants for all spectra',
     1        ' [Y/N] [Y]: ',$)
1020  FORMAT (' Enter constant [1.0]: ',$)
      END

C     LAST UPDATE 15/02/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE REMZER
C
C Purpose: REMOVE ZEROES FROM DATA
C
      INCLUDE 'COMMON.FOR'
C
C Calls   9: APLOT  , DAWRT  , FILL   , GETCHN , GETHDR
C            GETXAX , OPNFIL , OUTFIL , SFT1D
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER      ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,NCHANX
      INTEGER      KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM,XFNAM
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
C KREC   : Output file record
C ISPEC  : Frame nos. part of filename
C IFFR   : First frame in sequence
C ILFR   : Last frame in sequence
C INCR   : Header file increment
C IFINC  : Frame increment
C HFNAM  : Header filename
C OFNAM  : output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C IMEM   : Output memory dataset
C NCHANX : Nos. of points in x-axis
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
10    WRITE (IPRINT,*) 'X-axis'
      CALL GETXAX (NCHANX,IRC)
      IF (IRC.NE.0) GOTO 999
      KREC=0
      JOP=0
      ICLO=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      IFRAME=IHFMAX+IFRMAX-1
      DO 40 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 30 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
C
               L=0
               DO 20 K=1,NCHAN
                  IF (SP1(K).EQ.0.0) GOTO 20
                  L=L+1
                  SP2(L)=SP1(K)
                  SP3(L)=XAX(K)
20             CONTINUE
               MCHAN=L
C
               IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP2,MCHAN)
               IF (KREC.GE.IFRAME) ICLO=1
               IF (KREC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 60
               ENDIF
               XFNAM=OFNAM
               CALL DAWRT (KUNIT,OFNAM,IMEM,MCHAN,IFRAME,HEAD1,HEAD2,
     1                     SP2,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 60
               IF (KREC.EQ.1) THEN
                  JOP=0
                  XFNAM(10:10)='X'
               ENDIF
               CALL DAWRT (LUNIT,XFNAM,IMEM,MCHAN,IFRAME,HEAD1,HEAD2,
     1                     SP3,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 60
30          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
40    CONTINUE
C
60    CLOSE (UNIT=JUNIT)
      GOTO 10
 999  RETURN
      END

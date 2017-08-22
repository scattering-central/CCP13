C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SFT
      IMPLICIT NONE
C
C Purpose: Singleton Fast Forward fourier transform
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
      REAL         DELTA
      INTEGER      ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,NCHANX
      INTEGER      KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,MID
      INTEGER      NCHAN,ICH1,ICH2,NFRAME,I,J,K
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM,PFNAM,XFNAM
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
C OFNAM  : Modulus output header filename
C PFNAM  : Phase output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C IMEM   : Output memory dataset
C NCHANX : Nos. of points in x-axis
C MID    : Midpoint of spectrum
C DELTA  : x-axis increment
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
      WRITE (IPRINT,*) 'X-axis'
      CALL GETXAX (NCHANX,IRC)
      IF (IRC.NE.0) GOTO 999
10    ICLO=0
      JOP=0
      KREC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      IFRAME=IHFMAX+IFRMAX-1
      CALL GETCHN (ITERM,IPRINT,NCHAN,ICH1,ICH2,IRC)
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
               KREC=KREC+1
C
               CALL FILL (SP3,4096,0.0)
               CALL FILL (SP4,4096,0.0)
               DO 20 K=ICH1,ICH2
                  SP3(K)=SP1(K)
20             CONTINUE
C
               DO 1 K=2,NCHAN,2
                  SP3(K)=-SP3(K)
1              CONTINUE
               CALL SFT1D(SP3,SP4,NCHAN,NCHAN,NCHAN,1)
               DO 2 K=2,NCHAN,2
                  SP3(K)=-SP3(K)
                  SP4(K)=-SP4(K)
2              CONTINUE
C
               DO 25 K=1,NCHAN
                  SP1(K)=SQRT(SP3(K)*SP3(K)+SP4(K)*SP4(K))
                  IF (SP3(K).EQ.0) SP3(K)=1.0E-20
                  SP2(K)=ATAN2(SP4(K),SP3(K))
25             CONTINUE
C
               IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP1,NCHAN)
               IF (KREC.GE.IFRAME) ICLO=1
               IF (KREC.EQ.1) THEN
                  WRITE (IPRINT,*) 'Modulus output'
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 60
               ENDIF
               XFNAM=OFNAM
               CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1                     SP1,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 60
               IF (KREC.EQ.1) THEN
                  JOP=0
                  WRITE (IPRINT,*) 'Phase output'
                  CALL OUTFIL (ITERM,IPRINT,PFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 60
               ENDIF
               CALL DAWRT (KUNIT,PFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1                     SP2,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 60
30          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
40    CONTINUE
C
      MID=NCHAN/2+1
      XAX(MID)=0.0
      DELTA=1/XAX(NCHAN)
      DO 50 I=MID+1,NCHAN
         XAX(I)=REAL(I-MID)*DELTA
50    CONTINUE
      DO 55 I=MID-1,1,-1
         XAX(I)=-REAL(MID-I)*DELTA
55    CONTINUE
      JOP=0
      ICLO=1
      IFRAME=1
      KREC=1
      XFNAM(10:10)='X'
      CALL DAWRT (KUNIT,XFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1            XAX,KREC,JOP,ICLO,IRC)
60    CLOSE (UNIT=JUNIT)
      GOTO 10
999   RETURN
      END

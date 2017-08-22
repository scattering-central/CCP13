C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE BACK
      IMPLICIT NONE
C
C Purpose: Automatic background removal by spline.
C
      INCLUDE 'COMMON.FOR'
C
C Calls  11: APLOT  , ASKYES , DAWRT  , ERRMSG , FILL   , GETCHN
C            GETVAL , GETHDR , OPNFIL , ASKNO  , OUTFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    CONST(10),SUM,SIGMA
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,NCHAN,NFRAME
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL
      INTEGER IMEM,I,J,K,M,NITER,IKNOT
      LOGICAL AGAIN,ASKNO,ZERO,ASKYES
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
C========SPLINE DATA
C
               DO 41 K=1,NCHAN
                  SP3(K)=SP1(K)
                  SP4(K)=REAL(K)
41             CONTINUE                                 
C
24             IF (KREC.EQ.1) THEN
                  NITER=1
                  WRITE (IPRINT,1010)
                  CALL GETVAL (ITERM,CONST,NVAL,IRC)
                  IF (IRC.EQ.1) GOTO 60
                  IF (IRC.EQ.2) GOTO 24
                  IF (NVAL.EQ.1) NITER=INT(CONST(1))
               ENDIF
C
               DO 25 M=1,NITER
                  CALL FILL (SP5,NCHAN,1.0)
                  IKNOT=NCHAN/2
                  CALL VC03A (NCHAN,IKNOT,SP4,SP3,SP5,SP6,SP7,SP8,SP9,
     1                        SP10,SP11,0,SPW)
                  DO 55 K=1,NCHAN
                     SP2(K)=SP1(K)-(SP3(K)-SP6(K))
                     SP1(K)=SP2(K)
55                CONTINUE
                  IF (M.NE.NITER) THEN
C
C========FIND SIGMA WEIGHTING
C
                     IF (M.EQ.1.AND.KREC.EQ.1) THEN
20                      WRITE (IPRINT,1020)
                        CALL GETVAL (ITERM,CONST,NVAL,IRC)
                        IF (IRC.EQ.1) GOTO 60
                        IF (IRC.EQ.2) GOTO 20
                        IF (NVAL.EQ.0) CONST(1)=1.0
                     ENDIF
C
C========FIND MEAN RESIDUAL
C
                     SUM=0.0
                     DO 30 K=1,NCHAN
                        SUM=SUM+ABS(SP2(K))
30                   CONTINUE
                     SUM=SUM/REAL(NCHAN)
                     SIGMA=CONST(1)*SUM
                     DO 32 K=1,NCHAN
                        SP3(K)=SP2(K)
                        IF (SP2(K).GT.SIGMA) SP3(K)=SIGMA
32                   CONTINUE
                  ENDIF
25             CONTINUE
               IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP2,NCHAN)
               IF (KREC.EQ.1) THEN
                  WRITE (IPRINT,1000) 
                  AGAIN=ASKNO (ITERM,IRC)                 
                  IF (.NOT.AGAIN) GOTO 24
                  WRITE (IPRINT,1030)
                  ZERO=ASKYES (ITERM,IRC)                 
                  IF (ZERO) THEN
27                   WRITE (IPRINT,1020)
                     CALL GETVAL (ITERM,CONST,NVAL,IRC)
                     IF (IRC.EQ.1) GOTO 60
                     IF (IRC.EQ.2) GOTO 27
                     IF (NVAL.EQ.0) CONST(1)=1.0
                  ENDIF
               ENDIF
               IF (ZERO) THEN
                  SUM=0.0
                  DO 33 K=1,NCHAN
                     SUM=SUM+ABS(SP2(K))
33                CONTINUE
                  SUM=SUM/REAL(NCHAN)
                  SIGMA=CONST(1)*SUM
                  DO 34 K=1,NCHAN
                     SP2(K)=SP2(K)-SIGMA
                     IF (SP2(K).LT.0.0) SP2(K)=0.0
34                CONTINUE
               ENDIF
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
1000  FORMAT (' Another iteration [Y/N] [N]: ',$)
1010  FORMAT (' Enter number of iterations [1]: ',$)
1020  FORMAT (' Enter sigma weighting [1.0]: ',$)
1030  FORMAT (' Do you want to zero [Y/N] [Y]: ',$)
      END

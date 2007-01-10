C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE PKK
      IMPLICIT NONE
C
C Purpose: Subtracts the background under a peak by polynomial fitting
C          to two ranges of points on either side of the peak. 
C
      INCLUDE 'COMMON.FOR'
C
C Calls   7: APLOT  , DAWRT  , ERRMSG , FILL   , GETHDR , GETVAL
C            OPNFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10)
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,NCHAN,NFRAME
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL
      INTEGER L1,L2,L3,L4,MDEG,NPNTS,NPNT2,I,J,K,L
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
C
      DATA  IMEM/1/ , KREC/1/
C
C-----------------------------------------------------------------------
10    ICLO=0
      KREC=0
      JOP=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
20    WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.EQ.0) THEN
         MDEG=1
      ELSE
         MDEG=INT(VALUE(1))
      ENDIF
30    WRITE (IPRINT,1010)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 30
      IF (NVAL.LT.4) THEN 
         CALL ERRMSG ('Error: Insufficient input')
         GOTO 30
      ELSE
         L1=INT(VALUE(1))
         L2=INT(VALUE(2))
         L3=INT(VALUE(3))
         L4=INT(VALUE(4))
         IF ((L1.LT.1.OR.L1.GT.NCHAN).OR. 
     1       (L2.LT.1.OR.L2.GT.NCHAN).OR.
     2       (L3.LT.1.OR.L3.GT.NCHAN).OR.
     3       (L4.LT.1.OR.L4.GT.NCHAN)) THEN
            CALL ERRMSG ('Error: Value outside of range')
            GOTO 20
         ENDIF
      ENDIF
      DO 100 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 90 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
C
               CALL FILL (SP3,NCHAN,0.0)
               DO 40 K=L1,L2
                  L=K-L1+1
                  SP5(L)=REAL(K)
                  SP6(L)=1.0
                  SP3(L)=SP1(K)
40             CONTINUE
               DO 50 K=L3,L4
                  L=K-L3+L2-L1+2
                  SP5(L)=REAL(K)
                  SP6(L)=1.0
                  SP3(L)=SP1(K)
50             CONTINUE
               NPNTS=L2-L1+1+L4-L3+1
               CALL VC01A (SP5,SP3,SP6,SP2,NPNTS,SP7,SP8,SP9,SP10,SP11,
     1                     SP12,MDEG,SPW)
               DO 60 K=L1,L4
                  L=K-L1+1
                  SP6(L)=REAL(K)
60             CONTINUE
               NPNT2=L4-L1+1
               CALL POLCAL (SP6,SP3,SP7,SP8,SP9,MDEG,1,NPNT2)
               CALL FILL (SP2,NCHAN,0.0)
               DO 80 K=L1,L4
                  L=K-L1+1
                  SP2(K)=SP1(K)-SP3(L)
80             CONTINUE
               IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP2,NCHAN)
               IF (KREC.GE.IFRAME) ICLO=1
               IF (KREC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 110
               ENDIF
               CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1                     SP2,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 110
90          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
100   CONTINUE
110   CLOSE (UNIT=JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter degree of polynomial [1]: ',$)
1010  FORMAT (' Enter range of points on either side of peak,',/,
     1        ' low_min, low_max, high_min, high_max: ',$)
      END

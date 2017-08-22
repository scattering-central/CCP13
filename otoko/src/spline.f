C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SPLINE (XAXIS)
      IMPLICIT NONE
C
C Purpose: Calculate spline function through data.
C
      LOGICAL XAXIS
C
C XAXIS  : Set to true if user supplied x-axis
C
      INCLUDE 'COMMON.FOR'
C
C Calls  10: APLOT  , ASKNO  , DAWRT  , ERRMSG , FILL   , GETCHN
C            GETHDR , GETVAL , GETXAX , OPNFIL
C Harlib  2: TG01B  , VC03A
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10),RAN,TG01B
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,NCHAN,NFRAME
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NCHANX
      INTEGER NPNTS,ICH1,ICH2,NVAL,IKNOT,NOS,I,J,K,L
      LOGICAL EQUAL,ASKNO
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
C NCHANX :
C NPNTS  :
C ICH1   :
C ICH2   :
C NVAL   :
C IKNOT  :
C EQUAL  :
C VALUE  :
C RAN    :
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
      IF (XAXIS) THEN
         WRITE (IPRINT,*) 'X-axis'
         CALL GETXAX (NCHANX,IRC)
         IF (IRC.NE.0) GOTO 999
      ENDIF
10    ICLO=0
      JOP=0
      KREC=0
      EQUAL=.TRUE.
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      IFRAME=IHFMAX+IFRMAX-1
C
      CALL GETCHN (ITERM,IPRINT,NCHAN,ICH1,ICH2,IRC)
      IF (IRC.NE.0) GOTO 10
      IF (XAXIS) THEN
         WRITE (IPRINT,*) 'Values will be sorted in',
     1                    ' ascending order of X'
         WRITE (IPRINT,1000)
         EQUAL=ASKNO (ITERM,IRC)
         IF (IRC.NE.0) GOTO 10
         IF (.NOT.EQUAL) THEN
20          WRITE (IPRINT,1010)
            CALL GETVAL (ITERM,VALUE,NVAL,IRC)
            IF (IRC.EQ.1) GOTO 10
            IF (IRC.EQ.2) GOTO 20
            IF (NVAL.EQ.0) THEN
               NPNTS=512
            ELSE
               NPNTS=INT(VALUE(1))             
            ENDIF
         ENDIF
      ENDIF
      CALL FILL (SP5,NCHAN,1.0)
C
      DO 90 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 80 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
C
               DO 40 K=ICH1,ICH2
                  L=K-ICH1+1
                  SP3(L)=SP1(K)
                  IF (XAXIS) THEN
                     SP4(L)=XAX(K)
                  ELSE
                     SP4(L)=REAL(K)
                  ENDIF
40             CONTINUE                                 
               NOS=ICH2-ICH1+1
               IF (XAXIS) CALL SORT (SP4,SP3,NOS,'X')
               IKNOT=NOS/2
               CALL VC03A (NOS,IKNOT,SP4,SP3,SP5,SP6,SP7,SP8,SP9,SP10,
     1                     SP11,0,SPW)
               CALL FILL (SP2,NCHAN,0.0)
               DO 50 K=ICH1,ICH2
                  SP2(K)=SP1(K)-SP6(K-ICH1+1)
50             CONTINUE
               IF (.NOT.EQUAL) THEN
                  RAN=SP4(NCHAN)-SP4(1)
                  RAN=RAN/(NPNTS-1)
                  DO 60 K=2,NPNTS
                     SP4(K)=(K-1)*RAN+SP4(1)
60                CONTINUE
                  L=-1
                  DO 70 K=1,NPNTS
                     SP2(K)=TG01B (L,IKNOT,SP7,SP8,SP9,SP4(K))
                     L=L+1
70                CONTINUE
                  NCHAN=NPNTS
               ENDIF
               IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP2,NCHAN)
               IF (KREC.GE.IFRAME) ICLO=1
               IF (KREC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 100
               ENDIF
               CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1                     SP2,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 100
80          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
90    CONTINUE
100   CLOSE (UNIT=JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Do you want equally spaced points for output',
     1        ' [Y/N] [N]: ',$)
1010  FORMAT (' How many points [512]: ',$)
      END

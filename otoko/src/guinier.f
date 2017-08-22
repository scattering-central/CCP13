C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE GUINIER
      IMPLICIT NONE
C
C Purpose: Calculate Guinier functions
C
      INCLUDE 'COMMON.FOR'
C
C Calls   4: GETHDR , OPNFIL , APLOT  , DAWRT
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(1),SLOPE,RADIUS,SMIN,SMAX,ZERO
      INTEGER ICALL,IAXIS,IAUTO,IWINDO,ISYMB,ICOL(8)
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,NCHAN,NFRAME
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
      INTEGER NCHANX,ICH1,ICH2,NVAL,NPOINT,MODE,NPTS,I,J,K,MDEG
      CHARACTER*80 HEAD1,HEAD2,TITLE,XANOT,YANOT
      CHARACTER*13 HFNAM,OFNAM,RFNAM
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
C RFNAM  : Raddi output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C NFRAME : Nos. of time frames
C TITLE  : PLOT TITLE
C XANOT  : ABSCISSA ANNOTATION
C YANOT  : ORDINATE ANNOTATION
C ICALL  : NOS. OF TIMES ROUTINE CALLED
C IAXIS  : PLOT TYPE
C IAUTO  : DATA SCALED BY PROGRAM
C IPLOT  : SYMBOL TYPE
C ISYMB  : GHOST symbol
C
      DATA IAXIS/2/ , IAUTO/0/ , IWINDO/0/ , ICOL/0,0,0,0,0,0,0,0/
      DATA XANOT/'X-AXIS'/ , YANOT/'Y-AXIS'/
      DATA IMEM/1/
C
C-----------------------------------------------------------------------
      WRITE (IPRINT,*) 'X-axis'
      CALL GETXAX (NCHANX,IRC)
      IF (IRC.NE.0) GOTO 999
10    ICLO=0
      JOP=0
      NPOINT=0
      ICALL=0
      KREC=0
      MDEG=1
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      CALL GETCHN (ITERM,IPRINT,NCHAN,ICH1,ICH2,IRC)
      IF (IRC.NE.0) GOTO 10
30    WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 30
      IF (NVAL.EQ.0) THEN
         MODE=1
      ELSE
         MODE=INT(VALUE(1))
         IF (MODE.LT.1.OR.MODE.GT.3) GOTO 30
      ENDIF
      DO 35 I=1,NCHAN
         SP3(I)=XAX(I)*XAX(I)
35    CONTINUE
      NPTS=ICH2-ICH1+1
      IFRAME=IHFMAX+IFRMAX-1
      DO 40 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 31 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
C
               DO 20 K=1,NCHAN
                  SP4(K)=SP1(K)
20             CONTINUE
               IF (MODE.EQ.2) THEN
                  DO 26 K=ICH1,ICH2
                     SP4(K)=SP4(K)*XAX(K)
26                CONTINUE
               ELSEIF (MODE.EQ.3) THEN
                  DO 27 K=ICH1,ICH2
                     SP4(K)=SP4(K)*SP3(K)
27                CONTINUE
               ENDIF
C
C========ASK ABOUT ANNOTATION
C
               IF (ICALL.EQ.0) THEN
                  TITLE=' '
                  WRITE (IPRINT,1020)
                  CALL IGETS (ITERM,TITLE)
               ENDIF
               CALL FRPLOT (ITERM,IPRINT,SP3(ICH1),SP4(ICH1),NPTS,ICALL,
     &                     IAXIS,IAUTO,1,IWINDO,ISYMB,ICOL,
     &                     XANOT,YANOT,TITLE)
               DO 25 K=ICH1,ICH2
                  SP4(K)=ALOG(SP4(K))
25             CONTINUE
               CALL FILL (SP7,NCHAN,1.0)
               CALL VC01A (SP3(ICH1),SP4(ICH1),SP7,SP1,NPTS,SP8,SP9,
     1                     SP10,SP11,SP12,SP5,MDEG,SPW)
               CALL POLCAL (SP3(ICH1),SP4(ICH1),SP8,SP9,SP10,MDEG,
     1                      1,NPTS)
               SLOPE=(SP4(ICH2)-SP4(ICH1))/(SP3(ICH2)-SP3(ICH1))
               RADIUS=SQRT(REAL(MODE-4)*SLOPE/39.478416)
               SMIN=SP3(ICH1)
               SMAX=SP3(ICH2)
               ZERO=EXP(SP4(ICH2)-SP3(ICH2)*SLOPE)
               NPOINT=NPOINT+1
               SP6(NPOINT)=RADIUS
               SP2(NPOINT)=ZERO
               CALL FILL (SP1,NCHAN,0.0)
               DO 55 K=1,ICH1-1
                  IF (XAX(K).GE.0.0) SP1(K)=EXP(SP3(K)*SLOPE+ALOG(ZERO))
55             CONTINUE
               DO 56 K=ICH1,ICH2
                  SP1(K)=EXP(SP4(K))
56             CONTINUE
               CALL FRPLOT (ITERM,IPRINT,SP3(ICH1),SP1(ICH1),NPTS,ICALL,
     &                      IAXIS,IAUTO,2,IWINDO,ISYMB,ICOL,
     &                      XANOT,YANOT,TITLE)
cx               CALL GREND
               CALL TRMODE
               IF (IFRAME.EQ.1) WRITE (IPRINT,1010) SMIN,SMAX,
     &                                              RADIUS,ZERO
               IF (KREC.GE.IFRAME) THEN
                  ICLO=1
                  CALL SAVPLO (ITERM,IPRINT)
               ENDIF
               IF (KREC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 50
               ENDIF
               CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     &                     SP1,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 50
31          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
40    CONTINUE
      IF (NPOINT.GT.1) THEN
         JOP=0
         ICLO=0
         IFRAME=2
         WRITE (IPRINT,*) 'Radii & I(0) data'
         CALL OUTFIL (ITERM,IPRINT,RFNAM,HEAD1,HEAD2,IRC)
         IF (IRC.NE.0) GOTO 50
         CALL DAWRT (LUNIT,RFNAM,IMEM,NPOINT,IFRAME,HEAD1,HEAD2,
     1               SP6,1,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 50
         ICLO=1
         CALL DAWRT (LUNIT,RFNAM,IMEM,NPOINT,IFRAME,HEAD1,HEAD2,
     1               SP2,2,JOP,ICLO,IRC)
      ENDIF
50    CLOSE(UNIT=JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter option',/,' [1] Radius of gyration',/,
     1        ' [2] Radius of gyration of cross section',/,
     2        ' [3] Radius of gyration of thickness  [1]: ',$)
1010  FORMAT ('     SMIN         SMAX        R(A)        I(0)',/,
     1        ' ',4G12.5)
1020  FORMAT (' Enter plot title: ',$)
      END

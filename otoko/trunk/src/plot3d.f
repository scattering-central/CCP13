C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE PLOT3D
      IMPLICIT NONE
C
C Purpose: Multiple plotting of frames in 3D
C
C AUTHOR: Z.KAM and M.H.J.KOCH, EMBL - HAMBURG
C
      INCLUDE 'COMMON.FOR'
C
C Updates:
C 14/03/84 GRM Modified for ghost graphics
C 19/03/84 GRM Added hard copy facility
C
C Calls  11: FILL   , GETCHN , GETHDR , GETVAL , GRMODE , MINMAX
C            OPNFIL , OT3PLO , SAVPLO , TRMODE , PLOTON
C Ghost   7: ERASE  , FILON  , MAP    , MAPYL  , PLOTON , PICNOW
C            PSPACE
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10),XMIN,XMAX,FMIN,FMAX,RANGE,DELY,XTOT,YTOT
      INTEGER IRC,IFRAME,IHFMAX,IFRMAX,NCHAN,NFRAME,LENGTH,I,J,K
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NPTS,NM
      INTEGER ISAVE1,ISAVE2,ICH1,ICH2,IAUTO,IOPT,ILIN,IMAX,IMIN,NVAL
      CHARACTER*80 TITLE
      CHARACTER*13 HFNAM
      CHARACTER EOFCHAR
      LOGICAL IGETS
C
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
C NCHAN  : Nos. of data points in spectrum
C NFRAME : Nos. of time frames
C ISAVE1 : Temporary storage
C ISAVE2 : Temporary storage
C ICH1   : First channel of interest
C ICH2   : Last channel of interest
C IAUTO  : Automatic scaling required
C IOPT   : Origin position on the screen
C ILIN   : Linear or logrithmic display
C IMIN   : Position of minimum
C IMAX   : Position of maximum
C XMIN   : Minimum value
C XMAX   : Maximum value
C FMIN   : Overall mimimum value of frames
C FMAX   : Overall maximum value of frames
C VALUE  : Numeric values entered at terminal
C NVAL   : Nos. of values entered at terminal
C RANGE  : Range of abscissa values
C DELY   : Ordinate increment
C NM     : ?
C XTOT   : Abscissa span
C YTOT   : Ordinate span
C NPTS   : Nos. of points in frame to plot
C TITLE  : Title of plot
C
C-----------------------------------------------------------------------
10    KREC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      ISAVE1=ISPEC
      ISAVE2=IFFR
      IFRAME=IHFMAX+IFRMAX-1
C
      CALL GETCHN (ITERM,IPRINT,NCHAN,ICH1,ICH2,IRC)
      IF (IRC.NE.0) GOTO 10
      CALL FILL (SP3,NCHAN,0.0)
      IAUTO=0
20    IOPT=0
      WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.GE.1) IOPT=INT(VALUE(1))
      IF (IOPT.NE.0.AND.IOPT.NE.1) GOTO 20
30    ILIN=0
      WRITE (IPRINT,1010)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 30
      IF (NVAL.GE.1) ILIN=INT(VALUE(1))
      IF (ILIN.LT.0.OR.ILIN.GT.2) GOTO 30
      TITLE=' '
      WRITE (IPRINT,1015)
      IF (.NOT.IGETS (ITERM,TITLE)) GOTO 999
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
               IF (ILIN.EQ.2) THEN
                  DO 42 K=1,NCHAN
                     SP1(K)=SP1(K)*REAL(K)*REAL(K)
 42               CONTINUE
               ENDIF
               CALL MINMAX (SP1,NCHAN,ICH1,ICH2,IMIN,IMAX,XMIN,XMAX)
               IF (KREC.EQ.1) THEN
                  FMIN=XMIN
                  FMAX=XMAX
               ENDIF
               IF (XMIN.LT.FMIN) FMIN=XMIN
               IF (XMAX.GT.FMAX) FMAX=XMAX
40          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
50    CONTINUE
C
      WRITE (IPRINT,1020) FMIN,FMAX
60    WRITE (IPRINT,1030) EOFCHAR ()
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 70
      IF (IRC.EQ.2) GOTO 60
      IF (NVAL.GE.1) FMIN=VALUE(1)
      IF (NVAL.GE.2) FMAX=VALUE(2)
      IAUTO=1
70    NPTS=ICH2-ICH1+1
      IF (ILIN.EQ.1) THEN
         IF (FMIN.LT.0.001) FMIN=0.001
         FMIN=ALOG10(FMIN)*1000.0
         FMAX=ALOG10(FMAX)*1000.0
      ENDIF
      RANGE=FMAX-FMIN
      IF (IFRAME.EQ.1) THEN
         DELY=0.
         NM=2
      ELSE
         NM=(NPTS-1)/(IFRAME-1)
         IF (NM.LT.2) NM=2
         DELY=RANGE/(2.*(IFRAME-1))
      ENDIF
      XTOT=NPTS-1+(IFRAME-1)*(NM-1)
      YTOT=DELY*(IFRAME-1)+RANGE
C
      CALL GRMODE
      CALL PLOTON
      CALL PSPACE (0.25,1.1,0.175,0.9)
      CALL ERASE
C
C========PUT AXIS ANNOTATION & TITLE TO PLOT  
C 
      CALL CTRMAG (20)
      CALL MAP (0.0,1.0,0.0,1.0)
      CALL PCSCEN (0.5,-0.1,TITLE(1:LENGTH(TITLE)))
      CALL MAP   (0.0,XTOT,0.0,YTOT)
C
      KREC=0
      ISPEC=ISAVE1
      IFFR=ISAVE2
      CALL FILL (SPW,NCHAN,0.0)
      DO 110 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 100 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
C  
               IF (ILIN.EQ.1) THEN
                  DO 80 K=ICH1,ICH2
                     IF (SP1(K).LT.0.001) SP1(K)=0.001
                     SP1(K)=ALOG10(SP1(K))*1000.0
80                CONTINUE
               ELSEIF (ILIN.EQ.2) THEN
                  DO 81 K=ICH1,ICH2
                     SP1(K)=SP1(K)*REAL(K)*REAL(K)
 81               CONTINUE
               ENDIF
               IF (IAUTO.NE.0) THEN
                  DO 90 K=ICH1,ICH2
                     IF (SP1(K).GT.FMAX) SP1(K)=FMAX
                     IF (SP1(K).LT.FMIN) SP1(K)=FMIN
90                CONTINUE
               ENDIF
               CALL OT3PLO (SP1(ICH1),SPW,NPTS,KREC,IOPT,ILIN,NM,
     1                      IFRAME,DELY,FMIN)
C
100         CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
110   CONTINUE
C
      CALL PICNOW
      CALL TRMODE
      CALL SAVPLO (ITERM,IPRINT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Origin on [0] RHS or [1] LHS of screen [0]: ',$)
1010  FORMAT (' [0] X,Y [1] X,Log(Y) [2] X,X^2*Y  [0]: ',$)
1015  FORMAT (' Enter plot title: ',$)
1020  FORMAT (' Minimum value is ',G13.5,' Maximum value is ',G13.5)
1030  FORMAT (' Enter new values or <ctrl-',a1,'>: ',$)
      END

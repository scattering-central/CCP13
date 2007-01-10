C     LAST UPDATE 07/12/93
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE RADSCN
      IMPLICIT   NONE
C
C PURPOSE: Perform radial scan on an image.
C
      INCLUDE 'COMMON.FOR'
C
C Calls  11: IMDISP , ASKYES , WFRAME , RFRAME , IMSIZE , OUTFIL
C            GETVAL , GETHDR , OPNFIL , OPNNEW , ASKNO
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         VALUE(10),PI,XCENTR,YCENTR,AVRAD,RAD1,COSRAD,SINRAD
      REAL         THETA,ANGLE,X,Y,DX,DY,WIDTH,XO,YO
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL
      INTEGER      I,J,K,L,M,JFRAME,IX,IY,NAPTS,NOUT
      INTEGER      IXC1,IYC1,IRAD1,IRAD2
      LOGICAL      ASKNO,PUTIMAGE,FIRST,FIXED
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM
C
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
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
C NPIX   : Nos. of pixels in image
C NRAST  : Nos. of rasters in image
C NFRAME : Nos. of frames in dataset
C KPIC   : Current image nos.
C
      DATA IMEM/1/, NOUT/1/
C
C-----------------------------------------------------------------------
 10   FIRST=.TRUE.
      KPIC=0
      PI=ACOS(-1.0)
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
      WRITE (IPRINT,1000)
      FIXED=ASKNO (ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
      IXC1=INT(REAL(NPIX+1)/2.0)
      IYC1=INT(REAL(NRAST+1)/2.0)
      IRAD1=INT(REAL(NPIX+1)/8.0)
      RAD1 = FLOAT(RAD1)
      WIDTH=1.0
      IF (.NOT.FIXED) THEN
 20      WRITE (IPRINT,1020)IXC1,IYC1,IRAD1,INT(WIDTH)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 10
         IF (IRC.EQ.2) GOTO 20
         IF (NVAL.GT.0) XCENTR=VALUE(1)
         IF (NVAL.GT.1) YCENTR=VALUE(2)
         IF (NVAL.GT.2) RAD1=VALUE(3)
         IF (NVAL.GT.3) WIDTH=VALUE(4)
      ENDIF
      AVRAD = RAD1 + 0.5*WIDTH
C
      DO 90 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 80 J=1,IFRMAX
C
               IF ((FIRST).AND.(FIXED)) THEN
                  FIRST=.FALSE.
                  JFRAME=IFFR
                  IF (ILFR.GT.IFFR) THEN
18                   WRITE (IPRINT,1050) JFRAME
                     CALL GETVAL(ITERM,VALUE,NVAL,IRC)
                     IF (IRC.EQ.1) GOTO 90
                     IF (IRC.EQ.2) GOTO 18
                     IF (NVAL.GT.0) JFRAME=INT(VALUE(1))
                     IF (JFRAME.LT.IFFR.OR.JFRAME.GT.ILFR) GOTO 18
                  ENDIF
                  CALL RFRAME (JUNIT,JFRAME,NPIX,NRAST,SP1,IRC)
                  IF (IRC.NE.0) GOTO 90
                  IF (.NOT.PUTIMAGE (SP1,NPIX,NRAST)) GOTO 90
               ENDIF
C
               IF (KPIC.EQ.0.AND.(FIXED)) THEN
                  CALL CIRSET (IXC1,IYC1,IRAD1,NPIX,NRAST)
                  IRAD2 = IRAD1 + NPIX/20
                  CALL CIRSET (IXC1,IYC1,IRAD2,NPIX,NRAST)
                  AVRAD = REAL (IRAD1+IRAD2)/2.0
                  IF(ABS(IRAD2-IRAD1).GT.0)THEN
                     WIDTH = REAL (ABS(IRAD2-IRAD1))
                  ELSE
                     WIDTH = 1.0
                  ENDIF
                  RAD1 = FLOAT(MIN(IRAD1,IRAD2))
                  XCENTR = REAL (IXC1)
                  YCENTR = REAL (IYC1)
                  WRITE(IPRINT,1030)IXC1,IYC1,INT(RAD1),INT(WIDTH)
               ENDIF
C
C========TRANSLATE CENTRE TO ORIGIN, ROTATE & REPOSITION IMAGE
C
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) GOTO 80
               IFFR=IFFR+IFINC
               KPIC=KPIC+1
C
               NAPTS=INT(WIDTH)
               CALL FILL (SP2,NAPTS*NOUT,0.0)
               ANGLE=1.0/AVRAD
               YO = 0.0
cx               call timer ()
               DO 70 L=1,NAPTS
                  XO = RAD1 + FLOAT(L) - 0.5
                  SP3(L) = XO
                  DO 60 K=1,INT(2.0*PI*AVRAD)
                     THETA = (FLOAT(K)-0.5)*ANGLE
                     COSRAD = COS(THETA)
                     SINRAD = SIN(THETA)
                     X = COSRAD*XO - SINRAD*YO + XCENTR
                     Y = SINRAD*XO + COSRAD*YO + YCENTR
                     IX = INT(X)
                     IY = INT(Y)
                     IF (IX.GT.0.AND.IX.LT.NPIX.AND.
     &                   IY.GT.0.AND.IY.LT.NRAST)THEN
                         M=(IY-1)*NPIX + IX
                         DX = X - REAL(INT(IX))
                         DY = Y - REAL(INT(IY))
                         SP2(L) = SP2(L) + (1.-DX)*(1.-DY)*SP1(M)
     &                            +             DX*(1.-DY)*SP1(M+1)
     &                            +             (1.-DX)*DY*SP1(M+NPIX)
     &                            +                  DX*DY*SP1(M+NPIX+1)
                     ELSE
                        SP2(L) = 0.0
                        GOTO 70
                     ENDIF   
 60               CONTINUE
70             CONTINUE
C
C========DISPLAY PLOT OF SCAN
C
               CALL APLOT (ITERM,IPRINT,SP2,SP3,NAPTS)
cx               call timer ()
C
               IF (KPIC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 100
                  CALL OPNNEW (KUNIT,NAPTS,IFRAME,NOUT,OFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 100
               ENDIF
               CALL WFRAME (KUNIT,KPIC,NAPTS,NOUT,SP2,IRC)
               IF (IRC.NE.0) GOTO 100
80          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
90    CONTINUE
100   CALL FCLOSE (KUNIT)
      CALL FCLOSE (JUNIT)
      GOTO 10
cx 999  stop
999   RETURN
C
 1000 FORMAT (' Do you want fixed centre, radius and width',
     &        ' [Y/N] [N]: ',$)
 1020 FORMAT (' Enter (x,y) coordinates of centre, radius and width [',
     &        3(I3,','),I3,']: ',$)
 1030 FORMAT (' Selected values are:   centre   [',I3,',',I3,']'/
     &        '                        radius   [',I3,']'/
     &        '                        width    [',I3,']')
 1050 FORMAT (' Enter frame nos. for image display [',I3,']: ',$) 
      END

C     LAST UPDATE 18/07/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE ROTATE
      IMPLICIT   NONE
C
C PURPOSE: Rotate an image.
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
      REAL         VALUE(10),PI,XCENTR,YCENTR,XCOORD(2),YCOORD(2)
      REAL         THETA,ANGLE,SINRAD,COSRAD,X,Y
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL
      INTEGER      I,J,K,L,M,N,II,IFPIX,ILPIX,IFRAST,ILRAST,JFRAME
      INTEGER      IX,IY,IXOFF,IYOFF,IXLEN,IYLEN,KCHAR
      LOGICAL      KEYB,ASKNO,PUTIMAGE,FIRST,FIXED
      CHARACTER*80 HEAD1,HEAD2,TITLE
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
      DATA IMEM/1/
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
      IF (.NOT.FIXED) THEN
20       ANGLE=90.0
         WRITE (IPRINT,1010)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 10
         IF (IRC.EQ.2) GOTO 20
         IF (NVAL.GT.0) ANGLE=VALUE(1)
         THETA=ANGLE*PI/180.
         XCENTR=REAL(NPIX+1)/2.0
         YCENTR=REAL(NRAST+1)/2.0
         IXOFF=0
         IYOFF=0
      ELSE
         WRITE (IPRINT,1015)
         KEYB=ASKNO (ITERM,IRC)
         IF (IRC.NE.0) GOTO 10
      ENDIF
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
                  IF (.NOT.KEYB) THEN
                     IF (.NOT.PUTIMAGE (SP1,NPIX,NRAST)) GOTO 90
                  ENDIF
               ENDIF
C
               IF (KPIC.EQ.0.AND.(FIXED)) THEN
                  DO 50 K=1,2
                     IF (.NOT.KEYB) THEN
                        CALL VARREC (NPIX,NRAST,IFPIX,ILPIX,
     &                       IFRAST,ILRAST)
                        WRITE (IPRINT,1020) IFPIX,IFRAST,ILPIX,ILRAST
                     ELSE
                        CALL IMSIZE (ITERM,IPRINT,NPIX,NRAST,IFPIX,
     &                       ILPIX,IFRAST,ILRAST,IRC)
                        IF (IRC.NE.0) GOTO 10
                     ENDIF
                     IXLEN=ILPIX-IFPIX+1
                     IYLEN=ILRAST-IFRAST+1
                     II=1
                     DO 40 L=IFRAST,ILRAST
                        N=(L-1)*NPIX
                        DO 30 M=IFPIX,ILPIX
                           SP2(II)=SP1(N+M)
                           II=II+1
30                      CONTINUE
40                   CONTINUE
                     call ploton
                     CALL CONTOUR (ITERM,IPRINT,SP2,IXLEN,IYLEN,IFPIX,
     &                             IFRAST,TITLE)
C
C========SELECT CENTRE POINT
C
                     CALL GRMODE
                     CALL MAP (REAL(IFPIX),REAL(ILPIX),REAL(IFRAST),
     &                         REAL(ILRAST))
                     CALL CURSOR (XCOORD(K),YCOORD(K),KCHAR)
                     CALL PLOTNC (XCOORD(K),YCOORD(K),231)
                     CALL PICNOW
                     call trmode
50                CONTINUE
C
C========CALCULATE CENTRE POSITION, ANGLE OF ROTATION & OFFSETS
C
                  XCENTR=ABS((XCOORD(1)+XCOORD(2))/2.0)
                  YCENTR=ABS((YCOORD(1)+YCOORD(2))/2.0)
                  WRITE (IPRINT,1030) NINT(XCENTR),NINT(YCENTR)
                  THETA=ATAN2((YCOORD(1)-YCENTR),(XCOORD(1)-XCENTR))
                  THETA=PI/2.0-THETA
                  IXOFF=NINT(REAL(NPIX/2+1)-XCENTR)
                  IYOFF=NINT(REAL(NRAST/2+1)-YCENTR)
                  WRITE (IPRINT,1040) THETA,IXOFF,IYOFF
               ENDIF
C
C========TRANSLATE CENTRE TO ORIGIN, ROTATE & REPOSITION IMAGE
C
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) GOTO 80
               IFFR=IFFR+IFINC
               KPIC=KPIC+1
C
               CALL FILL (SP2,NPIX*NRAST,0.0)
               call timer ()
               DO 70 K=1,NRAST
                  N=(K-1)*NPIX
                  DO 60 L=1,NPIX
                     COSRAD=COS(THETA)
                     SINRAD=SIN(THETA)
                     X=(REAL(L)-XCENTR)*COSRAD-(REAL(K)-YCENTR)*SINRAD
                     Y=(REAL(L)-XCENTR)*SINRAD+(REAL(K)-YCENTR)*COSRAD
                     IX=NINT(X+XCENTR)+IXOFF
                     IY=NINT(Y+YCENTR)+IYOFF
                     M=(IY-1)*NRAST
                     IF (IX.GT.0.AND.IX.LE.NRAST.AND.
     &                   IY.GT.0.AND.IY.LE.NPIX) SP2(M+IX)=SP1(N+L)
60                CONTINUE
70             CONTINUE
               call timer ()
C
               IF (IFRAME.EQ.1) CALL IMDISP(ITERM,IPRINT,SP2,NPIX,NRAST)
               IF (KPIC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 100
                  CALL OPNNEW (KUNIT,NPIX,NRAST,IFRAME,OFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 100
               ENDIF
               CALL WFRAME (KUNIT,KPIC,NPIX,NRAST,SP2,IRC)
               IF (IRC.NE.0) GOTO 100
80          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
90    CONTINUE
100   CALL FCLOSE (KUNIT)
      CALL FCLOSE (JUNIT)
      GOTO 10
999   RETURN
C
 1000 FORMAT (' Do you want fixed angle rotation [Y/N] [N]: ',$)
 1010 FORMAT (' Enter rotation angle [90]: ',$)
 1015 FORMAT (' Do you want to use cursor selection [Y/N] [N]: ',$) 
 1020 FORMAT (' Selected values are: [',I4,',',I4,'] & [',I4,',',I4,']')
 1030 FORMAT (' Calculated centre position is: [',I3,',',I3,']')
 1040 FORMAT (' Calculated angle (rad) & offsets: ',G13.5,' [',I6,
     &     ',',I6,']')
 1050 FORMAT (' Enter frame nos. for image display [',I3,']: ',$) 
      END

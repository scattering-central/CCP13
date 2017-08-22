C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE POLAR
      IMPLICIT   NONE
C
C PURPOSE: TRANSFORM IMAGE EXPRESSED IN CARTESIAN COORDINATES TO AN
C          IMAGE IN POLAR COORDINATES. 
C
      INCLUDE 'COMMON.FOR'
C
C Calls  11: IMDISP , WFRAME , RFRAME , IMSIZE , OUTFIL
C            GETVAL , GETHDR , OPNFIL , OPNNEW
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         DTHETA,RADIUS,THETA,RMIN,VALUE(10),X,Y,PI
      INTEGER      ICENTX,ICENTY,IX,IY,INDX1,INDX2,MRAST,MPIX,MRAST4
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL,I,J,K
      INTEGER      ITEMP,L,M
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
C NVAL   : Nos. of values entered at terminal
C DTHETA : Increment of theta
C RADIUS : Polar radius
C THETA  : Polar angle
C RMIN   : Minimum value of theta
C ICENTX : Centre x coordinate
C ICENTY : Centre y coordinate
C IX     : Integerised x coordinate for given r,theta
C IY     : Integerised y coordinate for given r,theta
C INDX1  : Offset to buffer
C INDX2  : Offset to buffer

      DATA RMIN/0.00001/ , IMEM/1/
C
C-----------------------------------------------------------------------
10    KPIC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=4
C
C========FIND X,Y COORDINATES FOR CENTRE OF POLAR COORDINATES
C
      ICENTX=NPIX/2
      ICENTY=NRAST/2
20    WRITE (IPRINT,1000) ICENTX,ICENTY
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.GT.0) ICENTX=VALUE(1)
      IF (NVAL.GT.1) ICENTY=VALUE(2)
C
C========FIND MAXIMUM RADIUS OBTAINABLE FROM GIVEN CENTRE
C
      PI=ACOS(-1.0)
      MPIX=MIN (NPIX-ICENTX,ICENTX,NRAST-ICENTY,ICENTY)
      MRAST=INT(2.0*PI*REAL(MPIX))
      DTHETA=2.0*PI/REAL(MRAST)
      MRAST4=MRAST/4
C
      DO 70 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 60 J=1,IFRMAX
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) GOTO 80
               IFFR=IFFR+IFINC
               KPIC=KPIC+1
C
C========CALCULATE POLAR IMAGE
C
               DO 50 K=1,4
                  INDX2=1
                  DO 40 L=1,MRAST4
                     THETA=DTHETA*REAL(L)
                     DO 30 M=1,MPIX
                        RADIUS=REAL(M)
                        X=RADIUS*COS(THETA)
                        Y=RADIUS*SIN(THETA)
                        IX=INT(X-RMIN)+1
                        IY=INT(Y-RMIN)+1
C
C========CORRECT EACH QUADRANT FOR CENTRE OFFSET
C
                        IF (K.EQ.1) THEN
                           IX=IX+ICENTX
                           IY=IY+ICENTY
                        ELSEIF (K.EQ.2) THEN
                           ITEMP=IX
                           IX=-IY+ICENTX+1
                           IY=ITEMP+ICENTY
                        ELSEIF (K.LE.3) THEN
                           IX=-IX+ICENTX+1
                           IY=-IY+ICENTY+1
                        ELSE
                           ITEMP=-IX
                           IX=IY+ICENTX
                           IY=ITEMP+ICENTY+1 
                        ENDIF
                        INDX1=NPIX*(IY-1)+IX
                        SP2(INDX2)=SP1(INDX1)*2.0*PI*(M+0.5)/NPIX
                        INDX2=INDX2+1
30                   CONTINUE
40                CONTINUE
C
                  IF (K.EQ.1) THEN
                     IF (KPIC.EQ.1) CALL IMDISP(ITERM,IPRINT,SP2,MPIX,
     &                                          MRAST4)
                     CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                     IF (IRC.NE.0) GOTO 80
                     CALL OPNNEW (KUNIT,MPIX,MRAST4,IFRAME,OFNAM,IMEM,
     &                            HEAD1,HEAD2,IRC)
                     IF (IRC.NE.0) GOTO 80
                  ENDIF
                  CALL WFRAME (KUNIT,K,MPIX,MRAST4,SP2,IRC)
                  IF (IRC.NE.0) GOTO 80
50             CONTINUE
               CALL FCLOSE (KUNIT)
60          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
70    CONTINUE
80    CALL FCLOSE (KUNIT)
      CALL FCLOSE (JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter x,y coordinate for polar image centre',
     &        ' [',I4,',',I4,'] : ',$)
      END

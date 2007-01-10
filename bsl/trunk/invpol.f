C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE INVPOL
      IMPLICIT   NONE
C
C PURPOSE: TRANSFORM IMAGE EXPRESSED IN CARTESIAN COORDINATES TO AN
C          IMAGE IN POLAR COORDINATES.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   8: IMDISP , WFRAME , RFRAME , OUTFIL
C            GETHDR , OPNFIL , OPNNEW , FILL
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         DTHETA,RADIUS,THETA,RMIN,X,Y,PI
      INTEGER      ICENTX,ICENTY,IX,IY,INDX1,INDX2,MRAST,MPIX
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,I,J,K
      INTEGER      ITEMP,L
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
      IFRAME=IHFMAX
C
      PI=ACOS(-1.0)
      DO 70 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            KPIC=KPIC+1
            DO 50 J=1,4
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) GOTO 80
               IFFR=IFFR+IFINC
               IF (J.EQ.1) THEN
                  ICENTX=NPIX
                  ICENTY=NPIX
                  MPIX=NPIX*2
                  MRAST=NPIX*2
                  CALL FILL (SP2,MPIX*MRAST,0.0)
                  DTHETA=2.0*PI/REAL(4*NRAST)
               ENDIF
C
C========CALCULATE CARTESIAN IMAGE
C
               INDX2=1
               DO 30 K=1,NRAST
                  THETA=DTHETA*REAL(K)
                  DO 20 L=1,NPIX
                     RADIUS=REAL(L)
                     X=RADIUS*COS(THETA)
                     Y=RADIUS*SIN(THETA)
                     IX=INT(X-RMIN)+1
                     IY=INT(Y-RMIN)+1
C
C========CORRECT FOR QUADRANT
C
                     IF (J.EQ.1) THEN
                        IX=IX+ICENTX
                        IY=IY+ICENTY
                     ELSEIF (J.EQ.2) THEN
                        ITEMP=IX
                        IX=-IY+ICENTX+1
                        IY=ITEMP+ICENTY
                     ELSEIF (J.EQ.3) THEN
                        IX=-IX+ICENTX+1
                        IY=-IY+ICENTY+1
                     ELSE
                        ITEMP=-IX
                        IX=IY+ICENTX
                        IY=ITEMP+ICENTY+1 
                     ENDIF
                     INDX1=MPIX*(IY-1)+IX
                     SP2(INDX1)=SP2(INDX1)+SP1(INDX2)/(2.0*PI)
                     INDX2=INDX2+1
20                CONTINUE
30             CONTINUE
C
               IF (KPIC.EQ.1) THEN
                  CALL IMDISP(ITERM,IPRINT,SP2,MPIX,MRAST)
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
                  CALL OPNNEW (KUNIT,MPIX,MRAST,IFRAME,OFNAM,IMEM,
     &                         HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
               ENDIF
               CALL WFRAME (KUNIT,KPIC,MPIX,MRAST,SP2,IRC)
               IF (IRC.NE.0) GOTO 80
50          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
70    CONTINUE
80    CALL FCLOSE (KUNIT)
      CALL FCLOSE (JUNIT)
      GOTO 10
999   RETURN
C
      END

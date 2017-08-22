C     LAST UPDATE 17/02/97
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE sector
      IMPLICIT   NONE
C
C PURPOSE: Perform partial/whole radial scan on an image.
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
      REAL         VALUE(10),PI,XCENTR,YCENTR,AVRAD,COSRAD,SINRAD
      REAL         THETA,X,Y,DX,DY,WIDTH,XO,YO,DX1,DX2,DY1,DY2
      real         phi1,phi2
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL
      INTEGER      I,J,K,L,M,JFRAME,IX,IY,NAPTS,NOUT,itemp,ncount
      INTEGER      IXC,IYC,IRAD1,IRAD2,iang1,iang2,ix1,ix2,iy1,iy2
      LOGICAL      ASKNO,PUTIMAGE,FIRST,FIXED,askyes,ave,mirror,mirsec
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
      ixc=INT(REAL(NPIX+1)/2.0)
      iyc=INT(REAL(NRAST+1)/2.0)
      iang1=0
      iang2=360
      Irad1=npix/4
      width = npix/8
      IX1=IRAD1+IXC
      IY1=IYC
      IX2=IX1+WIDTH
      IY2=IYC+1
      IF (.NOT.FIXED) THEN
 20      WRITE (IPRINT,1020)ixc,iyc,iang1, iang2, IRAD1,INT(WIDTH)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 10
         IF (IRC.EQ.2) GOTO 20
         IF (NVAL.GT.0) XCENTR=VALUE(1)
         IF (NVAL.GT.1) YCENTR=VALUE(2)
         IF (NVAL.GT.2) iang1=int(VALUE(3))
         IF (NVAL.GT.3) iang2=int(VALUE(4))
         IF (NVAL.GT.4) iRAD1=int(VALUE(5))
         IF (NVAL.GT.5) WIDTH=VALUE(6)
      ENDIF
      AVRAD = real(iRAD1) + 0.5*WIDTH
      PHI1=REAL(IANG1)*PI/180.0
      PHI2=REAL(IANG2)*PI/180.0
      
      WRITE (IPRINT,1060)
      ave=ASKyes (ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
      
      WRITE (IPRINT,1070) 
      mirror=ASKyes (ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
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
                  CALL sectorset (IXC,IYC,ix1,iy1,ix2,iy2)
                  DX1=ix1-ixc
                  DY1=iyc-iy1
                  DX2=ix2-ixc
                  DY2=iyc-iy2
                  irad1 = int(sqrt(dx1*dx1+dy1*dy1))
                  irad2 = int(sqrt(dx2*dx2+dy2*dy2))
                  phi1=atan2(dy1,dx1)
                  phi2=atan2(dy2,dx2)
                  if (phi2.lt.phi1) phi2 = phi2 + 2*pi
                  iang1=int(phi1*180.0/pi)
                  iang2=int(phi2*180.0/pi)
                  AVRAD = real(iRAD1+iRAD2)/2.0
                  IF(IRAD1.gt.IRAD2)THEN
                     itemp = irad1
                     irad1 = irad2
                     irad2=itemp
                  ENDIF
                  WIDTH = real(irad2 - irad1)
                  if (irad1.eq.irad2) width=1.0
                  XCENTR = REAL (ixc)
                  YCENTR = REAL (iyc)
                  WRITE(IPRINT,1030) ixc,iyc,iang1,iang2,IRAD1,
     *                  INT(WIDTH)
               ENDIF
C
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) GOTO 80
               IFFR=IFFR+IFINC
               KPIC=KPIC+1
C
               NAPTS=INT(WIDTH)
               CALL FILL (SP2,NAPTS,0.0)
               YO = 0.0
               DO 70 L=1,napts
                  XO = FLOAT(L+irad1-1)
                  SP3(L) = XO
                  ncount=0
                  DO 60 K=INT(PHI1*XO),INT(PHI2*XO)
                     THETA = (FLOAT(K)-0.5)/XO
c
c========initialize mirroring shit here
c
                     mirsec = .false.
 55                  continue
                     COSRAD = COS(THETA)
                     SINRAD = SIN(THETA)
                     X = COSRAD*XO - SINRAD*YO + XCENTR
                     Y = -SINRAD*XO - COSRAD*YO + YCENTR
                     IX = INT(X)
                     IY = INT(Y)
                     IF (IX.GT.0.AND.IX.LT.NPIX.AND.
     &                   IY.GT.0.AND.IY.LT.NRAST)THEN
                         M=(IY-1)*NPIX + IX
                         DX = X - REAL(IX)
                         DY = Y - REAL(IY)
                         SP2(L) = SP2(L) + (1.-DX)*(1.-DY)*SP1(M)
     &                            +             DX*(1.-DY)*SP1(M+1)
     &                            +             (1.-DX)*DY*SP1(M+NPIX)
     &                            +                  DX*DY*SP1(M+NPIX+1)
                     ELSE
                        SP2(L) = 0.0
                        GOTO 70
                     ENDIF
                     ncount = ncount + 1
c
c========do more mirroring shit here
c
                     if(mirror)then
                        mirsec = .not.mirsec
                        if(mirsec)then
                           theta = theta + pi
                           goto 55
                        endif
                     endif
c
c========end of mirroring shit
c
 60               CONTINUE
                  if (ncount.gt.0) then
                     sp2(L)=sp2(L)/real(ncount)
                     if (.not.ave) then
                        sp2(l) = sp2(l)*(phi2-phi1)*XO
                     endif
                  endif
 70             CONTINUE
C
C========DISPLAY PLOT OF SCAN
C
                IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP2,SP3,NAPTS)
                IF (KPIC.EQ.1) THEN
                   CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                   IF (IRC.NE.0) GOTO 100
                   CALL OPNNEW (KUNIT,NAPTS,IFRAME,NOUT,OFNAM,IMEM,
     &                          HEAD1,HEAD2,IRC)
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
c999   stop
 999   RETURN
C
 1000 FORMAT (' Do you want fixed centre, starting & final angles,',
     &        ' radius & width [Y/N] [N]: ',$)
 1020 FORMAT (' Enter (x,y) coordinates of centre, start angle,',
     &        ' final angle, radius  and width [',5(I4,','),I4,']: ',$)
 1030 FORMAT (' Selected values are:   centre   [',I4,',',I4,']'/
     &        '                   start angle   [',I4,']'/
     &        '                   final angle   [',I4,']'/
     &        '                        radius   [',I4,']'/
     &        '                        width    [',I4,']')
 1050 FORMAT (' Enter frame nos. for image display [',I3,']: ',$) 
 1060 FORMAT (' Average the integrated data [y/n] [y]: ',$)
 1070 FORMAT (' Do you want to include mirrored section [Y/N] [Y]: ',$)
      END

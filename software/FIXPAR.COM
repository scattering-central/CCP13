C     LAST UPDATE 10/12/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C     FIXPAR.COM
C
C Purpose: Include file to set up parameters for FIX fortran routines 
C
C Calls   0:
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER MAXBUF
      PARAMETER(MAXBUF=4000000) 
      INTEGER MAXPTS,MAXVERT
      PARAMETER(MAXPTS=500,MAXVERT=10)
      INTEGER MAXVAL
      PARAMETER(MAXVAL=MAXPTS*MAXVERT)
      INTEGER MAXREF
      PARAMETER(MAXREF=2048)
C
C Declarations for unnamed common block:
C
      INTEGER NPIX,NRAST
      REAL FXY(2,MAXPTS),SXY(2,MAXPTS),RZ(2,MAXPTS),AVPIX(MAXPTS),
     &     BCK(MAXPTS),BKSUB(MAXPTS),XLINE(2,MAXPTS),YLINE(2,MAXPTS),
     &     XCSCAN(MAXPTS),YCSCAN(MAXPTS),XSCAN(2,MAXPTS),YSCAN(2,MAXPTS)
      INTEGER LWIDTH(MAXPTS),NVALS(MAXPTS)
      INTEGER NLIN,NPTS,NSCAN
C
C Unnamed common block:
C
      COMMON NPIX,NRAST,FXY,SXY,RZ,AVPIX,BCK,BKSUB,XLINE,YLINE,LWIDTH,
     &       NVALS,XCSCAN,YCSCAN,XSCAN,YSCAN,NLIN,NPTS,NSCAN
C
C Declarations for logical and real information for INFO:
C
      LOGICAL GOTWAV,GOTSDD,GOTCEN,GOTROT,GOTTIL,GOTCAL,RADIAL,LATPNT
      REAL WAVE,SDD,XC,YC,XCB,YCB,ROTX,ROTY,ROTZ,TILT,DCAL
C
C INFO common block:
C
      COMMON /INFO/ GOTWAV,GOTSDD,GOTCEN,GOTROT,GOTTIL,GOTCAL,RADIAL,
     &              LATPNT,
     &              WAVE,SDD,XC,YC,XCB,YCB,ROTX,ROTY,ROTZ,TILT,DCAL
C
C Declarations for CELPAR common block:
C
      INTEGER IHKL(3,MAXREF)
      REAL CELL(6),DRZ(3,MAXREF)
      REAL PHIX,PHIZ
      CHARACTER*20 SPCGRP
C
C CELPAR common block:
C
      COMMON /CELPAR/ IHKL,CELL,DRZ,PHIX,PHIZ,SPCGRP
C
C Declarations for STREAMS common block:
C
      INTEGER ITERM,IPRINT,ILOG
C
C STREAMS common block:
      COMMON /STREAMS/ ITERM,IPRINT,ILOG
C
C-----------------------------------------------------------------------

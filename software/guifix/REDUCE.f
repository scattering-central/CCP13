C     LAST UPDATE 02/12/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE REDUCE(BUF,NPOINTS,FX,FY,WIDTH)
      IMPLICIT NONE
C
C Purpose: Converts polygon vertex coordinates from image.c 
C          into centre-of-gravity filespace coordinates. Accepts
C          single pixels but puts lines in separate array.
C
C Calls   1: EVPOLY
C Called by: GUIFIX 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file:
C
      INCLUDE 'FIXPAR.COM'
C
C Arguments:
C
      REAL BUF(NPIX*NRAST)
      REAL FX(MAXVERT),FY(MAXVERT)
      INTEGER NPOINTS
      REAL WIDTH
C
C Local variables:
C
      INTEGER J,NP,NL
      REAL AVV,BAK,XCG,YCG
      INTEGER NVAL
C
C-----------------------------------------------------------------------
      NL = NLIN 
      NP = NPTS  
      IF(NPOINTS.GT.0)THEN
         IF(NPOINTS.EQ.2)THEN
C
C========Process lines
C 
            NL = NL + 1
            DO 10 J=1,2
               XLINE(J,NL) = FX(J)
               YLINE(J,NL) = FY(J)
 10         CONTINUE
            LWIDTH(NL) = NINT(WIDTH)
         ELSE
C
C========Process polygons and points 
C 
            NP = NP + 1
C     
C========Find centre of gravity, average value and number of interior
C========pixels for polygons
C 
            IF(NPOINTS.GT.2)THEN 
               CALL EVPOLY(BUF,FX,FY,NPOINTS,AVV,BAK,XCG,YCG,NVAL)
C
C========Process single pixel information
C
            ELSE
               XCG = FX(1)
               YCG = FY(1)
               AVV = BUF(NINT(FY(1))*NPIX+NINT(FX(1))+1)
               BAK = 0.0
               NVAL = 1
            ENDIF 
C
C========Write information to common block arrays
C 
            FXY(1,NP) = XCG
            FXY(2,NP) = YCG
            AVPIX(NP) = AVV
            BCK(NP) = BAK
            NVALS(NP) = NVAL
         ENDIF 
      ENDIF
      NLIN = NL 
      NPTS = NP
C
C========Convert to standard coordinates if possible
C 
      IF(GOTCEN.AND.GOTROT)THEN
         CALL FTOSTD
         IF(GOTWAV.AND.GOTSDD.AND.GOTTIL)CALL STOREC
      ENDIF
      RETURN
C
      END                  

C     LAST UPDATE 02/12/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE EVPOLY(BUF,FX,FY,NVTS,AVV,BAK,XCG,YCG,NVAL)
      IMPLICIT NONE
C
C Purpose: Extracts the pixel values from a polygon defined by the points,
C          IXY(2,NVTS) (in that sequence). Returns centre of gravity.. 
C          Also returns average pixel value and average backgound.
C
C Calls   0:
C Called by: REDUCE 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INCLUDE 'FIXPAR.COM'
C
C Arguments:
C
      REAL BUF(NPIX*NRAST),FX(MAXVERT),FY(MAXVERT)
      INTEGER NVTS,NVAL
      REAL AVV,BAK,XCG,YCG
C
C Local variables:
C
      INTEGER I,J,M,MM,N,N1,IXMIN,IXMAX,IYMIN,IYMAX,NBAK
      REAL ANGSUM,PI,CROSS,DOT,XM
      REAL X(2)
C
C Data:
C
      DATA PI /3.1415927/
C
C-----------------------------------------------------------------------
      IF(NVTS.LT.3)THEN
         WRITE(6,1000)
         RETURN
      ENDIF
C
C========Determine min and max of vertices
C
      IXMIN = NPIX
      IXMAX = 0
      IYMIN = NRAST
      IYMAX = 0
      DO 10 I=1,NVTS
         IF(NINT(FX(I)+0.5).GT.IXMAX)IXMAX = NINT(FX(I)+0.5)
         IF(NINT(FX(I)+0.5).LT.IXMIN)IXMIN = NINT(FX(I)+0.5)
         IF(NINT(FY(I)+0.5).GT.IYMAX)IYMAX = NINT(FY(I)+0.5)
         IF(NINT(FY(I)+0.5).LT.IYMIN)IYMIN = NINT(FY(I)+0.5)
 10   CONTINUE 
C
C========Calculate background along perimeter of polygon
C
      NBAK = 0
      BAK = 0.0
      DO 30 N=1,NVTS
         IF(N.LT.NVTS)THEN
            N1 = N + 1
         ELSE
            N1 = 1
         ENDIF
         X(1) = FX(N1) - FX(N)
         X(2) = FY(N1) - FY(N)
         XM = SQRT(X(1)*X(1)+X(2)*X(2))
         IF(XM.GT.0.0)THEN
            X(1) = X(1)/XM
            X(2) = X(2)/XM
            DO 20 M=0,INT(XM)
               I = NINT(FX(N) + FLOAT(M)*X(1) + 0.5)
               J = NINT(FY(N) + FLOAT(M)*X(2) + 0.5)
               IF(I.GE.1.AND.I.LE.NPIX.AND.
     &            J.GE.1.AND.J.LE.NRAST)THEN
                  MM = (J-1)*NPIX + I
                  NBAK = NBAK + 1
                  BAK = BAK + BUF(MM)
               ENDIF
 20         CONTINUE
         ENDIF
 30   CONTINUE
      IF(NBAK.GT.0)BAK = BAK/FLOAT(NBAK) 
C
C========Find interior points of polygon
C
      NVAL = 0
      XCG = 0.0
      YCG = 0.0
      AVV = 0.0
      DO 60 J=IYMIN,IYMAX
         M = (J-1)*NPIX
         DO 50 I=IXMIN,IXMAX
            MM = M + I
            ANGSUM = 0.0
            DO 40 N=1,NVTS
               IF(N.LT.NVTS)THEN
                  N1 = N + 1
               ELSE
                  N1 = 1
               ENDIF
               CROSS = ((FX(N)-FLOAT(I)+0.5)*(FY(N1)-FLOAT(J)+0.5) -
     &                  (FX(N1)-FLOAT(I)+0.5)*(FY(N)-FLOAT(J)+0.5))
               DOT = ((FX(N)-FLOAT(I)+0.5)*(FX(N1)-FLOAT(I)+0.5) +
     &                (FY(N)-FLOAT(J)+0.5)*(FY(N1)-FLOAT(J)+0.5)) 
               IF(ABS(CROSS).GT.0.0)ANGSUM = ANGSUM + ATAN2(CROSS,DOT)
 40         CONTINUE
            IF(ABS(ANGSUM).GT.PI)THEN 
               NVAL = NVAL + 1
               XCG = XCG + (FLOAT(I)-0.5)*(BUF(MM)-BAK)
               YCG = YCG + (FLOAT(J)-0.5)*(BUF(MM)-BAK)
               AVV = AVV + BUF(MM) - BAK
            ENDIF
 50      CONTINUE
 60   CONTINUE
      IF(AVV.GT.0)THEN
         XCG = XCG/AVV
         YCG = YCG/AVV
         CALL FLUSH(6)
         AVV = AVV/FLOAT(NVAL) + BAK
      ELSE
         XCG = 0.0
         YCG = 0.0
         DO 70 N=1,NVTS
            XCG = XCG + FX(N)
            YCG = YCG + FY(N)
 70      CONTINUE
         XCG = XCG/FLOAT(NVTS)
         YCG = YCG/FLOAT(NVTS)
      ENDIF
C
      RETURN
C
 1000 FORMAT(1X,'EVPOLY:Warning - polygon has less then 3 vertices')
      END                  

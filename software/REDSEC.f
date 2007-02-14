C     LAST UPDATE 17/01/97
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE REDSEC(BUF,CX,CY,X1,Y1,X2,Y2)
      IMPLICIT NONE
C
C Purpose: Converts sector coordinates from xfix 
C          into centre-of-gravity filespace coordinates.
C
C Calls   0: 
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
      REAL CX,CY,X1,Y1,X2,Y2
C
C Local variables:
C
      INTEGER NP,I,J,NR,NPHI,M,IX,IY,NVAL,NBAK
      REAL XS(2),YS(2),DELX(2),DELY(2)
      REAL DX1,DY1,DX2,DY2,PHI1,PHI2,DPHI,PHI,R,TEMP,DX,DY,R1,R2
      REAL X,Y,TWOPI
      REAL AVV,BAK,XCG,YCG
C
C Data:
C
      DATA TWOPI /6.2831853/
C
C-----------------------------------------------------------------------
      NP = NPTS
C
C========Process sectors
C 
      NP = NP + 1
C     
C========Find centre of gravity, average value and number of interior
C========pixels for sectors
C 
      DX1 = X1 - CX
      DY1 = CY - Y1
      DX2 = X2 - CX
      DY2 = CY - Y2
      R1 = SQRT(DX1*DX1+DY1*DY1)
      R2 = SQRT(DX2*DX2+DY2*DY2)
      PHI1 = ATAN2(DY1,DX1)
      PHI2 = ATAN2(DY2,DX2)
      IF(PHI2.LT.PHI1)PHI2 = PHI2 + TWOPI
C
C========Calculate background along perimeter of sector
C
      NBAK = 0
      BAK = 0.0
C
C========Sum the radial background contribution
C
      IF(R2.GT.R1)THEN
         DELX(1) = COS(PHI1)
         DELY(1) = -SIN(PHI1)
         DELX(2) = COS(PHI2)
         DELY(2) = -SIN(PHI2)
      ELSE
         DELX(1) = -COS(PHI1)
         DELY(1) = SIN(PHI1)
         DELX(2) = -COS(PHI2)
         DELY(2) = SIN(PHI2)
      ENDIF
      XS(1) = X1
      XS(2) = X2
      YS(1) = Y1
      YS(2) = Y2
      NR = NINT(ABS(R2-R1))
      DO 20 I=0,NR
         DO 10 J=1,2
         X = XS(J) + FLOAT(I)*DELX(J) + 0.5
         Y = YS(J) + FLOAT(I)*DELY(J) + 0.5
         IX = INT(X)
         IY = INT(Y)
         IF(IX.GE.1.AND.IX.LT.NPIX.AND.
     &      IY.GE.1.AND.IY.LT.NRAST)THEN
            NBAK = NBAK + 1
            M = (IY-1)*NPIX + IX
            DX = X - FLOAT(IX)
            DY = Y - FLOAT(IY)
            BAK = BAK
     &           + (1.0-DX)*(1.0-DY)*BUF(M)
     &           +       DX*(1.0-DY)*BUF(M+1)
     &           +       (1.0-DX)*DY*BUF(M+NPIX)
     &           +             DX*DY*BUF(M+NPIX+1)
         ENDIF
 10      CONTINUE
 20   CONTINUE
C
C========Sum azimuthal background contribution
C
      DPHI = 1/R1
      NPHI = NINT(R1*(PHI2-PHI1))
      DO 40 I=0,NPHI
         PHI = FLOAT(I)*DPHI
         X = CX + R1*COS(PHI) + 0.5
         Y = CY - R1*SIN(PHI) + 0.5
         IX = INT(X)
         IY = INT(Y)
         IF(IX.GE.1.AND.IX.LT.NPIX.AND.
     &      IY.GE.1.AND.IY.LT.NRAST)THEN
            NBAK = NBAK + 1
            M = (IY-1)*NPIX + IX
            DX = X - FLOAT(IX)
            DY = Y - FLOAT(IY)
            BAK = BAK 
     &           + (1.0-DX)*(1.0-DY)*BUF(M)
     &           +       DX*(1.0-DY)*BUF(M+1)
     &           +       (1.0-DX)*DY*BUF(M+NPIX)
     &           +             DX*DY*BUF(M+NPIX+1)
         ENDIF
 40   CONTINUE
      DPHI = 1/R2
      NPHI = NINT(R2*(PHI2-PHI1))
      DO 50 I=0,NPHI
         PHI = FLOAT(I)*DPHI
         X = CX + R2*COS(PHI) + 0.5
         Y = CY - R2*SIN(PHI) + 0.5
         IX = INT(X)
         IY = INT(Y)
         IF(IX.GE.1.AND.IX.LT.NPIX.AND.
     &      IY.GE.1.AND.IY.LT.NRAST)THEN
            NBAK = NBAK + 1
            M = (IY-1)*NPIX + IX
            DX = X - FLOAT(IX)
            DY = Y - FLOAT(IY)
            BAK = BAK
     &           + (1.0-DX)*(1.0-DY)*BUF(M)
     &           +       DX*(1.0-DY)*BUF(M+1)
     &           +       (1.0-DX)*DY*BUF(M+NPIX)
     &           +             DX*DY*BUF(M+NPIX+1)
         ENDIF
 50   CONTINUE
      IF(BAK.GT.0.0)BAK = BAK/FLOAT(NBAK)
C
C========Loop over interior points of sector
C
      NVAL = 0
      XCG = 0.0
      YCG = 0.0
      AVV = 0.0
      DO 70 I=1,NR-1
         R = R1 + SIGN(FLOAT(I),R2-R1)
         DPHI = 1/R
         NPHI = NINT(R*(PHI2-PHI1))
         DO 60 J=1,NPHI-1
            PHI = PHI1 + FLOAT(J)*DPHI
            X = CX + R*COS(PHI) + 0.5
            Y = CY - R*SIN(PHI) + 0.5
            IX = INT(X)
            IY = INT(Y)
            IF(IX.GE.1.AND.IX.LT.NPIX.AND.
     &         IY.GE.1.AND.IY.LT.NRAST)THEN
               NVAL = NVAL + 1
               M = (IY-1)*NPIX + IX
               DX = X - FLOAT(IX)
               DY = Y - FLOAT(IY)                
               TEMP = (1.0-DX)*(1.0-DY)*BUF(M)
     &              +       DX*(1.0-DY)*BUF(M+1)
     &              +       (1.0-DX)*DY*BUF(M+NPIX)
     &              +             DX*DY*BUF(M+NPIX+1)
               TEMP = TEMP - BAK
               XCG = XCG + (X-0.5)*TEMP
               YCG = YCG + (Y-0.5)*TEMP
               AVV = AVV + TEMP
            ENDIF
 60      CONTINUE
 70   CONTINUE
      IF(ABS(AVV).GT.0.0)THEN
         XCG = XCG/AVV
         YCG = YCG/AVV
         AVV = AVV/FLOAT(NVAL) + BAK
      ELSE
         PHI = (PHI2+PHI1)/2.0
         DPHI = (PHI2-PHI1)/2.0
         R = ABS(2.0*SIN(DPHI)*(R2**3-R1**3)/(3.0*DPHI*(R2**2-R1**2)))
         XCG = CX + R*COS(PHI)
         YCG = CY - R*SIN(PHI)
      ENDIF
C     
C========Write information to common block arrays
C
      FXY(1,NP) = XCG
      FXY(2,NP) = YCG
      AVPIX(NP) = AVV
      BCK(NP) = BAK
      NVALS(NP) = -NVAL
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



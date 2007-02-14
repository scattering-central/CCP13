C     LAST UPDATE 29/09/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FDEBYE(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is the Debye approximation to the intensity transform 
C          for chain molecules. 
C          of A: A(1) = I(0),  A(2) = Origin,  A(3) = Rg
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY
      PARAMETER(TINY=1.0D-10)
C
C Arguments:
C
      DOUBLE PRECISION A(10),DYDA(10)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      DOUBLE PRECISION  ARG,ARG2,ARG4,EX,FAC,DARG
C
C-----------------------------------------------------------------------
      IF(A(3).LT.TINY)A(3) = TINY
      ARG = (X-A(2))/A(3)
      ARG2 = ARG*ARG
      IF(ARG2.LT.TINY)THEN
         Y = A(1)
         DYDA(1) = 1.0D0
         DYDA(2) = 0.0D0
         DYDA(3) = 0.0D0
      ELSE
         ARG4 = ARG2*ARG2
         EX = EXP(-ARG2)
         FAC = 2.0D0*(EX-1.0D0+ARG2)
         Y = A(1)*FAC/ARG4
         DYDA(1) = FAC/ARG4
         DARG = 2.0D0*A(1)*(2.0D0/ARG2-1.0D0-(1.0D0+2.0D0/ARG2)*EX)/ARG4
         DYDA(2) = -2.0D0*ARG*DARG/A(3)
         DYDA(3) = -2.0D0*ARG2*DARG/A(3)
      ENDIF
C
      RETURN
      END


C     LAST UPDATE 18/03/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FDEXP(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is double exponential. The amplitude. centre and widths
C          of the double exponential are stored in consecutive locations 
C          of A: 
C          A(1) = B,  A(2) = E,  A(3) = G1, A(4) = G2
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY
      PARAMETER(TINY=1.0D-10)
C
C Arguments:
C
      DOUBLE PRECISION A(10),DYDA(10)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      DOUBLE PRECISION  ARG1,ARG2,EX1,EX2,FAC
C
C-----------------------------------------------------------------------
      IF(A(3).LT.TINY)A(3) = TINY
      IF(A(4).LT.TINY)A(4) = TINY
      ARG1 = (X-A(2))/A(3)
      ARG2 = (X-A(2))/A(4)
      EX1 = EXP(-ARG1)
      EX2 = EXP(ARG2)
      FAC = EX1 + EX2
      Y = 2.0D0*A(1)/FAC
      DYDA(1) = 2.0D0/FAC
      DYDA(2) = Y*(EX2/A(4)-EX1/A(3))/FAC
      DYDA(3) = -Y*ARG1*EX1/(FAC*A(3))
      DYDA(4) = Y*ARG2*EX2/(FAC*A(4))
C
      RETURN
      END


C     LAST UPDATE 30/03/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FLORENTZ(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is Lorentzian. The amplitude. centre and width of the
C           Lorentzian are stored in consecutive locations of A: 
C           A(1) = B,  A(2) = E,  A(3) = G
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY
      PARAMETER(TINY=1.0D-10)
C
C Arguments:
C
      DOUBLE PRECISION A(10),DYDA(10)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      DOUBLE PRECISION  ARG,EX,FAC
C
C-----------------------------------------------------------------------
      IF(A(3).LT.TINY)A(3) = TINY
      ARG = (X-A(2))/A(3)
      FAC = (1.0D0+ARG*ARG)
      Y = A(1)/FAC
      EX = 2.0D0*ARG*A(1)/(A(3)*FAC*FAC)
      DYDA(1) = 1.0D0/FAC
      DYDA(2) = EX
      DYDA(3) = ARG*EX
C
      RETURN
      END


C     LAST UPDATE 22/03/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FGAUSS(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is Gaussian. The amplitude. centre
C          and width of the Gaussian are stored in consecutive locations
C          of A: A(1) = B,  A(2) = E,  A(3) = G
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY
      PARAMETER(TINY=1.0D-10)
C
C Arguments:
C
      DOUBLE PRECISION A(10),DYDA(10)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      DOUBLE PRECISION  ARG,EX,FAC
C
C-----------------------------------------------------------------------
      IF(A(3).LT.TINY)A(3) = TINY
      ARG = (X-A(2))/A(3)
      EX = EXP(-ARG*ARG)
      FAC = A(1)*EX*2.0D0*ARG
      Y = A(1)*EX
      DYDA(1) = EX
      DYDA(2) = FAC/A(3)
      DYDA(3) = FAC*ARG/A(3)
C
      RETURN
      END


C     LAST UPDATE 20/12/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FPEARSON(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is Pearson VII. The amplitude. centre and widths of 
C          the Pearson VII are stored in consecutive locations of A: 
C          A(1) = B,  A(2) = E,  A(3) = G1, A(4) = G2
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY,HALF,BIG
      PARAMETER(TINY=1.0D-10,HALF=0.5D0,BIG=1.0D03)
C
C Arguments:
C
      DOUBLE PRECISION A(10),DYDA(10)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      DOUBLE PRECISION  ARG,EX,FAC
C
C-----------------------------------------------------------------------
      IF(A(3).LT.TINY)A(3) = TINY
      IF(A(4).LT.HALF)A(4) = HALF
      IF(A(4).GT.BIG)A(4) = BIG
      ARG = (X-A(2))/A(3)
      EX = 2.0D0**(1.0D0/A(4)) - 1.0D0
      FAC = (1.0D0+4.0D0*ARG*ARG*EX)
      Y = A(1)/FAC**A(4)
      DYDA(1) = 1.0D0/FAC**A(4)
      DYDA(2) = 8.0D0*ARG*A(4)*EX*Y/(A(3)*FAC)
      DYDA(3) = ARG*DYDA(2)
      DYDA(4) = (4.0D0*ARG*ARG*LOG(2.0D0)*(EX+1.0D0)/
     &          (A(4)*FAC)-LOG(FAC))*Y
C
      RETURN
      END


C     LAST UPDATE 04/08/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FVOIGT(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is a Voigtian. The amplitude. centre and widths of 
C          the Voigtian are stored in consecutive locations of A: 
C          A(1) = B,  A(2) = E,  A(3) = G1, A(4) = G2
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY
      PARAMETER(TINY=1.0D-10)
C
C Arguments:
C
      DOUBLE PRECISION A(10),DYDA(10)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      INTEGER I
      DOUBLE PRECISION  V,Z,P,PMA,ZMB,ZMB2,PMA2,DVDZ,DVDP,TOP,BOT,BOT2,
     &                  PP,DVMDP,TOPM,BOTM
      DOUBLE PRECISION  ALPHA(4),BETA(4),GAMMA(4),DELTA(4),GAPDB(4),
     &                  A2PB2(4)
C
C Common block:
C
      DOUBLE PRECISION VMAX
      COMMON /VGTCOM/VMAX
      SAVE /VGTCOM/
C
C Data:
C
      DATA ALPHA /-1.2150D0,-1.3509D0,-1.2150D0,-1.3509D0/,
     &     BETA  / 1.2359D0, 0.3786D0,-1.2359D0,-0.3786D0/,
     &     GAMMA /-0.3085D0, 0.5906D0,-0.3085D0, 0.5906D0/,
     &     DELTA / 0.0210D0,-1.1858D0,-0.0210D0, 1.1858D0/
      DATA GAPDB / 0.4007814D0,-1.24678542D0,0.4007814D0,-1.24678542D0/,
     &     A2PB2 / 3.00367381D0,1.96826877D0,3.00367381D0,1.96826877D0/
C
C-----------------------------------------------------------------------
      P = A(4)
      PP = P*P
      IF(A(3).LT.TINY)A(3) = TINY
      Z = (X-A(2))/A(3)
      V = 0.0D0
      VMAX = 0.0D0
      DVDZ = 0.0D0
      DVDP = 0.0D0
      DVMDP = 0.0D0
      DO 10 I=1,4
         PMA = P - ALPHA(I)
         ZMB = Z - BETA(I)
         PMA2 = PMA*PMA
         ZMB2 = ZMB*ZMB
         TOP = GAMMA(I)*PMA + DELTA(I)*ZMB
         BOT = PMA2 + ZMB2
         BOT2 = BOT*BOT
         V = V + TOP/BOT
         TOPM = GAMMA(I)*P - GAPDB(I)
         BOTM = PP - 2.0D0*P*ALPHA(I) + A2PB2(I)
         VMAX = VMAX + TOPM/BOTM
         DVDZ = DVDZ + (DELTA(I)*BOT-2.0D0*ZMB*TOP)/BOT2
         DVDP = DVDP + (GAMMA(I)*BOT-2.0D0*PMA*TOP)/BOT2
         DVMDP = DVMDP + (GAMMA(I)*BOTM-2.0D0*PMA*TOPM)/(BOTM*BOTM)
 10   CONTINUE
      V = V/VMAX
      DVDZ = DVDZ/VMAX
      DVDP = DVDP/VMAX
      DVMDP = DVMDP/VMAX
      Y = A(1)*V
      DYDA(1) = V
      DYDA(2) = -DVDZ*A(1)/A(3)
      DYDA(3) = Z*DYDA(2)
      DYDA(4) = A(1)*(DVDP-V*DVMDP)
C
      RETURN
      END
      

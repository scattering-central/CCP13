C     LAST UPDATE 04/08/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FVOIGT(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is a Voigtian. The amplitude. centre and widths of 
C          the Voigtian are stored in consecutive locations of A: 
C          A(1) = H,  A(2) = P,  
C          A(3) = FWHM(Gaussian), A(4) = FWHM(Lorentzian)
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY,FACTOR
      PARAMETER(TINY=1.0D-10,FACTOR=1.66510922231D0)
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
     &                  PP,W,DVMDP,TOPM,BOTM
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
      P = A(4)/2.0D0
      PP = P*P
      IF(A(3).LT.TINY)A(3) = TINY
      W = A(3)/FACTOR
      Z = (X-A(2))/W
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
      DYDA(2) = -DVDZ*A(1)/W
      DYDA(3) = FACTOR*Z*DYDA(2)
      DYDA(4) = 2.0D0*A(1)*(DVDP-V*DVMDP)
C
      RETURN
      END
      

C     LAST UPDATE 07/08/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION VGTINT(A1,A3,A4)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is a Voigtian. The amplitude. centre and widths of 
C          the Voigtian are stored in consecutive locations of A: 
C          A(1) = H,  A(2) = E,  A(3) = G, A(4) = P
C          This function returns the integrated area under the curve.
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY,FACTOR
      PARAMETER(TINY=1.0D-10,FACTOR=1.66510922231D0)
C
C Arguments:
C
      DOUBLE PRECISION A1,A3,A4
C
C Local variables:
C
      INTEGER I
      DOUBLE PRECISION  PI,PMA,PMA2,RM,RN,RA,RB,RC,SUM,W,P
      DOUBLE PRECISION  ALPHA(4),BETA(4),GAMMA(4),DELTA(4)
C
C Common block:
C
      DOUBLE PRECISION VCOM
      COMMON /VGTCOM/ VCOM
      SAVE /VGTCOM/
C
C Data:
C
      DATA PI    /3.1415926536D0/
      DATA ALPHA /-1.2150D0,-1.3509D0,-1.2150D0,-1.3509D0/,
     &     BETA  / 1.2359D0, 0.3786D0,-1.2359D0,-0.3786D0/,
     &     GAMMA /-0.3085D0, 0.5906D0,-0.3085D0, 0.5906D0/,
     &     DELTA / 0.0210D0,-1.1858D0,-0.0210D0, 1.1858D0/
C
C-----------------------------------------------------------------------
      IF(A3.LT.TINY)A3 = TINY
      W = A3/FACTOR
      P = A4/2.0D0
      SUM = 0.0D0
      RC = 1.0D0
      DO 10 I=1,4
         PMA = P - ALPHA(I)
         PMA2 = PMA*PMA
         RB = -BETA(I)
         RM = DELTA(I)
         RN = GAMMA(I)*PMA + DELTA(I)*RB
         RA = PMA2 + RB*RB
         SUM = SUM + (RN*RC-RM*RB)/(RC*SQRT(RA*RC-RB*RB))
 10   CONTINUE
      SUM = SUM*PI*A1*W/VCOM
      VGTINT = SNGL(SUM)
C
      RETURN
      END
      

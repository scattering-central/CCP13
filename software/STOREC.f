C     LAST UPDATE 21/02/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE STOREC
      IMPLICIT NONE
C
C Purpose: Converts coordinates from standard to reciprocal space
C
C Calls   0:
C Called by: CTILT 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file:
C
      INCLUDE 'FIXPAR.COM'
C
C Local variables:
C
      INTEGER I
      REAL CMU,CHI,TEMP,R,Z,D
C
C-----------------------------------------------------------------------
      DO 10 I=1,NPTS
         CMU = COS(ATAN2(SXY(1,I),SDD))
         CHI = ATAN2(SXY(2,I),SQRT(SXY(1,I)**2+SDD**2))
         TEMP = 1.0 - CMU*COS(CHI)
         IF(TEMP.LT.0.0)TEMP = 0.0
         D = SQRT(2.0*TEMP)/WAVE
         Z = (SIN(TILT)*TEMP+COS(TILT)*SIN(CHI))/WAVE
         R = D*D - Z*Z
         IF(R.LT.0.0)R = 0.0
         R = SQRT(R)
         R = SIGN(R,SXY(1,I))
         RZ(1,I) = R
         RZ(2,I) = Z
 10   CONTINUE
      RETURN
C
      END                  

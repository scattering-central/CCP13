C     LAST UPDATE 17/03/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE RECIP(U,V,R,Z)
      IMPLICIT NONE
C
C Purpose: Converts from film space (U,V) to reciprocal space (R,Z)
C
C Calls   0:
C Called by: REFALL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INCLUDE 'FIXPAR.COM'
C
C Scalar Arguments:
C
      REAL U,V,R,Z
C
C Local variables:
C
      REAL D(3),DR(3),PHI(3,3)
      REAL DNORM,DSQ,RSQ,TEMP
      REAL CRX,SRX,CRY,SRY,CRZ,SRZ
      INTEGER J,K
C
C Intrinsic Functions:
C
      INTRINSIC COS,SIN,SQRT
C
C-----------------------------------------------------------------------
C
C========Form sines and cosines of detector rotation angles
C
      CRX = COS(ROTX)
      SRX = SIN(ROTX)
      CRY = COS(ROTY)
      SRY = SIN(ROTY)
      CRZ = COS(ROTZ)
      SRZ = SIN(ROTZ)
C
C========Form detector rotation matrix RzRyRx
C
      PHI(1,1) = CRZ*CRY
      PHI(1,2) = CRZ*SRY*SRX + SRZ*CRX
      PHI(1,3) = -CRZ*SRY*CRX + SRZ*SRX
      PHI(2,1) = -SRZ*CRY
      PHI(2,2) = -SRZ*SRY*SRX + CRZ*CRX
      PHI(2,3) = SRZ*SRY*CRX + CRZ*SRX
      PHI(3,1) = SRY
      PHI(3,2) = -CRY*SRX
      PHI(3,3) = CRY*CRX
C
C========Set up detector space vector and normalize
C
      DNORM = SQRT(SDD*SDD+U*U+V*V)
      D(1) = SDD/DNORM
      D(2) = U/DNORM
      D(3) = V/DNORM
C
C========Apply detector orientation matrix
C
      DO 20 J=1,3
         DR(J) = 0.0
         DO 10 K=1,3
            DR(J) = DR(J) + PHI(J,K)*D(K)
 10      CONTINUE
 20   CONTINUE
C
C========DR(1) = cos(2theta) and DR(3) = sin(chi) from rotated vector
C
      TEMP = 1.0 - DR(1)
      IF(TEMP.LT.0.0)TEMP = 0.0
      DSQ = 2.0*TEMP/(WAVE*WAVE)
      Z = (SIN(TILT)*TEMP+COS(TILT)*DR(3))/WAVE
      RSQ = DSQ - Z*Z
      IF(RSQ.LT.0.0)RSQ = 0.0
      R = SQRT(RSQ)
C
      RETURN
      END



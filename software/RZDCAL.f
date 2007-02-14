      SUBROUTINE RZDCAL(AMAT,IH,IK,IL,R0,Z0,D0)
      IMPLICIT NONE
C
      REAL AMAT(3,3) 
      REAL R0,Z0,D0
      INTEGER IH,IK,IL
C 
      INTEGER I,J
      DOUBLE PRECISION RC(3),H(3)
      DOUBLE PRECISION ZZ,DD
C
      H(1) = DBLE(IH)
      H(2) = DBLE(IK)
      H(3) = DBLE(IL)
C
      DD = 0.0D0
      DO 20 I=1,3
         RC(I) = 0.0D0
         DO 10 J=1,3
            RC(I) = RC(I) + DBLE(AMAT(I,J))*H(J)
 10      CONTINUE
         DD = DD + RC(I)**2
 20   CONTINUE
      ZZ = ABS(RC(3)**2)
      IF(DD.GT.ZZ)THEN 
         R0 = SNGL(SQRT(DD-ZZ))
      ELSE
         R0 = 0.0
      ENDIF
      Z0 = SNGL(SQRT(ZZ))
      D0 = SNGL(SQRT(DD))
      RETURN 
C
      END

      SUBROUTINE RZDCAL(AMAT,IH,IK,IL,R0,Z0,D0)
      IMPLICIT NONE
C
      REAL AMAT(3,3) 
      REAL R0,Z0,D0
      INTEGER IH,IK,IL
C 
      INTEGER I,J
      REAL RC(3),H(3)
C
      H(1) = FLOAT(IH)
      H(2) = FLOAT(IK)
      H(3) = FLOAT(IL)
C
      D0 = 0.0
      DO 20 I=1,3
         RC(I) = 0.0
         DO 10 J=1,3
            RC(I) = RC(I) + AMAT(I,J)*H(J)
 10      CONTINUE
         D0 = D0 + RC(I)**2
 20   CONTINUE
      Z0 = ABS(RC(3))
      IF(D0.GT.Z0*Z0)THEN 
         R0 = SQRT(D0-Z0*Z0) 
      ELSE
         R0 = 0.0
      ENDIF
      D0 = SQRT(D0)
      RETURN 
C
      END

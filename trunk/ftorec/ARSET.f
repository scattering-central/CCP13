      SUBROUTINE ARSET(ARRAY,NDIMEN,VAL)
      IMPLICIT NONE
C arset sets first ndimen elements of array (as one dimensional) to val
C
C     .. Scalar Arguments ..
      REAL VAL
      INTEGER NDIMEN
C     ..
C     .. Array Arguments ..
      REAL ARRAY(NDIMEN)
C     ..
C     .. Local Scalars ..
      INTEGER I
C     ..
      I = 1
 10   IF(I.LE.NDIMEN)THEN
         ARRAY(I) = VAL
         I = I + 1
         GOTO 10
C
      ENDIF
C
      RETURN
C
      END

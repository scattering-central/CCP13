      SUBROUTINE AISET(IARRAY,NDIMEN,IVAL)
      IMPLICIT NONE
C aiset sets first ndimen elts of integer array (as 1 dimensional) to ival
C     .. Scalar Arguments ..
      INTEGER IVAL,NDIMEN
C     ..
C     .. Array Arguments ..
      INTEGER IARRAY(NDIMEN)
C     ..
C     .. Local Scalars ..
      INTEGER I
C     ..
      I = 1
 10   IF(I.LE.NDIMEN)THEN
         IARRAY(I) = IVAL
         I = I + 1
         GOTO 10
C
      ENDIF
C
      RETURN
C
      END

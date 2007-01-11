C     LAST UPDATE 22/05/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE WRAPZ(DCIN,NRS,NZS,I1,I2,J1,J2,ICEN,JCEN)
      IMPLICIT NONE
C
C Purpose: Wraps non-equatorial intensity around the equator
C
C Calls 0: 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Scalar arguments:
C
      INTEGER I1,I2,ICEN,J1,J2,JCEN,NRS,NZS
C
C Array arguments:
C
      REAL DCIN(-NRS:NRS,-NZS:NZS)
C
C Local scalars:
C
      INTEGER I,J,JDIF,JMAP
C 
C-----------------------------------------------------------------------
C
      IF(JCEN+J1.LT.0)THEN
C
C========Wrap about equator, J1..-JCEN-1 add to -2*JCEN-J1-1..-JCEN
C
         JDIF = -2*JCEN - 1
         IF(JDIF-J1.GT.NZS)STOP 'WRAPZ: overwrap in Z'
         IF(JDIF-J1.GT.J2)THEN
C
C========Longer than original, so zero
C
            DO 20 J=J2+1,JDIF-J1
               DO 10 I=I1,I2
                  DCIN(I,J) = 0.
 10            CONTINUE
 20         CONTINUE
            J2 = JDIF - J1
         ENDIF
C
         DO 40 J=J1,-JCEN-1
            JMAP = JDIF - J
            DO 30 I=I1,I2
               DCIN(I,JMAP) = DCIN(I,JMAP) + DCIN(I,J)
 30         CONTINUE
 40      CONTINUE
         J1 = -JCEN
      ENDIF
C
      RETURN
      END

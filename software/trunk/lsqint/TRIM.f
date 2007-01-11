C     LAST UPDATE 22/05/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE TRIM(DCIN,NRS,NZS,I1,I2,J1,J2,IL,IR,IAMIN,IAMAX,JAMIN,
     &                JAMAX,EMAX)
      IMPLICIT NONE
C
C Purpose: Sets IL and IR to start and end points of each line
C
C Calls 0: 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      REAL EPS
      PARAMETER(EPS=3.92E-03)
C
C Scalar arguments:
C
      INTEGER I1,I2,IAMAX,IAMIN,J1,J2,JAMAX,JAMIN,NRS,NZS
      REAL EMAX
C
C Array arguments:
C
      REAL DCIN(-NRS:NRS,-NZS:NZS)
      INTEGER IL(-NZS:NZS),IR(-NZS:NZS)
C
C Local scalars:
C
      REAL THRESH
      INTEGER I,J
C 
C-----------------------------------------------------------------------
C
      EMAX = 0.0
      DO 20 J=J1,J2
         DO 10 I=I1,I2
            EMAX = MAX(EMAX,DCIN(I,J))
 10      CONTINUE
 20   CONTINUE
      THRESH = EPS*EMAX
      DO 50 J=J1,J2
         IL(J) = I1
 30      IF(DCIN(IL(J),J).LT.THRESH.AND.IL(J).LE.I2)THEN
            IL(J) = IL(J) + 1
            GOTO 30
         ENDIF
C
         IR(J) = I2
 40      IF(DCIN(IR(J),J).LT.THRESH.AND.IR(J).GE.IL(J))THEN
            IR(J) = IR(J) - 1
            GOTO 40
         ENDIF
 50   CONTINUE
C
C=======Have the exact form - now fit to limits
C
      J1 = MAX(J1,JAMIN)
      J2 = MIN(J2,JAMAX)
      DO 60 J=J1,J2
         IL(J) = MAX(IL(J),IAMIN)
         IR(J) = MIN(IR(J),IAMAX)
 60   CONTINUE
C
C========Check for blank lines at top or bottom
C
 70   IF(IR(J1).LT.IL(J1).AND.J1.LE.J2)THEN
         J1 = J1 + 1
         GOTO 70
      ENDIF
C
 80   IF(IR(J2).LT.IL(J2).AND.J1.LE.J2)THEN
         J2 = J2 - 1
         GOTO 80
      ENDIF
      RETURN
C
      END

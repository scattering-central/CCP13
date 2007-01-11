C     LAST UPDATE 17/05/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SETSPLODGE(DCIN,NRS,NZS,I1,I2,ICEN,J1,J2)
      IMPLICIT NONE
C
C Purpose: Define initial area of spot profile
C
C Calls 2: ADDHORIZ, ADDVERT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      REAL EPS
      PARAMETER(EPS=3.92E-03)
C
C Scalar arguments:
C
      INTEGER I1,I2,ICEN,J1,J2,NRS,NZS
C
C Array arguments:
C
      REAL DCIN(-NRS:NRS,-NZS:NZS)
C
C Local Scalars:
C
      REAL EBOT,ELEFT,ERITE,ETOP,EMAX,THRESH
      LOGICAL BOTLIM,LEFLIM,RITLIM,TOPLIM,BOTTHR,LEFTHR,RITTHR,TOPTHR
C
C External Functions:
C
      REAL SPLODGE
      EXTERNAL SPLODGE
C 
C-----------------------------------------------------------------------
C
C========Set initial limits
C
      I1 = 0
      J1 = 0
      I2 = 1
      J2 = 0
C
C========Evaluate initial values
C
      DCIN(I1,J1) = SPLODGE(I1,J1)
      IF(NRS.EQ.0.AND.NZS.EQ.0)THEN
         I2 = 0
         RETURN
      ENDIF
      ELEFT = DCIN(I1,J1)
      DCIN(I2,J2) = SPLODGE(I2,J2)
      ERITE = DCIN(I2,J2)
      EMAX = MAX(ELEFT,ERITE)
      ETOP = EMAX
      EBOT = EMAX
      THRESH = EPS*EMAX
      TOPLIM = .FALSE.
      BOTLIM = .FALSE.
      LEFLIM = .FALSE.
      RITLIM = .FALSE.
C
 10   CONTINUE
C
         IF(.NOT.TOPLIM)THEN
            IF(ETOP.GT.THRESH)THEN
               IF(J2.EQ.NZS)THEN
                  WRITE(6,1020)J2
                  WRITE(4,1020)J2
                  TOPLIM = .TRUE.
                  TOPTHR = .TRUE.
               ELSE
                  J2 = J2 + 1
                  CALL ADDHORIZ(DCIN,NRS,NZS,ETOP,J2,I1,I2,ELEFT,ERITE)
                  IF(ETOP.GT.EMAX)THEN
                     EMAX = ETOP
                     THRESH = EPS*EMAX
                  ENDIF
                  TOPTHR = .FALSE.
               ENDIF
            ELSE
               TOPTHR = .TRUE.
            ENDIF
         ENDIF
C
         IF(.NOT.BOTLIM)THEN
            IF(EBOT.GT.THRESH)THEN
               IF(J1.EQ.-NZS)THEN
                  WRITE(6,1030)J1
                  WRITE(4,1030)J1
                  BOTLIM = .TRUE.
                  BOTTHR = .TRUE.
               ELSE
                  J1 = J1 - 1
                  CALL ADDHORIZ(DCIN,NRS,NZS,EBOT,J1,I1,I2,ELEFT,ERITE)
                  IF(EBOT.GT.EMAX)THEN
                     EMAX = EBOT
                     THRESH = EPS*EMAX
                  ENDIF
                  BOTTHR = .FALSE.
               ENDIF
            ELSE
               BOTTHR = .TRUE.
            ENDIF
         ENDIF
C
         IF(.NOT.LEFLIM)THEN
            IF(ELEFT.GT.THRESH)THEN
               IF(I1.EQ.-NRS)THEN
                  WRITE(6,1040)I1
                  WRITE(4,1040)I1
                  LEFLIM = .TRUE.
                  LEFTHR = .TRUE.
               ELSE
                  I1 = I1 - 1
                  CALL ADDVERT(DCIN,NRS,NZS,ELEFT,I1,J1,J2,ETOP,EBOT)
                  IF(ELEFT.GT.EMAX)THEN
                     EMAX = ELEFT
                     THRESH = EPS*EMAX
                  ENDIF
                  LEFTHR = .FALSE.
               ENDIF
            ELSE
               LEFTHR = .TRUE.
            ENDIF
         ENDIF
C
         IF(.NOT.RITLIM)THEN
            IF(ERITE.GT.THRESH)THEN
               IF(I2.EQ.NRS)THEN
                  WRITE(6,1050)I2
                  WRITE(4,1050)I2
                  RITLIM = .TRUE.
                  RITTHR = .TRUE.
               ELSE
                  I2 = I2 + 1
                  CALL ADDVERT(DCIN,NRS,NZS,ERITE,I2,J1,J2,ETOP,EBOT)
                  IF(ERITE.GT.EMAX)THEN
                     EMAX = ERITE
                     THRESH = EPS*EMAX
                  ENDIF
                  RITTHR = .FALSE.
               ENDIF
            ELSE
               RITTHR = .TRUE.
            ENDIF
         ENDIF
C
         IF(TOPTHR.AND.BOTTHR.AND.LEFTHR.AND.RITTHR)RETURN
      GOTO 10
C
 1020 FORMAT(1X,'SETSPLODGE: reached maximum vertical extent ',I5)
 1030 FORMAT(1X,'SETSPLODGE: reached maximum vertical extent ',I5)
 1040 FORMAT(1X,'SETSPLODGE: reached maximum horizontal extent ',I5)
 1050 FORMAT(1X,'SETSPLODGE: reached maximum horizontal extent ',I5)
      END

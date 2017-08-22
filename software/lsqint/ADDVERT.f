C     LAST UPDATE 22/05/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE ADDVERT(DCIN,NRS,NZS,E,I,J1,J2,ETOP,EBOT)
      IMPLICIT NONE
C
C Purpose: Adds up contributions to a profile along a column
C
C Calls 0: 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Scalar arguments:
C
      REAL E,EBOT,ETOP
      INTEGER I,J1,J2,NRS,NZS
C
C Array arguments:
C
      REAL DCIN(-NRS:NRS,-NZS:NZS)
C
C Local scalars:
C
      INTEGER J
C
C External functions:
C
      REAL SPLODGE
      EXTERNAL SPLODGE
C 
C-----------------------------------------------------------------------
C
      DCIN(I,J1) = SPLODGE(I,J1)
      E = DCIN(I,J1)
      EBOT = MAX(EBOT,E)
      DCIN(I,J2) = SPLODGE(I,J2)
      ETOP = MAX(ETOP,DCIN(I,J2))
      E = MAX(E,DCIN(I,J2))
      DO 10 J=J1+1,J2-1
         DCIN(I,J) = SPLODGE(I,J)
         E = MAX(E,DCIN(I,J))
 10   CONTINUE
      RETURN
C
      END

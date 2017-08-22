C     LAST UPDATE 17/05/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE ADDHORIZ(DCIN,NRS,NZS,E,J,I1,I2,ELEFT,ERITE)
      IMPLICIT NONE
C
C Purpose: Adds up contributions to a profile along a row
C
C Calls 0: 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Scalar arguments:
C
      REAL E,ELEFT,ERITE
      INTEGER I1,I2,J,NRS,NZS
C
C Array arguments:
C
      REAL DCIN(-NRS:NRS,-NZS:NZS)
C
C Local scalars:
C
      INTEGER I
C
C External Function:
C
      REAL SPLODGE
      EXTERNAL SPLODGE
C 
C-----------------------------------------------------------------------
C
      DCIN(I1,J) = SPLODGE(I1,J)
      E = DCIN(I1,J)
      ELEFT = MAX(ELEFT,E)
      DCIN(I2,J) = SPLODGE(I2,J)
      ERITE = MAX(ERITE,DCIN(I2,J))
      E = MAX(E,DCIN(I2,J))
      DO 10 I=I1+1,I2-1
         DCIN(I,J) = SPLODGE(I,J)
         E = MAX(E,DCIN(I,J))
 10   CONTINUE
      RETURN
C
      END

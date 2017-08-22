C     LAST UPDATE 01/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FILL (ARRAY,NPTS,VALUE)
      IMPLICIT NONE
C
C Purpose: Zero specified nos. of elements of a data array 
C
      REAL    ARRAY(1),VALUE
      INTEGER NPTS
C
C ARRAY  : Data array to be zeroed
C NPTS   : Nos. of elements to zero
C VALUE  : Value to fill array
C
C Calls   0:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      INTEGER I
C
C-----------------------------------------------------------------------
      DO 10 I=1,NPTS
         ARRAY(I)=VALUE
10    CONTINUE
      RETURN
      END

C     LAST UPDATE 02/1/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE ROOTJ(N,XMAX,ROOTS,MAXRTS,NR)
      IMPLICIT NONE
C
C Purpose: Calculates the first NR roots of Jn out to XMAX or the first
C          MAXRTS roots if NR > MAXRTS.
C
C Calls   1: RTJNK
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C
C Arguments:
C
      INTEGER N,MAXRTS,NR
      REAL ROOTS(MAXRTS),XMAX
C
C External function:
C
      REAL RTJNK
      EXTERNAL RTJNK
C
C Local variables:
C
      INTEGER I
C-----------------------------------------------------------------------
      DO 10 I=1,MAXRTS
         ROOTS(I) = RTJNK(N,I)
         IF(ROOTS(I).GT.XMAX)THEN
            NR = I - 1
            RETURN
         ENDIF
 10   CONTINUE
      NR = I - 1
C
      RETURN
      END       

           
C     LAST UPDATE 02/1/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION RTJNK(N,K)
      IMPLICIT NONE
C
C Purpose: Calculates the Kth root of Jn.
C
C Calls   1: RTSAFE
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      REAL XACC,PI
      PARAMETER(XACC=1.0E-04,PI=3.141592654)
C
C Arguments:
C
      INTEGER N,K
C
C Local variables:
C
      REAL K0
      INTEGER I
      REAL RTMP,X1,X2
C
C External functions:
C
      REAL RTSAFE,BESSD
      EXTERNAL RTSAFE,BESSD
C
C Common block variables:
C
      INTEGER NBESS
C
C Common blocks:
C
      COMMON /BORDER/NBESS
C
C Data:
C
      DATA K0 /2.40483/
C-----------------------------------------------------------------------
C
C========Find Kth roots of zero order
C
      RTMP = K0
      NBESS = 0
      DO 10 I=2,K
         X1 = RTMP + 0.5*PI
         X2 = X1 + PI
         RTMP = RTSAFE(BESSD,X1,X2,XACC)
 10   CONTINUE
C
C========Find all the intervening Kth roots
C
      DO 20 I=1,ABS(N)
         NBESS = I
         X1 = RTMP
         X2 = X1 + PI
         RTMP = RTSAFE(BESSD,X1,X2,XACC)
 20   CONTINUE
      RTJNK = RTMP
C
      RETURN
      END                  




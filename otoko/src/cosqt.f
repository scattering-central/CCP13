C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE COSQT (M,TABLE)
      IMPLICIT NONE
C
C Purpose: Generate quarter-length cosine table
C
      REAL    TABLE(513)
      INTEGER M
C
C TABLE  : Cosine table
C M      : Power of FFT
C
C Calls   0:
C Called by: FRWFFT , INVFFT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    SCL,TWOPI,THETA
      INTEGER NPT,ND4P1,I
C
C SCL    : Scale factor
C TWOPI  : 2*PI
C THETA  : Angle
C NPT    : Nos. of points
C ND4P1  : Nos. of pts/2 plus 1
C
      DATA TWOPI/6.283185307/
C
C-----------------------------------------------------------------------
      NPT=2**M
      ND4P1=NPT/4+1
      SCL=TWOPI/REAL(NPT)
      DO 10 I=1,ND4P1
         THETA=REAL(I-1)*SCL
         TABLE(I)=COS(THETA)
 10   CONTINUE
      RETURN
      END

C     LAST UPDATE 15/02/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION PSNINT(A1,A3,A4)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is Pearson VII. The amplitude. centre and widths of 
C          the Pearson VII are stored in consecutive locations of A: 
C          A(1) = B,  A(2) = E,  A(3) = G1, A(4) = G2
C          This function returns the integrated area under the curve.
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameter:
C
      DOUBLE PRECISION PI,TINY
      PARAMETER (PI=3.14159265359D0,TINY=1.0D-10)
C
C Arguments:
C
      DOUBLE PRECISION A1,A3,A4
C
C Local variables:
C
      INTEGER N,I
      DOUBLE PRECISION FRAC,ARG
      REAL A,B,SS
C
C External function:
C
      REAL POWCOS
      EXTERNAL POWCOS
C
C Common block:
C
      DOUBLE PRECISION DEL
      COMMON /PSNCOM/ DEL
C
C-----------------------------------------------------------------------
C
      IF(A4.LT.TINY)RETURN
      B = SNGL(PI/2.0D0)
      A = -B
      FRAC = 1.0D0
      IF(A4.LT.1.0D0)THEN
         DEL = 2.0D0*(A4-1.0D0)
c      ELSEIF(A4.GT.1.0D3)THEN
c         DEL = 0.0
      ELSE
         N = INT(A4-1.0D0)
         ARG = DBLE(N)
         DEL = 2.0D0*(A4-ARG-1.0D0)
         DO 10 I=1,2*N,2
            ARG = DBLE(I)
            FRAC = FRAC*(ARG+DEL)/(ARG+DEL+1.0D0)
 10      CONTINUE
      ENDIF
      IF(DEL.LT.TINY)THEN
         SS = SNGL(PI)
      ELSE
         CALL QGAUS(POWCOS,A,B,SS)
      ENDIF
      FRAC = FRAC/(2.0D0*SQRT(2.0D0**(1.0D0/A4)-1.0D0))
      PSNINT = SNGL(A1*A3*FRAC)*SS
      RETURN
      END

      REAL FUNCTION POWCOS(X)
      REAL X
      DOUBLE PRECISION CX
      DOUBLE PRECISION DEL
      COMMON /PSNCOM/ DEL
      CX = DBLE(COS(X))
      POWCOS = SNGL(CX**DEL)
      RETURN
      END

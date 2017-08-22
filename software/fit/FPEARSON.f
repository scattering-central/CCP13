C     LAST UPDATE 20/12/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FPEARSON(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is Pearson VII. The amplitude. centre and widths of 
C          the Pearson VII are stored in consecutive locations of A: 
C          A(1) = H,  A(2) = P,  A(3) = FWHM, A(4) = S
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY,HALF,BIG
      PARAMETER(TINY=1.0D-10,HALF=0.5D0,BIG=1.0D03)
C
C Arguments:
C
      DOUBLE PRECISION A(10),DYDA(10)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      DOUBLE PRECISION  ARG,EX,FAC
C
C-----------------------------------------------------------------------
      IF(A(3).LT.TINY)A(3) = TINY
      IF(A(4).LT.HALF)A(4) = HALF
      IF(A(4).GT.BIG)A(4) = BIG
      ARG = (X-A(2))/A(3)
      EX = 2.0D0**(1.0D0/A(4)) - 1.0D0
      FAC = (1.0D0+4.0D0*ARG*ARG*EX)
      Y = A(1)/FAC**A(4)
      DYDA(1) = 1.0D0/FAC**A(4)
      DYDA(2) = 8.0D0*ARG*A(4)*EX*Y/(A(3)*FAC)
      DYDA(3) = ARG*DYDA(2)
      DYDA(4) = (4.0D0*ARG*ARG*LOG(2.0D0)*(EX+1.0D0)/
     &          (A(4)*FAC)-LOG(FAC))*Y
C
      RETURN
      END



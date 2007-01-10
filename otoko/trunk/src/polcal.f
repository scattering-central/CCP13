C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE POLCAL (XDATA,YDATA,A,B,C,MDEG,ICH1,ICH2)
      IMPLICIT NONE
C
C Purpose: Calculates a polynomial of degree M, between selected
C          channels at points determined by abscissa data.
C
      REAL    XDATA(1),YDATA(1),A(1),B(1),C(1)
      INTEGER MDEG,ICH1,ICH2
C
C XDATA  : Abscissa data
C YDATA  : Ordinate data
C A      : Coefficients given by Harwell library routine VC01A
C B      : Coefficients given by Harwell library routine VC01A
C C      : Coefficients given by Harwell library routine VC01A
C MDEG   : Degree of the polynomial
C ICH1	 : First channel of interest
C ICH2   : Last channel of interest
C
C Calls   0:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL   W1,W2,YY
      INTEGER I,J,K
C
C W1     :
C W2     :
C YY     :
C
C----------------------------------------------------------------------- 
      DO 10 I=ICH1,ICH2
         W2=0.0
         YY=C(MDEG+1)
         DO 20 J=1,MDEG
            K=MDEG-J+1
            W1=W2
            W2=YY
            YY=C(K)+(XDATA(I)-A(K))*W2-B(K+1)*W1
20       CONTINUE
         YDATA(I)=YY
10    CONTINUE
      RETURN
      END

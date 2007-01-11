C     LAST UPDATE 06/09/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION KCOF(R,E,N)
      IMPLICIT NONE
C
C Purpose: Calculates the K coefficients for the Fourier-Bessel
C          interpolation of intensity.
C
C Calls   0:
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      REAL TOL
      PARAMETER(TOL=1.0E-06)
C
C Arguments:
C
      REAL R,E
      INTEGER N
C
C Local variables:
C
      REAL DR2
C
C External function:
C
      REAL BESSJ
      EXTERNAL BESSJ
C
C-----------------------------------------------------------------------
      IF(ABS(E-R).GT.TOL)THEN 
         DR2 = (E+R)*(E-R)
         KCOF = 2.0*E*BESSJ(2*N,R)/(DR2*BESSJ(2*N+1,E))
      ELSE
         KCOF = 1.0
      ENDIF
      RETURN
      END                  

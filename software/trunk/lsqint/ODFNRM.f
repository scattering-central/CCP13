C     LAST UPDATE 18/09/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION ODFNRM(D,S)
      IMPLICIT NONE
C
C Purpose: Evaluate the integral of the orientation distribution 
C          function multiplied by the sine of the angle for the 
C          purposes normalization. A = 1 + D, B = -D.
C
C Calls 0:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      REAL PI,SMAX,SMIN
      PARAMETER(PI=3.14159265,SMAX=100.0,SMIN=1.0)
C
C Arguments:
C
      REAL D,S
C
C Local scalars:
C
      REAL AMB,ONEMS
C 
C-----------------------------------------------------------------------
      ODFNRM = 0.0
C
C========Check S and reset if necessary
C
      IF(S.LT.SMIN)S = SMIN
      IF(S.GT.SMAX)S = SMAX
C
C========Check that the distribution is non-uniform
C
      IF(D.GT.0.0)THEN
         AMB = 1.0 + 2.0*D
C
C========Check for S > 1.0 or use alternative method
C
         IF(S.GT.1.0)THEN
            ONEMS = 1.0 - S
            ODFNRM = 2.0*PI*(AMB**ONEMS-1.0)/(D*ONEMS)
         ELSE
            ODFNRM = 2.0*PI*LOG(AMB)/D
         ENDIF
      ELSE         
         ODFNRM = 4.0*PI
      ENDIF
      RETURN
      END



C     LAST UPDATE 28/03/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION CORTAB(D,U,V)
      IMPLICIT NONE
C Purpose: CORTAB corrects intensities for oblique incidence on film, 
C          absorption by previous films and paper polarisation 
C          correction and going from energy per unit area on film to 
C          intensity in reciprocal space.
C
C Calls   0:
C Called by: ARRFIL, FILARR
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C
C Common scalars:
C
      REAL DIST,XC,YC,ROTX,ROTY,ROTZ,TILT,WAVE,XYRAT
      REAL ABSBAS,ABSEML,ABSPAP,C0,PAPN,FILN
      INTEGER NFBEFR,NPBEFR
C
C Arguments:
C
      REAL D,U,V
C
C Local Scalars:
C
      REAL COS2T,POL,SECP,TNP,CT
C
C Common blocks:
C
      COMMON /TRANSF/ DIST,XC,YC,ROTX,ROTY,ROTZ,TILT,WAVE,XYRAT
      COMMON /FILMAB/ ABSBAS,ABSEML,ABSPAP,NFBEFR,NPBEFR,C0,PAPN,FILN
C
C-----------------------------------------------------------------------
      COS2T = 1.0 - 0.5*WAVE*WAVE*D*D
      SECP = SQRT(DIST*DIST+U*U+V*V)/DIST
      IF(ABSEML.GT.0.0)THEN
         CT = (1.0-EXP(-ABSEML*SECP))*(1.0+EXP(-(ABSEML+ABSBAS)*SECP))
         TNP = C0*EXP((PAPN+FILN)*(SECP-1.0))/CT
      ELSE
         TNP = 1.0
      ENDIF
      POL = 0.5 + 0.5*COS2T
      CORTAB = SECP*SECP*SECP*TNP/POL
      RETURN
C
      END

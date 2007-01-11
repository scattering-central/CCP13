C     LAST UPDATE 29/03/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE RECIP(U,V,R,Z,D,SIGMA)
      IMPLICIT NONE
C
C Purpose: Converts from film space (U,V) to reciprocal space (R,Z)
C
C Calls   0:
C Called by: FILARR
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C
C Common arrays:
C
      REAL PHI(3,3)
C
C Common scalars:
C
      REAL DIST,XC,YC,ROTX,ROTY,ROTZ,TILT,WAVE,XYRAT
      REAL DMIN,DMAX,SIGMIN,SIGMAX,RMIN,RMAX,ZMIN,ZMAX,RBAK,ZBAK
C
C Scalar Arguments:
C
      REAL U,V,R,Z,D,SIGMA
C
C Local variables:
C
      REAL DS(3),DR(3)
      REAL DNORM,DSQ,RSQ,TEMP
      INTEGER J,K
C
C Common blocks:
C
      COMMON /ORIENT/ PHI
      COMMON /TRANSF/ DIST,XC,YC,ROTX,ROTY,ROTZ,TILT,WAVE,XYRAT
      COMMON /RLIMIT/ DMIN,DMAX,SIGMIN,SIGMAX,RMIN,RMAX,ZMIN,ZMAX,
     &                RBAK,ZBAK
C
C-----------------------------------------------------------------------
C
C========Set up detector space vector and normalize
C
      DNORM = SQRT(DIST*DIST+U*U+V*V)
      DS(1) = DIST/DNORM
      DS(2) = U/DNORM
      DS(3) = V/DNORM
C
C========Apply detector orientation matrix
C
      DO 20 J=1,3
         DR(J) = 0.0
         DO 10 K=1,3
            DR(J) = DR(J) + PHI(J,K)*DS(K)
 10      CONTINUE
 20   CONTINUE
C
C========DR(1) = cos(2theta) and DR(3) = sin(chi) from rotated vector
C
      TEMP = 1.0 - DR(1)
      IF(TEMP.LT.0.0)TEMP = 0.0
      DSQ = 2.0*TEMP/(WAVE*WAVE)
      D = SQRT(DSQ)
      Z = (SIN(TILT)*TEMP+COS(TILT)*DR(3))/WAVE
      RSQ = DSQ - Z*Z
      IF(RSQ.LT.0.0)RSQ = 0.0
      R = SQRT(RSQ)
      R = SIGN(R,U)
C
C========If averaging into positive quadrants only
C
      IF(R.LT.0.0.AND.RMIN.GE.0.0)R = -R
      IF(Z.LT.0.0.AND.ZMIN.GE.0.0)Z = -Z
C
C========Calculate SIGMA
C
      IF(D.EQ.0.0)THEN
         SIGMA = 0.0
      ELSEIF(ABS(Z/D).GT.1.0)THEN
         SIGMA = 0.0
      ELSE
         SIGMA = ATAN2(R,Z)
      ENDIF
C
      RETURN
      END

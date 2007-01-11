C     LAST UPDATE 24/02/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SQUELCH(T0,Q,Q1,Q2,IL,IR,J1,J2,DCIN,NRS,NZS,ICEN,JCEN,
     &                   DELR,DELZ,IAMIN,IAMAX,JAMIN,JAMAX,POLAR,EMAX)
      IMPLICIT NONE
C 
C Purpose: Form spread function for a single lattice point
C
C Calls  4: SETSPLODGE, TRIM, WRAPR, WRAPZ
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      REAL RLIM
      PARAMETER(RLIM=5.0)
C
C Scalar arguments:
C
      REAL T0,Q,Q1,Q2,DELR,DELZ,EMAX
      INTEGER IAMAX,IAMIN,ICEN,J1,J2,JAMAX,JAMIN,JCEN,NRS,NZS
      LOGICAL POLAR
C
C Array arguments:
C
      REAL DCIN(-NRS:NRS,-NZS:NZS)
      INTEGER IL(-NZS:NZS),IR(-NZS:NZS)
C
C Common scalars:
C
      REAL A,B,S,DL,DRL,DRS,DZS,PQ2,RCEN,RL,ZCEN,ZL,TPQ2R,PI,CONST,DZL
      REAL DSG,R1,R2,Z1,Z2,DD1,DD2
      INTEGER INFO1
C
C Local scalars:
C
      REAL PL
      INTEGER I1,I2
C
C Common blocks:
C
      COMMON /CINPAR/ A,B,S,DL,RL,DRL,ZL,RCEN,DRS,ZCEN,DZS,PQ2,TPQ2R,PI,
     &                DZL,DSG,CONST,INFO1,R1,R2,Z1,Z2,DD1,DD2
C
C-----------------------------------------------------------------------
C
C========Set up constants for profile scaling for Bragg data
C
      IF(INFO1.EQ.1)THEN
         DRL = Q + Q1*RL + Q2*RL*RL
         PQ2 = PI/(DRL*DRL)
         TPQ2R = 2.0*PQ2*RL
         CONST = Q*Q/(DRL*DRL)
         DRL = RLIM*DRL
      ENDIF
C
C========define centre of splodge in pixels
C 
      IF(POLAR)THEN
         PL = ATAN2(RL,ZL)
         ICEN = NINT(DL/DRS)
         JCEN = NINT(PL/DZS)
      ELSE
         ICEN = NINT(RL/DRS) 
         JCEN = NINT(ZL/DZS)
      ENDIF
      RCEN = FLOAT(ICEN)*DRS
      ZCEN = FLOAT(JCEN)*DZS
C
C========Set up limits for spot box
C
      R1 = MAX(0.0,RL-0.5*DRL)
      R2 = RL + 0.5*DRL
      Z1 = ZL - 0.5*DZL
      Z2 = ZL + 0.5*DZL
      DD1 = MIN(R1*R1+Z1*Z1,R1*R1+ZL*ZL)
      DD2 = R2*R2 + Z2*Z2
C
C========Form splodge for this reflection
C
      CALL SETSPLODGE(DCIN,NRS,NZS,I1,I2,ICEN,J1,J2)
C
C========Check wrapping about equator
C
      IF(ABS(ZL).LT.DZS/2.0)J1 = MAX(J1,-JCEN)
      CALL WRAPZ(DCIN,NRS,NZS,I1,I2,J1,J2,ICEN,JCEN)
C
C========Remove any insignificant pixels
C
      CALL TRIM(DCIN,NRS,NZS,I1,I2,J1,J2,IL,IR,IAMIN-ICEN,IAMAX-ICEN,
     &          JAMIN-JCEN,JAMAX-JCEN,EMAX)
      RETURN
C
      END

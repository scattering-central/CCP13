C     LAST UPDATE 31/03/98
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE REPROF(PR,PINC,MINFO,NLAT,ITMAX,FTOL,RFAC)
      IMPLICIT NONE
C
C Purpose: Refines profile and cell parameters after LSQINT has
C          fitted some intensities using Brent's PRAXIS method.
C
C Calls   0:
C Called by: LSQINT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER MAXALL,MAXLAT
      PARAMETER(MAXALL=50,MAXLAT=3)
C
C Scalar arguments:
C
      REAL RFAC,FTOL
      INTEGER ITMAX,NLAT
C
C Array arguments:
C
      REAL PR(MAXALL),PINC(MAXALL)
      INTEGER MINFO(5,MAXLAT)
C
C Local arrays:
C
      REAL X(MAXALL)
C
C Local scalars:
C
      REAL ATOL,MACHEP,STEP
      INTEGER I,NPPAR,IREF,NL,NP,IFLAG,M
C
C Common scalars:
C
      INTEGER NALLP
C
C Common arrays:
C
      REAL ALLPAR(MAXALL),SCALEX(MAXALL)
      INTEGER IRFFLG(MAXALL)
C
C Common block:
C
      COMMON /REFINE/ ALLPAR,SCALEX,IRFFLG,NALLP
C
C External function:
C
      REAL FLWRAP,PRAXIS
      EXTERNAL FLWRAP,PRAXIS
C
C Data:
C
      DATA ATOL /1.0E-05/, MACHEP /1.0E-07/
C
C-----------------------------------------------------------------------
C
C========Say hello, etc
C
      WRITE(6,1000)
      WRITE(4,1000)
      NP = 0
      M = 0
      DO 20 NL=1,NLAT
C
C========The number of parameters for continuous/bragg lattice
C
         IF(MINFO(1,NL).EQ.0)THEN
            NPPAR = 4
         ELSE
            NPPAR = 14
         ENDIF
C
C========Flag parameters to refine and scale on user supplied shifts
C
         IREF = 0
         NALLP = 0
         DO 10 I=NP+1,NP+NPPAR
            NALLP = NALLP + 1
            ALLPAR(I) = PR(I)
            IF(PINC(I).NE.0.0)THEN
               M = M + 1
               IREF = IREF + 1
               IRFFLG(I) = 1
               SCALEX(M) = 1.0/PINC(I)
               X(M) = SCALEX(M)*PR(I)
            ELSE
               IRFFLG(I) = 0
            ENDIF
 10      CONTINUE
         STEP = SQRT(FLOAT(M))
C
C========Report parameters and shifts for this lattice
C
         WRITE(6,1010)NL
         WRITE(4,1010)NL
         WRITE(6,1020)NPPAR,IREF
         WRITE(4,1020)NPPAR,IREF
         WRITE(6,1030)(PR(I),I=NP+1,NP+NPPAR)
         WRITE(4,1030)(PR(I),I=NP+1,NP+NPPAR)
         WRITE(6,1040)(PINC(I),I=NP+1,NP+NPPAR)
         WRITE(4,1040)(PINC(I),I=NP+1,NP+NPPAR)
         NP = NP + NPPAR
 20   CONTINUE
C
C========Minimize with Brent's Praxis method
C
      RFAC = PRAXIS(ATOL,MACHEP,STEP,M,1,X,FLWRAP,0.0,ITMAX,IFLAG)
C
C========Indicate whether or not convergence has been achieved
C
      IF(IFLAG.EQ.0)THEN
         WRITE(6,1050)
         WRITE(4,1050)
      ELSE
         WRITE(6,1060)
         WRITE(4,1060)
      ENDIF
C
C========Report R-factor
C
      WRITE(6,1070)RFAC
      WRITE(4,1070)RFAC
C
C========Re-calculate profiles at minimum
C
      WRITE(6,1080)
      WRITE(4,1080)
      RFAC = FLWRAP(X,M)
C
C========Copy best parameters back to PR
C
      DO 30 I=1,NALLP
         PR(I) = ALLPAR(I)
 30   CONTINUE
      RETURN
C
 1000 FORMAT(/1X,'Starting Parameter refinement...'/)
 1010 FORMAT(1X,'Lattice ',I1)
 1020 FORMAT(/1X,'Parameter refinement for',I3,'  parameters'
     &       /1X,I3,'  parameters have non-zero shifts')
 1030 FORMAT(/1X,'Vector ',14F8.5)
 1040 FORMAT(1X,'Shifts ',14F8.5/)
 1050 FORMAT(/1X,'Maximum number of iterations for parameter',
     &       1X,'refinement - no convergence')
 1060 FORMAT(/1X,'Parameter refinement has converged')
 1070 FORMAT(/1X,'R-factor from parameter refinement = ',G12.4)
 1080 FORMAT(/1X,'Re-calculating profiles at minimum...')
      END

C     LAST UPDATE 27/03/98
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION FLWRAP(X,N)
      IMPLICIT NONE
C
C Purpose: Wrapper for FALL to arrange refined parameters into the
C          whole parameter set and scale them
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C
C Parameter:
C
      INTEGER MAXALL
      PARAMETER(MAXALL=50)
C
C Scalar arguments:
C     
      INTEGER N
C
C Array arguments:
C
      REAL X(N)
C
C Common scalars:
C
      INTEGER NALLP
C
C Common arrays:
C
      REAL ALLPAR(MAXALL),SCALEX(MAXALL)
      INTEGER IRFFLG(MAXALL)
C
C Common block:
C
      COMMON /REFINE/ ALLPAR,SCALEX,IRFFLG,NALLP
C
C Local scalars:
C
      INTEGER I,M
C
C External function:
C
      REAL FALL
C
C-----------------------------------------------------------------------
C
      M = 0
      DO 10 I=1,NALLP
         IF(IRFFLG(I).GT.0)THEN
            M = M + 1
            IF(M.GT.N)THEN
               WRITE(6,1000)M,N
               WRITE(4,1000)M,N
               STOP
            ENDIF
            ALLPAR(I) = X(M)/SCALEX(M)
         ENDIF
 10   CONTINUE
      FLWRAP = FALL(ALLPAR)
      RETURN
C
 1000 FORMAT(1X,'FLWRAP: number of refined parameters',I3,
     &       1X,'does not match argument',I3)
      END

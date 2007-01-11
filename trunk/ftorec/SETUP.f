C     LAST UPDATE 28/03/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SETUP
      IMPLICIT NONE
C
C Purpose: Puts angles in radians and works out detector orientation
C
C Calls   2: ARSET , AISET
C Called by: FTOREC
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C
C Common arrays:
C
      REAL RDAT(2500*2500),RECSPA(1250*1250),STDEV(1250*1250),PHI(3,3)
      INTEGER NPOINT(1250*1250)
C
C Common scalars:
C
      REAL DIST,XC,YC,ROTX,ROTY,ROTZ,TILT,WAVE,XYRAT
      REAL DMIN,DMAX,SIGMIN,SIGMAX,RMIN,RMAX,ZMIN,ZMAX,RBAK,ZBAK
      REAL DELR,DELZ,DELSIG,DELD      
      REAL ABSBAS,ABSEML,ABSPAP,C0,PAPN,FILN
      INTEGER NFBEFR,NPBEFR
      INTEGER NXMIN,NXMAX,NYMIN,NYMAX,NRD,NZSIG
C
C Local variables:
C
      REAL CRX,SRX,CRY,SRY,CRZ,SRZ
C
C Common blocks:
C
      COMMON /ARRAYS/ RDAT,RECSPA,STDEV,NPOINT
      COMMON /ORIENT/ PHI
      COMMON /TRANSF/ DIST,XC,YC,ROTX,ROTY,ROTZ,TILT,WAVE,XYRAT
      COMMON /RLIMIT/ DMIN,DMAX,SIGMIN,SIGMAX,RMIN,RMAX,ZMIN,ZMAX,
     &                RBAK,ZBAK
      COMMON /DELTAS/ DELR,DELZ,DELSIG,DELD
      COMMON /FILMAB/ ABSBAS,ABSEML,ABSPAP,NFBEFR,NPBEFR,C0,PAPN,FILN
      COMMON /ILIMIT/ NXMIN,NXMAX,NYMIN,NYMAX,NRD,NZSIG
C
C-----------------------------------------------------------------------
C   
C========Make tilt have same sign as for GUCKMAL.
C
      TILT = -TILT/57.296
C
      ROTX = ROTX/57.296
      ROTY = ROTY/57.296
      ROTZ = ROTZ/57.296
      SIGMIN = SIGMIN/57.296
      SIGMAX = SIGMAX/57.296
      DELSIG = DELSIG/57.296
      RMAX = FLOAT(NRD-1)*DELR + RMIN
      ZMAX = FLOAT(NZSIG-1)*DELZ + ZMIN
C
      NYMIN = NYMIN + 1
      NXMIN = NXMIN + 1
      NYMAX = NYMAX + 1
      NXMAX = NXMAX + 1
      CALL ARSET(RECSPA,1250*1250,0.0)
      CALL ARSET(STDEV,1250*1250,0.0)
      CALL AISET(NPOINT,1250*1250,0)
C
C========Set up film absorption coefficients
C
      C0 = (1.0-EXP(-ABSEML))*(1.0+EXP(-ABSEML-ABSBAS))
      PAPN = FLOAT(NPBEFR)*ABSPAP
      FILN = FLOAT(NFBEFR)*(2.0*ABSEML+ABSBAS)
C
C========Form sines and cosines of detector rotation angles
C
      CRX = COS(ROTX)
      SRX = SIN(ROTX)
      CRY = COS(ROTY)
      SRY = SIN(ROTY)
      CRZ = COS(ROTZ)
      SRZ = SIN(ROTZ)
C
C========Form detector rotation matrix RzRyRx
C
      PHI(1,1) = CRZ*CRY
      PHI(1,2) = CRZ*SRY*SRX + SRZ*CRX
      PHI(1,3) = -CRZ*SRY*CRX + SRZ*SRX
      PHI(2,1) = -SRZ*CRY
      PHI(2,2) = -SRZ*SRY*SRX + CRZ*CRX
      PHI(2,3) = SRZ*SRY*CRX + CRZ*SRX
      PHI(3,1) = SRY
      PHI(3,2) = -CRY*SRX
      PHI(3,3) = CRY*CRX
C
      RETURN
      END

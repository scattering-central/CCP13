C     Last update 16/05/96
C-----------------------------------------------------------------------
      SUBROUTINE REPORT(MINFO,PR,NLAT)
      IMPLICIT NONE
C
C Purpose: Report final values of cell and profile parameters after
C          a cycle of refinement 
C
C Calls 1: RECCEL 
C Called by: LSQINT
C-----------------------------------------------------------------------
C Parameters:
C
      INTEGER MAXALL,MAXLAT
      PARAMETER(MAXALL=50,MAXLAT=3)
C
C Array arguments:
C
      REAL PR(MAXALL)
      INTEGER MINFO(5,MAXLAT)
C
C Scalar arguments:
C
      INTEGER NLAT
C
C Local arrays:
C
      REAL CELL(6),RCELL(6)
C 
C Local variables:
C
      REAL AWID,RTOD 
      INTEGER I,NL,NP
C-----------------------------------------------------------------------
C
      RTOD = 45.0/ATAN(1.0)
      WRITE(6,1000)
      WRITE(4,1000)
      NP = 0
      DO 20 NL=1,NLAT
         WRITE(6,1005)NL
         WRITE(4,1005)NL
         AWID = PR(NP+2)*RTOD 
         IF(MINFO(1,NL).EQ.0)THEN 
C     
C========Continuous layerlines - only 4 parameters
C
            CELL(3) = 1.0/PR(NP+1)
            WRITE(6,1010)CELL(3),AWID,PR(NP+3),PR(NP+4)
            WRITE(4,1010)CELL(3),AWID,PR(NP+3),PR(NP+4)
            NP = NP + 4
         ELSE
C     
C========Bragg sampling - up to 14 parameters
C     
            IF(MINFO(2,NL).LE.2)THEN
C
C========Trigonal or tetragonal cell
C 
               RCELL(1) = PR(NP+5)
               RCELL(2) = PR(NP+5)
            ELSE
C     
C========Orthorhombic, monoclinic or triclinic cell
C 
               RCELL(1) = PR(NP+5)
               RCELL(2) = PR(NP+9)
            ENDIF
            RCELL(3) = PR(NP+1)
            RCELL(4) = PR(NP+10)
            RCELL(5) = PR(NP+11)
            RCELL(6) = PR(NP+12)
            CALL RECCEL(RCELL,CELL)
            DO 10 I=4,6 
               CELL(I) = CELL(I)*RTOD 
 10         CONTINUE
            WRITE(6,1020)(CELL(I),I=1,6),AWID,PR(NP+3),PR(NP+4),
     &                   PR(NP+6),PR(NP+7),PR(NP+8),
     &                   PR(NP+13)*RTOD,PR(NP+14)*RTOD 
            WRITE(4,1020)(CELL(I),I=1,6),AWID,PR(NP+3),PR(NP+4),
     &                   PR(NP+6),PR(NP+7),PR(NP+8),
     &                   PR(NP+13)*RTOD,PR(NP+14)*RTOD 
            NP = NP + 14
         ENDIF
 20   CONTINUE
      RETURN 
C-----------------------------------------------------------------------
C
 1000 FORMAT(/1X,'Refined parameters:')
 1005 FORMAT(1X,'Lattice ',I1)
 1010 FORMAT(1X,'  c',F12.4/
     &       1X,'  Angular width ',F8.4,5X,'  shape ',F8.4/
     &       1X,'  Z width       ',F8.6)
 1020 FORMAT(1X,'  a',F12.4,'  b',F12.4,'  c',F12.4/
     &       1X,'  alpha',F8.2,'  beta ',F8.2,'  gamma',F8.2/
     &       1X,'  Angular width ',F8.4,5X,'  shape ',F8.4/
     &       1X,'  Z width       ',F8.6/
     &       1X,'  R0 ',F8.6,'  R1 ',F8.6,'  R2 ',F8.6/
     &       1X,'  Phi_Z ',F6.2,'  Phi_X ',F6.2) 
      END

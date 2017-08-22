C     LAST UPDATE 14/02/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FTOSTD
      IMPLICIT NONE
C
C Purpose: Converts coordinates from filespace to centred, rotated
C          (standard) coordinates. 
C
C Calls   0:
C Called by: ROTATE 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file:
C
      INCLUDE 'FIXPAR.COM'
C
C Local variables:
C
      REAL D(3),DR(3),PHI(3,3)
      REAL CRX,SRX,CRY,SRY,CRZ,SRZ
      INTEGER I,J,K
C
C-----------------------------------------------------------------------
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
C========Apply matrix to each point in the buffer
C
      DO 30 I=1,NPTS
         D(1) = SDD
         D(2) = FXY(1,I) - XC
         D(3) = FXY(2,I) - YC
         DO 20 J=1,3
            DR(J) = 0.0
            DO 10 K=1,3
               DR(J) = DR(J) + PHI(J,K)*D(K)
 10         CONTINUE
 20      CONTINUE
C
C========Scale coordinates to be on a plane passing through (SDD,0,0)
C
         IF(DR(1).GT.0.0)THEN
            SXY(1,I) = DR(2)*SDD/DR(1)
            SXY(2,I) = DR(3)*SDD/DR(1)
         ENDIF
 30   CONTINUE
C
C========Calculate centre beam position in detector space
C
      XCB = PHI(1,2)*SDD/PHI(1,1) + XC
      YCB = PHI(1,3)*SDD/PHI(1,1) + YC
      RETURN
C
      END                  

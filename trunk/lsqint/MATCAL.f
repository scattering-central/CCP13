C     LAST UPDATE 03/03/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE MATCAL(ICSTPZ,PHIZ,PHIX,RCELL,AMAT)
      IMPLICIT NONE
C
C Purpose: Calculates a matrix AMAT = PHI.A where PHI is the orientation 
C          matrix, defined by PHIZ and PHIX,  with respect to one of two 
C          standard settings, and A is the matrix corresponding to the 
C          components of the reciprocal cell vectors in one of the
C          standard orientations. The standard orientations are: 
C          c parallel to Z and a* parallel to X (ICSTPZ=0) or
C          c* parallel to Z and a* perpendicular to Y (ICSTPZ=1). 
C          
C
C Calls   0:
C Called by: DRAGON, FBRAG, BRGOUT 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Arguments:
C
      INTEGER ICSTPZ
      REAL RCELL(6),AMAT(3,3)
      REAL PHIZ,PHIX 
C
C Local variables:
C
      INTEGER I,J,K 
      REAL SA,CA,SB,CB,SG,CG,SPZ,CPZ,SPX,CPX 
      REAL A(3,3),PHI(3,3)
C
C-----------------------------------------------------------------------
C
C========Set up sin and cos of reciprocal cell angles
C
      SA = SIN(RCELL(4))
      CA = COS(RCELL(4))
      SB = SIN(RCELL(5))
      CB = COS(RCELL(5))
      SG = SIN(RCELL(6))
      CG = COS(RCELL(6))
C
C========Set up A matrix
C
      IF(ICSTPZ.EQ.0)THEN
         A(1,1) = RCELL(1) 
         A(1,2) = RCELL(2)*CG
         A(1,3) = RCELL(3)*CB
         A(2,1) = 0.0
         A(2,2) = RCELL(2)*SG 
         A(2,3) = RCELL(3)*(CA-CB*CG)/SG 
         A(3,1) = 0.0
         A(3,2) = 0.0
         A(3,3) = SQRT(RCELL(3)**2-A(1,3)**2-A(2,3)**2)
      ELSE
         A(1,1) = RCELL(1)*SB
         A(1,2) = RCELL(2)*(CG-CA*CB)/SB
         A(1,3) = 0.0
         A(2,1) = 0.0
         A(2,3) = 0.0
         A(3,1) = RCELL(1)*CB
         A(3,2) = RCELL(2)*CA 
         A(2,2) = SQRT(RCELL(2)**2-A(1,2)**2-A(3,2)**2)
         A(3,3) = RCELL(3)
      ENDIF
C
C========Set up sin and cos of orientation angles  
C
      SPZ = SIN(PHIZ)
      CPZ = COS(PHIZ)
      SPX = SIN(PHIX)
      CPX = COS(PHIX)
C
C========Set up PHI
C 
      PHI(1,1) = CPZ
      PHI(1,2) = -SPZ
      PHI(1,3) = 0.0
      PHI(2,1) = CPX*SPZ
      PHI(2,2) = CPX*CPZ
      PHI(2,3) = -SPX
      PHI(3,1) = SPX*SPZ
      PHI(3,2) = SPX*CPZ
      PHI(3,3) = CPX
C
C========Calculate PHI.A
C
      DO 30 I=1,3
         DO 20 J=1,3
            AMAT(I,J) = 0.0
            DO 10 K=1,3
               AMAT(I,J) = AMAT(I,J) + PHI(I,K)*A(K,J) 
 10         CONTINUE
 20      CONTINUE
 30   CONTINUE
      RETURN 
C
      END                  

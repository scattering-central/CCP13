      REAL FUNCTION BESSJ(N,X)
      IMPLICIT NONE
C----------------------------------------------------------------------
C Purpose: Calculates Jn(X) 
C
C Parameters:
C
      INTEGER IACC
      PARAMETER(IACC=40)
      REAL BIGNO,BIGNI
      PARAMETER(BIGNO=1.0E+10,BIGNI=1.0E-10)
C
C Arguments:
C
      INTEGER N
      REAL X
C
C Local variables:
C
      REAL AX,TOX,BJM,BJ,BJP,SUM
      INTEGER J,JSUM,M,NN
C
C External functions:
C
      REAL BESSJ0,BESSJ1
      EXTERNAL BESSJ0,BESSJ1
C----------------------------------------------------------------------
      NN = ABS(N)
      IF(N.EQ.0)THEN
         BESSJ = BESSJ0(X)
      ELSEIF(NN.EQ.1)THEN
         BESSJ = BESSJ1(X)
      ELSE
         AX = ABS(X)
         IF(AX.EQ.0.0)THEN
            BESSJ = 0.0
         ELSEIF(AX.GT.FLOAT(NN))THEN
            TOX = 2.0/AX
            BJM = BESSJ0(AX)
            BJ = BESSJ1(AX)
            DO 10 J=1,NN-1
               BJP = FLOAT(J)*TOX*BJ - BJM
               BJM = BJ
               BJ = BJP
 10         CONTINUE
            BESSJ = BJ
         ELSE
            TOX = 2.0/AX
            M = 2*((NN+INT(SQRT(FLOAT(IACC*NN))))/2)
            BESSJ = 0.0
            JSUM = 0
            SUM = 0.0
            BJP =  0.0
            BJ = 1.0
            DO 20 J=M,1,-1
               BJM = FLOAT(J)*TOX*BJ - BJP
               BJP = BJ
               BJ = BJM
               IF(ABS(BJ).GT.BIGNO)THEN
                  BJ = BJ*BIGNI
                  BJP = BJP*BIGNI
                  BESSJ = BESSJ*BIGNI
                  SUM = SUM*BIGNI
               ENDIF
               IF(JSUM.NE.0)SUM = SUM + BJ
               JSUM = 1 - JSUM
               IF(J.EQ.NN)BESSJ = BJP
 20         CONTINUE
            SUM = 2.0*SUM - BJ
            BESSJ = BESSJ/SUM
         ENDIF
      ENDIF
      IF(MOD(NN,2).EQ.1)THEN
         IF(FLOAT(N)*X.LT.0.0)BESSJ = -BESSJ
      ENDIF
      RETURN
      END

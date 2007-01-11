C     LAST UPDATE 17/07/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE MNBRAK2(AX,BX,CX,FA,FB,FC,FUNC)
      IMPLICIT NONE
C
C Purpose: Given a function FUNC, and given distinct initial points AX
C          and BX, this routine searches in the downhill direction
C          (defined by the function as evaluated at the initial points)
C          and returns new points AX,BX,CX which bracket a minimum of
C          the function. Also returned are the function values at the
C          three points FA,FB,FC  
C
C Calls   0:
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      REAL GOLD,GLIMIT,TINY
      PARAMETER(GOLD=1.618034, GLIMIT=100.0, TINY=1.0E-20)
C
C Arguments:
C
      REAL AX,BX,CX,FA,FB,FC
      REAL FUNC
      EXTERNAL FUNC
C
C External function:
C
      REAL F1DIM
      EXTERNAL F1DIM
C 
C Local variables:
C
      REAL DUM,R,Q,U,ULIM,FU  
C
C-----------------------------------------------------------------------
      FA = F1DIM(AX,FUNC)
      FB = F1DIM(BX,FUNC)
      IF(FB.GT.FA)THEN
         DUM = AX
         AX = BX
         BX = DUM
         DUM = FB
         FB = FA
         FA = DUM
      ENDIF
      CX = BX + GOLD*(BX-AX)
      FC = F1DIM(CX,FUNC)
 1    IF(FB.GE.FC)THEN
         R = (BX-AX)*(FB-FC)
         Q = (BX-CX)*(FB-FA)
         U = BX -((BX-CX)*Q-(BX-AX)*R)/
     &            2.0*SIGN(MAX(ABS(Q-R),TINY),Q-R)
         ULIM = BX + GLIMIT*(CX-BX)
         IF((BX-U)*(U-CX).GT.0.0)THEN
            FU = F1DIM(U,FUNC)
            IF(FU.LT.FC)THEN 
               AX = BX
               FA = FB
               BX = U
               FB = FU
               RETURN
            ELSEIF(FU.GT.FB)THEN
               CX = U
               FC = FU
               RETURN
            ENDIF
            U = CX + GOLD*(CX-BX)
            FU = F1DIM(U,FUNC)
         ELSEIF((CX-U)*(U-ULIM).GT.0.0)THEN
            FU = F1DIM(U,FUNC)
            IF(FU.LT.FC)THEN
            BX = CX
            CX = U
            U = CX + GOLD*(CX-BX)
            FB = FC
            FC = FU
            FU = F1DIM(U,FUNC)
         ENDIF
         ELSEIF((U-ULIM)*(ULIM-CX).GE.0.0)THEN
            U = ULIM
            FU = F1DIM(U,FUNC)
         ELSE
            U = CX + GOLD*(CX-BX)
            FU = F1DIM(U,FUNC)
         ENDIF
         AX = BX
         BX = CX
         CX = U
         FA = FB
         FB = FC
         FC = FU
         GOTO 1
      ENDIF
      RETURN  
C
      END                  

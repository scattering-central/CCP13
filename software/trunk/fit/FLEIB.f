C     LAST UPDATE 04/03/97
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FLEIB(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: This subroutine calculates the LIEBLER DIBLOCK COPOLYMER
C          L.LEIBLER, Macromolecule 13(1980)1602-1617 eqns IV-2 to IV-8
C          R.K.Heenan 13/1/97
C          Modified for FIT 17/02/97 by RCD.
C          Q=X, DIBLK=Y, 
C          A(1)=I0, A(2)=Q0, A(3)=LL, A(4)=RN, A(5)=F, A(6)=CHI
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameter:
C
      DOUBLE PRECISION TINY
      PARAMETER (TINY=1.0D-40)
C
C Arguments:
C
      DOUBLE PRECISION A(10),DYDA(10)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      DOUBLE PRECISION TA(3),DYDA1(3),DYDA2(3),DYDA3(3)
      DOUBLE PRECISION RG1,RG2,RG3,F1,F2,F3,F,FM,DEN1,DEN2,DIBLK,
     &                 DD2DF1,DD2DF2,DD2DF3,DD1DF1,DD1DF2,DD1DF3,DD2DN
C
C-----------------------------------------------------------------------
C
C========Check parameters
C
      IF(A(3).LT.TINY)A(3) = TINY
      IF(A(4).LT.1.0D0)A(4) = 1.0D0
      IF(A(5).LT.TINY)A(5) = TINY
      IF(A(5).GT.1.0D0-TINY)A(5) = 1.0D0 - TINY
      IF(A(6).LT.0.0D0)A(6) = 0.0D0
C
C========Calculate Rg's and Debye functions
C
      RG1 = A(3)*SQRT(A(4)/6.0D0)
      TA(1) = 1.0D0
      TA(2) = A(2)
      TA(3) = 1.0D0/RG1
      CALL FDEBYE(X,TA,F1,DYDA1)
      F = A(5)
      RG2 = RG1*SQRT(F)
      TA(1) = F*F
      TA(3) = 1.0D0/RG2
      CALL FDEBYE(X,TA,F2,DYDA2)
      FM = 1.0D0 - F
      RG3 = RG1*SQRT(FM)
      TA(1) = FM*FM
      TA(3) = 1.0D0/RG3
      CALL FDEBYE(X,TA,F3,DYDA3)
      DEN1 = F2*F3 - 0.25D0*(F1 - F2 - F3)**2
      IF(ABS(DEN1).LT.TINY)DEN1 = SIGN(TINY,DEN1)
      DEN2 = F1/DEN1 - 2.0D0*A(4)*A(6)
      IF(ABS(DEN2).LT.TINY)DEN2 = SIGN(TINY,DEN2)
      DIBLK = A(4)/DEN2
      Y = A(1)*DIBLK
C
C========Calculate partial derivatives
C
      DD1DF1 = -0.5D0*(F1 - F2 - F3)
      DD1DF2 = 0.5D0*(F1 - F2 + F3)
      DD1DF3 = 0.5D0*(F1 + F2 - F3)
      DD2DF1 = (DEN1 - F1*DD1DF1)/(DEN1*DEN1)
      DD2DF2 = -DD1DF2*F1/(DEN1*DEN1)
      DD2DF3 = -DD1DF3*F1/(DEN1*DEN1)
      DYDA(1) = DIBLK
      DYDA(2) = -Y/DEN2*
     &          (DD2DF1*DYDA1(2)+DD2DF2*DYDA2(2)+DD2DF3*DYDA3(2))
      DYDA(3) = Y/DEN2*
     &          (DD2DF1*DYDA1(3)/(RG1*A(3)) +
     &           DD2DF2*DYDA2(3)/(RG2*A(3)) +
     &           DD2DF3*DYDA3(3)/(RG3*A(3)))
      DD2DN = -0.5D0*(DYDA1(3)*DD2DF1/(RG1*A(4)) +
     &                DYDA2(3)*DD2DF2/(RG2*A(4)) +
     &                DYDA3(3)*DD2DF3/(RG3*A(4))) - 
     &        2.0D0*A(6)
      DYDA(4) = A(1)*(DEN2 - A(4)*DD2DN)/(DEN2*DEN2)
      DYDA(5) = -Y/DEN2*
     &          (DD2DF2*(DYDA2(1)*2.0D0*F  - 
     &                   DYDA2(3)/(2.0D0*RG2*F )) -
     &           DD2DF3*(DYDA3(1)*2.0D0*FM - 
     &                   DYDA3(3)/(2.0D0*RG3*FM)))
      DYDA(6) = 2.0D0*A(4)*Y/DEN2
      RETURN
      END





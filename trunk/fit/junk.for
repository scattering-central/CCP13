C     LAST UPDATE 29/09/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FDEBYE(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is the Debye approximation to the intensity transform 
C          for chain molecules. 
C          of A: A(1) = I(0),  A(2) = Origin,  A(3) = 1/Rg
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY
      PARAMETER(TINY=1.0D-10)
C
C Arguments:
C
      DOUBLE PRECISION A(*),DYDA(*)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      DOUBLE PRECISION ARG,ARG2,ARG4,EX,FAC,DARG
C
C-----------------------------------------------------------------------
      IF(A(3).LT.TINY)A(3) = TINY
      ARG = (X-A(2))/A(3)
      ARG2 = ARG*ARG
      IF(ARG2.LT.TINY)THEN
         Y = A(1)
         DYDA(1) = 1.0D0
         DYDA(2) = 0.0D0
         DYDA(3) = 0.0D0
      ELSE
         ARG4 = ARG2*ARG2
         EX = EXP(-ARG2)
         FAC = 2.0D0*(EX-1.0D0+ARG2)
         Y = A(1)*FAC/ARG4
         DYDA(1) = FAC/ARG4
         DARG = 2.0D0*A(1)*((2.0D0/ARG2)*(1.0D0-EX)-EX-1.0D0)/ARG4
         DYDA(2) = -2.0D0*ARG*DARG/A(3)
         DYDA(3) = -2.0D0*ARG2*DARG/A(3)
      ENDIF
C
      RETURN
      END


C     LAST UPDATE 18/03/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FDEXP(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is double exponential. The amplitude. centre and widths
C          of the double exponential are stored in consecutive locations 
C          of A: 
C          A(1) = B,  A(2) = E,  A(3) = G1, A(4) = G2
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY
      PARAMETER(TINY=1.0D-10)
C
C Arguments:
C
      DOUBLE PRECISION A(10),DYDA(10)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      DOUBLE PRECISION  ARG1,ARG2,EX1,EX2,FAC
C
C-----------------------------------------------------------------------
      IF(A(3).LT.TINY)A(3) = TINY
      IF(A(4).LT.TINY)A(4) = TINY
      ARG1 = (X-A(2))/A(3)
      ARG2 = (X-A(2))/A(4)
      EX1 = EXP(-ARG1)
      EX2 = EXP(ARG2)
      FAC = EX1 + EX2
      Y = 2.0D0*A(1)/FAC
      DYDA(1) = 2.0D0/FAC
      DYDA(2) = Y*(EX2/A(4)-EX1/A(3))/FAC
      DYDA(3) = -Y*ARG1*EX1/(FAC*A(3))
      DYDA(4) = Y*ARG2*EX2/(FAC*A(4))
C
      RETURN
      END


C     LAST UPDATE 22/03/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FGAUSS(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is Gaussian. The amplitude. centre
C          and width of the Gaussian are stored in consecutive locations
C          of A: A(1) = H,  A(2) = P,  A(3) = FWHM
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY,FACTOR
      PARAMETER(TINY=1.0D-10,FACTOR=1.66510922231D0)
C
C Arguments:
C
      DOUBLE PRECISION A(10),DYDA(10)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      DOUBLE PRECISION  ARG,EX,FAC,W
C
C-----------------------------------------------------------------------
      IF(A(3).LT.TINY)A(3) = TINY
      W = A(3)/FACTOR
      ARG = (X-A(2))/W
      EX = EXP(-ARG*ARG)
      FAC = A(1)*EX*2.0D0*ARG
      Y = A(1)*EX
      DYDA(1) = EX
      DYDA(2) = FAC/W
      DYDA(3) = FACTOR*FAC*ARG/W
C
      RETURN
      END


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
      TA(3) = 1.0D0/(RG3)
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




C     LAST UPDATE 30/03/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FLORENTZ(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is Lorentzian. The amplitude. centre and width of the
C           Lorentzian are stored in consecutive locations of A: 
C           A(1) = H,  A(2) = P,  A(3) = FWHM
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY
      PARAMETER(TINY=1.0D-10)
C
C Arguments:
C
      DOUBLE PRECISION A(10),DYDA(10)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      DOUBLE PRECISION  ARG,EX,FAC,W
C
C-----------------------------------------------------------------------
      IF(A(3).LT.TINY)A(3) = TINY
      W = A(3)/2.0D0
      ARG = (X-A(2))/W
      FAC = (1.0D0+ARG*ARG)
      Y = A(1)/FAC
      EX = 2.0D0*ARG*A(1)/(FAC*FAC)
      DYDA(1) = 1.0D0/FAC
      DYDA(2) = EX/W
      DYDA(3) = 2.0D0*ARG*EX/W
C
      RETURN
      END


C     LAST UPDATE 20/12/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FPEARSON(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is Pearson VII. The amplitude. centre and widths of 
C          the Pearson VII are stored in consecutive locations of A: 
C          A(1) = H,  A(2) = P,  A(3) = FWHM, A(4) = S
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY,HALF,BIG
      PARAMETER(TINY=1.0D-10,HALF=0.5D0,BIG=1.0D03)
C
C Arguments:
C
      DOUBLE PRECISION A(10),DYDA(10)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      DOUBLE PRECISION  ARG,EX,FAC
C
C-----------------------------------------------------------------------
      IF(A(3).LT.TINY)A(3) = TINY
      IF(A(4).LT.HALF)A(4) = HALF
      IF(A(4).GT.BIG)A(4) = BIG
      ARG = (X-A(2))/A(3)
      EX = 2.0D0**(1.0D0/A(4)) - 1.0D0
      FAC = (1.0D0+4.0D0*ARG*ARG*EX)
      Y = A(1)/FAC**A(4)
      DYDA(1) = 1.0D0/FAC**A(4)
      DYDA(2) = 8.0D0*ARG*A(4)*EX*Y/(A(3)*FAC)
      DYDA(3) = ARG*DYDA(2)
      DYDA(4) = (4.0D0*ARG*ARG*LOG(2.0D0)*(EX+1.0D0)/
     &          (A(4)*FAC)-LOG(FAC))*Y
C
      RETURN
      END


C     LAST UPDATE 29/03/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FPOLY(X,A,Y,DYDA,NA)
      IMPLICIT NONE
C
C Purpose: Calculates function and derivatives for polynomial
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Arguments:
C
      INTEGER NA 
      DOUBLE PRECISION A(NA+1),DYDA(NA+1)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      INTEGER I,J
      DOUBLE PRECISION TEMP
C
C-----------------------------------------------------------------------
      Y = 0.0D0 
      TEMP = 1.0D0
      J = NA + 1
      DO 10 I=1,NA+1
         Y = Y*X + A(I)
         DYDA(J) = TEMP
         TEMP = TEMP*X
         J = J - 1 
 10   CONTINUE
C
      RETURN
      END
C     LAST UPDATE 04/03/97
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FUNCS(X,A,Y,DYDA,NA)
      IMPLICIT NONE
C
C Purpose: Calls specific functions for curve fitting
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Include file:
C
      INCLUDE 'FIT.COM'
C
C Arguments:
C
      INTEGER NA
      DOUBLE PRECISION A(MAXPAR),DYDA(MAXPAR)
      DOUBLE PRECISION X,Y  
C
C Common block:
C
      INTEGER NPEAKS,NBAK,FEXP,NSELPK,KORIG
      LOGICAL LATCON
      INTEGER FTYPE(20),VTABLE(MAXPAR),FTABLE(MAXPAR),LTABLE(MAXPAR)
      DOUBLE PRECISION XORIG
      DOUBLE PRECISION X1CON(MAXPAR),X2CON(MAXPAR),X3CON(MAXPAR)
      DOUBLE PRECISION X1LIM(MAXPAR),X2LIM(MAXPAR)
      COMMON /FCOM  /NPEAKS,NBAK,FEXP,FTYPE,VTABLE,NSELPK
      COMMON /FCOM1 /X1CON,X2CON,X3CON,FTABLE
      COMMON /FCOM2 /XORIG,KORIG,LATCON
      COMMON /FCOM3 /X1LIM,X2LIM,LTABLE
C
C Local variables:
C
      INTEGER I,J,K,NPPAR
      DOUBLE PRECISION  AP(10),DP(10),YP,EX,ARG,DTMP
C
C External functions:
C
      DOUBLE PRECISION FCONST,DFCONST
      EXTERNAL FCONST,DFCONST
C
C-----------------------------------------------------------------------
      K = 0
      Y=0.0D0
      DO 5 I=1,MIN(NA+NBAK+FEXP+1,MAXPAR)
         DYDA(I) = 0.0D0
 5    CONTINUE
      IF(LATCON)THEN
         XORIG = A(KORIG)
         DYDA(KORIG) = 0.0D0
      ENDIF
      DO 30 I=1,NPEAKS
         IF(FTYPE(I).EQ.1)THEN
            NPPAR = 3
         ELSEIF(FTYPE(I).EQ.2)THEN
            NPPAR = 3
         ELSEIF(FTYPE(I).EQ.3)THEN
            NPPAR = 4
         ELSEIF(FTYPE(I).EQ.4)THEN
            NPPAR = 4
         ELSEIF(FTYPE(I).EQ.5)THEN
            NPPAR = 3
         ELSEIF(FTYPE(I).EQ.6)THEN
            NPPAR = 4
         ELSEIF(FTYPE(I).EQ.7)THEN
            NPPAR = 6
         ENDIF
         DO 10 J=1,NPPAR
            K = K + 1
            IF(VTABLE(K).GT.0)THEN
               IF(VTABLE(K).EQ.K)THEN
                  IF(LTABLE(K).EQ.1)THEN
                     IF(A(K).LT.X1LIM(K))A(K) = X1LIM(K)
                     IF(A(K).GT.X2LIM(K))A(K) = X2LIM(K)
                  ENDIF
               ENDIF
               AP(J) = FCONST(A(VTABLE(K)),FTABLE(K),X1CON(K),
     &                        X2CON(K),X3CON(K),XORIG)
               A(K) = AP(J)
            ELSE
               AP(J) = A(K)
            ENDIF
 10      CONTINUE
         K = K - NPPAR
         IF(NSELPK.EQ.0.OR.NSELPK.EQ.I)THEN
            IF(FTYPE(I).EQ.1)THEN
               CALL FGAUSS(X,AP,YP,DP)
            ELSEIF(FTYPE(I).EQ.2)THEN
               CALL FLORENTZ(X,AP,YP,DP)
            ELSEIF(FTYPE(I).EQ.3)THEN
               CALL FPEARSON(X,AP,YP,DP)
            ELSEIF(FTYPE(I).EQ.4)THEN
               CALL FVOIGT(X,AP,YP,DP)
            ELSEIF(FTYPE(I).EQ.5)THEN
               CALL FDEBYE(X,AP,YP,DP)
            ELSEIF(FTYPE(I).EQ.6)THEN
               CALL FDEXP(X,AP,YP,DP)
            ELSEIF(FTYPE(I).EQ.7)THEN
               CALL FLEIB(X,AP,YP,DP)
            ENDIF
            Y = Y + YP
         ENDIF
         DO 20 J=1,NPPAR
            K = K + 1
            IF(VTABLE(K).GT.0)THEN
               A(VTABLE(K)) = AP(J)
               DTMP = DP(J)*DFCONST(A(VTABLE(K)),
     &                FTABLE(K),X1CON(K),X2CON(K),X3CON(K))
               DYDA(VTABLE(K)) = DYDA(VTABLE(K)) + DTMP
               IF(FTABLE(K).GT.0.AND.FTABLE(K).LE.3)THEN
                  IF(LATCON.AND.VTABLE(KORIG).GT.0)THEN
                     DYDA(VTABLE(KORIG)) =  DYDA(VTABLE(KORIG)) - DTMP
                  ENDIF
               ENDIF
            ELSE
               DYDA(K) = 0.0D0
            ENDIF
 20      CONTINUE
 30   CONTINUE
C
C=======Calculate background
C
      IF(NBAK.GE.0)THEN
         DO 40 I=1,NBAK+1
            IF(VTABLE(K+I).GT.0)THEN
               IF(VTABLE(K+I).EQ.K+I)THEN
                  IF(LTABLE(K+I).EQ.1)THEN
                     IF(A(K+I).LT.X1LIM(K+I))A(K+I) = X1LIM(K+I)
                     IF(A(K+I).GT.X2LIM(K+I))A(K+I) = X2LIM(K+I)
                  ENDIF
               ENDIF
               AP(I) = FCONST(A(VTABLE(K+I)),FTABLE(K+I),X1CON(K+I),
     &                        X2CON(K+I),X3CON(K+I),XORIG)
               A(K+I) = AP(I)
            ELSE
               AP(I) = A(K+I)
            ENDIF
 40      CONTINUE
         CALL FPOLY(X,AP,YP,DP,NBAK)
         Y = Y + YP
         DO 50 I=1,NBAK+1
            IF(VTABLE(K+I).GT.0)THEN
               DTMP = DP(I)*DFCONST(A(VTABLE(K+I)),
     &                FTABLE(K+I),X1CON(K+I),X2CON(K+I),X3CON(K+I))
               DYDA(VTABLE(K+I)) = DYDA(VTABLE(K+I)) + DTMP
               IF(FTABLE(K+I).GT.0.AND.FTABLE(K+I).LE.3)THEN
                  IF(LATCON.AND.VTABLE(KORIG).GT.0)THEN
                     DYDA(VTABLE(KORIG)) =  DYDA(VTABLE(KORIG)) - DTMP
                  ENDIF
               ENDIF
            ELSE
               DYDA(K+I) = 0.0D0
            ENDIF
 50      CONTINUE
      ENDIF
      IF(FEXP.GT.0)THEN
         K = K + NBAK + 1
         DO 60 I=1,2
            IF(VTABLE(K+I).GT.0)THEN
               IF(VTABLE(K+I).EQ.K+I)THEN
                  IF(LTABLE(K+I).EQ.1)THEN
                     IF(A(K+I).LT.X1LIM(K+I))A(K+I) = X1LIM(K+I)
                     IF(A(K+I).GT.X2LIM(K+I))A(K+I) = X2LIM(K+I)
                  ENDIF
               ENDIF
               AP(I) = FCONST(A(VTABLE(K+I)),FTABLE(K+I),X1CON(K+I),
     &                        X2CON(K+I),X3CON(K+I),XORIG)
               A(K+I) = AP(I)
            ELSE
               AP(I) = A(K+I)
            ENDIF
 60      CONTINUE
         ARG = X*AP(2)
         EX = EXP(ARG)
         Y = Y + AP(1)*EX
         DP(1) = EX
         DP(2) = X*AP(1)*EX
         DO 70 I=1,2
            IF(VTABLE(K+I).GT.0)THEN
               DTMP = DP(I)*DFCONST(A(VTABLE(K+I)),
     &                FTABLE(K+I),X1CON(K+I),X2CON(K+I),X3CON(K+I))
               DYDA(VTABLE(K+I)) = DYDA(VTABLE(K+I)) + DTMP
               IF(FTABLE(K+I).GT.0.AND.FTABLE(K+I).LE.3)THEN
                  IF(LATCON.AND.VTABLE(KORIG).GT.0)THEN
                     DYDA(VTABLE(KORIG)) =  DYDA(VTABLE(KORIG)) - DTMP
                  ENDIF
               ENDIF
            ELSE
               DYDA(K+I) = 0.0D0
            ENDIF
 70      CONTINUE     
      ENDIF
C
      RETURN
      END

      DOUBLE PRECISION FUNCTION FCONST(X,NF,A1,A2,A3,XO)
      IMPLICIT NONE
      DOUBLE PRECISION X,A1,A2,A3,XO
      INTEGER NF
      IF(NF.EQ.0)THEN
         FCONST = X
         RETURN
      ELSEIF(NF.EQ.1)THEN
         FCONST = SQRT(A1*A1+A2*A2+A1*A2)*(X-XO) + XO
         RETURN
      ELSEIF(NF.EQ.2)THEN
         FCONST = SQRT(A1*A1+A2*A2)*(X-XO) + XO
         RETURN
      ELSEIF(NF.EQ.3)THEN
         FCONST = SQRT(A1*A1+A2*A2+A3*A3)*(X-XO) + XO
         RETURN
      ELSE
         WRITE(6,1000)NF
         RETURN
      ENDIF
 1000 FORMAT(1X,'***Unrecognised contraint function',I4)
      END

      DOUBLE PRECISION FUNCTION DFCONST(X,NF,A1,A2,A3)
      IMPLICIT NONE
      DOUBLE PRECISION X,A1,A2,A3
      INTEGER NF
      IF(NF.EQ.0)THEN
         DFCONST = 1.0D0 
         RETURN
      ELSEIF(NF.EQ.1)THEN
         DFCONST = SQRT(A1*A1+A2*A2+A1*A2)
         RETURN
      ELSEIF(NF.EQ.2)THEN
         DFCONST = SQRT(A1*A1+A2*A2)
         RETURN
      ELSEIF(NF.EQ.3)THEN
         DFCONST = SQRT(A1*A1+A2*A2+A3*A3)
         RETURN
      ELSE
         WRITE(6,1000)NF
         RETURN
      ENDIF
 1000 FORMAT(1X,'***Unrecognised contraint function',I4)
      END


C     LAST UPDATE 04/08/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FVOIGT(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is a Voigtian. The amplitude. centre and widths of 
C          the Voigtian are stored in consecutive locations of A: 
C          A(1) = H,  A(2) = P,  
C          A(3) = FWHM(Gaussian), A(4) = FWHM(Lorentzian)
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY,FACTOR
      PARAMETER(TINY=1.0D-10,FACTOR=1.66510922231D0)
C
C Arguments:
C
      DOUBLE PRECISION A(10),DYDA(10)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      INTEGER I
      DOUBLE PRECISION  V,Z,P,PMA,ZMB,ZMB2,PMA2,DVDZ,DVDP,TOP,BOT,BOT2,
     &                  PP,W,DVMDP,TOPM,BOTM
      DOUBLE PRECISION  ALPHA(4),BETA(4),GAMMA(4),DELTA(4),GAPDB(4),
     &                  A2PB2(4)
C
C Common block:
C
      DOUBLE PRECISION VMAX
      COMMON /VGTCOM/VMAX
      SAVE /VGTCOM/
C
C Data:
C
      DATA ALPHA /-1.2150D0,-1.3509D0,-1.2150D0,-1.3509D0/,
     &     BETA  / 1.2359D0, 0.3786D0,-1.2359D0,-0.3786D0/,
     &     GAMMA /-0.3085D0, 0.5906D0,-0.3085D0, 0.5906D0/,
     &     DELTA / 0.0210D0,-1.1858D0,-0.0210D0, 1.1858D0/
      DATA GAPDB / 0.4007814D0,-1.24678542D0,0.4007814D0,-1.24678542D0/,
     &     A2PB2 / 3.00367381D0,1.96826877D0,3.00367381D0,1.96826877D0/
C
C-----------------------------------------------------------------------
      P = A(4)/2.0D0
      PP = P*P
      IF(A(3).LT.TINY)A(3) = TINY
      W = A(3)/FACTOR
      Z = (X-A(2))/W
      V = 0.0D0
      VMAX = 0.0D0
      DVDZ = 0.0D0
      DVDP = 0.0D0
      DVMDP = 0.0D0
      DO 10 I=1,4
         PMA = P - ALPHA(I)
         ZMB = Z - BETA(I)
         PMA2 = PMA*PMA
         ZMB2 = ZMB*ZMB
         TOP = GAMMA(I)*PMA + DELTA(I)*ZMB
         BOT = PMA2 + ZMB2
         BOT2 = BOT*BOT
         V = V + TOP/BOT
         TOPM = GAMMA(I)*P - GAPDB(I)
         BOTM = PP - 2.0D0*P*ALPHA(I) + A2PB2(I)
         VMAX = VMAX + TOPM/BOTM
         DVDZ = DVDZ + (DELTA(I)*BOT-2.0D0*ZMB*TOP)/BOT2
         DVDP = DVDP + (GAMMA(I)*BOT-2.0D0*PMA*TOP)/BOT2
         DVMDP = DVMDP + (GAMMA(I)*BOTM-2.0D0*PMA*TOPM)/(BOTM*BOTM)
 10   CONTINUE
      V = V/VMAX
      DVDZ = DVDZ/VMAX
      DVDP = DVDP/VMAX
      DVMDP = DVMDP/VMAX
      Y = A(1)*V
      DYDA(1) = V
      DYDA(2) = -DVDZ*A(1)/W
      DYDA(3) = FACTOR*Z*DYDA(2)
      DYDA(4) = 2.0D0*A(1)*(DVDP-V*DVMDP)
C
      RETURN
      END
      
C     LAST UPDATE 11/07/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE GETOTO(BUF2,MAXCHN,MAXFRM,NCHAN,NFRAME,HEAD1,HEAD2,IRC)
      IMPLICIT NONE
C
C Purpose: Example program to demonstrate routines currently used by
C          OTOKO for opening, closing, reading and writing header and 
C          data files.
C Note:    Needs to be linked with the otoko.a library apprpriate to the
C          architecture of your machine (if available).
C
C Calls   3: GETHDR , GETCHN , OPNFIL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Include file:
C
      INCLUDE 'FIT.COM'
C
C Arguments:
C
      INTEGER MAXCHN,MAXFRM
      REAL BUF2(MAXCHN*MAXFRM)
      INTEGER NCHAN,NFRAME,IRC
C
C Local variables:
C
      REAL    BUF1(MAXDIM)
      INTEGER ICLO,JOP,IFRAME,IHFMAX,IFRMAX,NDUM
      INTEGER ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,I,J,K,M
      INTEGER ITERM,IPRINT,IUNIT,JUNIT
      CHARACTER*13 HFNAM
      CHARACTER*80 HEAD1,HEAD2
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
C ISPEC  : First header file of sequence
C LSPEC  : First header file of sequence
C MEM    : Positional or calibration data indicator
C IFFR   : First frame in sequence
C ILFR   : Last frame in sequence
C INCR   : Header file increment
C IFINC  : Frame increment
C HFNAM  : Header filename
C OFNAM  : Output header filename 
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C NCHAN  : Nos. of data points in spectrum
C NDUM   : Set to 1 for 1-D implementation
C NFRAME : Nos. of time frames 
C ITERM  : Unit number for reading from terminal
C IPRINT : Unit number for writing to terminal
C IUNIT  : Unit for reading header file
C JUNIT  : Unit for reading data file
C BUF1   : Buffer for frame of input     
C BUF2   : Buffer for frame of output
C
      DATA  ITERM/5/ , IPRINT/6/ , IUNIT/10/ , JUNIT/11/
      DATA  NDUM/1/
C
C-----------------------------------------------------------------------
 10   ICLO=0
      JOP=0 
C
C========PROMPT FOR INPUT FILE DETAILS
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 9999
      IFRAME = IHFMAX + IFRMAX - 1
      OPEN(UNIT=20,FILE=HFNAM,STATUS='OLD')
      READ(20,'(A80)')HEAD1
      READ(20,'(A80)')HEAD2
      CLOSE(20)
C
C========LOOP OVER SPECIFIED HEADER FILES
C
      DO 40 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC = ISPEC + INCR
C
C========LOOP OVER SPECIFIED FRAMES
C
            DO 30 J=1,IFRMAX
C
C========NEW VERSION OF RFRAME - AVAILABLE NEXT RELEASE OF OTOKO LIBRARY
C
               READ(UNIT=JUNIT,REC=IFFR,ERR=9999)(BUF1(K),K=1,NCHAN)
               IFFR = IFFR + IFINC
C
C========EXAMPLE OPERATION     
C
               DO 20 K=1,NCHAN
                  M = (J-1)*NCHAN + K
                  BUF2(M) = BUF1(K)
 20            CONTINUE
C
C========END OF OPERATION
C
 30         CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
 40   CONTINUE
 50   CLOSE (UNIT=JUNIT)
 9999 RETURN  
C
      END                  
      function DIBLK(Q,RN,LL,F,CHI)
c==== this subroutine calculates the LIEBLER DIBLOCK COPOLYMER
C==== L.LEIBLER, Macromolecule 13(1980)1602-1617 eqns IV-2 to IV-8
c==== 		R.K.Heenan 13/1/97
C
c==== NOTE MAY NOT BE VERY ROBUST TO OVERFLOWS, NON-PHYSICAL PARAMS ETC. !!!
C
      real*4 LL
      LT=1
      UU=0.0
C====  compute Rg**2
      RR = RN*LL*LL/6.0
      BIGF = DEBGAUSS(LT,Q,RR,UU)
      FM = 1.0-F
      D  = (F**2)* DEBGAUSS(LT,Q,RR*F ,UU)
      DM = (FM**2)*DEBGAUSS(LT,Q,RR*FM,UU)
      DEN = D*DM -0.25*(BIGF -D -DM)**2
      DIBLK = RN/( BIGF/DEN  -2.0*CHI*RN)
      RETURN
      END
c
c
      function DEBGAUSS(LTYP,QQ,RR,UU)
C==== P(Q) for Debye Gaussian coil.  Polydisp if LTYP >10 (i.e. 11 or 21)
c
C==== NOTE input RR is RG SQUARED not RG, but QQ is just Q
c
c==== carefully modified Feb 1992 by R.K.Heenan to avoid over & underflows
C==== 12/5/94 star polymer equation added as LTYP=31, fo rwhich UU is then
c==== the number of arms F
c
c==== polynomial expansion is used at small QR
c
c==== Written by R.K.Heenan, RAL
c
      QR=RR*(QQ**2)
      U=0.0
      FSTAR=1.0
      IF(LTYP.EQ.11)U=ABS(UU)
      IF(LTYP.EQ.31)FSTAR=AMAX1(1.0,ABS(UU))
C====  note U and FSTAR cannot be used simultaneously !
      Y=QR/( (1.0+2.0*U)*(3.0 -2.0/FSTAR) )
C==== polydisp version
      IF(U.GT.1.0E-02.AND.Y.GT.0.01)DEBGAUSS=
     >         2.0*( (1.0+U*Y)**(-1.0/U) +Y -1.0)/( (1.0+U)*(Y**2) )
C==== monodisp version
C2345 789012345678901234567890123456789012345678901234567890123456789012
      IF(U.LE.1.0E-02.AND.Y.GT.0.01)THEN
        AA=(EXPSPEC(-Y)-1.0)/(FSTAR*Y)
        DEBGAUSS= 2.*(AA + 1./FSTAR)/Y
        IF(FSTAR.GT.1.0)DEBGAUSS=DEBGAUSS+ FSTAR*(FSTAR-1.0)*AA*AA
      END IF
C==== EXPSPEC avoids underflows as QR**2 can be large
C==== low Q expansion for ALL versions
      IF(Y.LE.0.01)DEBGAUSS= 1.0 - QR*(1.0+ (0.25 - 0.75*U)*Y )/3.0
      return
      end
c
      FUNCTION EXPSPEC(A)
C==== expspec avoids underflows invoking the error handler
c==== the -88.5 is a machine dependent number
c
c==== The usual EXP( ) function may be fine - depends whether 
c==== a particular compiler gives underflow errors
cc
c==== Written by R.K.Heenan, RAL
c
      EXPSPEC=0.0
      IF(A.GT.-88.5.AND.A.LT.88.0)THEN
         EXPSPEC=EXP(A)
      ELSE IF(A.GE.85.2)THEN
         EXPSPEC=1.0E37
      END IF
C==== NOTE EXP(88.02)=1.684996E38
C==== NOTE EXP(-88.7)=3.006635E-39
      RETURN
      END
C




C     LAST UPDATE 22/04/97
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      PROGRAM PGFIT
      IMPLICIT NONE
C
C Purpose: Opens files, does line plots and peak fits.
C
C Calls  11: GETHDR , OPNFIL , OUTFIL , OPNNEW , ASK    , PAPER ,
C            PSPACE , FILNAM , FPLOT  , FRAME  , GREND 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Include file:
C
      INCLUDE 'FIT.COM'
C
C Parameter:
C
      DOUBLE PRECISION FACTOR
      PARAMETER(FACTOR=1.66510922231D0)
C
C Local variables:
C
      REAL    BUF(MAXDIM)
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,NCHAN,NFRAME,IMEM
      INTEGER ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
      INTEGER I,J,K,L,M,N,IM
      INTEGER ITERM,IPRINT,IUNIT,JUNIT,KUNIT,LUNIT
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM
      INTEGER ITEM(2),NW,NV
      REAL VAL
      CHARACTER*10 WORD
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
C ISPEC  : First header file of sequence
C LSPEC  : First header file of sequence
C MEM    : Positional or calibration data indicator
C IFFR   : First frame in sequence
C ILFR   : Last frame in sequence
C INCR   : Header file increment
C IFINC  : Frame increment
C HFNAM  : Header filename
C OFNAM  : Output header filename 
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C IMEM   : Output memory dataset
C NCHAN  : Nos. of pixels in image
C NFRAME : Nos. of frames in dataset
C ITERM  : Unit number for reading from terminal
C IPRINT : Unit number for writing to terminal
C IUNIT  : Unit for reading header file
C JUNIT  : Unit for reading data file
C KUNIT  : Unit for writing output file
C BUF   : Buffer for frame of input     
C
C FPLOT declarations:
C
      DOUBLE PRECISION A(MAXPAR),ASTDER(MAXPAR)
      REAL XPOS(MAXDIM),SIG(MAXDIM)
      REAL AREA,PI,SHAPE
      INTEGER IFLAG
      LOGICAL REPT,FIT,HCOPY,OTOUT,INIT,XAXIS,AUTO,AUTO1,SIGMA
      CHARACTER*12 CTYPE(7)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      CHARACTER*80 NAMFIL
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C OTOKO initialization file declarations:
C 
      REAL SBUF(MAXDIM*MAXPAR)
      INTEGER NCHANI,NFRAMI,IFFRI,NCHANX,NFRAMX,NPKPAR
      CHARACTER*80 IHEAD1,IHEAD2
C
C OTOKO file output declarations:
C
      REAL O2BUF(MAXDIM,MAXPAR),O1BUF(MAXDIM)
      INTEGER IOFRAM,IOCHAN
C
C External functions:
C
      REAL PSNINT,VGTINT
      EXTERNAL PSNINT,VGTINT
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      INTEGER PGBEG
      EXTERNAL PGBEG
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C Common block:
C
      INTEGER NPEAKS,NBAK,FEXP,NSELPK,KORIG
      LOGICAL LATCON
      DOUBLE PRECISION XORIG
      INTEGER FTYPE(20),VTABLE(MAXPAR)
      COMMON /FCOM  /NPEAKS,NBAK,FEXP,FTYPE,VTABLE,NSELPK
      COMMON /FCOM2 /XORIG,KORIG,LATCON
C
C Data:
C
      DATA  ITERM/5/ , IPRINT/6/ , IUNIT/10/ , JUNIT/11/ , KUNIT/12/ ,
     &      LUNIT/13/
      DATA  IMEM/1/ , PI /3.1415927/
      DATA  CTYPE /'Gaussian    ' , 'Lorentzian  ' , 'Pearson VII ' , 
     &             'Voigt       ' , 'Debye       ' , 'Dble expntl ' ,
     &             'Liebler     '/
C
C-----------------------------------------------------------------------
      WRITE(6,5000)
      CALL FLUSH(6)
C
C========Open FIT.OUT file
C
      OPEN(UNIT=KUNIT,STATUS='UNKNOWN',FILE='FIT.OUT')
C
C========Initialize graphics
C
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      CALL PAPER(1)
c      CALL PSPACE(0.1,0.9,0.1,0.9)
c      CALL GPSTOP(0)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IRC = PGBEG(0,'/XWINDOW',1,1)
      IF(IRC.NE.1)GOTO 9999
      CALL PGPAP(6.0,0.7)
      CALL PGASK(.FALSE.)
      CALL PGSVP(0.1,0.9,0.1,0.9)
      CALL PGPAGE
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C========Start main file loop
C
 10   CONTINUE
C
C========Prompt for input file details
C
      WRITE(6,5010)
      CALL FLUSH(6)
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 9999
      IFRAME = IHFMAX + IFRMAX - 1
      WRITE(KUNIT,1010)HFNAM
      WRITE(KUNIT,1020)IFFR,ILFR,IFINC
      REPT = .FALSE.
C
C========Prompt for X-axis input
C
      XAXIS = .FALSE.
      CALL ASK('701 User-supplied X-axis',XAXIS,0)
      IF(XAXIS)THEN
         CALL GETOTO(XPOS,MAXDIM,1,NCHANX,NFRAMX,IHEAD1,IHEAD2,IRC)
         IF(IRC.EQ.0)THEN
            IF(NCHANX.NE.NCHAN.OR.NFRAMX.NE.1)THEN
               WRITE(6,2030)
               CALL FLUSH(6)
               XAXIS = .FALSE.
            ENDIF
         ELSE
            WRITE(6,2030)
            CALL FLUSH(6)
            XAXIS = .FALSE.
         ENDIF
      ENDIF
C
C========Prompt for peak fitting and associated files
C
      FIT = .TRUE.
      CALL ASK('702 Do you want to fit the data',FIT,0)
      IF(FIT)THEN
         INIT = .FALSE.
         CALL ASK('703 Read initial parameters from file',INIT,0)
         IF(INIT)THEN
            IFFRI = 0
            CALL GETOTO(SBUF,MAXDIM,MAXPAR,NCHANI,NFRAMI,IHEAD1,IHEAD2,
     &                  IRC)
            IF(IRC.NE.0)THEN
               INIT = .FALSE.
            ELSE
               READ(IHEAD2,'(I2)')NPEAKS
               READ(IHEAD2,'(3X,20(I1,1X))')(FTYPE(L),L=1,NPEAKS)
            ENDIF
         ENDIF
         SIGMA = .FALSE.
         CALL ASK('713 Read standard deviations from file',SIGMA,0)
         IF(SIGMA)THEN
            IFFRI = 0
            CALL GETOTO(SIG,MAXDIM,1,NCHANX,NFRAMX,IHEAD1,IHEAD2,
     &                  IRC)
            IF(IRC.NE.0)THEN
               WRITE(6,2040)
               CALL FLUSH(6)
               SIGMA = .FALSE.
            ENDIF
         ENDIF
         IF(.NOT.SIGMA)THEN
            DO 20 I=1,NCHAN
               SIG(I) = 1.0
 20         CONTINUE
         ENDIF             
         IOFRAM = 0
         IOCHAN = 0
         AUTO1 = .FALSE.
         AUTO = .FALSE.
         IF(IFFR.NE.ILFR)THEN
            CALL ASK('707 Automatic run after the first frame',AUTO1,0)
         ENDIF
      ENDIF
C
C========Prompt for hardcopy output
C
      HCOPY = .FALSE.
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      CALL ASK('705 Do you require hardcopy output',HCOPY,0)
c      IF(HCOPY)THEN
c         WRITE(6,1000)
c         CALL FLUSH(6)
c         READ(ITERM,'(A80)',ERR=9999,END=9999)NAMFIL
c         CALL FILNAM(NAMFIL)
c      ENDIF
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c++++++++No hardcopy at present
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C========Loop over specified headers
C
      DO 50 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
C
C========Loop over specified frames
C
            DO 40 J=1,IFRMAX
C
C========Read frames sequentially
C
               READ (JUNIT,REC=IFFR,ERR=9999)(BUF(K),K=1,NCHAN)
C
C========Fill out A with appropriate SBUF values
C
               IF(INIT)THEN
                  IFFRI = IFFRI + 1
                  IF(IFFRI.GT.NCHANI)THEN
                     WRITE(6,2020)IFFR - 1
                     CALL FLUSH(6)
                     INIT = .FALSE.
                  ELSE
                     K = 0
                     DO 45 M=1,NPEAKS
                        IF(FTYPE(M).EQ.1.OR.FTYPE(M).EQ.2)THEN
                           NPKPAR = 3
                        ELSEIF(FTYPE(M).EQ.3.OR.FTYPE(M).EQ.4)THEN
                           NPKPAR = 4
                        ELSEIF(FTYPE(M).EQ.5)THEN
                           NPKPAR = 3
                        ELSEIF(FTYPE(M).EQ.6)THEN
                           NPKPAR = 4
                        ELSEIF(FTYPE(M).EQ.7)THEN
                           NPKPAR = 6
                        ENDIF
                        DO 41 L=1,NPKPAR
                           IM = (10+(M-1)*10+L-1)*NCHANI + IFFRI
                           A(K+L) = DBLE(SBUF(IM))
 41                     CONTINUE
                        K = K + NPKPAR
 45                  CONTINUE
                     NBAK = INT(SBUF(IFFRI))
                     DO 46 M=NBAK+2,2,-1
                        K = K + 1
                        IM = (M-1)*NCHANI + IFFRI
                        A(K) = DBLE(SBUF(IM))
 46                  CONTINUE
                     FEXP = INT(SBUF(6*NCHANI+IFFRI))
                     DO 47 M=8,7+FEXP
                        K = K + 1
                        IM = (M-1)*NCHANI + IFFRI
                        A(K) = DBLE(SBUF(IM))
 47                  CONTINUE
                     IM = 9*NCHANI + IFFRI
                     XORIG = DBLE(SBUF(IM))
                  ENDIF
               ENDIF
C
C========Do plotting and fitting                   
C
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c               CALL ERASE
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               CALL PGPAGE 
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               WRITE(6,1005)IFFR
               CALL FLUSH(6)
               CALL FPLOT(BUF,NCHAN,REPT,FIT,A,ASTDER,INIT,NFRAMI,
     &                    XPOS,SIG,XAXIS,AUTO,IFLAG)
C
C========Exit if GUI demands it (i.e. ^D received)
C
               IF(IFLAG.EQ.-2)GOTO 60
C
C========Interpret A and write out parameters
C
               IF(FIT.AND.IFLAG.EQ.0)THEN
                  IOCHAN = IOCHAN + 1
C
C========Write out peaks parameters
C
                  WRITE(KUNIT,1030)IFFR
                  WRITE(6,1030)IFFR
                  CALL FLUSH(6)
                  IF(10*NPEAKS+10.GT.IOFRAM)IOFRAM = 10*NPEAKS + 10
                  M = 0
                  DO 30 L=1,NPEAKS
                     IF(FTYPE(L).EQ.1.OR.FTYPE(L).EQ.2)THEN
                        A(M+3) = ABS(A(M+3))
                        IF(FTYPE(L).EQ.1)THEN
                           AREA = SNGL(A(M+1)*A(M+3)/FACTOR)*SQRT(PI)
                        ELSE
                           AREA = SNGL(A(M+1)*A(M+3)/2.0D0)*PI
                        ENDIF
                        SHAPE = 0.0
                        N = 3
                     ELSEIF(FTYPE(L).EQ.3.OR.FTYPE(L).EQ.4)THEN
                        IF(FTYPE(L).EQ.3)THEN
                           AREA = PSNINT(A(M+1),A(M+3),A(M+4))
                        ELSE
                           AREA = VGTINT(A(M+1),A(M+3),A(M+4))
                        ENDIF
                        SHAPE = SNGL(A(M+4))
                        N = 4
                     ELSEIF(FTYPE(L).EQ.5)THEN
                        AREA = SNGL(A(M+1)*A(M+3))*SQRT(PI)*8.0/3.0
                        SHAPE = 0.0
                        N = 3
                     ELSEIF(FTYPE(L).EQ.6)THEN
                        AREA = 2.0*PI*SNGL(A(M+1)*A(M+4)*A(M+4)/
     &                                     (A(M+3)+A(M+4)))
     &                       /SIN(PI/(1.0+SNGL(A(M+4)/A(M+3))))
                        SHAPE = SNGL(A(M+4))
                        N = 4
                     ELSEIF(FTYPE(L).EQ.7)THEN
                        N = 6
                     ENDIF
                     IF(FTYPE(L).NE.7)THEN
                        WRITE(KUNIT,1035)L,CTYPE(FTYPE(L)),
     &                       (A(M+K),K=1,3),SHAPE,AREA
                        WRITE(6,1035)L,CTYPE(FTYPE(L)),
     &                       (A(M+K),K=1,3),SHAPE,AREA
                        O2BUF(IOCHAN,10*L+1) = SNGL(A(M+1))
                        O2BUF(IOCHAN,10*L+2) = SNGL(A(M+2))
                        O2BUF(IOCHAN,10*L+3) = SNGL(A(M+3))
                        O2BUF(IOCHAN,10*L+4) = SHAPE
                        O2BUF(IOCHAN,10*L+5) = AREA
                     ELSE
                        WRITE(KUNIT,1040)L,CTYPE(FTYPE(L)),
     &                       (A(M+K),K=1,6)
                        WRITE(6,1040)L,CTYPE(FTYPE(L)),
     &                       (A(M+K),K=1,6)
                        O2BUF(IOCHAN,10*L+1) = SNGL(A(M+1))
                        O2BUF(IOCHAN,10*L+2) = SNGL(A(M+2))
                        O2BUF(IOCHAN,10*L+3) = SNGL(A(M+3))
                        O2BUF(IOCHAN,10*L+4) = SNGL(A(M+4))
                        O2BUF(IOCHAN,10*L+5) = SNGL(A(M+5))
                        O2BUF(IOCHAN,10*L+6) = SNGL(A(M+6))
                     ENDIF
                     WRITE(KUNIT,1045)(ASTDER(M+K),K=1,N)
                     WRITE(6,1045)(ASTDER(M+K),K=1,N)
                     CALL FLUSH(6)
                     M = M + N
 30               CONTINUE
C
C========Write out background polynomial coefficients
C
                  WRITE(6,1050)NBAK,(K,K=0,4)
                  CALL FLUSH(6)
                  WRITE(KUNIT,1050)NBAK,(K,K=0,4)
                  WRITE(6,1060)(A(M+K),K=NBAK+1,1,-1)
                  CALL FLUSH(6)
                  WRITE(KUNIT,1060)(A(M+K),K=NBAK+1,1,-1)
                  WRITE(6,1065)(ASTDER(M+K),K=NBAK+1,1,-1)
                  CALL FLUSH(6)
                  WRITE(KUNIT,1065)(ASTDER(M+K),K=NBAK+1,1,-1)
                  O2BUF(IOCHAN,1) = NBAK
                  L = 1
                  DO 35 K=NBAK+1,1,-1
                     L = L + 1
                     O2BUF(IOCHAN,L) = SNGL(A(M+K))
 35               CONTINUE
                  IF(FEXP.GT.0)THEN
                     WRITE(6,1070)A(M+NBAK+2),A(M+NBAK+3)
                     CALL FLUSH(6)
                     WRITE(KUNIT,1070)A(M+NBAK+2),A(M+NBAK+3)
                     WRITE(6,1075)ASTDER(M+NBAK+2),ASTDER(M+NBAK+3)
                     CALL FLUSH(6)
                     WRITE(KUNIT,1075)ASTDER(M+NBAK+2),ASTDER(M+NBAK+3)
                     O2BUF(IOCHAN,7) = FEXP
                     L = 7
                     DO 36 K=NBAK+2,NBAK+FEXP+1
                        L = L + 1
                        O2BUF(IOCHAN,L) = SNGL(A(M+K))
 36                  CONTINUE
                  ENDIF
                  IF(LATCON)THEN
                     WRITE(6,1080)XORIG
                     CALL FLUSH(6)
                     WRITE(KUNIT,1080)XORIG
                     O2BUF(IOCHAN,10) = SNGL(XORIG)
                     IF(KORIG.GT.0)THEN
                        WRITE(6,1085)ASTDER(KORIG)
                        CALL FLUSH(6)
                        WRITE(KUNIT,1085)ASTDER(KORIG)
                     ENDIF
                  ENDIF
               ENDIF
C
C========Wait until ready for next plot
C
               IF(.NOT.FIT)THEN
                  IF(IFFR.NE.ILFR)THEN
                     WRITE(6,1090)
                     CALL FLUSH(6)
                     CALL RDCOMF(ITERM,WORD,NW,VAL,NV,ITEM,1,1,10,IRC)
                     IF(IRC.NE.0)THEN
                        IFLAG = -2
                        GOTO 60
                     ELSEIF(NW.GT.0)THEN
                        IF(WORD(1:2).EQ.'^D')THEN
                           IFLAG = -2
                           GOTO 60
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
               IF(IFLAG.EQ.0)REPT = .TRUE.
               IF(REPT.AND.AUTO1)AUTO = .TRUE.
               IFFR=IFFR+IFINC
 40         CONTINUE
            CLOSE (JUNIT)
         ENDIF
 50   CONTINUE
 60   CLOSE (JUNIT)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      IF(HCOPY)CALL FILEND
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c++++++++No hardcopy at present
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IF(FIT)THEN
         OTOUT = .TRUE.
         CALL ASK('704 Save parameters in a new OTOKO file',OTOUT,0)
         IF(OTOUT)THEN
            CALL OUTFIL(ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
            IF(IRC.NE.0)THEN
               WRITE(6,2000)
               OTOUT = .FALSE.
            ENDIF
         ENDIF
      ENDIF
      IF(OTOUT)THEN
         ICLO = 0
         JOP = 0
         IF(IOFRAM.GT.MAXPAR)THEN
            WRITE(6,2010)
            CALL FLUSH(6)
            IOFRAM = MAXPAR
         ENDIF
         WRITE(HEAD2,'(I2,1X,20(I1,1X))')NPEAKS,(FTYPE(L),L=1,NPEAKS)
         DO 80 I=1,IOFRAM
            IF(I.EQ.IOFRAM)ICLO = 1
            DO 70 J=1,IOCHAN
               O1BUF(J) = O2BUF(J,I)
 70         CONTINUE
            CALL DAWRT(LUNIT,OFNAM,IMEM,IOCHAN,IOFRAM,HEAD1,HEAD2,
     &           O1BUF,I,JOP,ICLO,IRC)
            IF(IRC.NE.0)THEN
               WRITE(6,2005)
               CALL FLUSH(6)
            ENDIF
 80      CONTINUE
      ENDIF
      IF(IFLAG.NE.-2)GOTO 10
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c 9999 CALL GREND
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 9999 CALL PGEND
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CLOSE(KUNIT)
      STOP  
C
 1000 FORMAT(1X,'900',
     &       1X,'Enter gridfile name: ',$)
 1005 FORMAT(/1X,'200',
     &       1X,'Plotting frame ',I4/)
 1010 FORMAT(/1X,'200'/
     &       1X,'Header filename: ',A20)
 1020 FORMAT(1X,'200',
     &       1X,'First frame ',I4,'  Last frame ',I4,'  Incr. ',I4)
 1030 FORMAT(/1X,'200'/
     &       1X,'Frame ',I4)
 1035 FORMAT(1X,'200',
     &       1X,'Peak ',I3,4X,A12/
     &       1X,'200',
     &       8X,'Height      Position    Width       Shape',
     &       7X,'Integrated'/
     &       1X,'Value',4X,5G12.5)
 1040 FORMAT(1X,'200',
     &       1X,'Peak ',I3,4X,A12/
     &       1X,'200',
     &       8X,'Scale       Position    Length      Number',
     &       6X,'Fraction    Flory'/
     &       1X,'Value',4X,6G12.5)
 1045 FORMAT(1X,'Std Err',2X,6G12.5)
 1050 FORMAT(/1X,'Background polynomial degree ',I3/
     &       1X,'200',6X,5(4X,'a',I1,6X))
 1060 FORMAT(1X,'Coeff',4X,5G12.5)
 1065 FORMAT(1X,'Std Err',2X,5G12.5)
 1070 FORMAT(/1X,'Exponential background'/
     &       10X,G12.5,' * exp(',G12.5,' * x)')
 1075 FORMAT(1X,'Std Err',2X,G12.5,7X,G12.5)
 1080 FORMAT(/1X,'Origin for lattice constraints = ',G12.5)
 1085 FORMAT(1X,'                       Std Err = ',G12.5)
 1090 FORMAT(1X,'806',
     &       1X,'Hit return for next frame or <ctrl-D> to exit'/
     &       1X,'200',
     &       1X,'Waiting to continue...')
 2000 FORMAT(1X,'400',
     &       1X,'Error opening output file')
 2005 FORMAT(1X,'400',
     &       1X,'Error writing binary output file')
 2010 FORMAT(1X,'300',
     &       1X,'Too many frames in output file - truncating')
 2020 FORMAT(/1X,'300',
     &       1X,'Warning - ',I4,' frames read - no more initialization',
     &       1X,'data'/)
 2030 FORMAT(1X,'300',
     &       1X,'Warning - invalid X-axis file - using default axis')
 2040 FORMAT(1X,'300',
     &       1X,'Warning - invalid standard deviation file -'
     &       1X,'using unit weights')
 5000 FORMAT(/1X,'200',
     &       1X,'FIT - 1-D peak fitting program'/
     &       1X,'Last update 22/04/97'/)
 5010 FORMAT(1X,'201 New input file')
      END                  




C     LAST UPDATE 09/11/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FPLOT(BUF,NBUF,REPEAT,FIT,A,ASTDER,INIT,NFRAMI,
     &                 XPOS,SIG,XAXIS,AUTO,IFLAG)
      IMPLICIT NONE
C
C Purpose: Plots 1-D data and allows fitting of peaks
C
C Calls  16: RDCOMF , MAP    , DEFPEN , SCALES , LINCOL , PTPLOT , 
C            ASK    , CURSOR , POSITN , JOIN   , MRQMIN , FUNCS  , 
C            CURVEO , PICNOW , PTJOIN
C Called by: 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Include file:
C
      INCLUDE 'FIT.COM'
C
C Arguments:
C
      INTEGER NBUF,NPKPAR,NFRAMI,IFLAG
      REAL BUF(NBUF),XPOS(MAXDIM),SIG(MAXDIM)
      DOUBLE PRECISION A(MAXPAR),ASTDER(MAXPAR)
      LOGICAL REPEAT,FIT,INIT,XAXIS,AUTO
C
C Local variables:
C
      INTEGER I,J,K,IXMIN,IXMAX,NW,NV,IRC,MARKER,KCHAR,MA,MFIT,IXMINF,
     &        IXMAXF,NLSQ,TYPE,M,KPAR,NV1,NV2,ITMAX,ISTEP,ITMP
      INTEGER ITEM(20),LISTA(MAXPAR)
      REAL VAL(10),SFIT(MAXDIM),XFIT(MAXDIM),YFIT(MAXDIM)
      DOUBLE PRECISION COVAR(MAXPAR,MAXPAR),ALPHA(MAXPAR,MAXPAR)
      DOUBLE PRECISION DYDA(MAXPAR)
      CHARACTER*10 WRD(10)
      REAL XMIN,XMAX,YMIN,YMAX,XCURSR,YCURSR,TEMP,CHISQ,ALAMDA,ENDLAM
      REAL ASPECT,XMAP,XMINF,XMAXF,XMAPF,OCHISQ,CHITST,ESTD
      REAL PRECHI,FACTOR
      LOGICAL REPLY,RETRY,STEP,CONVGD
      CHARACTER*12 CTYPE(7)
      CHARACTER*40 STAT1,STAT2
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CHARACTER*1 CH
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C External function:
C
      CHARACTER*40 STATUS
      EXTERNAL STATUS
      EXTERNAL FUNCS
C
C Common block:
C
      INTEGER NPEAKS,NBAK,FEXP,NSELPK,KORIG
      LOGICAL LATCON
      INTEGER FTYPE(20),VTABLE(MAXPAR),FTABLE(MAXPAR),LTABLE(MAXPAR)
      DOUBLE PRECISION X1COM(MAXPAR),X2COM(MAXPAR),X3COM(MAXPAR)
      DOUBLE PRECISION XORIG
      DOUBLE PRECISION X1LIM(MAXPAR),X2LIM(MAXPAR)
      COMMON /FCOM  /NPEAKS,NBAK,FEXP,FTYPE,VTABLE,NSELPK
      COMMON /FCOM1 /X1COM,X2COM,X3COM,FTABLE
      COMMON /FCOM2 /XORIG,KORIG,LATCON
      COMMON /FCOM3 /X1LIM,X2LIM,LTABLE
C
C Save local variables for next call:
C
      SAVE
C
C Data:
C
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      DATA MARKER /243/
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      DATA MARKER /16/
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      DATA ASPECT /0.714/ , CHITST /0.1/ , FACTOR /10.0/
      DATA  CTYPE /'Gaussian    ' , 'Lorentzian  ' , 'Pearson-VII ' , 
     &             'Voigt       ' , 'Debye       ' , 'Dble-expntl ' ,
     &             'Liebler     '/
C-----------------------------------------------------------------------
C
C========Initialize plotting area
C
      IF(REPEAT)THEN
         IF(FIT)THEN
            XMIN = XMINF
            XMAX = XMAXF
            XMAP = XMAPF
            IXMIN = IXMINF
            IXMAX = IXMAXF
         ENDIF
      ELSE
         IF(.NOT.XAXIS)THEN
            DO 1 I=1,NBUF
               XPOS(I) = FLOAT(I)
 1          CONTINUE
         ENDIF
         XMIN = XPOS(1)
         XMAX = XPOS(NBUF)
         IXMIN = 1
         IXMAX = NBUF
      ENDIF
      RETRY = .FALSE.
 5    IF(.NOT.REPEAT.OR.RETRY)THEN
         IF(.NOT.RETRY)THEN
            WRITE(6,1000)IXMIN,IXMAX
            CALL FLUSH(6)
            CALL RDCOMF(5,WRD,NW,VAL,NV,ITEM,10,10,10,IRC)
            IF(IRC.NE.0)THEN
               IFLAG = -1
               RETURN
            ENDIF
            IF(NW.GT.0)THEN
               IF(WRD(1)(1:2).EQ.'^D')THEN
                  IFLAG = -2
                  RETURN
               ELSEIF(WRD(1)(1:2).EQ.'^d')THEN
                  IFLAG = -1
                  RETURN
               ELSE
                  WRITE(6,2010)
               ENDIF
            ENDIF
            IF(NV.GE.1)IXMIN = NINT(VAL(1))
            IF(NV.GE.2)IXMAX = NINT(VAL(2))
            XMIN = XPOS(IXMIN)
            XMAX = XPOS(IXMAX)
         ENDIF
         XMAP = XMIN + (XMAX-XMIN)*ASPECT
      ENDIF
      IF(.NOT.RETRY.AND..NOT.REPEAT)THEN
         YMIN = 1.0E+10
         YMAX = 1.0E-10
         DO 7 I=IXMIN,IXMAX
            IF(BUF(I).GT.YMAX)YMAX = BUF(I)
            IF(BUF(I).LT.YMIN)YMIN = BUF(I)
 7       CONTINUE
         IF(YMIN.LT.-0.99E+30)YMIN = 0.0
      ENDIF
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c 8    CALL MAP(XMIN,XMAP,YMIN,YMAX)
c      CALL WINDOW(XMIN,XMAX,YMIN,YMAX)
c      CALL DEFPEN
c      CALL FULL
c      CALL SCALES
c      CALL LINCOL(3)
c      CALL PTJOIN(XPOS,BUF,IXMIN,IXMAX,1)
c      CALL PICNOW
c      CALL DEFPEN
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 8    CALL PGBBUF
      CALL PGSWIN(XMIN,XMAX,YMIN,YMAX)
      CALL PGSCI(1)
      CALL PGSLS(1)
      CALL PGBOX('BCNST',0.0,0,'BCNSTV',0.0,0)
      CALL PGSCI(3)
      CALL PGLINE(IXMAX-IXMIN+1,XPOS(IXMIN),BUF(IXMIN))
      CALL PGSCI(1)
      CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IF(.NOT.RETRY.AND..NOT.AUTO)THEN
         WRITE(6,1005)YMIN,YMAX
         CALL FLUSH(6)
         CALL RDCOMF(5,WRD,NW,VAL,NV,ITEM,10,10,10,IRC)
         IF(IRC.NE.0)THEN
            IFLAG = -1
            RETURN
         ENDIF
         IF(NW.GT.0)THEN
            IF(WRD(1)(1:2).EQ.'^D')THEN
               IFLAG = -2
               RETURN
            ELSEIF(WRD(1)(1:2).EQ.'^d')THEN
               IFLAG = -1
               RETURN
            ELSE
               WRITE(6,2010)
            ENDIF
         ENDIF
         IF(NV.EQ.0)GOTO 9
         IF(NV.GE.1)YMIN = VAL(1)
         IF(NV.GE.2)YMAX = VAL(2)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c         CALL ERASE
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         CALL PGPAGE
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         GOTO 8
      ENDIF
 9    IF(FIT)THEN
C
C========Select range on graph for fitting
C
         IF(.NOT.REPEAT.AND..NOT.RETRY)THEN
            REPLY = .FALSE.
            CALL ASK('700 Cursor selection of fitting region',REPLY,0)
            IF(REPLY)THEN
               WRITE(6,1007)
               CALL FLUSH(6)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c               CALL CURSOR(XCURSR,YCURSR,KCHAR)
c               CALL POSITN(XCURSR,YMIN)
c               CALL JOIN(XCURSR,YMAX)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               CALL PGBBUF
               CALL PGBAND(6,0,0.0,0.0,XCURSR,YCURSR,CH)
               KCHAR=ICHAR(CH)
               CALL PGMOVE(XCURSR,YMIN)
               CALL PGDRAW(XCURSR,YMAX)
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               XMINF = XCURSR
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c               CALL CURSOR(XCURSR,YCURSR,KCHAR)
c               CALL POSITN(XCURSR,YMIN)
c               CALL JOIN(XCURSR,YMAX)
c               CALL PICNOW
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               CALL PGBAND(6,0,0.0,0.0,XCURSR,YCURSR,CH)
               KCHAR=ICHAR(CH)
               CALL PGMOVE(XCURSR,YMIN)
               CALL PGDRAW(XCURSR,YMAX)
               CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               XMAXF = XCURSR
               IF((XMINF.GT.XMAXF).EQV.(XPOS(NBUF).GT.XPOS(1)))THEN
                  TEMP = XMINF
                  XMINF = XMAXF
                  XMAXF = TEMP
               ENDIF
               XMAPF = XMINF + (XMAXF-XMINF)*ASPECT
            ELSE
               XMINF = XMIN
               XMAXF = XMAX
               XMAPF = XMAP
            ENDIF
            IF(XAXIS)THEN
               CALL LOCATE(XPOS,MAXDIM,IXMIN,IXMAX,XMINF,IXMINF)
               CALL LOCATE(XPOS,MAXDIM,IXMIN,IXMAX,XMAXF,IXMAXF)
            ELSE
               IXMINF = NINT(XMINF)
               IXMAXF = NINT(XMAXF)
            ENDIF
            WRITE(6,1010)IXMINF,IXMAXF,XMINF,XMAXF
            CALL FLUSH(6)
            IF(REPLY)THEN
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c               CALL ERASE
c               CALL MAP(XMINF,XMAPF,YMIN,YMAX)
c               CALL WINDOW(XMINF,XMAXF,YMIN,YMAX)
c               CALL DEFPEN
c               CALL FULL
c               CALL SCALES
c               CALL LINCOL(3)
c               CALL PTJOIN(XPOS,BUF,IXMINF,IXMAXF,1)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               CALL PGBBUF
               CALL PGPAGE
               CALL PGSWIN(XMINF,XMAXF,YMIN,YMAX)
               CALL PGSCI(1)
               CALL PGSLS(1)
               CALL PGBOX('BCNST',0.0,0,'BCNSTV',0.0,0)
               CALL PGSCI(3)
               CALL PGLINE(IXMAXF-IXMINF+1,XPOS(IXMINF),BUF(IXMINF))
               CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ENDIF
         ENDIF
C
C========Initialize background order, peak type etc
C
         IF(.NOT.(REPEAT.OR.INIT).OR.RETRY)THEN
            NBAK = 3
            FEXP = 0
            TYPE = 1
            NPKPAR = 3
C
C========Initialize fitting parameters
C
            MA = 0
            NPEAKS = 0
            DO 10 I=1,MAXPAR
               A(I) = 0.0D0
               ASTDER(I) = 0.0D0
 10         CONTINUE
            XORIG = DBLE(XMINF)
            KORIG = 0
            LATCON = .FALSE.
         ENDIF
C
C========If initial A values have been taken from a file,
C========plot peaks and initialize MA and MFIT
C
         IF(INIT.AND..NOT.RETRY)THEN
            MA = 0
            DO 12 M=1,NPEAKS
               IF(FTYPE(M).EQ.1.OR.FTYPE(M).EQ.2)THEN
                  NPKPAR = 3
               ELSEIF(FTYPE(M).EQ.3.OR.FTYPE(M).EQ.4)THEN
                  NPKPAR = 4
               ELSEIF(FTYPE(M).EQ.5)THEN
                  NPKPAR = 3
               ELSEIF(FTYPE(M).EQ.6)THEN
                  NPKPAR = 4
               ELSEIF(FTYPE(M).EQ.7)THEN
                  NPKPAR = 6
               ENDIF
               MA = MA + NPKPAR
               NSELPK = M
               CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
 12         CONTINUE
            MFIT = MA + NBAK + FEXP + 1
            MA = MFIT
C
C========Initialize dependency list
C
            IF(.NOT.REPEAT)THEN
               DO 16 J=1,MFIT
                  VTABLE(J) = J
                  FTABLE(J) = 0
                  LTABLE(J) = 0
 16            CONTINUE
            ENDIF
         ENDIF
C     
C========Get user to estimate initial parameters
C
         IF((.NOT.REPEAT.AND..NOT.INIT).OR.RETRY)THEN
            WRITE(6,1015)
            WRITE(6,1020)
            CALL FLUSH(6)
            WRITE(6,1016)CTYPE(TYPE)
            CALL FLUSH(6)
            WRITE(6,1017)NBAK
            CALL FLUSH(6)
            WRITE(6,1018)
            CALL FLUSH(6)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c            CALL LINCOL(2)
c 20         CALL CURSOR(XCURSR,YCURSR,KCHAR)
c            IF(KCHAR.EQ.108.OR.KCHAR.EQ.114)THEN
c               IF(KCHAR.EQ.108)THEN
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            CALL PGSCI(2)
 20         CALL PGBAND(7,0,0.0,0.0,XCURSR,YCURSR,CH)
            KCHAR=ICHAR(CH)
            IF(KCHAR.EQ.65.OR.KCHAR.EQ.88)THEN
               IF(KCHAR.EQ.65)THEN
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  NPEAKS = NPEAKS + 1
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c                  CALL FULL
c                  CALL POSITN(XCURSR,YMIN)
c                  CALL JOIN(XCURSR,YMAX)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  CALL PGBBUF
                  CALL PGSLS(1)
                  CALL PGMOVE(XCURSR,YMIN)
                  CALL PGDRAW(XCURSR,YMAX)
                  CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  CALL LOCATE(XPOS,MAXDIM,IXMINF,IXMAXF,XCURSR,ITMP)
                  A(MA+1) = DBLE(BUF(ITMP)-YMIN)
                  A(MA+2) = DBLE(XCURSR)
                  TEMP = (YCURSR-YMIN)*(XMAPF-XMINF)/(YMAX-YMIN)
                  A(MA+3) = DBLE(ABS(TEMP))
                  IF(TYPE.EQ.3)A(MA+4) = 2.0D0
                  IF(TYPE.EQ.4)A(MA+4) = 0.1D0
                  IF(TYPE.EQ.6)A(MA+4) = A(MA+3)
                  IF(TYPE.EQ.7)THEN
                     A(MA+3) = 5.0D0
                     A(MA+4) = 24.0D0/(A(MA+2)*A(MA+3))**2
                     A(MA+2) = 0.0D0
                     A(MA+5) = 0.5D0
                     A(MA+1) = 5.0D-3*A(MA+1)
                     A(MA+6) = 10.0D0/A(MA+4)
                  ENDIF
                  FTYPE(NPEAKS) = TYPE
                  DO 22 J=1,NPKPAR 
                     VTABLE(MA+J) = MA + J
                     FTABLE(MA+J) = 0
                     LTABLE(MA+J) = 0
 22               CONTINUE
                  MA = MA + NPKPAR
               ELSE
                  WRITE(6,1030)NPEAKS
                  CALL FLUSH(6)
               ENDIF
               MFIT = MA + NBAK + FEXP + 1
               IF(MFIT.GT.MAXPAR)THEN
                  WRITE(6,1040)
                  CALL FLUSH(6)
                  IFLAG = -2
                  RETURN
               ENDIF
               DO 24 J=1,MFIT
                  IF(J.GT.MA.AND.J.LE.MA+NBAK+1)THEN
                     A(J) = 0.0D0
                     VTABLE(J) = J
                     FTABLE(J) = 0
                     LTABLE(J) = 0
                  ENDIF
 24            CONTINUE
               IF(NBAK.GE.0)A(MA+NBAK+1) = DBLE(YMIN)
               IF(FEXP.GT.0)THEN
                  A(MFIT-1) = 1.0D0
                  A(MFIT) = 0.0D0
                  VTABLE(MFIT-1) = MFIT - 1
                  FTABLE(MFIT-1) = 0
                  LTABLE(MFIT-1) = 0
                  VTABLE(MFIT) = MFIT
                  FTABLE(MFIT) = 0
                  LTABLE(MFIT) = 0
               ENDIF
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c               IF(KCHAR.EQ.108)THEN
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               IF(KCHAR.EQ.65)THEN
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  NSELPK = NPEAKS
                  CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
                  GOTO 20
               ELSE
                  MA = MFIT
               ENDIF
            ELSEIF(KCHAR.GE.48.AND.KCHAR.LE.52)THEN
               NBAK = KCHAR - 48   
               WRITE(6,1017)NBAK
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.103)THEN
               TYPE = 1
               NPKPAR = 3
               WRITE(6,1016)CTYPE(TYPE)
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.99)THEN
               TYPE = 2
               NPKPAR = 3
               WRITE(6,1016)CTYPE(TYPE)
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.112)THEN
               TYPE = 3
               NPKPAR = 4
               WRITE(6,1016)CTYPE(TYPE)
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.118)THEN
               TYPE = 4
               NPKPAR = 4
               WRITE(6,1016)CTYPE(TYPE)
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.100)THEN
               TYPE = 5
               NPKPAR = 3
               WRITE(6,1016)CTYPE(TYPE)
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.120)THEN
               TYPE = 6
               NPKPAR = 4
               WRITE(6,1016)CTYPE(TYPE)
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.108)THEN
               TYPE = 7
               NPKPAR = 6
               WRITE(6,1016)CTYPE(TYPE)
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.101)THEN
               FEXP = 2
               WRITE(6,1019)
               CALL FLUSH(6)
               GOTO 20
            ELSE
               GOTO 20
            ENDIF
         ENDIF
C
C========Draw first guess at peaks
C
         NSELPK = 0
         CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
         NSELPK = -1
         CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
         IF(.NOT.RETRY.OR.REPEAT.OR.INIT)THEN
            DO 30 J=1,NPEAKS
               NSELPK = J
               CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
 30         CONTINUE
         ENDIF
C
C========Allow user to set variables to a fixed value or tie them to 
C========other variables
C
         IF(.NOT.AUTO)THEN
            WRITE(6,1110)
            CALL FLUSH(6)
         ENDIF
         STEP = .FALSE.
 31      KPAR = 0
         IF(.NOT.AUTO)THEN
            WRITE(6,'(/1X,A3)')'805'
            CALL FLUSH(6)
         ENDIF
         DO 32 J=1,NPEAKS
            IF(FTYPE(J).EQ.1)THEN
               NPKPAR = 3
            ELSEIF(FTYPE(J).EQ.2)THEN
               NPKPAR = 3
            ELSEIF(FTYPE(J).EQ.3)THEN
               NPKPAR = 4
            ELSEIF(FTYPE(J).EQ.4)THEN
               NPKPAR = 4
            ELSEIF(FTYPE(J).EQ.5)THEN
               NPKPAR = 3
            ELSEIF(FTYPE(J).EQ.6)THEN
               NPKPAR = 4
            ELSEIF(FTYPE(J).EQ.7)THEN
               NPKPAR = 6
            ENDIF
            IF(.NOT.AUTO)THEN
               WRITE(6,1041)J,CTYPE(FTYPE(J))
               CALL FLUSH(6)
               STAT1 = STATUS(VTABLE(KPAR+1),KPAR+1,
     &              LTABLE(KPAR+1),X1LIM(KPAR+1),X2LIM(KPAR+1))
               WRITE(6,1042)KPAR+1,A(KPAR+1),STAT1
               CALL FLUSH(6)
               STAT1 = STATUS(VTABLE(KPAR+2),KPAR+2,
     &              LTABLE(KPAR+2),X1LIM(KPAR+2),X2LIM(KPAR+2))
               WRITE(6,1043)KPAR+2,A(KPAR+2),STAT1
               CALL FLUSH(6)
               IF(NPKPAR.LE.4)THEN
                  STAT1 = STATUS(VTABLE(KPAR+3),KPAR+3,
     &                 LTABLE(KPAR+3),X1LIM(KPAR+3),X2LIM(KPAR+3))
                  WRITE(6,1044)KPAR+3,A(KPAR+3),STAT1
                  CALL FLUSH(6)
                  IF(NPKPAR.EQ.4)THEN
                     STAT1 = STATUS(VTABLE(KPAR+4),KPAR+4,
     &                    LTABLE(KPAR+4),X1LIM(KPAR+4),X2LIM(KPAR+4))
                     WRITE(6,1045)KPAR+4,A(KPAR+4),STAT1
                     CALL FLUSH(6)
                  ENDIF
               ELSEIF(NPKPAR.EQ.6)THEN
                  STAT1 = STATUS(VTABLE(KPAR+3),KPAR+3,
     &                 LTABLE(KPAR+3),X1LIM(KPAR+3),X2LIM(KPAR+3))
                  WRITE(6,1047)KPAR+3,A(KPAR+3),STAT1
                  STAT1 = STATUS(VTABLE(KPAR+4),KPAR+4,
     &                 LTABLE(KPAR+4),X1LIM(KPAR+4),X2LIM(KPAR+4))
                  WRITE(6,1048)KPAR+4,A(KPAR+4),STAT1
                  STAT1 = STATUS(VTABLE(KPAR+5),KPAR+5,
     &                 LTABLE(KPAR+5),X1LIM(KPAR+5),X2LIM(KPAR+5))
                  WRITE(6,1049)KPAR+5,A(KPAR+5),STAT1
                  STAT1 = STATUS(VTABLE(KPAR+6),KPAR+6,
     &                 LTABLE(KPAR+6),X1LIM(KPAR+6),X2LIM(KPAR+6))
                  WRITE(6,1050)KPAR+6,A(KPAR+6),STAT1
                  CALL FLUSH(6)
               ENDIF
            ENDIF
            KPAR = KPAR + NPKPAR
 32      CONTINUE
         IF(.NOT.AUTO)THEN
            WRITE(6,1070)NBAK
            CALL FLUSH(6)
            DO 33 K=KPAR+1,KPAR+NBAK+1
               STAT1 = STATUS(VTABLE(K),K,LTABLE(K),X1LIM(K),X2LIM(K))
               WRITE(6,1080)K,KPAR+NBAK+1-K,A(K),STAT1
               CALL FLUSH(6)
 33         CONTINUE
            K = KPAR + NBAK + 1
            IF(FEXP.GT.0)THEN
               WRITE(6,1090)
               CALL FLUSH(6)
               STAT1 = STATUS(VTABLE(K+1),K+1,LTABLE(K+1),X1LIM(K+1),
     &              X2LIM(K+1))
               STAT2 = STATUS(VTABLE(K+2),K+2,LTABLE(K+2),X1LIM(K+2),
     &              X2LIM(K+2))
               WRITE(6,1100)K+1,A(K+1),STAT1,K+2,A(K+2),STAT2
               CALL FLUSH(6)
            ENDIF
            IF(LATCON)THEN
               WRITE(6,1105)
               CALL FLUSH(6)
               STAT1 = STATUS(VTABLE(KORIG),KORIG,LTABLE(KORIG),
     &              X1LIM(KORIG),X2LIM(KORIG))
               WRITE(6,1107)KORIG,XORIG,STAT1
               CALL FLUSH(6)
            ENDIF
            WRITE(6,'(1X)')
            CALL FLUSH(6)
         ENDIF
 34      IF(.NOT.AUTO)THEN
            WRITE(6,'(1X,A3,1X,A7,$)')'200','SETUP: '
            CALL FLUSH(6)
            CALL RDCOMF(5,WRD,NW,VAL,NV,ITEM,10,10,10,IRC)
            IF(IRC.EQ.2)THEN
               IFLAG = -2
               RETURN
            ENDIF
         ELSE
            IRC = 1
         ENDIF
         IF(.NOT.STEP)THEN
C
C========Initialize Levenberg-Marquardt parameter and no. of steps
C
            ALAMDA = -1.0
            CONVGD = .FALSE.
            ISTEP = 1
         ENDIF
         IF(IRC.EQ.1)THEN
            STEP = .FALSE.
            ITMAX = ISTEP + 50
            GOTO 40
         ENDIF
         CALL UPPER(WRD(1),10)
         IF(WRD(1)(1:2).EQ.'^D')THEN
            IFLAG = -2
            RETURN
         ELSEIF(WRD(1)(1:3).EQ.'RUN')THEN
            STEP = .FALSE.
            ITMAX = ISTEP + 50
            GOTO 40
         ELSEIF(WRD(1)(1:3).EQ.'SET')THEN
            STEP = .FALSE.
            IF(NW.GT.1)THEN
               CALL UPPER(WRD(2),10)
               IF(WRD(2)(1:3).EQ.'ORI')THEN
                  IF(NV.GT.0)XORIG = DBLE(VAL(1))
                  IF(LATCON)THEN
                     IF(VTABLE(KORIG).NE.0)THEN
                        A(VTABLE(KORIG)) = XORIG
                        VTABLE(KORIG) = 0
                        LTABLE(KORIG) = 0
                        MFIT = MFIT - 1
                     ENDIF
                  ENDIF
               ENDIF
            ELSEIF(NV.GT.0)THEN
               NV1 = NINT(VAL(1))
               IF(VTABLE(NV1).EQ.NV1)MFIT = MFIT - 1
               IF(NV.GE.1)THEN
                  VTABLE(NV1) = 0
                  LTABLE(NV1) = 0
               ENDIF
               IF(NV.EQ.2)A(NV1) = DBLE(VAL(2))
               IF(NV1.EQ.KORIG)XORIG = A(NV1)
            ENDIF
         ELSEIF(WRD(1)(1:3).EQ.'INI')THEN
            STEP = .FALSE.
            IF(NV.GT.0)THEN
               NV1 = NINT(VAL(1))
               IF(NV.EQ.2.AND.VTABLE(NV1).GT.0)THEN
                  A(VTABLE(NV1)) = DBLE(VAL(2))
                  IF(NV1.EQ.KORIG)XORIG = A(NV1)
               ENDIF
               IF(NW.GT.1)THEN
                  CALL UPPER(WRD(2),10)
                  IF(WRD(2)(1:3).EQ.'ORI'.AND.NV.GE.1)THEN
                     XORIG = DBLE(VAL(1))
                     IF(LATCON)THEN
                        IF(VTABLE(KORIG).GT.0)A(VTABLE(KORIG)) = XORIG
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ELSEIF(WRD(1)(1:3).EQ.'FRE')THEN
            STEP = .FALSE.
            IF(NV.GT.0)THEN
               NV1 = NINT(VAL(1))
               IF(VTABLE(NV1).NE.NV1)THEN
                  VTABLE(NV1) = NV1
                  MFIT = MFIT + 1
               ENDIF
               LTABLE(NV1) = 0
            ELSEIF(NW.GT.1)THEN
               CALL UPPER(WRD(2),10)
               IF(WRD(2)(1:3).EQ.'ORI')THEN
                  IF(VTABLE(KORIG).EQ.0)THEN
                     VTABLE(KORIG) = KORIG
                     MFIT = MFIT + 1
                  ENDIF
                  LTABLE(KORIG) = 0
               ENDIF
            ENDIF
         ELSEIF(WRD(1)(1:3).EQ.'TIE')THEN
            STEP = .FALSE.
            IF(NV.GE.1)NV1 = NINT(VAL(1))
            IF(NV.GE.2)THEN
               NV2 = NINT(VAL(2))
               IF(NV1.GT.NV2)THEN
                  IF(VTABLE(NV1).EQ.NV1)MFIT = MFIT - 1
                  VTABLE(NV1) = VTABLE(NV2)
                  LTABLE(NV1) = 0
               ELSEIF(NV2.GT.NV1)THEN                
                  IF(VTABLE(NV2).EQ.NV2)MFIT = MFIT - 1
                  VTABLE(NV2) = VTABLE(NV1)
                  LTABLE(NV2) = 0
                  NV1 = NV2
               ENDIF
               IF(NW.GT.1)THEN
                  CALL UPPER(WRD(2),10)
                  IF(WRD(2)(1:3).EQ.'HEX')THEN
                     FTABLE(NV1) = 1
                     X1COM(NV1) = DBLE(VAL(3))
                     X2COM(NV1) = DBLE(VAL(4))
                     IF(.NOT.LATCON)THEN
                        MA = MA + 1
                        KORIG = MA
                        A(KORIG) = XORIG
                        VTABLE(KORIG) = KORIG
                        LTABLE(KORIG) = 0
                        MFIT = MFIT + 1
                        LATCON = .TRUE.
                     ENDIF
                  ELSEIF(WRD(2)(1:3).EQ.'TET')THEN
                     FTABLE(NV1) = 2
                     X1COM(NV1) = DBLE(VAL(3))
                     X2COM(NV1) = DBLE(VAL(4))
                     IF(.NOT.LATCON)THEN
                        MA = MA + 1
                        KORIG = MA
                        A(KORIG) = XORIG
                        VTABLE(KORIG) = KORIG
                        LTABLE(KORIG) = 0
                        MFIT = MFIT + 1
                        LATCON = .TRUE.
                     ENDIF
                  ELSEIF(WRD(2)(1:3).EQ.'CUB')THEN
                     FTABLE(NV1) = 3
                     X1COM(NV1) = DBLE(VAL(3))
                     X2COM(NV1) = DBLE(VAL(4))
                     X3COM(NV1) = DBLE(VAL(5))
                     IF(.NOT.LATCON)THEN
                        MA = MA + 1
                        KORIG = MA
                        A(KORIG) = XORIG
                        VTABLE(KORIG) = KORIG
                        LTABLE(KORIG) = 0
                        MFIT = MFIT + 1
                        LATCON = .TRUE.
                     ENDIF
                  ENDIF
               ENDIF
            ELSEIF(NV.EQ.1)THEN
               IF(NW.EQ.2)THEN
                  CALL UPPER(WRD(2),10)
                  IF(WRD(2)(1:3).EQ.'ORI')THEN
                     IF(VTABLE(NV1).EQ.NV1)MFIT = MFIT - 1
                     VTABLE(NV1) = VTABLE(KORIG)
                  ENDIF
               ENDIF
            ENDIF
         ELSEIF(WRD(1)(1:3).EQ.'DEL')THEN
            STEP = .FALSE.
            IF(NV.GT.1)THEN
               NV1 = NINT(VAL(1))
               IF(VTABLE(NV1).GT.0)THEN
                  NV2 = VTABLE(NV1)
                  LTABLE(NV2) = 1
                  IF(NV.EQ.2)THEN
                     X1LIM(NV2) = MIN(A(NV2)-DBLE(VAL(2)),
     &                                 A(NV2)+DBLE(VAL(2)))
                     X2LIM(NV2) = MAX(A(NV2)-DBLE(VAL(2)),
     &                                A(NV2)+DBLE(VAL(2)))
                  ELSE
                     X1LIM(NV2) = MIN(VAL(2),VAL(3))
                     X2LIM(NV2) = MAX(VAL(2),VAL(3))
                  ENDIF
               ENDIF
            ENDIF
         ELSEIF(WRD(1)(1:3).EQ.'PLO')THEN
            STEP = .FALSE.
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c            CALL ERASE
c            CALL DEFPEN
c            CALL FULL
c            CALL SCALES
c            CALL LINCOL(3)
c            CALL PTJOIN(XPOS,BUF,IXMINF,IXMAXF,1)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            CALL PGBBUF
            CALL PGPAGE
            CALL PGSCI(1)
            CALL PGSLS(1)
            CALL PGBOX('BCNST',0.0,0,'BCNSTV',0.0,0)
            CALL PGSCI(3)
            CALL PGLINE(IXMAXF-IXMINF+1,XPOS(IXMINF),BUF(IXMINF))
            CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            IF(NBAK.GE.0.OR.FEXP.GT.0)THEN
               NSELPK = -1
               CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
            ENDIF
            DO 38 K=1,NPEAKS
               NSELPK = K
               CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
 38         CONTINUE
            NSELPK = 0
            CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
         ELSEIF(WRD(1)(1:3).EQ.'STE')THEN
            STEP = .TRUE.
            ITMAX = ISTEP
            GOTO 40
         ELSEIF(WRD(1)(1:3).EQ.'PRI')THEN
            GOTO 31
         ELSE
            WRITE(6,2030)
            CALL FLUSH(6)
         ENDIF
         IF(.NOT.AUTO)GOTO 34
 40      K = 0
         DO 42 J=1,MA
            IF(VTABLE(J).EQ.J)THEN
               K = K + 1
               LISTA(K) = J
            ENDIF
 42      CONTINUE
         IF(.NOT.AUTO)THEN
            WRITE(6,1046)MFIT
            CALL FLUSH(6)
         ENDIF
C
C========Prepare for least-squares fit
C
         J = 0
         IF(LATCON)A(KORIG) = XORIG
         DO 45 I=IXMINF,IXMAXF
            J = J + 1
            XFIT(J) = XPOS(I)
            YFIT(J) = BUF(I)
            SFIT(J) = SIG(I)
 45      CONTINUE
         NLSQ = J
         NSELPK = 0
C
C========Do fitting 
C
         DO 50 I=ISTEP,ITMAX
            CALL MRQMIN(XFIT,YFIT,SFIT,NLSQ,A,MA,LISTA,MFIT,COVAR,ALPHA,
     &                  MAXPAR,CHISQ,FUNCS,ALAMDA)
C
C========Convergence test
C
            IF(I.GT.1)THEN
               IF(ALAMDA.LT.0.0)THEN
                  TEMP = (OCHISQ-CHISQ)*FLOAT(IXMAXF-IXMINF)/CHISQ
                  CHISQ = OCHISQ
                  ALAMDA = -ALAMDA
                  IF(ABS(TEMP).LT.CHITST)THEN
                     WRITE(6,1055)I
                     CALL FLUSH(6)
                     CONVGD = .TRUE.
                     GOTO 55
                  ENDIF
               ENDIF
            ENDIF
            OCHISQ = CHISQ
 50      CONTINUE
         WRITE(6,1060)I-1
         CALL FLUSH(6)
 55      IF(NLSQ.GT.MFIT)THEN
            ESTD = SQRT(CHISQ/FLOAT(NLSQ-MFIT))
         ELSE
            ESTD = 0.0
         ENDIF
         WRITE(6,1065)CHISQ,ESTD
         CALL FLUSH(6)
         IF(.NOT.STEP.AND.(CONVGD.OR.I.EQ.ITMAX+1))THEN
            ENDLAM = 0.0
            CALL MRQMIN(XFIT,YFIT,SIG,NLSQ,A,MA,LISTA,MFIT,COVAR,ALPHA,
     &           MAXPAR,CHISQ,FUNCS,ENDLAM) 
            DO 57 J=1,MA
               IF(VTABLE(J).EQ.J)THEN
                  ASTDER(J) = DBLE(ESTD)*SQRT(COVAR(J,J))
               ELSE
                  ASTDER(J) = 0.0D0
               ENDIF
 57         CONTINUE
            RETRY = .FALSE.
            IF(AUTO)THEN
               IF(CHISQ.GT.FACTOR*PRECHI)THEN
                  WRITE(6,2040)FACTOR
                  AUTO = .FALSE.
                  RETRY = .TRUE.
               ENDIF
            ENDIF
            PRECHI = CHISQ
         ENDIF
C
C========Plot results of fit
C
         XMAPF = XMINF + (XMAXF-XMINF)*ASPECT
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c         CALL ERASE
c         CALL MAP(XMINF,XMAPF,YMIN,YMAX)
c         CALL WINDOW(XMINF,XMAXF,YMIN,YMAX)
c         CALL DEFPEN
c         CALL FULL
c         CALL SCALES
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         CALL PGBBUF
         CALL PGPAGE
         CALL PGSWIN(XMINF,XMAXF,YMIN,YMAX)
         CALL PGSCI(1)
         CALL PGSLS(1)
         CALL PGBOX('BCNST',0.0,0,'BCNSTV',0.0,0)
         CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         NSELPK = 0
         CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c         CALL LINCOL(3)
c         CALL PTPLOT(XPOS,BUF,IXMINF,IXMAXF,MARKER)
c         CALL PICNOW
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         CALL PGBBUF
         CALL PGSCI(3)
         CALL PGPT(IXMAXF-IXMINF+1,XPOS(IXMINF),BUF(IXMINF),MARKER)
         CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C========Plot background
C
         IF(NBAK.GE.0)THEN
            NSELPK = -1
            CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
         ENDIF
C
C========Plot individual peaks
C
         IF(NPEAKS.GT.1)THEN
            DO 110 J=1,NPEAKS
               NSELPK = J
               CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
 110        CONTINUE
         ENDIF
C
C========Return to setup prompt having done a step
C
         IF(STEP)THEN
            ISTEP = ISTEP + 1
            GOTO 34
         ENDIF
C
C========Give user the option to try again
C
         IF(.NOT.AUTO)CALL ASK('706 Try again',RETRY,0)
         IF(RETRY)THEN
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c            CALL ERASE
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            CALL PGPAGE
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            XMIN = XMINF
            XMAX = XMAXF
            GOTO 5
         ENDIF
      ELSE
         XMINF = XMIN
         XMAXF = XMAX
      ENDIF
      IFLAG = 0
9999  RETURN
C
 1000 FORMAT(1X,'803',
     &       1X,'First and last channels [',I4,',',I4,']: ',$) 
 1005 FORMAT(1X,'804',
     &       1X,'Min. and max. Y values [',G12.5,',',G12.5,']: ',$)
 1007 FORMAT(/1X,'600'/
     &       1X,'Position the cursor at the limits of the region'/
     &       1X,'Click on any mouse button to mark a limit'/
     &       1X,'200',
     &       1X,'Waiting for region selection...')
 1010 FORMAT(/1X,'200',
     &       1X,'Region selected'/
     &       1X,'Channels  [',I4,',',I4,']    X  [',G12.5,',',G12.5,']')     
 1015 FORMAT(/1X,'600'/
     &       1X,'Press keys while focus is in the GHOST window'//
     &       1X,'Peak type selection'/
     &       1X,'Gaussian ...................... g'/
     &       1X,'Cauchy (Lorentzian) ........... c'/
     &       1X,'Pearson VII ................... p'/
     &       1X,'Voigt ......................... v'/
     &       1X,'Debye Gaussian polymer ........ d'/
     &       1X,'Double exponential ............ x'/
     &       1X,'Liebler diblock copolymer...... l'//
     &       1X,'Background polynomial degree .. 0 - 4'/
     &       1X,'Exponential background ........ e'/)
 1016 FORMAT(1X,'200',
     &       1X,'Current peak type is ',A12)
 1017 FORMAT(1X,'200',
     &       1X,'Current background polynomial order is ',I2)
 1018 FORMAT(1X,'200',
     &       1X,'No exponential background component'/)
 1019 FORMAT(1X,'200',
     &       1X,'Exponential background selected')
 1020 FORMAT(1X,'600'/
     &       1X,'Button 1 - Select peak position and width'/
     &       1X,'Position = X position of cursor'/
     &       1X,'Width    = Y position of cursor'/
     &       1X,'Button 3 - End selection'/)
 1030 FORMAT(/1X,'200',
     &       1X,'Number of peaks selected ',I3)
 1040 FORMAT(1X,'400',
     &       1X,'FPLOT: Error - too many parameters')
 1041 FORMAT(1X,'Peak ',I3,4X,A12)
 1042 FORMAT(1X,'Parameter ',I3,3X,'Height    ',G12.5,4X,A40)
 1043 FORMAT(1X,'Parameter ',I3,3X,'Position  ',G12.5,4X,A40)
 1044 FORMAT(1X,'Parameter ',I3,3X,'Width     ',G12.5,4X,A40)
 1045 FORMAT(1X,'Parameter ',I3,3X,'Shape     ',G12.5,4X,A40)
 1046 FORMAT(1X,'200',
     &       1X,'Total number of parameters to fit ',I3)
 1047 FORMAT(1X,'Parameter ',I3,3X,'Length    ',G12.5,4X,A40)
 1048 FORMAT(1X,'Parameter ',I3,3X,'Number    ',G12.5,4X,A40)
 1049 FORMAT(1X,'Parameter ',I3,3X,'Fraction  ',G12.5,4X,A40)
 1050 FORMAT(1X,'Parameter ',I3,3X,'Flory     ',G12.5,4X,A40)
 1055 FORMAT(/1X,'200',
     &       1X,'Convergence achieved after ',I3,' iterations')
 1060 FORMAT(1X,'200',
     &       1X,'No convergence after ',I3,' iterations')
 1065 FORMAT(1X,'200',
     &       1X,'Chi-squared = ',G12.5,4X,'Standard Error = ',G12.5/)
 1070 FORMAT(/1X,'Polynomial background degree = ',I2)
 1080 FORMAT(1X,'Parameter ',I3,3X,'a',I1,8X,G12.5,4X,A40)
 1090 FORMAT(/1X,'Exponential background component')
 1100 FORMAT(1X,'Parameter ',I3,3X,'Coeff     ',G12.5,4X,A40/
     &       1X,'Parameter ',I3,3X,'Decay     ',G12.5,4X,A40)
 1105 FORMAT(/1X,'Lattice constraints')
 1107 FORMAT(1X,'Parameter ',I3,3X,'Origin    ',G12.5,4X,A40)
 1110 FORMAT(/1X,'900',
     &       1X,'Set up parameter values/dependencies. Use keywords - '/
     &       1X,'TIE refinement of two parameters together',
     &       5X,'e.g. tie 6 3 or tie 5 2 hex 1 1'/
     &       1X,'SET the value of a parameter             ',
     &       5X,'e.g. set 2 50.0 or set origin 10.0'/
     &       1X,'INItialize the value of a parameter      ',
     &       5X,'e.g. ini 1 1000.0 or ini origin 10.0'/
     &       1X,'FREe a parameter for refinement          ',
     &       5X,'e.g. fre 2 or fre origin'/
     &       1X,'DELta sets range of a free parameter     ',
     &       5X,'e.g. del 2 0.5 or del origin 1.0'/
     &       1X,'PLOt to replot with current values'/
     &       1X,'STEp to perform one fitting iteration ',
     &       1X,'(hit return for subsequent steps)'/
     &       1X,'PRInt to print current parameters'/
     &       1X,'RUN or <CTRL-D> to exit set-up and run')
 2000 FORMAT(1X,'Enter background polynomial order [',I2,']: ',$)
 2010 FORMAT(1X,'400 Numeric input expected')
 2030 FORMAT(1X,'Unrecognised command')
 2040 FORMAT(1X,'300',
     &       1X,'Current Chi-squared > ',F5.1,2X,'times previous')
      END                  


      CHARACTER*40 FUNCTION STATUS(KDEP,K,LTAB,X1,X2)
      IMPLICIT NONE
      INTEGER KDEP,K,LTAB
      DOUBLE PRECISION X1,X2
      IF(KDEP.GT.0)THEN
         IF(KDEP.EQ.K)THEN
            IF(LTAB.EQ.0)THEN
               WRITE(STATUS,1000)
            ELSE
               WRITE(STATUS,1005)X1,X2
            ENDIF
         ELSE
            WRITE(STATUS,1010)KDEP
         ENDIF
      ELSE
         WRITE(STATUS,1020)
      ENDIF
      RETURN
 1000 FORMAT('Free      ',30X)
 1005 FORMAT('Range   ',G12.5,'   to   ',G12.5)
 1010 FORMAT('Tied to',I3,30X)
 1020 FORMAT('Set       ',30X)
      END


      SUBROUTINE PLPEAK(IXMINF,IXMAXF,XPOS,MA,NPK,A,DYDA)
      IMPLICIT NONE
      INCLUDE 'FIT.COM'
      INTEGER IXMINF,IXMAXF,MA,NPK
      DOUBLE PRECISION A(MA),DYDA(MA)
      INTEGER I
      DOUBLE PRECISION X,Y
      REAL XPOS(MAXDIM),YFIT(MAXDIM)
      DO 10 I=IXMINF,IXMAXF
         X = DBLE(XPOS(I))
         CALL FUNCS(X,A,Y,DYDA,MA)
         YFIT(I) = SNGL(Y)
 10   CONTINUE
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CALL PGBBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IF(NPK.GE.0)THEN
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c         CALL LINCOL(2)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         CALL PGSCI(2)
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         IF(NPK.EQ.0)THEN
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c            CALL FULL
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            CALL PGSLS(1)
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         ELSE
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c            CALL BROKEN(4,15,4,15)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            CALL PGSLS(4)
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         ENDIF
      ELSE
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c         CALL LINCOL(4)
c         CALL BROKEN(10,10,10,10)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         CALL PGSCI(4)
         CALL PGSLS(2)
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ENDIF
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      CALL CURVEO(XPOS,YFIT,IXMINF,IXMAXF)
c      CALL PICNOW
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CALL PGLINE(IXMAXF-IXMINF+1,XPOS(IXMINF),YFIT(IXMINF))
      CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      RETURN
      END


      SUBROUTINE LOCATE(XX,N,JLO,JHI,X,J)
      IMPLICIT NONE
      INTEGER N
      REAL XX(N),X
      INTEGER JLO,JHI,J
      INTEGER JL,JU,JM
      JL = JLO - 1
      JU = JHI + 1
 10   IF(JU-JL.GT.1)THEN
         JM = (JU+JL)/2
         IF((XX(JHI).GT.XX(JLO)).EQV.(X.GT.XX(JM)))THEN
            JL = JM
         ELSE
            JU = JM
         ENDIF
         GOTO 10
      ENDIF
      J = JL
      IF(J.EQ.0)J = 1
      RETURN
      END













C     LAST UPDATE 15/02/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION PSNINT(A1,A3,A4)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is Pearson VII. The amplitude. centre and widths of 
C          the Pearson VII are stored in consecutive locations of A: 
C          A(1) = B,  A(2) = E,  A(3) = G1, A(4) = G2
C          This function returns the integrated area under the curve.
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameter:
C
      DOUBLE PRECISION PI,TINY
      PARAMETER (PI=3.14159265359D0,TINY=1.0D-10)
C
C Arguments:
C
      DOUBLE PRECISION A1,A3,A4
C
C Local variables:
C
      INTEGER N,I
      DOUBLE PRECISION FRAC,ARG
      REAL A,B,SS
C
C External function:
C
      REAL POWCOS
      EXTERNAL POWCOS
C
C Common block:
C
      DOUBLE PRECISION DEL
      COMMON /PSNCOM/ DEL
C
C-----------------------------------------------------------------------
C
      IF(A4.LT.TINY)RETURN
      B = SNGL(PI/2.0D0)
      A = -B
      FRAC = 1.0D0
      IF(A4.LT.1.0D0)THEN
         DEL = 2.0D0*(A4-1.0D0)
c      ELSEIF(A4.GT.1.0D3)THEN
c         DEL = 0.0
      ELSE
         N = INT(A4-1.0D0)
         ARG = DBLE(N)
         DEL = 2.0D0*(A4-ARG-1.0D0)
         DO 10 I=1,2*N,2
            ARG = DBLE(I)
            FRAC = FRAC*(ARG+DEL)/(ARG+DEL+1.0D0)
 10      CONTINUE
      ENDIF
      IF(DEL.LT.TINY)THEN
         SS = SNGL(PI)
      ELSE
         CALL QGAUS(POWCOS,A,B,SS)
      ENDIF
      FRAC = FRAC/(2.0D0*SQRT(2.0D0**(1.0D0/A4)-1.0D0))
      PSNINT = SNGL(A1*A3*FRAC)*SS
      RETURN
      END

      REAL FUNCTION POWCOS(X)
      REAL X
      DOUBLE PRECISION CX
      DOUBLE PRECISION DEL
      COMMON /PSNCOM/ DEL
      CX = DBLE(COS(X))
      POWCOS = SNGL(CX**DEL)
      RETURN
      END
C     LAST UPDATE 07/08/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION VGTINT(A1,A3,A4)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is a Voigtian. The amplitude. centre and widths of 
C          the Voigtian are stored in consecutive locations of A: 
C          A(1) = H,  A(2) = E,  A(3) = G, A(4) = P
C          This function returns the integrated area under the curve.
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY,FACTOR
      PARAMETER(TINY=1.0D-10,FACTOR=1.66510922231D0)
C
C Arguments:
C
      DOUBLE PRECISION A1,A3,A4
C
C Local variables:
C
      INTEGER I
      DOUBLE PRECISION  PI,PMA,PMA2,RM,RN,RA,RB,RC,SUM,W,P
      DOUBLE PRECISION  ALPHA(4),BETA(4),GAMMA(4),DELTA(4)
C
C Common block:
C
      DOUBLE PRECISION VCOM
      COMMON /VGTCOM/ VCOM
      SAVE /VGTCOM/
C
C Data:
C
      DATA PI    /3.1415926536D0/
      DATA ALPHA /-1.2150D0,-1.3509D0,-1.2150D0,-1.3509D0/,
     &     BETA  / 1.2359D0, 0.3786D0,-1.2359D0,-0.3786D0/,
     &     GAMMA /-0.3085D0, 0.5906D0,-0.3085D0, 0.5906D0/,
     &     DELTA / 0.0210D0,-1.1858D0,-0.0210D0, 1.1858D0/
C
C-----------------------------------------------------------------------
      IF(A3.LT.TINY)A3 = TINY
      W = A3/FACTOR
      P = A4/2.0D0
      SUM = 0.0D0
      RC = 1.0D0
      DO 10 I=1,4
         PMA = P - ALPHA(I)
         PMA2 = PMA*PMA
         RB = -BETA(I)
         RM = DELTA(I)
         RN = GAMMA(I)*PMA + DELTA(I)*RB
         RA = PMA2 + RB*RB
         SUM = SUM + (RN*RC-RM*RB)/(RC*SQRT(RA*RC-RB*RB))
 10   CONTINUE
      SUM = SUM*PI*A1*W/VCOM
      VGTINT = SNGL(SUM)
C
      RETURN
      END
      

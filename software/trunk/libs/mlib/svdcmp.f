C     LAST UPDATE 10/12/92
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SVDCMP(A,M,N,MP,NP,W,V)
      IMPLICIT NONE
C
C Purpose: Given a matrix A with logical dimensions M by N and physical
C          dimensions MP by NP, this routine computes its singular value
C          decomposition, A = U.W.V(T). The matrix U replaces A on output.
C          The diagonal matrix of singular values W is output as a
C          vector W . The matrix V (not transpose(V)) is output as V. M
C          must be greater than or equal to N; if it is smaller, then A
C          should be filled up to square with zero rows.
C
      INTEGER M,N,MP,NP
      REAL A(MP,NP),W(NP),V(NP,NP)
C
C Calls   0:
C Called by: 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER NMAX
      PARAMETER(NMAX=5000)
      REAL RV1(NMAX)
      REAL S,F,G,H,C,X,Y,Z,ANORM,SCALE,TOL
      PARAMETER(TOL=1.0E-06)
      INTEGER I,J,K,L,NM,ITS,JJ
C
C---------------------------------------------------------------------
      G = 0.0
      SCALE = 0.0
      ANORM = 0.0
      DO 150 I=1,N
         L = I + 1
         RV1(I) = SCALE*G
         G = 0.0
         S = 0.0
         SCALE = 0.0
         IF(I.LE.M)THEN
            DO 10 K=I,M
               SCALE = SCALE + ABS(A(K,I))
 10         CONTINUE
            IF(ABS(SCALE).GT.0.0)THEN
               DO 20 K=I,M
                  A(K,I) = A(K,I)/SCALE
                  S = S + A(K,I)*A(K,I)
 20            CONTINUE
               F = A(I,I)
               G = -SIGN(SQRT(S),F)
               H = F*G - S
               A(I,I) = F - G
               IF(I.NE.N)THEN
                  DO 50 J=L,N
                     S = 0.0
                     DO 30 K=I,M
                        S = S + A(K,I)*A(K,J)
 30                  CONTINUE
                     F = S/H
                     DO 40 K=I,M
                        A(K,J) = A(K,J) + F*A(K,I)
 40                  CONTINUE
 50               CONTINUE
               ENDIF
               DO 60 K=I,M
                  A(K,I) = SCALE*A(K,I)
 60            CONTINUE
            ENDIF
         ENDIF
         W(I) = SCALE*G
         G = 0.0
         S = 0.0
         SCALE = 0.0
         IF((I.LE.M).AND.(I.NE.N))THEN
            DO 70 K=L,N
               SCALE = SCALE + ABS(A(I,K))
 70         CONTINUE
            IF(ABS(SCALE).GT.0.0)THEN
               DO 80 K=L,N
                  A(I,K) = A(I,K)/SCALE 
                  S = S + A(I,K)*A(I,K)
 80            CONTINUE
               F = A(I,L)
               G = -SIGN(SQRT(S),F)
               H = F*G - S
               A(I,L) = F - G
               DO 90 K=L,N
                  RV1(K) = A(I,K)/H
 90            CONTINUE
               IF(I.NE.M)THEN
                  DO 130 J=L,M
                     S = 0.0
                     DO 110 K=L,N
                        S = S + A(J,K)*A(I,K)
 110                 CONTINUE
                     DO 120 K=L,N
                        A(J,K) = A(J,K) + S*RV1(K)
 120                 CONTINUE
 130              CONTINUE
               ENDIF
               DO 140 K=L,N
                  A(I,K) = SCALE*A(I,K)
 140           CONTINUE
            ENDIF
         ENDIF
         ANORM = MAX(ANORM,(ABS(W(I))+ABS(RV1(I))))
 150  CONTINUE
      DO 220 I=N,1,-1
         IF(I.LT.N)THEN
            IF(ABS(G).GT.0.0)THEN
               DO 160 J=L,N
                  V(J,I) = (A(I,J)/A(I,L))/G
 160           CONTINUE
               DO 190 J=L,N 
                  S = 0.0 
                  DO 170 K=L,N
                     S = S + A(I,K)*V(K,J)
 170              CONTINUE
                  DO 180 K=L,N
                     V(K,J) = V(K,J) + S*V(K,I)
 180              CONTINUE
 190           CONTINUE
            ENDIF
            DO 210 J=L,N
               V(I,J) = 0.0
               V(J,I) = 0.0
 210        CONTINUE
         ENDIF
         V(I,I) = 1.0
         G = RV1(I)
         L = I
 220  CONTINUE
      DO 290 I=N,1,-1
         L = I + 1
         G = W(I)
         IF(I.LT.N)THEN
            DO 230 J=L,N
               A(I,J) = 0.0
 230        CONTINUE
         ENDIF
         IF(ABS(G).GT.0.0)THEN
            G = 1.0/G
            IF(I.NE.N)THEN
               DO 260 J=L,N
                  S = 0.0
                  DO 240 K=L,M
                     S = S + A(K,I)*A(K,J)
 240              CONTINUE
                  F = (S/A(I,I))*G
                  DO 250 K=I,M
                     A(K,J) = A(K,J) + F*A(K,I)
 250              CONTINUE
 260           CONTINUE
            ENDIF
            DO 270 J=I,M
               A(J,I) = A(J,I)*G
 270        CONTINUE
         ELSE
            DO 280 J=I,M
               A(J,I) = 0.0
 280        CONTINUE
         ENDIF
         A(I,I) = A(I,I) + 1.0 
 290  CONTINUE
      DO 390 K=N,1,-1
         DO 380 ITS=1,50
            DO 310 L=K,1,-1
               NM = L - 1
               IF((ABS(RV1(L))+ANORM).LT.(1.0+TOL)*ANORM) GOTO 2
               IF((ABS(W(NM))+ANORM).LT.(1.0+TOL)*ANORM) GOTO 1
 310        CONTINUE
 1          C = 0.0
            S = 1.0
            DO 330 I=L,K
               F = S*RV1(I)
               RV1(I) = C*RV1(I)
               IF((ABS(F)+ANORM).LT.(1.0+TOL)*ANORM) GOTO 2
               G = W(I)
               H = SQRT(F*F+G*G)
               W(I) = H
               H = 1.0/H
               C = G*H
               S = -F*H
               DO 320 J=1,M
                  Y = A(J,NM)
                  Z = A(J,I)
                  A(J,NM) = Y*C + Z*S
                  A(J,I) = -Y*S + Z*C
 320           CONTINUE
 330        CONTINUE
 2          Z = W(K)
            IF(L.EQ.K)THEN
               IF(Z.LT.0.0)THEN
                  W(K) = -Z
                  DO 340 J=1,N
                     V(J,K) = -V(J,K)
 340              CONTINUE
               ENDIF
               GOTO 3
            ENDIF
            IF(ITS.EQ.50)WRITE(6,1000)
            X = W(L)
            NM = K - 1
            Y = W(NM)
            G = RV1(NM)
            H = RV1(K)
            F = ((Y-Z)*(Y+Z)+(G-H)*(G+H))/(2.0*H*Y)
            G = SQRT(F*F+1.0)
            F = ((X-Z)*(X+Z)+H*((Y/(F+SIGN(G,F)))-H))/X
            C = 1.0
            S = 1.0
            DO 370 J=L,NM
               I = J + 1
               G = RV1(I)
               Y = W(I)
               H = S*G
               G = G*C
               Z = SQRT(F*F+H*H)
               RV1(J) = Z
               C = F/Z
               S = H/Z
               F = X*C + G*S
               G = -X*S + G*C
               H = Y*S
               Y = Y*C
               DO 350 JJ=1,N
                  X = V(JJ,J)
                  Z = V(JJ,I)
                  V(JJ,J) = X*C + Z*S
                  V(JJ,I) = Z*C - X*S
 350           CONTINUE
               Z = SQRT(F*F+H*H)
               W(J) = Z
               IF(ABS(Z).GT.0.0)THEN
                  Z = 1.0/Z
                  C = F*Z
                  S = H*Z
               ENDIF
               F = C*G + S*Y
               X = C*Y - S*G
               DO 360 JJ=1,M
                  Y = A(JJ,J)
                  Z = A(JJ,I)
                  A(JJ,J) = Y*C + Z*S
                  A(JJ,I) = Z*C - Y*S
 360           CONTINUE
 370        CONTINUE
            RV1(L) = 0.0
            RV1(K) = F
            W(K) = X
 380     CONTINUE
 3       CONTINUE
 390  CONTINUE
      RETURN
 1000 FORMAT(1X,'GSSVD: Warning - no convergence in 50 iterations')
      END

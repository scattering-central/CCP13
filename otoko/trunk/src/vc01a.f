C
C
CC##       VC01A          25/10/74
CC NAME VC01A(R)                  CHECK
      SUBROUTINE VC01A(X,Y,W,Z,N,A,B,C,G,H,L,M,U)
C###### 25/10/74 LAST LIBRARY UPDATE
C     TAKEN FROM HARWELL SUBROUTINE LIBRARY
C     COMMON U HAS BEEN SUPPRESSED AND ADDED IN CALLING SEQUENCE
C
      DIMENSION X(1),Y(1),W(1),A(1),B(1),C(1),G(1),H(1),L(1)
      DIMENSION U(1),Z(1)
    4 FORMAT(3X,I5,5E16.6,6X,I5)
      LP=0
      EJ=0.0
      FJ=0.0
      GJ=0.0
      DO 1 I=1,N
      IV=I+N
      U(I)=SQRT(W(I))
      Z(I)=Y(I)*U(I)
      EJ=EJ+X(I)*U(I)**2
      FJ=FJ+U(I)*Z(I)
      GJ=GJ+U(I)**2
      U(IV)=0.0
    1 CONTINUE
      A(1)=EJ/GJ
      B(1)=0.0
      C(1)=FJ/GJ
      G(1)=1.0/GJ
      DO 2 J=1,M
      EJ=0.0
      FJ=0.0
      GJ=0.0
      H1=0.0
      L2=0
      DO 3 I=1,N
      Z(I)= Z(I)-C(J) *U(I)
      IV=I+N
      WS=(X(I)-A(J))*U(I)-B(J)*U(IV)
      U(IV)=U(I)
      U(I)=WS
      EJ=EJ+X(I)*U(I)**2
      FJ=FJ+U(I)*Z(I)
      GJ=GJ+U(I)**2
      H1=H1+Z(I)**2
      IF(1-I)13,3,3
   13 L2=(SIGN(1.0,-Z(I)*Z(I-1))+1.0)/2.0+L2
    3 CONTINUE
      A(J+1)=EJ/GJ
      B(J+1)=GJ*G(J)
      C(J+1)=FJ/GJ
      G(J+1)=1.0/GJ
      H(J)=H1
      L(J)=L2
    2 CONTINUE
    5 M1=M+1
      IF(LP.GT.0)WRITE(LP,20)
   20 FORMAT(1H1,8X,4HX(I),12X,4HY(I),12X,4HZ(I),//)
      H1=0.0
      L2=0
      DO 10 I=1,N
      W2=0.0
      YY=C(M+1)
      DO 101 J=1,M
      J1=M-J+1
      W1=W2
      W2=YY
      YY=C(J1)+(X(I)-A(J1))*W2-B(J1+1)*W1
  101 CONTINUE
      Z(I)=YY
      U(I)=(Z(I)-Y(I))
      H1=H1+U(I)*U(I)*W(I)
      IF(1-I)111,110,110
  111 L2=L2+(SIGN(1.0,-U(I)*U(I-1))+1.0)/2.0
  110 IF(LP.GT.0)WRITE(LP,11)X(I),Y(I),Z(I)
   10 CONTINUE
      H(M1)=H1
      L(M1)=L2
      IF(N.EQ.M1) GOTO 22
      H1=H1/(N-M1)
22    DO 21 J=1,M1
      G(J)=G(J)*H1
   21 CONTINUE
      IF(LP.LE.0)GO TO 40
      IF(LP.GT.0)WRITE(LP,7)
    7 FORMAT(1H1,61X,8HVARIANCE,10X,9HRESIDUALS)
      IF(LP.GT.0)WRITE(LP,6)
    6 FORMAT(7X,1HJ,7X,4HA(J),12X,4HB(J),12X,4HC(J),11X,7HOF C(J),6X,
     114HSUM OF SQUARES,3X,12HSIGN CHANGES)
      M1=M+1
      DO 24 I=1,M1
      II=I-1
   24 WRITE(LP,4)II,A(I),B(I),C(I),G(I),H(I),L(I)
   11 FORMAT(3E16.6)
   40 RETURN
      END

C     ==================================================================
      SUBROUTINE SFT1D( A, B, NTOT, N, NSPAN, ISN )
C     ==================================================================
C
C --- This routine calculates a one-dimensional complex multivariate
C --- Fast Fourier Transform (FFT) using a generalisation of the
C --- Cooley-Tukey algorithm due to SINGLETON,
C --- IEEE Trans Audio & Electroacoustics AU-17, 93-103 (1969).
C --- The routine works on all array sizes which factorise into PRIMES
C --- UP TO 23.
C
C --- The parameters are as follows:
C
C ---    A     a REAL array which contains the real components of the
C ---          data to be transformed.
C
C ---    B     a REAL array which contains the imaginary components of
C ---          the data to be transformed.
C
C ---    NTOT  the total number of complex values (see below).
C
C ---    N     the dimension of the current variable (see below).
C
C ---    NSPAN NSPAN/N defines the spacing of consecutive data values
C ---          while indexing the current variable (see below).
C
C ---    ISN   the sign of the transform kernel:
C ---                 ISN = -1 ==> exponent is negative (reverse).
C ---                 ISN = +1 ==> exponent is positive (forward).
C
C --- The meaning of NTOT, N and NSPAN can be understood from the
C --- following examples. (It is inportant to understand that Fortran
C --- arrays have element A(2,J,...) next to A(1,J,...) .)
C
C --- A single-variate transform with A(N) & B(N) requires one call:
C ---             CALL FFT( A, B, N, N, N, ISN )
C
C --- A bi-variate transform with A(N1,N2) & B(N1,N2) requires 2 calls:
C ---             CALL FFT( A, B, N1*N2, N1, N1,    ISN )
C ---             CALL FFT( A, B, N1*N2, N2, N1*N2, ISN )
C
C --- A tri-variate transform with A(N1,N2,N3) & B(N1,N2,N3) requires
C --- three calls:
C ---             CALL FFT( A, B, N1*N2*N3, N1, N1,       ISN )
C ---             CALL FFT( A, B, N1*N2*N3, N2, N1*N2,    ISN )
C ---             CALL FFT( A, B, N1*N2*N3, N3, N1*N2*N3, ISN )
C
C --- Note, however, that this is a very inefficient method of
C --- calculating multivariate (particularly 2-D) transforms.
C
C --- The transforms of COMPLEX arrays can also be calculated.
C --- If C is a complex array, the correct call is:
C ---             CALL FFT( C, C(2), NTOT, N, NSPAN, +/-2 )
C --- Note that the magnitude of ISN is two.
C --- The zero frequency is found in A(1),B(1) for A 1-D transform, etc.
C
C --- The error message "Array bounds exceeded"
C --- means one of two things:
C ---              the maximum prime factor is greater than 23.
C ---              the number of prime factors in N is greater than 209.
C
C --- This routine is modified from the program listing in Singletons's
C --- paper. The modifications are by Adrian Clark, Physics Dept.,
C --- Queen Elizabeth College, Campden Hill Road, London W8 7AH.
C
      DIMENSION A(1), B(1)
      DIMENSION NFAC(11), NP(209)
C
C --- The array storage allows a maximum prime of 23.
C
      DIMENSION AT(23), CK(23), BT(23), SK(23)
      EQUIVALENCE (I,II)
C
C --- The following two numbers should be equal to the array dimenions.
C
      MAXF=23
      MAXP=209
      IF(N .LT. 2) RETURN
      INC=ISN
      RAD=8.0*ATAN(1.0)
      S72=RAD/5.0
      C72=COS(S72)
      S72=SIN(S72)
      S120=SQRT(0.75)
      IF(ISN .GE. 0) GO TO 10
      S72=-S72
      S120=-S120
      RAD=-RAD
      INC=-INC
10    NT=INC*NTOT
      KS=INC*NSPAN
      KSPAN=KS
      NN=NT-INC
      JC=KS/N
      RADF=RAD*FLOAT(JC)*0.5
      I=0
      JF=0
C
C --- Determine the factors of N.
C
      M=0
      K=N
      GO TO 20
15    M=M+1
      NFAC(M)=4
      K=K/16
20    IF(K-(K/16)*16 .EQ. 0) GO TO 15
      J=3
      JJ=9
      GO TO 30
25    M=M+1
      NFAC(M)=J
      K=K/JJ
30    IF(MOD(K,JJ) .EQ. 0) GO TO 25
      J=J+2
      JJ=J**2
      IF(JJ .LE. K) GO TO 30
      IF(K .GT. 4) GO TO 40
      KT=M
      NFAC(M+1)=K
      IF(K .NE. 1) M=M+1
      GO TO 80
40    IF(K-(K/4)*4 .NE. 0) GO TO 50
      M=M+1
      NFAC(M)=2
      K=K/4
50    KT=M
      J=2
60    IF(MOD(K,J) .NE. 0) GO TO 70
      M=M+1
      NFAC(M)=J
      K=K/J
70    J=((J+1)/2)*2+1
      IF(J .LE. K) GO TO 60
80    IF(KT .EQ. 0) GO TO 100
      J=KT
90    M=M+1
      NFAC(M)=NFAC(J)
      J=J-1
      IF(J .NE. 0) GO TO 90
C
C --- Compute the Fourier transform.
C
100   SD=RADF/FLOAT(KSPAN)
      CD=2.0*SIN(SD)**2
      SD=SIN(SD+SD)
      KK=1
      I=I+1
      IF(NFAC(I) .NE. 2) GO TO 400
C
C --- Radix-2 transform.
C
      KSPAN=KSPAN/2
      K1=KSPAN+2
210   K2=KK+KSPAN
      AK=A(K2)
      BK=B(K2)
      A(K2)=A(KK)-AK
      B(K2)=B(KK)-BK
      A(KK)=A(KK)+AK
      B(KK)=B(KK)+BK
      KK=K2+KSPAN
      IF(KK .LE. NN) GO TO 210
      KK=KK-NN
      IF(KK .LE. JC) GO TO 210
      IF(KK .GT. KSPAN) GO TO 800
220   C1=1.0-CD
      S1=SD
230   K2=KK+KSPAN
      AK=A(KK)-A(K2)
      BK=B(KK)-B(K2)
      A(KK)=A(KK)+A(K2)
      B(KK)=B(KK)+B(K2)
      A(K2)=C1*AK-S1*BK
      B(K2)=S1*AK+C1*BK
      KK=K2+KSPAN
      IF(KK .LT. NT) GO TO 230
      K2=KK-NT
      C1=-C1
      KK=K1-K2
      IF(KK .GT. K2) GO TO 230
      AK=C1-(CD*C1+SD*S1)
      S1=(SD*C1-CD*S1)+S1
C
C --- The following three statements compensate for truncation errors.
C --- If rounded arithmetic is used, replace them with
C --- C1=AK
C
      C1=0.5/(AK**2+S1**2)+0.5
      S1=C1*S1
      C1=C1*AK
      KK=KK+JC
      IF(KK .LT. K2) GO TO 230
      K1=K1+INC+INC
      KK=(K1-KSPAN)/2+JC
      IF(KK .LE. JC+JC) GO TO 220
      GO TO 100
C
C --- Radix-3 transform.
C
320   K1=KK+KSPAN
      K2=K1+KSPAN
      AK=A(KK)
      BK=B(KK)
      AJ=A(K1)+A(K2)
      BJ=B(K1)+B(K2)
      A(KK)=AK+AJ
      B(KK)=BK+BJ
      AK=-0.5*AJ+AK
      BK=-0.5*BJ+BK
      AJ=(A(K1)-A(K2))*S120
      BJ=(B(K1)-B(K2))*S120
      A(K1)=AK-BJ
      B(K1)=BK+AJ
      A(K2)=AK+BJ
      B(K2)=BK-AJ
      KK=K2+KSPAN
      IF(KK .LT. NN) GO TO 320
      KK=KK-NN
      IF(KK .LE. KSPAN) GO TO 320
      GO TO 700
C
C --- Radix-4 transform.
C
400   IF(NFAC(I) .NE. 4) GO TO 600
      KSPNN=KSPAN
      KSPAN=KSPAN/4
410   C1=1.0
      S1=0
420   K1=KK+KSPAN
      K2=K1+KSPAN
      K3=K2+KSPAN
      AKP=A(KK)+A(K2)
      AKM=A(KK)-A(K2)
      AJP=A(K1)+A(K3)
      AJM=A(K1)-A(K3)
      A(KK)=AKP+AJP
      AJP=AKP-AJP
      BKP=B(KK)+B(K2)
      BKM=B(KK)-B(K2)
      BJP=B(K1)+B(K3)
      BJM=B(K1)-B(K3)
      B(KK)=BKP+BJP
      BJP=BKP-BJP
      IF(ISN .LT. 0) GO TO 450
      AKP=AKM-BJM
      AKM=AKM+BJM
      BKP=BKM+AJM
      BKM=BKM-AJM
      IF(S1 .EQ. 0.0) GO TO 460
430   A(K1)=AKP*C1-BKP*S1
      B(K1)=AKP*S1+BKP*C1
      A(K2)=AJP*C2-BJP*S2
      B(K2)=AJP*S2+BJP*C2
      A(K3)=AKM*C3-BKM*S3
      B(K3)=AKM*S3+BKM*C3
      KK=K3+KSPAN
      IF(KK .LE. NT) GO TO 420
440   C2=C1-(CD*C1+SD*S1)
      S1=(SD*C1-CD*S1)+S1
C
C --- The following three statements compensate for truncation errors.
C --- If rounede arithmetic is used, substitute:
C --- C1=C2
C
      C1=0.5/(C2**2+S1**2)+0.5
      S1=C1*S1
      C1=C1*C2
      C2=C1**2-S1**2
      S2=2.0*C1*S1
      C3=C2*C1-S2*S1
      S3=C2*S1+S2*C1
      KK=KK-NT+JC
      IF(KK .LE. KSPAN) GO TO 420
      KK=KK-KSPAN+INC
      IF(KK .LE. JC) GO TO 410
      IF(KSPAN .EQ. JC) GO TO 800
      GO TO 100
450   AKP=AKM+BJM
      AKM=AKM-BJM
      BKP=BKM-AJM
      BKM=BKM+AJM
      IF(S1 .NE. 0.0) GO TO 430
460   A(K1)=AKP
      B(K1)=BKP
      A(K2)=AJP
      B(K2)=BJP
      A(K3)=AKM
      B(K3)=BKM
      KK=K3+KSPAN
      IF(KK .LE. NT) GO TO 420
      GO TO 440
C
C --- Radix-5 transform.
C
510   C2=C72**2-S72**2
      S2=2.0*C72*S72
520   K1=KK+KSPAN
      K2=K1+KSPAN
      K3=K2+KSPAN
      K4=K3+KSPAN
      AKP=A(K1)+A(K4)
      AKM=A(K1)-A(K4)
      BKP=B(K1)+B(K4)
      BKM=B(K1)-B(K4)
      BKP=B(K1)+B(K4)
      BKM=B(K1)-B(K4)
      AJP=A(K2)+A(K3)
      AJM=A(K2)-A(K3)
      BJP=B(K2)+B(K3)
      BJM=B(K2)-B(K3)
      AA=A(KK)
      BB=B(KK)
      A(KK)=AA+AKP+AJP
      B(KK)=BB+BKP+BJP
      AK=AKP*C72+AJP*C2+AA
      BK=BKP*C72+BJP*C2+BB
      AJ=AKM*S72+AJM*S2
      BJ=BKM*S72+BJM*S2
      A(K1)=AK-BJ
      A(K4)=AK+BJ
      B(K1)=BK+AJ
      B(K4)=BK-AJ
      AK=AKP*C2+AJP*C72+AA
      BK=BKP*C2+BJP*C72+BB
      AJ=AKM*S2-AJM*S72
      BJ=BKM*S2-BJM*S72
      A(K2)=AK-BJ
      A(K3)=AK+BJ
      B(K2)=BK+AJ
      B(K3)=BK-AJ
      KK=K4+KSPAN
      IF(KK .LT. NN) GO TO 520
      KK=KK-NN
      IF(KK .LE. KSPAN) GO TO 520
      GO TO 700
C
C --- Transform for odd radices.
C
600   K=NFAC(I)
      KSPNN=KSPAN
      KSPAN=KSPAN/K
      IF(K .EQ. 3) GO TO 320
      IF(K .EQ. 5) GO TO 510
      IF(K .EQ. JF) GO TO 640
      JF=K
      S1=RAD/FLOAT(K)
      C1=COS(S1)
      S1=SIN(S1)
      IF(JF .GT. MAXF) GO TO 998
      CK(JF)=1.0
      SK(JF)=0.0
      J=1
630   CK(J)=CK(K)*C1+SK(K)*S1
      SK(J)=CK(K)*S1-SK(K)*C1
      K=K-1
      CK(K)=CK(J)
      SK(K)=-SK(J)
      J=J+1
      IF(J .LT. K) GO TO 630
640   K1=KK
      K2=KK+KSPNN
      AA=A(KK)
      BB=B(KK)
      AK=AA
      BK=BB
      J=1
      K1=K1+KSPAN
650   K2=K2-KSPAN
      J=J+1
      AT(J)=A(K1)+A(K2)
      AK=AT(J)+AK
      BT(J)=B(K1)+B(K2)
      BK=BT(J)+BK
      J=J+1
      AT(J)=A(K1)-A(K2)
      BT(J)=B(K1)-B(K2)
      K1=K1+KSPAN
      IF(K1 .LT. K2) GO TO 650
      A(KK)=AK
      B(KK)=BK
      K1=KK
      K2=KK+KSPNN
      J=1
660   K1=K1+KSPAN
      K2=K2-KSPAN
      JJ=J
      AK=AA
      BK=BB
      AJ=0.0
      BJ=0.0
      K=1
670   K=K+1
      AK=AT(K)*CK(JJ)+AK
      BK=BT(K)*CK(JJ)+BK
      K=K+1
      AJ=AT(K)*SK(JJ)+AJ
      BJ=BT(K)*SK(JJ)+BJ
      JJ=JJ+J
      IF(JJ .GT. JF) JJ=JJ-JF
      IF(K .LT. JF) GO TO 670
      K=JF-J
      A(K1)=AK-BJ
      B(K1)=BK+AJ
      A(K2)=AK+BJ
      B(K2)=BK-AJ
      J=J+1
      IF(J .LT. K) GO TO 660
      KK=KK+KSPNN
      IF(KK .LE. NN) GO TO 640
      KK=KK-NN
      IF(KK .LE. KSPAN) GO TO 640
C
C --- Multiply by rotation factor (not radices 2 & 4 - they do it
C --- themselves).
C
700   IF(I .EQ. M) GO TO 800
      KK=JC+1
710   C2=1.0-CD
      S1=SD
720   C1=C2
      S2=S1
      KK=KK+KSPAN
730   AK=A(KK)
      A(KK)=C2*AK-S2*B(KK)
      B(KK)=S2*AK+C2*B(KK)
      KK=KK+KSPNN
      IF(KK .LE. NT) GO TO 730
      AK=S1*S2
      S2=S1*C2+C1*S2
      C2=C1*C2-AK
      KK=KK-NT+KSPAN
      IF(KK .LE. KSPNN) GO TO 730
      C2=C1-(CD*C1+SD*S1)
      S1=S1+(SD*C1-CD*S1)
C
C --- The following three statements compensate for truncation errors.
C --- If rounded arithmetic is used, they may be deleted.
C
      C1=0.5/(C2**2+S1**2)+0.5
      S1=C1*S1
      C2=C1*C2
      KK=KK-KSPNN+JC
      IF(KK .LE. KSPAN) GO TO 720
      KK=KK-KSPAN+JC+INC
      IF(KK .LE. JC+JC) GO TO 710
      GO TO 100
C
C --- Permute the results to normal order...this is done in 2 stages.
C --- (i) permutation for square factors of N.
C
800   NP(1)=KS
      IF(KT .EQ. 0) GO TO 890
      K=KT+KT+1
      IF(M .LT. K) K=K-1
      J=1
      NP(K+1)=JC
810   NP(J+1)=NP(J)/NFAC(J)
      NP(K)=NP(K+1)*NFAC(J)
      J=J+1
      K=K-1
      IF(J .LT. K) GO TO 810
      K3=NP(K+1)
      KSPAN=NP(2)
      KK=JC+1
      J=1
      K2=KSPAN+1
      IF(N .NE. NTOT) GO TO 850
C
C --- Permutation for single-variate transform.
C
820   AK=A(KK)
      A(KK)=A(K2)
      A(K2)=AK
      BK=B(KK)
      B(KK)=B(K2)
      B(K2)=BK
      KK=KK+INC
      K2=KSPAN+K2
      IF(K2 .LT. KS) GO TO 820
830   K2=K2-NP(J)
      J=J+1
      K2=NP(J+1)+K2
      IF(K2 .GT. NP(J)) GO TO 830
      J=1
840   IF(KK .LT. K2) GO TO 820
      KK=KK+INC
      K2=KSPAN+K2
      IF(K2 .LT. KS) GO TO 840
      IF(KK .LT. KS) GO TO 830
      JC=K3
      GO TO 890
C
C --- Permutation for multi-variate transform.
C
850   K=KK+JC
860   AK=A(KK)
      A(KK)=A(K2)
      A(K2)=AK
      BK=B(KK)
      B(KK)=B(K2)
      B(K2)=BK
      KK=KK+INC
      K2=K2+INC
      IF(KK .LT. K) GO TO 860
      KK=KK+KS-JC
      K2=K2+KS-JC
      IF(KK .LT. NT) GO TO 850
      K2=K2-NT+KSPAN
      KK=KK-NT+JC
      IF(K2 .LT. KS) GO TO 850
870   K2=K2-NP(J)
      J=J+1
      K2=NP(J+1)+K2
      IF(K2 .GT. NP(J)) GO TO 870
      J=1
880   IF(KK .LT. K2) GO TO 850
      KK=KK+JC
      K2=KSPAN+K2
      IF(K2 .LT. KS) GO TO 880
      IF(KK .LT. KS) GO TO 870
      JC=K3
890   IF(2*KT+1 .GE. M) RETURN
      KSPNN=NP(KT+1)
C
C --- (ii) permutation for square-free factors of N.
C
      J=M-KT
      NFAC(J+1)=1
900   NFAC(J)=NFAC(J)*NFAC(J+1)
      J=J-1
      IF(J .NE. KT) GO TO 900
      KT=KT+1
      NN=NFAC(KT)-1
      IF(NN .GT. MAXP) GO TO 998
      JJ=0
      J=0
      GO TO 906
902   JJ=JJ-K2
      K2=KK
      K=K+1
      KK=NFAC(K)
904   JJ=KK+JJ
      IF(JJ .GE. K2) GO TO 902
      NP(J)=JJ
906   K2=NFAC(KT)
      K=KT+1
      KK=NFAC(K)
      J=J+1
      IF(J .LE. NN) GO TO 904
C
C --- Determine the permutation cycles of length greater than unity.
C
      J=0
      GO TO 914
910   K=KK
      KK=NP(K)
      NP(K)=-KK
      IF(KK .NE. J) GO TO 910
      K3=KK
914   J=J+1
      KK=NP(J)
      IF(KK .LT. 0) GO TO 914
      IF(KK .NE. J) GO TO 910
      NP(J)=-J
      IF(J .NE. NN) GO TO 914
      MAXF=INC*MAXF
C
C --- Re-order A & B, following the permutation cycles.
C
      GO TO 950
924   J=J-1
      IF(NP(J) .LT. 0) GO TO 924
      JJ=JC
926   KSPAN=JJ
      IF(JJ .GT. MAXF) KSPAN=MAXF
      JJ=JJ-KSPAN
      K=NP(J)
      KK=JC*K+II+JJ
      K1=KK+KSPAN
      K2=0
928   K2=K2+1
      AT(K2)=A(K1)
      BT(K2)=B(K1)
      K1=K1-INC
      IF(K1 .NE. KK) GO TO 928
932   K1=KK+KSPAN
      K2=K1-JC*(K+NP(K))
      K=-NP(K)
936   A(K1)=A(K2)
      B(K1)=B(K2)
      K1=K1-INC
      K2=K2-INC
      IF(K1 .NE. KK) GO TO 936
      KK=K2
      IF(K .NE. J) GO TO 932
      K1=KK+KSPAN
      K2=0
940   K2=K2+1
      A(K1)=AT(K2)
      B(K1)=BT(K2)
      K1=K1-INC
      IF(K1 .NE. KK) GO TO 940
      IF(JJ .NE. 0) GO TO 926
      IF(J .NE. 1) GO TO 924
950   J=K3+1
      NT=NT-KSPNN
      II=NT-INC+1
      IF(NT .GE. 0) GO TO 924
      RETURN
C
C --- Error abort: insufficient array storage.
C
998   ISN=0
      WRITE(6,999)
      STOP
999   FORMAT(36H FFT:FATAL - ARRAY BOUNDS EXCEEDED.   )
      END

      SUBROUTINE VC03A (M,N,XD,YD,WD,RD,XN,FN,GN,DN,THETA,IPRINT,W)
C
C	------------------------------------------------------------
C
C	calculate a smooth weighted least squares fit to given data
C
C	CALLS:
C		VB06A
C
C	------------------------------------------------------------
C
      REAL*8    W(1)
      DIMENSION XD(1),YD(1),WD(1),RD(1),XN(N),FN(N),GN(1),DN(1),
     1THETA(1)
      NDIMAX=N
C     OMIT DATA WITH ZERO WEIGHTS
      MM=1
      J=1
      DO 1 I=2,M
      IF (WD(I)) 3,2,3
    2 IF (I-M) 4,3,3
    4 W(J)=XD(I)
      W(J+1)=YD(I)
      W(J+2)=FLOAT(I)
      J=J+3
      GO TO 1
    3 MM=MM+1
      XD(MM)=XD(I)
      YD(MM)=YD(I)
      WD(MM)=WD(I)
    1 CONTINUE
      J=1
      K=MM
    7 IF (K-M) 5,6,6
    5 K=K+1
      XD(K)=W(J)
      YD(K)=W(J+1)
      WD(K)=W(J+2)
      J=J+3
      GO TO 7
C     INITIALIZATION OF ITERATIONS
    6 JA=1
      IF (WD(1)) 9,8,9
    8 JA=2
    9 N=5
      IF(N-NDIMAX)100,100,110
  100 XN(1)=XD(1)
      XN(5)=XD(MM)
      XN(3)=0.5*(XN(1)+XN(5))
      XN(2)=0.5*(XN(1)+XN(3))
      XN(4)=0.5*(XN(3)+XN(5))
      IW=7*MM+46
      DO 10 I=1,5
      J=IW+I
      W(J)=XN(I)
   10 CONTINUE
      IP=-IPRINT
C     CALCULATE THE HISTOGRAMS FOR NEW SCALE FACTORS
   11 J=0
      K=1
      SA=0.
   12 SA=SA+WD(K)**2
      K=K+1
      IF (XD(K)-XD(1)) 12,12,13
   13 SA=(SA+0.5*WD(K)**2)/(XD(K)-XD(1))
   14 J=J+1
      IF (XD(K)-XN(J+1)) 15,15,16
   16 GN(J)=SA*(XN(J+1)-XN(J))
      GO TO 14
   15 GN(J)=SA*(XD(K)-XN(J))+0.5*WD(K)**2
   17 K=K+1
      IF (K-MM) 18,18,19
   18 IF (XD(K)-XN(J+1)) 20,20,21
   20 GN(J)=GN(J)+WD(K)**2
      GO TO 17
   21 SA=0.5*(WD(K-1)**2+WD(K)**2)/(XD(K)-XD(K-1))
      GN(J)=GN(J)-0.5*WD(K-1)**2+SA*(XN(J+1)-XD(K-1))
      GO TO 14
C     CALCULATE THE NEW SCALE FACTORS
   19 K=IW+2
      GN(1)=0.00025216*GN(1)*(W(K)-W(K-1))**8/(XN(2)-XN(1))
      DO 22 J=3,N
      IF (XN(J)-W(K)) 23,23,24
   24 K=K+1
   23 GN(J-1)=0.00025216*GN(J-1)*(W(K)-W(K-1))**8/(XN(J)-XN(J-1))
      GN(J-2)=ALOG(GN(J-2)+GN(J-1))
   22 CONTINUE
      NN=N-2
      HS=1.386294
      DO 97 J=2,NN
      GN(J)=AMIN1(GN(J),GN(J-1)+HS)
   97 CONTINUE
      J=NN-1
   98 GN(J)=AMIN1(GN(J),GN(J+1)+HS)
      J=J-1
      IF (J) 99,99,98
   99 DO 25 J=3,N
      THETA(J-1)=SQRT(EXP(GN(J-2))/(XN(J)-XN(J-2)))
   25 CONTINUE
C     CALCULATE THE SPLINE APPROXIMATION WITH CURRENT KNOTS
      CALL VB06A (MM,N,XD,YD,WD,RD,XN,FN,GN,DN,THETA,IP,W)
C     APPLY STATISTICAL TEST FOR EXTRA KNOTS
      J=IW+1
      JJ=0
      K=JA
      TMAX=0.
      IIS=1
   26 KC=-1
      SW=0.
      SR=0.
      RP=0.
      J=J+1
      JJ=JJ+1
      W(JJ)=0.
   27 IF (W(J)-XD(K)) 28,29,30
   30 KC=KC+1
      SW=SW+RD(K)**2
      SR=SR+RP*RD(K)
      RP=RD(K)
      K=K+1
      GO TO 27
   29 IF (WD(K)) 31,28,31
   31 KC=KC+1
      SW=SW+RD(K)**2
      SR=SR+RP*RD(K)
   28 IF (SR) 32,32,33
   33 SW=(SW/SR)**2
      RP=SQRT(SR/FLOAT(KC))
      IF (FLOAT(KC)-SW) 32,32,34
   34 GO TO (35,36,37),IIS
   35 PRP=RP
      IIS=3
      IF (FLOAT(KC)-2.*SW) 38,38,39
   37 W(JJ-1)=PRP
      TMAX=AMAX1(TMAX,PRP)
   39 IIS=2
   36 W(JJ)=RP
      TMAX=AMAX1(TMAX,RP)
      GO TO 38
   32 IIS=1
   38 IF (W(J)-XN(N)) 26,40,40
C     TEST WHETHER ANOTHER ITERATION IS REQUIRED
   40 IF (TMAX) 41,41,42
C     CALCULATE NEW TREND ARRAY, INCLUDING LARGER TRENDS ONLY
   42 TMAX=0.5*TMAX
      I=0
      J=1
      JW=1
      K=IW+1
      THETA(JW)=W(K)
   43 I=I+1
      K=K+1
      IF (W(I)-TMAX) 44,44,45
   44 JW=JW+1
      THETA(JW)=W(K)
   46 FN(J)=0.
      J=J+1
      IF (W(K)-XN(J)) 47,47,46
   45 JW=JW+2
      THETA(JW-1)=0.5*(W(K-1)+W(K))
      THETA(JW)=W(K)
      IF (XN(J+1)-THETA(JW-1)) 46,46,48
   48 FN(J)=1.
      J=J+1
   47 IF (J-N) 43,49,49
C     MAKE KNOT SPACINGS BE USED FOUR TIMES
   49 IK=1
      KL=1
      FN(2)=AMAX1(FN(1),FN(2))
      GO TO 102
   50 K=KL+3
   51 IF (FN(K)) 52,52,53
   52 K=K-1
      IF (K-KL) 74,74,51
   53 K=K-1
      FN(K)=1.
      IF (K-KL) 74,74,53
  102 K=KL+3
   54 K=K+1
      IF (K-N) 55,56,56
   55 IF (XN(K+1)-XN(K)-1.5*(XN(K)-XN(K-1))) 54,54,56
   56 KU=K
      FN(K-2)=AMAX1(FN(K-2),FN(K-1))
   57 KKU=K
   58 K=K-1
      IF (K-KL) 59,59,60
   60 IF (XN(K)-XN(K-1)-1.5*(XN(K+1)-XN(K))) 58,58,61
   61 FN(K+1)=AMAX1(FN(K),FN(K+1))
   59 KKL=K
      KZ=4
      IF (FN(K)) 62,62,63
   63 K=K+1
      IF (K-KKU) 64,65,65
   64 IF (FN(K)) 66,66,63
   66 KZ=0
   62 KZ=KZ+1
      K=K+1
      IF (K-KKU) 67,65,65
   67 IF (FN(K)) 62,62,68
   68 IF (KZ-3) 69,69,70
   69 J=K-KZ
   71 FN(J)=1.
      J=J+1
      IF (J-K) 71,63,63
   70 IF (K+1-KKU) 72,65,65
   72 K=K+1
      FN(K)=1.
      GO TO 63
   65 IF (KL-KKL) 73,50,50
   73 FN(KKL-2)=AMAX1(FN(KKL-2),FN(KKL+1))
      FN(KKL-1)=AMAX1(FN(KKL-1),FN(KKL+3))
   75 K=KKL-4
   78 IF (FN(K)) 76,76,77
   76 K=K+1
      IF (K-KKL) 78,79,79
   77 FN(K)=1.
      K=K+1
      IF (K-KKL) 77,79,79
   79 GO TO (57,80),IK
   74 IF (KU-N) 81,82,82
   81 KL=KU
      FN(KL+1)=AMAX1(FN(KL+1),FN(KL-2))
      FN(KL)=AMAX1(FN(KL),FN(KL-4))
      GO TO 102
   82 IK=2
      KKL=N
      GO TO 75
C     INSERT EXTRA KNOTS FOR NEW APPROXIMATION
   80 DO 83 J=1,N
      GN(J)=XN(J)
   83 CONTINUE
      NN=1
      DO 84 J=2,N
      IF (FN(J-1)) 85,85,86
   86 NN=NN+1
      XN(NN)=0.5*(GN(J-1)+GN(J))
   85 NN=NN+1
      XN(NN)=GN(J)
   84 CONTINUE
      IF(N-NDIMAX)101,110,110
  110 WRITE(5,111)N
  111 FORMAT(///' ARRAY SIZES TOO SMALL.  N =',I6,///)
      N=-N
      GO TO 90
  101 N=NN
      IW=7*MM+8*N+6
      DO 87 J=1,JW
      I=IW+J
      W(I)=THETA(J)
   87 CONTINUE
      GO TO 11
C     RESTORE DATA WITH ZERO WEIGHTS
   41 IF (MM-M) 88,89,89
   89 IF (IPRINT) 90,90,91
   88 J=-2
      K=MM
   92 J=J+3
      K=K+1
      W(J)=XD(K)
      W(J+1)=YD(K)
      W(J+2)=WD(K)
      IF (K-M) 92,93,93
   93 I=INT(W(J+2)+0.5)
   94 IF (K-I) 95,95,96
   96 XD(K)=XD(MM)
      YD(K)=YD(MM)
      WD(K)=WD(MM)
      K=K-1
      MM=MM-1
      GO TO 94
   95 XD(K)=W(J)
      YD(K)=W(J+1)
      WD(K)=0.
      K=K-1
      J=J-3
      IF (J) 91,91,93
   91 CALL VB06A (M,N,XD,YD,WD,RD,XN,FN,GN,DN,THETA,IABS(IPRINT),W)
   90 RETURN
      END

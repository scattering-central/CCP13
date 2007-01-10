C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FFT1D (X,Y,TABLE,M,LL,ISN)
      IMPLICIT NONE
C
C Purpose:  FFT is in place DFT computation using Sande algorithm
C           and Markel pruning modification.
C
      REAL    X(1),Y(1),TABLE(1)
      INTEGER M,LL,ISN
C
C X      : Array of length 2**M used to hold real part of complex input
C Y      : Array of length 2**M used to hold imaginary part of input
C          X&Y are real and complex part of output
C TABLE  : Array of length N/4+1 (N=2**M) contains quarter length
C          cosine table.
C M      : Integer power of two which determines size of fft to be
C          performed. (bit reverse table is set for a max of N=2**12)
C LL     : Integer power of 2 which determines 2**ll actual data pts
C          and thus no. of stages in which no pruning is allowable
C ISN    :-1 for forward fft
C         +1 for reverse fft
C
C Calls   0:
C Called by: FRWFFT , INVFFT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    C,S,R,FI,T1,T2
      INTEGER L(12),L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,IARG
      INTEGER J,J1,J2,J3,J4,J5,J6,J7,J8,J9,J10,J11,JR,JN,K1,K2,K3
      INTEGER N,ND4,ND4P1,ND4P2,ND2P2,LLL,LM,LMM,LO,LI,LMX,LIX,ISCL
C
C L     :
C
      EQUIVALENCE (L12,L(1)) , (L11,L(2)) , (L10,L(3)) , (L9,L(4)) ,
     1            (L8,L(5))  , (L7,L(6))  , (L6,L(7))  , (L5,L(8)) ,
     1            (L4,L(9))  , (L3,L(10)) , (L2,L(11)) , (L1,L(12))
C
C-----------------------------------------------------------------------
      N=2**M
      ND4=N/4
      ND4P1=ND4+1
      ND4P2=ND4P1+1
      ND2P2=ND4+ND4P2
      LLL=2**LL
      DO 50 LO=1,M
         LMX=2**(M-LO)
         LMM=LMX
         LIX=2*LMX
         ISCL=N/LIX
C
C=======TEST FOR PRUNING
C
         IF (LO-M+LL) 10,20,20
  10     LMM=LLL
  20     DO 50 LM=1,LMM
            IARG=(LM-1)*ISCL+1
            IF (IARG.LE.ND4P1) GO TO 30
            K1=ND2P2-IARG
            C=-TABLE(K1)
            K3=IARG-ND4
            S=ISN*TABLE(K3)
            GO TO 40
  30        C=TABLE(IARG)
            K2=ND4P2-IARG
            S=ISN*TABLE(K2)
  40        DO 50 LI=LIX,N,LIX
               J1=LI-LIX+LM
               J2=J1+LMX
               T1=X(J1)-X(J2)
               T2=Y(J1)-Y(J2)
               X(J1)=X(J1)+X(J2)
               Y(J1)=Y(J1)+Y(J2)
               X(J2)=C*T1-S*T2
               Y(J2)=C*T2+S*T1
  50  CONTINUE
C
C========PERFORM BIT REVERSAL
C
      DO 70 J=1,12
         L(J)=1
         IF (J-M) 60,60,70
  60     L(J)=2**(M+1-J)
  70  CONTINUE
      JN=1
      DO 120 J1=1,L1
       DO 120 J2=J1,L2,L1
        DO 120 J3=J2,L3,L2
         DO 120 J4=J3,L4,L3
          DO 120 J5=J4,L5,L4
           DO 120 J6=J5,L6,L5
            DO 120 J7=J6,L7,L6
             DO 120 J8=J7,L8,L7
              DO 120 J9=J8,L9,L8
               DO 120 J10=J9,L10,L9
                DO 120 J11=J10,L11,L10
                 DO 120 JR=J11,L12,L11
                 IF (JN-JR) 80,80,90
  80             R=X(JN)
                 X(JN)=X(JR)
                 X(JR)=R
                 FI=Y(JN)
                 Y(JN)=Y(JR)
                 Y(JR)=FI
  90             IF (ISN) 110,110,100
  100            X(JR)=X(JR)/REAL(N)
                 Y(JR)=Y(JR)/REAL(N)
  110            JN=JN+1
  120 CONTINUE
      RETURN
      END

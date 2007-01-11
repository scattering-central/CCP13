C     LAST UPDATE 22/02/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      SUBROUTINE CHICAL(ALLINE,JMIN,JMAX,NLLP,NPAR,IMIN,IMAX,NIMM,IDCIN,
     &                  NDCIN,A,V,N1,N2,IBACK,CHISQ,RFAC,SIG,SIGMA,
     &                  IFLAG)
      IMPLICIT NONE
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C     .. Scalar Arguments ..
      REAL CHISQ,RFAC 
      INTEGER N1,N2,NDCIN,NIMM,NLLP,IBACK,NPAR,IFLAG
      LOGICAL SIGMA
C     ..
C     .. Array Arguments ..
      REAL A(N1,N2),V(N1,N2),ALLINE(NPAR),SIG(NPAR)
      CHARACTER*1 IDCIN(NDCIN)
      INTEGER*2 IMAX(NIMM),IMIN(NIMM),JMAX(NLLP),JMIN(NLLP)
C     ..
C     .. Common scalars..
      REAL DELR,RMIN,DELZ,ZMIN,DMIN,DMAX,SN,RADM
      INTEGER IFPIX,ILPIX,IFRAST,ILRAST,L1,L2,NR1,NR2,NLDIV,NBESS
      LOGICAL POLAR
C     ..
C     .. Local Arrays ..
      REAL B(262144)
C     ..
C     .. Local Scalars ..
      INTEGER I,II,IPOINT,J,LPOINT,MPOINT,NB,NBCK
      REAL RS,ZS,DS,PS,SUMA
      DOUBLE PRECISION X,T(4)
C     ..
C     .. Common blocks ..
      COMMON /INSPEC/ DELR,RMIN,DELZ,ZMIN,POLAR
      COMMON /DLIMIT/ DMIN,DMAX,L1,L2,NR1,NR2,SN,NLDIV,NBESS,RADM
      COMMON /IMAGE / IFPIX,ILPIX,IFRAST,ILRAST
C
C-----------------------------------------------------------------------
      IF(MOD(IBACK/16,2).EQ.1)THEN
         NBCK = 8
      ELSE
         NBCK = 0
      ENDIF
      IPOINT = 0
      MPOINT = 0
      SUMA = 0.0
      DO 20 J=1,N2
         IF(POLAR)THEN
            PS = FLOAT(J)*DELZ + ZMIN 
         ELSE
            ZS = FLOAT(J)*DELZ + ZMIN 
         ENDIF
         DO 10 I=1,N1
            II = (J-1)*N1 + I
            IF(A(I,J).GT.-0.99E+30.AND.I.GE.IFPIX.AND.I.LE.ILPIX
     &         .AND.J.GE.IFRAST.AND.J.LE.ILRAST)THEN
               B(II) = A(I,J)
               IF(MOD(IBACK/16,2).EQ.1)THEN
C
C========Subtract background
C
                  IF(POLAR)THEN
                     DS = FLOAT(I)*DELR + RMIN
                  ELSE
                     RS = FLOAT(I)*DELR + RMIN
                     DS = SQRT(RS*RS+ZS*ZS)
                     PS = ATAN2(ABS(RS),ABS(ZS))
                  ENDIF
                  X = DBLE(DS)/DBLE(DMAX)
                  T(1) = 1.0D0
                  T(2) = X
                  T(3) = 2.0D0*X*X - 1.0D0
                  T(4) = 2.0D0*X*T(3) - X
                  DO 5 NB=1,4
                     B(II) = B(II) - ALLINE(NB)*SNGL(T(NB))
                     B(II) = B(II) - ALLINE(NB+4)*COS(FLOAT(2*NB)*PS)
 5                CONTINUE
               ENDIF
               SUMA = SUMA + B(II)*B(II)/V(I,J)
            ELSE
               B(II) = -1.0E+30 
            ENDIF
 10      CONTINUE
 20   CONTINUE
C
C========Subtract peaks
C
      DO 50 LPOINT = 1,NLLP
         DO 40 J = JMIN(LPOINT),JMAX(LPOINT)
            IPOINT = IPOINT + 1
            DO 30 I = IMIN(IPOINT),IMAX(IPOINT)
               II = (J-1)*N1 + I
               MPOINT = MPOINT + 1
               IF(B(II).GT.-0.99E+30)THEN
                     B(II) = B(II) - ALLINE(NBCK+LPOINT)*
     &                       FLOAT(ICHAR(IDCIN(MPOINT)))
               ENDIF
 30         CONTINUE
 40      CONTINUE
 50   CONTINUE
C
C========Form CHISQ
C
      CHISQ = 0.0
      DO 70 J=1,N2
         DO 60 I=1,N1
            II = (J-1)*N1 + I
            IF(B(II).GT.-0.99E+30)THEN
               CHISQ = CHISQ + B(II)*B(II)/V(I,J)
            ENDIF 
 60      CONTINUE
 70   CONTINUE
      IF(SUMA.GT.0.0)THEN
         RFAC = SQRT(CHISQ/SUMA)
      ELSE
         RFAC = 0.0
      ENDIF
      IF(IFLAG.EQ.0)RETURN
C
C========Calculate individual sigmas
C
      IF(IFLAG.EQ.1)THEN 
         MPOINT = 0
         IPOINT = 0
         DO 100 LPOINT=1,NLLP
            SIG(NBCK+LPOINT) = 0.0
            SUMA = 0.0
            DO 90 J=JMIN(LPOINT),JMAX(LPOINT)
               IPOINT = IPOINT + 1
               DO 80 I=IMIN(IPOINT),IMAX(IPOINT)
                  MPOINT = MPOINT + 1
                  II = (J-1)*N1 + I
                  IF(A(I,J).GT.-0.99E+30.AND.I.GE.IFPIX.AND.I.LE.ILPIX
     &               .AND.J.GE.IFRAST.AND.J.LE.ILRAST)THEN
                     IF(SIGMA)THEN
                        SIG(NBCK+LPOINT) = SIG(NBCK+LPOINT) + V(I,J)
                     ENDIF
                     SIG(NBCK+LPOINT) = SIG(NBCK+LPOINT) + B(II)*B(II)
                     SUMA = SUMA + FLOAT(ICHAR(IDCIN(MPOINT)))
                  ENDIF
 80            CONTINUE
 90         CONTINUE
            IF(SUMA.GT.0.0)THEN
               SIG(NBCK+LPOINT) = SQRT(SIG(NBCK+LPOINT))/SUMA
            ELSE
               SIG(NBCK+LPOINT) = 0.0
            ENDIF
 100     CONTINUE
      ELSE
C
C========Calculate A(T).B for iteratve improvement of the solution
C========Form first 8 elements if MOD(IBACK/16,2) = 1
C
         DO 102 NB=1,NBCK
            SIG(NB) = 0.0
 102     CONTINUE
         IF(MOD(IBACK/16,2).EQ.1)THEN
            DO 120 J=1,N2
               IF(POLAR)THEN
                  PS = FLOAT(J)*DELZ + ZMIN
               ELSE
                  ZS = FLOAT(J)*DELZ + ZMIN 
               ENDIF
               DO 110 I=1,N1
                  II = (J-1)*N1 + I
                  IF(A(I,J).GT.-0.99E+30.AND.I.GE.IFPIX.AND.I.LE.ILPIX
     &               .AND.J.GE.IFRAST.AND.J.LE.ILRAST)THEN
                     IF(POLAR)THEN
                        DS = FLOAT(I)*DELR + RMIN
                     ELSE
                        RS = FLOAT(I)*DELR + RMIN
                        DS = SQRT(RS*RS+ZS*ZS)
                        PS = ATAN2(ABS(RS),ABS(ZS))
                     ENDIF
                     X = DBLE(DS)/DBLE(DMAX)
                     T(1) = 1.0D0
                     T(2) = X
                     T(3) = 2.0D0*X*X - 1.0D0
                     T(4) = 2.0D0*X*T(3) - X
                     DO 105 NB=1,4 
                        SIG(NB) = SIG(NB) + B(II)*SNGL(T(NB))/V(I,J)
                        SIG(NB+4) = SIG(NB+4) + 
     &                              B(II)*COS(FLOAT(2*NB)*PS)/V(I,J)
 105                 CONTINUE
                  ENDIF
 110           CONTINUE
 120        CONTINUE
         ENDIF
C
C========Form the bulk of A(T).B
C 
         MPOINT = 0
         IPOINT = 0
         DO 150 LPOINT=1,NLLP
            SIG(NBCK+LPOINT) = 0.0
            DO 140 J=JMIN(LPOINT),JMAX(LPOINT)
               IPOINT = IPOINT + 1
               DO 130 I=IMIN(IPOINT),IMAX(IPOINT)
                  MPOINT = MPOINT + 1
                  II = (J-1)*N1 + I
                  IF(A(I,J).GT.-0.99E+30.AND.I.GE.IFPIX.AND.I.LE.ILPIX
     &               .AND.J.GE.IFRAST.AND.J.LE.ILRAST)THEN
                     SIG(NBCK+LPOINT) = SIG(NBCK+LPOINT) + B(II)*
     &                                  FLOAT(ICHAR(IDCIN(MPOINT)))
     &                                  /V(I,J)
                  ENDIF
 130           CONTINUE
 140        CONTINUE
 150     CONTINUE 
      ENDIF 
      RETURN
C
      END

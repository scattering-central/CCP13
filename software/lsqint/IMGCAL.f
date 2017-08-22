C     LAST UPDATE 17/05/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE IMGCAL(ALLINE,JMIN,JMAX,NLLP,NPAR,IMIN,IMAX,NIMM,IDCIN,
     &                  NDCIN,A,B,N1,N2,IBACK,KPIC,ICAL)
      IMPLICIT NONE
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Scalar arguments:
C
      INTEGER N1,N2,NDCIN,NIMM,NLLP,NPAR,IBACK,KPIC,ICAL
C
C Array arguments:
C
      REAL A(N1*N2),B(N1*N2),ALLINE(NPAR)
      INTEGER*2 IMAX(NIMM),IMIN(NIMM),JMAX(NLLP),JMIN(NLLP)
      CHARACTER*1 IDCIN(NDCIN)
C
C Common scalars:
C
      REAL DELR,RMIN,DELZ,ZMIN,DMIN,DMAX,SN,RADM
      INTEGER L1,L2,NR1,NR2,NLDIV,NBESS
      LOGICAL POLAR
C
C Local scalars:
C
      INTEGER I,IPOINT,J,IJ,LPOINT,MPOINT,NB,NBCK,MPIC,IRC
      REAL RS,ZS,DS,PS,SUMBK,SUMPC,SUMPO,TEMP
      DOUBLE PRECISION X
C
C Local arrays:
C
      DOUBLE PRECISION T(4)
C
C Common blocks:
C
      COMMON /INSPEC/ DELR,RMIN,DELZ,ZMIN,POLAR
      COMMON /DLIMIT/ DMIN,DMAX,L1,L2,NR1,NR2,SN,NLDIV,NBESS,RADM
C
C-----------------------------------------------------------------------
      IF(MOD(IBACK/16,2).EQ.1)THEN
         NBCK = 8
      ELSE
         NBCK = 0
      ENDIF
C
C========Add background
C
      SUMBK = 0.0
      SUMPO = 0.0
      DO 20 J=1,N2
         IF(POLAR)THEN
            PS = FLOAT(J)*DELZ + ZMIN
         ELSE
            ZS = FLOAT(J)*DELZ + ZMIN 
         ENDIF
         DO 10 I=1,N1
            IJ = (J-1)*N1 + I
            IF(A(IJ).GT.-0.99E+30)THEN
               IF(MOD(IBACK/16,2).EQ.1)THEN
                  IF(POLAR)THEN
                     DS = FLOAT(I)*DELR + RMIN
                     ZS = DS*COS(PS)
                     RS = DS*SIN(PS)
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
                     B(IJ) = B(IJ) + ALLINE(NB)*SNGL(T(NB))
                     B(IJ) = B(IJ) + ALLINE(NB+4)*COS(FLOAT(2*NB)*PS)
 5                CONTINUE
                  A(IJ) = A(IJ) - B(IJ)
               ENDIF
               SUMBK = SUMBK + B(IJ)
               SUMPO = SUMPO + A(IJ)
               B(IJ) = 0.0
            ENDIF 
 10      CONTINUE
 20   CONTINUE
C
C========Write background-subtracted image to file
C
      MPIC = 2*KPIC - 1
      CALL WFRAME(ICAL,MPIC,N1,N2,A,IRC)
      IF(IRC.NE.0)THEN
         WRITE(6,1000)
         WRITE(4,1000)
         RETURN
      ENDIF
C
C========Accumulate peaks
C
      SUMPC = 0.0
      IPOINT = 0
      MPOINT = 0
      DO 50 LPOINT = 1,NLLP
         DO 40 J = JMIN(LPOINT),JMAX(LPOINT)
            IPOINT = IPOINT + 1
            DO 30 I = IMIN(IPOINT),IMAX(IPOINT)
               MPOINT = MPOINT + 1
               IJ = (J-1)*N1 + I
               IF(A(IJ).GT.-0.99E+30)THEN 
                  TEMP = ALLINE(NBCK+LPOINT)*FLOAT(ICHAR(IDCIN(MPOINT)))
                  B(IJ) = B(IJ) + TEMP 
                  SUMPC = SUMPC + TEMP 
               ENDIF 
 30         CONTINUE
 40      CONTINUE
 50   CONTINUE
C
C========Write total calculated image to file
C
      MPIC = MPIC + 1
      CALL WFRAME(ICAL,MPIC,N1,N2,B,IRC)
      IF(IRC.NE.0)THEN
         WRITE(6,1000)
         WRITE(4,1000)
         RETURN
      ENDIF
C
C========Write out sums
C
      WRITE(6,1010)SUMBK,SUMPC,SUMPO 
      WRITE(4,1010)SUMBK,SUMPC,SUMPO 
      RETURN
C
 1000 FORMAT(1X,'IMGCAL: Error writing calculated file')
 1010 FORMAT(1X,'Sum of background pixels:         ',G12.5/
     &       1X,'Sum of fitted peak pixels:        ',G12.5/
     &       1X,'Sum of observed minus background: ',G12.5)
      END

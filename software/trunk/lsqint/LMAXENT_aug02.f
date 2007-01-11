C     LAST UPDATE 03/08/02
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE LMAXENT(ITER,NPAR,NSIZE,DEFA,RSCL,TCON,CFAC,MEITS,RFAC,
     &                   SIG,E,RE,DS,DC)
      IMPLICIT NONE
C
C Purpose: Performs entropy maximization for fixed default entropy
C          according to the algorithm of Skilling and Bryan, Mon. Not.
C          R. astr. Soc. (1984) 211, 111-124. 
C
C Calls   5: TRED2  , TQLI  , RESPON , TRANSR , CHICAL
C Called by: LSQINT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C August 2002: modifications made by RCD (see email below):
C
C Dug out the paper the algorithm comes from. Went through it changing things
C in the code that didn't match the paper. Most of the differences were slight
C improvements except for one. Control of the target chi-squared on each
C iteration is determined by FRAC. In the paper this value is fixed to 2/3.
C This seems much more robust than the elaboration that was in the code. I've
C also fiddled with the tolerances to match IEEE754 arithmetic a bit better.
C My changes are in lowercase. I've replaced most of them with what was in the
C original code - it was only when I put them in that it struck me the code
C was a bit cleverer.
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER MAXDAT
      PARAMETER(MAXDAT=512*512)
      INTEGER NLLPX,JWIDTHAV,IPOINTX,IWIDTHAV,MPOINTX 
      PARAMETER(NLLPX=10000,JWIDTHAV=50)
      PARAMETER(IPOINTX=JWIDTHAV*NLLPX,IWIDTHAV=30)
      PARAMETER(MPOINTX=IWIDTHAV*IPOINTX)
c
      double precision tiny,chopmin,tweak
      parameter(tiny=1.0D-20,chopmin=4.0D-16,tweak=4.0D-12)
C
C Scalar arguments:
C
      REAL DEFA,RSCL,TCON,CFAC,RFAC
      INTEGER ITER,NPAR,NSIZE,MEITS
C
C Array arguments:
C
      REAL SIG(NPAR)
      REAL E(NPAR,3),RE(NSIZE,3),DS(NPAR),DC(NPAR)
C
C Common arrays:
C
      REAL A(MAXDAT),ALLINE(NLLPX+8),PSIG(MAXDAT)
      INTEGER ISIZE(5)
      INTEGER*2 JMIN(NLLPX),JMAX(NLLPX),IMIN(IPOINTX),IMAX(IPOINTX)
      CHARACTER*1 IDCIN(MPOINTX)
C
C Common scalars:
C
      REAL DELR,RMIN,DELZ,ZMIN
      INTEGER NPIX,NRAST,IBACK,IFPIX,ILPIX,IFRAST,ILRAST
      LOGICAL SIGMA,POLAR
C
C Local arrays:
C
      DOUBLE PRECISION G(3,3),RM(3,3),GSAVE(3,3),GM(3,3),DTMP(3,3)
      DOUBLE PRECISION S(3),C(3),GS(3),GC(3),XU(3),XUG(3)
      DOUBLE PRECISION GAMMA(3),D(3),OD(3),RMSAVE(3,3)
C
C Local scalars:
C
      INTEGER I,J,LPOINT,IJ,K,I1,J1,K1,ND,ISUC,NL,II,JJ,IFLAG
      DOUBLE PRECISION X,Y,EMIN,EMAX,ALMIN,CMIN,CTAR,CAIM,CGAP,RP,DRP,
     &                 PEN,R,DR
      DOUBLE PRECISION DSNORM,DCNORM,S0,C0,E3NORM,TEST,RATE,SUMF,TMP
      DOUBLE PRECISION AL,D2S,CNEW,GQD,X2,CW,D2SG,SNEW,SUMA,DEF,FRAC
      REAL V,CHISQ
C
C Common blocks:
C
      COMMON /INSPEC/ DELR,RMIN,DELZ,ZMIN,POLAR
      COMMON /COEFFS/ JMIN,JMAX,IMIN,IMAX,IDCIN,ISIZE
      COMMON /IMDATA/ NPIX,NRAST,IBACK,A,PSIG,SIGMA
      COMMON /FITPAR/ ALLINE
      COMMON /IMAGE / IFPIX,ILPIX,IFRAST,ILRAST
C
C-----------------------------------------------------------------------
C
      DEF = DBLE(DEFA)
      CAIM = DBLE(FLOAT(NSIZE)+CFAC*SQRT(FLOAT(NSIZE)))
      WRITE(6,1000)CAIM
      WRITE(4,1000)CAIM
C
C========Initialize map
C
      IF(ITER.EQ.1)THEN
         DO 10 J=1,NPAR
            ALLINE(J) = DEF
 10      CONTINUE
      ENDIF
C
C========Begin main maximum entropy loop
C
      DO 480 NL=0,MEITS
C
C========Check for positivity
C
         DO 20 LPOINT=1,NPAR
            IF(ALLINE(LPOINT).LT.1.0E-5*SNGL(DEF))
     &         ALLINE(LPOINT) = 1.0E-5*SNGL(DEF)
 20      CONTINUE
C
C========Calculate entropy, DEL.S and RATE
C
         S0 = 0.0D0
         DSNORM = 0.0D0
         SUMF = 0.0D0
         DO 30 LPOINT=1,NPAR
            S0 = S0 - DBLE(ALLINE(LPOINT))*
     &           (DLOG(DBLE(ALLINE(LPOINT))/DEF)-1.0D0)
            DS(LPOINT) = DLOG(DEF/DBLE(ALLINE(LPOINT)))
            DSNORM = DSNORM + DS(LPOINT)*DS(LPOINT)
            SUMF = SUMF + DBLE(ALLINE(LPOINT))
 30      CONTINUE
         RATE = DBLE(RSCL)*SUMF
C
C========Calculate C0,DEL.C
C
         SUMA = 0.0D0
         C0 = 0.0D0
         CALL RESPON(ALLINE,1,1,RE,1,3,NPAR,NSIZE)
         DO 50 J=IFRAST,ILRAST
            DO 40 I=IFPIX,ILPIX
               IJ = (J-1)*NPIX + I
               IF(A(IJ).GT.-0.99E+30)THEN
                  V = PSIG(IJ)
                  SUMA = SUMA + DBLE(RE(IJ,1))
                  RE(IJ,1) = RE(IJ,1) - A(IJ)
                  C0 = C0 + DBLE(RE(IJ,1)*RE(IJ,1)/V)
                  RE(IJ,1) = RE(IJ,1)/V
               ENDIF
 40         CONTINUE
 50      CONTINUE
         CALL TRANSR(DC,1,1,RE,1,3,NPAR,NSIZE)
         DCNORM = 0.0D0
         DO 60 LPOINT=1,NPAR
            DC(LPOINT) = 2.0*DC(LPOINT)
            DCNORM = DCNORM + DBLE(DC(LPOINT))*DBLE(DC(LPOINT))
 60      CONTINUE
         DSNORM = SQRT(DSNORM)
         DCNORM = SQRT(DCNORM)
         WRITE(6,1010)NL,S0,C0,DSNORM,DCNORM
         WRITE(4,1010)NL,S0,C0,DSNORM,DCNORM
C
C========Test for convergence
C
         IF(DSNORM.GT.0.0D0.AND.DCNORM.GT.0.0D0)THEN
            TEST = 0.0D0
            DO 70 LPOINT=1,NPAR
               TMP = DBLE(DS(LPOINT))/DSNORM - DBLE(DC(LPOINT))/DCNORM
               TEST = TEST + TMP*TMP
 70         CONTINUE
            TEST = 0.5D0*TEST
            WRITE(6,1020)TEST
            WRITE(4,1020)TEST
            IF(C0.LT.CAIM.AND.TEST.LT.TCON)THEN
               WRITE(6,1030)
               WRITE(4,1030)
               GOTO 500 
            ENDIF
         ENDIF 
         IF(NL.EQ.MEITS)THEN
            WRITE(6,1040)
            WRITE(4,1040)
            GOTO 500 
         ENDIF
C
C========Apply metric to DS and DC to get E(1) and E(2)
C
         DSNORM = 0.0D0
         DCNORM = 0.0D0
         DO 80 LPOINT=1,NPAR
            E(LPOINT,1) = DS(LPOINT)*ALLINE(LPOINT)
            E(LPOINT,2) = DC(LPOINT)*ALLINE(LPOINT)
            DSNORM = DSNORM + DBLE(E(LPOINT,1)*E(LPOINT,1))
            DCNORM = DCNORM + DBLE(E(LPOINT,2)*E(LPOINT,2))
 80      CONTINUE
         DSNORM = SQRT(DSNORM)
         DCNORM = SQRT(DCNORM)
         WRITE(6,1015)DSNORM,DCNORM,SUMF,SUMA 
         WRITE(4,1015)DSNORM,DCNORM,SUMF,SUMA 
C
C========Normalize E(1),E(2)
C
         IF(SNGL(DSNORM).GT.0.0)THEN 
            DO 90 LPOINT=1,NPAR
               E(LPOINT,1) = E(LPOINT,1)/SNGL(DSNORM)
 90         CONTINUE
         ENDIF 
         IF(SNGL(DCNORM).GT.0.0D0)THEN
            DO 92 LPOINT=1,NPAR
               E(LPOINT,2) = E(LPOINT,2)/SNGL(DCNORM)
 92         CONTINUE
         ENDIF 
C
C========Form E(3)
C
         CALL RESPON(E,1,3,RE,1,3,NPAR,NSIZE)
         CALL RESPON(E,2,3,RE,2,3,NPAR,NSIZE)
         DO 96 J=IFRAST,ILRAST
            DO 94 I=IFPIX,ILPIX
               IJ = (J-1)*NPIX + I
               IF(A(IJ).GT.-0.99E+30)THEN
                  RE(IJ,3) = (RE(IJ,1)-RE(IJ,2))/PSIG(IJ)
               ENDIF
 94         CONTINUE
 96      CONTINUE
         CALL TRANSR(E,3,3,RE,3,3,NPAR,NSIZE)
         E3NORM = 0.0D0
         DO 100 LPOINT=1,NPAR
            E(LPOINT,3) = 2.0*E(LPOINT,3)
            E3NORM = E3NORM + DBLE(E(LPOINT,3)*E(LPOINT,3))
 100     CONTINUE
         E3NORM = SQRT(E3NORM)
C
C========Normalize E(3)
C
         IF(SNGL(E3NORM).GT.0.0)THEN
            DO 110 LPOINT=1,NPAR
               E(LPOINT,3) = E(LPOINT,3)/SNGL(E3NORM)
 110        CONTINUE
         ENDIF
         CALL RESPON(E,3,3,RE,3,3,NPAR,NSIZE)
C
C========Form metric G and RM,S,C
C
         DO 140 J=1,3
            S(J) = 0.0D0
            C(J) = 0.0D0
            DO 115 LPOINT=1,NPAR
               S(J) = S(J) + DBLE(E(LPOINT,J)*DS(LPOINT))
               C(J) = C(J) + DBLE(E(LPOINT,J)*DC(LPOINT))
 115        CONTINUE
            DO 130 I=1,J
               G(I,J) = 0.0D0
               DO 120 LPOINT=1,NPAR
                  G(I,J) = G(I,J) + DBLE(E(LPOINT,I)*E(LPOINT,J))
 120           CONTINUE
               RM(I,J) = 0.0D0
               DO 126 JJ=IFRAST,ILRAST
                  DO 124 II=IFPIX,ILPIX
                     IJ = (JJ-1)*NPIX + II
                     IF(A(IJ).GT.-0.99E+30)THEN
                        RM(I,J) = RM(I,J) + 
     &                       2.0D0*DBLE(RE(IJ,I)*RE(IJ,J)/PSIG(IJ))
                     ENDIF
 124              CONTINUE
 126           CONTINUE
               GSAVE(I,J) = G(I,J)
               RMSAVE(I,J) = RM(I,J)
               IF(I.NE.J)THEN
                  G(J,I) = G(I,J)
                  GSAVE(J,I) = G(I,J)
                  RM(J,I) = RM(I,J)
                  RMSAVE(J,I) = RM(I,J)
               ENDIF
 130        CONTINUE
 140     CONTINUE 
C
C========Normalise G,RM
C
         DO 160 J=1,3
            DO 150 I=1,3
               X = SQRT(GSAVE(I,I)*GSAVE(J,J))
               G(I,J) = GSAVE(I,J)/(X+tiny)
               RM(I,J) = RMSAVE(I,J)/(X+tiny)
 150        CONTINUE
 160     CONTINUE
C
C========Diagonalize G
C
         CALL TRED2(G,3,3,D,OD)
         CALL TQLI(D,OD,3,3,G)
         EMAX = D(1)
         DO 170 I=2,3
            IF(D(I).GT.EMAX)EMAX = D(I)
 170     CONTINUE
         DO 180 I=1,3
            IF(D(I).LT.1.0D-8*EMAX)D(I) = 0.0D0
 180     CONTINUE
C
C========Re-scale eigenvectors
C
         ND = 3
         DO 210 J=1,3
            IF(ABS(D(J)).GT.0.0D0)THEN
               DO 190 I=1,3
                  G(I,J) = G(I,J)/SQRT(D(J))
 190           CONTINUE
            ELSE
               ND = ND - 1
               DO 200 I=1,3
                  G(I,J) = 0.0D0
 200           CONTINUE
            ENDIF
 210     CONTINUE
C
C========Transform RM contracting if necessary
C
         DO 240 K=1,3
            J1 = 0
            DO 230 J=1,3
               IF(D(J).GT.0.0D0)THEN
                  J1 = J1 + 1
                  DTMP(K,J1) = 0.0D0
                  DO 220 I=1,3
                     DTMP(K,J1) = DTMP(K,J1) + RM(K,I)*G(I,J)
 220              CONTINUE 
               ENDIF 
 230        CONTINUE
 240     CONTINUE
         K1 = 0
         DO 270 K=1,3
            IF(D(K).GT.0.0D0)THEN
               K1 = K1 + 1
               DO 260 J=1,ND 
                  GM(K1,J) = 0.0D0
                  DO 250 I=1,3
                     GM(K1,J) = GM(K1,J) + G(I,K)*DTMP(I,J)
 250              CONTINUE 
 260           CONTINUE
            ENDIF
 270     CONTINUE
C
C========Diagonalize GM
C
         CALL TRED2(GM,ND,3,GAMMA,OD)
         CALL TQLI(GAMMA,OD,ND,3,GM)
C
C========Rotate eigenvectors of GM back to original space
C
         DO 300 K=1,3
            DO 290 J=1,ND
               DTMP(K,J) = 0.0D0
               I1 = 0
               DO 280 I=1,3
                  IF(D(I).GT.0.0D0)THEN
                     I1 = I1 + 1
                     DTMP(K,J) = DTMP(K,J) + G(K,I)*GM(I1,J)
                  ENDIF 
 280           CONTINUE  
               DTMP(K,J) = DTMP(K,J)/(SQRT(GSAVE(K,K)+tiny))
 290        CONTINUE
 300     CONTINUE
C
C========Polish eigenvalues
C 
         DO 340 K=1,ND
            X = 0.0D0
            Y = 0.0D0
            DO 320 J=1,3
               DO 310 I=1,3
                  X = X + DTMP(J,K)*RMSAVE(I,J)*DTMP(I,K) 
                  Y = Y + DTMP(J,K)*GSAVE(I,J)*DTMP(I,K)
 310           CONTINUE
 320        CONTINUE
            GAMMA(K) = X/Y
            DO 340 J=1,3
               GM(J,K) = DTMP(J,K)/SQRT(Y)
 330        CONTINUE
 340     CONTINUE
         WRITE(6,1050)(GAMMA(K),K=1,ND)
         WRITE(4,1050)(GAMMA(K),K=1,ND)
C
C========Transform S and C to this basis
C
         EMIN = GAMMA(1)
         DO 360 J=1,ND
            IF(GAMMA(J).LT.EMIN)EMIN = GAMMA(J)
            GS(J) = 0.0D0
            GC(J) = 0.0D0
            DO 350 I=1,3
               GS(J) = GS(J) + S(I)*GM(I,J)
               GC(J) = GC(J) + C(I)*GM(I,J)
 350        CONTINUE
 360     CONTINUE
C
C========Set target statistic and ALMIN
C
         IF(EMIN.GT.0.0D0)THEN
            ALMIN = 0.0D0
            CMIN = C0
            DO 370 K = 1,ND
               CMIN = CMIN - 0.5D0*GC(K)**2/GAMMA(K)
 370        CONTINUE
c            FRAC = EXP(-5.0D0*TEST)
            frac = 0.66666d0
c            frac = exp(-0.5d0*test)
            CTAR = MAX(CAIM,FRAC*CMIN+(1.0D0-FRAC)*C0)
         ELSE
            ALMIN = -EMIN
            CTAR = CAIM
         ENDIF
         CGAP = ABS(C0-CTAR)
         WRITE(6,1055)CTAR 
         WRITE(4,1055)CTAR 
C
C========Commence control section 
C========Control of precision is important.
C========The binary chop limits of CHOPMIN for AL fit real*8 arithmetic.
C========Tweaking GQ(1) by TWEAK is enough to be detected by the 
C========binary chop.
C========The matrix B is inverted by dividing by its (subspace) 
C========eigenvalues, namely  (AL+ALMIN)+GAMMA(K).
C========Here AL can be small, but X=ALMIN+GAMMA(K) can be exactly 0,
C========so X must be evaluated first.
C========Get as near to CTAR as possible within rate. If it can't even 
C========get to C, invoke penalty.
C========Chop RP=PEN/(PEN+1), but only use RP>=0.5
C
         RP = 0.5D0
c         rp = 0.0d0
         DRP = 0.5D0
 380     IF(DRP.LT.chopmin)GOTO 420 
         DRP = DRP/2.0D0
         PEN = RP/(1.0D0-RP)
C
C========Start AL iteration towards C by chopping R=AL/(AL+PEN)
C
         R = 0.5D0
         DR = 0.5D0
         ISUC = 0
 390     IF(DR.LT.chopmin)THEN
C
C========Iterate penalty
C
            IF(ISUC.EQ.1)THEN
               RP = RP - DRP
            ELSE
               RP = RP + DRP
            ENDIF
            IF(RP.GT.0.5D0)GOTO 380
            GOTO 420
         ENDIF
         DR = DR/2.0D0
         AL = R*PEN/(1.0D0-R)
c         al = r/(1.0d0-r)
C
C========Solve B(..)X(.)=GQ(.), breaking symmetry via GQ(1)
C========new chisquared
C========and D2S
C
         D2S = 0.0D0
         CNEW = C0
         DO 400 K=1,ND
            X2 = ALMIN + GAMMA(K)
            GQD = (AL+ALMIN)*GS(K)/PEN - GC(K)
c            gqd = (al+almin)*gs(k) - gc(k)
            IF(K.EQ.1.AND.ABS(GQD).LT.tweak)GQD = tweak
            XU(K) = GQD/(X2+AL)
c            xu(k) = gqd/(pen+x2+al)
            D2S = D2S + XU(K)*XU(K)
            CNEW = CNEW + XU(K)*(GC(K)+GAMMA(K)*XU(K)/2.0D0)
c            cnew = cnew + xu(k)*(gc(k)+(pen+gamma(k))*xu(k)/2.0d0)
 400     CONTINUE
C
C========Iterate AL
C========iterate towards target C if inside rate
C========or towards old C if outside
C
         IF(D2S.LE.RATE)THEN
            CW = CTAR
            IF(ABS(CNEW-CTAR).LE.CGAP.AND.ABS(CNEW-C0).LE.CGAP)THEN
               ISUC = 1
               D2SG = D2S
               DO 410 K=1,ND
                  XUG(K) = XU(K)
 410           CONTINUE
            ENDIF
         ELSE
            CW = C0
         ENDIF
         IF(CNEW.LT.CW)R = R + DR
         IF(CNEW.GT.CW)R = R - DR
         GOTO 390
C
C========Work out new S
C
 420     SNEW = S0 - D2SG/2.0D0
         DO 430 K=1,ND
            SNEW = SNEW + XUG(K)*GS(K)
 430     CONTINUE
C
C========End of control section
C
C========Rewrite XU in original coordinate system
C
         DO 450 I = 1,3
            XU(I) = 0.0D0
            DO 440 J = 1,ND
               XU(I) = XU(I) + GM(I,J)*XUG(J)
 440        CONTINUE
 450     CONTINUE
C
C========Update map 
C
         DO 470 K=1,NPAR
            DO 460 J=1,3
               ALLINE(K) = ALLINE(K) + SNGL(XU(J)*E(K,J))
 460        CONTINUE
 470     CONTINUE
 480  CONTINUE
C
C========Calculate R-factor and sigmas
C
 500  IFLAG = 1
      CALL CHICAL(ALLINE,JMIN,JMAX,NLLPX,NPAR,IMIN,IMAX,IPOINTX,IDCIN,
     &            MPOINTX,A,PSIG,NPIX,NRAST,IBACK,CHISQ,RFAC,SIG,
     &            SIGMA,IFLAG)
      WRITE(6,1060)RFAC
      WRITE(4,1060)RFAC
      RETURN
C
 1000 FORMAT(/1X,'Maximum Entropy Fitting:',
     &       1X,'Overall chi-squared target ',G12.5/)
 1010 FORMAT(/1X,'After ',I4,1X,'iterations:'/
     &       1X,'Entropy = ',G12.5/
     &       1X,'Chi-squared = ',G12.5/
     &       1X,'|DS| = ',G12.5/
     &       1X,'|DC| = ',G12.5)
 1015 FORMAT(1X,'|f(DS)| = ',G12.5/
     &       1X,'|f(DC)| = ',G12.5/
     &       1X,'|Sum(F) = ',G12.5/
     &       1X,'|Sum(A) = ',G12.5)
 1020 FORMAT(1X,'TEST = ',G12.5)
 1030 FORMAT(/1X,'Convergence achieved')
 1040 FORMAT(/1X,'Maximum number of iterations - no convergence')
 1050 FORMAT(1X,'Gamma eigenvalues ',3G12.5)
 1055 FORMAT(1X,'Chi-squared target for next iteration ',G12.5)
 1060 FORMAT(1X,'R-factor from maximum entropy ',G12.5)
      END

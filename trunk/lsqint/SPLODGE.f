C     LAST UPDATE 16/05/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION SPLODGE(I,J)
      IMPLICIT NONE
C
C Purpose: Evaluates value in spot profile for specimen. All external
C          functions (PROF2, ODFINT, EBESI0) have been included in this
C          file for automatic inlining on some compilers.
C
C Calls   0:
C Called by: SETSPLODGE , ADDHORIZ , ADDVERT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C
C Parameter:
C
      REAL FRAC
      PARAMETER(FRAC=0.3)
C
C Scalar arguments:
C
      INTEGER I,J
C
C Common scalars:
C
      REAL DELR,RMIN,DELZ,ZMIN
      REAL A,B,S,DL,RL,DRL,ZL,RCEN,DRS,ZCEN,DZS,PQ2,CONST,R1,R2,Z1,Z2
      REAL DS,SINSIGMA,COSSIGMA,TPQ2R,PI,DZL,DSG,DD1,DD2
      INTEGER INFO1
      LOGICAL POLAR
C
C Local Scalars:
C
      REAL TH1,TH2,TH1R,TH2R,TH1Z,TH2Z
      REAL TH1IN,TH2IN,DS2,SIGMA,SIG1,SIG2,RS,ZS,TEMP,XM,H
C
C Local arrays:
C
      REAL X(5),W(5)
C
C External function:
C
      REAL PROF2
      EXTERNAL PROF2
C
C Common blocks:
C
      COMMON /INSPEC/ DELR,RMIN,DELZ,ZMIN,POLAR
      COMMON /CINPAR/ A,B,S,DL,RL,DRL,ZL,RCEN,DRS,ZCEN,DZS,PQ2,TPQ2R,PI,
     &                DZL,DSG,CONST,INFO1,R1,R2,Z1,Z2,DD1,DD2
      COMMON /SPLCOM/ DS,SINSIGMA,COSSIGMA
C
C Statement function:
C
      REAL QG
      QG(XM,H) = H*(W(1)*(PROF2(XM+H*X(1))+PROF2(XM-H*X(1))) +
     &              W(2)*(PROF2(XM+H*X(2))+PROF2(XM-H*X(2))) +
     &              W(3)*(PROF2(XM+H*X(3))+PROF2(XM-H*X(3))) +
     &              W(4)*(PROF2(XM+H*X(4))+PROF2(XM-H*X(4))) +
     &              W(5)*(PROF2(XM+H*X(5))+PROF2(XM-H*X(5))))
C
C Data:
C
      DATA X /0.1488743389, 0.4333953941, 0.6794095682, 0.8650633666,
     &        0.9739065285/
      DATA W /0.2955242247, 0.2692667193, 0.2190863625, 0.1494513491,
     &        0.0666713443/
C
C-----------------------------------------------------------------------
C
C========Initialize integral
C
      SPLODGE = 0.0
C
C========Calculate position in specimen transform space
C
      IF(POLAR)THEN
         DS = RCEN + FLOAT(I)*DRS
         SIGMA = ZCEN + FLOAT(J)*DZS
         SINSIGMA = SIN(SIGMA)
         COSSIGMA = COS(SIGMA)
      ELSE
         RS = RCEN + FLOAT(I)*DRS
         ZS = ZCEN + FLOAT(J)*DZS
         DS = SQRT(RS*RS+ZS*ZS)
         IF(DS.GT.0.0)THEN
            SIGMA = ATAN2(RS,ZS)
            COSSIGMA = ZS/DS
            SINSIGMA = RS/DS
         ELSE
            SIGMA = 0.0
            COSSIGMA = 1.0
            SINSIGMA = 0.0
         ENDIF
      ENDIF
      IF(SIGMA.LT.0.0)RETURN
C
C========Test that disorientation circle goes through particle spot 
C========region
C
      DS2 = DS*DS
      IF((DD1.LT.DS2).AND.(DD2.GT.DS2))THEN
C
C========Set up theta integration limits
C
         IF(Z1.LT.-DS)THEN
            TH2Z = PI
         ELSEIF(Z1.GT.DS)THEN
            TH2Z = 0.0
         ELSE
            TH2Z = ACOS(Z1/DS)
         ENDIF
         IF(Z2.GT.DS)THEN
            TH1Z = 0.0
         ELSE
            TH1Z = ACOS(Z2/DS)
         ENDIF
         IF(R1.GT.DS)THEN
            TH1R = PI/2.0
         ELSE
            TH1R = ASIN(R1/DS)
         ENDIF
         IF(R2.GT.DS)THEN
            TH2R = PI - TH1R
         ELSE
            TH2R = ASIN(R2/DS)
         ENDIF
         TH1 = MAX(TH1R,TH1Z)
         TH2 = MIN(TH2R,TH2Z)
C
C========Set up inner theta limits
C
         TH1IN = (1.0-FRAC)*TH1 + FRAC*TH2
         TH2IN = FRAC*TH1 + (1.0-FRAC)*TH2
         IF(DSG.LT.(0.5-FRAC)*(TH2-TH1))THEN
            SIG1 = MAX(SIGMA-DSG,0.0)
            SIG2 = MIN(SIGMA+DSG,PI)
            IF(SIG1.GT.TH1.AND.SIG1.LT.TH2)TH1IN = SIG1
            IF(SIG2.GT.TH1.AND.SIG2.LT.TH2)TH2IN = SIG2
            IF(TH2IN.LT.TH1IN)THEN
               TEMP = TH1IN
               TH1IN = TH2IN
               TH2IN = TEMP
            ENDIF
         ENDIF
C
C========Try integral over (possibly) three intervals
C
         XM = 0.5*(TH1IN+TH1)
         H = 0.5*(TH1IN-TH1)
         SPLODGE = QG(XM,H)
         IF(TH2IN.GT.TH1IN)THEN
            XM = 0.5*(TH2IN+TH1IN)
            H = 0.5*(TH2IN-TH1IN)
            SPLODGE = SPLODGE + QG(XM,H)
         ENDIF
         XM = 0.5*(TH2+TH2IN)
         H = 0.5*(TH2-TH2IN)
         SPLODGE = SPLODGE + QG(XM,H)
C     
C========Scale result for varying Bragg spot widths
C
         SPLODGE = CONST*SPLODGE
      ENDIF
C
      RETURN
      END

C     LAST UPDATE 16/05/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION PROF2(THETA)
      IMPLICIT NONE
C
C Purpose: Calculates the value of a fibre diffraction spot profile at a
C          given point
C
C Calls 0: 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Scalar arguments:
C
      REAL THETA
C
C Common scalars:
C
      REAL A,B,S,DL,DRL,DRS,DS,DZS,PQ2,RCEN,RL,ZCEN,ZL,CONST,DZL,DSG,
     &     SINSIGMA,COSSIGMA,TPQ2R,PI,R1,R2,Z1,Z2,DD1,DD2
      INTEGER INFO1
C
C Local Scalars:
C
      REAL COSTHETA,SINTHETA,ZP,RP,DZ2,DR2,AA,BB
C
C External functions:
C
      REAL EBESI0,ODFINT
      EXTERNAL EBESI0,ODFINT
C
C Common blocks:
C
      COMMON /CINPAR/ A,B,S,DL,RL,DRL,ZL,RCEN,DRS,ZCEN,DZS,PQ2,TPQ2R,PI,
     &                DZL,DSG,CONST,INFO1,R1,R2,Z1,Z2,DD1,DD2
      COMMON /SPLCOM/ DS,SINSIGMA,COSSIGMA
C
C-----------------------------------------------------------------------
C
      SINTHETA = SIN(THETA)
      COSTHETA = COS(THETA)
      RP = DS*SINTHETA
      ZP = DS*COSTHETA
      DZ2 = ZP - ZL
      DZ2 = DZ2*DZ2
      AA = 1.0 + A*(1.0-COSTHETA*COSSIGMA)
      BB = -A*SINTHETA*SINSIGMA
      IF(INFO1.EQ.0)THEN
         PROF2 = SINTHETA*EXP(-B*DZ2)*ODFINT(AA,BB,S)
      ELSE
         DR2 = RP - RL
         DR2 = DR2*DR2
         PROF2 = EBESI0(TPQ2R*RP)*SINTHETA*EXP(-B*DZ2-PQ2*DR2)
     &           *ODFINT(AA,BB,S)
      ENDIF
C
      RETURN
      END

C     LAST UPDATE 15/05/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION ODFINT(A,B,S)
      IMPLICIT NONE
C
C Purpose: Evaluate the integral of the orientation distribution 
C          function
C
C Calls 0:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      REAL PI,SMAX
      PARAMETER(PI=3.14159265,SMAX=100.0)
C
C Arguments:
C
      REAL A,B,S
C  
C Local scalars:
C
      REAL X,PM1,PM2,PCUR,TWOX2,ONEPL2,TWOPL2,AA,BB,RA2MB2
      INTEGER L,NL,L2
C 
C-----------------------------------------------------------------------
C
      RA2MB2 = SQRT((A+B)*(A-B))
      X = A/RA2MB2
      IF(S.GT.SMAX)S = SMAX
C
C========Initialize for recurrence relation
C
      NL = INT(S)
      PM2 = 1.0
      PM1 = 0.5
      TWOX2 = 2.0*X*X
C
C========Do recurrence relation
C
      DO 10 L=2,NL
         L2 = L + L
         PCUR = (FLOAT(L2-1)*PM1-FLOAT(L-1)*PM2/TWOX2)/FLOAT(L2)
         PM2 = PM1
         PM1 = PCUR
 10   CONTINUE
C
C========Do some initializing
C
      ONEPL2 = FLOAT(NL*NL)
      TWOPL2 = ONEPL2 + FLOAT(NL+NL+1)
C
C========Interpolation is AA + BB/(1+L)**2
C
      BB = (PM2-PM1)*ONEPL2*TWOPL2/(TWOPL2-ONEPL2)
      AA = 0.5*(PM2+PM1-BB*(TWOPL2+ONEPL2)/(TWOPL2*ONEPL2))
C
C=========Interpolate
C
      ODFINT = PI*((2.0*X/RA2MB2)**(S-1.0))*(AA+BB/(S*S))/RA2MB2
      RETURN
      END

C     LAST UPDATE 11/06/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION EBESI0(X)
      IMPLICIT NONE
C
C Purpose: Evaluates exp(-X).I0(X)
C
C Calls 0:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C
C Arguments:
C
      REAL X
C
C Local Scalars:
C
      DOUBLE PRECISION Y,P1,P2,P3,P4,P5,P6,P7,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9
      REAL AX
C
C Data:
C
      DATA P1,P2,P3,P4,P5,P6,P7 
     &     / 1.0D0 , 3.5156229D0 , 3.0899424D0 , 1.2067492D0 , 
     &     0.2659732D0 , 0.360768D-1 , 0.45813D-2 /
      DATA Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9
     &     / 0.39894228D0 , 0.1328592D-1 , 0.225319D-2 , -0.157565D-2 ,
     &     0.916281D-2 , -0.2057706D-1 , 0.2635537D-1 , -0.1647633D-1 ,
     &     0.392377D-2 /
C 
C-----------------------------------------------------------------------
C
      IF(ABS(X).LT.3.75)THEN
         Y = DBLE(X*X)/14.0625D0
         EBESI0 = SNGL(P1+Y*(P2+Y*(P3+Y*(P4+Y*(P5+Y*(P6+Y*P7))))))
     &            *EXP(-X)
      ELSE
         AX = ABS(X)
         Y = 3.75D0/DBLE(AX)
         EBESI0 = SNGL((Q1+Y*(Q2+Y*(Q3+Y*(Q4+Y*(Q5+Y*(Q6+Y*(Q7+Y*(Q8+
     &                  Y*Q9)))))))))/SQRT(AX)
      ENDIF
C
      RETURN
      END


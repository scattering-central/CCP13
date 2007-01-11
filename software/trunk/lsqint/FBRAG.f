C     LAST UPDATE 14/10/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FBRAG(PR)
      IMPLICIT NONE
C
C Purpose: This function allows the generation of profiles from
C          polycrystalline samples.
C
C Calls 1: SQUELCH 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER MAXDAT,MAXLAT
      PARAMETER(MAXDAT=262144,MAXLAT=3)
      INTEGER NRS,NZS
      PARAMETER(NRS=256,NZS=256)
      INTEGER NLLPX
      PARAMETER(NLLPX=10000)
      INTEGER JWIDTHAV
      PARAMETER(JWIDTHAV=50)
      INTEGER IPOINTX
      PARAMETER(IPOINTX=JWIDTHAV*NLLPX)
      INTEGER IWIDTHAV,MPOINTX
      PARAMETER(IWIDTHAV=30,MPOINTX=IWIDTHAV*IPOINTX)
      REAL ZLIM,SLIM
      PARAMETER(ZLIM=5.0,SLIM=2.0)
      REAL TWOPI
      PARAMETER(TWOPI=6.283185)
C
C Array arguments:
C
      REAL PR(14)
C
C Local scalars:
C
      REAL ALP0,T,Q,Q1,Q2,ARGM,TEMP,EMAX,K0
      INTEGER I,ICEN,IPOINT,IRF,J,J1,J2,JCEN,MPOINT,M,N,JLOLD
      INTEGER JH,JK,JL,IFLAG,K,LALLOW,MMAX,NMIN,IPMAX
C
C Local arrays:
C
      REAL DCIN(-NRS:NRS,-NZS:NZS),RCL(6),AMAT(3,3)
      INTEGER IL(-NZS:NZS),IR(-NZS:NZS)
C
C Common Arrays:
C
      REAL ALLINE(NLLPX+8),AD(512*512),PSIG(512*512)
      REAL SNORM(MAXLAT),SSCALE(NLLPX)
      INTEGER*2 JMIN(NLLPX),JMAX(NLLPX)
      INTEGER*2 IMIN(IPOINTX),IMAX(IPOINTX)
      CHARACTER*1 IDCIN(MPOINTX)
      INTEGER ISIZE(5),IHKL(4,NLLPX),INFO(3)
C
C Common scalars:
C
      REAL A,B,S,DL,DRL,DRS,DZS,RCEN,RL,ZCEN,ZL,PQ2,TPQ2R,PI,CONST
      REAL DELR,RMIN,DELZ,ZMIN
      REAL DMIN,DMAX,DZL,DSG,SN,RADM,R1,R2,Z1,Z2,DD1,DD2
      INTEGER IAMIN,IAMAX,JAMIN,JAMAX,N1,N2,IBACK,IORIG,JORIG
      INTEGER L1,L2,NR1,NR2,NLLP,NPRD,INF1,NLDIV,NBESS
      LOGICAL SIGMA,POLAR
      INTEGER MPTR,IPTR,LPTR,NPTR
C
C Common blocks:
C
      COMMON /CINPAR/ A,B,S,DL,RL,DRL,ZL,RCEN,DRS,ZCEN,DZS,PQ2,TPQ2R,
     &                PI,DZL,DSG,CONST,INF1,R1,R2,Z1,Z2,DD1,DD2
      COMMON /INSPEC/ DELR,RMIN,DELZ,ZMIN,POLAR
      COMMON /POINTS/ NLLP,NPRD,INFO,IHKL
      COMMON /LIMITS/ IAMIN,IAMAX,JAMIN,JAMAX,IORIG,JORIG
      COMMON /COEFFS/ JMIN,JMAX,IMIN,IMAX,IDCIN,ISIZE
      COMMON /DLIMIT/ DMIN,DMAX,L1,L2,NR1,NR2,SN,NLDIV,NBESS,RADM
      COMMON /IMDATA/ N1,N2,IBACK,AD,PSIG,SIGMA
      COMMON /FITPAR/ ALLINE
      COMMON /POINTR/ MPTR,IPTR,LPTR,NPTR
      COMMON /SCALES/ SNORM,SSCALE
C
C External function:
C
      REAL ODFNRM
      EXTERNAL ODFNRM
C
C-----------------------------------------------------------------------
C
      INF1 = INFO(1)
      IFLAG = 0
      DRS = DELR
      DZS = DELZ
C
C========Print this parameter set
C
      WRITE(6,1030)(PR(I),I=1,14)
      WRITE(4,1030)(PR(I),I=1,14)
C
C========Initialize some common block variables, etc.
C
      ALP0 = PR(2)
      S = PR(3)
      T = PR(4)
      Q = PR(6)
      Q1 = PR(7)
      Q2 = PR(8)
      RCL(1) = PR(5)
      IF(INFO(2).LE.2)THEN
         RCL(2) = PR(5)
      ELSE
         RCL(2) = PR(9)
      ENDIF
      RCL(3) = PR(1)
      RCL(4) = PR(10)
      RCL(5) = PR(11)
      RCL(6) = PR(12)
      CALL MATCAL(INFO(3),PR(13),PR(14),RCL,AMAT)
      A = 2.0*(2.0**(1.0/S)-1.0)/TAN(0.5*ALP0)**2
      B = PI/(T*T)
C
C========Calculate normalization factor for this lattice
C
      SN = Q*Q*T*ODFNRM(A,S)
C
C========Set integration limits
C
      DZL = ZLIM*T
      DSG = SLIM*ALP0*2.0**(1.0/S)
C
C========Initialize pointers
C      
      MPOINT = MPTR
      IPOINT = IPTR
      NLLP = LPTR
      IPMAX = 0
      JLOLD = L1 - 1
      ARGM = 0.0
C
      DO 30 IRF=NPTR+1,NPTR+NPRD
C
         JH = IHKL(1,IRF)
         JK = IHKL(2,IRF)
         JL = IHKL(3,IRF)
C
C========Check JL against layerline range
C
         IF(JL.LT.L1.OR.JL.GT.L2)THEN
            IHKL(4,IRF) = 0
            GOTO 30
         ENDIF
C
C========Check JL against selection rule
C
         IF(JL.NE.JLOLD)THEN
            LALLOW = 0
            IF(NBESS.EQ.0)THEN
               DO 5 K=1,NLDIV
                  IF(MOD(JL,ISIZE(K)).EQ.0)LALLOW = LALLOW + 1
 5             CONTINUE
            ELSE
               NMIN = NBESS + 1
               MMAX = (ABS(ISIZE(4)*JL)+ABS(ISIZE(1))*NBESS)
               MMAX = MMAX/ABS(ISIZE(2)) + 1
               DO 6 M=-MMAX,MMAX
                  N = ABS(JL)*ISIZE(4) - ABS(ISIZE(2))*M
                  IF(MOD(N,ISIZE(1)).EQ.0)THEN
                     N = N/ISIZE(1)
                     IF(MOD(N,ISIZE(3)).EQ.0)NMIN = MIN(NMIN,ABS(N))
                  ENDIF
 6             CONTINUE
               IF(NMIN.LE.NBESS)THEN
                  LALLOW = 1
                  ARGM = MAX((FLOAT(NMIN)-2.0)/TWOPI,0.0)
                  WRITE(6,1000)JL,NMIN,ARGM/RADM
                  WRITE(4,1000)JL,NMIN,ARGM/RADM
               ELSE
                  WRITE(6,1005)JL
                  WRITE(4,1005)JL
               ENDIF
            ENDIF
            JLOLD = JL
         ENDIF
         IF(LALLOW.EQ.0)THEN
            IHKL(4,IRF) = 0
            GOTO 30
         ENDIF
C
C========Check DL against resolution range and selection rule
C
         CALL RZDCAL(AMAT,JH,JK,JL,RL,ZL,DL)
         IF(DL.GT.DMIN.AND.DL.LT.DMAX.AND.RADM*RL.GE.ARGM)THEN
            LPTR = LPTR + 1
            NLLP = NLLP + 1
            IHKL(4,IRF) = 1
            IF(NLLP.GT.NLLPX)STOP 'FBRAG: Error - nllp too big'
C
            CALL SQUELCH(T,Q,Q1,Q2,IL,IR,J1,J2,DCIN,NRS,NZS,ICEN,JCEN,
     &                   DELR,DELZ,IAMIN,IAMAX,JAMIN,JAMAX,POLAR,EMAX)
C
C========Scaling
C
            IF(EMAX.GT.0.0)THEN
               SSCALE(NLLP) = 255.0/EMAX
            ELSE
               SSCALE(NLLP) = 0.0
            ENDIF
            K0 = SSCALE(NLLP)
C
C========Copy to output array.
C
            JMIN(NLLP) = J1 + JCEN - JORIG
            JMAX(NLLP) = J2 + JCEN - JORIG
            DO 20 J=J1,J2
               IPTR = IPTR + 1
               IPOINT = IPOINT + 1
               IF(IPOINT.GT.IPOINTX)STOP 'FBRAG: Error - ipoint too big'
C
               IMIN(IPOINT) = IL(J) + ICEN - IORIG
               IMAX(IPOINT) = IR(J) + ICEN - IORIG
               DO 10 I=IL(J),IR(J)
                  MPTR = MPTR + 1
                  MPOINT = MPOINT + 1
                  IF(MPOINT.GT.MPOINTX)STOP 
     &                                 'FBRAG: Error - mpoint too big' 
                  TEMP = K0*DCIN(I,J)
                  IDCIN(MPOINT) = CHAR(NINT(TEMP))
                  IF(NINT(TEMP).GT.IPMAX)IPMAX = NINT(TEMP)
 10            CONTINUE
 20         CONTINUE
C
         ELSE
            IHKL(4,IRF) = 0
         ENDIF
C
 30   CONTINUE
C
      WRITE(6,1010)IPMAX
      WRITE(4,1010)IPMAX
      NPTR = NPTR + NPRD
      WRITE(6,1050)
      WRITE(4,1050)
      RETURN
 1000 FORMAT(1X,'Layer line ',I3,':',4X,'minimum |n| = ',I3,
     &       4X,'minimum R = ',G12.5)
 1005 FORMAT(1X,'Layer line ',I3,':',4X,'disallowed')
 1010 FORMAT(1X,'Maximum profile value = ',I8)
 1020 FORMAT(1X,'FBRAG: Warning - value out of range ',F10.1)
 1030 FORMAT(1X,'Calculating profiles for parameter set:'/
     &       1X,'c*                                  = ',F8.5/
     &       1X,'ODF width (AWIDTH)                  = ',F8.5/
     &       1X,'ODF shape (SHAPE)                   = ',F8.5/
     &       1X,'particle coherence length (ZWIDTH)  = ',F8.5/
     &       1X,'a*                                  = ',F8.5/
     &       1X,'particle coherence radius (R0WIDTH) = ',F8.5/
     &       1X,'linear width factor (R1WIDTH)       = ',F8.5/
     &       1X,'quadratic width factor (R2WIDTH)    = ',F8.5/
     &       1X,'b*                                  = ',F8.5/
     &       1X,'alpha*                              = ',F8.5/
     &       1X,'beta*                               = ',F8.5/
     &       1X,'gamma*                              = ',F8.5/
     &       1X,'phi_Z                               = ',F8.5/
     &       1X,'phi_X                               = ',F8.5)
 1040 FORMAT(1X,12F8.5)
 1050 FORMAT(1X,'Profile calculation completed')
      END


      BLOCK DATA
      REAL A,B,S,DL,DRL,DRS,DZS,RCEN,RL,ZCEN,ZL,PQ2,TPQ2R,PI,CONST
      REAL DZL,DSG,R1,R2,Z1,Z2,DD1,DD2
      INTEGER INF1
      COMMON /CINPAR/ A,B,S,DL,RL,DRL,ZL,RCEN,DRS,ZCEN,DZS,PQ2,TPQ2R,PI,
     &                DZL,DSG,CONST,INF1,R1,R2,Z1,Z2,DD1,DD2
      DATA PI /3.141592654/
      END



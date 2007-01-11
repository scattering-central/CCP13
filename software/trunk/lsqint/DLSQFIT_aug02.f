C     LAST UPDATE 06/06/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE DLSQFIT(JMIN,JMAX,NLLP,NPAR,IMIN,IMAX,NIMM,IDCIN,NDCIN,
     &                   SIG,RFAC,SETZ,FTF,V,W,FTY,DX,IPT,MPT,IMN,IMX)
      IMPLICIT NONE
C
C Purpose: Forms the normal least squares equation, F(T)F.X = F(T)Y 
C          then solves the least-squares problem by singular
C          value decomposition and back substitution. Refinement
C          of global back ground parameters is optional.
C
C
C Calls   4: TRED2 , TQLI , TBKSB , CHICAL
C Called by: LSQINT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER MAXALL,MAXLAT
      PARAMETER(MAXALL=50,MAXLAT=3)
      INTEGER NLLPX
      PARAMETER(NLLPX=10000)
C
C Scalar arguments:
C
      REAL RFAC
      INTEGER NDCIN,NIMM,NLLP,NPAR
      LOGICAL SETZ
C
C Array arguments:
C
      REAL SIG(NLLPX+8)
      REAL*8 FTF(NPAR,NPAR),V(NPAR),W(NPAR),FTY(NPAR),DX(NPAR)
      CHARACTER*1 IDCIN(NDCIN)
      INTEGER*2 IMAX(NIMM),IMIN(NIMM),JMAX(NLLP),JMIN(NLLP)
      INTEGER IPT(NPAR),MPT(NPAR),IMN(NPAR),IMX(NPAR)
C
C Common scalars:
C
      REAL DELR,RMIN,DELZ,ZMIN,DMIN,DMAX,SN,RADM
      INTEGER N1,N2,IBACK,IFPIX,ILPIX,IFRAST,ILRAST
      INTEGER L1,L2,NR1,NR2,NLDIV,NBESS
      LOGICAL SIGMA,POLAR
C
C Common arrays:
C
      REAL A(512*512),PSIG(512*512),ALLINE(NLLPX+8)

C
C Local arrays:
C
      REAL*8 B(8)
C
C Local scalars:
C
      INTEGER I,IPOINT,J,LPOINT,MPOINT,II,IIPOINT,JJ,LLPOINT,MMPOINT,
     &        NB,NBB,IW,IFLAG,IJ,NBCK,INEG,IPASS,NPASS
      REAL RS,ZS,ZS2,DS,PS,CHISQ,SBCK
      REAL*8 THRESH,TOL,WMAX,FIDCN1,DSIG,X
      PARAMETER(TOL=1.0D-07)
C
C Common blocks:
C
      COMMON /INSPEC/ DELR,RMIN,DELZ,ZMIN,POLAR
      COMMON /DLIMIT/ DMIN,DMAX,L1,L2,NR1,NR2,SN,NLDIV,NBESS,RADM
      COMMON /IMDATA/ N1,N2,IBACK,A,PSIG,SIGMA
      COMMON /FITPAR/ ALLINE
      COMMON /IMAGE / IFPIX,ILPIX,IFRAST,ILRAST
C
C Data:
C
      DATA NPASS /1/
      DATA SBCK /2.0/
C
C-----------------------------------------------------------------------
C
C========Zero arrays
C
      DO 20 J=1,NPAR
         FTY(J) = 0.0D0
         DO 10 I=1,J
            FTF(I,J) = 0.0D0
 10      CONTINUE
 20   CONTINUE
C
C========Loop over data points to form B(T).B and B(T).Y
C
      IF(MOD(IBACK/16,2).EQ.1)THEN
         NBCK = 8
         DO 70 J=1,N2
            IF(POLAR)THEN
               PS = FLOAT(J)*DELZ + ZMIN
            ELSE
               ZS = FLOAT(J)*DELZ + ZMIN
               ZS2 = ZS*ZS
            ENDIF
            DO 60 I=1,N1
               IJ = (J-1)*N1 + I
C
C========A(IJ) = -1.0E30 flags points off sphere of reflection
C
               IF(A(IJ).GT.-0.99E+30.AND.I.GE.IFPIX.AND.I.LE.ILPIX
     &            .AND.J.GE.IFRAST.AND.J.LE.ILRAST)THEN
                  DSIG = DBLE(PSIG(IJ))
                  IF(POLAR)THEN
                     DS = FLOAT(I)*DELR + RMIN
                  ELSE
                     RS = FLOAT(I)*DELR + RMIN
                     DS = SQRT(RS*RS+ZS2)
                     PS = ATAN2(ABS(RS),ABS(ZS))
                  ENDIF
C
C========Form coefficients for background parameters and scale by SBCK
C
                  X = DBLE(DS)/DBLE(DMAX)
                  B(1) = 1.0D0
                  B(2) = X
                  B(3) = 2.0D0*X*X - 1.0D0
                  B(4) = 2.0*X*B(3) - X
                  DO 30 NB=1,4
                     B(NB) = B(NB)*DBLE(SBCK)
                     B(NB+4) = DBLE(SBCK*COS(2.0*FLOAT(NB)*PS))
 30               CONTINUE
C
C========Form B(T).Y and diagonal of B(T).B
C
                  DO 50 NB=1,8
                     FTY(NB) = FTY(NB) + DBLE(A(IJ))*
     &                         B(NB)/DSIG 
                     FTF(NB,NB) = FTF(NB,NB) + 
     &                            B(NB)*B(NB)/DSIG
C
C========Form B(T).B
C
                     DO 40 NBB=1,NB-1
                        FTF(NBB,NB) = FTF(NBB,NB) +
     &                                B(NBB)*B(NB)/DSIG
 40                  CONTINUE
 50               CONTINUE
               ENDIF
 60         CONTINUE
 70      CONTINUE
C
C========Form symmetric image of B(T).B
C
         DO 76 NB=1,8
            DO 74 NBB=1,NB-1
               FTF(NB,NBB) = FTF(NBB,NB)
 74         CONTINUE
 76      CONTINUE
      ELSE
         NBCK = 0
      ENDIF
C
C========Loop over profile coefficients array to form the
C========F(T).Y vector and the symmetric F(T)F matrix
C
      IPOINT = 0
      MPOINT = 0
      DO 170 LPOINT=1,NLLP
C
C========Set up pointers for the transpose loop
C
         IPT(LPOINT) = IPOINT
         MPT(LPOINT) = MPOINT
         IMN(LPOINT) = N1
         IMX(LPOINT) = 1
C
C========Loop over the heights in this profile
C 
         DO 140 J=JMIN(LPOINT),JMAX(LPOINT)
            IPOINT = IPOINT + 1
            IF(IMIN(IPOINT).LT.IMN(LPOINT))IMN(LPOINT) = IMIN(IPOINT)
            IF(IMAX(IPOINT).GT.IMX(LPOINT))IMX(LPOINT) = IMAX(IPOINT)
C
C========Loop over the widths at this height
C
            DO 130 I=IMIN(IPOINT),IMAX(IPOINT)
               MPOINT = MPOINT + 1
               IJ = (J-1)*N1 + I
               IF(A(IJ).GT.-0.99E+30.AND.I.GE.IFPIX.AND.I.LE.ILPIX
     &            .AND.J.GE.IFRAST.AND.J.LE.ILRAST)THEN
                  DSIG = DBLE(PSIG(IJ))
C
C========Calculate R,Z,D,PHI for background subtraction
C
                  IF(POLAR)THEN
                     PS = FLOAT(J)*DELZ + ZMIN
                     DS = FLOAT(I)*DELR + RMIN
                  ELSE
                     ZS = FLOAT(J)*DELZ + ZMIN
                     RS = FLOAT(I)*DELR + RMIN
                     DS = SQRT(RS*RS+ZS*ZS)
                     PS = ATAN2(ABS(RS),ABS(ZS))
                  ENDIF
C
C========Form F(T).Y and diagonal of F(T).F 
C
                  FIDCN1 = DBLE(ICHAR(IDCIN(MPOINT)))
                  FTY(NBCK+LPOINT) = FTY(NBCK+LPOINT) + 
     &                 FIDCN1*A(IJ)/DSIG
                  FTF(NBCK+LPOINT,NBCK+LPOINT) = 
     &                 FTF(NBCK+LPOINT,NBCK+LPOINT) +
     &                 FIDCN1*FIDCN1/DSIG
                  FIDCN1 = FIDCN1/DSIG
C
C========Loop over transpose for F(T).F
C
                  DO 100 LLPOINT=1,LPOINT-1
                     IF(JMIN(LLPOINT).LE.J.AND.JMAX(LLPOINT).GE.J.AND.
     &                  IMN(LLPOINT).LE.I.AND.IMX(LLPOINT).GE.I)THEN
                        IIPOINT = IPT(LLPOINT)
                        MMPOINT = MPT(LLPOINT)
                        DO 90 JJ=JMIN(LLPOINT),JMAX(LLPOINT)
                           IIPOINT = IIPOINT + 1
C
C========Check for coincidence of column elements
C
                           IF(JJ.EQ.J)THEN
                              DO 80 II=IMIN(IIPOINT),IMAX(IIPOINT)
                                 MMPOINT = MMPOINT + 1
C
C========Check for coincidence of row elements
C
                                 IF(II.EQ.I)THEN
                                    FTF(NBCK+LLPOINT,NBCK+LPOINT) = 
     &                                   FTF(NBCK+LLPOINT,NBCK+LPOINT) +
     &                                   DBLE(ICHAR(IDCIN(MMPOINT)))*
     &                                   FIDCN1
                                    GOTO 100
                                 ENDIF 
 80                           CONTINUE
                           ELSE
                              MMPOINT = MMPOINT + IMAX(IIPOINT) - 
     &                                  IMIN(IIPOINT) + 1
                           ENDIF
 90                     CONTINUE
                     ENDIF
 100              CONTINUE
C
C========Form F(T).B 
C 
                  IF(MOD(IBACK/16,2).EQ.1)THEN
                     X = DBLE(DS)/DBLE(DMAX)
                     B(1) = 1.0D0
                     B(2) = X
                     B(3) = 2.0D0*X*X - 1.0D0
                     B(4) = 2.0D0*X*B(3) - X
                     DO 110 NB=1,4
                        B(NB) = DBLE(SBCK)*B(NB)
                        B(NB+4) = DBLE(SBCK*COS(2.0*FLOAT(NB)*PS))
 110                 CONTINUE
                     DO 120 NB=1,8
                        FTF(NB,NBCK+LPOINT) = FTF(NB,NBCK+LPOINT)  
     &                       + FIDCN1*B(NB)
 120                 CONTINUE
                  ENDIF
               ENDIF
 130        CONTINUE
 140     CONTINUE
C
C========Form image for symmetric matrix
C
         DO 150 LLPOINT=1,LPOINT-1
            FTF(NBCK+LPOINT,NBCK+LLPOINT) = 
     &                                    FTF(NBCK+LLPOINT,NBCK+LPOINT)
 150     CONTINUE
         IF(MOD(IBACK/16,2).EQ.1)THEN 
            DO 160 NB = 1,8
               FTF(NBCK+LPOINT,NB) = FTF(NB,NBCK+LPOINT)
 160        CONTINUE
         ENDIF
 170  CONTINUE
C
C========Now solve least-squares by singular value decomposition
C========and backsubstitution
C
      CALL TRED2(FTF,NPAR,NPAR,W,V)
      CALL TQLI(W,V,NPAR,NPAR,FTF)
      WMAX = 0.0D0 
      DO 180 J=1,NPAR
         IF(W(J).GT.WMAX)WMAX = W(J)
 180  CONTINUE
      THRESH = TOL*WMAX
      IW = 0
      DO 190 J=1,NPAR
         IF(W(J).LT.THRESH)THEN
            W(J) = 0.0D0
            IW = IW + 1
         ENDIF
 190  CONTINUE
      WRITE(6,1020)IW
      WRITE(4,1020)IW
      CALL TBKSB(W,FTF,NPAR,NPAR,FTY,DX)
C
C========Re-scale background parameters
C
      IF(MOD(IBACK/16,2).EQ.1)THEN
         DO 200 NB=1,8
            ALLINE(NB) = SNGL(DX(NB))*SBCK
 200     CONTINUE
      ENDIF
      DO 204 LPOINT=NBCK+1,NPAR
         ALLINE(LPOINT) = SNGL(DX(LPOINT))
 204  CONTINUE
C
C========Try improvement of the solution by solving for F(T).delta(Y)
C 
      IFLAG = 2 
      DO 209 IPASS=1,NPASS
         CALL CHICAL(ALLINE,JMIN,JMAX,NLLP,NPAR,IMIN,IMAX,NIMM,IDCIN,
     &               NDCIN,A,PSIG,N1,N2,IBACK,CHISQ,RFAC,SIG,
     &               SIGMA,IFLAG)
         IF(MOD(IBACK/16,2).EQ.1)THEN
            DO 205 NB=1,8
               FTY(NB) = DBLE(SIG(NB)*SBCK)
 205        CONTINUE
         ENDIF
         DO 206 LPOINT=NBCK+1,NPAR
            FTY(LPOINT) = DBLE(SIG(LPOINT))
 206     CONTINUE
         CALL TBKSB(W,FTF,NPAR,NPAR,FTY,DX)
         IF(MOD(IBACK/16,2).EQ.1)THEN
            DO 207 NB=1,8
               ALLINE(NB) = ALLINE(NB) + SNGL(DX(NB))*SBCK
 207        CONTINUE
         ENDIF
         DO 208 LPOINT=NBCK+1,NPAR
            ALLINE(LPOINT) = ALLINE(LPOINT) + SNGL(DX(LPOINT))
 208     CONTINUE
 209  CONTINUE
c
c Write out covariances in bottom half, original in top half
c of output - i.e. there are two diagonals:
c
c                     nllp + 1          
c        |\\------------------------------
c        |  \\                           |  
c        |    \\                         |  
c        |      \\   Normal equations    |
c        |        \\                     |
c        |          \\                   |
c        |            \\                 |  
c        |              \\               | nllp
c        |                \\             |
c        |                  \\           |
c        |  Covariance        \\         |
c        |  (= Inverse of       \\       |
c        |     upper half)        \\     |
c        |                          \\   |
c        |                            \\ |
c        |______________________________\\     
c
      open(unit=19,file='cov.dat',access='direct',
     &     form='unformatted',recl=4*(nllp+1),
     &     status='unknown')
      do i=nbck+1,npar
         do j=nbck+1,npar
            sig(j) = 0.0
            if(j.lt.i)then
c Covariance   
               do jj=nbck+1,npar
                  if(w(jj).gt.0.0)then
                     ds = ftf(i,jj) * ftf(j,jj)
	             sig(j) = sig(j) + ds / w(jj)
                  endif
               enddo
            elseif(j.gt.i)then
c Normal equations
               do jj=nbck+1,npar
                  ds = ftf(i,jj) * ftf(j,jj)
                  sig(j) = sig(j) + ds * w(jj)
               enddo
            else
c Both diagonals
               rs = 0.0
               zs = 0.0
               do jj=nbck+1,npar
                  ds = ftf(i,jj) * ftf(j,jj)
                  if(w(jj).gt.0.0)then
	             rs = rs + ds / w(jj)
                  endif
                  zs = zs + ds * w(jj)
               enddo
            endif
         enddo
         write(19,rec=i)(sig(j),j=nbck+1,i-1),rs,
     &                  zs,(sig(j),j=i+1,npar)
      enddo
      close(unit=19)	
C
C========Reset negative values to zero
C
      IF(SETZ)THEN
         INEG = 0
         DO 210 LPOINT=1,NLLP
            IF(ALLINE(NBCK+LPOINT).LT.0.0)THEN
               INEG = INEG + 1
               WRITE(6,1050)LPOINT
               WRITE(4,1050)LPOINT
               ALLINE(NBCK+LPOINT) = 0.0
            ENDIF
 210     CONTINUE
         WRITE(6,1060)INEG
         WRITE(4,1060)INEG
      ENDIF
C
C========Calculate CHISQ,RFAC and individual sigmas
C
      IFLAG = 1
      CALL CHICAL(ALLINE,JMIN,JMAX,NLLP,NPAR,IMIN,IMAX,NIMM,IDCIN,
     &            NDCIN,A,PSIG,N1,N2,IBACK,CHISQ,RFAC,SIG,
     &            SIGMA,IFLAG)
C
C========Write out background parameters
C
      IF(MOD(IBACK/16,2).EQ.1)THEN
         WRITE(6,1040)(ALLINE(NB),NB=1,8)
         WRITE(4,1040)(ALLINE(NB),NB=1,8)
      ENDIF
C
C========Write CHISQ
C
      WRITE(6,1000)CHISQ
      WRITE(4,1000)CHISQ
      WRITE(6,1010)RFAC
      WRITE(4,1010)RFAC
      RETURN
C
 1000 FORMAT(1X,'Chi-squared from least-squares = ',G12.4)
 1010 FORMAT(1X,'R-factor from least-squares = ',G12.4)
 1020 FORMAT(1X,'Number of eigenvalues set to zero ',I5)
 1040 FORMAT(/1X,'Background parameters'
     &       /5X,'A',9X,'B',9X,'C',9X,'D',9X,'E',9X,'F',9X,'G',9X,'H'
     &       /8(1X,E9.3)/)
 1050 FORMAT(1X,'Point',I5,' negative - resetting to zero')
 1060 FORMAT(1X,'Number of negative values reset ',I5)
      END

C     LAST UPDATE 20/03/98
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE BGWLSH(B,BB,IWID,JWID,ISEP,JSEP,SMOO,TENS)
      IMPLICIT NONE
C
C Purpose: Forms a background image using a combination of a roving
C          window and least-squares fitting and 2-D spline fitting to
C          speed things up (Horizontal plane + spots).
C
C Calls   4: TRED2, TQLI, TBKSB, CURVS
C Called by: LSQINT 
C 
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER MAXDIM,MAXDAT,MAXWIN,MAXPAR
      PARAMETER(MAXDIM=512,MAXDAT=MAXDIM**2,MAXWIN=41*41,MAXPAR=150)
      INTEGER NLLPX,JWIDTHAV,IPOINTX,IWIDTHAV,MPOINTX 
      PARAMETER(NLLPX=10000,JWIDTHAV=50)
      PARAMETER(IPOINTX=JWIDTHAV*NLLPX,IWIDTHAV=30)
      PARAMETER(MPOINTX=IWIDTHAV*IPOINTX)
      DOUBLE PRECISION TOL
      PARAMETER(TOL=1.0D-07)
      REAL SCALEB
      PARAMETER(SCALEB=100.0)
C
C Scalar arguments:
C
      REAL SMOO,TENS
      INTEGER IWID,JWID,ISEP,JSEP
C
C Array arguments:
C
      REAL B(MAXDAT),BB(MAXDAT)
C
C Common Arrays:
C
      REAL AD(MAXDAT),PSIG(MAXDAT)
      INTEGER IHKL(4,NLLPX),INFO(3),ISIZE(5)
      INTEGER*2 JMIN(NLLPX),JMAX(NLLPX),IMIN(IPOINTX),IMAX(IPOINTX)
      CHARACTER*1 IDCIN(MPOINTX)
C
C Common scalars:
C
      REAL DELR,RMIN,DELZ,ZMIN
      INTEGER IFPIX,ILPIX,IFRAST,ILRAST,NPIX,NRAST,IBACK
      INTEGER NLLP,NPRD
      LOGICAL SIGMA,POLAR
C
C Local arrays:
C
      DOUBLE PRECISION P(MAXPAR,MAXPAR),X(MAXPAR),V(MAXPAR),W(MAXPAR),
     &                 COF(MAXPAR)
      REAL PRF(MAXWIN,MAXPAR),PIX(MAXWIN)
      REAL XB(MAXDIM),YB(MAXDIM),YS(MAXDIM),YSP(MAXDIM),WRK(9*MAXDIM)
      INTEGER LPT(NLLPX)
      LOGICAL KNOT(MAXDIM)
C
C Local Scalars:
C
      DOUBLE PRECISION THRESH,WMAX
      INTEGER I,J,K,L,IBCK,M,MM,ISTRT,IEND,NIWIND
      INTEGER NB,JW1,JW2,IW1,IW2,IW,IER,IN,JN
      INTEGER IPOINT,LPOINT,MPOINT,IPEAK
      REAL RS,ZS,S,EPS
      LOGICAL LINE
C
C Common blocks:
C
      COMMON /INSPEC/ DELR,RMIN,DELZ,ZMIN,POLAR
      COMMON /POINTS/ NLLP,NPRD,INFO,IHKL
      COMMON /COEFFS/ JMIN,JMAX,IMIN,IMAX,IDCIN,ISIZE
      COMMON /IMDATA/ NPIX,NRAST,IBACK,AD,PSIG,SIGMA
      COMMON /IMAGE / IFPIX,ILPIX,IFRAST,ILRAST
C
C External function:
C
      REAL CURV2
      EXTERNAL CURV2
C
C-----------------------------------------------------------------------
C
      WRITE(6,1000)
      WRITE(4,1000)
C
C========Check window size for array bounds
C
      NB = (2*IWID+1)*(2*JWID+1) 
      IF(NB.GT.MAXWIN)THEN
         WRITE(6,1010)
         WRITE(4,1010)
         STOP
      ENDIF
C
C========Initialize B to flag unknown background values
C
      DO 20 J=1,NRAST
         DO 10 I=1,NPIX
            M = (J-1)*NPIX + I
            B(M) = -1.0E+30
 10      CONTINUE
 20   CONTINUE
C
C========Set default window separation if necessary
C
      IF(JSEP.LE.0)JSEP = JWID
      IF(ISEP.LE.0)ISEP = IWID
C
C========Loop over rasters and determine window limits
C
      DO 120 J=IFRAST,ILRAST
         JW1 = J - JWID
         IF(JW1.LT.1)JW1 = 1
         JW2 = J + JWID
         IF(JW2.GT.NRAST)JW2 = NRAST
         ZS = FLOAT(J)*DELZ + ZMIN
C     
C========Find first and last relevant pixels in this raster
C     
         ISTRT = 0
         IEND = 0
         DO 30 I=IFPIX,ILPIX
            KNOT(I) = .FALSE.
            M = (J-1)*NPIX + I
            MM = J*NPIX - I + 1
            IF(AD(M).GT.-0.99E+30)THEN
               IF(ISTRT.EQ.0)ISTRT = I
            ENDIF
            IF(AD(MM).GT.-0.99E+30)THEN
               IF(IEND.EQ.0)IEND = NPIX - I + 1
            ENDIF 
 30      CONTINUE
C
C========Determine whether this is a raster for interpolation, if so, 
C========flag the appropriate pixels, if not, flag only those pixels 
C========likely to be on the perimeter of the image or masked areas
C
         LINE = .FALSE.
         IF(MOD(J-IFRAST,JSEP).EQ.0.OR.J.EQ.ILRAST)THEN
            NIWIND = (IEND-ISTRT-1)/ISEP + 2 
            DO 40 IN=1,NIWIND
               I = ISTRT + (IN-1)*ISEP
               IF(I.GT.IEND)I = IEND 
               KNOT(I) = .TRUE.
               LINE = .TRUE.
 40         CONTINUE
         ELSE
            DO 50 I=ISTRT,IEND
               M = (J-1)*NPIX + I 
               IF(AD(M-NPIX).LT.-0.99E+30.OR.
     &            AD(M+NPIX).LT.-0.99E+30)KNOT(I) = .TRUE.
 50         CONTINUE
         ENDIF
         IBCK = 0
C
C=========Loop over pixels in this raster
C
         DO 100 I=IFPIX,ILPIX
            IF(KNOT(I))THEN
               M = (J-1)*NPIX + I
               IF(AD(M).GT.-0.99E+30)THEN
                  IW1 = I - IWID
                  IF(IW1.LT.1)IW1 = 1
                  IW2 = I + IWID
                  IF(IW2.GT.NPIX)IW2 = NPIX
C
C========SPECIFIC WINDOW BACKGROUND METHOD
C
C
C========Initialize row-pointer for peak points
C 
                  DO 60 IPEAK=1,NLLP
                     LPT(IPEAK) = 0
 60               CONTINUE
C
C========Start loop over points in this window
C
                  IW = 0
                  IPEAK = 1
                  DO 72 JN=JW1,JW2
                     DO 70 IN=IW1,IW2
                        MM = (JN-1)*NPIX + IN
                        IF(AD(MM).GT.-0.99E+30)THEN 
                           IW = IW + 1
C
C========Form first 3 columns of design matrix with current background 
C========for this window and fill array with corresponding pixels
C 
                           PRF(IW,1) = SCALEB
                           PIX(IW) = AD(MM)
C     
C========Initialize design matrix
C 
                           DO 62 NB=2,MAXPAR
                              PRF(IW,NB) = 0.0
 62                        CONTINUE
                           IPOINT = 0
                           MPOINT = 0
C
C========Loop over peak points to form design matrix
C 
                           DO 68 LPOINT=1,NLLP
                              DO 66 K=JMIN(LPOINT),JMAX(LPOINT)
                                 IPOINT = IPOINT + 1
                                 IF(JN.GE.JMIN(LPOINT).AND.
     &                              JN.LE.JMAX(LPOINT))THEN
                                    DO 64 L=IMIN(IPOINT),IMAX(IPOINT)
                                       MPOINT = MPOINT + 1
                                       IF(L.EQ.IN.AND.K.EQ.JN)THEN
C     
C========Put profile value in the appropriate row
C
                                          IF(LPT(LPOINT).EQ.0)THEN
                                             IPEAK = IPEAK + 1
                                             LPT(LPOINT) = IPEAK
                                          ENDIF
                                          PRF(IW,LPT(LPOINT)) = 
     &                                    FLOAT(ICHAR(IDCIN(MPOINT)))
                                       ENDIF
 64                                 CONTINUE
                                 ELSE
                                    MPOINT = MPOINT + IMAX(IPOINT) -
     &                                   IMIN(IPOINT) + 1
                                 ENDIF
 66                           CONTINUE
 68                        CONTINUE
                        ENDIF
 70                  CONTINUE
 72               CONTINUE
C
C========Check number of peaks contributing to this window
C 
                  IF(IPEAK.GT.MAXPAR)THEN
                     WRITE(6,1020)
                     WRITE(4,1020)
                     IPEAK = MAXPAR
                  ENDIF 
                  IF(IPEAK.GT.IW)THEN
                     WRITE(6,1020)
                     WRITE(4,1020)
                     IPEAK = IW  
                  ENDIF 
C
C========Form normal equations 
C
                  DO 80 K=1,IPEAK
                     P(K,K) = 0.0D0
                     X(K) = 0.0D0
                     DO 74 L=1,IW
                        P(K,K) = P(K,K) + 
     &                       DBLE(PRF(L,K)*PRF(L,K))
                        X(K) = X(K) + DBLE(PRF(L,K)*PIX(L))
 74                  CONTINUE
                     DO 78 JN=1,K-1
                        P(JN,K) = 0.0D0
                        DO 76 IN=1,IW
                           P(JN,K) = P(JN,K) + 
     &                          DBLE(PRF(IN,JN)*PRF(IN,K))
 76                     CONTINUE
                        P(K,JN) = P(JN,K)
 78                  CONTINUE
 80               CONTINUE
C
C========decompose normal matrix into eigenvalues and eigenvectors
C 
                  CALL TRED2(P,IPEAK,MAXPAR,W,V)
                  CALL TQLI(W,V,IPEAK,MAXPAR,P)
C
C========Filter eigenvalues
C 
                  WMAX = 0.0D0
                  DO 82 NB=1,IPEAK
                     IF(W(NB).GT.WMAX)WMAX = W(NB)
 82               CONTINUE
                  THRESH = TOL*WMAX
                  DO 84 NB=1,IPEAK
                     IF(W(NB).LT.THRESH)THEN
                        W(NB) = 0.0D0
                     ENDIF
 84               CONTINUE
C
C========Back-substitute to get coefficients array
C
                  CALL TBKSB(W,P,IPEAK,MAXPAR,X,COF)
C
C========Re-scale the central background point of window
C
                  IBCK = IBCK + 1
                  B(M) = SNGL(COF(1))*SCALEB
                  XB(IBCK) = FLOAT(I)*DELR + RMIN 
                  YB(IBCK) = B(M)
C     
C========END OF SPECIFIC WINDOW BACKGROUND METHOD
C
               ENDIF
            ENDIF
 100     CONTINUE
C
C========Fit splines to fill in gaps in this raster
C
         IF(LINE.AND.IBCK.GT.1)THEN
            EPS = SQRT(2.0/FLOAT(IBCK))
            S = SMOO*FLOAT(IBCK)
            CALL CURVS(IBCK,XB,YB,1.0,1,S,EPS,YS,YSP,TENS,WRK,IER)
            IF(IER.NE.0)THEN
               WRITE(6,2000)IER
               WRITE(4,2000)IER
               STOP 'Fatal error'
            ENDIF
C
C========Interpolate
C
            DO 110 I=ISTRT+1,IEND-1
               M = (J-1)*NPIX + I
               IF(AD(M).GT.-0.99E+30)THEN
                  RS = DELR*FLOAT(I) + RMIN
                  B(M) = CURV2(RS,IBCK,XB,YS,YSP,TENS)
               ENDIF
 110        CONTINUE 
         ENDIF
 120  CONTINUE
C
C========Transpose the spline fitting
C
      DO 160 I=IFPIX,ILPIX
C
C========Set up arrays for interpolation
C
         IBCK = 0
         DO 140 J=IFRAST,ILRAST
            M = (J-1)*NPIX + I
            IF(B(M).GT.-0.99E+30)THEN
               IBCK = IBCK + 1
               XB(IBCK) = FLOAT(J)*DELZ + ZMIN
               YB(IBCK) = B(M)
            ENDIF
 140     CONTINUE
         IF(IBCK.GT.1)THEN
            EPS = SQRT(2.0/FLOAT(IBCK))
            S = SMOO*FLOAT(IBCK)
            CALL CURVS(IBCK,XB,YB,1.0,1,S,EPS,YS,YSP,TENS,WRK,IER)
            IF(IER.NE.0)THEN
               WRITE(6,2000)IER
               WRITE(4,2000)IER
               STOP 'Fatal error'
            ENDIF
C
C========Interpolate
C
            DO 150 J=IFRAST,ILRAST
               M = (J-1)*NPIX + I
               IF(AD(M).GT.-0.99E+30)THEN
                  ZS = DELZ*FLOAT(J) + ZMIN 
                  B(M) = CURV2(ZS,IBCK,XB,YS,YSP,TENS)
               ENDIF
 150        CONTINUE
         ENDIF  
 160  CONTINUE
C
C========Subtract background from AD and accumulate background in BB
C 
      DO 180 J=1,NRAST
         DO 170 I=1,NPIX
            M = (J-1)*NPIX + I
            IF(AD(M).GT.-0.99E+30)THEN
               AD(M) = AD(M) - B(M)
               BB(M) = BB(M) + B(M)   
            ENDIF
 170     CONTINUE 
 180  CONTINUE 
      RETURN 
C
 1000 FORMAT(/1X,'BGWLSH: Window background fitting...')
 1010 FORMAT(1X,'BGWLSH: Error - window size too large for array')
 1020 FORMAT(1X,'BGWLSH: Warning - too many peaks, resetting')      
 2000 FORMAT(1X,'***Error in spline fitting: FITPACK error ',I3)
      END

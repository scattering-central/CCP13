C     LAST UPDATE 16/03/98
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE BGCSYM(B,BB,SMOO,TENS,PC1,PC2)
      IMPLICIT NONE
C
C Purpose: Fits the background by the following method. The pixels are
C          assigned to a radial bin. The values held in this bin are  
C          sorted and pixel values in the range PC1 to PC2 are averaged
C          to form a background value for this bin. When the binning is
C          complete, the radial bin values are used to calculate spline
C          coefficients. Background values for the 2D image are then 
C          interpolated using these coefficients.
C
C Calls   2: SORT , CURVS
C Called by: LSQINT 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER MAXBIN,MAXDIM,MAXDAT,MAXNUM
      PARAMETER (MAXBIN=256,MAXDIM=512,MAXDAT=MAXDIM**2,MAXNUM=2048)
C
C Scalar arguments:
C
      REAL SMOO,TENS,PC1,PC2
C
C Array arguments:
C
      REAL B(MAXDAT),BB(MAXDAT)
C
C Common Arrays:
C
      REAL AD(MAXDAT),PSIG(MAXDAT)
C
C Common scalars:
C
      REAL DELR,RMIN,DELZ,ZMIN
      INTEGER IFPIX,ILPIX,IFRAST,ILRAST,NPIX,NRAST,IBACK
      LOGICAL SIGMA,POLAR
C
C Local arrays:
C
      REAL CSYB(MAXBIN),CSYD(MAXBIN),YS(MAXBIN),YSP(MAXBIN),
     &     WRK(9*MAXBIN),PIXBIN(MAXNUM)
      INTEGER INDEX(MAXNUM)
C
C Local Scalars:
C
      INTEGER NBIN,I,J,M,NB,IER,IBAD,NP,IP,IW,IBCK,IW1,IW2,I1,I2
      REAL RS,ZS,DINC,DS,DMAX,RMAX,ZMAX,S,EPS,D1,D2,BCK
C
C Common blocks:
C
      COMMON /INSPEC/ DELR,RMIN,DELZ,ZMIN,POLAR
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
C========Set B to zero
C
      DO 20 J=1,NRAST
         DO 10 I=1,NPIX
            M = (J-1)*NPIX + I
            B(M) = 0.0
 10      CONTINUE
 20   CONTINUE
C
C========Initialize limits and increment for binning
C
      IF(POLAR)THEN
         DMAX = MAX(ABS(RMIN),FLOAT(NPIX+1)*DELR+RMIN)
         NBIN = NPIX
      ELSE
         RMAX = MAX(ABS(RMIN),FLOAT(NPIX+1)*DELR+RMIN)
         ZMAX = MAX(ABS(ZMIN),FLOAT(NRAST+1)*DELZ+ZMIN)
         DMAX = SQRT(RMAX*RMAX+ZMAX*ZMAX)
         NBIN = NINT(SQRT(FLOAT(NPIX*NPIX+NRAST*NRAST)))
      ENDIF
      IF(NBIN.GT.MAXBIN)NBIN = MAXBIN
      DINC = DMAX/FLOAT(NBIN)
C
C========Loop over pixels and bin into d*
C
      IBAD = 0
      IBCK = 0
      DO 70 NB=1,NBIN
         D1 = FLOAT(NB-1)*DINC
         D2 = D1 + DINC
         NP = 0
         DO 50 J=1,NRAST
            IF(POLAR)THEN
               I1 = MAX(INT((D1-RMIN)/DELR)-1,1)
               I2 = MIN(INT((D2-RMIN)/DELR)+2,NPIX)
            ELSE
               ZS = (FLOAT(J)-0.5)*DELZ + ZMIN
               I1 = MAX(INT((SQRT(D1*D1-ZS*ZS)-RMIN)/DELR)-1,1)
               I2 = MIN(INT((SQRT(D2*D2-ZS*ZS)-RMIN)/DELR)+2,NPIX)
            ENDIF
            DO 40 I=I1,I2
               IF(POLAR)THEN
                  DS = (FLOAT(I)-0.5)*DELR + RMIN
               ELSE
                  RS = (FLOAT(I)-0.5)*DELR + RMIN
                  DS = SQRT(RS*RS+ZS*ZS)
               ENDIF
               IF(DS.GT.D1.AND.DS.LE.D2)THEN
                  M = (J-1)*NPIX + I
                  IF(AD(M).GT.-0.99E+30)THEN
                     IF(NP.LT.MAXNUM)THEN
                        NP = NP + 1
                        PIXBIN(NP) = AD(M)
                     ENDIF
                  ENDIF
               ENDIF
 40         CONTINUE
 50      CONTINUE
C
C========Sort pixel values and sum over desired interval
C
         IF(NP.GT.0)THEN
            CALL SORT(PIXBIN,NP,INDEX)
            IP = 0
            BCK = 0.0
            IW1 = MIN(INT(PC1*FLOAT(NP))+1,NP)
            IW2 = MIN(INT(PC2*FLOAT(NP))+1,NP)
            DO 60 IW=IW1,IW2
               IP = IP + 1
               BCK = BCK + PIXBIN(INDEX(IW))
 60         CONTINUE
C
C========Form average
C
            IBCK = IBCK + 1
            CSYB(IBCK) = BCK/FLOAT(IP)
            CSYD(IBCK) = (FLOAT(NB)-0.5)*DINC
         ELSE
            IBAD = IBAD + 1
         ENDIF
 70   CONTINUE
      WRITE(6,1005)IBCK,DINC,CSYD(1),CSYD(IBCK)
      WRITE(4,1005)IBCK,DINC,CSYD(1),CSYD(IBCK)
C
C========Calculate spline coefficients for interpolating radial bins
C
      IF(IBCK.GT.1)THEN
         EPS = SQRT(2.0/FLOAT(IBCK))
         S = SMOO*FLOAT(IBCK)
         CALL CURVS(IBCK,CSYD,CSYB,1.0,1,S,EPS,YS,YSP,TENS,WRK,IER)
         IF(IER.NE.0)THEN
            WRITE(6,2000)IER
            WRITE(4,2000)IER
            STOP 'Fatal error'
         ENDIF
C
C========Loop over image pixels to interpolate background values
C
         DO 90 J=IFRAST,ILRAST
            IF(.NOT.POLAR)ZS = (FLOAT(J)-0.5)*DELZ + ZMIN
            DO 80 I=IFPIX,ILPIX
               M = (J-1)*NPIX + I
               IF(POLAR)THEN
                  DS = (FLOAT(I)-0.5)*DELR + RMIN
               ELSE
                  RS = (FLOAT(I)-0.5)*DELR + RMIN
                  DS = SQRT(RS*RS+ZS*ZS)
               ENDIF
               IF(AD(M).GT.-0.99E+30)THEN
                  B(M) = CURV2(DS,IBCK,CSYD,YS,YSP,TENS)
               ENDIF
 80         CONTINUE
 90      CONTINUE
      ENDIF
C
C========Pass A back with the background subtracted
C 
      DO 110 J=1,NRAST
         DO 100 I=1,NPIX
            M = (J-1)*NPIX + I
            IF(AD(M).GT.-0.99E+30)THEN
               BB(M) = BB(M) + B(M)
               AD(M) = AD(M) - B(M)
            ENDIF
 100     CONTINUE 
 110  CONTINUE 
      WRITE(6,1010)
      WRITE(4,1010)
      RETURN
C
 1000 FORMAT(/1X,'BGCSYM: Circularly-symmetric background fitting...'/)
 1005 FORMAT(1X,'Number of radial bins: ',I4,2X,'increment: ',G12.5/
     &       1X,'over d* range: ',G12.5,' to ',G12.5)
 1010 FORMAT(/1X,'Circularly-symmetric background fitting done'/)
 2000 FORMAT(1X,'***Error in spline fitting: FITPACK error ',I3)
      END


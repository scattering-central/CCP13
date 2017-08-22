C     LAST UPDATE 21/02/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION FALL(PALL)
      IMPLICIT NONE
C
C Purpose: This function allows the generation of profiles from
C          multiple lattices of different types.
C
C Calls:  3: FBRAG  , FCONT  , CHICAL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER MAXALL,MAXLAT,MAXDAT
      PARAMETER(MAXALL=50,MAXLAT=3,MAXDAT=262144)
      INTEGER NLLPX
      PARAMETER(NLLPX=10000)
      INTEGER JWIDTHAV
      PARAMETER(JWIDTHAV=50)
      INTEGER IPOINTX
      PARAMETER(IPOINTX=JWIDTHAV*NLLPX)
      INTEGER IWIDTHAV,MPOINTX
      PARAMETER(IWIDTHAV=30,MPOINTX=IWIDTHAV*IPOINTX)
C
C Arguments:
C
      REAL PALL(MAXALL)
C
C Local variables:
C
      INTEGER I,J,NP,NPALL,IFLAG,NPAR
      REAL PR(14),SIG(NLLPX+8)
      REAL CHISQ,RFAC
C
C Common variables:
C
      REAL ALLINE(NLLPX+8),AD(MAXDAT),PSIG(MAXDAT)
      REAL ALLCEL(6,MAXLAT),LATLIM(6,MAXLAT),RADMM(MAXLAT)
      REAL SNORM(MAXLAT),SSCALE(NLLPX)
      REAL DELR,RMIN,DELZ,ZMIN
      REAL DMIN,DMAX,RADM,SN
      INTEGER*2 JMIN(NLLPX),JMAX(NLLPX)
      INTEGER*2 IMIN(IPOINTX),IMAX(IPOINTX)
      CHARACTER*1 IDCIN(MPOINTX)
      INTEGER L1,L2,NR1,NR2,NLDIV,NBESS
      INTEGER ISIZE(5),IHKL(4,NLLPX),INFO(3),MINFO(5,MAXLAT),
     &        MSIZE(5,MAXLAT),MBESS(MAXLAT),MLDIV(MAXLAT)
      INTEGER N1,N2,IBACK,NLLP,NPRD
      INTEGER MPTR,IPTR,LPTR,NPTR,NLAT
      LOGICAL SIGMA,POLAR
C
C Common blocks:
C
      COMMON /INSPEC/ DELR,RMIN,DELZ,ZMIN,POLAR
      COMMON /POINTS/ NLLP,NPRD,INFO,IHKL
      COMMON /COEFFS/ JMIN,JMAX,IMIN,IMAX,IDCIN,ISIZE
      COMMON /DLIMIT/ DMIN,DMAX,L1,L2,NR1,NR2,SN,NLDIV,NBESS,RADM
      COMMON /IMDATA/ N1,N2,IBACK,AD,PSIG,SIGMA
      COMMON /FITPAR/ ALLINE
      COMMON /POINTR/ MPTR,IPTR,LPTR,NPTR
      COMMON /LATICE/ NLAT,ALLCEL,MINFO,LATLIM,RADMM,MSIZE,MBESS,MLDIV
      COMMON /SCALES/ SNORM,SSCALE
C
C-----------------------------------------------------------------------
C
      IFLAG = 0
      NPALL = 0
      MPTR = 0
      IPTR = 0
      LPTR = 0
      NPTR = 0
      DO 40 I=1,NLAT
         WRITE(6,1000)I
         WRITE(4,1000)I
         NPRD = MINFO(4,I)
         DO 10 J=1,3
            INFO(J) = MINFO(J,I)
 10      CONTINUE
         IF(INFO(1).EQ.1)THEN
            NP = 14
         ELSE
            NP = 4
         ENDIF
         DO 20 J=1,NP
            PR(J) = PALL(NPALL+J)
 20      CONTINUE
         NPALL = NPALL + NP
         DO 30 J=1,5
            ISIZE(J) = MSIZE(J,I)
 30      CONTINUE
         NBESS = MBESS(I)
         RADM = RADMM(I)
         NLDIV = MLDIV(I)
         L1 = NINT(LATLIM(1,I))
         L2 = NINT(LATLIM(2,I))
         NR1 = NINT(LATLIM(3,I))
         NR2 = NINT(LATLIM(4,I))
         DMIN = LATLIM(5,I)
         DMAX = LATLIM(6,I)
         IF(INFO(1).EQ.0)THEN
            CALL FCONT(PR)
            MINFO(4,I) = NPRD
         ELSE
            CALL FBRAG(PR)
         ENDIF
         MINFO(5,I) = LPTR
         SNORM(I) = SN
 40   CONTINUE 
      IF(MOD(IBACK/16,2).EQ.1)THEN
         NPAR = NLLP + 8
      ELSE
         NPAR = NLLP
      ENDIF
      CALL CHICAL(ALLINE,JMIN,JMAX,NLLP,NPAR,IMIN,IMAX,IPTR,IDCIN,
     &            MPTR,AD,PSIG,N1,N2,IBACK,CHISQ,RFAC,SIG,
     &            SIGMA,IFLAG)
      
      FALL = RFAC
      RETURN
 1000 FORMAT(/1X,'Calculating profiles for cell ',I1)
      END

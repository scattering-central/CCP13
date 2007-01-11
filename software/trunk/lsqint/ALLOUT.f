C     LAST UPDATE 24/02/95
C-----------------------------------------------------------------------
C
      SUBROUTINE ALLOUT(IUNIT,OUTBRG,KPIC,IFRAME,PALL,SIG) 
      IMPLICIT NONE
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER MAXALL,MAXLAT
      PARAMETER(MAXALL=50,MAXLAT=3)
      INTEGER NLLPX
      PARAMETER(NLLPX=10000)
C
C Arguments:
C
      INTEGER IUNIT,KPIC,IFRAME
      REAL SIG(NLLPX+8),PALL(MAXALL)
      CHARACTER*80 OUTBRG
C
C Local variables:
C
      REAL PR(14),CST
      INTEGER I,NL,NBCK,LEN,NP,NPPAR,LPTR,NPTR
      CHARACTER*1 CH
      CHARACTER*80 OUTFIL
C
C Common variables:
C
      REAL ALLINE(NLLPX+8),AD(512*512),PSIG(512*512)
      REAL ALLCEL(6,MAXLAT),LATLIM(6,MAXLAT),RADMM(MAXLAT)
      REAL SNORM(MAXLAT),SSCALE(NLLPX)
      REAL DMIN,DMAX,SN,RADM
      INTEGER IHKL(4,NLLPX),INFO(3),MINFO(5,MAXLAT),
     &        MSIZE(5,MAXLAT),MBESS(MAXLAT),MLDIV(MAXLAT)
      INTEGER L1,L2,NR1,NR2,NLDIV,NBESS
      INTEGER NPIX,NRAST,IBACK,NLLP,NPRD
      INTEGER NLAT
      LOGICAL SIGMA
C
C Common blocks:
C
      COMMON /DLIMIT/ DMAX,DMIN,L1,L2,NR1,NR2,SN,NLDIV,NBESS,RADM
      COMMON /POINTS/ NLLP,NPRD,INFO,IHKL
      COMMON /IMDATA/ NPIX,NRAST,IBACK,AD,PSIG,SIGMA
      COMMON /FITPAR/ ALLINE
      COMMON /LATICE/ NLAT,ALLCEL,MINFO,LATLIM,RADMM,MSIZE,MBESS,MLDIV
      COMMON /SCALES/ SNORM,SSCALE
C
C-----------------------------------------------------------------------
C
      NP = 0
      NPTR = 0
      IF(MOD(IBACK/16,2).EQ.1)THEN
         NBCK = 8
      ELSE
         NBCK = 0
      ENDIF
      LPTR = NBCK
      DO 50 NL=1,NLAT
         DO 10 I=80,1,-1
            IF(OUTBRG(I:I).NE.' ')THEN
               LEN = I 
               GOTO 20
            ENDIF
 10      CONTINUE
 20      IF(NLAT.GT.1)THEN
            WRITE(CH,'(I1)')NL         
            OUTFIL = OUTBRG(1:LEN)//'.'//CH
         ELSE
            OUTFIL = OUTBRG
         ENDIF
         DO 30 I=1,3
            INFO(I) = MINFO(I,NL)
 30      CONTINUE
         IF(INFO(1).EQ.0)THEN
            NPRD = MINFO(4,NL)
            NPPAR = 4
         ELSE
            NPPAR = 14
         ENDIF
         DO 40 I=1,NPPAR
            PR(I) = PALL(NP+I)
 40      CONTINUE
         NP = NP + NPPAR
         SN = SNORM(NL)
         L1 = NINT(LATLIM(1,NL))
         L2 = NINT(LATLIM(2,NL))
         NR1 = NINT(LATLIM(3,NL))
         NR2 = NINT(LATLIM(4,NL))
         DMIN = LATLIM(5,NL)
         DMAX = LATLIM(6,NL)
         IF(INFO(1).EQ.0)THEN
            CST = PR(1)
            CALL CONOUT(IUNIT,ALLINE,SIG,NLLP,IHKL,NPRD,OUTFIL,KPIC,
     &                  IFRAME,IBACK,CST,LPTR,NPTR)
         ELSE
            CALL BRGOUT(IUNIT,ALLINE,SIG,NLLP,IHKL,NPRD,OUTFIL,KPIC,
     &                  IFRAME,IBACK,PR,INFO,LPTR,NL)
            NPTR = NPTR + MINFO(4,NL)
         ENDIF
         LPTR = MINFO(5,NL) + NBCK
 50   CONTINUE
      RETURN
      END


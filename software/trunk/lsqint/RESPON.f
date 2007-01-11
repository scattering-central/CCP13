C     LAST UPDATE 06/06/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE RESPON(E,NE,MAXE,RE,NRE,MAXRE,NESIZE,NRESIZ)
      IMPLICIT NONE
C
C Purpose: Multiply an image by a space-variant point-spread function
C
C Calls   0:
C Called by: LMAXENT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER NLLPX,JWIDTHAV,IPOINTX,IWIDTHAV,MPOINTX 
      PARAMETER(NLLPX=10000,JWIDTHAV=50)
      PARAMETER(IPOINTX=JWIDTHAV*NLLPX,IWIDTHAV=30)
      PARAMETER(MPOINTX=IWIDTHAV*IPOINTX)
C
C Scalar arguments:
C
      INTEGER NE,NRE,MAXE,MAXRE,NESIZE,NRESIZ
C
C Array arguments:
C
      REAL E(NESIZE,MAXE),RE(NRESIZ,MAXRE)
C
C Local variables:
C
      INTEGER I,J,IJ,LPOINT,IPOINT,MPOINT,NBCK
C
C Common arrays:
C
      REAL A(512*512),PSIG(512*512)
      INTEGER ISIZE(5)
      INTEGER*2 JMIN(NLLPX),JMAX(NLLPX),IMIN(IPOINTX),IMAX(IPOINTX)
      CHARACTER*1 IDCIN(MPOINTX)
C    
C Common scalars:
C
      INTEGER NPIX,NRAST,IFPIX,ILPIX,IFRAST,ILRAST,IBACK
      LOGICAL SIGMA
C
C Common blocks:
C
      COMMON /COEFFS/ JMIN,JMAX,IMIN,IMAX,IDCIN,ISIZE
      COMMON /IMDATA/ NPIX,NRAST,IBACK,A,PSIG,SIGMA
      COMMON /IMAGE / IFPIX,ILPIX,IFRAST,ILRAST
C
C-----------------------------------------------------------------------
      IF(MOD(IBACK/16,2).EQ.1)THEN
         NBCK = 8
      ELSE
         NBCK = 0
      ENDIF
C
C========Initialize RE(NRE)
C
      DO 20 J=IFRAST,ILRAST
         DO 10 I=IFPIX,ILPIX
            IJ = (J-1)*NPIX + I
            IF(A(IJ).GT.-0.99E+30)THEN
               RE(IJ,NRE) = 0.0
            ENDIF
 10      CONTINUE
 20   CONTINUE
C
C========Loop over allowed pixels
C
      IPOINT = 0
      MPOINT = 0
      DO 50 LPOINT=NBCK+1,NESIZE
C     
C========Loop over the heights in this profile
C 
         DO 40 J=JMIN(LPOINT),JMAX(LPOINT)
            IPOINT = IPOINT + 1
C     
C========Loop over the widths at this height
C     
            DO 30 I=IMIN(IPOINT),IMAX(IPOINT)
               MPOINT = MPOINT + 1
               IF(I.GE.IFPIX.AND.I.LE.ILPIX.AND.
     &            J.GE.IFRAST.AND.J.LE.ILRAST)THEN
                  IJ = (J-1)*NPIX + I
                  IF(A(IJ).GT.-0.99E+30)THEN
                     RE(IJ,NRE) = RE(IJ,NRE) + 
     &               FLOAT(ICHAR(IDCIN(MPOINT)))*E(LPOINT,NE)
                  ENDIF
               ENDIF
 30         CONTINUE
 40      CONTINUE
 50   CONTINUE
      RETURN
      END









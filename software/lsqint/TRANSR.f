C     LAST UPDATE 06/06/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE TRANSR(E,NE,MAXE,RE,NRE,MAXRE,NESIZE,NRESIZ)
      IMPLICIT NONE
C
C Purpose: Multiplication by the transpose of the response matrix
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
      IPOINT = 0
      MPOINT = 0
      DO 30 LPOINT=NBCK+1,NESIZE
         E(LPOINT,NE) = 0.0
C     
C========Loop over the heights in this profile
C 
         DO 20 J=JMIN(LPOINT),JMAX(LPOINT)
            IPOINT = IPOINT + 1
C
C========Loop over the widths at this height
C
            DO 10 I=IMIN(IPOINT),IMAX(IPOINT)
               MPOINT = MPOINT + 1
               IF(I.GE.IFPIX.AND.I.LE.ILPIX.AND.
     &            J.GE.IFRAST.AND.J.LE.ILRAST)THEN
                  IJ = (J-1)*NPIX + I
                  IF(A(IJ).GT.-0.99E+30)THEN
                     E(LPOINT,NE) = E(LPOINT,NE) + 
     &               FLOAT(ICHAR(IDCIN(MPOINT)))*RE(IJ,NRE)
                  ENDIF
               ENDIF
 10         CONTINUE
 20      CONTINUE
 30   CONTINUE
      RETURN
      END


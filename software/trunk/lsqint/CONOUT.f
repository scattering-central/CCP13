C     LAST UPDATE 24/02/95
C-----------------------------------------------------------------------
C
      SUBROUTINE CONOUT(IUNIT,ARR,SIG,NLLP,IHKL,NPRD,OUTBRG,KPIC,
     &                  IFRAME,IBACK,CST,LPTR,NPTR)
      IMPLICIT NONE
C
C Parameters:
C
      INTEGER NLLPX,MAXLAT
      PARAMETER(NLLPX=10000,MAXLAT=3)
C
C Array arguments:
C
      REAL ARR(NLLPX+8),SIG(NLLPX+8)
      INTEGER IHKL(4,NLLPX)
C
C Variable arguments:
C
      INTEGER NLLP,KPIC,NPRD,IUNIT,IBACK,IFRAME,LPTR,NPTR
      REAL CST
      CHARACTER*80 OUTBRG
C
C Common variables:
C
      REAL DELR,RMIN,DELZ,ZMIN,DMIN,DMAX,SN,RADM
      INTEGER L1,L2,NR1,NR2,NLDIV,NBESS
      LOGICAL POLAR
      REAL SNORM(MAXLAT),SSCALE(NLLPX)
      COMMON /INSPEC/ DELR,RMIN,DELZ,ZMIN,POLAR
      COMMON /DLIMIT/ DMAX,DMIN,L1,L2,NR1,NR2,SN,NLDIV,NBESS,RADM
      COMMON /SCALES/ SNORM,SSCALE
      LOGICAL LXPLOR
      INTEGER XPUNIT
      COMMON /CXPLOR/ LXPLOR,XPUNIT
C 
C Local variables:
C      
      REAL R,C,SCL
      INTEGER NH,NRD,NL,NR,IZ,MFD 
      INTEGER I,IO,NLAST,LEN,NBCK
      CHARACTER*3 CH
      CHARACTER*80 XPFILE
      DATA IZ /999/ , MFD /1/
C++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C========Set array offset for background parameters
C
      IF(MOD(IBACK/16,2).EQ.1)THEN
         NBCK = 8
      ELSE
         NBCK = 0
      ENDIF
C
C========Make filename for this cell
C
      IF(IFRAME.GT.1)THEN
         IF(KPIC.LT.10)THEN
            WRITE(CH,'(I1)')KPIC
         ELSEIF(KPIC.LT.100)THEN
            WRITE(CH,'(I2)')KPIC
         ELSEIF(KPIC.LT.999)THEN
            WRITE(CH,'(I3)')KPIC
         ELSE
            STOP 'Too many pictures'
         ENDIF
         DO 10 I=80,1,-1
            IF(OUTBRG(I:I).NE.' ')THEN
               LEN = I 
               GOTO 20
            ENDIF
 10      CONTINUE
 20      OUTBRG = OUTBRG(1:LEN)//'.'//CH  
      ENDIF
C
C========Open file and write header info
C
      OPEN(UNIT=IUNIT,FILE=OUTBRG,STATUS='UNKNOWN')
      C = 1.0/CST
      WRITE(IUNIT,2000)
      WRITE(IUNIT,2010)C
      WRITE(IUNIT,2020)DELR
C
C========Open Xplor file if required
C
      IF(LXPLOR)THEN
         XPFILE='XP'//OUTBRG
         OPEN(UNIT=XPUNIT,FILE=XPFILE,STATUS='UNKNOWN')
      ENDIF
C
C========Loop over points for this cell
C
      NLAST = 4*NPTR
      IO = LPTR
      DO 30 I=NLAST+1,NLAST+NPRD

C
C========Revolting use of IHKL array to see if this is a valid point
C
         NH = MOD(I-1,4) + 1
         NRD = (I-1)/4 + 1
         NL = (I-1)/(NR2-NR1+1) + L1 
C Changed 10/01/00 +(NR-1) term added
         NR = I - (NL-L1)*(NR2-NR1+1) +(NR1-1)
         IF(IHKL(NH,NRD).EQ.1)THEN
            IO = IO + 1
            R = FLOAT(NR)*DELR + RMIN 
C
C========Scale output for profile normalization and height
C
            SCL = SN*SSCALE(IO-NBCK)
            WRITE(IUNIT,1010)IZ,IZ,NL,R,MFD,SCL*ARR(IO),
     &                       SCL*SIG(IO)
            IF(LXPLOR)THEN
               CALL FXPOUT(XPUNIT,NINT(R/DELR),NL,
     &                     SCL*ARR(IO),SCL*SIG(IO))
            ENDIF
         ENDIF
 30   CONTINUE
      NPTR = NPTR + NRD
      CLOSE(IUNIT)
      IF(LXPLOR)CLOSE(XPUNIT)
      RETURN
 1010 FORMAT(3I4,E12.4,I4,2E12.4)
 2000 FORMAT(1X,'CONTINUOUS')
 2010 FORMAT(1X,'CELL ',F12.2)
 2020 FORMAT(1X,'DELTA ',E12.4)
      END

      SUBROUTINE FXPOUT(IOUT,IR,IL,RI,SG)
      IMPLICIT NONE
C
C Arguments:
C
      INTEGER IOUT,IR,IL
      REAL RI,SG

C
C Local variables:
C
      REAL AMP,SGA,WGT
C
C Evaluate amplitude and sigma as isolated peaks according to 
C DS Sivia & WIF David Acta Cryst. (1994). A50, 703-714
C
      IF(SG.GT.0.0)THEN
         AMP = 0.5*SQRT(2.0*RI+SQRT(4.0*RI*RI+8.0*SG*SG))
         SGA = 1.0/SQRT(1.0/(AMP*AMP)+2.0*(3.0*AMP*AMP-RI)/(SG*SG))
         WGT = 1.0/(SG*SG)
      ELSE
         AMP = 0.0
         SGA = 0.0
         WGT = 0.0
      ENDIF
C
C Write this reflection to X-PLOR file
C
      WRITE(IOUT,1000)IR,IL,AMP,SGA,WGT
      RETURN
 1000 FORMAT(1X,'index ',2I5,
     &       2X,'fobs ',G12.5,2X,'sigma ',G12.5,2X,'weight ',G12.5)
      END

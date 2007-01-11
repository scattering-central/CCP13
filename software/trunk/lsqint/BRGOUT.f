C     LAST UPDATE 06/07/93
C-----------------------------------------------------------------------
C
      SUBROUTINE BRGOUT(IUNIT,ALLINE,SIG,NLLP,IHKL,NPRD,OUTBRG,KPIC,
     &                  IFRAME,IBACK,PR,INFO,LPTR,NL)
      IMPLICIT NONE
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER NLLPX,MAXLAT
      PARAMETER (NLLPX=10000,MAXLAT=3)
C
C Array arguments:
C
      REAL ALLINE(NLLPX+8),SIG(NLLPX+8),PR(14)
      INTEGER IHKL(4,NLLPX),INFO(3)
C
C Variable arguments:
C
      INTEGER NLLP,KPIC,IFRAME,NPRD,IBACK,IUNIT,LPTR,NL
      CHARACTER*80 OUTBRG
C
C Common variables:
C
      REAL RMIN,DELR,ZMIN,DELZ
      LOGICAL POLAR
      COMMON /INSPEC/ DELR,RMIN,DELZ,ZMIN,POLAR
      REAL DMIN,DMAX,SN,RADM
      INTEGER L1,L2,NR1,NR2,NLDIV,NBESS
      COMMON /DLIMIT/ DMIN,DMAX,L1,L2,NR1,NR2,SN,NLDIV,NBESS,RADM
      REAL SNORM(MAXLAT),SSCALE(NLLPX)
      COMMON /SCALES/ SNORM,SSCALE
      LOGICAL LXPLOR
      INTEGER XPUNIT
      COMMON /CXPLOR/ LXPLOR,XPUNIT
C
C Local arrays:
C
      REAL CELL(6),RCELL(6),AMAT(3,3)
      INTEGER IH(128),IK(128),IL(128),MUL(128)
C 
C Local variables:
C
      REAL DUMI,DUMS,D,R,Z,SCL
      INTEGER I,LEN,MFD,IP,IO,IM,IR,MDUM,NBCK
      CHARACTER*3 CH
      CHARACTER*80 LINE,DFILE,XPFILE
      DATA DUMI/0.0/,DUMS/0.0/,MDUM/0/
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
      IF(INFO(2).LE.2)THEN
C
C========Trigonal or tetragonal cell
C 
         RCELL(1) = PR(5)
         RCELL(2) = PR(5)
      ELSE
C
C========Orthorhombic, monoclinic or triclinic cell
C 
         RCELL(1) = PR(5)
         RCELL(2) = PR(9)
      ENDIF
      RCELL(3) = PR(1)
      RCELL(4) = PR(10)
      RCELL(5) = PR(11)
      RCELL(6) = PR(12)
      CALL MATCAL(INFO(3),PR(13),PR(14),RCELL,AMAT)
      CALL RECCEL(RCELL,CELL)
      DO 25 I=4,6 
         CELL(I) = CELL(I)*45.0/ATAN(1.0)
 25   CONTINUE
C
C========Write output file header
C
      OPEN(UNIT=IUNIT,FILE=OUTBRG,STATUS='UNKNOWN')
      WRITE(IUNIT,2000)
      WRITE(IUNIT,2010)CELL
      WRITE(IUNIT,2020)DELR
C
C========Open Xplor file if required
C
      IF(LXPLOR)THEN
         XPFILE='XP'//OUTBRG
         OPEN(UNIT=XPUNIT,FILE=XPFILE,STATUS='UNKNOWN')
      ENDIF
C
C========Open appropriate DRAGON file and read header
C
      WRITE(DFILE,'(A10,I1)')'DRAGON.OUT',NL
      OPEN(UNIT=20,FILE=DFILE,STATUS='OLD')
      READ(20,'(A80)')LINE
C
C========Loop over reflections in DRAGON file
C
      IR = 0
      IP = 0
      IO = LPTR
      IM = 0
 30   CONTINUE
      IR = IR + 1
      IM = IM + 1
      READ(20,1000,END=50)IH(IM),IK(IM),IL(IM),MUL(IM),MFD,D,R,Z
C
C========Multiplicity > 0 for unique points
C
      IF(MFD.GT.0)THEN
         IP = IP + 1
         CALL RZDCAL(AMAT,IH(IM),IK(IM),IL(IM),R,Z,D)
C
C========Valid points in resolution range etc.
C
         IF(IHKL(4,IP).EQ.1)THEN
            IO = IO + 1
C
C========Scale for profile normalization and height
C
            SCL = SN*SSCALE(IO-NBCK)
C
C========Write out preceding indices of multiplet set with zeros
C
            DO 40 I=1,IM-1
               WRITE(IUNIT,1010)IH(I),IK(I),IL(I),R,MDUM,DUMI,DUMS
               IF(LXPLOR)THEN
                  CALL PXPOUT(XPUNIT,IH(I),IK(I),IL(I),MUL(I),MDUM,
     &                        DUMI,DUMS)
               ENDIF
 40         CONTINUE
C
C========Write the sum to last set of indices
C
            WRITE(IUNIT,1010)IH(IM),IK(IM),IL(IM),R,MFD,
     &                       SCL*ALLINE(IO),SCL*SIG(IO)
            IF(LXPLOR)THEN
               CALL PXPOUT(XPUNIT,IH(IM),IK(IM),IL(IM),MUL(IM),MFD,
     &                     SCL*ALLINE(IO),SCL*SIG(IO))
            ENDIF
         ENDIF
         IM = 0
      ENDIF 
      GOTO 30
 50   CLOSE(IUNIT)
      CLOSE(20)
      IF(LXPLOR)CLOSE(XPUNIT)
      RETURN
C
 1000 FORMAT(1X,3I4,2I5,1X,3E14.6)
 1010 FORMAT(3I4,E12.4,I4,2E12.4)
 1020 FORMAT(1X,'BRGOUT: Warning - IO(',I4,') .ne. NLLP(',I4,')')
 2000 FORMAT(1X,'BRAGG')
 2010 FORMAT(1X,'CELL ',6F12.2)
 2020 FORMAT(1X,'DELTA ',E12.4)
      END
C
      SUBROUTINE PXPOUT(IOUT,IH,IK,IL,M,MF,RI,SG)
      IMPLICIT NONE
C
C Arguments:
C
      INTEGER IOUT,IH,IK,IL,M,MF
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
      WRITE(IOUT,1000)IH,IK,IL,M,MF,AMP,SGA,WGT
      RETURN
 1000 FORMAT(1X,'index ',3I5,2X,'mult ',I5,2X,'fmul ',I5,
     &       2X,'fobs ',G12.5,2X,'sigma ',G12.5,2X,'weight ',G12.5)
      END
      

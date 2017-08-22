C     LAST UPDATE 24/02/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FLIST(KUNIT)
      IMPLICIT NONE
C
C Purpose: Lists coordinates and intensities held in common and writes
C          to file FIX.OUT. 
C
C Calls   RDCOM:
C Called by: FIX 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file:
C
      INCLUDE 'FIXPAR.COM'
C
C Arguments:
C
      INTEGER KUNIT
C
C Local variables:
C
      INTEGER I,J,NTYPE
      REAL RTOD,D
      CHARACTER*7 TYPE(3)
C
      DATA TYPE /'POINT', 'POLYGON', 'SECTOR'/
      DATA RTOD /57.29578/
C
C-----------------------------------------------------------------------
      WRITE(KUNIT,1005)
C
C========List known parameters
C
      IF(GOTWAV)THEN
         WRITE(KUNIT,1000)WAVE
      ELSE
         WRITE(KUNIT,1010)
      ENDIF
      IF(GOTSDD)THEN
         WRITE(KUNIT,1020)SDD
      ELSE
         WRITE(KUNIT,1030)
      ENDIF
      IF(GOTCEN)THEN
         WRITE(KUNIT,1040)XC,YC
      ELSE
         WRITE(KUNIT,1050)
      ENDIF
      IF(GOTROT)THEN
         WRITE(KUNIT,1060)RTOD*ROTX,RTOD*ROTY,RTOD*ROTZ
      ELSE
         WRITE(KUNIT,1070)
      ENDIF
      IF(GOTTIL)THEN
         WRITE(KUNIT,1080)-RTOD*TILT
      ELSE
         WRITE(KUNIT,1090)
      ENDIF
C
C========List points
C
      IF(NPTS.EQ.0)RETURN
      WRITE(KUNIT,1100)
      DO 10 I=1,NPTS
         IF(NVALS(I).LT.0)THEN
            NTYPE = 3
         ELSEIF(NVALS(I).GT.1)THEN
            NTYPE = 2
         ELSE
            NTYPE = 1
         ENDIF
         D = SQRT(RZ(1,I)*RZ(1,I)+RZ(2,I)*RZ(2,I))
         WRITE(KUNIT,1110)TYPE(NTYPE),I,(FXY(J,I),J=1,2),
     &                    (SXY(J,I),J=1,2),(RZ(J,I),J=1,2),D,AVPIX(I)
 10   CONTINUE
C
 1005 FORMAT(/1X,'New listing...'/)
 1000 FORMAT(1X,'Wavelength = ',F6.3)
 1010 FORMAT(1X,'Don''t know wavelength')
 1020 FORMAT(1X,'Specimen-to-detector distance = ',F8.1)
 1030 FORMAT(1X,'Don''t know specimen-to-detector distance')
 1040 FORMAT(1X,'Centre coordinates = ',2F8.1)
 1050 FORMAT(1X,'Don''t know centre coordinates')
 1060 FORMAT(1X,'Detector rotation = ',F9.4/
     &       1X,'         twist    = ',F9.4/
     &       1X,'         tilt     = ',F9.4)
 1070 FORMAT(1X,'Don''t know detector rotation angles')
 1080 FORMAT(1X,'Specimen tilt angle = ',F6.1)
 1090 FORMAT(1X,'Don''t know specimen tilt angle')
 1100 FORMAT(/2X,'No.',6X,'Filespace',8X,'Standard',11X,'Reciprocal',
     &       6X,'Av. pixel',3X,'Background',3X,'Intensity',6X,'Type'/
     &       2X,'         X       Y',8X,'X       Y',10X,'R        Z')
 1110 FORMAT(1X,A7,1X,I3,1X,2F8.1,1X,2F8.1,4X,3F9.5,
     &       3X,G12.5)
      END                  

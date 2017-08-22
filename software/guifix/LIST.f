C     LAST UPDATE 15/05/97
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE LIST(KUNIT)
      IMPLICIT NONE
C
C Purpose: Lists coordinates and intensities held in common.
C
C Calls    : 
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
      DATA TYPE /'Point', 'Polygon', 'Sector'/
      DATA RTOD /57.29578/
C
C-----------------------------------------------------------------------
C
C========List known parameters
C
      IF(GOTWAV)THEN
         WRITE(6,1000)WAVE
         WRITE(KUNIT,1000)WAVE
      ELSE
         WRITE(6,1010)
         WRITE(KUNIT,1010)
      ENDIF
      IF(GOTSDD)THEN
         WRITE(6,1020)SDD
         WRITE(KUNIT,1020)SDD
      ELSE
         WRITE(6,1030)
         WRITE(KUNIT,1030)
      ENDIF
      IF(GOTCEN)THEN
         WRITE(6,1040)XC,YC
         WRITE(KUNIT,1040)XC,YC
      ELSE
         WRITE(6,1050)
         WRITE(KUNIT,1050)
      ENDIF
      IF(GOTROT)THEN
         WRITE(6,1060)RTOD*ROTX,RTOD*ROTY,RTOD*ROTZ,XCB,YCB
         WRITE(KUNIT,1060)RTOD*ROTX,RTOD*ROTY,RTOD*ROTZ,XCB,YCB
      ELSE
         WRITE(6,1070)
         WRITE(KUNIT,1070)
      ENDIF
      IF(GOTTIL)THEN
         WRITE(6,1080)-RTOD*TILT
         WRITE(KUNIT,1080)-RTOD*TILT
      ELSE
         WRITE(6,1090)
         WRITE(KUNIT,1090)
      ENDIF
C
C========Convert to standard coordinates if possible
C 
      IF(GOTCEN.AND.GOTROT)THEN
         CALL FTOSTD
         IF(GOTWAV.AND.GOTSDD.AND.GOTTIL)CALL STOREC
      ENDIF
C
C========List points
C
      IF(NPTS.EQ.0)RETURN
      WRITE(6,1100)
      WRITE(KUNIT,1100)
      DO 10 I=1,NPTS
         IF(NVALS(I).LT.0)THEN
            NTYPE = 3
         ELSEIF(NVALS(I).EQ.1)THEN
            NTYPE = 1
         ELSE
            NTYPE = 2
         ENDIF
         D = SQRT(RZ(1,I)*RZ(1,I)+RZ(2,I)*RZ(2,I))
         WRITE(6,1110)TYPE(NTYPE),I,(FXY(J,I),J=1,2),(SXY(J,I),J=1,2),
     &                (RZ(J,I),J=1,2),D,AVPIX(I)
         WRITE(KUNIT,1110)TYPE(NTYPE),I,(FXY(J,I),J=1,2),
     &                    (SXY(J,I),J=1,2),(RZ(J,I),J=1,2),D,AVPIX(I)
 10   CONTINUE
C
 1000 FORMAT(1X,'200 Wavelength = ',F6.3)
 1010 FORMAT(1X,'200 Don''t know wavelength')
 1020 FORMAT(1X,'200 Specimen-to-detector distance = ',F8.1)
 1030 FORMAT(1X,'200 Don''t know specimen-to-detector distance')
 1040 FORMAT(1X,'200 Detector centre coordinates  = ',2F8.1)
 1050 FORMAT(1X,'200 Don''t know centre coordinates')
 1060 FORMAT(1X,'200 Detector rotation = ',F9.4/
     &       1X,'200          twist    = ',F9.4/
     &       1X,'200          tilt     = ',F9.4/
     &       1X,'200 Main beam centre coordinates = ',2F8.1)
 1070 FORMAT(1X,'200 Don''t know detector rotation angles')
 1080 FORMAT(1X,'200 Specimen tilt angle = ',F6.1)
 1090 FORMAT(1X,'200 Don''t know specimen tilt angle')
 1100 FORMAT(/1X,'200',6X,'No.',5X,'Filespace',8X,'Standard',
     &       15X,'Reciprocal',12X,'Av. pixel'/
     &       1X,'200',14X,'X',7X,'Y',8X,'X',7X,'Y',
     &       10X,'R',8X,'Z',8X,'D')
 1110 FORMAT(1X,A7,1X,I3,1X,2F8.1,1X,2F8.1,4X,3F9.5,
     &       3X,G12.5)
      END                  

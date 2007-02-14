C     LAST UPDATE 17/07/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE CENTRE(VALS,NV)
      IMPLICIT NONE
C
C Purpose: Determine centre of diffraction pattern from at least three 
C          points 
C
C Calls   3: RDCOMF, FRPRMN, ASK 
C Called by: FIX 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file
C
      INCLUDE 'FIXPAR.COM'
C
C Arguments:
C
      INTEGER NV
      REAL VALS(10)
C
C Common block:
C
      REAL XD(MAXPTS),YD(MAXPTS)
      INTEGER NDAT
      COMMON /CIRDAT/ XD,YD,NDAT
C
C External functions:
C
      REAL FUNC
      EXTERNAL FUNC,DFUNC
C
C Local variables:
C
      INTEGER I,J,K
      REAL X(3)
      REAL RESSQ,FTOL,ALPHA,TOP,DEN,DX,DY
      INTEGER ITER
      LOGICAL REPLY
C
      DATA FTOL /0.01/
C
C-----------------------------------------------------------------------
      IF(NV.EQ.0)THEN
         VALS(1) = 1.0
         VALS(2) = FLOAT(NPTS)
         NV = 2
      ELSEIF(NV.EQ.1)THEN
         IF(NINT(VALS(1)).GE.1.AND.NINT(VALS(1)).LE.NPTS)THEN
            XC = FXY(1,NINT(VALS(1)))
            YC = FXY(2,NINT(VALS(1)))
            GOTCEN = .TRUE.
C
C========Draw centre
C
            PRINT *, '500 DRAW CROSS ',XC,YC
            PRINT *, '500 CENTRE ',XC,YC
            CALL FLUSH(6)
            RETURN
         ELSE
            WRITE(6,1040)
            CALL FLUSH(6)
         ENDIF
      ENDIF
C
C========Copy relevant coordinates into work arrays 
C
      K = 0
      DO 30 I=1,NV-1,2
         IF(I+1.GT.NV)VALS(I+1) = VALS(I)
         DO 40 J=NINT(VALS(I)),NINT(VALS(I+1))
            IF(J.LT.1.OR.J.GT.NPTS)THEN
               WRITE(6,1040)
               CALL FLUSH(6)
               RETURN
            ENDIF
            K = K + 1
            XD(K) = FXY(1,J)
            YD(K) = FXY(2,J)
 40      CONTINUE
 30   CONTINUE
      NDAT = K
      IF(NDAT.EQ.2)THEN
         XC = (XD(1)+XD(2))/2.0
         YC = (YD(1)+YD(2))/2.0
         GOTCEN = .TRUE.
      ELSE
C     
C========Guess at centre and radius from first three points
C     
         TOP = (XD(3)-XD(2))*(XD(1)-XD(3)) +
     &        (YD(3)-YD(2))*(YD(1)-YD(3))
         DEN = (XD(2)-XD(3))*(YD(2)-YD(1)) +
     &        (YD(2)-YD(3))*(XD(1)-XD(2))
         ALPHA = TOP/(2.0*DEN)
         X(1) = (XD(1)+XD(2))/2.0 + ALPHA*(YD(2)-YD(1))
         X(2) = (YD(1)+YD(2))/2.0 + ALPHA*(XD(1)-XD(2))
         X(3) = SQRT((XD(1)-X(1))**2 + (YD(1)-X(2))**2)
         WRITE(6,1050)(X(I),I=1,3)
C     
C========Minimise residual using conjugate gradient method  
C      
         CALL FRPRMN(X,3,FTOL,ITER,RESSQ,FUNC,DFUNC)
         WRITE(6,1060)(X(I),I=1,3),ITER,SQRT(RESSQ/FLOAT(K-1))
         XC = X(1)
         YC = X(2)
         XCB = XC
         YCB = YC
         GOTCEN = .TRUE.
C     
C========Draw crosses on images
C
         DO 50 I=1,NDAT
            DX = XD(I) - XC
            DY = YD(I) - YC
            DEN = SQRT(DX*DX+DY*DY)
            XD(I) = XC + DX*X(3)/DEN - 0.5
            YD(I) = YC + DY*X(3)/DEN - 0.5
            PRINT *, '500 DRAW CROSS ',XD(I),YD(I)
 50      CONTINUE
C
C========Draw circle
C
         PRINT *, '500 DRAW CIRCLE ',XC,YC,X(3)
C
C========Calculate specimen-to-detector distance if required
C   
         IF(GOTWAV.AND.GOTCAL)THEN
            REPLY = .NOT.GOTSDD
            CALL ASK('700 Calculate specimen to detector distance',
     &           REPLY, 0)
            IF(REPLY)THEN
               SDD = X(3)/TAN(2.0*ASIN(WAVE/(2.0*DCAL)))
               PRINT *, '500 DISTANCE ',SDD
               WRITE(6,1080)SDD
               CALL FLUSH(6)
               GOTSDD = .TRUE.
            ENDIF
         ENDIF
      ENDIF
C
C========Draw centre
C
      PRINT *, '500 DRAW CROSS ',XC,YC
      PRINT *, '500 CENTRE ',XC,YC
      CALL FLUSH(6)
 9999 RETURN
C
 1020 FORMAT(1X,'200',
     &       1X,'Enter coordinate ranges for centre determination: ',$)
 1040 FORMAT(1X,'200',
     &       1X,'Selected point is out of range')
 1050 FORMAT(1X,'200',
     &       1X,'First estimation   X = ',F6.1,'  Y = ',F6.1,'  R = ',
     &       F6.1)
 1060 FORMAT(/1X,'200 Least-squares'/
     &       1X,'Centre  X = ',F6.1,'  Y = ',F6.1,'   Radius = ',F6.1,
     &       1X,'after ',I3,' iterations'/
     &       1X,'Residual = ',F7.3)
 1080 FORMAT(1X,'200 Specimen-to-detector distance = ',F10.1)
 2000 FORMAT(1X,'400 Numeric input only')
C-----------------------------------------------------------------------
      END                  

C     LAST UPDATE 10/12/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE CTILT(VALS,NV)
      IMPLICIT NONE
C
C Purpose: Determines tilt from pairs of corresponding points 
C
C Calls   2: RDCOMF, STOREC
C Called by: FIX 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file:
C
      INCLUDE 'FIXPAR.COM'
C
C Arguments:
C
      INTEGER NV
      REAL VALS(10)
C
C Local variables:
C
      INTEGER I,I1,I2,K
      REAL SCHI(MAXPTS/2),TEMP(MAXPTS/2)
      REAL TOP,DEN,RTOD,CHI1,CHI2,RESSQ,RESID,SD2,DAV
      LOGICAL PAIRS,RETN
C
      DATA RTOD /57.29578/
C
C-----------------------------------------------------------------------
C
C========Check to see if we have wavelength, specimen-to-detector 
C========distance, centre and rotation angle
C
      RETN = .FALSE.
      IF(.NOT.GOTWAV)THEN
         RETN = .TRUE.
         WRITE(6,1000)
      ENDIF
      IF(.NOT.GOTSDD)THEN
         RETN = .TRUE.
         WRITE(6,1010)
      ENDIF
      IF(.NOT.GOTCEN)THEN
         RETN = .TRUE.
         WRITE(6,1020)
      ENDIF
      IF(.NOT.GOTROT)THEN
         RETN = .TRUE.
         WRITE(6,1030)
      ENDIF
      CALL FLUSH(6)
      IF(RETN)RETURN 
C
C========Inquire as to which pairs of points to use in tilt
C========determination
C
      PAIRS = .FALSE.
      IF(NV.EQ.0)THEN
         PAIRS = .TRUE.
      ELSEIF(NV.LT.2)THEN
         WRITE(6,1070)
         CALL FLUSH(6)
         RETURN
      ENDIF
C
C========Compile least-squares solution from each pair of data
C
      SD2 = SDD*SDD
      TOP = 0.0
      DEN = 0.0
      K = 0
      IF(PAIRS)THEN
         DO 30 I=1,NPTS-1,2
            K = K + 1
            CHI1 = ATAN2(SXY(2,I),SQRT(SXY(1,I)**2+SD2))
            CHI2 = ATAN2(SXY(2,I+1),SQRT(SXY(1,I+1)**2+SD2))
            DAV = 0.5*(SQRT(SXY(1,I)**2+SXY(2,I)**2)+
     &                 SQRT(SXY(1,I+1)**2+SXY(2,I+1)**2))
            TEMP(K) = 4.0*SIN(0.5*ATAN2(DAV,SDD))**2
            SCHI(K) = SIN(-CHI1) + SIN(-CHI2) 
            WRITE(6,1080)I,I+1,-RTOD*ATAN2(SCHI(K),TEMP(K))
            CALL FLUSH(6)
            TOP = TOP + TEMP(K)*SCHI(K)
            DEN = DEN + TEMP(K)*TEMP(K)
 30      CONTINUE
      ELSE
         DO 40 I=1,NV-1,2
            K = K + 1
            I1 = NINT(VALS(I))
            I2 = NINT(VALS(I+1))
            CHI1 = ATAN2(SXY(2,I1),SQRT(SXY(1,I1)**2+SD2))
            CHI2 = ATAN2(SXY(2,I2),SQRT(SXY(1,I2)**2+SD2))
            DAV = 0.5*(SQRT(SXY(1,I1)**2+SXY(2,I1)**2)+
     &                 SQRT(SXY(1,I2)**2+SXY(2,I2)**2))
            TEMP(K) = 4.0*SIN(0.5*ATAN2(DAV,SDD))**2
            SCHI(K) = SIN(-CHI1) + SIN(-CHI2)
            IF(ABS(TEMP(K)).LT.1.0E-20)THEN
               TILT = 0.0
            ELSE
               TILT = ATAN(SCHI(K)/TEMP(K))
            ENDIF
            WRITE(6,1080)I1,I2,-RTOD*ATAN2(SCHI(K),TEMP(K))
            CALL FLUSH(6)
            TOP = TOP + TEMP(K)*SCHI(K)
            DEN = DEN + TEMP(K)*TEMP(K)
 40      CONTINUE
      ENDIF
      TILT = ATAN2(TOP,DEN)
      GOTTIL = .TRUE.
C
C========Calculate residual
C
      IF(K.GT.1)THEN
         RESSQ = 0.0
         IF(DEN.GT.0.0)THEN
            DO 50 I=1,K
               RESSQ = RESSQ + (TEMP(I)*TOP/DEN-SCHI(I))**2 
 50         CONTINUE
         ENDIF
         RESID = RTOD*SQRT(RESSQ/(DEN*FLOAT(K-1)))*COS(TILT)**2
         WRITE(6,1090)-RTOD*TILT,RESID
         CALL FLUSH(6)
      ENDIF
      PRINT *, '500 TILT ',-RTOD*TILT
      CALL FLUSH(6)
      CALL STOREC
      RETURN
C
 1000 FORMAT(1X,'300 No wavelength!')
 1010 FORMAT(1X,'300 No specimen-to-detector distance!')
 1020 FORMAT(1X,'300 No centre coordinates!')
 1030 FORMAT(1X,'300 No rotation angle!')
 1060 FORMAT(1X,'Enter pairs of points for tilt determination: ',$)
 1070 FORMAT(1X,'400',1X,'Not enough points')
 1080 FORMAT(1X,'200',
     &       1X,'Points ',I3,' and ',I3,'   tilt angle =',F6.1)
 1090 FORMAT(1X,'200 Least-squares tilt angle =',F6.1/
     &       1X,'200 Residual =',F6.2)
 2000 FORMAT(1X,'400 Numeric input only')
      END                  

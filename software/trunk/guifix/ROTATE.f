C     LAST UPDATE 10/12/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE ROTATE(VALS,NV)
      IMPLICIT NONE
C
C Purpose: Determine rotation from pairs of points  
C
C Calls   2: RDCOMF, FTOSTD 
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
      INTEGER I,K
      REAL XDIF(MAXPTS/2),YDIF(MAXPTS/2)
      REAL TOP,DEN,RTOD,RESSQ,RESID,PIBY2
      LOGICAL PAIRS
C
      DATA RTOD /57.29578/ , PIBY2 /1.57079633/
C
C-----------------------------------------------------------------------
      PAIRS = .FALSE.
      IF(NV.EQ.0)THEN
         PAIRS = .TRUE.
      ELSEIF(NV.EQ.1)THEN
         IF(GOTCEN)THEN
            IF(NINT(VALS(1)).GE.1.AND.NINT(VALS(1)).LE.NPTS)THEN
               ROTX = ATAN2(XC-FXY(1,NINT(VALS(1))),
     &                      YC-FXY(2,NINT(VALS(1))))
               GOTROT = .TRUE.
            ENDIF
         ELSE
            WRITE(6,1030)
            CALL FLUSH(6)
         ENDIF
      ENDIF
C
C========Compile least-squares solution from each pair of data
C
      TOP = 0.0
      DEN = 0.0
      K = 0
      IF(PAIRS)THEN
         DO 30 I=1,NPTS-1,2
            K = K + 1
            XDIF(K) = FXY(1,I) - FXY(1,I+1)
            YDIF(K) = FXY(2,I) - FXY(2,I+1)
            IF(ABS(XDIF(K)).GT.0.01)THEN
               ROTX = ATAN(YDIF(K)/XDIF(K))
            ELSE
               ROTX = PIBY2
            ENDIF
            WRITE(6,1040)I,I+1,RTOD*ROTX
            TOP = TOP + YDIF(K)*XDIF(K)
            DEN = DEN + XDIF(K)*XDIF(K)
 30      CONTINUE
      ELSE
         DO 40 I=1,NV-1,2
            K = K + 1
            XDIF(K) = FXY(1,NINT(VALS(I))) - FXY(1,NINT(VALS(I+1)))
            YDIF(K) = FXY(2,NINT(VALS(I))) - FXY(2,NINT(VALS(I+1)))
            IF(ABS(XDIF(K)).GT.0.01)THEN
               ROTX = ATAN(YDIF(K)/XDIF(K))
            ELSE
               ROTX = PIBY2
            ENDIF
            WRITE(6,1040)NINT(VALS(I)),NINT(VALS(I+1)),RTOD*ROTX
            TOP = TOP + YDIF(K)*XDIF(K)
            DEN = DEN + XDIF(K)*XDIF(K)
 40      CONTINUE
      ENDIF
C
C========Calculate least-squares rotation and residual
C
      IF(K.GT.1)THEN
         IF(DEN.EQ.0.0)THEN
            ROTX = PIBY2
         ELSE
            ROTX = ATAN2(TOP,DEN)
         ENDIF
         RESSQ = 0.0
         IF(DEN.GT.0.0)THEN
            DO 50 I=1,K
               RESSQ = RESSQ + (XDIF(I)*TOP/DEN-YDIF(I))**2
 50         CONTINUE
         ENDIF
         RESID = RTOD*SQRT(RESSQ/(DEN*FLOAT(K-1)))*COS(ROTX)**2
         WRITE(6,1050)RTOD*ROTX,RESID
         CALL FLUSH(6)
      ENDIF
      ROTY = 0.0
      ROTZ = 0.0
      GOTROT = .TRUE.
      PRINT *, '500 ROTATION ',ROTX*RTOD,ROTY*RTOD,ROTZ*RTOD
      CALL FLUSH(6)
      IF(GOTCEN)CALL FTOSTD
      RETURN
C
 1020 FORMAT(1X,'Enter pairs of points for rotation determination: ',$)
 1030 FORMAT(1X,'200',1X,'Not enough points')
 1040 FORMAT(/1X,'200',
     &       1X,'Points ',I3,' and ',I3,'   rotation angle =',F6.1)
 1050 FORMAT(1X,'Least-squares rotation angle =',F6.1/
     &       1X,'Residual =',F6.2)
 2000 FORMAT(1X,'400 Numeric input only')
      END                  

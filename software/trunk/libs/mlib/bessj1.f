         
      REAL FUNCTION BESSJ1(X)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C Purpose: Calculate J1(X)
C
C Arguments:
C
      REAL X
C
C Local Arrays:
C
      REAL*8 PCOF(0:4),QCOF(0:4),RCOF(0:5),SCOF(0:5)
C
C Local Scalars:
C
      REAL*8 Y,AX,Z,DX,XX,TMP1,TMP2
      INTEGER I
C
C Data:
C
      DATA PCOF/-0.2403370190D-06, 0.2457520174D-05,-0.3516396496D-04,
     &           0.1831050000D-02, 1.0D0/
      DATA QCOF/ 0.1057874120D-06,-0.8822898700D-06, 0.8449199096D-05,
     &          -0.2002690873D-03, 0.4687499995D-01/
      DATA RCOF/-0.3016036606D+02, 0.1570448260D+05,-0.2972611439D+07,
     &           0.2423968531D+09,-0.7895059235D+10, 0.72362614232D+11/
      DATA SCOF/ 1.0D0           , 0.3769991397D+03, 0.9944743394D+05,
     &           0.1858330474D+08, 0.2300535178D+10, 0.144725228442D+12/
C
C-----------------------------------------------------------------------
      DX = DBLE(X)
      IF(ABS(X).LT.8.0)THEN
         Y = DX*DX
         TMP1 = RCOF(0)
         TMP2 = SCOF(0)
         DO 10 I=1,5
            TMP1 = TMP1*Y + RCOF(I)
            TMP2 = TMP2*Y + SCOF(I)
 10      CONTINUE
         BESSJ1 = SNGL(DX*TMP1/TMP2)
      ELSE
         AX = ABS(DX)
         Z = 8.0D0/AX
         Y = Z*Z
         XX = AX - 2.356194491D0
         TMP1 = PCOF(0)
         TMP2 = QCOF(0)
         DO 20 I=1,4
            TMP1 = TMP1*Y + PCOF(I)
            TMP2 = TMP2*Y + QCOF(I)
 20      CONTINUE
         BESSJ1 = SNGL(SQRT(0.636619772D0/AX)
     &                 *(COS(XX)*TMP1-Z*SIN(XX)*TMP2))*SIGN(1.0,X)
      ENDIF
      RETURN
      END

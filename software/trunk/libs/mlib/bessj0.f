      REAL FUNCTION BESSJ0(X)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C Purpose: Calculates J0(X)
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
      REAL*8 Y,Z,AX,XX,DX,TMP1,TMP2
      INTEGER I
C
C Data:
C
      DATA PCOF/ 0.2093887211D-06,-0.2073370639D-05, 0.2734510407D-04,
     &          -0.1098628627D-02, 1.0D0/


      DATA QCOF/-0.9349451520D-07, 0.7621095161D-06,-0.6911147651D-05,
     &           0.1430488765D-03,-0.1562499995D-01/


      DATA RCOF/-0.1849052456D+03, 0.7739233017D+05,-0.1121442418D+08,
     &           0.6516196407D+09,-0.13362590354D+11,0.57568490574D+11/


      DATA SCOF/ 1.0D0           , 0.2678532712D+03, 0.5927264853D+05,
     &           0.9494680718D+07, 0.1029532985D+10, 0.57568490411D+11/
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
         BESSJ0 = SNGL(TMP1/TMP2)
      ELSE
         AX = ABS(DX)
         Z = 8.0D0/AX
         Y = Z*Z
         XX = AX - 0.785398164D0
         TMP1 = PCOF(0)
         TMP2 = QCOF(0)
         DO 20 I=1,4
            TMP1 = TMP1*Y + PCOF(I)
            TMP2 = TMP2*Y + QCOF(I)
 20      CONTINUE
         BESSJ0 = SNGL(SQRT(0.636619772D0/AX)
     &                 *(COS(XX)*TMP1-Z*SIN(XX)*TMP2))
      ENDIF
      RETURN
      END

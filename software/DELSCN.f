C     LAST UPDATE 17/01/97
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE DELSCN(VALS,NV)
      IMPLICIT NONE
C
C Purpose: Allows deletions to be made from scan list.  
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
      REAL VALS(10)
      INTEGER NV
C
C Local variables:
C
      INTEGER I,J,IDIF
C
C-----------------------------------------------------------------------
C
      IF(NV.EQ.0)RETURN
      IF(NV.EQ.1)VALS(2) = VALS(1)
      IDIF = NINT(VALS(2)-VALS(1)) + 1
      IF(IDIF.LT.1)RETURN
      DO 30 I=NINT(VALS(1)),NLIN
         IF(I+IDIF.GT.NLIN)THEN
            XCSCAN(I) = 0.0
            YCSCAN(I) = 0.0
            DO 10 J=1,2
               XSCAN(J,I) = 0.0 
               YSCAN(J,I) = 0.0
 10         CONTINUE
         ELSE
            XCSCAN(I) = XCSCAN(I+IDIF)
            YCSCAN(I) = YCSCAN(I+IDIF)
            DO 20 J=1,2
               XSCAN(J,I) = XSCAN(J,I+IDIF)
               YSCAN(J,I) = YSCAN(J,I+IDIF)
 20         CONTINUE
         ENDIF
 30   CONTINUE
      NSCAN = NSCAN - IDIF
      RETURN
C
      END

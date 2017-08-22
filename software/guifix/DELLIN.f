C     LAST UPDATE 10/12/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE DELLIN(VALS,NV)
      IMPLICIT NONE
C
C Purpose: Allows deletions to be made from line list.  
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
            LWIDTH(I) = 0
            DO 10 J=1,2
               XLINE(J,I) = 0.0 
               YLINE(J,I) = 0.0 
 10         CONTINUE
         ELSE
            LWIDTH(I) = LWIDTH(I+IDIF)
            DO 20 J=1,2
               XLINE(J,I) = XLINE(J,I+IDIF)
               YLINE(J,I) = YLINE(J,I+IDIF)
 20         CONTINUE
         ENDIF
 30   CONTINUE
      NLIN = NLIN - IDIF
      RETURN
C
      END

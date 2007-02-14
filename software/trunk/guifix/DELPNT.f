C     LAST UPDATE 10/12/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE DELPNT(VALS,NV)
      IMPLICIT NONE
C
C Purpose: Allows deletions to be made from coordinate list.  
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
      DO 30 I=NINT(VALS(1)),NPTS
         IF(I+IDIF.GT.NPTS)THEN
            NVALS(I) = 0
            AVPIX(I) = 0.0 
            DO 10 J=1,2
               FXY(J,I) = 0.0 
               SXY(J,I) = 0.0 
               RZ(J,I) = 0.0 
 10         CONTINUE
         ELSE
            NVALS(I) = NVALS(I+IDIF)
            AVPIX(I) = AVPIX(I+IDIF)
            DO 20 J=1,2
               FXY(J,I) = FXY(J,I+IDIF)
               SXY(J,I) = SXY(J,I+IDIF)
               RZ(J,I) = RZ(J,I+IDIF)
 20         CONTINUE
         ENDIF
 30   CONTINUE
      NPTS = NPTS - IDIF
      RETURN
C
      END

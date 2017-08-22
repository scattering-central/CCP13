C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE TRMODE
      IMPLICIT NONE
C
C Purpose: Set terminal into transparent mode (alpha) 
C          after using graphics.
C          n.b.  This routine does not clear any screens.
C
C Calls   0:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      CHARACTER*1 CAN
C
      DATA CAN/24/
C
C-----------------------------------------------------------------------
C
      call flush (6)
      PRINT 1000,CAN
      RETURN
C
1000  FORMAT (A1)
      END

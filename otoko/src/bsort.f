C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE BSORT (XDATA,YDATA,NCHAN)
      IMPLICIT NONE
C
C Purpose: Sorts the contents of two arrays. The order is detemined by
C          ascending order of the xdata, the other follows. The ordering
C          of the data for equivalent points is preserved.
C
      REAL          XDATA(1),YDATA(1)
      INTEGER       NCHAN        
C
C XDATA  : Abscissa data
C YDATA  : Ordinate data
C NCHAN  : Nos. of data points
C
C Calls   0:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    TEMP
      INTEGER I
      LOGICAL SWAP
C
C-----------------------------------------------------------------------
C
10    SWAP=.FALSE.
      DO 20 I=2,NCHAN
         IF (XDATA(I).LT.XDATA(I-1)) THEN
            SWAP=.TRUE.
            TEMP=XDATA(I)
            XDATA(I)=XDATA(I-1)
            XDATA(I-1)=TEMP
            TEMP=YDATA(I)
            YDATA(I)=YDATA(I-1)
            YDATA(I-1)=TEMP
         ENDIF
20    CONTINUE
      IF (SWAP) GOTO 10
      RETURN
      END  

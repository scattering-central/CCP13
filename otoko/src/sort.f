C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SORT (XDATA,YDATA,NCHAN,MODE)
      IMPLICIT NONE
C
C Purpose: Sorts the contents of two arrays. One determined by
C          mode, is placed in ascending order, the other follows
C
      REAL          XDATA(1),YDATA(1)
      INTEGER       NCHAN        
      CHARACTER*(*) MODE
C
C XDATA  : Abscissa data
C YDATA  : Ordinate data
C NCHAN  : Nos. of data points
C MODE   : X - Sort x ascending
C          Y - Sort y ascending
C
C Calls   0:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    DIFF,TEMP
      INTEGER LENGTH,MARK,I,J
C
C DIFF   : Difference between values
C TEMP   : Temporary value
C LENGTH : Nos. of values to consider
C MARK   : Swapped value flag
C
C-----------------------------------------------------------------------
C
C========SET LENGTH OF TRIAL
C
      LENGTH=(NCHAN+1)/2
      MARK=1
C
C========SKIP DONE-TEST IF SWAPPED
C
10    IF (MARK.EQ.0) THEN
         IF (LENGTH.LE.1) RETURN
         LENGTH=(LENGTH+1)/2
      ENDIF 
C
C========START SORTING
C
      I=1
      MARK=0
30    J=I+LENGTH
      IF (NCHAN.LT.J) GOTO 10
      IF (MODE(1:1).EQ.'Y') THEN
         DIFF=YDATA(J)-YDATA(I)
      ELSE
         DIFF=XDATA(J)-XDATA(I)
      ENDIF
      IF (DIFF.LT.0.0) THEN
         TEMP=XDATA(J)
         XDATA(J)=XDATA(I)
         XDATA(I)=TEMP
         TEMP=YDATA(J)
         YDATA(J)=YDATA(I)
         YDATA(I)=TEMP
C
C========MARK AS SWAPPED
C
         MARK=1
      ENDIF 
      I=I+1
      GOTO 30 
      END  

C     LAST UPDATE 29/09/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE WRTLOG(ILOG,WORD,NWORD,VALUES,NVALS,ITEM,MAXWRD,MAXVAL,
     &                  IRC)
      IMPLICIT NONE
C
C Purpose: Write a line of input from a terminal to a log file
C
      INTEGER MAXWRD,MAXVAL
      INTEGER ILOG,NWORD,NVALS,ITEM(MAXWRD+MAXVAL),IRC
      REAL    VALUES(MAXVAL)
      CHARACTER*(*)  WORD(MAXWRD)
C
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      LOGICAL LOGOPN
      INTEGER I,NV,NW
C
C-----------------------------------------------------------------------
      INQUIRE(ILOG,OPENED = LOGOPN)
      IF(.NOT.LOGOPN)THEN
         IRC = 1
         RETURN
      ENDIF
      NV = 0
      NW = 0
      DO 10 I=1,NWORD+NVALS
         IF(ITEM(I).EQ.1)THEN
            NV = NV + 1
            WRITE(ILOG,'(2X,G12.5,2X,$)',ERR=9999)VALUES(NV)
         ELSEIF(ITEM(I).EQ.2)THEN
            NW = NW + 1
            WRITE(ILOG,'(2X,A,2X,$)',ERR=9999)WORD(NW)
         ENDIF
 10   CONTINUE
      WRITE(ILOG,1000,ERR=9999)
      IRC = 0
      RETURN
 9999 IRC = 2
      RETURN
 1000 FORMAT(' ')
      END



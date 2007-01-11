C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE UPCASE (INBUF,OUTBUF)
      IMPLICIT NONE
C
C Purpose: Convert all occurrences of lower case characters to upper
C          case characters leaving all else alone.
C
      CHARACTER*(*) INBUF,OUTBUF
C
C INBUF  : Input buffer
C OUTBUF : Output buffer
C
C Calls   0: 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER       INDX,I
      CHARACTER*26  LOWER,UPPER
C
C INDX   : Postion of valid instruction in command string
C LOWER  : Lower case alphabet
C UPPER  : Upper case alphabet
C
      DATA LOWER/'abcdefghijklmnopqrstuvwxyz'/
      DATA UPPER/'ABCDEFGHIJKLMNOPQRSTUVWXYZ'/
C
C-----------------------------------------------------------------------
      DO 10 I=1,LEN(INBUF)
         INDX=INDEX (LOWER,INBUF(I:I))
         IF (INDX.EQ.0) THEN
            OUTBUF(I:I)=INBUF(I:I)
         ELSE
            OUTBUF(I:I)=UPPER(INDX:INDX)
         ENDIF
10    CONTINUE
      RETURN
      END


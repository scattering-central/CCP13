C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      INTEGER FUNCTION LENGTH (STRING)
      IMPLICIT NONE
C
C Purpose: Calculate the length of a character string without trailing
C          blanks.
C
      CHARACTER*(*) STRING
C
C STRING : Character string
C
C Calls   0:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      INTEGER I
C
C-----------------------------------------------------------------------
C
      DO 10 I=LEN(STRING),1,-1
         IF (STRING(I:I).NE.' ') THEN
            LENGTH=I
            RETURN
         ENDIF
10    CONTINUE
      LENGTH=0
      END

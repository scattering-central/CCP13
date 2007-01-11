C++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE ASK (QUES, REPLY, LOG)
C
C Purpose: To ask stupid questions and get the user's reply
C
      IMPLICIT NONE
      CHARACTER*(*) QUES
      LOGICAL       REPLY
      INTEGER       LOG
C
      INTEGER       IN_TERM, OUT_TERM
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local Variables:
C
      CHARACTER*1 CHAR
      INTEGER IRC,ITEM(2),NW,NV
      REAL V
C
C External function:
C
c      INTEGER IGETS
c      EXTERNAL IGETS
C
C Data:
C
      DATA  IN_TERM /5/, OUT_TERM /6/
C
C------------------------------------------------------------------------------
C
      CHAR = 'N'
      IF (REPLY) CHAR = 'Y'
C
      WRITE (OUT_TERM, 1000) QUES, CHAR
      CALL FLUSH (OUT_TERM)
      IF (LOG.NE.0) WRITE (LOG, 1000) QUES, CHAR
C
      CALL RDCOMF(5,CHAR,NW,V,NV,ITEM,1,1,1,IRC)
      IF(IRC.NE.0)GOTO 9999
C
      IF (CHAR.EQ.'Y' .OR. CHAR.EQ.'y') REPLY = .TRUE.
      IF (CHAR.EQ.'N' .OR. CHAR.EQ.'n') REPLY = .FALSE.
      IF (LOG.NE.0)THEN
         CHAR='N'
         IF(REPLY)CHAR='Y'
         WRITE (LOG, 2001) CHAR
      ENDIF
C
 9999 RETURN
 1000 FORMAT(1X,A,' [',A1,']: ',$)
 2000 FORMAT(A)
 2001 FORMAT(1X,A)
      END

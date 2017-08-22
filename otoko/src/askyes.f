C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      LOGICAL FUNCTION ASKYES (ITERM,IRC)
      IMPLICIT NONE
C
C Purpose: Read user response to a yes/no question and either assign
C          the default answer if <cr> is entered or interpret the reply
C          and return the relevant logical value. If <ctrl-Z> is
C          entered the return code is -1.( <ctrl-D> if unix ).
C
      INTEGER ITERM,IRC
C
C ITERM  : Terminal input stream
C IRC    : Return code 0 - successful
C                      1 - <ctrl-Z> for VMS /<ctrl-d> for unix
C
C Calls   1: ERRMSG
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER      JCHAR
      CHARACTER*80 TBUFF
      LOGICAL      IGETS
C
C JCHAR  : Nos. of chars entered
C TBUFF  : Terminal buffer
C
C-----------------------------------------------------------------------
C
      ASKYES=.TRUE.
      IRC=1
C
10    IF (IGETS (ITERM,TBUFF)) THEN
         JCHAR=INDEX(TBUFF,' ')-1
         IF (JCHAR.EQ.0) THEN
            IRC=0
         ELSEIF (TBUFF(1:1).EQ.'N'.OR.TBUFF(1:1).EQ.'n') THEN
            IRC=0
            ASKYES=.FALSE.
         ELSEIF (TBUFF(1:1).EQ.'Y'.OR.TBUFF(1:1).EQ.'y') THEN
            IRC=0
         ELSE
            CALL ERRMSG ('Error: Reply Y or N, Please re-enter')
            GOTO 10
         ENDIF
      ENDIF
      RETURN
      END

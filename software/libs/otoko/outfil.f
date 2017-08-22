C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE OUTFIL (ITERM,IPRINT,HFNAM,HEAD1,HEAD2,IRC)
      IMPLICIT NONE
C
C Purpose: Get header filename and header records from terminal.
C
      INTEGER ITERM,IPRINT,IRC
      CHARACTER*(*) HFNAM,HEAD1,HEAD2
C
C HFNAM  : Header filename
C HEAD1  : Header record 1
C HEAD2  : Header record 2
C ITERM  : Terminal input
C IPRINT : Terminal output
C IRC    : 0 - o.k.
c          1 - <ctrl-Z> for VMS/<ctrl-D> for unix
C
C Calls   1: ERRMSG
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER JCHAR,I
      LOGICAL IGETS
C
C JCHAR  : Nos. of chars entred at terminal
C
C-----------------------------------------------------------------------
      IRC=1
10    WRITE (IPRINT,1000)
      CALL FLUSH (IPRINT)
      IF (IGETS (ITERM,HFNAM)) THEN
         JCHAR=INDEX(HFNAM,' ')-1
         IF (JCHAR.NE.10) THEN
            CALL ERRMSG ('Error: Invalid header filename')
            GOTO 10
         ENDIF
         DO 20 I=4,6
            IF (HFNAM(I:I).NE.'0') THEN
               CALL ERRMSG ('Error: Invalid header filename')
               GOTO 10
            ENDIF
20       CONTINUE
         IF (HFNAM(7:7).NE.'.') THEN
            CALL ERRMSG ('Error: Invalid header filename')
            GOTO 10
         ENDIF
         WRITE (IPRINT,1010)
         CALL FLUSH (IPRINT)
         IF (IGETS (ITERM,HEAD1)) THEN
            WRITE (IPRINT,1020)
            CALL FLUSH (IPRINT)
            IF (IGETS (ITERM,HEAD2)) THEN
               IRC=0
            ENDIF
         ENDIF
      ENDIF
      RETURN
C
1000  FORMAT (' Enter output filename [Xnn000.xxx]: ',$)
1010  FORMAT (' Enter first header: ',$)
1020  FORMAT (' Enter second header: ',$)
      END

C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE INIPLO (ITERM,IPRINT,ICALL,IAXIS,IAUTO,IPLOT,IWINDO,
     &                   ISYMB,ICOL,XANOT,YANOT,TITLE,IRC)
      IMPLICIT NONE
C
C Purpose: Sets initial plotting parameters.
C
      INTEGER ITERM,IPRINT,IAXIS,IAUTO,IPLOT,IRC,IWINDO,ICALL,ISYMB
      INTEGER ICOL(1)
      CHARACTER*(*) XANOT,YANOT,TITLE
C
C XANOT  : X-axis annotation
C YANOT  : Y-axis annotation
C ICALL  : CALL NOS.
C IWINDO : Position of graph on terminal (1,2,3,4=quarter,0=full screen)
C TITLE  : Title of plot
C ITERM  : Terminal input stream
C IPRINT : Terminal output stream
C ISYMB  : GHOST SYMBOL
C ICOL   : Colour specification
C IAXIS  : Data plot type 1 - x      .v. y
C                         2 - x      .v. log(y)
C                         3 - log(x) .v. log(y)
C                         4 - x^2    .v. log(y)
C                         5 - x^2    .v. log(x.y)
C                         6 - x^2    .v. log(x^2.y)
C                         7 - x      .v. x^2.y
C IAUTO  : Auto scaling	0 - progam scales
C                       1 - user input scales
C IPLOT  : Plot type 1 - dot
C                    2 - line
C                    3 - diamond
C                    4 - histogram
C                    5 - Ghost symbol
C                    6 - Dashed line
C IRC    : Return code 0 - successful
C                      1 - <ctrl-Z> for VMS/<ctrl-D> for unix
C
C Calls   3: ASKYES , ERRMSG , GETVAL
C Called by: PLOT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10)
      INTEGER NVAL,I
      LOGICAL AUTO,ASKYES,IGETS
C
C VALUE : Terminal input
C BLANK : Space character string
C AUTO  : True if automatic scaling reqiured
C
C-----------------------------------------------------------------------
      IRC=1
      IF (ICALL.NE.0) GOTO 25
C
C========FIND PLOT TYPE
C
10    IPLOT=2
      WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 999
      IF (IRC.EQ.2) GOTO 10
      IF (NVAL.GE.1) IPLOT=INT(VALUE(1))
      IF (IPLOT.LT.1.OR.IPLOT.GT.6) THEN
         CALL ERRMSG ('Error: Invalid option selected')
         GOTO 10
      ENDIF
      IF (IPLOT.EQ.5) THEN
15       ISYMB=250
         WRITE (IPRINT,1005)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 999
         IF (IRC.EQ.2) GOTO 15
         IF (NVAL.GE.1) ISYMB=INT(VALUE(1))
         IF (ISYMB.LT.224.OR.IPLOT.GT.255) THEN
            CALL ERRMSG ('Error: Invalid symbol selected. See manual')
            GOTO 10
         ENDIF
      ENDIF
C
C========FIND AXIS TYPE
C   
20    IAXIS=1
      WRITE (IPRINT,1010)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 999
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.GE.1) IAXIS=INT(VALUE(1))
      IF (IAXIS.LT.1.OR.IAXIS.GT.7) THEN
         CALL ERRMSG ('Error: Invalid option selected')
         GOTO 20
      ENDIF
C
C========FIND AXIS TYPE
C   
 22   DO 23 I=1,8
         ICOL(I)=0
 23   CONTINUE
      WRITE (IPRINT,1012)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 999
      IF (IRC.EQ.2) GOTO 22
      DO 24 I=1,NVAL
         ICOL(I)=INT(VALUE(I))
         IF (ICOL(I).LT.0.OR.ICOL(I).GT.8) THEN
            CALL ERRMSG ('Error: Invalid colour selected')
            GOTO 22
         ENDIF
 24   CONTINUE
C
C========GET PLOT WINDOW (POSITION OF GRAPH ON TERMINAL)
C   
25    IWINDO=0
      WRITE (IPRINT,1015)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 999
      IF (IRC.EQ.2) GOTO 25
      IF (NVAL.GE.1) IWINDO=INT(VALUE(1))
      IF (IWINDO.LT.0.OR.IWINDO.GT.4) THEN
         CALL ERRMSG ('Error: Invalid window selected')
         GOTO 25
      ENDIF
C
C========ASK ABOUT ANNOTATION
C
      TITLE=' '
      WRITE (IPRINT,1020)
      IF (.NOT.IGETS (ITERM,TITLE)) GOTO 999
      IF (ICALL.NE.0) GOTO 999
      XANOT=' '
      WRITE (IPRINT,1030)
      IF (.NOT.IGETS (ITERM,XANOT)) GOTO 999
      YANOT=' '
      WRITE (IPRINT,1040)
      IF (.NOT.IGETS (ITERM,YANOT)) GOTO 999
C
C========ASK IF AUTOMATIC SCALING REQUIRED
C 
      WRITE (IPRINT,1050)
      AUTO=ASKYES (ITERM,IRC)
      IF (IRC.EQ.1) GOTO 999
      IF (AUTO) IAUTO=0
      IF (.NOT.AUTO) IAUTO=1
      IRC=0
999   RETURN
C
1000  FORMAT (' Enter type of plot:-',/,' (dots (1),full (2),diamond',
     &        ' (3),histog (4),GHOST symbol (5), Dashed (6)) [2]: ',$)
1005  FORMAT (' Enter Ghost symbol (224-255) [250]: ',$)
1010  FORMAT (' Enter option '/' 1:X,Y'/' 2:X,LOG(Y)'/,' 3:LOG(X),
     &         LOG(Y)'/' 4:X**2,LOG(Y)'/' 5:X**2,LOG(XY)'/
     &        ' 6:X**2,LOG(X**2.Y) 7:X,X^2.Y [1]: ',$)
1015  FORMAT (' Enter plot window [0,1,2,3,4] for display [0]: ',$)
1012  FORMAT (' Enter plot colours (background first)',
     &        ' [0,0,0,0,0,0,0,0]: ',$)
1020  FORMAT (' Enter plot title: ',$)
1030  FORMAT (' Enter X-axis annotation: ',$)
1040  FORMAT (' Enter Y-axis annotation: ',$)
1050  FORMAT (' Automatic scaling [Y/N] [Y]: ',$)
      END

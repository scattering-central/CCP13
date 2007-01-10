C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FRPLOT (ITERM,IPRINT,XDATA,YDATA,NCHAN,ICALL,IAXIS,
     &                   IAUT,IPLOT,IWINDO,ISYMB,ICOL,
     &                   XANOT,YANOT,TITLE)
      IMPLICIT NONE
C
C Purpose: Plots data in arrays xdata & ydata according to the various
C          parameters.
C
      REAL    XDATA(1),YDATA(1)
      INTEGER ITERM,IPRINT,NCHAN,ICALL,IAXIS,IAUT,IPLOT
      INTEGER IWINDO,ISYMB,ICOL(1)
      CHARACTER*(*) XANOT,YANOT,TITLE
C
C XDATA  : Abscissa data
C YDATA  : Ordinate data
C ITERM  : Terminal input stream
C IPRINT : Terminal output stream
C NCHAN  : Number of data points to be plotted
C ICALL  : Flag for first call to routine (should be 0 on first call)
C IAXIS  : Data plot type 
C IAUT   : Auto scaling
C IPLOT  : Plotting type
C IWINDO : Window for graph display
C ISYMB  : GHOST graphics symbol
C XANOT  : Annotation for x-axis
C YANOT  : Annotation for y-axis
C TITLE  : Title of plot
C
C Calls   5: ERRMSG , GETVAL , GRMODE , MINMAX , LENCHA
C Ghost  19: PAPER  , FILON  , PSPACE , ERASE  , MAP    , CTRMAG
C            AXES   , MAPXYL , AXEXYL , MAPYL  , POINT  , PICNOW
C            AXEYL  , POSITN , PCSCEN , JOIN   , CTRORI , BACCOL
C            LINCOL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10),XMIN,XMAX,YMIN,YMAX,XPOS(4),YPOS(4)
      INTEGER IRC,IMIN,IMAX,NVAL,LENGTH,I,LCOLOR
      SAVE    LCOLOR
C
C XMIN   : Abscissa minimum
C XMAX   : Abscissa maximum
C YMIN   : Ordinate minimum
C YMAX   : Ordinate maximum
C XORIG  : X origin
C YORIG  : Y origin
C XPOS   : Position of X min on terminal
C YPOS   : Position of Y min on terminal
C IMIN   : Dummy variable
C IMAX   : Dummy variable
C VALUE  : Numeric input values
C NVAL   : Nos. of input values
C IRC    : Return code
C
      DATA XPOS/0.15,0.75,0.15,0.75/ , YPOS/0.575,0.575,0.1,0.1/
C
C----------------------------------------------------------------------------- 
C
C========CORRECT DATA FOR PLOT TYPE
C
      IF (IAXIS.EQ.2) THEN
         DO 10 I=1,NCHAN
            IF (YDATA(I).LT.0.0001) YDATA(I)=0.0001
10       CONTINUE
      ELSEIF (IAXIS.EQ.3) THEN
         DO 20 I=1,NCHAN
            IF (XDATA(I).LT.0.0001) XDATA(I)=0.0001
            IF (YDATA(I).LT.0.0001) YDATA(I)=0.0001
20       CONTINUE
      ELSEIF (IAXIS.EQ.4) THEN
         DO 30 I=1,NCHAN
            XDATA(I)=XDATA(I)*XDATA(I)
            IF (YDATA(I).LT.0.0001) YDATA(I)=0.0001
30       CONTINUE 
      ELSEIF (IAXIS.EQ.5) THEN
         DO 40 I=1,NCHAN
            YDATA(I)=YDATA(I)*XDATA(I)
            IF (YDATA(I).LT.0.0001) YDATA(I)=0.0001
            XDATA(I)=XDATA(I)*XDATA(I)
40       CONTINUE
      ELSEIF (IAXIS.EQ.6) THEN
         DO 50 I=1,NCHAN
            XDATA(I)=XDATA(I)*XDATA(I)
            YDATA(I)=YDATA(I)*XDATA(I)
            IF (YDATA(I).LT.0.0001) YDATA(I)=0.0001
50       CONTINUE
      ELSEIF (IAXIS.EQ.7) THEN
         DO 55 I=1,NCHAN
            YDATA(I)=YDATA(I)*XDATA(I)*XDATA(I)
55       CONTINUE
      ENDIF
      IF (ICALL.EQ.0.OR.IWINDO.NE.0) THEN
         LCOLOR=2
      ELSE
         LCOLOR=LCOLOR+1
         IF (LCOLOR.GT.8) LCOLOR=2
      ENDIF
C
C========CALCULATE SCALING
C
      IF (ICALL.EQ.0.OR.IWINDO.NE.0) THEN
         CALL MINMAX (XDATA,NCHAN,1,NCHAN,IMIN,IMAX,XMIN,XMAX)
         CALL MINMAX (YDATA,NCHAN,1,NCHAN,IMIN,IMAX,YMIN,YMAX)
C
C========AUTOMATIC SCALING REQUIRED
C
         IF (IAUT.NE.0) THEN
            WRITE (IPRINT,1000) XMIN,XMAX,YMIN,YMAX
60          WRITE (IPRINT,1010)
            CALL GETVAL (ITERM,VALUE,NVAL,IRC)
            IF (IRC.EQ.2) THEN
               CALL ERRMSG ('Error: Numeric input required')
               GOTO 60
            ELSEIF (IRC.NE.1) THEN
               IF (NVAL.GT.3) YMAX=VALUE(4)
               IF (NVAL.GT.2) YMIN=VALUE(3)
               IF (NVAL.GT.1) XMAX=VALUE(2)
               IF (NVAL.GT.0) XMIN=VALUE(1)
            ENDIF
         ENDIF
C
C========INITIALISE PLOTTER
C
         CALL GRMODE
         CALL PLOTON
         CALL BACCOL (ICOL(1))
         IF (IWINDO.EQ.0) THEN
            CALL PSPACE (0.25,1.1,0.175,0.9)
            CALL CTRMAG (20)
         ELSE     
            CALL PSPACE (XPOS(IWINDO),XPOS(IWINDO)+0.45,
     &                   YPOS(IWINDO),YPOS(IWINDO)+0.375)
            CALL CTRMAG (10)
         ENDIF
         IF (ICALL.EQ.0.OR.IWINDO.EQ.0) CALL ERASE
C
C========PUT AXIS ANNOTATION & TITLE TO PLOT  
C 
         CALL MAP (0.0,1.0,0.0,1.0)
         CALL CTRORI (90.)
         CALL PCSCEN (-0.175,0.5,YANOT(1:LENGTH(YANOT)))
         CALL CTRORI (0.)
         CALL PCSCEN (0.5,-0.15,XANOT(1:LENGTH(XANOT)))
         CALL PCSCEN (0.5,1.05,TITLE(1:LENGTH(TITLE)))
C
C========SET WINDOWING & DRAW AXES
C 
         CALL AXORIG (XMIN,YMIN)
         IF (IAXIS.EQ.1.or.IAXIS.EQ.7) THEN
            CALL MAP (XMIN,XMAX,YMIN,YMAX)
            CALL AXESSI (0,0)
         ELSEIF (IAXIS.EQ.3) THEN
            CALL MAPXYL (XMIN,XMAX,YMIN,YMAX)
            CALL AXEXYL
         ELSE
            CALL MAPYL (XMIN,XMAX,YMIN,YMAX)
            CALL AXEYLI (0)
         ENDIF
         CALL POSITN (XMIN,YMAX)
         CALL JOIN (XMAX,YMAX)
         CALL JOIN (XMAX,YMIN)
         IF (YMIN.LT.0.0) THEN
            CALL POSITN (XMIN,0.0)
            CALL JOIN (XMAX,0.0)
         ENDIF
         IF (XMIN.LT.0.0) THEN
            CALL POSITN (0.0,YMIN)
            CALL JOIN (0.0,YMAX)
         ENDIF
      ENDIF
C
C========PLOT THE DATA
C
      CALL LINCOL(ICOL(LCOLOR))
      IF (IPLOT.EQ.6) CALL BROKEN (25,25,25,25)
      CALL POSITN (XDATA(1),YDATA(1))
      DO 200 I=1,NCHAN
         IF (IPLOT.EQ.1) THEN
            CALL POINT (XDATA(I),YDATA(I))
         ELSEIF (IPLOT.EQ.2) THEN
            CALL JOIN (XDATA(I),YDATA(I))
         ELSEIF (IPLOT.EQ.3) THEN
            CALL PLOTNC (XDATA(I),YDATA(I),228)
         ELSEIF (IPLOT.EQ.4) THEN
            CALL POSITN (XDATA(I),0.0)
            CALL JOIN (XDATA(I),YDATA(I))
         ELSEIF (IPLOT.EQ.5) THEN
            CALL PLOTNC (XDATA(I),YDATA(I),ISYMB)
         ELSEIF (IPLOT.EQ.6) THEN
            CALL JOIN (XDATA(I),YDATA(I))
         ENDIF
200   CONTINUE
      IF (IPLOT.EQ.6) CALL FULL
      CALL PICNOW
      ICALL=ICALL+1
      RETURN
C
1000  FORMAT (' Limits for plot:    XMIN        XMAX      ',
     1        ' YMIN        YMAX',/,'               ',4G13.5)
1010  FORMAT (' Enter new limits or <ctl-Z>: ',$)
      END

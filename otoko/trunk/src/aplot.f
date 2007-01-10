C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE APLOT (ITERM,IPRINT,YDATA,NCHAN)
      IMPLICIT NONE
C
C Purpose: Plot a single frame of data if requested.
C
      REAL    YDATA(1)
      INTEGER ITERM,IPRINT,NCHAN
C
C ITERM  : TERMINAL INPUT STREAM
C IPRINT : TERMINAL OUTPUT STREAM
C YDATA  : ORDINATE DATA
C NCHAN  : NOS. OF DATA POINTS
C
C Calls   3: ASKNO  , FRPLOT , TRMODE
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL        XDATA(5000)
      INTEGER     IWINDO,ICALL,IAXIS,IAUTO,IPLOT,IRC,ISYMB,I,ICOL(8)
      CHARACTER*6 TITLE,XANOT,YANOT
      LOGICAL     ASKNO,PLOT
C
C XDATA  : ABSCISSA DATA
C TITLE  : PLOT TITLE
C XANOT  : ABSCISSA ANNOTATION
C YANOT  : ORDINATE ANNOTATION
C IWINDO : WINDOW FOR GRAPH ON TERMINAL
C ICALL  : NOS. OF TIMES ROUTINE CALLED
C IAXIS  : PLOT TYPE
C IAUTO  : DATA SCALED BY PROGRAM
C IPLOT  : SYMBOL TYPE
C IRC    : RETURN CODE
C PLOT   : PLOT REQUIRED FLAG
C
      DATA IAXIS/1/ , IAUTO/0/ ,IPLOT/2/
      DATA XANOT/'X-AXIS'/ , YANOT/'Y-AXIS'/ 
      DATA TITLE/' '/ , IWINDO/0/ , ICOL/0,0,0,0,0,0,0,0/
C
C-----------------------------------------------------------------------
      WRITE (IPRINT,1000)
      PLOT=ASKNO (ITERM,IRC)
      IF (IRC.EQ.0) THEN
         IF (.NOT.PLOT) THEN
            ICALL=0
            DO 10 I=1,NCHAN
               XDATA(I)=REAL(I)
10          CONTINUE
            CALL FRPLOT (ITERM,IPRINT,XDATA,YDATA,NCHAN,ICALL,IAXIS,
     &                   IAUTO,IPLOT,IWINDO,ISYMB,ICOL,
     &                   XANOT,YANOT,TITLE)
cx            CALL GREND
            call trmode
         ENDIF
      ENDIF
      RETURN
C
1000  FORMAT (' Do you want to display plot [Y/N] [N]: ',$)
      END

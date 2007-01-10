C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE COPLOT
      IMPLICIT NONE
C
C Purpose: Produce a correlation plot for a series of frames 
C
      INCLUDE 'COMMON.FOR'
C
C Calls   8: FRPLOT , GETCHN , GETHDR , GETXAX , INIPLO , OPNFIL
C            SAVPLO , TRMODE
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER IRC,IFRAME,IHFMAX,IFRMAX,NCHAN,NFRAME,NCHANX,ICH1,ICH2
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NPTS,I,J,K
      INTEGER ICALL,IAXIS,IAUTO,IPLOT,IWINDO,ISYMB,ICOL(8)
      CHARACTER*80 XANOT,YANOT,TITLE
      CHARACTER*13 HFNAM
C
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
C KREC   : Output file record
C ISPEC  : First header file of sequence
C LSPEC  : Last header file in sequence
C MEM    : Positional or calibration data indicator
C IFFR   : First frame in sequence
C ILFR   : Last frame in sequence
C INCR   : Header file increment
C IFINC  : Frame increment
C HFNAM  : Header filename
C NCHAN  : Nos. of data points in spectrum
C NFRAME : Nos. of time frames
C NCHANX : Nos. of points in X-axis
C ICH1   : First channel to be plotted
C ICH2   : Last channel to be plotted
C NPTS   : Nos. of points to be plotted
C XANOT  : X-axis annotation
C YANOT  : Y-axis annotation
C TITLE  : Title of plot
C ICALL  : Nos. of plotting calls
C IAXIS  : Plot type
C IAUTO  : Automatic scaling
C IPLOT  : Plot symbol
C IWINDO : Window on terminal
C ISYMB  : GHOST symbol
C
C-----------------------------------------------------------------------
      ICALL=0
      WRITE (IPRINT,*) 'X-axis'
      CALL GETXAX (NCHANX,IRC)
      IF (IRC.NE.0) GOTO 999
C
10    KREC=0
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      IFRAME=IHFMAX+IFRMAX-1
      CALL GETCHN (ITERM,IPRINT,NCHAN,ICH1,ICH2,IRC)
      IF (IRC.NE.0) GOTO 10
      DO 40 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 30 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
C
               IF (ICALL.EQ.0.OR.IWINDO.NE.0) THEN
                  CALL INIPLO (ITERM,IPRINT,ICALL,IAXIS,IAUTO,IPLOT,
     &                        IWINDO,ISYMB,ICOL,XANOT,YANOT,TITLE,IRC)
                 IF (IRC.NE.0) GOTO 999
               ENDIF
C
               NPTS=ICH2-ICH1+1
               CALL FRPLOT (ITERM,IPRINT,XAX(ICH1),SP1(ICH1),NPTS,ICALL,
     &                 IAXIS,IAUTO,IPLOT,IWINDO,ISYMB,ICOL,XANOT,
     &                 YANOT,TITLE)
               CALL TRMODE
30          CONTINUE
            CLOSE(UNIT=JUNIT)
         ENDIF
40    CONTINUE
      GOTO 10
999   IF (ICALL.NE.0) CALL SAVPLO (ITERM,IPRINT)
      RETURN
      END

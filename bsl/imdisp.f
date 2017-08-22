C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE IMDISP (ITERM,IPRINT,BUFF,NPIX,NRAST)
      IMPLICIT   NONE
C
C Purpose: Check for image display.
C
      REAL    BUFF(1)
      INTEGER ITERM,IPRINT,NPIX,NRAST
C
C ITERM  : TERMINAL INPUT STREAM
C IPRINT : TERMINAL OUTPUT STREAM
C BUFF   : IMAGE DATA
C NPIX   : NOS. OF PIXELS
C NRAST  : NOS. OF RASTERS
C
C Calls   2: ASKNO  , PUTIMAGE
C Called by: 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      INTEGER IRC
      LOGICAL ASKNO,NOPLOT
C
C IRC    : RETURN CODE
C PLOT   : PLOT REQUIRED FLAG
C
C-----------------------------------------------------------------------
      WRITE (IPRINT,'(A,$)') ' Do you want to display image [Y/N] [N]: '
      NOPLOT=ASKNO (ITERM,IRC)
      IF (IRC.EQ.0) THEN
         IF (NOPLOT) THEN
            RETURN
         ELSE
            CALL PUTIMAGE (BUFF,NPIX,NRAST)
         ENDIF
      ENDIF
      END

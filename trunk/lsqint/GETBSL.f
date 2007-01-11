C     LAST UPDATE 24/06/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE GETBSL(NPIX,NRAST,BUF)
      IMPLICIT NONE
C
C Purpose: Get a single frame from a BSL file  
C
C Calls   4: GETHDR , OPNFIL , RFRAME , FCLOSE  
C            
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Arguments:
C
      INTEGER NPIX,NRAST
      REAL BUF(NPIX*NRAST)
C
C Local variables for BSL file input:
C
      INTEGER IRC,IFRAME,IHFMAX,IFRMAX,NFRAME
      INTEGER ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
      INTEGER ITERM,IPRINT,IUNIT,JUNIT
      CHARACTER*13 HFNAM
C
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
C ISPEC  : First header file of sequence
C LSPEC  : First header file of sequence
C MEM    : Positional or calibration data indicator
C IFFR   : First frame in sequence
C ILFR   : Last frame in sequence
C INCR   : Header file increment
C IFINC  : Frame increment
C HFNAM  : Header filename
C NPIX   : Nos. of pixels in image (stored in common)
C NRAST  : Nos. of rasters in image (stored in common)
C NFRAME : Nos. of frames in dataset
C KPIC   : Current image no.
C ITERM  : Unit number for reading from terminal
C IPRINT : Unit number for writing to terminal
C IUNIT  : Unit for reading header file
C JUNIT  : Unit for reading data file
C
C Data:
C
      DATA  ITERM/5/ , IPRINT/6/ , IUNIT /10/ , JUNIT /11/
C-----------------------------------------------------------------------
C
C========Prompt for input file details
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0)GOTO 9999
      IFRAME = IHFMAX + IFRMAX - 1
C
C========Loop over specified header files
C
      CALL OPNFIL(JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &             NFRAME,IRC)
      IF(IRC.EQ.0)THEN
C
C========Read frame
C
         CALL RFRAME(JUNIT,IFFR,NPIX,NRAST,BUF,IRC)
         IF(IRC.NE.0)WRITE(6,1000)
      ENDIF 
      CALL FCLOSE(JUNIT)
 9999 RETURN 
 1000 FORMAT(1X,'Error reading frame of binary data')
      END                  

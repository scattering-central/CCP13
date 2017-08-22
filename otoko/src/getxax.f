C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE GETXAX (NCHANX,IRC)
      IMPLICIT NONE
C
C Purpose: Read 1 frame of data from specified file and put in
C          X-axis data buffer.
C
      INTEGER NCHANX,IRC
C
C NCHANX : NOS. OF X CHANNELS
C IRC    : RETURN CODE
C
      INCLUDE 'COMMON.FOR'
C
C Calls   4: GETHDR , OPNFIL 
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER IHFMAX,IFRMAX,IMEM,NCHAN,NFRAME,K
      INTEGER ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
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
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C NFRAME : Nos. of time frames
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
C
10    CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
      IF (IRC.NE.0) GOTO 10
C
      READ (JUNIT,REC=IFFR) (XAX(K),K=1,NCHAN)
      CLOSE (UNIT=JUNIT)
      NCHANX=NCHAN
999   RETURN
C
      END

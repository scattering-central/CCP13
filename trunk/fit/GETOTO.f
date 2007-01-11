C     LAST UPDATE 11/07/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE GETOTO(BUF2,MAXCHN,MAXFRM,NCHAN,NFRAME,HEAD1,HEAD2,IRC)
      IMPLICIT NONE
C
C Purpose: Example program to demonstrate routines currently used by
C          OTOKO for opening, closing, reading and writing header and 
C          data files.
C Note:    Needs to be linked with the otoko.a library apprpriate to the
C          architecture of your machine (if available).
C
C Calls   3: GETHDR , GETCHN , OPNFIL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Include file:
C
      INCLUDE 'FIT.COM'
C
C Arguments:
C
      INTEGER MAXCHN,MAXFRM
      REAL BUF2(MAXCHN*MAXFRM)
      INTEGER NCHAN,NFRAME,IRC
C
C Local variables:
C
      REAL    BUF1(MAXDIM)
      INTEGER ICLO,JOP,IFRAME,IHFMAX,IFRMAX,NDUM
      INTEGER ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,I,J,K,M
      INTEGER ITERM,IPRINT,IUNIT,JUNIT
      CHARACTER*13 HFNAM
      CHARACTER*80 HEAD1,HEAD2
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
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
C OFNAM  : Output header filename 
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C NCHAN  : Nos. of data points in spectrum
C NDUM   : Set to 1 for 1-D implementation
C NFRAME : Nos. of time frames 
C ITERM  : Unit number for reading from terminal
C IPRINT : Unit number for writing to terminal
C IUNIT  : Unit for reading header file
C JUNIT  : Unit for reading data file
C BUF1   : Buffer for frame of input     
C BUF2   : Buffer for frame of output
C
      DATA  ITERM/5/ , IPRINT/6/ , IUNIT/10/ , JUNIT/11/
      DATA  NDUM/1/
C
C-----------------------------------------------------------------------
 10   ICLO=0
      JOP=0 
C
C========PROMPT FOR INPUT FILE DETAILS
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 9999
      IFRAME = IHFMAX + IFRMAX - 1
      OPEN(UNIT=20,FILE=HFNAM,STATUS='OLD')
      READ(20,'(A80)')HEAD1
      READ(20,'(A80)')HEAD2
      CLOSE(20)
C
C========LOOP OVER SPECIFIED HEADER FILES
C
      DO 40 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC = ISPEC + INCR
C
C========LOOP OVER SPECIFIED FRAMES
C
            DO 30 J=1,IFRMAX
C
C========NEW VERSION OF RFRAME - AVAILABLE NEXT RELEASE OF OTOKO LIBRARY
C
               READ(UNIT=JUNIT,REC=IFFR,ERR=9999)(BUF1(K),K=1,NCHAN)
               IFFR = IFFR + IFINC
C
C========EXAMPLE OPERATION     
C
               DO 20 K=1,NCHAN
                  M = (J-1)*NCHAN + K
                  BUF2(M) = BUF1(K)
 20            CONTINUE
C
C========END OF OPERATION
C
 30         CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
 40   CONTINUE
 50   CLOSE (UNIT=JUNIT)
 9999 RETURN  
C
      END                  

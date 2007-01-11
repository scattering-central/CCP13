C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,
     &                   IFFR,ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IMPLICIT NONE
C
C Purpose: Get header file information
C
      INTEGER ISPEC,LSPEC,INCR,MEM,IFFR,ILFR,IFINC,IHFMAX,IFRMAX,IRC
      INTEGER ITERM,IPRINT,IUNIT,NCHAN
      CHARACTER*(*) HFNAM
C
C ITERM  : Terminal input stream
C IPRINT : Terminal output stream
C IUNIT  : Header I/O stream
C HFNAM  : Header filename
C ISPEC  : Frame nos. part of filename
C LSPEC  : Last frame part of file name
C INCR   : Header file increment
C MEM    : Memory nos.
C IFFR   : First frame in sequence
C ILFR   : Last frame in sequence
C IFINC  : Frame increment
C IHFMAX : Nos. of header file in sequence
C IFRMAX : Nos. of frames/file
C NCHAN  : Nos. of  channels 
C IRC    : Return code 0 - successful
C                      1 - <ctrl-z>
C
C Calls   4: ERRMSG , FRDATA , GETFIL , RDHDR
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER      JRC,NFRAME,NDUM
      CHARACTER*13 FNAM
C
C JRC    : Return code
C NFRAME : Nos. of frames
C NDUM   : Dummy (used in 2d implementation)
C FNAM   : Binary dataset name
C
C-----------------------------------------------------------------------
      IRC=1
10    CALL GETFIL (ITERM,IPRINT,HFNAM,MEM,ISPEC,LSPEC,INCR,IFFR,ILFR,
     &             IFINC,JRC)
      IF (JRC.EQ.0) THEN
         CALL RDHDR (HFNAM,FNAM,ISPEC,MEM,IUNIT,NCHAN,NFRAME,NDUM,JRC)
         IF (JRC.EQ.1) THEN
            CALL ERRMSG ('Error: Missing values in header file')
            GOTO 10
         ELSEIF (JRC.EQ.2) THEN
            CALL ERRMSG ('Error: Header file not found')
            GOTO 10
         ELSE
            IF (IFFR.EQ.0) CALL FRDATA (ITERM,IPRINT,IFFR,ILFR,IFINC,
     &                                  NCHAN,NFRAME,MEM,JRC)
            IF (JRC.EQ.0) THEN
               IHFMAX=1
               IFRMAX=1
               IF (INCR.NE.0) IHFMAX=((LSPEC-ISPEC)/INCR)+1
               IF (IFINC.NE.0) IFRMAX=((ILFR-IFFR)/IFINC)+1
               IF (IHFMAX.GT.1.AND.IFRMAX.GT.1) THEN
                  CALL ERRMSG ('Error: Invalid operation')
                  GOTO 10
               ENDIF
               IF (IFFR.GT.NFRAME.OR.ILFR.GT.NFRAME) THEN
                  CALL ERRMSG ('Error: Invalid operation')
                  GOTO 10
               ENDIF
               IRC=0
            ENDIF
         ENDIF
      ENDIF
      RETURN
      END

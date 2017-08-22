C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,
     1                   IRC)
      IMPLICIT NONE
C
C Purpose: Open binary dataset.
C
      INTEGER       JUNIT,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC
      CHARACTER*(*) HFNAM
C
C HFNAM  : Header filename
C JUNIT  : Fortran I/O stream
C ISPEC  : Frame nos. part of file name
C MEM    : Memory nos.
C IFFR   : First frame of sequence
C ILFR   : Last frame of sequence
C NCHAN  : Nos. of channels
C NFRAME : Nos. of frames
C IRC    : Return code 0 - successful
C                      1 - file error
C
      EXTERNAL ACCESS
C
C Calls   2: ERRMSG , RDHDR
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER      NDUM,IOS,JRC
      CHARACTER*13 FNAM
C
C NDUM   : Dummy (used in 2d implementation)
C IOS    : File open status
C JRC    : Return code
C FNAM   : Binary dataset name
C
C-----------------------------------------------------------------------
      IRC=0
      CALL RDHDR (HFNAM,FNAM,ISPEC,MEM,JUNIT,NCHAN,NFRAME,NDUM,JRC)
      IF (JRC.NE.0) THEN
         CALL ERRMSG ('Error: Header file not found')
         IRC=1
      ELSE
         IF (IFFR.GT.NFRAME.OR.ILFR.GT.NFRAME) THEN
            CALL ERRMSG ('Error: Missing file or frame')
            IRC=1
         ELSE
#if defined titan || iris || DEC5000
            OPEN (UNIT=JUNIT,FILE=FNAM,STATUS='OLD',ACCESS='DIRECT',
     &            IOSTAT=IOS,SHARED,RECL=NCHAN)
#else
            OPEN (UNIT=JUNIT,FILE=FNAM,STATUS='OLD',ACCESS='DIRECT',
     &            IOSTAT=IOS,RECL=NCHAN*4)
#endif
            IF (IOS.NE.0) THEN
               CALL ERRMSG ('Error: File not found')
               IRC=1
            ENDIF
         ENDIF
      ENDIF
      RETURN
      END

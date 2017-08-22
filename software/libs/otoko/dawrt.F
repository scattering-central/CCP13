C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE DAWRT (KUNIT,FNAM,MEM,NCHAN,NFRAME,HEAD1,HEAD2,SPEC,
     &                  KREC,IOP,ICLO,IRC)
      IMPLICIT NONE
C
C Purpose: Writes a frame to a direct access binary file. On the
C          first call IOP should be set to 0 to initialise the file.
C          On the final call ICLO should be set to 1 to close the file.
C
      REAL    SPEC(1)
      INTEGER KUNIT,MEM,NCHAN,NFRAME,IOP,ICLO,KREC,IRC
      CHARACTER*(*) FNAM,HEAD1,HEAD2
C
C KUNIT  : Output stream
C FNAM   : File name of dataset
C MEM    : Memory (digits 4-6 in file name)
C NCHAN  : Nos. of channels in frame
C NFRAME : Total nos of frames to be written
C HEAD1  : Header record 1
C HEAD2  : Header record 2
C IOP    : Open flag 0 - file is to be opened (set to 1 on exit)
C                    1 - File is already open
C ICLO   : Close flag 0 - file is not to be closed
C                     1 - Write last record and close file
C                     2 - Close file without writing record
C KREC   : Record nos. to be written
C IRC    : Return code 0 - successful
C                      1 - File open failure
C SPEC   : Frame data
C
C Calls   2: ERRMSG , HDRGEN
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER IFLAG,IOS,NDUM,I
      LOGICAL EXISTS
C
C IFLAG  : First call to open
C IOS    : Status of open
C NDUM   : Used for 2d implementation
C
      DATA NDUM/1/
C
C-----------------------------------------------------------------------
      CALL UPCASE (FNAM,FNAM)
C
      IF (IOP.EQ.0) THEN
         CALL HDRGEN (NCHAN,NFRAME,NDUM,FNAM,MEM,KUNIT,HEAD1,HEAD2,IRC)
         IF (IRC.NE.0) GOTO 999
         IFLAG=0
C
         INQUIRE (FILE=FNAM,EXIST=EXISTS)
         IF (EXISTS) THEN
            OPEN (UNIT=KUNIT,FILE=FNAM,STATUS='OLD',IOSTAT=IOS)
            IF (IOS.EQ.0) THEN
               CLOSE (UNIT=KUNIT,STATUS='DELETE')
            ELSE
               CALL ERRMSG ('Error: Failed to delete existing file')
               IRC=2
               RETURN
            ENDIF
         ENDIF
#if defined titan || iris || DEC5000
         OPEN (UNIT=KUNIT,FILE=FNAM,STATUS='NEW',ACCESS='DIRECT',
     &         RECL=NCHAN,IOSTAT=IOS)
#else
         OPEN (UNIT=KUNIT,FILE=FNAM,STATUS='NEW',ACCESS='DIRECT',
     &         RECL=NCHAN*4,IOSTAT=IOS)
#endif
         IF (IOS.NE.0) THEN  
            CALL ERRMSG ('Error: Failed to create binary file')
            IRC=2
            RETURN
         ENDIF
         IOP=1
      ENDIF
C
      IF (ICLO.EQ.0) THEN
         WRITE (KUNIT,REC=KREC) (SPEC(I),I=1,NCHAN)
      ELSEIF (ICLO.EQ.1) THEN
         WRITE (KUNIT,REC=KREC) (SPEC(I),I=1,NCHAN)
         CLOSE (UNIT=KUNIT,STATUS='KEEP')
      ELSE
         CLOSE (UNIT=KUNIT,STATUS='KEEP')
      ENDIF
999   RETURN
      END

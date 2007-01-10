C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE HDRGEN (NPIX,NRAST,NFRAME,FNAM,MEM,IUNIT,HDR1,HDR2,IRC)
      IMPLICIT NONE
C
C Purpose: Generates a header file.
C
      INTEGER NPIX,NRAST,NFRAME,MEM,IUNIT,IRC
      CHARACTER *(*) FNAM,HDR1,HDR2
C
C NPIX   : Nos. of pixels
C NRAST  : Nos. of rasters
C NFRAME : Nos. of frames
C FNAM   : Header filename
C MEM    : Digits 4-6 of dataset filename
C HDR1   : Header record 1
C HDR2   : Header record 2
C IUNIT	 : Fortran i/o unit
C IRC    : 0 - Successful
C          1 - File error
C
C Calls   1: ERRMSG
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER INDIC(10),IOS,I
      LOGICAL EXISTS
C
C INDIC  : Header file indices
C IFLAG  : First call
C
C-----------------------------------------------------------------------
      CALL UPCASE (FNAM,FNAM)
C
C========ASSIGN INDICES
C
      INDIC(1)=NPIX
      INDIC(2)=NRAST
      INDIC(3)=NFRAME
      DO 10 I=4,10
            INDIC(I)=0
10    CONTINUE
C
C========OPEN & WRITE FILE
C
      INQUIRE (FILE=FNAM,EXIST=EXISTS)
      IF (EXISTS) THEN
         OPEN (UNIT=IUNIT,FILE=FNAM,STATUS='OLD',IOSTAT=IOS)
         IF (IOS.EQ.0) THEN
            CLOSE (UNIT=IUNIT,STATUS='DELETE')
         ELSE
            CALL ERRMSG ('Error: Failed to delete existing file')
            IRC=1
            RETURN
         ENDIF
      ENDIF
      OPEN (UNIT=IUNIT,FILE=FNAM,STATUS='NEW',IOSTAT=IOS)
      IF (IOS.NE.0) THEN  
         CALL ERRMSG ('Error: Failed to create header file')
         IRC=1
      ELSE
         WRITE (IUNIT,'(A)') HDR1
         WRITE (IUNIT,'(A)') HDR2
         WRITE (IUNIT,'(10I8)') (INDIC(I),I=1,10)
         WRITE (FNAM(4:4),'(I1)') MEM/100
         WRITE (FNAM(5:5),'(I1)') MOD(MEM,100)/10
         WRITE (FNAM(6:6),'(I1)') MOD(MEM,10)
         WRITE (IUNIT,'(A)') FNAM
         CLOSE (UNIT=IUNIT,STATUS='KEEP')
         IRC=0
      ENDIF
      RETURN
C
      END

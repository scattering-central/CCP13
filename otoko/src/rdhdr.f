C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE RDHDR(FNAM,AFNAM,ISPEC,MEM,IUNIT,NPIX,NRAST,NFRAME,IRC)
      IMPLICIT NONE
C
C Purpose: Read the header file for the associated binary file,
C          corresponding to the memory nos.
C
      INTEGER ISPEC,MEM,IRC,IUNIT,NPIX,NRAST,NFRAME
      CHARACTER*(*) FNAM,AFNAM
C
C FNAM   : Header filename
C AFNAM  : Direct access filename
C ISPEC  : Numerical part of the filename.
C          If ispec<0 then fnam is not changed.
C MEM    : On entry contains memory number
C IRC    : =0 if no errors detected
C          =1 incomplete header file
C          =2 if header file does not exist
C IUNIT  : Lun of header file
C NPIX   : Nos. of pixels
C NFRAME : Nos. of frames
C NRAST  : Nos. of rasters
C
C Calls   0: 
C Called by: GETHDR , OPNFIL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER INDIC(10),IOS,I,J
      CHARACTER*80 HEAD1,HEAD2
C
C IOS    : Status of file opening
C INDIC  : Array containing indicators
C HEAD1  : First header
C HEAD2  : Second header
C
C-----------------------------------------------------------------------
      IRC=1
      IF (ISPEC.GT.0) THEN
         WRITE (FNAM(2:2),'(I1)') ISPEC/10000
         WRITE (FNAM(3:3),'(I1)') MOD(ISPEC,10000)/1000
      ENDIF
      OPEN (UNIT=IUNIT,FILE=FNAM,STATUS='OLD',IOSTAT=IOS)
      IF (IOS.EQ.0) THEN
         READ (IUNIT,'(A)',END=20) HEAD1
         READ (IUNIT,'(A)',END=20) HEAD2
         DO 10 J=1,MEM
            READ (IUNIT,'(10I8)',END=20) (INDIC(I),I=1,10)
            READ (IUNIT,'(A)',END=20) AFNAM
10       CONTINUE
         IRC=0
20       CLOSE (UNIT=IUNIT)
         NPIX=INDIC(1)
         NRAST=INDIC(2)
         NFRAME=INDIC(3)
      ELSE
         IRC=2
      ENDIF
      RETURN
      END

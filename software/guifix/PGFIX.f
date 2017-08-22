C     LAST UPDATE 09/04/99
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      PROGRAM PGFIX 
      IMPLICIT NONE
C
C Purpose: Fibre diffraction analysis program with X-Windows graphics.
C          Useful for finding centre, rotation, tilt. 
C
C Calls  20: GETHDR , OPNFIL , RFRAME , OUTFIL , OPNNEW , WFRAME ,
C            FCLOSE , IMAGE  , REDUCE , RDCOMF , LIST   , FLIST  ,
C            ASK    , CENTRE , ROTATE , FTOSTD , CTILT  , STOREC ,
C            INTEG  , REPLACE
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file:
C
      INCLUDE 'FIXPAR.COM'
C
C Local variables for BSL file input:
C
      INTEGER IRC,IFRAME,IHFMAX,IFRMAX,NFRAME,IBUF
      INTEGER ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
      INTEGER I,J
      INTEGER ITERM,IPRINT,IUNIT,JUNIT,KUNIT
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
C ITERM  : Unit number for reading from terminal
C IPRINT : Unit number for writing to terminal
C IUNIT  : Unit for reading header file
C JUNIT  : Unit for reading data file
C IBUF   : Buffer pointer for frame of input     
C
C Arrays for image.c interface:
C
      INTEGER IXPTS(MAXVAL),IYPTS(MAXVAL),NPOINTS(MAXPTS),IWIDTH(MAXPTS)
      INTEGER INIT
C
C RDCOMF declarations:
C
      INTEGER ITEM(20)
      INTEGER NW,NV
      REAL VALS(10)
      CHARACTER*10 WORD(10)
C
C ASK declarations:
C
      LOGICAL REPLY
C
C LINES declarations:
C
      LOGICAL GSTOPN
C
C REPEAT declarations:
C
      INTEGER NRP
      LOGICAL REPEAT
C
C Degree to radians conversion
C
      REAL DTOR
      PARAMETER(DTOR=0.017453293)
C
C Initialize logicals:
C
      DATA GOTWAV /.FALSE./, GOTSDD /.FALSE./, GOTCEN /.FALSE./,
     &     GOTROT /.FALSE./, GOTTIL /.FALSE./, REPEAT /.FALSE./
      DATA  ITERM/5/ , IPRINT/6/ , IUNIT/10/ , JUNIT/11/ , KUNIT/12/
C
C-----------------------------------------------------------------------
C
      WRITE(6,1000)
C
C========Open FIX.OUT file
C
      OPEN(UNIT=KUNIT,STATUS='UNKNOWN',FILE='FIX.OUT')
      GSTOPN = .FALSE.
C
C========Prompt for input file details
C
 10   CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0)THEN
         IF(REPEAT.AND.IRC.EQ.1)THEN
            REPEAT = .FALSE.
            CALL FLIST(KUNIT)
            GOTO 10
         ENDIF
         GOTO 9999
      ENDIF
      IFRAME = IHFMAX + IFRMAX - 1
      WRITE(KUNIT,1020)HFNAM
      WRITE(KUNIT,1030)IFFR,ILFR,IFINC 
C
C========Loop over specified header files
C
      DO 50 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
C
C========Loop over specified frames
C
            DO 40 J=1,IFRMAX
C
C========Read frames sequentially
C
               WRITE(KUNIT,1040)IFFR 
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,IBUF,IRC)
               IF (IRC.NE.0) GOTO 60
               IFFR=IFFR+IFINC
C
C========First call to image and initializations
C
               IF(REPEAT)THEN
                  CALL REPLACE(NPOINTS,IXPTS,IYPTS,NRP)
               ELSE 
                  NPTS = 0
                  NLIN = 0
                  INIT = 1
                  CALL IMAGE(IBUF,NPIX,NRAST,NPOINTS,IXPTS,IYPTS,
     &                       IWIDTH,INIT)
               ENDIF
               CALL REDUCE(%val(IBUF),NPOINTS,IXPTS,IYPTS,IWIDTH)
               CALL LIST
               IF(REPEAT)GOTO 40
C
C========Now get keyworded input
C              
 35             WRITE(6,1010)
                CALL RDCOMF(ITERM,WORD,NW,VALS,NV,ITEM,10,10,10,IRC)
                IF(IRC.NE.0)GOTO 9999
                IF(NV.GT.0.AND.NW.EQ.0)THEN
                   WRITE(6,2020)
                   GOTO 35
                ENDIF
                IF(NW.EQ.0)GOTO 35
                CALL UPPER(WORD(1),10)
                IF(WORD(1)(1:4).EQ.'IMAG')THEN
                   CALL IMAGE(IBUF,NPIX,NRAST,NPOINTS,IXPTS,IYPTS,
     &                        IWIDTH,INIT)
                   CALL REDUCE(%val(IBUF),NPOINTS,IXPTS,IYPTS,IWIDTH)
                ELSEIF(WORD(1)(1:4).EQ.'WAVE')THEN
                   IF(NV.EQ.0)THEN
                      WRITE(6,2000)
                   ELSE
                      WAVE = VALS(1)
                      GOTWAV = .TRUE.
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'DIST')THEN
                   IF(NV.EQ.0)THEN
                      WRITE(6,2000)
                   ELSE
                      SDD = VALS(1)
                      GOTSDD = .TRUE.
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'CENT')THEN 
                   IF(NV.LT.2)THEN
                      IF(NPTS.LT.3)THEN
                         CALL IMAGE(IBUF,NPIX,NRAST,NPOINTS,IXPTS,
     &                              IYPTS,IWIDTH,INIT)
                         CALL REDUCE(%val(IBUF),NPOINTS,IXPTS,IYPTS,
     &                               IWIDTH)
                      ELSE
                         CALL LIST
                         CALL FLIST(KUNIT)
                         IF(NPTS.GT.2)THEN
                            REPLY = .FALSE.
                            CALL ASK('Collect more points',REPLY,0) 
                         ELSE
                            REPLY = .TRUE.
                         ENDIF
                         IF(REPLY)THEN
                            CALL IMAGE(IBUF,NPIX,NRAST,NPOINTS,
     &                                 IXPTS,IYPTS,IWIDTH,INIT)
                            CALL REDUCE(%val(IBUF),NPOINTS,IXPTS,IYPTS,
     &                                  IWIDTH)
                         ENDIF
                      ENDIF
                      IF(NPTS.GT.2)CALL CENTRE
                   ELSE
                      XC = VALS(1)
                      YC = VALS(2)
                      GOTCEN = .TRUE.
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'ROTA')THEN
                   IF(NV.EQ.0)THEN
                      IF(NPTS.LT.2)THEN
                         CALL IMAGE(IBUF,NPIX,NRAST,NPOINTS,IXPTS,
     &                              IYPTS,IWIDTH,INIT)
                         CALL REDUCE(%val(IBUF),NPOINTS,IXPTS,IYPTS,
     &                               IWIDTH)
                      ELSE
                         CALL LIST
                         CALL FLIST(KUNIT)
                         IF(NPTS.GT.1)THEN
                            REPLY = .FALSE.
                            CALL ASK('Collect more points',REPLY,0) 
                         ELSE
                            REPLY = .TRUE.
                         ENDIF
                         IF(REPLY)THEN
                            CALL IMAGE(IBUF,NPIX,NRAST,NPOINTS,
     &                                 IXPTS,IYPTS,IWIDTH,INIT)
                            CALL REDUCE(%val(IBUF),NPOINTS,IXPTS,IYPTS,
     &                                  IWIDTH)
                         ENDIF
                      ENDIF
                      IF(NPTS.GT.1)CALL ROTATE 
                   ELSE
                      ROTX = DTOR*VALS(1)
                      IF(NV.GE.2)THEN
                         ROTY = DTOR*VALS(2)
                      ELSE
                         ROTY = 0.0
                      ENDIF
                      IF(NV.GE.3)THEN
                         ROTZ = DTOR*VALS(3)
                      ELSE
                         ROTZ = 0.0
                      ENDIF
                      GOTROT = .TRUE.
                      IF(GOTCEN)CALL FTOSTD
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'TILT')THEN
                   IF(NV.EQ.0)THEN
                      IF(NPTS.LT.2)THEN
                         CALL IMAGE(IBUF,NPIX,NRAST,NPOINTS,IXPTS,
     &                              IYPTS,IWIDTH,INIT)
                         CALL REDUCE(%val(IBUF),NPOINTS,IXPTS,IYPTS,
     &                               IWIDTH)
                      ELSE
                         CALL LIST
                         CALL FLIST(KUNIT)
                         IF(NPTS.GT.1)THEN
                            REPLY = .FALSE.
                            CALL ASK('Collect more points',REPLY,0) 
                         ELSE
                            REPLY = .TRUE.
                         ENDIF
                         IF(REPLY)THEN
                            CALL IMAGE(IBUF,NPIX,NRAST,NPOINTS,
     &                                 IXPTS,IYPTS,IWIDTH,INIT)
                            CALL REDUCE(%val(IBUF),NPOINTS,IXPTS,IYPTS,
     &                                  IWIDTH)
                         ENDIF
                      ENDIF
                      IF(NPTS.GT.1)CALL CTILT 
                   ELSE
                      TILT = -DTOR*VALS(1)
                      GOTTIL = .TRUE.
                      IF(GOTCEN.AND.GOTROT.AND.
     &                   GOTWAV.AND.GOTSDD)CALL STOREC
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'REFI')THEN
                   CALL IMAGE(IBUF,NPIX,NRAST,NPOINTS,IXPTS,IYPTS,
     &                        IWIDTH,INIT)
                   CALL REFALL(%val(IBUF),IXPTS,IYPTS)
                ELSEIF(WORD(1)(1:4).EQ.'LIST')THEN
                   CALL LIST
                   CALL FLIST(KUNIT)
                ELSEIF(WORD(1)(1:4).EQ.'INTE')THEN
                   CALL INTEG
                ELSEIF(WORD(1)(1:4).EQ.'LINE')THEN
                   CALL LINES (%val(IBUF),GSTOPN)
                ELSEIF(WORD(1)(1:4).EQ.'REPE')THEN
                   REPEAT = .TRUE.
                   GOTO 40
                ELSEIF(WORD(1)(1:4).EQ.'FRAM')THEN
                   GOTO 40
                ELSEIF(WORD(1)(1:4).EQ.'FILE')THEN
                   GOTO 60
                ELSEIF(WORD(1)(1:1).EQ.'Q')THEN
                   GOTO 9999
                ELSE
                   WRITE(6,2010)
                ENDIF
                GOTO 35
 40         CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
 50   CONTINUE
 60   CALL FCLOSE (JUNIT)
      GOTO 10
 9999 CLOSE(KUNIT)
      CALL CFREE
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      IF(GSTOPN)CALL GREND
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IF(GSTOPN)CALL PGEND
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      STOP 'Normal stop' 
C
C-----------------------------------------------------------------------
 1000 FORMAT(/1X,'FIX - Fibre diffraction analysis program'/
     &        1X,'Last update 09/04/99'/)
 1010 FORMAT(1X,'Fix> ',$)
 1020 FORMAT(1X,'Header filename: ',A30)
 1030 FORMAT(1X,'First frame ',I4,'  Last frame ',I4,'  Incr. ',I4)
 1040 FORMAT(1X,'Reading frame ',I4)
 2000 FORMAT(1X,'***Numeric input expected')
 2010 FORMAT(1X,'***Unrecognized keyword')
 2020 FORMAT(1X,'***Keyword expected')
C-----------------------------------------------------------------------
      END                  

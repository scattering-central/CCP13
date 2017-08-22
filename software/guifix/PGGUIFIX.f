C     LAST UPDATE 09/04/99
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      PROGRAM GUIFIX
      IMPLICIT NONE
C
C Purpose: Fibre diffraction analysis program with OSF/MOTIF GUI,
C          X-Windows graphics and PGPLOT line graphs. 
C          This is the underlying Fortran code for processing data
C          selected using the GUI.
C          Useful for finding centre, rotation, tilt. 
C
C Calls  18: GETHDR , OPNFIL , RFRAME , OUTFIL , OPNNEW , WFRAME ,
C            FCLOSE , REDUCE , RDCOMF , LIST   , CENTRE , REFALL ,
C            ROTATE , FTOSTD , CTILT  , STOREC , DELPNT , FIBGEN ,
C                   
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file:
C
      INCLUDE 'FIXPAR.COM'
C
C Local variables for BSL file input:
C
C 
C+++++++++These need to be INTEGER*8 on 64 bit machines +++++++++++++++
      INTEGER*4 IBUF
      INTEGER*4 NBUF1,NBUF2,NBUF3,NBUF4
      INTEGER*4 IBUF1,IBUF2,IBUF3,IBUF4,IBUF5,IBUF6,IBUF7,IBUF8,IBUF9
      INTEGER*4 IBUF10
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      INTEGER IRC,IFRAME,IHFMAX,IFRMAX,NFRAME,IFLAG
      INTEGER ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
      INTEGER I,J,IJ
      INTEGER IUNIT,JUNIT
      CHARACTER*80 HFNAM
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
C Process ID, log file name and buffer for time
C
      INTEGER IPROC
      CHARACTER*30 LOGFIL,TSTART
C
C Arrays for image interface:
C
      INTEGER NPOINTS
      REAL WIDTH
      REAL XPTS(MAXVERT),YPTS(MAXVERT)
      INTEGER*4 DUMBUF
C
C RDCOMF declarations:
C
      INTEGER ITEM(30)
      INTEGER NW,NV,N
      REAL VALS(20)
      CHARACTER*10 WORD(10)
C
C LINES declarations:
C
      LOGICAL GSTOPN
C
C External Functions:
C
      INTEGER GETMEM
      EXTERNAL GETMEM
C
C Degree to radians conversion
C
      REAL DTOR
      PARAMETER(DTOR=0.017453293)

C
C Initialize file io streams:
C
      DATA IUNIT /11/ , JUNIT /12/ 
C
C-----------------------------------------------------------------------
C

C========Open FIX log file
C
      CALL PROCID(IPROC)
      WRITE(LOGFIL,1001)IPROC
      OPEN(UNIT=ILOG,STATUS='UNKNOWN',FILE=LOGFIL)
      CALL STRTIM(TSTART,30)
      WRITE(ILOG,1002)TSTART,IPROC
      GSTOPN = .FALSE.
C
C========Say hello
C
      WRITE(IPRINT,1000)
      CALL FLUSH(6)
      WRITE(ILOG,1000)
C
C========Now get pre-file keyworded input
C              
 5    WRITE(IPRINT,1010)
      CALL FLUSH(6)
      CALL RDCOMF(ITERM,WORD,NW,VALS,NV,ITEM,10,20,10,IRC)
      IF(IRC.NE.0)GOTO 9999
      IF(NV.GT.0.AND.NW.EQ.0)THEN
         WRITE(IPRINT,2020)
         CALL FLUSH(6)
         GOTO 5
      ENDIF
      IF(NW.EQ.0)GOTO 5
      IF(WORD(1)(1:2).EQ.'^D')GOTO 9999
      CALL UPPER(WORD(1),10)
      IF(WORD(1)(1:4).EQ.'WAVE')THEN
         IF(NV.EQ.0)THEN
            WRITE(IPRINT,2000)
            CALL FLUSH(6)
         ELSE
            WAVE = VALS(1)
            GOTWAV = .TRUE.
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'DIST')THEN
         IF(NV.EQ.0)THEN
            WRITE(IPRINT,2000)
            CALL FLUSH(6)
         ELSE
            SDD = VALS(1)
            GOTSDD = .TRUE.
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'CENT')THEN 
         IF(NV.EQ.2)THEN
            XC = VALS(1)
            YC = VALS(2)
            GOTCEN = .TRUE.
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'ROTA')THEN
         IF(NV.GE.1)THEN
            ROTX = DTOR*VALS(1)
         ELSE
            ROTX = 0.0
         ENDIF
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
      ELSEIF(WORD(1)(1:4).EQ.'TILT')THEN
         IF(NV.EQ.1)THEN
            TILT = -DTOR*VALS(1)
            GOTTIL = .TRUE.
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'CALI')THEN
         IF(NV.EQ.1)THEN
            DCAL = VALS(1)
            GOTCAL = .TRUE.
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'RADI')THEN
         RADIAL = .TRUE.
      ELSEIF(WORD(1)(1:4).EQ.'AZIM')THEN
         RADIAL = .FALSE.
      ELSEIF(WORD(1)(1:4).EQ.'SPOT')THEN
         LATPNT = .TRUE.
      ELSEIF(WORD(1)(1:4).EQ.'RING')THEN
         LATPNT = .FALSE.
      ELSEIF(WORD(1)(1:4).EQ.'CELL')THEN
         CELL(1) = VALS(1)
         CELL(2) = VALS(2)
         CELL(3) = VALS(3)
         CELL(4) = VALS(4)
         CELL(5) = VALS(5)
         CELL(6) = VALS(6)
      ELSEIF(WORD(1)(1:4).EQ.'MISS')THEN
         PHIX = VALS(1)*DTOR
         PHIZ = VALS(2)*DTOR
      ELSEIF(WORD(1)(1:4).EQ.'SPAC')THEN
         SPCGRP = WORD(2)
      ELSEIF(WORD(1)(1:4).EQ.'FILE')THEN
         GOTO 10
      ELSEIF(WORD(1)(1:4).EQ.'QUIT')THEN
         GOTO 9999
      ELSE
         WRITE(IPRINT,2010)
         CALL FLUSH(6)
      ENDIF
      GOTO 5
C
C========Prompt for input file details
C
 10   WRITE(IPRINT,1005)
      CALL FLUSH(6)
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0)GOTO 9999
      IFRAME = IHFMAX + IFRMAX - 1
      WRITE(ILOG,1020)HFNAM
      WRITE(ILOG,1030)IFFR,ILFR,IFINC 
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
            IFLAG=1
 34         CONTINUE
            DO 40 J=IFLAG,IFRMAX
C
C========Read frames sequentially
C
               WRITE(ILOG,1040)IFFR 
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,IBUF,IRC)
               IF (IRC.NE.0) GOTO 60
               IFFR=IFFR+IFINC
C
C========Initialization point and line counters
C
               NPTS = 0
               NLIN = 0
               NSCAN = 0
C
C========Set up memory size needed
C
      NBUF1=NPIX*NRAST*4
      NBUF2=NPIX*4
      NBUF3=NPIX*9*4
      NBUF4=NPIX/2*NRAST/2*4
C
C========Now get keyworded input
C              
 35             WRITE(IPRINT,1010)
                CALL FLUSH(6)
                CALL RDCOMF(ITERM,WORD,NW,VALS,NV,ITEM,10,20,10,IRC)
                IF(IRC.NE.0)GOTO 9999
                IF(NV.GT.0.AND.NW.EQ.0)THEN
                   WRITE(IPRINT,2020)
                   CALL FLUSH(6)
                   GOTO 35
                ENDIF
                IF(NW.EQ.0)GOTO 35
                IF(WORD(1)(1:2).EQ.'^D')GOTO 9999
                CALL UPPER(WORD(1),10)
                IF(WORD(1)(1:4).EQ.'WAVE')THEN
                   IF(NV.EQ.0)THEN
                      WRITE(IPRINT,2000)
                      CALL FLUSH(6)
                   ELSE
                      WAVE = VALS(1)
                      GOTWAV = .TRUE.
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'DIST')THEN
                   IF(NV.EQ.0)THEN
                      WRITE(IPRINT,2000)
                      CALL FLUSH(6)
                   ELSE
                      SDD = VALS(1)
                      GOTSDD = .TRUE.
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'CENT')THEN
                   IF(NW.EQ.2)THEN
                      CALL UPPER(WORD(2),10)
                      IF(WORD(2)(1:3).EQ.'FIT')THEN
                         IF(NPTS.GT.0)THEN
                            CALL CENTRE(VALS,NV)
                         ELSE
                            WRITE(IPRINT,2030)
                            CALL FLUSH(6)
                         ENDIF
                      ENDIF
                   ELSE
                      XC = VALS(1)
                      YC = VALS(2)
                      GOTCEN = .TRUE.
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'ROTA')THEN
                   IF(NW.EQ.2)THEN
                      CALL UPPER(WORD(2),10)
                      IF(WORD(2)(1:3).EQ.'FIT')THEN
                         IF(NPTS.GT.0)THEN
                            CALL ROTATE(VALS,NV)
                         ELSE
                            WRITE(IPRINT,2030)
                            CALL FLUSH(6)
                         ENDIF
                      ENDIF      
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
                   IF(NW.EQ.2)THEN
                      CALL UPPER(WORD(2),10)
                      IF(WORD(2)(1:3).EQ.'FIT')THEN
                         IF(NPTS.GT.1)THEN
                            CALL CTILT(VALS,NV)
                         ELSE
                            WRITE(IPRINT,1030)
                            CALL FLUSH(6)
                         ENDIF
                      ENDIF
                   ELSE
                      TILT = -DTOR*VALS(1)
                      GOTTIL = .TRUE.
                      IF(GOTCEN.AND.GOTROT.AND.
     &                   GOTWAV.AND.GOTSDD)CALL STOREC
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'CALI')THEN
                   IF(NV.EQ.1)THEN
                      DCAL = VALS(1)
                      GOTCAL = .TRUE.
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'REFI')THEN
                   XPTS(1) = VALS(1)
                   YPTS(1) = VALS(2)
                   XPTS(2) = VALS(1) + VALS(3)
                   YPTS(2) = YPTS(1)
                   XPTS(3) = XPTS(2)
                   YPTS(3) = VALS(2) + VALS(4)
                   XPTS(4) = XPTS(1)
                   YPTS(4) = YPTS(3)
                   CALL REFALL(IBUF,XPTS,YPTS)
                ELSEIF(WORD(1)(1:4).EQ.'LIST')THEN
                   CALL LIST(ILOG)
                ELSEIF(WORD(1)(1:4).EQ.'PLOT')THEN
                   CALL UPPER(WORD(2),10)
                   IF(WORD(2)(1:4).EQ.'LINE')
     &                CALL LINES (%val(IBUF),GSTOPN,VALS,NV)
                   IF(WORD(2)(1:4).EQ.'SCAN')
     &                CALL SCANS (%val(IBUF),GSTOPN,VALS,NV)
                ELSEIF(WORD(1)(1:4).EQ.'POIN')THEN
                   NPOINTS = 1
                   XPTS(1) = VALS(1)
                   YPTS(1) = VALS(2)
                   CALL REDUCE(%val(IBUF),NPOINTS,XPTS,YPTS,0)
                ELSEIF(WORD(1)(1:4).EQ.'POLY')THEN
                   NPOINTS = NINT(VALS(1))
                   DO N=1,NPOINTS
                      XPTS(N) = VALS(2*N)
                      YPTS(N) = VALS(2*N+1)
                   ENDDO
                   CALL REDUCE(%val(IBUF),NPOINTS,XPTS,YPTS,0)
                ELSEIF(WORD(1)(1:4).EQ.'LINE')THEN
                   NPOINTS = 2
                   XPTS(1) = VALS(1)
                   YPTS(1) = VALS(2)
                   XPTS(2) = VALS(3)
                   YPTS(2) = VALS(4)
                   WIDTH = VALS(5)
                   CALL REDUCE(%val(IBUF),NPOINTS,XPTS,YPTS,WIDTH)
                ELSEIF(WORD(1)(1:4).EQ.'SECT')THEN
                   CALL REDSEC(%val(IBUF),VALS(1),VALS(2),VALS(3),
     &                         VALS(4),VALS(5),VALS(6))
                ELSEIF(WORD(1)(1:4).EQ.'SCAN')THEN
                   CALL REDSCN(VALS(1),VALS(2),VALS(3),VALS(4),VALS(5),
     &                         VALS(6))
                ELSEIF(WORD(1)(1:4).EQ.'DELE')THEN
                   CALL UPPER(WORD(2),10)
                   IF(WORD(2)(1:4).EQ.'POIN')CALL DELPNT(VALS,NV)
                   IF(WORD(2)(1:4).EQ.'LINE')CALL DELLIN(VALS,NV)
                   IF(WORD(2)(1:4).EQ.'SCAN')CALL DELSCN(VALS,NV)
                ELSEIF(WORD(1)(1:4).EQ.'RADI')THEN
                   RADIAL = .TRUE.
                ELSEIF(WORD(1)(1:4).EQ.'AZIM')THEN
                   RADIAL = .FALSE.
                ELSEIF(WORD(1)(1:4).EQ.'SPOT')THEN
                   LATPNT = .TRUE.
                ELSEIF(WORD(1)(1:4).EQ.'RING')THEN
                   LATPNT = .FALSE.
                ELSEIF(WORD(1)(1:4).EQ.'CELL')THEN
                   CELL(1) = VALS(1)
                   CELL(2) = VALS(2)
                   CELL(3) = VALS(3)
                   CELL(4) = VALS(4)
                   CELL(5) = VALS(5)
                   CELL(6) = VALS(6)
                ELSEIF(WORD(1)(1:4).EQ.'MISS')THEN
                   PHIX = VALS(1)*DTOR
                   PHIZ = VALS(2)*DTOR
                ELSEIF(WORD(1)(1:4).EQ.'SPAC')THEN
                   SPCGRP = WORD(2)
                ELSEIF(WORD(1)(1:4).EQ.'GENE')THEN
                   CALL FIBGEN(VALS(1),VALS(2))
                ELSEIF(WORD(1)(1:4).EQ.'BACK')THEN

C Store original data
                  IRC=GETMEM(NBUF1,DUMBUF)
                  IF(IRC.NE.1)STOP 'Error allocating memory'
                  CALL GETBUF(%val(IBUF),%val(DUMBUF),NPIX,NRAST)

                  CALL UPPER(WORD(2),10)
                  IF(WORD(2)(1:6).EQ.'SMOOTH')THEN
                    DO 555 IJ=3,10
                      CALL UPPER(WORD(IJ),10)
 555                CONTINUE

C Allocate memory

                    IRC=GETMEM(NBUF1,IBUF1)
                    IF(IRC.NE.1)STOP 'Error allocating memory'
                    IRC=GETMEM(NBUF1,IBUF2)
                    IF(IRC.NE.1)STOP 'Error allocating memory'
                    IRC=GETMEM(NBUF2,IBUF3)
                    IF(IRC.NE.1)STOP 'Error allocating memory'
                    IRC=GETMEM(NBUF2,IBUF4)
                    IF(IRC.NE.1)STOP 'Error allocating memory'
                    IRC=GETMEM(NBUF2,IBUF5)
                    IF(IRC.NE.1)STOP 'Error allocating memory'
                    IRC=GETMEM(NBUF2,IBUF6)
                    IF(IRC.NE.1)STOP 'Error allocating memory'
                    IRC=GETMEM(NBUF2,IBUF7)
                    IF(IRC.NE.1)STOP 'Error allocating memory'
                    IRC=GETMEM(NBUF3,IBUF8)
                    IF(IRC.NE.1)STOP 'Error allocating memory'
                    IRC=GETMEM(NBUF1,IBUF9)
                    IF(IRC.NE.1)STOP 'Error allocating memory'
                    IRC=GETMEM(NBUF4,IBUF10)
                    IF(IRC.NE.1)STOP 'Error allocating memory'

                    CALL BCKSMOOTH( %val(DUMBUF),%val(IBUF1),
     &              %val(IBUF2),%val(IBUF10),VALS,WORD,%val(IBUF3),
     &              %val(IBUF4),%val(IBUF5),%val(IBUF6),
     &              %val(IBUF7),%val(IBUF8),%val(IBUF9),NBUF4 )

                    CALL FREMEM(IBUF1)
                    CALL FREMEM(IBUF2)
                    CALL FREMEM(IBUF3)
                    CALL FREMEM(IBUF4)
                    CALL FREMEM(IBUF5)
                    CALL FREMEM(IBUF6)
                    CALL FREMEM(IBUF7)
                    CALL FREMEM(IBUF8)
                    CALL FREMEM(IBUF9)
                    CALL FREMEM(IBUF10)

                  ELSEIF(WORD(2)(1:6).EQ.'WINDOW')THEN

                    IRC=GETMEM(NBUF1,IBUF1)
                    IF(IRC.NE.1)STOP 'Error allocating memory'

                    CALL BCKWIN(%val(DUMBUF),%val(IBUF1),VALS)

                    CALL FREMEM(IBUF1)

                  ELSEIF(WORD(2)(1:4).EQ.'CSYM')THEN

                    IRC=GETMEM(NBUF1,IBUF1)
                    IF(IRC.NE.1)STOP 'Error allocating memory'

                    CALL BCKCSYM(%val(DUMBUF),%val(IBUF1),VALS)

                    CALL FREMEM(IBUF1)

                  ENDIF

                  CALL FREMEM(DUMBUF)

                ELSEIF(WORD(1)(1:4).EQ.'FRAM')THEN
                   GOTO 40
                ELSEIF(WORD(1)(1:4).EQ.'GOFR')THEN
                   IFFR=INT(VALS(1))
                   IFLAG=IFFR
                   GOTO 34
                ELSEIF(WORD(1)(1:4).EQ.'FILE')THEN
                   GOTO 60
                ELSEIF(WORD(1)(1:4).EQ.'QUIT')THEN
                   GOTO 9999
                ELSE
                   WRITE(IPRINT,2010)
                   CALL FLUSH(6)
                ENDIF
                DO 558 IJ=1,10
                  WORD(IJ)=' '
 558            CONTINUE
                GOTO 35
 40         CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
 50   CONTINUE
 60   CALL FCLOSE (JUNIT)
      GOTO 10
 9999 CLOSE(ILOG)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      IF(GSTOPN)CALL GREND
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IF(GSTOPN)CALL PGEND
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      STOP 'Normal stop' 
C
C-----------------------------------------------------------------------
 1000 FORMAT(/1X,'200',
     &       1X,'FIX - Fibre diffraction analysis program'/
     &       1X,'Last update 09/04/99'/)
 1001 FORMAT('FIX_',I5.5,'.LOG')
 1002 FORMAT(75('*')/
     &       '*',1X,'FIX - Fibre diffraction analysis program',32X,'*'/
     &       '*',1X,'Last update 12/11/98',52X,'*'/
     &       '*',73X,'*'/
     &       '*',1X,'FIX log file opened ',A30,'Process ID ',I5,6X,'*'/
     &       75('*')/)
 1005 FORMAT(1X,'201 New input file')
 1010 FORMAT(1X,'200 Fix:  ',$)
 1020 FORMAT(1X,'Header filename: ',A80)
 1030 FORMAT(1X,'First frame ',I4,'  Last frame ',I4,'  Incr. ',I4)
 1040 FORMAT(1X,'Reading frame ',I4)
 2000 FORMAT(1X,'400 Numeric input expected')
 2010 FORMAT(1X,'400 Unrecognized keyword')
 2020 FORMAT(1X,'400 Keyword expected')
 2030 FORMAT(1X,'400 Buffer empty')
C-----------------------------------------------------------------------
      END                  

      BLOCK DATA
      INCLUDE 'FIXPAR.COM'

      DATA GOTWAV /.FALSE./, GOTSDD /.FALSE./, GOTCEN /.FALSE./,
     &     GOTROT /.FALSE./, GOTTIL /.FALSE./, RADIAL /.FALSE./,
     &     LATPNT /.TRUE./

      DATA ITERM /5/, IPRINT /6/, ILOG /10/
      END

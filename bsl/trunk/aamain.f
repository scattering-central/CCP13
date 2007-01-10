C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C Program BSL.FOR
C
C Purpose: Interactive data appraisal for 2-d images.
C
C Author: G.R.Mant & J.Bordas, Daresbury lab., Warrington
C
C Limitations: Maximum image size 512*512 ( MAXDIM in common /SIZES/ )
C
C Non-ANSI code:
C 1: All routines called by BSL main program, including itself, use
C    the INCLUDE statement for common block insertion.
C 2: Wherever information is requested from the terminal the '$' format
C    control character is used. This leaves the cursor at the end of the
C    line.
C
C Implementation notes:
C 1: Subroutine ERRMSG uses ESCAPE sequences specific to VT100
C    emulator terminals to switch into inverse video mode.
C 2: Several subroutines are taken from the OTOKO Program library.
C 3: Subroutines requiring changes for unix implementation:
C
C Updates:
C 09/06/89 GM Initail implementation of UNIX version of BSL started
C 30/05/96 GM Corrected bug in .VER & .HOR, changed askno to askyes 
C             Corrected bug in .SUM (for 2nd picture crash).
C
      IMPLICIT NONE
      INCLUDE 'COMMON.FOR'
      COMMON /MYGRAF/ OPENGR
      LOGICAL         OPENGR
C
C CALLS 43:  ADD    , ADDCON  , ADDFIL , ADDNRM  , AVERAG , BACK
C            CHANGE , CONPLOT , CUT    , DISPLAY , DIVCON , DIVFIL
C            DIVIDE , DIVNRM  , DUPE   , EXPON   , FFT    , GETINS
C            HORINT , IFT     , INTEG  , INTERP  , INVPOL , LOGTHM
C            MASK   , MAXVAL  , MIRROR , MULCON  , MULFIL , MULNRM
C            MULT   , PACK    , POLAR  , POWER   , PRTVAL , RADII
C            REMAP  , REPLACE , ROTATE , SHIFT   , SUBNRM , SUM
C            VERINT , WINDO   , ZERO   , SECTOR  , IMPRINT, CONVOLVE
C            MERGE  , GAUSSIAN, INSERT , ROTINT  , CIRSCN , RADSCN
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      INTEGER IOPT
C
C IOPT   : INSTRUCTION SELECTED
C
C-----------------------------------------------------------------------
C
C========GET INSTRUCTION FROM USER OR <CTRL-Z> TO END
C
10    CALL GETINS (ITERM,IPRINT,IOPT)
      IF (IOPT.EQ.0) GOTO 999
C
C========PROCESS INSTRUCTION
C
      GOTO (100,110,120,130,140,150,160,170,180,190,
     &      200,210,220,230,240,250,260,270,280,290,
     &      300,310,320,330,340,350,360,370,380,390,
     &      400,410,420,430,440,450,460,470,480,490,
     &      500,510,520,530,540,550,190,570,580,590,
     &      600,610,620,630,640,650,660,670,680) IOPT
C
      CALL ERRMSG ('Error: In software Please report!')    
      GOTO 999
C
100   CALL ADDCON
      GOTO 10
C
110   CALL ADD
      GOTO 10
C
120   CALL ADDNRM
      GOTO 10
C
130   CALL ADDFIL
      GOTO 10
C
140   CALL AVERAG
      GOTO 10
C
150   CALL CONPLOT
      GOTO 10
C
160   CALL CUT
      GOTO 10
C
170   CALL DIVCON
      GOTO 10
C
180   CALL DIVNRM
      GOTO 10
C
190   CALL DISPLAY
      GOTO 10
C
200   CALL DIVIDE
      GOTO 10
C
210   CALL DIVFIL
      GOTO 10
C
220   CALL DUPE
      GOTO 10
C
230   CALL EXPON
      GOTO 10
C
240   CALL FFT 
      GOTO 10
C
250   CALL HORINT
      GOTO 10
C
260   CALL IFT   
      GOTO 10
C
270   CALL INTEG  
      GOTO 10
C
280   CALL INVPOL
      GOTO 10
C
290   CALL INTERP
      GOTO 10
C
300   CALL LOGTHM
      GOTO 10
C
310   CALL MAXVAL 
      GOTO 10
C
320   CALL MIRROR
      GOTO 10
C
330   CALL MULFIL
      GOTO 10
C
340   CALL MASK 
      GOTO 10
C
350   CALL MULCON
      GOTO 10
C
360   CALL MULT
      GOTO 10
C
370   CALL MULNRM 
      GOTO 10
C
380   CALL PACK  
      GOTO 10
C
390   CALL POLAR 
      GOTO 10
C
400   CALL POWER  
      GOTO 10
C
410   CALL PRTVAL
      GOTO 10
C
420   CALL RADII
      GOTO 10
C
430   CALL DUPE
      GOTO 10
C
440   CALL REPLACE 
      GOTO 10
C
450   CALL REMAP 
      GOTO 10
C
460   CALL ROTATE 
      GOTO 10
C
470   CALL SHIFT  
      GOTO 10
C
480   CALL SUM
      GOTO 10
C
490   CALL SUBNRM
      GOTO 10
C
500   CALL VERINT
      GOTO 10
C
510   CALL WINDO 
      GOTO 10
C
520   CALL ZERO
      GOTO 10
C
530   CALL BACK
      GOTO 10
C
540   CALL CHANGE
      GOTO 10
C
550   CALL GLITCH
      GOTO 10
C
 570  CALL IMPRINT
      GOTO 10
C
 580  CALL SECTOR
      GOTO 10
C
 590  CALL GAUSSIAN
      GOTO 10
C
 600  CALL CONVOLVE
      GOTO 10
C
 610  CALL MERGE
      GOTO 10
C
 620  CALL INSERT
      GOTO 10
C
 630  CALL ROTINT
      GOTO 10
C
 670  CONTINUE
 640  CALL CIRSCN
      GOTO 10
C
 680  CONTINUE
 650  CALL RADSCN
      GOTO 10
C
 660  CALL SURFACE
      GOTO 10
C
999   IF (OPENGR) CALL GREND
      STOP
      END
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      BLOCK DATA BLKDAT
C
      INCLUDE 'COMMON.FOR'
      COMMON /MYGRAF/ OPENGR
      LOGICAL         OPENGR
C
C-----------------------------------------------------------------------
C
C========INITIALISE FORTRAN I/O CHANNEL UNITS
C
      DATA JUNIT/-1/, KUNIT/-1/, LUNIT/-1/
      DATA ITERM/5/, IPRINT/6/, IUNIT/1/
C
      DATA MAXDIM/1048576/
C
      DATA OPENGR/.FALSE./
      END

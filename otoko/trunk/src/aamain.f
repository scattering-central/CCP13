C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C      Program Otoko.for
C
C Purpose: Interactive data reduction package for 1-d.
C
C Author: M.H.J.Koch & P.Bendall, EMBL, Hamburg
C         G.R.Mant & J.Bordas, Daresbury lab., Warrington
C
C Limitations: Maximum frame length is 5000 channels.
C              Maximum frame length in *FFT & *IFT is 2048 channels.
C
C Non-ANSI code:
C 1: All routines called by OTOKO main program, including itself, use
C    the INCLUDE statement for common block insertion.
C 2: Wherever information is requested from the terminal the '$' format
C    control character is used. This leaves the cursor at the end of the
C    line.
C 4: Open statements use the extensions: CARRIAGECONTROL, DISPOSE,
C    SHARED, and USEROPEN.
C
C Implementation notes:
C 1: Subroutine PRTVAL uses the logical name LP: to open a stream to
C    the lineprinter.
C 2: Subroutine ERRMSG uses ESCAPE sequences specific to VT100
C    emulator terminals to switch into inverse video mode.
C 3: Subroutines INVFFT & FRWFFT are both limited to 2048 points,
C    therefore the array sizes may be increased but not decreased.
C    If the dimension size is increased in the COMMON remember to
C    adjust the XDATA array size in APLOT and the blockdata
C    initialisation.
C 4: Subroutine ACCESS is required by VAX VMS 4.4 to overcome the
C    record locking introduced with this release of the operating
C    system. It is only necessary if 1 file is to be accessed on
C    more than one I/O stream.
C 5: Subroutines requiring changes for unix implementation:
C    DAWRT :- change machine specific direct access open statement.
C    GETFIL:- comment out code for version numbers.
C    HDRGEN:- change the open statement to remove CARRIAGECONTROL='LIST'.
C    IGETS :- add PRINT statement for <CTRL-Z> handling.
C    OPNFIL:- change machine specific direct access open statement.
C    OUTFIL:- comment out code for version numbers.
C    TRMODE:- change format statement & add UNIX system call 'FLUSH'.
C
C Updates:
C 05/04/85 GRM Restructured OTOKO main routine. 
C 07/04/85 GRM Isolated code for each instruction into separate
C              subroutines. Removed code for hardcopy listing.
C 09/04/85 GRM Constructed common blocks & defined variables.
C              Converting to Fortran-77 where possible.
C 09/05/85 GRM Tidying code, checking for ANSI standards, updating
C              system docco. 
C 15/05/85 GRM Removed redundant instructions .ODI .PLS & .SCN 
C 16/05/85 GRM Added routine GETVAL for unformatted internal read.
C 20/05/85 GRM Added routines ASKYES & ASKNO which assign logical
C              values in response to a yes/no question.
C 21/05/85 GRM Included .EXP instruction to evaluate exponentials.
C 12/06/85 GRM Recoded .FIT either interpolate between values selected
C              with cursor or fit a spline through the selected points.
C 12/07/85 GRM Included modified Ghost axis annotation routines to
C              prevent overlap of numbers.
C 15/07/85 GRM Increased maximum frame size to 4096 channels.
C 03/09/85 GRM Implemented .LAT instruction to calculate 1-D structures
C              from diffraction data, input modulus of structure factors
C              and their phases.
C 16/09/85 GRM Implemented reverse latice transform instruction *ILT.
C 07/10/85 GRM Increased maximum frame size to 5000 channels.
C 29/10/85 GRM Implemented instruction to SUM several files.
C 17/11/85 GRM Enhanced merge instruction to include the *MRG option.
C 25/11/85 GRM Corrected minor bugs in DIVNRM & AVERAG
C 29/11/85 GRM Corrected minor bugs in ADDNRM,MULNRM,DIVNRM to allow
C              correct checking for mismatched operation, which previously
C              allowed each instruction to be used once.
C 09/12/85 GRM Corrected minor bug in zero check for DIN instruction.
C 14/02/86 GRM Corrected bug in GUINIER to calculate using natural logs.
C 27/03/86 GRM GETCHN now allows a 1 channel range.
C 22/05/86 SD  Corrections to INVFFT and GENFUN
C 29/05/86 GRM Corrections to subroutine FPK
C 01/06/86 GRM Correction to INVLAT: missing PI declaration
C              Implemented .COS and .SIN instructions.
C 03/06/86 GRM Corrected bug in SUBNRM
C 17/06/86 GRM Removed explicit declaration of help library and 
C              replaced it with a logical name.
C 03/07/86 SEM Corrected bug in *SPL. Note Harlib routine VC03A should be 
C              compiled with G_floating.
C 30/07/86 GRM Subroutine ACCESS introduced to bypass VMS 4.4 record
C              locking. See implemetation notes.
C 08/10/86 GRM Removed all occurences of VAX Q format specifier.
C              Implemented with release & of GHOST, this requires all
C              characters (title, axis annotation & gridfile names) to be
C              declared with CHARACTER declaration.
C 02/02/87 GRM Modification to histogram plot to handle negative nos.
C 28/04/87 GRM Removed .HLP instruction to make this program independent
C              of the VMS version (i.e. dependence on the RTL).
C              Replaced RTL subroutine, STR$UPCASE with Fortran subroutine
C              UPCASE.  Added new instructions *SFT & .SIT for Singleton
C              fast fourier transform, .LSQ for linear least squares 
C              fitting, .BAK .BPK for background correction.
C              Modification to CUT for multpile frame option.
C 26/06/87 GRM Corrected bug in .MAX for multiple file operations.
C 07/07/87 GRM Added .ITP instruction to interpolate files.
c 22/07/87 GRM Added facility to print values to laser printer.
C 21/10/87 GRM Modified .DIV to correct divisor for negative nos.
C 04/11/87 GRM Added instruction .XSH to shift blocks of data.
C 16/11/87 GRM Corrected *GUI for multiple frame options and added code
C              to interpolate values to zero.
C 19/11/87 GRM Added instruction .ISQ to integrate sequentially. Added
C              title to .PL3 plots.
C 23/02/88 GRM Added 2 new instructions .JOI to combine time frame data
C              into 1 file & .WIN to calculate a Tukey window for FFT's.
C              Modified the .PLO instruction to allow 4 graphs to be
C              plotted on the screen simultaneously.
C 29/03/88 GRM Corrected bug in .PKK instruction.
C 11/04/88 GRM Corrected bug in .FIT (now gives x-axis header file)
C              Added *ISQ instruction to integrate areas using start & end
C              values from a file (generated by .FIT or .GEN)
C 18/04/88 GRM Corrected *MRG to check for more than 2 equivalent xaxis
C              points. Added extra features to the .WIN instruction to allow
C              cursor selection & multiplication of the data by the window.
C 02/06/88 GRM Added instruction .ZER & corrected bug in MPLOT
C 08/06/88 GRM Modifications to .DIN, .ADN, .SUN, .MUN, & FRPLOT
C 12/12/88 GRM Mod to stop GHOST limiting nos. of plots, added 5th plot
C              style to allow user to select GHOST symbol, added title
C              to *GUI instruction.
C 03/01/89 GRM Added guassian function to .FUN instruction.
C 11/01/89 GRM Corrected error in .DIN which prohibited multiple file op's.
C 16/03/89 GRM UNIX implementation. See implementation notes.
C 30/10/89 GRM Added .FCH fractional change.
C 18/07/91 GRM Implement on SUN sparcstation. Added subroutines .PNT .NBK
C              .RBK .SBK & .PRO
C 02/09/91 GRM Added functions .SEP, *RMZ, *MAX and .FPK
C 20/11/91 JFD Modified .PRO routine
C 15/01/92 GRM Added functions .DRV, .RMP, modified .PNT
C 14/02/92 GRM Added anti-log routine .ALG
C 29/05/92 GRM Added .GIN create frame of data by interpolation between points
C 10/08/92 GRM Added .ASF add single file to multiple frames
C 18/01/94 GRM Added .MBP multiply by point.
C 03/02/94 GRM Modified .RBK to save selected points and reenter them later.
C 01/09/94 GRM Added .GAU function for series of gaussians
C
      IMPLICIT NONE
      INCLUDE 'COMMON.FOR'
      COMMON /MYGRAF/ OPENGR
      LOGICAL         OPENGR
C
C Calls 59: ABSVAL , ADDCON , ADD    , ADDNRM , AVERAG , CHANGE , CPK
C           CUMSUM , CUT    , DERIV  , DIVCON , DIVNRM , DIVIDE , EXPON
C           FIT    , FRWFFT , FUNCT  , GENFRM , GETINS , GUINIER, LSQ
C           INVFFT , INTEG  , LOGTHM , MAXVAL , MIRROR , MPLOT  , MERGE
C           MULCON , MULT   , MULNRM , PACK   , PCC    , PKK    , PLOT3D
C           COPLOT , PLOT   , POE    , POLNOM , POWER  , PRTVAL , SELECT
C           OPTIM  , SMOOTH , SPLINE , SUBNRM , XAXGEN , ERRMSG , LATICE
C           INVLAT , SUM    , COSINE , SINE   , SFT    , SIT    , BACK
C           PEAK   , INTERP , XSHIFT , INTSEQ , WINDO  , FJOIN  , ZERO
C           FRACTN , PNT    , NBACK  , RBACK  , SBACK  , PROCESS, ODDEVEN
C           REMZER , DERIV2 , REMAP  , ALGTHM , ADDFIL , MULPNT , GAUSS
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER IOPT
      LOGICAL XAXIS
C
C IOPT  : Instruction value
C XAXIS : Set true for user supplied x-axis
C
C_______________________________________________________________________
C
C========GET USER INSTRUCTION
C
10    CALL GETINS (ITERM,IPRINT,IOPT)
      IF (IOPT.EQ.0) GOTO 999
C
C========PROCESS INSTRUCTION
C
      GOTO (100,110,120,130,140,150,160,170,180,190,
     1      200,210,220,230,240,250,260,270,280,290,
     2      300,310,320,330,340,350,360,370,380,390,
     3      400,410,420,430,440,450,460,470,480,490,
     4      500,510,520,530,540,550,560,570,580,590,
     5      600,610,620,630,640,650,660,670,680,690,
     6      700,710,720,730,740,750,760,770,780,790,
     7      800,810,820,830,840,850,860,870,880,890,
     8      900,910,920,930,940,950,960) IOPT
C
      CALL ERRMSG ('Error: In software Please report!')    
C
100   CALL ABSVAL
      GOTO 10
C
110   CALL ADDCON
      GOTO 10
C
120   CALL ADD
      GOTO 10
C
130   CALL ADDNRM
      GOTO 10
C
140   CALL AVERAG
      GOTO 10
C
150   CALL CHANGE
      GOTO 10
C
160   CALL CPK
      GOTO 10
C
170   CALL CUMSUM
      GOTO 10
C
180   CALL CUT
      GOTO 10
C
190   CALL DERIV
      GOTO 10
C
200   CALL DIVCON
      GOTO 10
C
210   CALL DIVNRM
      GOTO 10
C
220   CALL DIVIDE
      GOTO 10
C
230   CALL EXPON
      GOTO 10
C
240   CALL FIT
      GOTO 10
C
250   CALL FRWFFT
      GOTO 10
C
260   CALL FUNCT
      GOTO 10
C
270   CALL GENFRM
      GOTO 10
C
280   CALL GUINIER
      GOTO 10
C
290   CALL LSQ
      GOTO 10
C
300   CALL INVFFT
      GOTO 10
C
310   CALL INTEG
      GOTO 10
C
320   CALL LOGTHM
      GOTO 10
C
 330  XAXIS=.FALSE.
      CALL MAXVAL (XAXIS)
      GOTO 10
C
340   CALL MIRROR
      GOTO 10
C
350   XAXIS=.FALSE.
      CALL MPLOT (XAXIS)
      GOTO 10
C
360   XAXIS=.TRUE.
      CALL MPLOT (XAXIS)
      GOTO 10
C
370   XAXIS=.FALSE.
      CALL MERGE (XAXIS)
      GOTO 10
C
380   CALL MULCON
      GOTO 10
C
390   CALL MULT
      GOTO 10
C
400   CALL MULNRM
      GOTO 10
C
410   CALL PACK
      GOTO 10
C
420   XAXIS=.TRUE.
      CALL FPK (XAXIS)
      GOTO 10
C
430   CALL PCC
      GOTO 10
C
440   CALL PKK
      GOTO 10
C
450   CALL PLOT3D
      GOTO 10
C
460   CALL COPLOT
      GOTO 10
C
470   XAXIS=.FALSE.
      CALL PLOT (XAXIS)
      GOTO 10
C
480   XAXIS=.TRUE.
      CALL PLOT (XAXIS)
      GOTO 10
C
490   CALL POE
      GOTO 10
C
500   XAXIS=.FALSE.
      CALL POLNOM (XAXIS)
      GOTO 10
C
510   XAXIS=.TRUE.
      CALL POLNOM (XAXIS)
      GOTO 10
C
520   CALL POWER
      GOTO 10
C
530   CALL PRTVAL
      GOTO 10
C
540   CALL SELECT
      GOTO 10
C
550   CALL OPTIM
      GOTO 10
C
560   CALL SMOOTH
      GOTO 10
C
570   XAXIS=.FALSE.
      CALL SPLINE (XAXIS)
      GOTO 10
C
580   XAXIS=.TRUE.
      CALL SPLINE (XAXIS)
      GOTO 10
C
590   CALL SUBNRM
      GOTO 10
C
600   CALL XAXGEN
      GOTO 10
C
610   CALL LATICE
      GOTO 10
C
620   CALL INVLAT
      GOTO 10
C
630   CALL SUM
      GOTO 10
C
640   XAXIS=.TRUE.
      CALL MERGE (XAXIS)
      GOTO 10
C
650   CALL COSINE
      GOTO 10
C
660   CALL SINE
      GOTO 10
C
670   CALL SFT
      GOTO 10
C
680   CALL SIT
      GOTO 10
C
690   CALL BACK
      GOTO 10
C
700   CALL PEAK
      GOTO 10
C
710   CALL INTERP
      GOTO 10
C
720   CALL XSHIFT
      GOTO 10
C
730   XAXIS=.FALSE.
      CALL INTSEQ (XAXIS)
      GOTO 10
C
740   CALL FJOIN
      GOTO 10
C
750   CALL WINDO
      GOTO 10
C
760   XAXIS=.TRUE.
      CALL INTSEQ (XAXIS)
      GOTO 10
C
770   CALL ZERO
      GOTO 10
C
780   CALL FRACTN
      GOTO 10
C
 790  CALL PNT
      GOTO 10
C
 800  CALL NBACK
      GOTO 10
C
 810  XAXIS=.FALSE.
      CALL  RBACK (XAXIS)
      GOTO 10
C
 820  CALL SBACK
      GOTO 10
C
 830  CALL PROCESS
      GOTO 10
C
 840  CALL ODDEVEN
      GOTO 10
C
 850  CALL REMZER
      GOTO 10
C
 860  XAXIS=.TRUE.
      CALL MAXVAL (XAXIS)
      GOTO 10
C
 870  XAXIS=.FALSE.
      CALL FPK (XAXIS)
      GOTO 10
C
 880  CALL DERIV2
      GOTO 10
C
 890  CALL REMAP
      GOTO 10
C
 900  CALL ALGTHM
      GOTO 10
C
 910  CALL GENITP
      GOTO 10
C
 920  CALL ADDFIL
      GOTO 10
C
 930  CALL MULPNT
      GOTO 10
C
 940  XAXIS=.TRUE.
      CALL RBACK (XAXIS)
      GOTO 10
C
 950  CALL GAUSS
      GOTO 10
C
960   XAXIS=.TRUE.
      CALL PLOTNS (XAXIS)
      GOTO 10
C
 999  IF (OPENGR) CALL GREND
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
      DATA ITERM/5/ , IPRINT/6/
      DATA IUNIT/1/ , JUNIT/2/ , KUNIT/3/ , LUNIT/4/ , munit/7/
      DATA nunit/8/
C
      DATA OPENGR/.FALSE./
C
      END

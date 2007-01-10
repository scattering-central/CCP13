C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE GETINS (ITERM,IPRINT,IOPT)
      IMPLICIT NONE
C
C Purpose: Read instruction from terminal, check to make sure its in
C          upper case and then calculate its option number from its
C          position in the command string.
C
      INTEGER ITERM,IPRINT,IOPT
C
C ITERM  : Terminal input stream
C IPRINT : Terminal output stream
C IOPT   : Instruction option number 0 - <ctrl-z>
C                                   >1 - valid instruction
C
C Calls   2: ERRMSG , UPCASE
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      INTEGER       INDX
      CHARACTER*256 CMDSTR
      CHARACTER*4   TBUFF
      LOGICAL       IGETS
C
C INDX   : Postion of valid instruction in command string
C CMDSTR : Command string
C TBUFF  : Terminal buffer
C
      DATA CMDSTR(1:36)    /'.ADC.ADD.ADN.ASF.AVE.CON.CUT.DIC.DIN'/
      DATA CMDSTR(37:72)   /'.DIS.DIV.DSF.DUP.EXP.FFT.HOR.IFT.INT'/
      DATA CMDSTR(73:108)  /'.IPO.ITP.LOG.MAX.MIR.MSF.MSK.MUC.MUL'/
      DATA CMDSTR(109:144) /'.MUN.PAK.POL.POW.PRT.CIR.REM.REP.RMP'/
      DATA CMDSTR(145:180) /'.ROT.SHF.SUM.SUN.VER.WIN.ZER.BAK.CHG'/
      DATA CMDSTR(181:216) /'.DGL.ARG.LZR.SEC.GAU.CNV.MRG.INS.ROI'/
      DATA CMDSTR(217:252) /'.CIN.RIN.SUR.RAD.AZI.***.***.***.***'/
      DATA CMDSTR(253:256) /'.***'/
C
C-----------------------------------------------------------------------
10    WRITE (IPRINT,'(A,$)') ' Enter instruction: '
      IF (IGETS (ITERM,TBUFF)) THEN
         CALL UPCASE (TBUFF,TBUFF)
         INDX=INDEX (CMDSTR,TBUFF)
         IF (INDX.NE.0) THEN
            IOPT=(INDX+3)/4
            RETURN
         ENDIF
         CALL ERRMSG ('Error: Illegal instruction')
         GOTO 10
      ENDIF
      IOPT=0
C
      END

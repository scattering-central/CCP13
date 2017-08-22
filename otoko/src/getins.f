C     LAST UPDATE 16/03/899
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
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER       INDX,I
      CHARACTER*256 CMDSTR(2)
      CHARACTER*4   TBUFF
      LOGICAL       IGETS
C
C INDX   : Postion of valid instruction in command string
C CMDSTR : Command string
C TBUFF  : Terminal buffer
C
      DATA CMDSTR(1)(1:36)    /'.ABS.ADC.ADD.ADN.AVE.CHG.CPK.CUM.CUT'/
      DATA CMDSTR(1)(37:72)   /'.DER.DIC.DIN.DIV.EXP.FIT*FFT.FUN.GEN'/
      DATA CMDSTR(1)(73:108)  /'*GUI.LSQ*IFT.INT.LOG.MAX.MIR.MPL*MPL'/
      DATA CMDSTR(1)(109:144) /'.MRG.MUC.MUL.MUN.PAK*FPK.PCC.PKK.PL3'/
      DATA CMDSTR(1)(145:180) /'*PLC.PLO*PLO*POE.POL*POL.POW.PRT.SEL'/
      DATA CMDSTR(1)(181:216) /'.SHO.SMO.SPL*SPL.SUN.XAX.LAT*ILT.SUM'/
      DATA CMDSTR(1)(217:252) /'*MRG.COS.SIN*SFT.SIT.BAK.BPK.ITP.XSH'/
      DATA CMDSTR(1)(253:256) /'.ISQ'/
C
      DATA CMDSTR(2)(1:36)    /'.JOI.WIN*ISQ.ZER.FCH.PNT.NBK.RBK.SBK'/
      DATA CMDSTR(2)(37:72)   /'.PRO.SEP*RMZ*MAX.FPK.DRV.RMP.ALG.GIN'/
      DATA CMDSTR(2)(73:108)  /'.ASF.MBP*RBK.GAU*PLS.***.***.***.***'/
      DATA CMDSTR(2)(109:144) /'.***.***.***.***.***.***.***.***.***'/
      DATA CMDSTR(2)(145:180) /'.***.***.***.***.***.***.***.***.***'/
      DATA CMDSTR(2)(181:216) /'.***.***.***.***.***.***.***.***.***'/
      DATA CMDSTR(2)(217:252) /'.***.***.***.***.***.***.***.***.***'/
      DATA CMDSTR(2)(253:256) /'.***'/
C
C-----------------------------------------------------------------------
10    WRITE (IPRINT,'(A,$)') ' Enter instruction: '
      IF (IGETS (ITERM,TBUFF)) THEN
         CALL UPCASE (TBUFF,TBUFF)
         DO 20 I=1,2
            INDX=INDEX (CMDSTR(I),TBUFF)
            IF (INDX.NE.0) THEN
               IOPT=(I-1)*64+(INDX+3)/4
               RETURN
            ENDIF
20       CONTINUE
         CALL ERRMSG ('Error: Illegal instruction')
         GOTO 10
      ENDIF
      IOPT=0
C
      END

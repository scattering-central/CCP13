      SUBROUTINE RECCEL(CELL,RCELL)
      IMPLICIT NONE
C***********************************************************************
C-----------------------------------------------------------------------
C PURPOSE: ESTABLISH RECIPROCAL CELL PARAMETERS FROM REAL CELL PARAMS
C =======  USING FORMULAE OF STOUT+JENSEN - "X-RAY STRUCTURE ANALYSIS",
C          MACMILLAN CO. (1968),  P.31, OR INT. TABLES VOL I P.13.
C-----------------------------------------------------------------------
C CALLS      : 0
C =====
C-----------------------------------------------------------------------
C ARGUMENTS:
C =========
C  CELL(I)  - Real array containing real space lattice parameters
C  RCELL(O) - Real array containing derived reciprocal space lattice pars
C-----------------------------------------------------------------------
      REAL CELL(6),RCELL(6)
      REAL CASQ,CBSQ,CCSQ,CBA,ALBTGM,VOLUME,XNUM,DEN,TEMP
C-----------------------------------------------------------------------
C
C-- Calculate real cell volume. Remember all angles should already be
C   in radians.
C
      CASQ = (COS(CELL(4)))**2
      CBSQ = (COS(CELL(5)))**2
      CCSQ = (COS(CELL(6)))**2
      CBA = CELL(1)*CELL(2)*CELL(3)
      ALBTGM = COS(CELL(4))*COS(CELL(5))*COS(CELL(6))
      VOLUME = CBA*(SQRT(1.0-CASQ-CBSQ-CCSQ+2.0*ALBTGM))
C
C-- Calculate reciprocal cell sides
C
      RCELL(1) = CELL(2)*CELL(3)*SIN(CELL(4))/VOLUME
      RCELL(2) = CELL(1)*CELL(3)*SIN(CELL(5))/VOLUME
      RCELL(3) = CELL(1)*CELL(2)*SIN(CELL(6))/VOLUME
C
C-- Calculate reciprocal cell angles
C
      XNUM = COS(CELL(5))*COS(CELL(6)) - COS(CELL(4))
      DEN = SIN(CELL(5))*SIN(CELL(6))
      TEMP = XNUM/DEN
      RCELL(4) = ACOS(TEMP)
 
      XNUM = COS(CELL(4))*COS(CELL(6)) - COS(CELL(5))
      DEN = SIN(CELL(4))*SIN(CELL(6))
      TEMP = XNUM/DEN
      RCELL(5) = ACOS(TEMP)
 
      XNUM = COS(CELL(4))*COS(CELL(5)) - COS(CELL(6))
      DEN = SIN(CELL(4))*SIN(CELL(5))
      TEMP = XNUM/DEN
      RCELL(6) = ACOS(TEMP)
 
      RETURN
      END

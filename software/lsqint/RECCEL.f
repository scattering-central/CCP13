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
C  RCELL(O) - Real array containing derived reciprocal space lattice 
C             parameters
C-----------------------------------------------------------------------
      REAL CELL(6),RCELL(6)
      DOUBLE PRECISION DC1,DC2,DC3,DC4,DC5,DC6
      DOUBLE PRECISION CASQ,CBSQ,CCSQ,CBA,ALBTGM,VOLUME,XNUM,DEN,TEMP
C-----------------------------------------------------------------------
C
C-- Convert cell parameters to double precision
C
      DC1 = DBLE(CELL(1))
      DC2 = DBLE(CELL(2))
      DC3 = DBLE(CELL(3))
      DC4 = DBLE(CELL(4))
      DC5 = DBLE(CELL(5))
      DC6 = DBLE(CELL(6))
C
C-- Calculate real cell volume. Remember all angles should already be
C   in radians.
C
      CASQ = COS(DC4)**2
      CBSQ = COS(DC5)**2
      CCSQ = COS(DC6)**2
      CBA = DC1*DC2*DC3
      ALBTGM = COS(DC4)*COS(DC5)*COS(DC6)
      VOLUME = CBA*(SQRT(1.0D0-CASQ-CBSQ-CCSQ+2.0D0*ALBTGM))
C
C-- Calculate reciprocal cell sides
C
      RCELL(1) = SNGL(DC2*DC3*SIN(DC4)/VOLUME)
      RCELL(2) = SNGL(DC1*DC3*SIN(DC5)/VOLUME)
      RCELL(3) = SNGL(DC1*DC2*SIN(DC6)/VOLUME)
C
C-- Calculate reciprocal cell angles
C
      XNUM = COS(DC5)*COS(DC6) - COS(DC4)
      DEN = SIN(DC5)*SIN(DC6)
      TEMP = XNUM/DEN
      RCELL(4) = SNGL(ACOS(TEMP))
 
      XNUM = COS(DC4)*COS(DC6) - COS(DC5)
      DEN = SIN(DC4)*SIN(DC6)
      TEMP = XNUM/DEN
      RCELL(5) = SNGL(ACOS(TEMP))
 
      XNUM = COS(DC4)*COS(DC5) - COS(DC6)
      DEN = SIN(DC4)*SIN(DC5)
      TEMP = XNUM/DEN
      RCELL(6) = SNGL(ACOS(TEMP))
 
      RETURN
      END

C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE PEKDES (SP,NCHAN,ICH1,ICH2,IACF,IACL,SPMAX,IMAX,
     1     RMEAN,IMED,IMODE,SIGI,IFWHM,SKEW1,SKEW2,IRC)
      IMPLICIT NONE
C
C Purpose: To calculate the parameters which describe a peak which
C          will be found between channels ICH1 and ICH2 in array SP
C
      REAL SP(1),SPMAX,RMEAN,SIGI,SKEW1,SKEW2
      INTEGER NCHAN,IACF,IACL,IMAX,IMED,IMODE,IFWHM,IRC
C
C SP     : array containing data
C NCHAN  : size of array SP
C IACF   : first active channel (SP()>0.0)
C IACL   : last active channel
C SPMAX  : highest value found in SP()
C IMAX   : channel where SPMAX was found
C RMEAN  : mean
C IMED   : median
C IMODE  : mode
C SIGI   : standard deviation " sigma "
C IFWHM  : FWHM expressed as number of channels
C SKEW1  : Third Moment / Sigma**3
C SKEW2  : ( mean - median ) / sigma
C IRC    : Return code 0 - if successful
C                      1 - if half maximum CANNOT be found
C
C Calls   1: MINMAX
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    SPMIN,SPMAX2,SUMSP,SUMPR,SUMSP2,SECM,THIRDM,DELTAI
      INTEGER IMIN,IL,I2,ICH1,ICH2,I1,I
C
C SPMIN  : Minimum value of spectrum
C SPMAX2 : Spectrum maximum/2
C SUMSP  : Integral of spectrum
C SUMPR  :
C SUMSP2 :
C SECM   : Second moment
C THIRDM : Third moment
C IMIN   : Minimum value in spectrum
C IL     :
C I2     :
C
C
C-----------------------------------------------------------------------  
      IRC=0
C 
C========find active channels,max, and min.
C
      IACF=0
      IACL=0
      CALL MINMAX (SP,NCHAN,ICH1,ICH2,IMIN,IMAX,SPMIN,SPMAX)
      DO 5 I=ICH1,ICH2
         IF (SP(I).NE.0.0.AND.IACF.EQ.0) IACF=I
5     CONTINUE
      DO 6 I=ICH2,ICH1,-1
         IF (SP(I).NE.0.0.AND.IACL.EQ.0) IACL=I
6     CONTINUE 
      IL=IACL-IMAX
      SPMAX2=SPMAX/2.0
C
C========TEST FOR VALIDITY
C
      DO 10 I=1,IL
         IF (SP(IMAX+I).LE.SPMAX2) GOTO 20
10    CONTINUE
      GOTO 998
C
C========VALID
C
20    I2=IMAX+I
      IL=IMAX-IACF
      DO 30 I=1,IL
         IF (SP(IMAX-I).LE.SPMAX2) GOTO 40
30    CONTINUE
      GOTO 998
C
C========ALL VALID
C
   40 I1=IMAX-I
      IFWHM=I2-I1
      SUMSP=0.0
      SUMPR=0.0
C
      DO 50 I=IACF,IACL
         SUMSP=SUMSP+SP(I)
         SUMPR=SUMPR+I*SP(I)
50    CONTINUE
C
      RMEAN=SUMPR/SUMSP
      SUMSP2=SUMSP/2.0
      SUMSP=0.0
      DO 60 I=IACF,IACL
         SUMSP=SUMSP+SP(I)
         IF (SUMSP.GE.SUMSP2) GOTO 70
60    CONTINUE
C
70    IMED=I
      IMODE=IMAX
      SECM=0.0
      THIRDM=0.0
C 
      DO 80 I=IACF,IACL
         DELTAI=I-RMEAN
         SECM=SECM+DELTAI*DELTAI*SP(I)
         THIRDM=THIRDM+DELTAI*DELTAI*DELTAI*SP(I)
80    CONTINUE 
C	
      SECM=SECM/(SUMSP2*2.0)
      THIRDM=THIRDM/(SUMSP2*2.0)
      SECM=ABS(SECM)
      SIGI=SQRT(SECM)
      SKEW1=THIRDM/(SIGI*SIGI*SIGI)
      SKEW2=(RMEAN-IMODE)/SIGI
      RETURN
C
998   IRC=1
      RETURN
      END

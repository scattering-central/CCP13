C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE MINMAX (SP,NCHAN,ICH1,ICH2,IMIN,IMAX,XMIN,XMAX)
      IMPLICIT NONE
C
C Purpose: Finds the minimum and maximum values, their positions, in a
C          data array between given limits.
C
      REAL SP(1),XMIN,XMAX
      INTEGER NCHAN,ICH1,ICH2,IMIN,IMAX
C
C SP     : Data array
C NCHAN  : Nos. of elements in data array
C ICH1   : First channel of interest
C ICH2   : Last channel of interest
C IMIN   : Channel number of minimum value
C IMAX   : Channel number of maximum value
C XMIN   : Value of minimum
C XMAX   : Value of maximum
C
C Calls   0:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      INTEGER I
C
C-----------------------------------------------------------------------
      XMIN=SP(ICH1)
      XMAX=SP(ICH1)
      IMIN=ICH1
      IMAX=ICH1
      DO 10 I=ICH1,ICH2
C
         IF (SP(I).LT.XMIN) THEN
            XMIN=SP(I)
            IMIN=I
C
         ENDIF
         IF (SP(I).GT.XMAX) THEN
            XMAX=SP(I)
            IMAX=I
         ENDIF
10    CONTINUE
      RETURN
      END

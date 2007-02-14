C     LAST UPDATE 14/10/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C     FIT.COM
C
C Purpose: Include file for FIT
C
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
	INTEGER MAXDIM,MAXPAR
	PARAMETER (MAXDIM=5120,MAXPAR=50)
C
C-----------------------------------------------------------------------

C     LAST UPDATE 17/01/97
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE REDSCN(CX,CY,X1,Y1,X2,Y2)
      IMPLICIT NONE
C
C Purpose: Converts scan coordinates from xfix 
C          into 
C
C Calls   1: EVSECT
C Called by: GUIFIX 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file:
C
      INCLUDE 'FIXPAR.COM'
C
C Arguments:
C
      REAL CX,CY,X1,Y1,X2,Y2
C
C Local variables:
C
      INTEGER NS
C
C-----------------------------------------------------------------------
      NS = NSCAN
C
C========Process sectors
C 
      NS = NS + 1
C
C========Write information to common block arrays
C 
      XCSCAN(NS) = CX
      YCSCAN(NS) = CY
      XSCAN(1,NS) = X1
      YSCAN(1,NS) = Y1
      XSCAN(2,NS) = X2
      YSCAN(2,NS) = Y2      
      NSCAN = NS
C
      RETURN
      END                  



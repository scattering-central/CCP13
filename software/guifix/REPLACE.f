C     LAST UPDATE 04/03/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE REPLACE(NPOINTS,IFX,IFY,NRP)
      IMPLICIT NONE
C
C Purpose: Shifts polygon vertex coordinates by the difference between
C          the two previous corresponding centres of gravity. 
C
C Calls   0:
C Called by: FIX 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file:
C
      INCLUDE 'FIXPAR.COM'
C
C Arguments:
C
      INTEGER NPOINTS(MAXPTS),IFX(MAXVAL),IFY(MAXVAL)
      INTEGER NRP
C
C Local variables:
C
      INTEGER I,J,J1,J2,K,II  
C
C-----------------------------------------------------------------------
      II = 0
      K = 0
      DO 30 I=1,MAXPTS
C
C========End of list signal (NPOINTS(I).EQ.0)
C 
         IF(NPOINTS(I).GT.0)THEN
            IF(NPOINTS(I).EQ.2)THEN
C
C========Process lines
C 
               DO 10 J=1,2
                  K = K + 1 
 10            CONTINUE 
            ELSE
C
C========Shift vertex positions 
C 
               II = II + 1
               IF(NPOINTS(I).GT.2)THEN 
                  J1 = NPTS + II - NRP
                  J2 = NPTS + II - 2*NRP 
                  IF(J2.GT.1)THEN
                     DO 20 J=1,NPOINTS(I)
                        K = K + 1
                        IFX(K) = IFX(K) + NINT(FXY(1,J1)-FXY(1,J2))
                        IFY(K) = IFY(K) + NINT(FXY(2,J1)-FXY(2,J2))
 20                  CONTINUE
                  ENDIF
               ELSE
                  K = K + 1
               ENDIF 
            ENDIF 
         ENDIF
 30   CONTINUE
      RETURN
C
      END                  

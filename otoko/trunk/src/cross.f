C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE CROSS (X,XX,Y,YY,YYY,XXX)
      IMPLICIT NONE
C
C Purpose: Interpolates cross point between curve and shadow.
C
      REAL  X,XX,Y,YY,YYY,XXX
C
C X      : Abscissa value 1
C XX     : Abscissa value 2
C Y      : Ordinate value 1
C YY     : Ordinate value 2
C YYY    : Interpolated Ordinate
C XXX    : Interpolated abscissa
C
C Calls   0:
C
C-----------------------------------------------------------------------
      YYY=Y-YY+XX-X
      XXX=Y*(XX-X)+X*(Y-YY)
      IF (ABS(YYY).GE.1.E-6) THEN
         YYY=XXX/YYY
         XXX=XX-X
         IF (ABS(XXX).GE.1.E-6) THEN
            XXX=(YYY-X)/XXX
         ELSE
            XXX=Y-YY
            IF (ABS(XXX).GE.1.E-6) THEN
               XXX=(Y-YYY)/XXX
            ENDIF
         ENDIF
      ENDIF
      RETURN
      END

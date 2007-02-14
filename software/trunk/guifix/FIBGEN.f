C     LAST UPDATE 27/01/97
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FIBGEN(DMIN,DMAX)
      IMPLICIT NONE
C
C Purpose: Generates Bragg-sampling points for fibre patterns.
C
C Calls   2: DRAGON , RECTOFF
C Called by: GUIFIX 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file:
C
      INCLUDE 'FIXPAR.COM'
C
C Arguments:
C
      REAL DMIN,DMAX
C
C Local variables:
C     
      REAL DELR,DELZ,X(4),Y(4)
      INTEGER I,J,N,NREF
C
C-----------------------------------------------------------------------
      IF(.NOT.GOTWAV)THEN
         WRITE(IPRINT,1000)
         CALL FLUSH(IPRINT)
      ELSEIF(.NOT.GOTSDD)THEN
         WRITE(IPRINT,1010)
         CALL FLUSH(IPRINT)
      ELSEIF(.NOT.GOTCEN)THEN
         WRITE(IPRINT,1020)
         CALL FLUSH(IPRINT) 
      ELSEIF(.NOT.GOTROT)THEN
         WRITE(IPRINT,1030)
         CALL FLUSH(IPRINT) 
      ELSEIF(.NOT.GOTTIL)THEN
         WRITE(IPRINT,1040)
         CALL FLUSH(IPRINT) 
      ELSE
C
C========Calculate DELR, DELZ
C
         DELR = 1.0/(WAVE*SDD)
         DELZ = DELR
C
C========Calculate (h,k,l) and (D,R,Z) for each reflection out to DMAX
C
         WRITE(IPRINT,'(A)')'203 Generating lattice points...'
         CALL FLUSH(IPRINT)
         CALL DRAGON(CELL,.FALSE.,PHIZ,PHIX,SPCGRP,DMAX,DELR,DELZ,IHKL,
     &               DRZ,MAXREF,NREF)
C
C========Convert to file coordinates and draw for spots in range
C
         WRITE(IPRINT,1050)
         WRITE(IPRINT,'(A,F7.2,1X,F7.2)')'500 DRAW POINT ',XC,YC
         CALL FLUSH(IPRINT)
         DO 20 I=1,NREF
            IF(DRZ(1,I).GT.DMIN)THEN
               CALL RECTOFF(DRZ(2,I),DRZ(3,I),X,Y,N)
               IF(LATPNT)THEN
                  DO 10 J=1,4
                     WRITE(IPRINT,'(A,2(1X,F7.2))')'500 DRAW POINT',
     &                    X(J)+XC,Y(J)+YC
                     CALL FLUSH(IPRINT)
                     WRITE(ILOG,'(A,2(1X,F7.2))')'500 DRAW POINT',
     &                    X(J)+XC,Y(J)+YC
                     CALL FLUSH(IPRINT)
 10               CONTINUE
               ELSE
                  WRITE(IPRINT,'(A,3(1X,F7.2))')'500 DRAW RING',
     &                 XC,YC,SDD*TAN(2.0*ASIN(WAVE*DRZ(1,I)/2.0))
                  CALL FLUSH(IPRINT)
                  WRITE(ILOG,'(A,3(1X,F7.2))')'500 DRAW RING',
     &                 XC,YC,SDD*TAN(2.0*ASIN(WAVE*DRZ(1,I)/2.0))
               ENDIF                     
               WRITE(IPRINT,1060)(IHKL(J,I),J=1,3),(DRZ(J,I),J=1,3),
     &              (X(J)+XC,Y(J)+YC,J=1,4)
               CALL FLUSH(IPRINT)
               WRITE(ILOG,1060)(IHKL(J,I),J=1,3),(DRZ(J,I),J=1,3),
     &              (X(J)+XC,Y(J)+YC,J=1,4)
            ENDIF
 20      CONTINUE
         WRITE(IPRINT,'(A)')'204 Finished generating lattice points'
         CALL FLUSH(IPRINT)
         WRITE(ILOG,'(A)')'204 Finished generating lattice points'
      ENDIF
C
      RETURN
 1000 FORMAT(1X,'300 No wavelength!')
 1010 FORMAT(1X,'300 No specimen-to-detector distance!')
 1020 FORMAT(1X,'300 No centre coordinates!')
 1030 FORMAT(1X,'300 No rotation angle!')
 1040 FORMAT(1X,'300 No tilt angle!')
 1050 FORMAT(1X,'200',
     &       4X,'h',4X,'k',4X,'l',7X,'D',10X,'R',10X,'Z',6X,
     &       6X,'x1',6X,'y1',6X,'x2',6X,'y2',
     &       6X,'x3',6X,'y3',6X,'x4',6X,'y4')
 1060 FORMAT(1X,'200',
     &       1X,I4,1X,I4,1X,I4,4X,3(1X,G10.4),8(2X,F6.1))
      END                  



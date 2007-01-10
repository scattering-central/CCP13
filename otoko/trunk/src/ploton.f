C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE PLOTON
      IMPLICIT NONE
C
C Purpose: Switch graphics on first time only.
C
      COMMON /MYGRAF/ OPENGR
      LOGICAL         OPENGR
C
C-----------------------------------------------------------------------
      IF (.NOT.OPENGR) THEN
         OPENGR=.TRUE.
         CALL GRMODE
         CALL PAPER(1)
         CALL GPSTOP (-1)
         CALL FILON
      ENDIF
      RETURN
      END

C     LAST UPDATE 26/07/91
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      CHARACTER FUNCTION EOFCHAR ()
      IMPLICIT NONE
C
C PURPOSE: Return the end of file character 'Z' for VMS, 'D' for unix
C
C----------------------------------------------------------------------
      EOFCHAR = 'D'
      RETURN
      END



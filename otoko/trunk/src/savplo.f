C     LAST UPDATE 16/03/89
C++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SAVPLO (ITERM,IPRINT)
      IMPLICIT NONE
C
C Purpose: Save a series of plots in a gridfile and terminate plotting.
C
      INTEGER ITERM,IPRINT
C
C ITERM  :
C IPRINT :
C
C Calls   3: ASKNO  , GRMODE , TRMODE
C Ghost   2: ERASE  , PICSAV
C Called by: PLOT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER   IRC
      CHARACTER PLOFIL*80,NAMPIC*16
      LOGICAL   COPY,ASKNO,IGETS
C
C PLOFIL : Plot file name
C NAMPIC : Picture name
C IRC    : Return code
C COPY   : True if no hard copy required
C
C-----------------------------------------------------------------------
C
C========ASK IF HARD COPY REQUIRED
C
      WRITE (IPRINT,1000)
      COPY=ASKNO (ITERM,IRC)
      IF (IRC.EQ.0) THEN
         IF (.NOT.COPY) THEN
C
C========GET PLOT FILE NAME
C
            WRITE (IPRINT,1010)
            IF (IGETS (ITERM,PLOFIL)) THEN
C
C========GET PICTURE NAME
C
               NAMPIC=' '
               WRITE (IPRINT,1020)
               IF (IGETS (ITERM,NAMPIC)) THEN
C
C========SAVE PICTURE AND DELETE SCRATCH FILE
C
                  CALL GRMODE
                  CALL ERASE
                  CALL PICSAV(PLOFIL,NAMPIC)
                  call trmode
               ENDIF
            ENDIF
         ENDIF
      ENDIF
cx      CALL GREND
      RETURN
C
1000  FORMAT (' Do you want hard copy [Y/N] [N]: ',$)
1010  FORMAT (' Enter plot file name: ',$)
1020  FORMAT (' Enter picture name or <return>: ',$)
      END

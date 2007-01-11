C     LAST UPDATE 28/03/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE REVDAT(TITLE2,XBR,NPIX,NRAST,IFRAME,KPIC)
      IMPLICIT NONE
C
C Purpose: Outputs 2d array in BSL format.
C
C
C Calls   3: OUTFIL , OPNNEW , WFRAME
C Called by: RECOUT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C
C Scalar Arguments:
C
      INTEGER NPIX,NRAST,IFRAME,KPIC
      CHARACTER TITLE2*(*)
C
C Array Arguments:
C
      REAL XBR(*)
C
C Local Scalars:
C
      INTEGER MEM,IRC
C
C Local Character Strings:
C
      CHARACTER*80 TITLE1,LINE2
      CHARACTER*30 FNAME
C
C Scalars in Common:
C
      INTEGER INDATA,INTERM,OUTDATA,OUTTERM
C
C Common blocks:
C
      COMMON /STREAMS/ INTERM,OUTTERM,INDATA,OUTDATA
C
C-----------------------------------------------------------------------
      MEM = 1
C
      IF(KPIC.EQ.1)THEN
         CALL OUTFIL(INTERM,OUTTERM,FNAME,TITLE1,LINE2,IRC)
         IF(IRC.NE.0)THEN
            WRITE(OUTTERM,1010)
            RETURN
         ENDIF
         WRITE(8,1040)FNAME,TITLE1,TITLE2
         CALL OPNNEW(OUTDATA,NPIX,NRAST,IFRAME,FNAME,MEM,TITLE1,TITLE2,
     &               IRC)
         IF(IRC.NE.0)THEN
            WRITE(OUTTERM,1020)
            RETURN
         ENDIF
      ENDIF
      CALL WFRAME(OUTDATA,KPIC,NPIX,NRAST,XBR,IRC)
      IF(IRC.NE.0)WRITE(OUTTERM,1030)
      RETURN
C
 1010 FORMAT(1X,'ERROR DURING READ')
 1020 FORMAT(1X,'ERROR WRITNG HEADER')
 1030 FORMAT(1X,'ERROR WRITNG DATA FILE')
 1040 FORMAT(1X,'Header filename: ',A/1X,'Header 1: ',A/1X,'Header 2: ',
     &       A)
      END

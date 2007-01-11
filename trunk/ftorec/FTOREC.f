C     LAST UPDATE 28/03/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      PROGRAM FTOREC
      IMPLICIT NONE
C
C Purpose: Converts data from image space to reciprocal space
C
C Calls  10: WRDLEN , PARINP , GETHDR , OPNFIL , IMSIZE , SETUP ,
C            FILARR , ARRFIL , RECOUT , FCLOSE
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C
C Common arrays:
C
      REAL RDAT(2500*2500),RECSPA(1250*1250),STDEV(1250*1250),PHI(3,3)
      INTEGER NPOINT(1250*1250)
C
C Common scalars:
C
      REAL DIST,XC,YC,ROTX,ROTY,ROTZ,TILT,WAVE,XYRAT
      REAL DMIN,DMAX,SIGMIN,SIGMAX,RMIN,RMAX,ZMIN,ZMAX,RBAK,ZBAK
      REAL DELR,DELZ,DELSIG,DELD      
      REAL RMAXOPT
      REAL ABSBAS,ABSEML,ABSPAP,C0,PAPN,FILN
      INTEGER NFBEFR,NPBEFR
      INTEGER NXMIN,NXMAX,NYMIN,NYMAX,NRD,NZSIG
      INTEGER INTERM,OUTTERM,INDATA,OUTDATA
      LOGICAL DODSIG,NSTDEV,OTINP,INTERP
C
C Local scalars:
C
      INTEGER IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,I,J
      INTEGER ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,KPIC
      INTEGER IFPIX,ILPIX,IFRAST,ILRAST,IRL,LWORD
      CHARACTER*30 HDRFNAM
C
C Common blocks:
C
      COMMON /ARRAYS/ RDAT,RECSPA,STDEV,NPOINT
      COMMON /ORIENT/ PHI
      COMMON /TRANSF/ DIST,XC,YC,ROTX,ROTY,ROTZ,TILT,WAVE,XYRAT
      COMMON /RLIMIT/ DMIN,DMAX,SIGMIN,SIGMAX,RMIN,RMAX,ZMIN,ZMAX,
     &                RBAK,ZBAK
      COMMON /DELTAS/ DELR,DELZ,DELSIG,DELD
      COMMON /MAXOPT/ RMAXOPT
      COMMON /FILMAB/ ABSBAS,ABSEML,ABSPAP,NFBEFR,NPBEFR,C0,PAPN,FILN
      COMMON /ILIMIT/ NXMIN,NXMAX,NYMIN,NYMAX,NRD,NZSIG
      COMMON /STREAM/ INTERM,OUTTERM,INDATA,OUTDATA
      COMMON /LOGICS/ DODSIG,NSTDEV,OTINP,INTERP
C
C-----------------------------------------------------------------------
      WRITE(6,1000)
C
C========Get machine word length
C
      CALL WRDLEN(LWORD)
C
C========Get input parameters
C
      CALL PARINP
C
C========Get header filename
C
 10   KPIC = 0
      CALL GETHDR(INTERM,OUTTERM,INDATA,HDRFNAM,ISPEC,LSPEC,INCR,MEM,
     &            IFFR,ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF(IRC.NE.0)STOP ' USER STOP'
      IFRAME = IHFMAX + IFRMAX - 1
      WRITE(8,1010)HDRFNAM
      WRITE(8,1020)IFFR,ILFR,IFINC
C
      CALL IMSIZE(INTERM,OUTTERM,NPIX,NRAST,IFPIX,ILPIX,IFRAST,ILRAST,
     &            IRC)
      IF(IRC.NE.0)GOTO 10
      WRITE(8,1030)IFPIX,ILPIX,IFRAST,ILRAST
      NXMIN = IFPIX
      NYMIN = IFRAST
      NXMAX = ILPIX
      NYMAX = ILRAST
C
      DO 30 I=1,IHFMAX
         IF(OTINP)THEN
C
C========Open optical density file
C
            IRL = NPIX/LWORD
            HDRFNAM(6:6) = '1'
            OPEN(UNIT=INDATA,FILE=HDRFNAM,STATUS='OLD',ACCESS='DIRECT',
     &           FORM='UNFORMATTED',RECL=IRL)
         ELSE
C
C========Open BSL file
C
            CALL OPNFIL(INDATA,HDRFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                  NFRAME,IRC)
            IF(IRC.NE.0)STOP 'FTOREC: Error - opening binary file'
         ENDIF 
         DO 20 J = 1,IFRMAX
C
C========Initialise arrays and set up orientation matrix
C
            CALL SETUP
C
C========Either interpolate or average to get reciprocal space image
C
            IF(INTERP)THEN
               CALL ARRFIL(IFFR,IFINC,NPIX,NRAST,IFPIX,ILPIX,IFRAST,
     &                     ILRAST,KPIC)
            ELSE
               CALL FILARR(IFFR,IFINC,NPIX,NRAST,IFPIX,ILPIX,IFRAST,
     &                     ILRAST,KPIC)
            ENDIF
C
C========Output remapped image
C
            CALL RECOUT(NPIX,NRAST,IFRAME,KPIC)
 20      CONTINUE
 30   CONTINUE
      CALL FCLOSE(INDATA)
      CALL FCLOSE(OUTDATA)
      STOP ' Normal stop'
C
 1000 FORMAT(1X,'FTOREC - Image to reciprocal space remapping program'/
     &       1X,'Last update 12/04/99')
 1010 FORMAT(1X,'Header filename: ',A30)
 1020 FORMAT(1X,'First frame ',I4,'  Last frame ',I4,'  Incr. ',I4)
 1030 FORMAT(1X,'First pix.  ',I4,'  Last pix.  ',I4,/1X,'First rast. ',
     &       I4,'  Last rast. ',I4)
      END

      BLOCK DATA
      INTEGER INTERM,OUTTERM,INDATA,OUTDATA
      COMMON /STREAMS/ INTERM,OUTTERM,INDATA,OUTDATA
      DATA INTERM /5/, OUTTERM /6/, INDATA /2/, OUTDATA /1/
      END

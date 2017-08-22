C     LAST UPDATE 16/05/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE RECOUT(NPIX,NRAST,IFRAME,KPIC)
      IMPLICIT NONE
C
C Purpose: Performs averaging and output 
C
C Calls   1: REVDAT
C Called by: FTOREC
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C
C Common arrays:
C
      REAL RDAT(2500*2500),RECSPA(1250*1250),STDEV(1250*1250)
      INTEGER NPOINT(1250*1250)
C
C Common scalars:
C
      REAL DMIN,DMAX,SIGMIN,SIGMAX,RMIN,RMAX,ZMIN,ZMAX,RBAK,ZBAK
      REAL DELR,DELZ,DELSIG,DELD      
      INTEGER NXMIN,NXMAX,NYMIN,NYMAX,NRD,NZSIG
      INTEGER INTERM,OUTTERM,INDATA,OUTDATA
      LOGICAL DODSIG,NSTDEV,OTINP,INTERP
C
C Scalar arguments:
C
      INTEGER NPIX,NRAST,IFRAME,KPIC
C
C Local Scalars:
C
      REAL DIVN
      INTEGER IRD,IZSIG,IN
      CHARACTER*80 TITLE2
C
C Common blocks:
C
      COMMON /ARRAYS/ RDAT,RECSPA,STDEV,NPOINT
      COMMON /RLIMIT/ DMIN,DMAX,SIGMIN,SIGMAX,RMIN,RMAX,ZMIN,ZMAX,
     &                RBAK,ZBAK
      COMMON /DELTAS/ DELR,DELZ,DELSIG,DELD
      COMMON /ILIMIT/ NXMIN,NXMAX,NYMIN,NYMAX,NRD,NZSIG
      COMMON /STREAM/ INTERM,OUTTERM,INDATA,OUTDATA
      COMMON /LOGICS/ DODSIG,NSTDEV,OTINP,INTERP
C
C-----------------------------------------------------------------------
      DO 20 IZSIG=1,NZSIG
         DO 10 IRD=1,NRD
            IN = (IZSIG-1)*NRD + IRD
            IF(NPOINT(IN).EQ.0)THEN
C
C========Use convention of SD=-1 for empty (or all saturated) bins.
C
               STDEV(IN) = -1.0
               RECSPA(IN) = -1.0E+30
               GOTO 10
            ENDIF
C
            DIVN = FLOAT(NPOINT(IN))
            STDEV(IN) = STDEV(IN) - RECSPA(IN)*RECSPA(IN)/DIVN
            RECSPA(IN) = RECSPA(IN)/DIVN
C
            IF(NPOINT(IN).EQ.1)THEN
               STDEV(IN) = 0.0
            ELSE
               IF(STDEV(IN).LT.0.0)STDEV(IN) = 0.0
               STDEV(IN) = SQRT(STDEV(IN)/(DIVN-1.0))
            ENDIF
 10      CONTINUE
 20   CONTINUE
C
      IF(DODSIG)THEN
         WRITE(TITLE2,1030)NRD,DELD,DMIN,NZSIG,DELSIG,SIGMIN
      ELSE
         WRITE(TITLE2,1040)NRD,DELR,RMIN,NZSIG,DELZ,ZMIN
      ENDIF
C
      WRITE(6,1010)
      WRITE(8,1010)
      CALL REVDAT(TITLE2,RECSPA,NRD,NZSIG,IFRAME,KPIC)
      IF(NSTDEV)THEN
         IF(DODSIG)THEN
            WRITE(TITLE2,1050)NRD,DELD,DMIN,NZSIG,DELSIG,SIGMIN
         ELSE
            WRITE(TITLE2,1060)NRD,DELR,RMIN,NZSIG,DELZ,ZMIN
         ENDIF
C
         WRITE(6,1020)
         WRITE(8,1020)
         CALL REVDAT(TITLE2,STDEV,NRD,NZSIG,IFRAME,KPIC)
      ENDIF
C
      RETURN
 1010 FORMAT(/1X,'Transformed image file')
 1020 FORMAT(/1X,'Standard deviation file')
 1030 FORMAT(2X,'POLAR IMAGE ',I5,2G12.5,I5,2G12.5,8X)
 1040 FORMAT(2X,'CARTN IMAGE ',I5,2G12.5,I5,2G12.5,8X)
 1050 FORMAT(2X,'POLAR ESDS  ',I5,2G12.5,I5,2G12.5,8X)
 1060 FORMAT(2X,'CARTN ESDS  ',I5,2G12.5,I5,2G12.5,8X)
      END

C     LAST UPDATE 28/03/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FILARR(IFFR,IFINC,NPIX,NRAST,IFPIX,ILPIX,IFRAST,ILRAST,
     &                  KPIC)
      IMPLICIT NONE
C
C Purpose: Loop over data points filling in reciprocal
C          space array and npoint array
C
C Calls    :
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
      REAL DIST,XC,YC,ROTX,ROTY,ROTZ,TILT,WAVE,XYRAT
      REAL DMIN,DMAX,SIGMIN,SIGMAX,RMIN,RMAX,ZMIN,ZMAX,RBAK,ZBAK
      REAL DELR,DELZ,DELSIG,DELD      
      REAL RMAXOPT
      INTEGER NXMIN,NXMAX,NYMIN,NYMAX,NRD,NZSIG
      INTEGER INTERM,OUTTERM,INDATA,OUTDATA
      LOGICAL DODSIG,NSTDEV,OTINP,INTERP
C
C Scalar arguments
C
      INTEGER IFFR,IFINC,NRAST,NPIX,IFRAST,ILRAST,IFPIX,ILPIX,KPIC
C 
C Local Scalars:
C
      REAL D,R,SIGMA,UU,VV,Z,TEMP
      INTEGER ID,IR,ISIG,IZ,IN,IFTMP,IX,IY,IRC
      INTEGER NMPTS,N0PTS,NLDPTS,NGDPTS,NOUTR,NOUTZ
C
C External function:
C
      REAL CORTAB
      EXTERNAL CORTAB
C
C Local Arrays:
C
      CHARACTER LDAT(4096)
C
C Common blocks:
C
      COMMON /ARRAYS/ RDAT,RECSPA,STDEV,NPOINT
      COMMON /TRANSF/ DIST,XC,YC,ROTX,ROTY,ROTZ,TILT,WAVE,XYRAT
      COMMON /RLIMIT/ DMIN,DMAX,SIGMIN,SIGMAX,RMIN,RMAX,ZMIN,ZMAX,
     &                RBAK,ZBAK
      COMMON /DELTAS/ DELR,DELZ,DELSIG,DELD
      COMMON /MAXOPT/ RMAXOPT
      COMMON /ILIMIT/ NXMIN,NXMAX,NYMIN,NYMAX,NRD,NZSIG
      COMMON /STREAM/ INTERM,OUTTERM,INDATA,OUTDATA
      COMMON /LOGICS/ DODSIG,NSTDEV,OTINP,INTERP
C
C-----------------------------------------------------------------------
C 
      NMPTS = 0
      N0PTS = 0
      NLDPTS = 0
      NGDPTS = 0
      NOUTR = 0
      NOUTZ = 0
C
      DO 30 IY=IFRAST,ILRAST
         IF(OTINP)THEN
            READ(INDATA,REC=IY)(LDAT(IX),IX=1,NPIX)
            DO 10 IX = 1,NPIX
               RDAT(IX) = FLOAT(ICHAR(LDAT(IX)))
 10         CONTINUE
         ELSE
            IFTMP = (IFFR-1)*NRAST + IY
            CALL RFRAME(INDATA,IFTMP,NPIX,1,RDAT,IRC)
            IF(IRC.NE.0)STOP 'FILARR: Error - reading binary file'
         ENDIF
C
         DO 20 IX=IFPIX,ILPIX
C
            IF(RDAT(IX).GT.RMAXOPT)THEN
               NMPTS = NMPTS + 1
               GOTO 20
            ENDIF
C
            IF(RDAT(IX).EQ.0.0)THEN
               N0PTS = N0PTS + 1
               GOTO 20
            ENDIF
C
            UU = XYRAT*(FLOAT(IX)-XC-0.5)
            VV = FLOAT(IY) - YC - 0.5
            CALL RECIP(UU,VV,R,Z,D,SIGMA)
C
            IF(D.LT.DMIN)THEN
               NLDPTS = NLDPTS + 1
               GOTO 20
            ENDIF
C
            IF(ABS(R).LT.RBAK.AND.ABS(Z).LT.ZBAK)THEN
               NLDPTS = NLDPTS + 1
               GOTO 20
            ENDIF
C
            IF(D.GT.DMAX)THEN
               NGDPTS = NGDPTS + 1
               GOTO 20
            ENDIF
C
            IF(DODSIG)THEN
               ID = NINT((D-DMIN)/DELD)
               IF(ID.LE.0 .OR. ID.GT.NRD)THEN
                  NOUTR = NOUTR + 1
                  GOTO 20
               ENDIF
C
               ISIG = NINT((SIGMA-SIGMIN)/DELSIG)
               IF(ISIG.LE.0 .OR. ISIG.GT.NZSIG)THEN
                  NOUTZ = NOUTZ + 1
                  GOTO 20
               ENDIF
C
               IN = (ISIG-1)*NRD + ID
               TEMP = RDAT(IX)*CORTAB(D,UU,VV)
               STDEV(IN) = STDEV(IN) + TEMP*TEMP
               RECSPA(IN) = RECSPA(IN) + TEMP
               NPOINT(IN) = NPOINT(IN) + 1
C
            ELSE
               IR = NINT((R-RMIN)/DELR)
               IF(IR.LE.0 .OR. IR.GT.NRD)THEN
                  NOUTR = NOUTR + 1
                  GOTO 20
               ENDIF
C
 
               IZ = NINT((Z-ZMIN)/DELZ)
               IF(IZ.LE.0 .OR. IZ.GT.NZSIG)THEN
                  NOUTZ = NOUTZ + 1
                  GOTO 20
               ENDIF
C
               IN = (IZ-1)*NRD + IR
               TEMP = RDAT(IX)*CORTAB(D,UU,VV)
               STDEV(IN) = STDEV(IN) + TEMP*TEMP
               RECSPA(IN) = RECSPA(IN) + TEMP
               NPOINT(IN) = NPOINT(IN) + 1
            ENDIF
C
 20      CONTINUE
 30   CONTINUE
      WRITE(8,1010)NMPTS + N0PTS + NLDPTS + NGDPTS + NOUTR + NOUTZ
      WRITE(8,1020)NMPTS
      WRITE(8,1030)N0PTS
      WRITE(8,1040)NLDPTS
      WRITE(8,1050)NGDPTS
      WRITE(8,1060)NOUTR
      WRITE(8,1070)NOUTZ
      KPIC = KPIC + 1
      IFFR = IFFR + IFINC
      RETURN
C
 1010 FORMAT(/1X,'Points rejected from transformation: ',I8)
 1020 FORMAT(1X,'Points greater then MAXOPT: ',I8)
 1030 FORMAT(1X,'Points equal to zero      : ',I8)
 1040 FORMAT(1X,'Points less than DMIN     : ',I8)
 1050 FORMAT(1X,'Points greater than DMAX  : ',I8)
 1060 FORMAT(1X,'Points outside R or D bins: ',I8)
 1070 FORMAT(1X,'Points outside Z or S bins: ',I8/)
 
      END

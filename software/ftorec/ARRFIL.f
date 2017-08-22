C     LAST UPDATE 28/03/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE ARRFIL(IFFR,IFINC,NPIX,NRAST,IFPIX,ILPIX,IFRAST,ILRAST,
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
C Scalar arguments:
C
      INTEGER IFFR,IFINC,NRAST,NPIX,IFRAST,ILRAST,IFPIX,ILPIX,KPIC
C
C Local Scalars:
C
      REAL D,RD,ZSIG,RECVAL,RECVAL2,DX,DY,X,Y,RECTMP,R,Z
      INTEGER IRD,IZSIG,IM1,IM2,IM3,IM4,IRC,NP,I,IN,ICOUNT,IX,IY
      INTEGER NMPTS,N0PTS,NLDPTS,NGDPTS,NOFSPH,NOFIMG
C
C External function:
C
      REAL CORTAB
      EXTERNAL CORTAB
C
C Local Arrays:
C
      REAL U(4),V(4)
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
      NMPTS = 0
      N0PTS = 0
      NLDPTS = 0
      NGDPTS = 0
      NOFSPH = 0
      NOFIMG = 0
C
      CALL RFRAME(INDATA,IFFR,NPIX,NRAST,RDAT,IRC)
      IF(IRC.NE.0)STOP 'ARRFIL: Error - reading binary file'
      KPIC = KPIC + 1
      IFFR = IFFR + IFINC
      DO 30 IZSIG = 1,NZSIG
         IF(DODSIG)THEN
            ZSIG = FLOAT(IZSIG)*DELSIG + SIGMIN
         ELSE
            ZSIG = FLOAT(IZSIG)*DELZ + ZMIN
         ENDIF
C
         DO 20 IRD = 1,NRD
            IF(DODSIG)THEN
               RD = FLOAT(IRD)*DELD + DMIN
            ELSE
               RD = FLOAT(IRD)*DELR + RMIN
            ENDIF
            IN = (IZSIG-1)*NRD + IRD
C
            ICOUNT = 0
            RECVAL = 0.0
            RECVAL2 = 0.0
            CALL RECTOFF(RD,ZSIG,U,V,NP)
            IF(NP.GT.0)THEN
C
               IF(DODSIG)THEN
                  D = RD
                  R = D*SIN(ZSIG)
                  Z = D*COS(ZSIG)
               ELSE
                  D = SQRT(RD*RD+ZSIG*ZSIG)
                  R = RD
                  Z = ZSIG
               ENDIF
C
               NP = 0
               DO 10 I = 1,4
                  IF(U(I).NE.0.0 .OR. V(I).NE.0.0)THEN
                     X = U(I)/XYRAT + XC + 0.5
                     Y = V(I) + YC + 0.5
                     IX = INT(X)
                     IY = INT(Y)
                     DX = X - FLOAT(IX)
                     DY = Y - FLOAT(IY)
                     IF((IX.GE.IFPIX.AND.IX.LT.ILPIX) .AND. 
     &                  (IY.GE.IFRAST.AND.IY.LT.ILRAST))THEN
                        IM1 = NPIX*(IY-1) + IX
                        IM2 = IM1 + 1
                        IM3 = IM1 + NPIX
                        IM4 = IM3 + 1
                        RECTMP = (1.-DX)*(1.-DY)*RDAT(IM1)
     &                              + DX*(1.-DY)*RDAT(IM2)
     &                              + (1.-DX)*DY*RDAT(IM3)
     &                              +      DX*DY*RDAT(IM4)
                        RECTMP = RECTMP*CORTAB(D,U(I),V(I))
                        ICOUNT = ICOUNT + 1
                     ENDIF
                  ENDIF
C
                  IF(RECTMP.GT.RMAXOPT)THEN
                     NMPTS = NMPTS + 1
                  ELSEIF(RECTMP.LE.0.0)THEN
                     N0PTS = N0PTS + 1
                  ELSE
                     NP = NP + 1
                     RECVAL = RECVAL + RECTMP
                     RECVAL2 = RECVAL2 + RECTMP*RECTMP
                  ENDIF
C
 10            CONTINUE
C
               IF(D.LT.DMIN)THEN
                  NLDPTS = NLDPTS + 1
               ELSEIF(ABS(R).LT.RBAK.AND.ABS(Z).LT.ZBAK)THEN
                  NLDPTS = NLDPTS + 1
               ELSEIF(D.GT.DMAX)THEN
                  NGDPTS = NGDPTS + 1
               ELSEIF(ICOUNT.EQ.0)THEN
                  NPOINT(IN) = 0
               ELSE
                  STDEV(IN) = RECVAL2
                  RECSPA(IN) = RECVAL
                  NPOINT(IN) = NP
               ENDIF
            ELSE
               NOFSPH = NOFSPH + 1
            ENDIF
C
 20      CONTINUE
 30   CONTINUE
      WRITE(8,1010)NMPTS + N0PTS + NOFIMG
      WRITE(8,1020)NMPTS
      WRITE(8,1030)N0PTS
      WRITE(8,1040)NOFIMG
      WRITE(8,1050)NLDPTS + NGDPTS + NOFSPH
      WRITE(8,1060)NLDPTS
      WRITE(8,1070)NGDPTS
      WRITE(8,1080)NOFSPH
      RETURN
C
 1010 FORMAT(/1X,'Points rejected from image space: ',I8)
 1020 FORMAT(1X,'Points greater then MAXOPT: ',I8)
 1030 FORMAT(1X,'Points equal to zero      : ',I8)
 1040 FORMAT(1X,'Points out of range       : ',I8)
 1050 FORMAT(/1X,'Points rejected from reciprocal space: ',I8)
 1060 FORMAT(1X,'Points less than DMIN     : ',I8)
 1070 FORMAT(1X,'Points greater than DMAX  : ',I8)
 1080 FORMAT(1X,'Points off Ewald sphere   : ',I8/)
C
      END

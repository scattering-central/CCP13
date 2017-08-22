C     LAST UPDATE 10/12/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE REFALL(LOCBUF,XPTS,YPTS)
      IMPLICIT NONE
C
C Purpose: Refines centre, rotation, tilt and specimen-to-detector 
C          distance for fibre patterns (EBUF argument for mmap version 
C          only)
C
C Calls   4: FREPLX , ASK , RECIP , IMAGE
C Called by: FIX
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INCLUDE 'FIXPAR.COM'
C
C Arguments: 
C
      INTEGER*4 LOCBUF
      REAL XPTS(MAXVERT),YPTS(MAXVERT)
C
C Local variables:
C
      INTEGER I,MAXITS,ITMAX,IFLAG
      REAL FTOL,ATOL,FRET,FMIN,RTOD,XCOLD,YCOLD,RTXOLD,RTYOLD,RTZOLD,
     &     TILOLD
      REAL U,V,R,Z,RMAX,ZMAX,UMIN,UMAX,VMIN,VMAX
      LOGICAL GOTALL,REPLY,REFCEN,REFRTX,REFRTY,REFRTZ,REFTIL
c      real fmin, twist
C
C Local arrays:
C
      REAL PR(10),PINC(10)
C
C External function:
C
      REAL WRAPRP
      EXTERNAL WRAPRP
C
C Common block variables:
C
      INTEGER IBOX,JBOX
      REAL RMIN,DELR,ZMIN,DELZ
C
C Common blocks:
C
      COMMON /REFINE/ IBOX,JBOX,RMIN,DELR,ZMIN,DELZ
C
C This is for mmap version
C
      INTEGER*4 LBUF
      COMMON /DITTO / LBUF
C
C Data:
C 
      DATA FMIN /1.0/, RTOD /57.2957795/, FTOL /0.001/, ATOL /0.0/
      DATA ITMAX /10/ , MAXITS /5/
C
C-----------------------------------------------------------------------
C
      LBUF = LOCBUF
C
C========Save initial values
C
      XCOLD = XC
      YCOLD = YC
      RTXOLD = ROTX
      RTYOLD = ROTY
      RTZOLD = ROTZ
      TILOLD = TILT
C
C=======Check that we have the necessary starting parameters
C
      GOTALL = .TRUE.
      REFCEN = .TRUE.
      REFRTX = .TRUE.
      REFRTY = .TRUE.
      REFRTZ = .TRUE.
      REFTIL = .TRUE.
      IF(.NOT.GOTWAV)THEN
         WRITE(6,1000)
         CALL FLUSH(6)
         GOTALL = .FALSE.
      ENDIF
      IF(.NOT.GOTSDD)THEN
         WRITE(6,1010)
         CALL FLUSH(6)
         GOTALL = .FALSE.
      ENDIF
      IF(.NOT.GOTCEN)THEN
         WRITE(6,1020)
         CALL FLUSH(6)
         GOTALL = .FALSE.
      ELSE
         PR(1) = XC
         PR(2) = YC
         REPLY = .FALSE.
         CALL ASK('708 Refine detector centre',REPLY,0)
         IF(REPLY)THEN
            PINC(1) = FMIN
            PINC(2) = FMIN
         ELSE
            PINC(1) = 0.0
            PINC(2) = 0.0
            REFCEN = .FALSE.
         ENDIF
      ENDIF
      IF(.NOT.GOTROT)THEN
         WRITE(6,1030)
         CALL FLUSH(6)
         GOTALL = .FALSE.
      ELSE
         PR(3) = ROTX
         PR(4) = ROTY
         PR(5) = ROTZ
         REPLY = .FALSE.
         CALL ASK('709 Refine detector rotation',REPLY,0)
         IF(REPLY)THEN
            PINC(3) = FMIN/RTOD
         ELSE
            PINC(3) = 0.0
            REFRTX = .FALSE.
         ENDIF
         REPLY = .FALSE.
         CALL ASK('710 Refine detector twist',REPLY,0)
         IF(REPLY)THEN
            PINC(4) = FMIN/SDD
            IF(.NOT.REFCEN)THEN
               WRITE(6,1035)
               CALL FLUSH(6)
            ENDIF
         ELSE
            PINC(4) = 0.0
            REFRTY = .FALSE.
         ENDIF
         REPLY = .FALSE.
         CALL ASK('711 Refine detector tilt',REPLY,0)
         IF(REPLY)THEN
            PINC(5) = FMIN/SDD
            IF(.NOT.REFCEN)THEN
               WRITE(6,1035)
               CALL FLUSH(6)
            ENDIF
         ELSE
            PINC(5) = 0.0
            REFRTZ = .FALSE.
         ENDIF
      ENDIF
      IF(.NOT.GOTTIL)THEN
         WRITE(6,1040)
         CALL FLUSH(6)
         GOTALL = .FALSE.
      ELSE
         PR(6) = TILT
         REPLY = .FALSE.
         CALL ASK('712 Refine specimen tilt',REPLY,0)
         IF(REPLY)THEN
            PINC(6) = FMIN/RTOD
         ELSE
            PINC(6) = 0.0
            REFTIL = .FALSE.
         ENDIF
      ENDIF
      IF(GOTALL)THEN
C
C========Get image and reciprocal space limits
C
         RMIN = 1.0
         RMAX = 0.0
         ZMIN = 1.0
         ZMAX = 0.0
         UMIN = 1.0E+06
         UMAX = 0.0
         VMIN = 1.0E+06
         VMAX = 0.0
         DO 5 I=1,4
            U = XPTS(I)
            V = YPTS(I)
            U = U - XC + 0.5
            V = V - YC + 0.5
            IF(ABS(U).LT.UMIN)UMIN = ABS(U)
            IF(ABS(U).GT.UMAX)UMAX = ABS(U)
            IF(ABS(V).LT.VMIN)VMIN = ABS(V)
            IF(ABS(V).GT.VMAX)VMAX = ABS(V)
            CALL RECIP(U,V,R,Z)
            IF(ABS(R).LT.RMIN)RMIN = ABS(R)
            IF(ABS(R).GT.RMAX)RMAX = ABS(R)
            IF(ABS(Z).LT.ZMIN)ZMIN = ABS(Z)
            IF(ABS(Z).GT.ZMAX)ZMAX = ABS(Z)
 5       CONTINUE
         DELR = (RMAX-RMIN)**2 + (ZMAX-ZMIN)**2
         DELZ = (UMAX-UMIN)**2 + (VMAX-VMIN)**2
         DELR = SQRT(DELR/DELZ)
         DELZ = DELR
         IBOX = INT((RMAX-RMIN)/DELR)
         JBOX = INT((ZMAX-ZMIN)/DELZ)
         WRITE(6,1045)RMIN,RMAX,IBOX,ZMIN,ZMAX,JBOX
         WRITE(6,1080)
         CALL FLUSH(6)
C
C========Do the refinement using replex method
C
c         fmin = WRAPRP(pr)
c         twist = pr(4)
c         do i=1,1200
c            pr(4) = pr(4) + atan(1.0)/900.0
c            pr(1) = 233.5 - sdd*tan(pr(4))
c            fret = WRAPRP(pr)
c            if(fret.lt.fmin)then
c               fmin = fret
c               twist = pr(4)
c            endif
c            print *, i,pr(4)*57.296,fret,twist*57.296,fmin
c         enddo
c         pr(1) = 233.5 - sdd*tan(twist)
c         pr(4) = twist
c         print *, (pr(i), i=1,6)
         CALL FREPLX(PR,PINC,6,WRAPRP,ITMAX,MAXITS,FTOL,ATOL,FRET,IFLAG)
         CALL FLUSH(6)
         WRITE(6,1090)
         CALL FLUSH(6)
         IF(IFLAG.EQ.1)THEN
            WRITE(6,2000)FTOL
         ELSEIF(IFLAG.EQ.2)THEN
            WRITE(6,2010)ATOL
         ELSEIF(IFLAG.EQ.3)THEN
            WRITE(6,2020)
         ENDIF
         WRITE(6,2030)FRET
         CALL FLUSH(6)
C
C========Print out refined parameters
C
         WRITE(6,1050)PR(1),PR(2)
         WRITE(6,1060)RTOD*PR(3),RTOD*PR(4),RTOD*PR(5)
         WRITE(6,1070)-RTOD*PR(6)
         CALL FLUSH(6)
C
C========Decide whether to accept refined values
C
         REPLY = .TRUE.
         CALL ASK('700 Accept new parameter values',REPLY,0)
         IF(REFCEN)THEN
            IF(REPLY)THEN
               XC = PR(1)
               YC = PR(2)
            ELSE
               XC = XCOLD
               YC = YCOLD
            ENDIF
         ENDIF
         IF(REFRTX)THEN
            IF(REPLY)THEN
               ROTX = PR(3)
            ELSE
               ROTX = RTXOLD
            ENDIF
         ENDIF
         IF(REFRTY)THEN
            IF(REPLY)THEN
               ROTY = PR(4)
            ELSE
               ROTY = RTYOLD
            ENDIF
         ENDIF
         IF(REFRTZ)THEN
            IF(REPLY)THEN
               ROTZ = PR(5)
            ELSE
               ROTZ = RTZOLD
            ENDIF
         ENDIF
         IF(REFTIL)THEN
            IF(REPLY)THEN
               TILT = PR(6)
            ELSE
               TILT = TILOLD
            ENDIF
         ENDIF
         PRINT *, '500 CENTRE ',XC,YC
         PRINT *, '500 ROTATION ',ROTX*RTOD,ROTY*RTOD,ROTZ*RTOD
         PRINT *, '500 TILT ', -RTOD*TILT
      ENDIF
      RETURN
C
 1000 FORMAT(1X,'400 Need to know wavelength!')
 1010 FORMAT(1X,'400 Need to know specimen-to-detector distance!')
 1020 FORMAT(1X,'400 Need starting values for centre coordinates')
 1030 FORMAT(1X,'400 Need starting values for detector orientation')
 1035 FORMAT(1X,'200',
     &       1X,'Refining the detector tilt or twist can cause the'/
     &       1X,'detector centre coordinates to shift!')
 1040 FORMAT(1X,'400 Need starting value for specimen tilt')
 1045 FORMAT(1X,'Reciprocal space limits for refinement'/
     &       1X,'Rmin = ',F8.5,3X,'Rmax = ',F8.5,3X,'Pixels = ',I4/
     &       1X,'Zmin = ',F8.5,3X,'Zmax = ',F8.5,3X,'Pixels = ',I4)
 1050 FORMAT(1X,'200',
     &       1X,'Refined centre coordinates  X = ',F7.1,4X,'Y = ',F7.1)
 1060 FORMAT(1X,'200',
     &       1X,'Refined detector rotation = ',F9.4/
     &       1X,'200',
     &       1X,'        detector twist    = ',F9.4/
     &       1X,'200',
     &       1X,'        detector tilt     = ',F9.4)
 1070 FORMAT(1X,'200',
     &       1X,'Refined specimen tilt     = ',F9.4)
 1080 FORMAT(/1X,'203',
     &       1X,'Starting refinement...')
 1090 FORMAT(/1X,'204',
     &       1X,'Refinement finished')
 2000 FORMAT(1X,'Fractional difference between successive iterations <',
     &       F9.6)
 2010 FORMAT(1X,'Function value <',G12.5)
 2020 FORMAT(1X,'No convergence')
 2030 FORMAT(1X,'Final variance =   ',G12.5)
      END


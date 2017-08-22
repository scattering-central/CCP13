C     LAST UPDATE 10/12/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION WRAPRP(P)
      IMPLICIT NONE
C
C Purpose: Provide a wrapper for REFPAR so that a pointer can be used to
C          define BUF
C
C Calls   1: REFPAR
C Called by: FREPLX, REFALL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C
C Arguments:
C
      REAL P(10)
C
C Common block variables:
C
      INTEGER*4 LBUF
C
C Common blocks:
C
      COMMON /DITTO/ LBUF
C
C External function:
C
      REAL REFPAR
      EXTERNAL REFPAR
C
C-----------------------------------------------------------------------
C
      WRAPRP = REFPAR(P,%val(LBUF))
      RETURN
      END

C     LAST UPDATE 10/12/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION REFPAR(P,BUF)
      IMPLICIT NONE
C
C Purpose: Calculates variances over four ideally equivalent regions
C          of reciprocal space for parameter refinement.
C
C Calls   1: RECTOFF
C Called by: WRAPRP
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INCLUDE 'FIXPAR.COM'
C
C Arguments:
C
      REAL P(10)
C
C This is for mmap version
C
      REAL BUF(NPIX*NRAST)
C
C Local variables:
C
      INTEGER I,J,IB,NP,IX,IY,IM1,IM2,IM3,IM4
      REAL R,Z,SUMB,SUMB2,X,Y,DX,DY,RECTMP,RJAC
C
C Local arrays:
C
      REAL U(4),V(4)
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
C-----------------------------------------------------------------------
C
C========Initialize parameters held in common
C
      XC = P(1)
      YC = P(2)
      ROTX = P(3)
      ROTY = P(4)
      ROTZ = P(5)
      TILT = P(6)
C
C========Loop over reciprocal space boxes accumulating variances
C
      REFPAR = 0.0
      DO 30 J=1,JBOX
         Z = ZMIN + FLOAT(J)*DELZ
         DO 20 I=1,IBOX
            R = RMIN + FLOAT(I)*DELR
C
C=======Find four sets of image coordinates corresponding to (R,Z)
C
            CALL RECTOFF(R,Z,U,V,NP)
            IF(NP.GT.0)THEN
               NP = 0
               SUMB = 0.0
               SUMB2 = 0.0
               DO 10 IB=1,4
                  IF(U(IB).NE.0.0 .OR. V(IB).NE.0.0)THEN
                     X = U(IB)
                     Y = V(IB)
                     RJAC = (1.0+(X*X+Y*Y)/(SDD*SDD))**1.5
                     X = X + XC + 0.5
                     Y = Y + YC + 0.5
                     IX = INT(X)
                     IY = INT(Y)
                     DX = X - FLOAT(IX)
                     DY = Y - FLOAT(IY)
                     IF((IX.GE.1.AND.IX.LT.NPIX) .AND. 
     &                  (IY.GE.1.AND.IY.LT.NRAST))THEN
                        IM1 = NPIX*(IY-1) + IX
                        IM2 = IM1 + 1
                        IM3 = IM1 + NPIX
                        IM4 = IM3 + 1
C
C========Interpolate to get value for this bin
C
                        RECTMP = (1.-DX)*(1.-DY)*BUF(IM1)
     &                              + DX*(1.-DY)*BUF(IM2)
     &                              + (1.-DX)*DY*BUF(IM3)
     &                              +      DX*DY*BUF(IM4)
                        RECTMP = RECTMP*RJAC
                        NP = NP + 1
                        SUMB2 = SUMB2 + RECTMP*RECTMP
                        SUMB = SUMB + RECTMP
                     ENDIF
                  ENDIF
 10            CONTINUE
               IF(NP.GT.0)
     &            REFPAR = REFPAR + SUMB2 - SUMB*SUMB/FLOAT(NP)
            ENDIF
 20      CONTINUE
 30   CONTINUE
      RETURN
      END


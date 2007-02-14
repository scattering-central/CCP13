      function DIBLK(Q,RN,LL,F,CHI)
c==== this subroutine calculates the LIEBLER DIBLOCK COPOLYMER
C==== L.LEIBLER, Macromolecule 13(1980)1602-1617 eqns IV-2 to IV-8
c==== 		R.K.Heenan 13/1/97
C
c==== NOTE MAY NOT BE VERY ROBUST TO OVERFLOWS, NON-PHYSICAL PARAMS ETC. !!!
C
      real*4 LL
      LT=1
      UU=0.0
C====  compute Rg**2
      RR = RN*LL*LL/6.0
      BIGF = DEBGAUSS(LT,Q,RR,UU)
      FM = 1.0-F
      D  = (F**2)* DEBGAUSS(LT,Q,RR*F ,UU)
      DM = (FM**2)*DEBGAUSS(LT,Q,RR*FM,UU)
      DEN = D*DM -0.25*(BIGF -D -DM)**2
      DIBLK = RN/( BIGF/DEN  -2.0*CHI*RN)
      RETURN
      END
c
c
      function DEBGAUSS(LTYP,QQ,RR,UU)
C==== P(Q) for Debye Gaussian coil.  Polydisp if LTYP >10 (i.e. 11 or 21)
c
C==== NOTE input RR is RG SQUARED not RG, but QQ is just Q
c
c==== carefully modified Feb 1992 by R.K.Heenan to avoid over & underflows
C==== 12/5/94 star polymer equation added as LTYP=31, fo rwhich UU is then
c==== the number of arms F
c
c==== polynomial expansion is used at small QR
c
c==== Written by R.K.Heenan, RAL
c
      QR=RR*(QQ**2)
      U=0.0
      FSTAR=1.0
      IF(LTYP.EQ.11)U=ABS(UU)
      IF(LTYP.EQ.31)FSTAR=AMAX1(1.0,ABS(UU))
C====  note U and FSTAR cannot be used simultaneously !
      Y=QR/( (1.0+2.0*U)*(3.0 -2.0/FSTAR) )
C==== polydisp version
      IF(U.GT.1.0E-02.AND.Y.GT.0.01)DEBGAUSS=
     >         2.0*( (1.0+U*Y)**(-1.0/U) +Y -1.0)/( (1.0+U)*(Y**2) )
C==== monodisp version
C2345 789012345678901234567890123456789012345678901234567890123456789012
      IF(U.LE.1.0E-02.AND.Y.GT.0.01)THEN
        AA=(EXPSPEC(-Y)-1.0)/(FSTAR*Y)
        DEBGAUSS= 2.*(AA + 1./FSTAR)/Y
        IF(FSTAR.GT.1.0)DEBGAUSS=DEBGAUSS+ FSTAR*(FSTAR-1.0)*AA*AA
      END IF
C==== EXPSPEC avoids underflows as QR**2 can be large
C==== low Q expansion for ALL versions
      IF(Y.LE.0.01)DEBGAUSS= 1.0 - QR*(1.0+ (0.25 - 0.75*U)*Y )/3.0
      return
      end
c
      FUNCTION EXPSPEC(A)
C==== expspec avoids underflows invoking the error handler
c==== the -88.5 is a machine dependent number
c
c==== The usual EXP( ) function may be fine - depends whether 
c==== a particular compiler gives underflow errors
cc
c==== Written by R.K.Heenan, RAL
c
      EXPSPEC=0.0
      IF(A.GT.-88.5.AND.A.LT.88.0)THEN
         EXPSPEC=EXP(A)
      ELSE IF(A.GE.85.2)THEN
         EXPSPEC=1.0E37
      END IF
C==== NOTE EXP(88.02)=1.684996E38
C==== NOTE EXP(-88.7)=3.006635E-39
      RETURN
      END
C





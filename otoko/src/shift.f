C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SHIFT (REF,SHI,RES,SQUARE,NCHAN,ILRAN,IRRAN,
     1                  ISTEP,IFINE)
      IMPLICIT NONE
C
C Purpose: Shift to optimize overlap
C
C Author : M.Kress, 5.4.84
C
      REAL    REF(1),SHI(1),RES(1),SQUARE(1)
      INTEGER NCHAN,ILRAN,IRRAN,ISTEP,IFINE
C
C REF    : Reference spectrum
C SHI    : Spectrum to be shifted
C RES    : Result, SHI shifted by non-integer number of channels,
C          with resolution 1/ISTEPS channels. Linear interpolation
C          between neighbouring channels is used.
C SQUARE : Returns sum of squares of difference for all the shifts
C NCHAN	 : Length of input spectra REF,SHI
C ILRAN  : Region where the optimisation of the sum of squares of the
C IRRAN  : ...differences is to be performed. Must leave enough room at
C             the edges to do the shifts. If not, is set to make this 
C             possible
C ISTEP  : Number of interpolation points between two input channels
C IFINE  : Radius of the region of shifts to be investigated, in fine
C          grid units
C
C Calls   1: MINMAX
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
C Implementation notes:
C  This subroutine accepts two spectra of NCHAN length on REF (reference)
C  and SHI (to be shifted). It transcribes SHI by linear interpolation
C  (spread by factor ISTEP) into the spectrum SHIF (F stands for fine
C  channels). The product of length of input spectra times the blow-up
C  factor, NCHAN * ISTEP, must be lower then 5120. SHIF is then shifted
C  between -IFINE and +IFINE fine channels. At each step the
C  difference of REFF and the shifted SHIF is stored in SQHILF. The
C  average square of this is then calculated for each step. This is
C  stored in SQUARE. The minimum of this is found. This shift is then
C  applied to SHIF to put it back into a spectrum of length NCHAN that is
C  stored in RES (result). The difference between the two spectra is only
C  formed between the channels ILRAN and IRRAN of the original input
C  spectra. The result of the routine is to shift one spectrum to get
C  maximal overlap with a reference spectrum. The shift can be a
C  non-integer number of channels. Its largest extend is determined by
C  IFINE/ISTEP. This subroutine was written for muscle diffraction,
C  where one wants to pick up slight differences between the resting and
C  the contracting pattern, but these patterns might be slightly offset
C  due to tilting of the muscle when it develops tension. For the
C  non-integral shift simple linear interpolation between the
C  neighbouring points was used, as this seems to be the only bias free
C  method to use on usually very noisy data, where the individual error
C  bars are larger than the real difference between two points. All other
C  methods of interpolation would employ curve fitting, where with the
C  noisy data probably only fastly converging series could be employed,
C  and then each experiment would need other functions. 
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
C Local variables:
C
      REAL    SQHILF(2048),SHIF(5120),XMIN,XMAX
      INTEGER IMIN,IMAX,ILESEN,ISHIFT,I,J
C
C SQHILF :
C SHIF   : Spectrum to be shifted expanded by linear interpolation
C ILESEN :
C ISHIFT :
C IMIN   :
C IMAX   :
C XMIN   :
C XMAX   :
C
C-----------------------------------------------------------------------
      IF (ISTEP*NCHAN.GT.5120) THEN
         PRINT *,'Expansion factor too large'
         RETURN
      ENDIF
C
      DO 10 I=1,NCHAN-1
         DO 20 J=1,ISTEP
            SHIF((I-1)*ISTEP+J)=((ISTEP-J+1)*SHI(I)+(J-1)*
     &                          SHI(I+1))/ISTEP
20       CONTINUE
10    CONTINUE
C
      DO 30 I=1,NCHAN
         SQUARE(I)=0.0
30    CONTINUE
C
      DO 40 I=-IFINE,+IFINE
         DO 50 J=ILRAN,IRRAN
            SQHILF(J)=REF(J)-SHIF((J-1)*ISTEP+1-I)
            SQUARE(I+IFINE+1)=SQUARE(I+IFINE+1)+SQHILF(J)**2
50       CONTINUE
C
         SQUARE(I+IFINE+1)=SQUARE(I+IFINE+1)/(IRRAN-ILRAN)
40    CONTINUE
C
      CALL MINMAX (SQUARE,2048,1,2*IFINE+1,IMIN,IMAX,XMIN,XMAX)
      ISHIFT=(IMIN-1)-IFINE
      IF (ISHIFT.GE.0) THEN
         ILESEN=1
      ELSE
         ILESEN=-1*ISHIFT/ISTEP+1
      ENDIF
      DO 60 I=ILESEN,NCHAN
         RES(I)=SHIF(I-1)*ISTEP-ISHIFT+1
60    CONTINUE
      RETURN
      END

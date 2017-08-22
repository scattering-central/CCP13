C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE REMAP
      IMPLICIT NONE
C
C Purpose: Remap an image according to a given set of remapping points
C
      INCLUDE 'COMMON.FOR'
C
C
C Calls   7: APLOT  , DAWRT  , GETCHN , GETHDR , OPNFIL , GETXAX
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL VALUE(10),XINC,XTOT,GRAD
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,NVAL,INDEX
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NPNTX
      INTEGER NFRAME,NCHAN,I,J,K,NCHANX,II,M,IFIRST,ILAST,L,NCH
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
C KREC   : Output file record
C ISPEC  : First header file of sequence
C LSPEC  : Last header file in sequence
C MEM    : Positional or calibration data indicator
C IFFR   : First frame in sequence
C ILFR   : Last frame in sequence
C INCR   : Header file increment
C IFINC  : Frame increment
C HFNAM  : Header filename
C OFNAM  : Output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C NFRAME : Nos. of time frames
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
C
 10   ICLO=0
      JOP=0
      KREC=0
      WRITE (IPRINT,*) 'Remapping file'
      CALL GETXAX (NCHANX,IRC)
      IF (IRC.NE.0) GOTO 999
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1

 15   NPNTX=0
      WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 999
      IF (IRC.EQ.2) GOTO 10
      IF (NVAL.GE.1) NPNTX=INT(VALUE(1))             
      IF (NPNTX.EQ.0) GOTO 15
C
      DO 70 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 60 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
               CALL FILL (SP2,NCHAN,0.0)
C
               II=1
               DO 40 M=1,NCHANX+1
                  IF (M.EQ.1) THEN
                     IFIRST=1
                     ILAST=XAX(M)-1
                  ELSEIF (M.EQ.NCHANX+1) THEN
                     IFIRST=XAX(M-1)
                     ILAST=NCHAN
                  ELSE
                     IFIRST=XAX(M-1)
                     ILAST=XAX(M)-1
                  ENDIF   
                  IF (M.EQ.1.OR.M.EQ.NCHANX+1) THEN
                     DO 20 L=IFIRST,ILAST
                        SP2(II)=SP1(L)
                        II=II+1
20                   CONTINUE
                  ELSE
                     NCH=ILAST-IFIRST+1
                     XINC=REAL(NCH-1)/REAL(NPNTX-1)
                     SP2(II)=SP1(IFIRST)
                     SP2(II+NPNTX-1)=SP1(ILAST)
                     XTOT=REAL(IFIRST)
                     DO 30 L=2,NPNTX-1
                        XTOT=XTOT+XINC
                        INDEX=IFIX(XTOT)
                        GRAD=SP1(INDEX+1)-SP1(INDEX)
                        SP2(II+L-1)=GRAD*(XTOT-REAL(INDEX))+
     &                                     SP1(INDEX)
30                   CONTINUE            
                     II=II+NPNTX
                  ENDIF
40             CONTINUE
C
               IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP2,NCHAN)
               IF (KREC.GE.IFRAME) ICLO=1
               IF (KREC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 90
               ENDIF
               CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     &                  SP2,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 90
 60         CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
 70   CONTINUE
 90   CLOSE (UNIT=JUNIT)
      GOTO 10
999   RETURN
1000  FORMAT (' How many remapped points [0]: ',$)
      END

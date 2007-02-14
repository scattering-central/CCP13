C     LAST UPDATE 24/02/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE INTEG 
      IMPLICIT NONE
C
C Purpose: Determine centre of diffraction pattern from at least three 
C          points 
C
C Calls   2: RDCOMF, ASK 
C Called by: FIX 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file
C
      INCLUDE 'FIXPAR.COM'
C
C Local variables:
C
      INTEGER I,J,NTYPE,NW,NV,IRC
      INTEGER ITEM(20),IVAL(10)
      REAL VALS(10)
      REAL BAK 
      CHARACTER*10 WORD(10)
      CHARACTER*7 TYPE(3)
      LOGICAL REPLY,MORE
C
      DATA TYPE /'POINT  ', 'LINE   ', 'POLYGON'/
C
C-----------------------------------------------------------------------
C
C========List filespace coordinates
C
      MORE = .TRUE.
 5    WRITE(6,1000)
      DO 10 I=1,NPTS
         IF(NVALS(I).GT.1)THEN
            NTYPE = 3
         ELSE
            NTYPE = 1 
         ENDIF
         WRITE(6,1010)I,(FXY(J,I),J=1,2),(SXY(J,I),J=1,2),
     &                (RZ(J,I),J=1,2),AVPIX(I),BCK(I),BKSUB(I),
     &                TYPE(NTYPE) 
 10   CONTINUE
C
C========Inquire as to which ranges of coordinates to use in integration 
C
      IF(.NOT.MORE)RETURN
 20   WRITE(6,1020)
      CALL RDCOMF(5,WORD,NW,VALS,NV,ITEM,10,10,10,IRC)
      IF(IRC.NE.0)RETURN
      IF(NW.GT.0)THEN
         WRITE(6,2000)
         GOTO 20
      ENDIF
      IF(NV.EQ.0)THEN
         IVAL(1) = 1
         IVAL(2) = NPTS
         NV = 2
         MORE = .FALSE.
      ELSEIF(NV.LT.2)THEN
         WRITE(6,1030)
         GOTO 20
      ELSE
         DO 25 I=1,NV
            IVAL(I) = NINT(VALS(I))
 25      CONTINUE
      ENDIF
C
C========Inquire as to which background subtraction method to use
C
      REPLY = .TRUE.
      CALL ASK('Automatic background subtraction',REPLY,0)
      IF(.NOT.REPLY)THEN
         WRITE(6,1040)
 27      CALL RDCOMF(5,WORD,NW,VALS,J,ITEM,10,10,10,IRC)
         IF(IRC.NE.0)RETURN
         IF(NW.GT.0)THEN
            WRITE(6,2000)
            GOTO 27 
         ENDIF
         IF(J.EQ.0)THEN
            BAK = 0.0
         ELSE
            BAK = AVPIX(NINT(VALS(1)))
         ENDIF
      ENDIF
C
C========Integrate points and subtract background 
C
      DO 40 I=1,NV-1,2
         IF(I+1.GT.NV)IVAL(I+1) = IVAL(I)
         DO 30 J=IVAL(I),IVAL(I+1)
            IF(J.LT.1.OR.J.GT.NPTS)THEN
               WRITE(6,1050)
               RETURN
            ENDIF
            IF(REPLY)BAK = BCK(J)
            BKSUB(J) = FLOAT(NVALS(J))*(AVPIX(J) - BAK)
 30      CONTINUE
 40   CONTINUE
      GOTO 5
C
 1000 FORMAT(/2X,'No.',6X,'Filespace',8X,'Standard',11X,'Reciprocal',
     &       6X,'Av. pixel',3X,'Background',3X,'Intensity',6X,'Type'/
     &       2X,'         X       Y',8X,'X       Y',10X,'R        Z')
 1010 FORMAT(1X,I3,1X,2F8.1,1X,2F8.1,4X,2F9.5,3X,3G12.5,4X,A7)
 1020 FORMAT(1X,'Enter coordinate ranges for integration: ',$)
 1030 FORMAT(1X,'Not enough points')
 1040 FORMAT(1X,'Enter point number to use as background: ',$)
 1050 FORMAT(1X,'Selected point is out of range')
 2000 FORMAT(1X,'***Numeric input only')
C-----------------------------------------------------------------------
      END                  

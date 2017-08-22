C     LAST UPDATE 23/02/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE RDCOM(IN,IOUT,WORD,NWORD,VALUES,NVALS,ITEM,ILOG,IRC)
      IMPLICIT NONE
C
C Purpose: Read a line of input from a terminal and sort into words and
C          numbers.
C
      INTEGER*4 IN,IOUT,NWORD,NVALS,ITEM(20),ILOG,IRC
      REAL*4    VALUES(10)
      CHARACTER*(*)  WORD(10)
C
C IN     : Terminal input stream
C IOUT   : Terminal output stream
C WORD   : Character string containing words separated by ' ' or ','
C NWORD  : Number of words found
C VALUES : Numerical values found (max. of 10)
C NVALS  : Number of values found
C ITEM   : Array containing 1 for a number, 2 for a word or 0
C ILOG   : Unit number for logfile output, no output for 0
C IRC    : 2 on error, 1 on EOF, 0 otherwise
C
C Calls   1: PNUM
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER I,J,ISTRT,IEND,IT,IENDL,ILINE,length,inf
      LOGICAL DIGIT,STRING
      CHARACTER*660 LINE
      CHARACTER*132 LBUF
      CHARACTER*13  CHNUM
C
      EXTERNAL PNUM,UPPER
C
C LBUF   : Input line of data
C LINE   : All characters pertaining to one data card
C CHNUM  : Character set determining number/word from initial character
C DIGIT  : True if string is number
C STRING : True if not a separator (' ' or ',')
C
      DATA CHNUM/'1234567890.+-'/ , length /132/
C
C-----------------------------------------------------------------------
      STRING=.FALSE.
      NVALS=0
      NWORD=0
      ILINE=0
      IT=0
      IENDL=0
      DO 10 I=1,660
        IF(I.LE.20)ITEM(I)=0
        IF(I.LE.132)LBUF(I:I) = ' '
        LINE(I:I)= ' '
 10   CONTINUE
 11   READ(IN,'(A132)',ERR=99,END=999)LBUF
      IF(ILOG.GT.0)WRITE(ILOG,'(A132)')LBUF
      ILINE=ILINE+1
      IF(ILINE.GT.5)THEN
        IF(IOUT.GT.0)WRITE(IOUT,1000)
        IF(ILOG.GT.0)WRITE(ILOG,1000)
        GOTO 99
      ENDIF
      LINE(IENDL+1:IENDL+132)=LBUF
      DO 30 I=IENDL+1,IENDL+132
        IF(LINE(I:I).EQ.'!')THEN
C========Comment after !
          IEND=I-1
          IF(STRING)THEN
            STRING=.FALSE.
            IF(DIGIT)THEN
              NVALS=NVALS+1
              ITEM(IT)=1
              CALL PNUM(LINE(ISTRT:IEND),IEND-ISTRT+1,VALUES(NVALS),IRC)
              IF(IRC.EQ.2)THEN
                IF(IOUT.GT.0)WRITE(IOUT,1010)
                IF(ILOG.GT.0)WRITE(ILOG,1010)
                GOTO 99
              ENDIF
            ELSE
              NWORD=NWORD+1
              ITEM(IT)=2
              WORD(NWORD)=LINE(ISTRT:IEND)
              CALL UPPER(WORD(NWORD),IEND-ISTRT+1)
            ENDIF
          ENDIF
          GOTO 9
        ELSEIF(LINE(I:I).EQ.'&')THEN
C========Continuation after &
          IENDL=I-1
          GOTO 11
C========Check for separator
        ELSEIF(.NOT.STRING.AND.(LINE(I:I).NE.' '
     &         .AND.LINE(I:I).NE.','))THEN
          ISTRT=I
          DIGIT=.FALSE.
          STRING=.TRUE.
          IT=IT+1
          DO 20 J=1,13
            IF(LINE(I:I).EQ.CHNUM(J:J))DIGIT=.TRUE.
 20       CONTINUE
        ELSEIF(STRING.AND.(LINE(I:I).EQ.' '.OR.LINE(I:I).EQ.','))THEN
          IEND=I-1
          STRING=.FALSE.
C========If the input is numeric, pass to PNUM
          IF(DIGIT)THEN
            NVALS=NVALS+1
            ITEM(IT)=1
            CALL PNUM(LINE(ISTRT:IEND),IEND-ISTRT+1,VALUES(NVALS),IRC)
            IF(IRC.EQ.2)THEN
              IF(IOUT.GT.0)WRITE(IOUT,1010)
              IF(ILOG.GT.0)WRITE(ILOG,1010)
              GOTO 99
            ENDIF
          ELSE
            NWORD=NWORD+1
            ITEM(IT)=2
            WORD(NWORD)=LINE(ISTRT:IEND)
            CALL UPPER(WORD(NWORD),IEND-ISTRT+1)
          ENDIF
        ENDIF
 30   CONTINUE
 9    IRC=0
      RETURN
 99   IRC=2
      IF(IOUT.GT.0)WRITE(IOUT,1020)IN
      IF(ILOG.GT.0)WRITE(ILOG,1020)IN
      RETURN
 999  IRC=1
      IF(IOUT.GT.0)WRITE(IOUT,1030)
      IF(ILOG.GT.0)WRITE(ILOG,1030)
      RETURN
 1000 FORMAT(1X,'RDCOM ERROR: more than 5 continued lines')
 1010 FORMAT(1X,'RDCOM ERROR: non-numeric character in numeric read')
 1020 FORMAT(1X,'error reading unit',I5)
 1030 FORMAT(1X,'EOF')
      END
C
C
C
      SUBROUTINE UPPER(WORD,LEN)
      IMPLICIT NONE
C
C========Make all letters uppercase
C
      INTEGER LEN
      CHARACTER*(*) WORD
C
      INTEGER IDIF,ILET,J
C
      INTRINSIC CHAR,ICHAR
C
      IDIF=ICHAR('a')-ICHAR('A')
      DO 10 J=1,LEN
        ILET=ICHAR(WORD(J:J))
          IF(ILET.GE.ICHAR('a').AND.ILET.LE.ICHAR('z'))THEN
            WORD(J:J)=CHAR(ILET-IDIF)
          ENDIF
 10   CONTINUE
C
      RETURN
      END
C
C
C
C     LAST UPDATE 19/01/93
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE PNUM(STRING,NCHAR,PVAL,IRC)
      IMPLICIT NONE
C
C Purpose: Take a string containing a number in integer,floating decimal
C          or exponent format and return a real number.
C
      REAL PVAL
      INTEGER NCHAR,IRC
      CHARACTER*(*) STRING
C
C NCHAR  : Number of relevant characters in string
C STRING : Character string containing number
C PVAL   : Returned value
C IRC    : 2 on error, 1 on EOF, 0 otherwise
C
C Calls   0:
C Called by: RDCOM
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    SIGN,SIGNE,EXPNT
      INTEGER IR(80),N1,N2,NP1,NP2,NE1,NE2,ID,NI,NP,NE,I,IP
      CHARACTER*1 CH
C
C SIGN   : Sign of integer or decimal part
C SIGNE  : Sign of exponent
C EXPNT  : Exponent
C IR     : Array containing decoded digits
C CH     : Character containing a coded digit
C
C---------------------------------------------------------------------
      N1=1
      SIGN=1.0
      SIGNE=1.0
      NP1=0
      NE1=0
      N2=NCHAR
      NP2=NCHAR
      NE2=NCHAR
      IF(STRING(1:1).EQ.'+')THEN
         N1=2
      ELSEIF(STRING(1:1).EQ.'-')THEN
         N1=2
         SIGN=-1.0
      ENDIF
      DO 10 I=N1,NCHAR
        IF(STRING(I:I).EQ.'.')THEN
           N2=I-1
           NP1=I+1
        ELSEIF(STRING(I:I).EQ.'E'.OR.STRING(I:I).EQ.'e'.OR.
     &         STRING(I:I).EQ.'D'.OR.STRING(I:I).EQ.'d')THEN
           IF(NP1.EQ.0)THEN
             N2=I-1
           ELSE
             NP2=I-1
           ENDIF
           IF(STRING(I+1:I+1).EQ.'-')THEN
             SIGNE=-1.0
             NE1=I+2
           ELSEIF(STRING(I+1:I+1).EQ.'+')THEN
             NE1=I+2
           ELSE
             NE1=I+1
           ENDIF
        ELSEIF(STRING(I:I).NE.'-'.AND.STRING(I:I).NE.'+')THEN
           CH=STRING(I:I)
           READ(CH,1000,ERR=99,END=999)ID
           IR(I)=ID
        ENDIF
 10   CONTINUE
      PVAL=0.0
      DO 20 NI=N1,N2
        PVAL=PVAL+FLOAT(IR(NI))*10.0**(N2-NI)
 20   CONTINUE
      IF(NP1.GT.0)THEN
         IP=0
         DO 30 NP=NP1,NP2
           IP=IP-1
           PVAL=PVAL+FLOAT(IR(NP))*10.0**IP
 30      CONTINUE
      ENDIF
      PVAL=PVAL*SIGN
      IF(NE1.GT.0)THEN
         EXPNT=0.0
         DO 40 NE=NE1,NE2
           EXPNT=EXPNT+FLOAT(IR(NE))*10.0**(NE2-NE)
 40      CONTINUE
         EXPNT=EXPNT*SIGNE
         PVAL=PVAL*10.0**EXPNT
      ENDIF
 1000 FORMAT(I1)
      IRC=0
      RETURN
 99   IRC=2
      RETURN
 999  IRC=1
      RETURN
      END

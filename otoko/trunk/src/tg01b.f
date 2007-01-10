      REAL FUNCTION TG01B*4(IX,N,U,S,D,X)                               
C###### 04/08/70LAST LIBRARY UPDATE                                     
C
C	--------------------------------------------------------
C
C                                                                       
C                                                                       
C      TG01B -  FUNCTION ROUTINE TO EVALUATE A CUBIC SPLINE GIVEN SPLINE
C     VALUES AND FIRST DERIVATIVE VALUES AT THE GIVEN KNOTS.            
C                                                                       
C     THE SPLINE VALUE IS DEFINED AS ZERO OUTSIDE THE KNOT RANGE,WHICH  
C     IS EXTENDED BY A ROUNDING ERROR FOR THE PURPOSE.                  
C                                                                       
C                  F = TG01B(IX,N,U,S,D,X)                              
C                                                                       
C       IX    ALLOWS CALLER TO TAKE ADVANTAGE OF SPLINE PARAMETERS SET  
C             ON A PREVIOUS CALL IN CASES WHEN X POINT FOLLOWS PREVIOUS 
C             X POINT. IF IX < 0 THE WHOLE RANGE IS SEARCHED FOR KNOT   
C             INTERVAL; IF IX > 0 IT IS ASSUMED THAT X IS GREATER THAN  
C             THE X OF THE PREVIOUS CALL AND SEARCH STARTED FROM THERE. 
C       N     THE NUMBER OF KNOTS.                                      
C       U     THE KNOTS.                                                
C       S     THE SPLINE VALUES.                                        
C       D     THE FIRST DERIVATIVE VALUES OF THE SPLINE AT THE KNOTS.   
C       X     THE POINT AT WHICH THE SPLINE VALUE IS REQUIRED.          
C       F     THE VALUE OF THE SPLINE AT THE POINT X.                   
C                                                                       
C                                      MODIFIED JULY 1970               
C                                                                       
C********************************************************************** 
C                                                                       
C     ALLOWABLE ROUNDING ERROR ON POINTS AT EXTREAMS OF KNOT RANGE      
C     IS 2**IEPS*MAX(!U(1)!,!U(N)!).                                    
      INTEGER*4 IFLG,IEPS                                       
      DIMENSION U(1),S(1),D(1)                                          
      DATA IFLG/0/,IEPS/-19/
C                                                                       
C       TEST WETHER POINT IN RANGE.                                     
      IF(X.LT.U(1)) GO TO 990                                           
      IF(X.GT.U(N)) GO TO 991                                           
C                                                                       
C       JUMP IF KNOT INTERVAL REQUIRES RANDOM SEARCH.                   
      IF(IX.LT.0.OR.IFLG.EQ.0) GO TO 12                                 
C       JUMP IF KNOT INTERVAL SAME AS LAST TIME.                        
      IF(X.LE.U(J+1)) GO TO 8                                           
C       LOOP TILL INTERVAL FOUND.                                       
    1 J=J+1                                                             
   11 IF(X.GT.U(J+1)) GO TO 1                                           
      GO TO 7                                                           
C                                                                       
C       ESTIMATE KNOT INTERVAL BY ASSUMING EQUALLY SPACED KNOTS.        
   12 J=ABS(X-U(1))/(U(N)-U(1))*(N-1)+1                                 
C       ENSURE CASE X=U(N) GIVES J=N-1.                                 
      J=MIN0(J,N-1)                                                     
C       INDICATE THAT KNOT INTERVAL INSIDE RANGE HAS BEEN USED.         
      IFLG=1                                                            
C       SEARCH FOR KNOT INTERVAL CONTAINING X.                          
      IF(X.GE.U(J)) GO TO 11                                            
    2 J=J-1                                                             
      IF(X.LT.U(J)) GO TO 2                                             
C                                                                       
C       CALCULATE SPLINE PARAMETERS FOR JTH INTERVAL.                   
    7 H=U(J+1)-U(J)                                                     
      Q1=H*D(J)                                                         
      Q2=H*D(J+1)                                                       
      SS=S(J+1)-S(J)                                                    
      B=3.0*SS-2.0*Q1-Q2                                                
      A=Q1+Q2-2.0*SS                                                    
C                                                                       
C       CALCULATE SPLINE VALUE.                                         
    8 Z=(X-U(J))/H                                                      
      TG01B=((A*Z+B)*Z+Q1)*Z+S(J)                                       
      RETURN                                                            
C       TEST IF X WITHIN ROUNDING ERROR OF U(1).                        
  990 IF(X.LE.U(1)-2.0**IEPS*AMAX1(ABS(U(1)),ABS(U(N)))) GO TO 99       
      J=1                                                               
      GO TO 7                                                           
C       TEST IF X WITHIN ROUNDING ERROR OF U(N).                        
  991 IF(X.GE.U(N)+2.0**IEPS*AMAX1(ABS(U(1)),ABS(U(N)))) GO TO 99       
      J=N-1                                                             
      GO TO 7                                                           
   99 IFLG=0                                                            
C       FUNCTION VALUE SET TO ZERO FOR POINTS OUTSIDE THE RANGE.        
      TG01B=0.0                                                         
      RETURN                                                            
      END                                                               

      REAL FUNCTION DCAL(RCELL,IH,IK,IL)
      IMPLICIT NONE
C
      REAL RCELL(6)
      REAL RH,RK,RL
      INTEGER IH,IK,IL
C
      RH = FLOAT(IH)
      RK = FLOAT(IK)
      RL = FLOAT(IL)
C
      DCAL = SQRT(RH*RH*RCELL(1)*RCELL(1) + 
     &            RK*RK*RCELL(2)*RCELL(2) +
     &            RL*RL*RCELL(3)*RCELL(3) + 
     &            2.0*RK*RL*RCELL(2)*RCELL(3)*COS(RCELL(4)) +
     &            2.0*RL*RH*RCELL(3)*RCELL(1)*COS(RCELL(5)) +
     &            2.0*RH*RK*RCELL(1)*RCELL(2)*COS(RCELL(6)))
      RETURN 
C
      END

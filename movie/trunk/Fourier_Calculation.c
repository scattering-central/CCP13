#define NRANSI
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

void Fourier_Calculation()
{
  extern struct Info *VAR;
  extern struct Myosin *MY;
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct Constant Cnst;
  extern struct Intensity *ID;
  extern struct BackBone *BB;
  extern struct Actin *AA;
  extern struct Tropomyosin *TR;
     
  int h,k,l,Rad,Sph,reps,m;
  int Head,Level,Strands,strand;
  int U_Fil,Dom,SubU,Points,Mol;
  double psi,Cmpnt_1,Cmpnt_2,Sph_Fac,psi_inv;
  double Sb,Arg,R_Rad,bes_arg,axial,azimuth;
  double b1angle,b2angle,b3angle,b1,b2,b3;
  double sum1,sum2,contrib,contrib2;

  VAR->Iterations++;
  for(l = 0;l<=ID->l_max;l++) {	  
    for(Rad = 0;Rad<=ID->R_max;Rad++) {
      ID->CI[Rad][l] = 0.0;
    }
  }
  for(l = 0;l<=ID->l_max;l++) {
    for(h = -ID->h_max;h<=ID->h_max;h++) {
      for(k = -ID->k_max;k<=ID->k_max;k++) {       
	Rad = abs(h*h+k*k+h*k);
	if(Rad > ID->R_max) continue;
	if(ID->SD[Rad][l] == 0.0) continue;
	psi =  atan2((2.0*k+h),Cnst.Root_t*h);
	if((psi >= VAR->Max_Angle) || (psi < VAR->Min_Angle )) continue;
	R_Rad = sqrt((double)Rad)/(VAR->U_Cl*Cnst.Root_tq);
	Cmpnt_1 = 0.0;
	Cmpnt_2 = 0.0;

	if(VAR->Myo) {
	  Points = 0;
	  Sb = Cnst.Two_Pi*MY->Sph_Sz*sqrt(SQR(R_Rad)+SQR((double)l/VAR->Tot_Rep));
	  Sph_Fac = CUBE(MY->Sph_Sz)*(sin(Sb)-Sb*cos(Sb))/CUBE(Sb);
	  for(Head=1;Head<=MY->N_Hds;Head++) {
	    for(Sph=0;Sph<=MY->N_Pts;Sph++) {
	      if(VAR->NoPerts) {
		Points++;
		sum1 = 0.0;
		sum2 = 0.0;
		bes_arg = fabs(Cnst.Two_Pi*R_Rad*MY->Radial[Points]);
		axial = (Cnst.Two_Pi*l*MY->Z[Points])/VAR->Tot_Rep;
		azimuth = psi-MY->Azi[Points] + Cnst.Pi/2.0;
		for(m=0;m<=ID->Bes_Num;m++) {
		  if(ID->Bes_Orders[l][m] == 999) break;
		  contrib = ID->Bes_Contrib[l][m]*
		    ID->Bessel[abs((int)(2*MY->Radial[Points]))][Rad][abs(ID->Bes_Orders[l][m])];
		  sum1 += contrib*cos(ID->Bes_Orders[l][m]*azimuth + axial);
		  sum2 += contrib*sin(ID->Bes_Orders[l][m]*azimuth + axial);
		}
		Cmpnt_1 += Sph_Fac*sum1;
		Cmpnt_2 += Sph_Fac*sum2;
	      }
	      else {
		for(Level=1;Level<=MY->N_Crwns;Level++) {
		  for(Strands=1;Strands<=VAR->N_Strnds;Strands++) {
		    for(reps=1;reps<=(int)(VAR->Tot_Rep/MY->Repeat);reps++) {
		      Points++;
		      Arg = Cnst.Two_Pi*(h*MY->RX[Points]+
					 k*MY->RY[Points]+
					 l*MY->RZ[Points]);
		      Cmpnt_1 += Sph_Fac*cos(Arg);
		      Cmpnt_2 += Sph_Fac*sin(Arg);
		    }
		  }
		}
	      }
	    }
	  }
	}
		    
	if(VAR->CPro) {
	  Points = 0;
	  Sb = Cnst.Two_Pi*CP->Sph_Sz*sqrt(SQR(R_Rad)+SQR((double)l/VAR->Tot_Rep));
	  Sph_Fac = fabs(CP->Weight.Val)*CUBE(CP->Sph_Sz)*(sin(Sb)-Sb*cos(Sb))/CUBE(Sb);
	  for(Mol=1;Mol<=VAR->N_Strnds;Mol++) {
	    for(SubU=1;SubU<=CP->Tot_SubU;SubU++) {
	      for(reps=1;reps<=(int)(VAR->Tot_Rep/CP->Repeat);reps++) {
		Points++;
		Arg = Cnst.Two_Pi*(h*CP->RX[Points]+
				   k*CP->RY[Points]+
				   l*CP->RZ[Points]);
		Cmpnt_1 += Sph_Fac*cos(Arg);
		Cmpnt_2 += Sph_Fac*sin(Arg);  
	      }      
	    }
	  }
	}
		    
	if(VAR->Titin) {
	  Points = 0;
	  Sb = Cnst.Two_Pi*TT->Sph_Sz*sqrt(SQR(R_Rad)+SQR((double)l/VAR->Tot_Rep));
	  Sph_Fac = fabs(TT->Weight.Val)*CUBE(TT->Sph_Sz)*(sin(Sb)-Sb*cos(Sb))/CUBE(Sb);
	  for(Mol=1;Mol<=VAR->N_Strnds;Mol++) {
	    for(SubU=1;SubU<=TT->Tot_SubU;SubU++) {
	      for(reps=1;reps<=(int)(VAR->Tot_Rep/TT->Repeat);reps++) {
		Points++;
		Arg = Cnst.Two_Pi*(h*TT->RX[Points]+
				   k*TT->RY[Points]+
				   l*TT->RZ[Points]);
		Cmpnt_1 += Sph_Fac*cos(Arg);
		Cmpnt_2 += Sph_Fac*sin(Arg);  
	      }
	    }
	  }
	}

	if(VAR->Actin) {
	  Points = 0;
	  for(Dom=1;Dom<=AA->Tot_Dom;Dom++) {
	    Sb = Cnst.Two_Pi*AA->Sph_Sz[Dom]*sqrt(SQR(R_Rad)+SQR((double)l/VAR->Tot_Rep));
	    Sph_Fac = fabs(AA->Weight.Val)*CUBE(AA->Sph_Sz[Dom])*(sin(Sb)-Sb*cos(Sb))/CUBE(Sb);
	    for(SubU=1;SubU<=AA->Tot_SubU;SubU++) {
	      for(U_Fil=1;U_Fil<=AA->N_Fil;U_Fil++) {
		for(reps = 1;reps<=(int)(VAR->Tot_Rep/AA->Repeat);reps++) {
		  Points++;
		  Arg = Cnst.Two_Pi*(h*AA->RX[Points]+
				     k*AA->RY[Points]+
				     l*AA->RZ[Points]);
		  Cmpnt_1 += Sph_Fac*cos(Arg);
		  Cmpnt_2 += Sph_Fac*sin(Arg);
		}
	      }
	    }
	  }
	}
		    
	if(VAR->Tropomyosin) {
	  Points = 0;
	  Sb = Cnst.Two_Pi*TR->Sph_Sz*sqrt(SQR(R_Rad)+SQR((double)l/VAR->Tot_Rep));
	  Sph_Fac = fabs(TR->Weight.Val)*CUBE(TR->Sph_Sz)*(sin(Sb)-Sb*cos(Sb))/CUBE(Sb);
	  for(SubU=1;SubU<=TR->Tot_SubU;SubU++) {
	    for(strand=0;strand<=1;strand++) {
	      for(U_Fil=1;U_Fil<=TR->N_Fil;U_Fil++) {
		for(reps = 1;reps<=(int)(VAR->Tot_Rep/TR->Repeat);reps++) {
		  Points++;
		  Arg = Cnst.Two_Pi*(h*TR->RX[Points]+
				     k*TR->RY[Points]+
				     l*TR->RZ[Points]);
		  Cmpnt_1 += Sph_Fac*cos(Arg);
		  Cmpnt_2 += Sph_Fac*sin(Arg);
		}
	      }
	    }
	  }
	}    
		    
	if((VAR->BBone) && (BB->Model == 0)) {
	  Points = 0;
	  Sb = Cnst.Two_Pi*BB->Sph_Sz*sqrt(SQR(R_Rad)+SQR((double)l/VAR->Tot_Rep));
	  Sph_Fac = CUBE(BB->Sph_Sz)*(sin(Sb)-Sb*cos(Sb))/CUBE(Sb);
	  for(Mol=0;Mol<=BB->N_Pts;Mol++) {
	    for(reps=1;reps<=(int)(VAR->Tot_Rep/BB->Repeat);reps++) {
	      Points++;
	      Arg = Cnst.Two_Pi*(h*BB->RX[Points]+
				 k*BB->RY[Points]+
				 l*BB->RZ[Points]);
	      Cmpnt_1 += Sph_Fac*cos(Arg);
	      Cmpnt_2 += Sph_Fac*sin(Arg);     
	    }
	  }
	}
	ID->CI[Rad][l] += Cmpnt_1*Cmpnt_1+Cmpnt_2*Cmpnt_2;
	if(VAR->Fourier_Diff + VAR->Observed + VAR->Reflections == TRUE) {
	  ID->FD_Cal[h][k][l] = sqrt(Cmpnt_1*Cmpnt_1+Cmpnt_2*Cmpnt_2);
	  ID->FD_Cal_Ph[h][k][l] = atan2(Cmpnt_2,Cmpnt_1)/Cnst.DTR;
	}
      }
    }
  }
}

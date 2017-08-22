#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

void Output()
{
  extern struct Info *VAR;
  extern struct Myosin *MY;
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct Tropomyosin *TR;
  extern struct Actin *AA;
  extern struct BackBone *BB;
  extern struct Constant Cnst;
  extern struct Intensity *ID;

  int Head,Level,h,k,l,Rad,MERID;
  double psi;
  double TOCF,TCIS,TCMS,TOCMF;
  double TCA,TCM,TOM,TOA;
 
  if(VAR->View) {
    View_Output();
    return;
  }  
  if((VAR->Fourier_Diff) || (VAR->Reflections) || (VAR->Observed)) {
    TCA = TCM = TOA = TOM = 0.0;
    printf("\n  Writing To Output Stream................ %s\n\n",VAR->Output_File);
    for(l = 0;l<=ID->l_max;l++) {
      for(h = -ID->h_max;h<=ID->h_max;h++) {
	for(k = -ID->k_max;k<=ID->k_max;k++) {       
	  Rad = abs(h*h+k*k+h*k);
	  if(Rad > ID->R_max) continue;
	  psi =  atan2((2.0*k+h),Cnst.Root_t*h);
	  if((psi >= VAR->Max_Angle) || (psi < VAR->Min_Angle )) continue;
	  ID->Mul[Rad][l]++;
	}
      }	  
    }
    if(!VAR->Scale_Data) {
      for(l = 0;l<=ID->l_max;l++) {
	for(h = -ID->h_max;h<=ID->h_max;h++) {
	  for(k = -ID->k_max;k<=ID->k_max;k++) {
	    Rad = abs(h*h+k*k+h*k);
	    if(Rad > ID->R_max) continue;
	    psi =  atan2((2.0*k+h),Cnst.Root_t*h);
	    if((psi >= VAR->Max_Angle) || (psi < VAR->Min_Angle )) continue;
	    if(ID->SD[Rad][l] == 0.0) continue;
	    if(VAR->Weighting)
	      ID->FD_Obs[h][k][l] = sqrt(ID->OI[Rad][l]*SQR(ID->FD_Cal[h][k][l])/ID->CI[Rad][l]);
	    else ID->FD_Obs[h][k][l] = sqrt(ID->OI[Rad][l]/(double)ID->Mul[Rad][l]);
	    if(Rad == 0) {
	      TCM += ID->FD_Cal[h][k][l];
	      TOM += ID->FD_Obs[h][k][l];
	      continue; 
	    }
	    TCA += ID->FD_Cal[h][k][l];
	    TOA += ID->FD_Obs[h][k][l];
	  }
	}
      }
      if(TCA == 0.0) VAR->Scale[OFFMERID] = 0.0;
      else VAR->Scale[OFFMERID] = TOA/TCA;
      if(TCM == 0.0) VAR->Scale[ONMERID] = 0.0;
      else VAR->Scale[ONMERID] = TOM/TCM;
    }
    for(l = 0;l<=ID->l_max;l++) {
      for(h = -ID->h_max;h<=ID->h_max;h++) {
	for(k = -ID->k_max;k<=ID->k_max;k++) {       
	  Rad = abs(h*h+k*k+h*k);
	  if(Rad > ID->R_max) continue;
	  if(!VAR->Scale_Data) 
	    if(Rad == 0) continue;
	  psi =  atan2((2.0*k+h),Cnst.Root_t*h);
	  if((psi >= VAR->Max_Angle) || (psi < VAR->Min_Angle )) continue;
	  if(ID->SD[Rad][l] == 0.0) continue;
	  if(Rad == 0) 
	    MERID = ONMERID;
	  else MERID = OFFMERID;
	  if(VAR->Observed) {
	    fprintf(VAR->Output,"%3d %3d %3d    %12.10e   %12.10f\n",
		    h,k,l,ID->FD_Obs[h][k][l],ID->FD_Cal_Ph[h][k][l]);
	  }
	  if(VAR->Reflections) {
	    fprintf(VAR->Output,"%3d %3d %3d    %12.10e   %12.10f\n",
		    h,k,l,VAR->Scale[MERID]*ID->FD_Cal[h][k][l],
		    ID->FD_Cal_Ph[h][k][l]);
	  }			 
	  if(VAR->Fourier_Diff) {
	    fprintf(VAR->Output,"%3d %3d %3d    ",h,k,l);
	    fprintf(VAR->Output,"%12.10e   ",
		    ID->FD_Obs[h][k][l] -  VAR->Scale[MERID]*ID->FD_Cal[h][k][l]);
	    fprintf(VAR->Output,"%12.10f\n",ID->FD_Cal_Ph[h][k][l]);
	  }
	}
      }
    }
    printf("  Meridional Scaling...................... %10.8e\n",VAR->Scale[ONMERID]);
    printf("  Off-Meridional Scaling.................. %10.8e\n",VAR->Scale[OFFMERID]);
    return;
  }

  if(VAR->HKLOutput) {
    TOCF = TCIS = TCMS = TOCMF = 0.0;
    printf("\n  Writing To Output Stream................ %s\n\n",VAR->Output_File);

    fprintf(VAR->Output,"BRAGG\n");
    fprintf(VAR->Output,"CELL\t%6.2f\t%6.2f\t%6.2f\t90\t90\t120\n",VAR->U_Cl,VAR->U_Cl,VAR->Tot_Rep);
    fprintf(VAR->Output,"DELTA 0.0\n");
    if(!VAR->Scale_Data) {
      for(l = 0;l<=ID->l_max;l++) {
	for(h = -ID->h_max;h<=ID->h_max;h++) {
	  for(k = -ID->k_max;k<=ID->k_max;k++) {
	    Rad = abs(h*h+k*k+h*k);
	    if(Rad > ID->R_max) continue;
	    psi =  atan2((2.0*k+h),Cnst.Root_t*h);
	    if((psi >= VAR->Max_Angle) || (psi < VAR->Min_Angle )) continue;
	    if(ID->SD[Rad][l] == 0.0) continue;
	    if(Rad == 0) {
	      TCMS  += ID->CI[Rad][l];
	      TOCMF += ID->OI[Rad][l];
	      continue; 
	    }
	    TCIS += ID->CI[Rad][l];
	    TOCF += ID->OI[Rad][l];
	  }
	}
      }
      if(TCIS == 0.0) VAR->Scale[OFFMERID] = 0.0;
      else VAR->Scale[OFFMERID] = TOCF/TCIS;
      if(TCMS == 0.0) VAR->Scale[ONMERID] = 0.0;
      else VAR->Scale[ONMERID] = TOCMF/TCMS;
    }
    for(l = 0;l<=ID->l_max;l++) {
      for(Rad = 0;Rad<=ID->R_max;Rad++) {
	if(ID->SD[Rad][l] == 0.0) continue;
	if(Rad == 0) MERID = ONMERID;
	else MERID = OFFMERID;

	if(VAR->ccp13) fprintf(VAR->Output,"%3d %3d %3d   1.0  1   %e   %e\n",
			       ID->h_i[Rad][l],ID->k_i[Rad][l],l,
			       VAR->Scale[MERID]*ID->CI[Rad][l],ID->SD[Rad][l]);
	else fprintf(VAR->Output,"%3d %3d %3d  %e\n",ID->h_i[Rad][l],ID->k_i[Rad][l],l,
		     VAR->Scale[MERID]*ID->CI[Rad][l]);
      }
    }
    printf("  Meridional Scaling...................... %10.8e\n",VAR->Scale[ONMERID]);
    printf("  Off-Meridional Scaling.................. %10.8e\n",VAR->Scale[OFFMERID]);
    return;
  }

  if(VAR->Global) {
    if(VAR->Myo) {
      for(Head=1;Head<=MY->N_Hds;Head++) {
	if(MY->Slew[Head].Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Slew[Head].Val/Cnst.DTR);
	if(MY->Tilt[Head].Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Tilt[Head].Val/Cnst.DTR);
	if(MY->Rot[Head].Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Rot[Head].Val/Cnst.DTR);
	for(Level=1;Level<=MY->N_Crwns;Level++) {
	  if(MY->PSlew[Level][Head].Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->PSlew[Level][Head].Val/Cnst.DTR);
	  if(MY->PTilt[Level][Head].Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->PTilt[Level][Head].Val/Cnst.DTR);
	  if(MY->PRot[Level][Head].Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->PRot[Level][Head].Val/Cnst.DTR);
	}
      }
      for(Level=1;Level<=MY->N_Crwns;Level++) {
	if(MY->PRad[Level].Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->PRad[Level].Val);
	if(MY->PAxial[Level].Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->PAxial[Level].Val);
	if(MY->PAzi[Level].Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->PAzi[Level].Val/Cnst.DTR);
      }
      if(MY->Hd_Sp.Stp > SMALL)    fprintf(VAR->Output,"%6.2f ",MY->Hd_Sp.Val);
      if(MY->Hd_An.Stp > SMALL)    fprintf(VAR->Output,"%6.2f ",MY->Hd_An.Val/Cnst.DTR);
      if(MY->Rad.Stp > SMALL)      fprintf(VAR->Output,"%6.2f ",MY->Rad.Val);
      if(MY->Lat.Stp > SMALL)      fprintf(VAR->Output,"%6.2f ",MY->Lat.Val/Cnst.DTR);
      if(MY->Piv_Tilt1.Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Piv_Tilt1.Val/Cnst.DTR);
      if(MY->Piv_Slew1.Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Piv_Slew1.Val/Cnst.DTR);
      if(MY->Piv_Rot1.Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Piv_Rot1.Val/Cnst.DTR);
      if(MY->Piv_Tilt2.Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Piv_Tilt2.Val/Cnst.DTR);
      if(MY->Piv_Slew2.Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Piv_Slew2.Val/Cnst.DTR);
      if(MY->Piv_Rot2.Stp > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Piv_Rot2.Val/Cnst.DTR);
    }
    if(VAR->CPro) {
      if(CP->Tilt.Stp > SMALL)       fprintf(VAR->Output,"%6.2f ",CP->Tilt.Val/Cnst.DTR);
      if(CP->Pivot_Tilt.Stp > SMALL) fprintf(VAR->Output,"%6.2f ",CP->Pivot_Tilt.Val/Cnst.DTR);
      if(CP->Pivot_Slew.Stp > SMALL) fprintf(VAR->Output,"%6.2f ",CP->Pivot_Slew.Val/Cnst.DTR);
      if(CP->Azi.Stp > SMALL)        fprintf(VAR->Output,"%6.2f ",CP->Azi.Val/Cnst.DTR);
      if(CP->Rad.Stp > SMALL)        fprintf(VAR->Output,"%6.2f ",CP->Rad.Val);
      if(CP->Axial.Stp > SMALL)      fprintf(VAR->Output,"%6.2f ",CP->Axial.Val);
      if(CP->Weight.Stp > SMALL)     fprintf(VAR->Output,"%6.2f ",CP->Weight.Val);
    }
    if(VAR->Titin) {
      if(TT->Azi.Stp > SMALL)    fprintf(VAR->Output,"%6.2f ",TT->Azi.Val/Cnst.DTR);
      if(TT->Rad.Stp > SMALL)    fprintf(VAR->Output,"%6.2f ",TT->Rad.Val);
      if(TT->Weight.Stp > SMALL) fprintf(VAR->Output,"%6.2f ",TT->Weight.Val);
    }
    if(VAR->BBone) if(BB->Model == 0) {
      if(BB->Azi.Stp > SMALL) fprintf(VAR->Output,"%6.2f ",BB->Azi.Val/Cnst.DTR);
    }    
    if(VAR->Actin) {
      if(AA->Weight.Stp > SMALL) fprintf(VAR->Output,"%6.2f ",AA->Weight.Val);
    }
    if(VAR->Tropomyosin) {
      if(TR->Weight.Stp > SMALL) fprintf(VAR->Output,"%6.2f ",TR->Weight.Val);
    }
  }
     
  if((VAR->Torus) || (VAR->Simplex) || (VAR->Powell) || (VAR->Anneal) || (VAR->Replex)) {
    if(VAR->Myo) {
      for(Head=1;Head<=MY->N_Hds;Head++) {
	if(MY->Slew[Head].Scl > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Slew[Head].Val/Cnst.DTR);
	if(MY->Tilt[Head].Scl > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Tilt[Head].Val/Cnst.DTR);
	if(MY->Rot[Head].Scl > SMALL)  fprintf(VAR->Output,"%6.2f ",MY->Rot[Head].Val/Cnst.DTR);
	for(Level=1;Level<=MY->N_Crwns;Level++) {
	  if(MY->PSlew[Level][Head].Scl > SMALL) fprintf(VAR->Output,"%6.2f ",MY->PSlew[Level][Head].Val/Cnst.DTR);
	  if(MY->PTilt[Level][Head].Scl > SMALL) fprintf(VAR->Output,"%6.2f ",MY->PTilt[Level][Head].Val/Cnst.DTR);
	  if(MY->PRot[Level][Head].Scl > SMALL) fprintf(VAR->Output,"%6.2f ",MY->PRot[Level][Head].Val/Cnst.DTR);
	}
      }
      for(Level=1;Level<=MY->N_Crwns;Level++) {
	if(MY->PRad[Level].Scl > SMALL)    fprintf(VAR->Output,"%6.2f ",MY->PRad[Level].Val);
	if(MY->PAxial[Level].Scl > SMALL)  fprintf(VAR->Output,"%6.2f ",MY->PAxial[Level].Val);
	if(MY->PAzi[Level].Scl > SMALL)    fprintf(VAR->Output,"%6.2f ",MY->PAzi[Level].Val/Cnst.DTR);
      }
      if(MY->Hd_Sp.Scl > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Hd_Sp.Val);
      if(MY->Hd_An.Scl > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Hd_An.Val/Cnst.DTR);
      if(MY->Rad.Scl > SMALL)   fprintf(VAR->Output,"%6.2f ",MY->Rad.Val);
      if(MY->Lat.Scl > SMALL)   fprintf(VAR->Output,"%6.2f ",MY->Lat.Val/Cnst.DTR);
      if(MY->Piv_Tilt1.Scl > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Piv_Tilt1.Val/Cnst.DTR);
      if(MY->Piv_Slew1.Scl > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Piv_Slew1.Val/Cnst.DTR);
      if(MY->Piv_Rot1.Scl > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Piv_Rot1.Val/Cnst.DTR);
      if(MY->Piv_Tilt2.Scl > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Piv_Tilt2.Val/Cnst.DTR);
      if(MY->Piv_Slew2.Scl > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Piv_Slew2.Val/Cnst.DTR);
      if(MY->Piv_Rot2.Scl > SMALL) fprintf(VAR->Output,"%6.2f ",MY->Piv_Rot2.Val/Cnst.DTR);      
    }
    if(VAR->CPro) {
      if(CP->Tilt.Scl > SMALL)       fprintf(VAR->Output,"%6.2f ",CP->Tilt.Val/Cnst.DTR);
      if(CP->Pivot_Tilt.Scl > SMALL) fprintf(VAR->Output,"%6.2f ",CP->Pivot_Tilt.Val/Cnst.DTR);
      if(CP->Pivot_Slew.Scl > SMALL) fprintf(VAR->Output,"%6.2f ",CP->Pivot_Slew.Val/Cnst.DTR);
      if(CP->Azi.Scl > SMALL)        fprintf(VAR->Output,"%6.2f ",CP->Azi.Val/Cnst.DTR);
      if(CP->Rad.Scl > SMALL)        fprintf(VAR->Output,"%6.2f ",CP->Rad.Val);
      if(CP->Axial.Scl > SMALL)      fprintf(VAR->Output,"%6.2f ",CP->Axial.Val);
      if(CP->Weight.Scl > SMALL)     fprintf(VAR->Output,"%6.2f ",CP->Weight.Val);
    }
    if(VAR->Titin) {
      if(TT->Azi.Scl > SMALL)    fprintf(VAR->Output,"%6.2f ",TT->Azi.Val/Cnst.DTR);
      if(TT->Rad.Scl > SMALL)    fprintf(VAR->Output,"%6.2f ",TT->Rad.Val);
      if(TT->Weight.Scl > SMALL) fprintf(VAR->Output,"%6.2f ",TT->Weight.Val);  
    }
    if(VAR->BBone) if(BB->Model == 0) {
      if(BB->Azi.Scl > SMALL) {
	fprintf(VAR->Output,"%6.2f ",BB->Azi.Val/Cnst.DTR);
      }
    }
    if(VAR->Actin) {
      if(AA->Weight.Scl > SMALL) {
	fprintf(VAR->Output,"%6.2f ",AA->Weight.Val);
      }
    }
    if(VAR->Tropomyosin) {
      if(TR->Weight.Scl > SMALL) {
	fprintf(VAR->Output,"%6.2f ",TR->Weight.Val);
      }  
    }
  }
  if(VAR->Least_Sq) {
    if(VAR->Weighting) WLeast_SQR();
    else Least_SQR();
    fprintf(VAR->Output,"%5.3e  %5.3e  ",ID->R_Fac,ID->MR_Fac);
    if(VAR->Scoring) fprintf(VAR->Output,"%d/%d  %d/%d  ",
			     ID->N_Ref-ID->MRD,
			     ID->N_Ref,
			     ID->NM_Ref-ID->MMRD,
			     ID->NM_Ref);
  }
  if(VAR->Cryst) {
    if(VAR->Weighting) WCrystal();
    else Crystal();
    fprintf(VAR->Output,"%5.3e  %5.3e  ",ID->R_Fac,ID->MR_Fac);
    if(VAR->Scoring) fprintf(VAR->Output,"%d/%d  %d/%d  ",
			     ID->N_Ref-ID->MRD,
			     ID->N_Ref,
			     ID->NM_Ref-ID->MMRD,
			     ID->NM_Ref);
  }
  if(VAR->Corr) {
    Correlation();
    fprintf(VAR->Output,"%5.3e  %5.3e  ",ID->C_Fac,ID->MC_Fac);
  }
  fprintf(VAR->Output,"\n");
  return;
}

void Finish()
{
  extern struct Info *VAR;
  extern struct Constant Cnst;
  extern struct Intensity *ID;
  extern struct Tropomyosin *TR;
  extern struct Actin *AA;
  extern struct Myosin *MY;
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct BackBone *BB;

  int Head,Level;

  fprintf(VAR->Output,"\n");
  if(VAR->Myo) {
    fprintf(VAR->Output,"Myosin Parameters\n");
    for(Head=1;Head<=MY->N_Hds;Head++) {
      fprintf(VAR->Output,"\t Slew_%d = %15.10f\n",Head,MY->Slew[Head].Val/Cnst.DTR);
      fprintf(VAR->Output,"\t Tilt_%d = %15.10f\n",Head,MY->Tilt[Head].Val/Cnst.DTR);
      fprintf(VAR->Output,"\t  Rot_%d = %15.10f\n",Head,MY->Rot[Head].Val/Cnst.DTR);
      for(Level=1;Level<=MY->N_Crwns;Level++) {
	fprintf(VAR->Output,"\t PSlew_%d%d = %15.10f\n",Level,Head,MY->PSlew[Level][Head].Val/Cnst.DTR);
	fprintf(VAR->Output,"\t PTilt_%d%d = %15.10f\n",Level,Head,MY->PTilt[Level][Head].Val/Cnst.DTR);
	fprintf(VAR->Output,"\t  PRot_%d%d = %15.10f\n",Level,Head,MY->PRot[Level][Head].Val/Cnst.DTR);
      } 
    }
    for(Level=1;Level<=MY->N_Crwns;Level++) {
      fprintf(VAR->Output,"\t   PRad_%d = %15.10f\n",Level,MY->PRad[Level].Val);
      fprintf(VAR->Output,"\t PAxial_%d = %15.10f\n",Level,MY->PAxial[Level].Val);
      fprintf(VAR->Output,"\t   PAzi_%d = %15.10f\n",Level,MY->PAzi[Level].Val/Cnst.DTR);
    }
    fprintf(VAR->Output,"\t  Head Sep = %15.10f\n",MY->Hd_Sp.Val);
    fprintf(VAR->Output,"\t  Head Ang = %15.10f\n",MY->Hd_An.Val/Cnst.DTR);
    fprintf(VAR->Output,"\t    Radius = %15.10f\n",MY->Rad.Val);
    fprintf(VAR->Output,"\t  Latt Rot = %15.10f\n",MY->Lat.Val/Cnst.DTR);
    fprintf(VAR->Output,"\tPivot Tilt1 = %15.10f\n",MY->Piv_Tilt1.Val/Cnst.DTR);
    fprintf(VAR->Output,"\tPivot Slew1 = %15.10f\n",MY->Piv_Slew1.Val/Cnst.DTR);
    fprintf(VAR->Output,"\tPivot Rot 1= %15.10f\n",MY->Piv_Rot1.Val/Cnst.DTR);
    fprintf(VAR->Output,"\tPivot Tilt2 = %15.10f\n",MY->Piv_Tilt2.Val/Cnst.DTR);
    fprintf(VAR->Output,"\tPivot Slew2 = %15.10f\n",MY->Piv_Slew2.Val/Cnst.DTR);
    fprintf(VAR->Output,"\tPivot Rot 2= %15.10f\n",MY->Piv_Rot2.Val/Cnst.DTR);
  }
  if(VAR->CPro) {
    fprintf(VAR->Output,"C-Protein Parameters\n");
    fprintf(VAR->Output,"\t   Tilt = %15.10f\n",CP->Tilt.Val/Cnst.DTR);
    fprintf(VAR->Output,"\t P Tilt = %15.10f\n",CP->Pivot_Tilt.Val/Cnst.DTR);
    if(CP->Pivot_Type == 2) {
      fprintf(VAR->Output,"\t P Slew = %15.10f\n",CP->Pivot_Slew.Val/Cnst.DTR);
    }
    fprintf(VAR->Output,"\tAzimuth = %15.10f\n",CP->Azi.Val/Cnst.DTR);
    fprintf(VAR->Output,"\t Radius = %15.10f\n",CP->Rad.Val);
    fprintf(VAR->Output,"\t Weight = %15.10f\n",CP->Weight.Val);
    fprintf(VAR->Output,"\t  Axial = %15.10f\n",CP->Axial.Val);
  }
  if(VAR->Titin) {
    fprintf(VAR->Output,"Titin Parameters\n");
    fprintf(VAR->Output,"\tAzimuth = %15.10f\n",TT->Azi.Val/Cnst.DTR);
    fprintf(VAR->Output,"\t Radius = %15.10f\n",TT->Rad.Val);
    fprintf(VAR->Output,"\t Weight = %15.10f\n",TT->Weight.Val);
  }
  if(VAR->BBone) {
    fprintf(VAR->Output,"BackBone Parameters\n");
    fprintf(VAR->Output,"\tAzimuth = %15.10f\n",BB->Azi.Val/Cnst.DTR);
  }
  if(VAR->Actin) {
    fprintf(VAR->Output,"Actin Parameters\n");
    fprintf(VAR->Output,"\t Weight = %15.10f\n",AA->Weight.Val);
  }
  if(VAR->Tropomyosin) {
    fprintf(VAR->Output,"Tropomyosin Parameters\n");
    fprintf(VAR->Output,"\t Weight = %15.10f\n",TR->Weight.Val);
  }
  if((VAR->Simplex) || (VAR->Global) || (VAR->Anneal) || (VAR->Replex) || (VAR->Torus)) 
    fprintf(VAR->Output,"\n No of iterations = %d\n",VAR->Iterations);
     
  if((VAR->Least_Sq) && (!VAR->Weighting)) {
    fprintf(VAR->Output,"\n  R-Factor = %10.8e\n",ID->R_Fac);
    fprintf(VAR->Output,"  MR-Factor = %10.8e\n",ID->MR_Fac);
  }
  if(VAR->Weighting) {
    fprintf(VAR->Output,"\n Weighted  R-Factor = %10.8e\n",ID->R_Fac);
    fprintf(VAR->Output," Weighted MR-Factor = %10.8e\n",ID->MR_Fac);
  }
  if(VAR->Scoring) {
    fprintf(VAR->Output,"\n Off Meridonal Score - %d/%d\n",ID->N_Ref-ID->MRD,ID->N_Ref);
    fprintf(VAR->Output," Meridional Score    - %d/%d\n",ID->NM_Ref-ID->MMRD,ID->NM_Ref);
  }
  if(VAR->Corr) {
    fprintf(VAR->Output,"\n  Correlation Factor = %10.8e\n",ID->C_Fac);
    fprintf(VAR->Output," MCorrelation Factor = %10.8e\n",ID->MC_Fac);    
  }
}

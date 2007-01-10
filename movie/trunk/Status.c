#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

void Status(FILE *output)
{
  extern struct Info *VAR;
  extern struct Intensity *ID;
  extern struct Myosin *MY;
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct BackBone *BB;
  extern struct Tropomyosin *TR;
  extern struct Actin *AA;

  int Head,Level,Domain;
  char *status[] = {"DISABLED","ENABLED"};

  fprintf(output,"\n                                Current Status\n");
  fprintf(output,"\nModelling Method - \n");
  fprintf(output,"   Global Parameter Search  : %8s",status[VAR->Global]);
  fprintf(output,"   Down Hill Simplex Method : %8s\n",status[VAR->Simplex]);
  fprintf(output,"   Powell's Method          : %8s",status[VAR->Powell]);
  fprintf(output,"   View Model               : %8s\n",status[VAR->View]);
  fprintf(output,"   View Intensities         : %8s",status[VAR->HKLOutput]);
  fprintf(output,"   Combined Refinement      : %8s\n",status[VAR->Combine]);
  fprintf(output,"   Simulated Annealing      : %8s",status[VAR->Anneal]);
  fprintf(output,"   Fourier Difference       : %8s\n",status[VAR->Fourier_Diff]);
  fprintf(output,"   Output Reflections       : %8s",status[VAR->Reflections]);
  fprintf(output,"   Obs Output Reflections   : %8s\n",status[VAR->Observed]);
  fprintf(output,"   Down Hill Replex Method  : %8s",status[VAR->Replex]);
  fprintf(output,"   Stochastic Torus Method  : %8s\n",status[VAR->Torus]);
  fprintf(output,"\nSimilarity Measure - \n");
  fprintf(output,"   Least Squares R-factor   : %8s",status[VAR->Least_Sq]);
  fprintf(output,"   Simularity Weighting     : %8s\n",status[VAR->Weighting]);
  fprintf(output,"   Correlation Function     : %8s",status[VAR->Corr]);
  fprintf(output,"   Crystallographic R-factor: %8s\n",status[VAR->Cryst]);
  fprintf(output,"   Scoring Method           : %8s",status[VAR->Scoring]);
  fprintf(output,"   Manually Scale Data      : %8s\n",status[VAR->Scale_Data]);
  fprintf(output,"\nModel Components - \n");
  fprintf(output,"   Myosin Coordinates       : %8s",status[VAR->Myo]);
  fprintf(output,"   C_Protein Coordinates    : %8s\n",status[VAR->CPro]);
  fprintf(output,"   Titin Coordinates        : %8s",status[VAR->Titin]);
  fprintf(output,"   BackBone Coordinates     : %8s\n",status[VAR->BBone]);
  fprintf(output,"   Actin Coordinates        : %8s",status[VAR->Actin]);
  fprintf(output,"   Tropomyosin Coordinates  : %8s\n",status[VAR->Tropomyosin]);
  fprintf(output,"\nMiscellanous BOOL's - \n");
  fprintf(output,"   OneShot Iteration        : %8s",status[VAR->OneShot]);
  fprintf(output,"   Generate Bogus Data      : %8s\n",status[VAR->BogusData]);
  fprintf(output,"   BrookeHaven S1           : %8s",status[VAR->BrookeHaven]);
  fprintf(output,"   No Perturbations         : %8s\n",status[VAR->NoPerts]);
  if(VAR->View) {
    fprintf(output,"\nOutput View Data Type - \n");
    fprintf(output,"   Output Data For AVS      : %8s",status[VAR->Avs]);
    fprintf(output,"   Output Data For DesignCad: %8s\n",status[VAR->DCad]);
    fprintf(output,"   Output Data In PDB Format: %8s\n",status[VAR->Pdb]);
  }
  fprintf(output,"\nSearch Range - \n");
  if(VAR->Myo) {
    fprintf(output,"Myosin Positional Parameters:\n");
    fprintf(output,"     Rot Lat - %+9.4f  to %+9.4f  Step %+9.4f, Scale %+9.4f\n",
	    MY->Lat.St,
	    ((MY->Lat.Stp-1)*MY->Lat.Sz)+MY->Lat.St,
	    MY->Lat.Sz,
	    MY->Lat.Scl);
    fprintf(output,"      Radius - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    MY->Rad.St,
	    ((MY->Rad.Stp-1)*MY->Rad.Sz)+MY->Rad.St,
	    MY->Rad.Sz,
	    MY->Rad.Scl);
    fprintf(output,"    Head Sep - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    MY->Hd_Sp.St,
	    ((MY->Hd_Sp.Stp-1)*MY->Hd_Sp.Sz)+MY->Hd_Sp.St,
	    MY->Hd_Sp.Sz,
	    MY->Hd_Sp.Scl);
    fprintf(output,"  Head Angle - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    MY->Hd_An.St,
	    ((MY->Hd_An.Stp-1)*MY->Hd_An.Sz)+MY->Hd_An.St,
	    MY->Hd_An.Sz,
	    MY->Hd_An.Scl);
    fprintf(output,"  Pivot Tilt1 - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    MY->Piv_Tilt1.St,
	    ((MY->Piv_Tilt1.Stp-1)*MY->Piv_Tilt1.Sz)+MY->Piv_Tilt1.St,
	    MY->Piv_Tilt1.Sz,
	    MY->Piv_Tilt1.Scl);
    fprintf(output,"  Pivot Slew1 - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    MY->Piv_Slew1.St,
	    ((MY->Piv_Slew1.Stp-1)*MY->Piv_Slew1.Sz)+MY->Piv_Slew1.St,
	    MY->Piv_Slew1.Sz,
	    MY->Piv_Slew1.Scl);
    fprintf(output,"  Pivot Rot1 - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    MY->Piv_Rot1.St,
	    ((MY->Piv_Rot1.Stp-1)*MY->Piv_Rot1.Sz)+MY->Piv_Rot1.St,
	    MY->Piv_Rot1.Sz,
	    MY->Piv_Rot1.Scl);
    fprintf(output,"  Pivot Tilt2 - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    MY->Piv_Tilt2.St,
	    ((MY->Piv_Tilt2.Stp-1)*MY->Piv_Tilt2.Sz)+MY->Piv_Tilt2.St,
	    MY->Piv_Tilt2.Sz,
	    MY->Piv_Tilt2.Scl);
    fprintf(output,"  Pivot Slew2 - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    MY->Piv_Slew2.St,
	    ((MY->Piv_Slew2.Stp-1)*MY->Piv_Slew2.Sz)+MY->Piv_Slew2.St,
	    MY->Piv_Slew2.Sz,
	    MY->Piv_Slew2.Scl);
    fprintf(output,"  Pivot Rot2 - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    MY->Piv_Rot2.St,
	    ((MY->Piv_Rot2.Stp-1)*MY->Piv_Rot2.Sz)+MY->Piv_Rot2.St,
	    MY->Piv_Rot2.Sz,
	    MY->Piv_Rot2.Scl);	    

    fprintf(output,"\n\n");
    for(Head=1;Head<=MY->N_Hds;Head++) {
      fprintf(output,"Head %d: Slew - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	      Head,
	      MY->Slew[Head].St,
	      ((MY->Slew[Head].Stp-1)*MY->Slew[Head].Sz)+MY->Slew[Head].St,
	      MY->Slew[Head].Sz,
	      MY->Slew[Head].Scl);
      fprintf(output,"        Tilt - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	      MY->Tilt[Head].St,
	      ((MY->Tilt[Head].Stp-1)*MY->Tilt[Head].Sz)+MY->Tilt[Head].St,
	      MY->Tilt[Head].Sz,
	      MY->Tilt[Head].Scl);
      fprintf(output,"        Rot  - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	      MY->Rot[Head].St,
	      ((MY->Rot[Head].Stp-1)*MY->Rot[Head].Sz)+MY->Rot[Head].St,
	      MY->Rot[Head].Sz,
	      MY->Rot[Head].Scl);
    }
    fprintf(output,"\n\n");
    for(Head=1;Head<=MY->N_Hds;Head++) {
      for(Level=1;Level<=MY->N_Crwns;Level++) {
	fprintf(output,"Level %d Head %d:   PSlew - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
		Level,
		Head,MY->PSlew[Level][Head].St,
		((MY->PSlew[Level][Head].Stp-1)*MY->PSlew[Level][Head].Sz)+MY->PSlew[Level][Head].St,
		MY->PSlew[Level][Head].Sz,
		MY->PSlew[Level][Head].Scl);
	fprintf(output,"                  PTilt - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
		MY->PTilt[Level][Head].St,
		((MY->PTilt[Level][Head].Stp-1)*MY->PTilt[Level][Head].Sz)+MY->PTilt[Level][Head].St,
		MY->PTilt[Level][Head].Sz,
		MY->PTilt[Level][Head].Scl);
	fprintf(output,"                  PRot  - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
		MY->PRot[Level][Head].St,
		((MY->PRot[Level][Head].Stp-1)*MY->PRot[Level][Head].Sz)+MY->PRot[Level][Head].St,
		MY->PRot[Level][Head].Sz,
		MY->PRot[Level][Head].Scl);
      }
    }
    fprintf(output,"\n");
    for(Level=1;Level<=MY->N_Crwns;Level++) {   
      fprintf(output,"    Level %d:       PRad - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	      Level,
	      MY->PRad[Level].St,
	      ((MY->PRad[Level].Stp-1)*MY->PRad[Level].Sz)+MY->PRad[Level].St,
	      MY->PRad[Level].Sz,
	      MY->PRad[Level].Scl);
      fprintf(output,"                 PAxial - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	      MY->PAxial[Level].St,
	      ((MY->PAxial[Level].Stp-1)*MY->PAxial[Level].Sz)+MY->PAxial[Level].St,
	      MY->PAxial[Level].Sz,
	      MY->PAxial[Level].Scl);
      fprintf(output,"             PAzimuthal - %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	      MY->PAzi[Level].St,
	      ((MY->PAzi[Level].Stp-1)*MY->PAzi[Level].Sz)+MY->PAzi[Level].St,
	      MY->PAzi[Level].Sz,
	      MY->PAzi[Level].Scl);
    }
  }
  if(VAR->CPro) {
    fprintf(output,"C-Protein Positional Parameters:\n");
    fprintf(output,"      Tilt = %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    CP->Tilt.St,
	    ((CP->Tilt.Stp-1)*CP->Tilt.Sz)+CP->Tilt.St,
	    CP->Tilt.Sz,
	    CP->Tilt.Scl);
    fprintf(output,"Pivot Tilt = %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    CP->Pivot_Tilt.St,
	    ((CP->Pivot_Tilt.Stp-1)*CP->Pivot_Tilt.Sz)+CP->Pivot_Tilt.St,
	    CP->Pivot_Tilt.Sz,
	    CP->Pivot_Tilt.Scl);
    if(CP->Pivot_Type == 2) {
      fprintf(output,"Pivot Slew = %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	      CP->Pivot_Slew.St,
	      ((CP->Pivot_Slew.Stp-1)*CP->Pivot_Slew.Sz)+CP->Pivot_Slew.St,
	      CP->Pivot_Slew.Sz,
	      CP->Pivot_Slew.Scl);
    }
    fprintf(output,"   Azimuth = %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    CP->Azi.St,
	    ((CP->Azi.Stp-1)*CP->Azi.Sz)+CP->Azi.St,
	    CP->Azi.Sz,
	    CP->Azi.Scl);
    fprintf(output,"     Axial = %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    CP->Axial.St,
	    ((CP->Axial.Stp-1)*CP->Axial.Sz)+CP->Axial.St,CP->Axial.Sz,
	    CP->Axial.Scl);
    fprintf(output,"    Radius = %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    CP->Rad.St,
	    ((CP->Rad.Stp-1)*CP->Rad.Sz)+CP->Rad.St,
	    CP->Rad.Sz,
	    CP->Rad.Scl);
    fprintf(output,"    Weight = %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    CP->Weight.St,
	    ((CP->Weight.Stp-1)*CP->Weight.Sz)+CP->Weight.St,
	    CP->Weight.Sz,
	    CP->Weight.Scl);
  }
  if(VAR->Titin) {
    fprintf(output,"Titin Positional Parameters:\n");
    fprintf(output," Azimuth = %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    TT->Azi.St,
	    ((TT->Azi.Stp-1)*TT->Azi.Sz)+TT->Azi.St,
	    TT->Azi.Sz,
	    TT->Azi.Scl);
    fprintf(output,"  Radius = %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    TT->Rad.St,
	    ((TT->Rad.Stp-1)*TT->Rad.Sz)+TT->Rad.St,
	    TT->Rad.Sz,
	    TT->Rad.Scl);
    fprintf(output,"  Weight = %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    TT->Weight.St,
	    ((TT->Weight.Stp-1)*TT->Weight.Sz)+TT->Weight.St,
	    TT->Weight.Sz,
	    TT->Weight.Scl);
  }
  if(VAR->BBone) {
    fprintf(output,"BackBone positional parameters:\n");
    fprintf(output," Azimuth = %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    BB->Azi.St,
	    ((BB->Azi.Stp-1)*BB->Azi.Sz)+BB->Azi.St,
	    BB->Azi.Sz,
	    BB->Azi.Scl);
  }
  if(VAR->Tropomyosin) {
    fprintf(output,"Tropomyosin positional parameters:\n");
    fprintf(output,"  Weight = %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    TR->Weight.St,
	    ((TR->Weight.Stp-1)*TR->Weight.Sz)+TR->Weight.St,
	    TR->Weight.Sz,
	    TR->Weight.Scl);
  }
  if(VAR->Actin) {
    fprintf(output,"Actin positional parameters:\n");
    fprintf(output,"  Weight = %+9.4f  to %+9.4f  Step %+9.4f  Scale %+9.4f\n",
	    AA->Weight.St,
	    ((AA->Weight.Stp-1)*AA->Weight.Sz)+AA->Weight.St,
	    AA->Weight.Sz,
	    AA->Weight.Scl);
  }
  fprintf(output,"\n");
  if(VAR->Myo) {
    fprintf(output,"Myosin:\n");
    fprintf(output,"   Myosin Repeat            : %+9.4fA\n",MY->Repeat);
    fprintf(output,"   Myosin Crowns per Repeat : %d\n",MY->N_Crwns);
    fprintf(output,"   S1 Head Raster Size      : %4.2fA\n",MY->Raster);
    fprintf(output,"   S1 Head Sphere Size      : %4.2fA\n",MY->Sph_Sz);
    fprintf(output,"   S1 Head Filename         : %s\n",MY->S1_Head_File);
    fprintf(output,"   Pivotal Sphere Number    : %d\n",MY->Piv_Point);
    fprintf(output,"   Number Of Myosin Heads   : %d\n",MY->N_Hds);
    fprintf(output,"  Number of Turns In Repeat : %4.2f\n",MY->Rep_Level);
  }
  if(VAR->CPro) {
    fprintf(output,"C-Protein:\n");
    fprintf(output,"   Domain Radius            : %4.2fA\n",CP->Sph_Sz);
    fprintf(output,"   No. Of Domains           : %d\n",CP->Tot_SubU);
    fprintf(output,"   Domain Separation        : %4.2fA\n",CP->Dom_Sep);
    fprintf(output,"   Repeat                   : %4.2fA\n",CP->Repeat);
    fprintf(output,"   Type Of Model            : %d\n",CP->Pivot_Type);
    fprintf(output,"   Position Of Pivot        : %d\n",CP->Pivot);
  }
  if(VAR->Titin) {
    fprintf(output,"Titin:\n");
    fprintf(output,"   Domain Radius            : %4.2fA\n",TT->Sph_Sz);
    fprintf(output,"   No. Of Domains           : %d\n",TT->Tot_SubU);
    fprintf(output,"   Repeat                   : %4.2fA\n",TT->Repeat);
  }
  if(VAR->Tropomyosin) {
    fprintf(output,"\nTropomyosin Positional Parameters - \n");
    fprintf(output,"        Phi  - %7.4f\n",TR->Phi);
    fprintf(output,"     Radius  - %7.4f\n",TR->Rad);
    fprintf(output,"    Z-Pert.  - %7.4f\n",TR->Z_Pert);
    fprintf(output,"     Repeat  - %7.4f\n",TR->Repeat);
    fprintf(output,"Sphere Size  - %7.4f\n",TR->Sph_Sz);
    fprintf(output," Tot. Doms.  - %d\n",TR->Tot_SubU);
    fprintf(output,"   No. Fils  - %d\n",TR->N_Fil);
  }
  if(VAR->Actin) {
    fprintf(output,"\nActin Positional Parameters - \n");
    for(Domain=1;Domain<=AA->Tot_Dom;Domain++) {
      fprintf(output,"     Domain %d:       Phi - %7.2f  Z - %7.2f  Rad - %7.2f  Sph_Sz %7.2f\n",
	      Domain,
	      AA->Dom_Phi[Domain],
	      AA->Dom_Z[Domain],
	      AA->Dom_Rad[Domain],
	      AA->Sph_Sz[Domain]);
    }
    fprintf(output,"    Z-Pert.  - %7.4f\n",AA->Z_Pert);
    fprintf(output,"  Azi-Pert.  - %7.4f\n",AA->Azi_Pert);
    fprintf(output,"     Repeat  - %7.4f\n",AA->Repeat);
    fprintf(output,"Sub Domains  - %d\n",AA->Tot_Dom);
    fprintf(output,"Doms/Repeat  - %d\n",AA->Tot_SubU);
    fprintf(output,"   No. Fils  - %d\n",AA->N_Fil);
  }

  if(VAR->BBone) {
    fprintf(output,"BackBone:\n");
    fprintf(output,"   BackBone Model Type      : %d\n",BB->Model);
    if(BB->Model == 0) {
      fprintf(output,"   Sphere Size              : %4.2fA\n",BB->Sph_Sz);
      fprintf(output,"   BackBone Coordinates File: %s\n",BB->BackBone_File);
    }
    fprintf(output,"   Repeat                   : %4.2fA\n",BB->Repeat);
    if(BB->Model == 1) fprintf(output,"   BackBone Radius          : %+9.4f\n",BB->Rad);
  }
  fprintf(output,"\nGeneral Parameters - \n");
  fprintf(output,"   No Of Molecular Strands  : %d\n",VAR->N_Strnds);
  fprintf(output,"   Unit Cell Size           : %+9.4fA\n",VAR->U_Cl);
  fprintf(output,"   Score Deviations         : %d\n",ID->MSD);
  fprintf(output,"   Combine Weighting        : %2.1f\n",VAR->CWeight);
  fprintf(output,"   Number Of Filaments      : %d\n",VAR->No_Fils);
  fprintf(output,"   Resolution CutOff        : %2.1f\n",VAR->CutOff);
  if(VAR->NoPerts) {
    fprintf(output,"   Number of Jn Functions   : %d\n",ID->Bes_Num);
  }
  if(VAR->BogusData) {
    fprintf(output,"   Bogus Data Generated To  : %9.4fA\n",VAR->BogusDataRes);
  }
     
  if(VAR->Scale_Data) {
    fprintf(output,"   Off-Meridional Scaling   : %e\n",VAR->Scale[OFFMERID]);
    fprintf(output,"   Meridional Scaling       : %e\n",VAR->Scale[ONMERID]);
  }
  fprintf(output,"   Total Repeat Of Model    : %+9.4fA\n",VAR->Tot_Rep);
  fprintf(output,"   Intensity Filename       : %s\n",VAR->Intensity_File);
  fprintf(output,"   Data Output Filename     : %s\n",VAR->Output_File);
  if(VAR->Anneal) {
    fprintf(output,"   Temperature Factor       : %5.3f\n",VAR->A_Temp);
    fprintf(output,"   Annealing Schedule       : %d\n",VAR->A_Iter);
    fprintf(output,"   Temperture Drop Factor   : %+9.4f\n",VAR->DTemp);
  }
  fprintf(output,"\n");
}

void Write_Status()
{
  extern struct Info *VAR;
  extern struct Intensity *ID;
  extern struct Myosin *MY;
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct BackBone *BB;
  extern struct Tropomyosin *TR;
  extern struct Actin *AA;

  FILE *Write;
  int head,level,Domain;
  time_t The_Time;
  time(&The_Time);

  if((Write = fopen(VAR->Status_File,"w")) == NULL ) {
    printf("\nCannot Create %s ! \n",VAR->Status_File);
    return;
  }
  fprintf(Write,"#\n");
  fprintf(Write,"# MOVIE Parameter file. Created by L.Hudson at %s",ctime(&The_Time));
  fprintf(Write,"#\n");
  if(VAR->Global) fprintf(Write,"global\n");
  if(VAR->Simplex) fprintf(Write,"simplex\n");
  if(VAR->Replex) fprintf(Write,"replex\n");
  if(VAR->Torus) fprintf(Write,"torus\n");
  if(VAR->Powell) fprintf(Write,"powell\n");
  if(VAR->Scale_Data) fprintf(Write,"scaledata\n");
  if(VAR->Anneal) {
    fprintf(Write,"anneal\n");
    fprintf(Write,"temperature %f\n",VAR->A_Temp);
    fprintf(Write,"iterations %d\n",VAR->A_Iter);
    fprintf(Write,"tempdrop %f\n",VAR->DTemp);
  }
  if(VAR->View) {
    fprintf(Write,"view\n");
    if(VAR->Avs) fprintf(Write,"avs\n");
    if(VAR->DCad) fprintf(Write,"dcad\n");
    if(VAR->Pdb) fprintf(Write,"pdb\n");
  }
  if(VAR->NoPerts) {
    fprintf(Write,"noperts\n");
    fprintf(Write,"besnum %d\n",ID->Bes_Num);
  }
  if(VAR->BogusData) {
    fprintf(Write,"bogusdata\n");
    fprintf(Write,"bogusdatares %d\n",VAR->BogusDataRes);
  }
  if(VAR->BrookeHaven) fprintf(Write,"brookehaven\n");
  if(VAR->HKLOutput) fprintf(Write,"hkloutput\n");
  if(VAR->Fourier_Diff) fprintf(Write,"fourierdif\n");
  if(VAR->Reflections) fprintf(Write,"reflections\n");
  if(VAR->Observed) fprintf(Write,"observed\n");
  if(VAR->Combine) {
    fprintf(Write,"combine\n");
    fprintf(Write,"cweight %f\n",VAR->CWeight);
  }
  if(VAR->Least_Sq) fprintf(Write,"leastsq\n");
  if(VAR->Corr) fprintf(Write,"correlation\n");
  if(VAR->Cryst) fprintf(Write,"crystallographic\n");
  if(VAR->Weighting) fprintf(Write,"weighted\n");
  if(VAR->Actin) fprintf(Write,"actin\n");
  if(VAR->Tropomyosin) fprintf(Write,"tropomyosin\n");
  if(VAR->Myo) {
    fprintf(Write,"myosin\n");
    fprintf(Write,"mrepeat %f\n",MY->Repeat);
    fprintf(Write,"mraster %f\n",MY->Raster);
    fprintf(Write,"msphere %f\n",MY->Sph_Sz);
    fprintf(Write,"headfile %s\n",MY->S1_Head_File);
    fprintf(Write,"mpivpoint %d\n",MY->Piv_Point);
    fprintf(Write,"mheads %d\n",MY->N_Hds);
    fprintf(Write,"replevel %f\n",MY->Rep_Level);
    fprintf(Write,"latticerot start %f  Scale %f  Steps %f size %f\n",
	    MY->Lat.St,
	    MY->Lat.Scl,
	    MY->Lat.Stp,
	    MY->Lat.Sz);
    for(head=1;head<=MY->N_Hds;head++) {
      fprintf(Write,"mslew head %d start %f  Scale %f  Steps %f size %f\n",
	      head,
	      MY->Slew[head].St,
	      MY->Slew[head].Scl,
	      MY->Slew[head].Stp,
	      MY->Slew[head].Sz);
      fprintf(Write,"mtilt head %d start %f  Scale %f  Steps %f size %f\n",
	      head,
	      MY->Tilt[head].St,
	      MY->Tilt[head].Scl,
	      MY->Tilt[head].Stp,
	      MY->Tilt[head].Sz);
      fprintf(Write,"mrot  head %d start %f  Scale %f  Steps %f size %f\n",
	      head,
	      MY->Rot[head].St,
	      MY->Rot[head].Scl,
	      MY->Rot[head].Stp,
	      MY->Rot[head].Sz);
      for(level=1;level<=MY->N_Crwns;level++) {
	fprintf(Write,"mpslew level %d head %d start %f  Scale %f  Steps %f size %f\n",
		level,
		head,
		MY->PSlew[level][head].St,
		MY->PSlew[level][head].Scl,
		MY->PSlew[level][head].Stp,
		MY->PSlew[level][head].Sz);
	fprintf(Write,"mptilt level %d head %d start %f  Scale %f  Steps %f size %f\n",
		level,
		head,
		MY->PTilt[level][head].St,
		MY->PTilt[level][head].Scl,
		MY->PTilt[level][head].Stp,
		MY->PTilt[level][head].Sz);
	fprintf(Write,"mprot  level %d head %d start %f  Scale %f  Steps %f size %f\n",
		level,
		head,
		MY->PRot[level][head].St,
		MY->PRot[level][head].Scl,
		MY->PRot[level][head].Stp,
		MY->PRot[level][head].Sz);
      }
    }
    for(level=1;level<=MY->N_Crwns;level++) {
      fprintf(Write,"mpradius level %d start %f  Scale %f  Steps %f size %f\n",
	      level,
	      MY->PRad[level].St,
	      MY->PRad[level].Scl,
	      MY->PRad[level].Stp,
	      MY->PRad[level].Sz);
      fprintf(Write,"mpaxial level %d start %f  Scale %f  Steps %f size %f\n",
	      level,
	      MY->PAxial[level].St,
	      MY->PAxial[level].Scl,
	      MY->PAxial[level].Stp,
	      MY->PAxial[level].Sz);
      fprintf(Write,"mpazimuthal level %d start %f  Scale %f  Steps %f size %f\n",
	      level,
	      MY->PAzi[level].St,
	      MY->PAzi[level].Scl,
	      MY->PAzi[level].Stp,
	      MY->PAzi[level].Sz);
    }
    fprintf(Write,"mradius start %f  Scale %f  Steps %f size %f\n",
	    MY->Rad.St,
	    MY->Rad.Scl,
	    MY->Rad.Stp,
	    MY->Rad.Sz);
    fprintf(Write,"mheadang start %f  Scale %f  Steps %f size %f\n",
	    MY->Hd_An.St,
	    MY->Hd_An.Scl,
	    MY->Hd_An.Stp,
	    MY->Hd_An.Sz);
    fprintf(Write,"mheadsep start %f  Scale %f  Steps %f size %f\n",
	    MY->Hd_Sp.St,
	    MY->Hd_Sp.Scl,
	    MY->Hd_Sp.Stp,
	    MY->Hd_Sp.Sz);
    fprintf(Write,"mpivtilt 1 start %f  Scale %f  Steps %f size %f\n",
	    MY->Piv_Tilt1.St,
	    MY->Piv_Tilt1.Scl,
	    MY->Piv_Tilt1.Stp,
	    MY->Piv_Tilt1.Sz);
    fprintf(Write,"mpivslew 1 start %f  Scale %f  Steps %f size %f\n",
	    MY->Piv_Slew1.St,
	    MY->Piv_Slew1.Scl,
	    MY->Piv_Slew1.Stp,
	    MY->Piv_Slew1.Sz);   
    fprintf(Write,"mpivrot 1 start %f  Scale %f  Steps %f size %f\n",
	    MY->Piv_Rot1.St,
	    MY->Piv_Rot1.Scl,
	    MY->Piv_Rot1.Stp,
	    MY->Piv_Rot1.Sz);
    fprintf(Write,"mpivtilt 2 start %f  Scale %f  Steps %f size %f\n",
	    MY->Piv_Tilt2.St,
	    MY->Piv_Tilt2.Scl,
	    MY->Piv_Tilt2.Stp,
	    MY->Piv_Tilt2.Sz);
    fprintf(Write,"mpivslew 2 start %f  Scale %f  Steps %f size %f\n",
	    MY->Piv_Slew2.St,
	    MY->Piv_Slew2.Scl,
	    MY->Piv_Slew2.Stp,
	    MY->Piv_Slew2.Sz);	    
    fprintf(Write,"mpivrot 2 start %f  Scale %f  Steps %f size %f\n",
	    MY->Piv_Rot2.St,
	    MY->Piv_Rot2.Scl,
	    MY->Piv_Rot2.Stp,
	    MY->Piv_Rot2.Sz);	    
  }
  if(VAR->CPro) {
    fprintf(Write,"cprotein\n");
    fprintf(Write,"cpdomrad %f\n",CP->Sph_Sz);
    fprintf(Write,"cpnodom %d\n",CP->Tot_SubU);
    fprintf(Write,"cpdomsep %f\n",CP->Dom_Sep);
    fprintf(Write,"cppivot_type %d\n",CP->Pivot_Type);
    fprintf(Write,"cpnum_pivot %d\n",CP->Pivot);
    fprintf(Write,"cptilt start %f  Scale %f  Steps %f size %f\n",
	    CP->Tilt.St,
	    CP->Tilt.Scl,
	    CP->Tilt.Stp,
	    CP->Tilt.Sz);
    fprintf(Write,"cppivot_tilt start %f  Scale %f  Steps %f size %f\n",
	    CP->Pivot_Tilt.St,
	    CP->Pivot_Tilt.Scl,
	    CP->Pivot_Tilt.Stp,
	    CP->Pivot_Tilt.Sz);
    if(CP->Pivot_Type == 2)
      fprintf(Write,"cppivot_slew start %f  Scale %f  Steps %f size %f\n",
	      CP->Pivot_Slew.St,
	      CP->Pivot_Slew.Scl,
	      CP->Pivot_Slew.Stp,
	      CP->Pivot_Slew.Sz);
    fprintf(Write,"cpazimith start %f  Scale %f  Steps %f size %f\n",
	    CP->Azi.St,
	    CP->Azi.Scl,
	    CP->Azi.Stp,
	    CP->Azi.Sz);
    fprintf(Write,"cpradius start %f  Scale %f  Steps %f size %f\n",
	    CP->Rad.St,
	    CP->Rad.Scl,
	    CP->Rad.Stp,
	    CP->Rad.Sz);
    fprintf(Write,"cpaxial start %f  Scale %f  Steps %f size %f\n",
	    CP->Axial.St,
	    CP->Axial.Scl,
	    CP->Axial.Stp,
	    CP->Axial.Sz);
    fprintf(Write,"cpweight start %f  Scale %f  Steps %f size %f\n",
	    CP->Weight.St,
	    CP->Weight.Scl,
	    CP->Weight.Stp,
	    CP->Weight.Sz);
  }
  if(VAR->Titin) {
    fprintf(Write,"titin\n");
    fprintf(Write,"ttdomrad %f\n",TT->Sph_Sz);
    fprintf(Write,"ttnodom %d\n",TT->Tot_SubU);
    fprintf(Write,"ttazimuth start %f  Scale %f  Steps %f size %f\n",
	    TT->Azi.St,
	    TT->Azi.Scl,
	    TT->Azi.Stp,
	    TT->Azi.Sz);	  
    fprintf(Write,"ttradius start %f  Scale %f  Steps %f size %f\n",
	    TT->Rad.St,
	    TT->Rad.Scl,
	    TT->Rad.Stp,
	    TT->Rad.Sz);
    fprintf(Write,"ttweight start %f  Scale %f  Steps %f size %f\n",
	    TT->Weight.St,
	    TT->Weight.Scl,
	    TT->Weight.Stp,
	    TT->Weight.Sz);
  }
  if(VAR->Tropomyosin) {
    fprintf(Write,"tropomyosin\n");
    fprintf(Write,"trphi %f\n",TR->Phi);
    fprintf(Write,"trrad %f\n",TR->Rad);
    fprintf(Write,"trzpert %f\n",TR->Z_Pert);
    fprintf(Write,"trrepeat %f\n",TR->Repeat);
    fprintf(Write,"trsubu %d\n",TR->Tot_SubU);
    fprintf(Write,"trsphsz %f\n",TR->Sph_Sz);
    fprintf(Write,"trweight start %f  Scale %f  Steps %f size %f\n",
	    TR->Weight.St,
	    TR->Weight.Scl,
	    TR->Weight.Stp,
	    TR->Weight.Sz);
  }
  if(VAR->Actin) {
    fprintf(Write,"actin\n");
    for(Domain=1;Domain<=AA->Tot_Dom;Domain++) {
      fprintf(Write,"aaphi domain %d start %f\n",Domain,AA->Dom_Phi[Domain]);
      fprintf(Write,"aaz domain %d start %f\n",Domain,AA->Dom_Z[Domain]);
      fprintf(Write,"aaradius domain %d start %f\n",Domain,AA->Dom_Rad[Domain]);
      fprintf(Write,"aasphsz domain %d start %f\n",Domain,AA->Sph_Sz[Domain]);
    }
    fprintf(Write,"aapertz %f\n",AA->Z_Pert);
    fprintf(Write,"aapertphi %f\n",AA->Azi_Pert);
    fprintf(Write,"aarepeat %f\n",AA->Repeat);
    fprintf(Write,"aaweight start %f  Scale %f  Steps %f size %f\n",
	    AA->Weight.St,
	    AA->Weight.Scl,
	    AA->Weight.Stp,
	    AA->Weight.Sz);
  }
  if(VAR->BBone) {
    if(BB->Model == 0) {
      fprintf(Write,"bbsphere %4.2f\n",BB->Sph_Sz);
      fprintf(Write,"bbfile %s\n",BB->BackBone_File);
      fprintf(Write,"bbazi start %f  Scale %f  Steps %f Size %f\n",
	      BB->Azi.St,
	      BB->Azi.Scl,
	      BB->Azi.Stp,
	      BB->Azi.Sz);	
    }
    fprintf(Write,"backbone\n");
    fprintf(Write,"bbrepeat %4.2f\n",BB->Repeat);
    fprintf(Write,"bbmodel %d\n",BB->Model);
    if(BB->Model == 1) {
      fprintf(Write,"bbradius %4.2f\n",BB->Rad);
    }
  }
     
  if(VAR->Scoring) {
    fprintf(Write,"scoring\n");
    fprintf(Write,"scoredev %d\n",ID->MSD);
  }
  fprintf(Write,"cell %f\n",VAR->U_Cl);
  if(VAR->Scale_Data) {
    fprintf(Write,"oscale %e\n",VAR->Scale[OFFMERID]);
    fprintf(Write,"mscale %e\n",VAR->Scale[ONMERID]);
  }
  fprintf(Write,"filaments %d\n",VAR->No_Fils);
  fprintf(Write,"totrepeat %f\n",VAR->Tot_Rep);
  fprintf(Write,"ifile %s\n",VAR->Intensity_File);
  fprintf(Write,"strands %d\n",VAR->N_Strnds);
  fprintf(Write,"cutoff %f\n",VAR->CutOff);
  fclose(Write);
}



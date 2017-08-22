#define NRANSI
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

void Load_Intensity()
{
  extern struct Info *VAR;
 
  if(VAR->View) return;
  if(VAR->BogusData) {
    Generate_Intensity_Params();
    Get_Data_Mem();
    Set_Data_Mem();
  }
  else Load_Intensity_Data();
  return;
}

void Generate_Intensity_Params()
{
  extern struct Info *VAR;
  extern struct Intensity *ID;
  extern struct Constant Cnst;

  int h,k,l,l_max,k_max,h_max,Rad;
  double psi,Radius;
     
  ID->R_max = ID->h_max = ID->k_max = ID->l_max = -1;
  l_max = (int)(VAR->Tot_Rep/VAR->BogusDataRes+10);
  k_max = (int)(VAR->U_Cl/VAR->BogusDataRes+10);
  h_max = k_max;
  for(l = 0;l<=l_max;l++) {
    for(k = -k_max;k<=k_max;k++) {
      for(h = -h_max;h<=h_max;h++) {
	psi =  atan2((2.0*k+h),Cnst.Root_t*h);
	if((psi >= VAR->Max_Angle) || (psi < VAR->Min_Angle )) continue;
	Radius = sqrt(abs(h*h+k*k+h*k)/(SQR(VAR->U_Cl*Cnst.Root_tq))+SQR(l/VAR->Tot_Rep));
	if(Radius > (1.0/VAR->BogusDataRes)) continue;
	Rad = abs(h*h+k*k+h*k);
	if(Rad > ID->R_max) ID->R_max = Rad;
	if(abs(h) > ID->h_max) ID->h_max = abs(h);
	if(abs(k) > ID->k_max) ID->k_max = abs(k);
	if(abs(l) > ID->l_max) ID->l_max = l;
      }
    }
    printf("\r  Maximum Values of h,k,l................. %d  %d  %d",
	   ID->h_max,ID->k_max,ID->l_max);
  }
  printf("\n");
}

void Load_Intensity_Data()
{
  extern struct Info *VAR;
  extern struct Intensity *ID;
  extern struct Constant Cnst;
     
  int h,k,l,Rad,mul,Tot_Reflections;
  double psi,I_Val,SD_Val,num,Radius;
  char Line[100];
  FILE *Intensity_File;

  VAR->Resolution = 999.0;
  ID->N_Ref = 0;
  ID->NM_Ref = 0;
  Tot_Reflections = 0;
  ID->h_max = -1000;
  ID->k_max = -1000;
  ID->l_max = -1000;
  ID->R_max = 0;

  if( (Intensity_File = fopen( VAR->Intensity_File, "r") ) == NULL ) {
    printf("Cannot Open %s ! \n",VAR->Intensity_File);
    CleanUp();
  }
  fgets(Line,60,Intensity_File);
  fgets(Line,60,Intensity_File);
  fgets(Line,60,Intensity_File);
  fgets(Line,60,Intensity_File);
  while(fgets(Line,60,Intensity_File)) {
    sscanf(Line,"%d%d%d",&h,&k,&l);
    if(abs(h) > ID->h_max) ID->h_max = abs(h);
    if(abs(k) > ID->k_max) ID->k_max = abs(k);
    if(l > ID->l_max) ID->l_max = l;
    Radius = 1.0/sqrt(abs(h*h+k*k+h*k)/(SQR(VAR->U_Cl*Cnst.Root_tq))+SQR(l/VAR->Tot_Rep));
    if(VAR->CutOff > Radius) continue;
    if(VAR->Resolution > Radius) VAR->Resolution = Radius;
    if(ID->R_max < h*h+k*k+h*k) ID->R_max = h*h+k*k+h*k;
    Tot_Reflections++;
    printf("\r  Total Number Of Reflections............. %d",Tot_Reflections);
  }
  rewind(Intensity_File); 
  printf("\n");
  printf("  Maximum Values of h,k,l................. %d  %d  %d\n",ID->h_max,ID->k_max,ID->l_max);
  printf("  Using Data At Resolution................ %5.2fA\n",VAR->Resolution);
  Get_Data_Mem();
  fgets(Line,60,Intensity_File);
  fgets(Line,60,Intensity_File);
  fgets(Line,60,Intensity_File);
  fgets(Line,60,Intensity_File);
  while(fgets(Line,60,Intensity_File)) {
    sscanf(Line,"%d %d %d %lf %d %lf %lf",&h,&k,&l,&num,&mul,&I_Val,&SD_Val);
    Rad = abs(h*h+k*k+h*k);
    Radius = 1.0/sqrt(abs(h*h+k*k+h*k)/(SQR(VAR->U_Cl*Cnst.Root_tq))+SQR(l/VAR->Tot_Rep));
    if(VAR->CutOff > Radius) continue;
    if(SD_Val == 0.0) continue;
    if((Rad == 0) && (l == 0)) continue;
    if(VAR->HKLOutput) {
      ID->h_i[Rad][l] = h;
      ID->k_i[Rad][l] = k;
      ID->l_i[Rad][l] = l;
    }
    ID->OI[Rad][l] = I_Val;
    ID->SD[Rad][l] = SD_Val;
    ID->CSD[Rad][l] = sqrt(ID->OI[Rad][l]+ID->SD[Rad][l])-sqrt(ID->OI[Rad][l]);
    if(Rad == 0) {
      if(VAR->Corr) {
	ID->MCORSD[(ID->NM_Ref)+1] = SD_Val;
	ID->MOCOR[(ID->NM_Ref)+1] = I_Val;
      }
      ID->NM_Ref++;
      continue;
    }
    if(VAR->Corr) {
      ID->OCOR[(ID->N_Ref)+1] = I_Val;
      ID->CORSD[(ID->N_Ref)+1] = SD_Val;
    }
    ID->N_Ref++;
  }
  fclose(Intensity_File);
  printf("  Number of Off-Meridional Intensities.... %d\n",ID->N_Ref);
  printf("  Number of Meridional Intensities........ %d\n",ID->NM_Ref);
}

void Get_Data_Mem()
{     
  extern struct Intensity *ID;
  extern struct Info *VAR;
     
  int Rad,l,h,k,i;
  int hmem,kmem,lmem;

  kmem = ID->k_max+1;
  hmem = ID->h_max+1;
  lmem = ID->l_max+1;
  ID->CI  = dmatrix(0,ID->R_max+1,0,ID->l_max+1);
  ID->OI  = dmatrix(0,ID->R_max+1,0,ID->l_max+1);
  ID->SD  = dmatrix(0,ID->R_max+1,0,ID->l_max+1);
  ID->CSD = dmatrix(0,ID->R_max+1,0,ID->l_max+1);
  for(Rad=0;Rad<=ID->R_max;Rad++) {
    for(l=0;l<=ID->l_max;l++) {
      ID->CI[Rad][l] = 0.0;
      ID->OI[Rad][l] = 0.0;
      ID->SD[Rad][l] = 0.0;
      ID->CSD[Rad][l] = 0.0;
    }
  }  
  if((VAR->Fourier_Diff) || (VAR->Reflections) || (VAR->Observed)) {
    ID->FD_Cal = f3tensor(-hmem,hmem,-kmem,kmem,0,lmem);
    ID->FD_Obs = f3tensor(-hmem,hmem,-kmem,kmem,0,lmem);
    ID->FD_Cal_Ph = f3tensor(-hmem,hmem,-kmem,kmem,0,lmem);
    ID->Mul = imatrix(0,ID->R_max+1,0,lmem);
    for(Rad=0;Rad<=ID->R_max;Rad++) {
      for(l=0;l<=ID->l_max;l++) {
	ID->Mul[Rad][l] = 0;
      }
    }
    for(h = -ID->h_max;h<=ID->h_max;h++) {
      for(k = -ID->k_max;k<=ID->k_max;k++) {
	for(l = 0;l<=ID->l_max;l++) {
	  ID->FD_Cal[h][k][l]    = 0.0;
	  ID->FD_Obs[h][k][l]    = 0.0;
	  ID->FD_Cal_Ph[h][k][l] = 0.0;
	}
      }
    } 
  }
  if(VAR->Corr) {
    i = 0;
    ID->OCOR   = dvector(0,ID->R_max*ID->l_max+1);
    ID->CCOR   = dvector(0,ID->R_max*ID->l_max+1);
    ID->MCORSD = dvector(0,ID->l_max+1);
    ID->CORSD  = dvector(0,ID->R_max*ID->l_max+1);
    ID->MOCOR  = dvector(0,ID->l_max+1);
    ID->MCCOR  = dvector(0,ID->l_max+1);       
    for(l=0;l<=ID->l_max;l++) {
      ID->MCORSD[l] = 0.0;
      ID->MOCOR[l] = 0.0;
      ID->MCCOR[l] = 0.0;
      for(Rad=0;Rad<=ID->R_max;Rad++) {
	ID->OCOR[i] = 0.0;
	ID->CCOR[i] = 0.0;
	ID->CORSD[i] = 0.0;
	i++;
      }
    }
  }
  if(VAR->HKLOutput) {
    ID->h_i = imatrix(0,ID->R_max+1,0,ID->l_max+1);
    ID->k_i = imatrix(0,ID->R_max+1,0,ID->l_max+1);
    ID->l_i = imatrix(0,ID->R_max+1,0,ID->l_max+1);
    for(Rad=0;Rad<=ID->R_max;Rad++) {
      for(l=0;l<=ID->l_max;l++) {
	ID->h_i[Rad][l] = 0;
	ID->k_i[Rad][l] = 0;
	ID->l_i[Rad][l] = 0;
      }
    }  
  }
}

void Set_Data_Mem()
{
  extern struct Info *VAR;
  extern struct Intensity *ID;
  extern struct Constant Cnst;

  int h,k,l,Rad;
  double psi;

  ID->N_Ref = 0;
  ID->NM_Ref = 0;
  for(l = 0;l<=ID->l_max;l++) {
    for(k = -ID->k_max;k<=ID->k_max;k++) {
      for(h = -ID->h_max;h<=ID->h_max;h++) {
	psi =  atan2((2.0*k+h),Cnst.Root_t*h);
	if((psi >= VAR->Max_Angle) || (psi < VAR->Min_Angle )) continue;
	Rad = abs(h*h+k*k+h*k);
	if(Rad > ID->R_max) continue;
	if(ID->OI[Rad][l] == 1.0) continue;
	if(VAR->HKLOutput) {
	  ID->h_i[Rad][l] = h;
	  ID->k_i[Rad][l] = k;
	  ID->l_i[Rad][l] = l;
	}
	ID->OI[Rad][l] = 1.0;
	ID->SD[Rad][l] = 1.0;
	if(Rad == 0) {
	  if(l == 0) ID->SD[Rad][l] = 0.0;
	  if(VAR->Corr) {
	    ID->MCORSD[(ID->NM_Ref)+1] = 1.0;
	    ID->MOCOR[(ID->NM_Ref)+1] = 1.0;
	  }
	  ID->NM_Ref++;
	  continue;
	}
	if(VAR->Corr) {
	  ID->OCOR[(ID->N_Ref)+1] = 1.0;
	  ID->CORSD[(ID->N_Ref)+1] = 1.0;
	}
	ID->N_Ref++;
      }
    }
  }
  printf("  Number of Bogus Off-Merid Intensities... %d\n",ID->N_Ref);
  printf("  Number of Bogus Meridional Intensities.. %d\n",ID->NM_Ref);
}

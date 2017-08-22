#define NRANSI
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

void Initialization(void)
{
  int i,l,m,Dimension,reps,Points;
  char Symmetry[40];

  extern struct Myosin *MY;
  extern struct Constant Cnst;
  extern struct Info *VAR;
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct BackBone *BB;
  extern struct Actin *AA;
  extern struct Tropomyosin *TR;
  extern struct Intensity *ID;

  VAR->Iterations = 0;
  VAR->Twst = (360.0/(double)VAR->N_Strnds)*Cnst.DTR;
  printf("\n  Model Symmetry.........................");
  if(VAR->BBone) {
    strcpy(Symmetry,"  P3\n");
    VAR->Max_Angle = (360.0/(double)VAR->N_Strnds)*Cnst.DTR;
    VAR->Min_Angle = 0.0;
  }
  if((VAR->Myo) || (VAR->CPro) || (VAR->Titin)) {
    if(VAR->N_Strnds == 3) {
      strcpy(Symmetry,"  P3\n");
      VAR->Max_Angle = 120.0*Cnst.DTR;
      VAR->Min_Angle = 0.0*Cnst.DTR;
    }
    if(VAR->N_Strnds == 4) {
      if(VAR->Reflections) {
	strcpy(Symmetry,"  180 Degree, but pretend not for CCP4\n");
	VAR->Max_Angle = 999.0*Cnst.DTR;
	VAR->Min_Angle = -999.0*Cnst.DTR;
      }
      else {
	strcpy(Symmetry,"  180 Degree\n");
	VAR->Max_Angle = 180.0*Cnst.DTR;
	VAR->Min_Angle = 0.0;
      }
    }
    if((VAR->N_Strnds != 3) && (VAR->N_Strnds != 4)) {
      if(VAR->NoPerts) {
	printf("Cannot use bessel functions...\n");
	CleanUp();
      }
      strcpy(Symmetry,"  Unknown... Assuming P1\n");
      VAR->Max_Angle = 999.0*Cnst.DTR;
      VAR->Min_Angle = -999.0*Cnst.DTR;
    }  
  }
  if((VAR->Tropomyosin) || (VAR->Actin)) {
    strcpy(Symmetry,"  Unknown... Assuming P1\n");
    VAR->Max_Angle = 999.0*Cnst.DTR;
    VAR->Min_Angle = -999.0*Cnst.DTR;
  }
  printf("%s",Symmetry);
  if(VAR->Myo) {
    if(VAR->BrookeHaven) Load_BrookMCoords();
    else Load_MCoords();
    MY->Crwn_Twst = 360.0/(MY->Rep_Level)*Cnst.DTR; 
    Dimension = MY->N_Pts*MY->N_Hds*MY->N_Crwns*VAR->N_Strnds*(int)(VAR->Tot_Rep/MY->Repeat);
    MY->X = dvector(0,Dimension+1);
    MY->Y = dvector(0,Dimension+1);
    MY->Z = dvector(0,Dimension+1);
    MY->RX = dvector(0,Dimension+1);
    MY->RY = dvector(0,Dimension+1);
    MY->RZ = dvector(0,Dimension+1);
    if(VAR->NoPerts) {
      MY->Radial = dvector(0,Dimension+1);
      MY->Azi = dvector(0,Dimension+1);
    }
  } 
  if(VAR->Actin) {
    Dimension = 2*2*AA->Tot_SubU*AA->Tot_Dom*(int)(VAR->Tot_Rep/AA->Repeat);
    AA->X = dvector(0,Dimension+1);
    AA->Y = dvector(0,Dimension+1);
    AA->Z = dvector(0,Dimension+1);
    AA->RX = dvector(0,Dimension+1);
    AA->RY = dvector(0,Dimension+1);
    AA->RZ = dvector(0,Dimension+1);
  }
  if(VAR->Tropomyosin) {
    Dimension = 2*2*TR->Tot_SubU*(int)(VAR->Tot_Rep/TR->Repeat);
    TR->X = dvector(0,Dimension+1);
    TR->Y = dvector(0,Dimension+1);
    TR->Z = dvector(0,Dimension+1);
    TR->RX = dvector(0,Dimension+1);
    TR->RY = dvector(0,Dimension+1);
    TR->RZ = dvector(0,Dimension+1);
  }
  if(VAR->CPro) {
    VAR->Twst = (360.0/(double)VAR->N_Strnds)*Cnst.DTR;
    Dimension = VAR->N_Strnds*CP->Tot_SubU*(int)(VAR->Tot_Rep/CP->Repeat);
    CP->X = dvector(0,Dimension+1);
    CP->Y = dvector(0,Dimension+1);
    CP->Z = dvector(0,Dimension+1);
    CP->RX = dvector(0,Dimension+1);
    CP->RY = dvector(0,Dimension+1);
    CP->RZ = dvector(0,Dimension+1);
  }
  if(VAR->Titin) {
    VAR->Twst = (360.0/(double)VAR->N_Strnds)*Cnst.DTR;
    Dimension = VAR->N_Strnds*TT->Tot_SubU*(int)(VAR->Tot_Rep/TT->Repeat);
    TT->X = dvector(0,Dimension+1);
    TT->Y = dvector(0,Dimension+1);
    TT->Z = dvector(0,Dimension+1);
    TT->RX = dvector(0,Dimension+1);
    TT->RY = dvector(0,Dimension+1);
    TT->RZ = dvector(0,Dimension+1);
  }
  if((VAR->BBone) && (BB->Model == 0)) {
    Load_BCoords();
    Dimension = BB->N_Pts*(int)(VAR->Tot_Rep/BB->Repeat);
    BB->X = dvector(0,Dimension+1);
    BB->Y = dvector(0,Dimension+1);
    BB->Z = dvector(0,Dimension+1);
    BB->RX = dvector(0,Dimension+1);
    BB->RY = dvector(0,Dimension+1);
    BB->RZ = dvector(0,Dimension+1);
  }
}

void Reset_Search()
{
  extern struct Info *VAR;

  VAR->Global       = VAR->Replex      =
    VAR->Anneal       = VAR->Simplex     = 
    VAR->Powell       = VAR->View        =
    VAR->HKLOutput    = VAR->Reflections =
    VAR->Fourier_Diff = VAR->ccp13       = 
    VAR->Observed     = VAR->OneShot     = 
    VAR->Avs          = VAR->DCad        = 
    VAR->Pdb          = VAR->Torus       = FALSE;
}

void Reset_Simul()
{
  extern struct Info *VAR;

  VAR->Corr  = VAR->Least_Sq  = 
    VAR->Cryst = VAR->Weighting = 
    VAR->BogusData = FALSE;
}

void Reset_Molecule()
{
  extern struct Info *VAR;

  VAR->Myo   = VAR->Actin  =
    VAR->Titin = VAR->CPro   = 
    VAR->BBone = VAR->Tropomyosin = FALSE;
}

int Alloc_Mem_Myosin()
{
  extern struct Myosin *MY;

  int mem;

  mem = TRUE;
  if( (MY = (struct Myosin*) malloc((unsigned) sizeof(struct Myosin))) == NULL) return FALSE;
  MY->N_Crwns = 3;
  MY->N_Hds   = 2;
  MY->Rep_Level = 9.0;
  MY->Slew   = datavector(0,MY->N_Hds+1);
  MY->Tilt   = datavector(0,MY->N_Hds+1);
  MY->Rot    = datavector(0,MY->N_Hds+1);
  MY->PRad   = datavector(0,MY->N_Crwns+1);
  MY->PAxial = datavector(0,MY->N_Crwns+1);
  MY->PAzi   = datavector(0,MY->N_Crwns+1);
  MY->PSlew  = datamatrix(0,MY->N_Crwns+1,0,MY->N_Hds+1);
  MY->PTilt  = datamatrix(0,MY->N_Crwns+1,0,MY->N_Hds+1);
  MY->PRot   = datamatrix(0,MY->N_Crwns+1,0,MY->N_Hds+1);
  Zero_Myosin_Mem();
  return TRUE;
}

int Alloc_Mem_Actin()
{
  extern struct Actin *AA;

  if( (AA = (struct Actin*) malloc((unsigned) sizeof(struct Actin))) == NULL) return FALSE;
  Zero_Actin_Mem();
  AA->Tot_SubU = 13;
  AA->Tot_Dom  = 4;
  return TRUE;
}

int Alloc_Mem_Tropomyosin()
{
  extern struct Tropomyosin *TR;

  if( (TR = (struct Tropomyosin*) malloc((unsigned) sizeof(struct Tropomyosin))) == NULL) return FALSE;
  Zero_Tropomyosin_Mem();
  return TRUE;
}

int Alloc_Mem_Titin()
{
  extern struct Titin *TT;

  if( (TT = (struct Titin*) malloc((unsigned) sizeof(struct Titin))) == NULL) return FALSE;
  Zero_Titin_Mem();
  return TRUE;
}

int Alloc_Mem_C_Protein()
{
  extern struct C_Protein *CP;

  if( (CP = (struct C_Protein*) malloc((unsigned) sizeof(struct C_Protein))) == NULL) return FALSE;
  Zero_C_Protein_Mem();
  return TRUE;
}

int Alloc_Mem_BackBone()
{
  extern struct BackBone *BB;

  if( (BB = (struct BackBone*) malloc((unsigned) sizeof(struct BackBone))) == NULL) return FALSE;
  Zero_BackBone_Mem();
  return TRUE;
}

void Alloc_Myosin()
{
  extern struct Info *VAR;

  if(!VAR->Myo) {
    VAR->Myo = TRUE;
    if(Alloc_Mem_Myosin()) return;
    else {
      printf("\nError allocated memory for Myosin\n\n!");
      CleanUp();
    }
  }
}

void Alloc_Titin()
{
  extern struct Info *VAR;

  if(!VAR->Titin) {
    VAR->Titin = TRUE;
    if(Alloc_Mem_Titin()) return;
    else {
      printf("\nError allocated memory for Titin\n\n!");
      CleanUp();
    }
  }
}

void Alloc_Actin()
{
  extern struct Info *VAR;

  if(!VAR->Actin) {
    VAR->Actin = TRUE;
    if(Alloc_Mem_Actin()) return;
    else {
      printf("\nError allocated memory for Actin\n\n!");
      CleanUp();
    }
  }
}

void Alloc_Tropomyosin()
{
  extern struct Info *VAR;

  if(!VAR->Tropomyosin) {
    VAR->Tropomyosin = TRUE;
    if(Alloc_Mem_Tropomyosin()) return;
    else {
      printf("\nError allocated memory for Tropomyosin\n\n!");
      CleanUp();
    }
  }
}


void Alloc_C_Protein()
{
  extern struct Info *VAR;

  if(!VAR->CPro) {
    VAR->CPro = TRUE;
    if(Alloc_Mem_C_Protein()) return;
    else {
      printf("\nError allocated memory for C_Protein\n\n!");
      CleanUp();
    }
  }
}

void Alloc_BackBone()
{
  extern struct Info *VAR;

  if(!VAR->BBone) {
    VAR->BBone = TRUE;
    if(Alloc_Mem_BackBone()) return;
    else {
      printf("\nError allocated memory for BackBone\n\n!");
      CleanUp();
    }
  }
}

void Load_BrookMCoords()
{
  extern struct Myosin *MY;

  int i,number,seq;
  FILE *Points;
  float dum2,dum3;
  double xt,yt,zt;
  char a,aa[4],chain[2],Param1[20],Param2[20];
  char Character,Line[100],atom[10],dum1[10];

  MY->N_Pts = 0;
  if( ( Points = fopen(MY->S1_Head_File ,"r" ) ) == NULL ) {
    printf("Cannot Open %s ! \n",MY->S1_Head_File);
    CleanUp();
  }  
  while(Character != EOF) {
    Character = fgetc(Points);
    if(Character == '\n') MY->N_Pts++;
  }
  rewind(Points);
  MY->X_C = dvector(0,MY->N_Pts+1);
  MY->Y_C = dvector(0,MY->N_Pts+1);
  MY->Z_C = dvector(0,MY->N_Pts+1);
  MY->Param = cmatrix(0,MY->N_Pts+1,0,20);
  MY->Amino_Acid = cmatrix(0,MY->N_Pts+1,0,4);
  MY->Chain = cmatrix(0,MY->N_Pts+1,0,2);
  MY->Sequence = ivector(0,MY->N_Pts+1);
  MY->Type = cmatrix(0,MY->N_Pts+1,0,4);
  i = 0;
  while(fgets(Line,90,Points) != NULL) {
    sscanf(Line,"%4s %5d %3s %3s %1s %4d %lf %lf %lf  %s%s",
	   atom,&number,dum1,aa,chain,&seq,
	   &xt,&yt,&zt,Param1,Param2);
    strcpy(MY->Amino_Acid[i],aa);
    strcpy(MY->Chain[i],chain);
    strcpy(MY->Type[i],dum1);
    strcat(Param1," ");
    strcat(Param1,Param2);
    strcpy(MY->Param[i],Param1);
    MY->Sequence[i] = seq;
    MY->X_C[i] = xt * MY->Raster;
    MY->Y_C[i] = yt * MY->Raster;
    MY->Z_C[i] = zt * MY->Raster;
    i++;
    strcpy(Param2," ");
  }
  printf("  Number Of S1 Spheres...................  %d\n",MY->N_Pts+1);
  if(MY->N_Pts < MY->Piv_Point) {
    printf("\n\n Oops, Pivoting on a non-existant sphere.. Call it zero !\n");
    MY->Piv_Point = 0;
  }
  fclose(Points);
}


void Load_MCoords()
{
  extern struct Myosin *MY;

  int i;
  FILE *Points;
  double xt,yt,zt;
  char Character,Line[100];

  MY->N_Pts = 0;
  if( ( Points = fopen(MY->S1_Head_File ,"r" ) ) == NULL ) {
    printf("Cannot Open %s ! \n",MY->S1_Head_File);
    CleanUp();
  }   
  while(Character != EOF) {
    Character = fgetc(Points);
    if(Character == '\n') MY->N_Pts++;
  }
  rewind(Points);
  MY->N_Pts -= 3;
  MY->X_C = dvector(0,MY->N_Pts+1);
  MY->Y_C = dvector(0,MY->N_Pts+1);
  MY->Z_C = dvector(0,MY->N_Pts+1);
  for(i=-3;i<=MY->N_Pts+1;i++) {
    if( (fgets(Line,60,Points) ) == NULL) break;
    if( i < 0 ) continue;
    sscanf(Line,"%lf%lf%lf",&xt,&yt,&zt);
    MY->X_C[i] = xt * MY->Raster;
    MY->Y_C[i] = yt * MY->Raster;
    MY->Z_C[i] = zt * MY->Raster;
    printf("\r  Number Of S1 Spheres...................  %d",MY->N_Pts+1);
  }
  printf("\n");
  if(MY->N_Pts < MY->Piv_Point) {
    printf("\n\n Oops, Pivoting on a non-existant sphere.. Call it zero !\n");
    MY->Piv_Point = 0;
  }
  fclose(Points);
}

void Load_BCoords()
{
  extern struct BackBone *BB;

  int i;
  FILE *Points;
  char Line[100],Character;

  BB->N_Pts = 0;
  if( ( Points = fopen(BB->BackBone_File ,"r" ) ) == NULL ) {
    printf("Cannot Open %s ! \n",BB->BackBone_File);
    CleanUp();
  }   
  while(Character != EOF) {
    Character = fgetc(Points);
    if(Character == '\n') BB->N_Pts++;
  }
  rewind(Points);
  BB->N_Pts -= 3;
  BB->X_C = dvector(0,BB->N_Pts+1);
  BB->Y_C = dvector(0,BB->N_Pts+1);
  BB->Z_C = dvector(0,BB->N_Pts+1);
  for(i=-3;i<=BB->N_Pts+1;i++) {
    if( (fgets(Line,99,Points) ) == NULL) break;
    if( i < 0 ) continue;
    sscanf(Line,"%lf\t%lf\t%lf",&BB->X_C[i],&BB->Y_C[i],&BB->Z_C[i]);
    printf("\r  Number Of BackBone Spheres.............  %d",i+1);
  }
  printf("\n");
  fclose(Points);
}

/*                                      
   Program    :    Movie 
   FileName   :    structures.h
   Author     :    Written By L.Hudson.
 */        

#ifndef _STRUCTURES_
#define _STRUCTURES_

struct Search_Range {
  double St,Sz,Scl,Stp,Val,Max;
};

struct Info {     
  int Global,   Simplex,     Powell;
  int View,     HKLOutput,   Combine,    Replex;
  int Least_Sq, Corr,        Scoring,    Cryst;
  int Myo,      Actin,       CPro,       Titin;
  int No_Fils,  Fourier_Diff,Reflections,BBone;
  int Observed, Weighting,   Anneal,     N_Strnds;
  int A_Iter,   Num_Reps,    NoCheck,    Scale_Data;
  int ccp13,    Tropomyosin, OneShot,    BogusData;
  int Pivot_Myosin,          Avs,        DCad;
  int Pdb,      Torus,       Iterations, BrookeHaven;
  int NoPerts;
  double CWeight,Twst,   Max_Angle,Min_Angle;
  double U_Cl,   Tot_Rep,Scale[2],CutOff;
  double A_Temp, DTemp,Resolution,BogusDataRes;
  char Status_File[100],Intensity_File[100];
  char Output_File[100];
  FILE *Output;
};

struct C_Protein {
  int Tot_Mol,Tot_SubU,Pivot_Type,Pivot;
  
  double Sph_Sz,Den, Repeat,Dom_Sep;
  double *RX,  *RY,*RZ;
  double *X,   *Y, *Z;
  
  struct Search_Range Tilt,Azi,Rad;
  struct Search_Range Pivot_Tilt,Pivot_Slew;
  struct Search_Range Weight,Axial;
};

struct Titin {
  int Tot_Mol,Tot_SubU;

  double Sph_Sz,Den, Repeat;
  double *RX,  *RY,*RZ;
  double *X,   *Y, *Z;

  struct Search_Range Azi,Rad,Weight;
};

struct Myosin {
  int N_Pts,A_Sz,N_Hds,N_Crwns,Piv_Point;
  int *Sequence;

  double Crwn_Twst,Repeat,Rep_Level;
  double *RX,*RY,*RZ;
  double *X, *Y, *Z;
  double *X_C,*Y_C,*Z_C;
  double *Radial,*Azi;

  struct Search_Range *Slew,*Tilt,*Rot,*PRad,*PAxial,*PAzi;
  struct Search_Range **PSlew,**PTilt,**PRot;
  struct Search_Range Lat,Rad,Hd_Sp,Hd_An;
  struct Search_Range Piv_Tilt1,Piv_Slew1,Piv_Rot1;
  struct Search_Range Piv_Tilt2,Piv_Slew2,Piv_Rot2;  
  double Raster,Sph_Sz;
  char S1_Head_File[100],**Amino_Acid,**Chain,**Param,**Type;
}; 

struct Tropomyosin {
  int Tot_SubU,N_Fil;

  double Z_Pert,Phi,Rad;
  double Repeat,Sph_Sz;
  double *RX, *RY, *RZ;
  double *X,  *Y,  *Z;
  struct Search_Range Weight;
};

struct Actin {
  int Tot_SubU,Tot_Dom,N_Fil;

  double Azi_Pert,Z_Pert,Repeat,Sph_Sz[5];
  double Dom_Phi[5],Dom_Z[5],Dom_Rad[5];
  double *RX, *RY, *RZ;
  double *X,  *Y,  *Z;

  struct Search_Range Weight;
     
};

struct BackBone {
  int N_Pts,Model;

  struct Search_Range Azi;

  double Rad,Repeat,Sph_Sz;
  double *RX, *RY, *RZ;
  double *X,  *Y,  *Z;
  double *X_C,*Y_C,*Z_C;

  char BackBone_File[100];
};

struct Intensity {
  int N_Ref,NM_Ref;
  int l_max,h_max,k_max;
  int R_max,MRD,MSD,MMRD;
  int **Mul,**h_i,**k_i,**l_i;
  int Max_Bessels;

  double ***Bessel;
  double *CCOR,  *OCOR, *MOCOR,   *MCCOR;
  double *MCORSD,*CORSD,**OI,     **CI;
  double **SD,   **CSD;
  int **Bes_Orders, **Bes_Contrib, Bes_Num;
  float  ***FD_Cal,***FD_Cal_Ph,***FD_Obs;
  double R_Fac,  MR_Fac,Cor,      MCor;
  double C_Fac,  MC_Fac;
};

struct Constant {
  double const Pi,Two_Pi,Root_t,Root_tq,DTR;
};

typedef struct
{
  double bump;
  int counter1;
  int counter2;
  double tor_exit;
  int scalar1;
  int scalar2;
  double shrink_hit;
  double shrink_trial;
  double tor_hole;
} Torus_Input;

typedef union
{
  double dfun;
  float ffun;
  int ifun;
} Function_Type;

#endif





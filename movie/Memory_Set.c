#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

void Reset(void)
{
  extern struct Info *VAR;

  if(VAR->Myo)   Reset_Myosin_Start();
  if(VAR->CPro)  Reset_C_Protein_Start();
  if(VAR->Titin) Reset_Titin_Start();
  if(VAR->Tropomyosin) Reset_Tropomyosin_Start();
  if(VAR->Actin) Reset_Actin_Start();
}

void Reset_Myosin_Start(void)
{
  extern struct Myosin *MY;
  extern struct Constant Cnst;

  int Level,Head;

  for(Head=1;Head<=MY->N_Hds;Head++) {
    MY->Slew[Head].St   = MY->Slew[Head].Val/Cnst.DTR;
    MY->Slew[Head].Scl /= Cnst.DTR; 
    MY->Tilt[Head].St   = MY->Tilt[Head].Val/Cnst.DTR;
    MY->Tilt[Head].Scl /= Cnst.DTR;
    MY->Rot[Head].St    = MY->Rot[Head].Val/Cnst.DTR;
    MY->Rot[Head].Scl  /= Cnst.DTR;
    for(Level=1;Level<=MY->N_Crwns;Level++) {
      MY->PSlew[Level][Head].St =  
	MY->PSlew[Level][Head].Val/Cnst.DTR;
      MY->PSlew[Level][Head].Scl /= Cnst.DTR;  
      MY->PTilt[Level][Head].St =  
	MY->PTilt[Level][Head].Val/Cnst.DTR;
      MY->PTilt[Level][Head].Scl /= Cnst.DTR;  
      MY->PRot[Level][Head].St  =  
	MY->PRot[Level][Head].Val/Cnst.DTR;
      MY->PRot[Level][Head].Scl /= Cnst.DTR;
    }
  }
  for(Level=1;Level<=MY->N_Crwns;Level++) {
    MY->PRad[Level].St   =  MY->PRad[Level].Val;
    MY->PAxial[Level].St =  MY->PAxial[Level].Val;
    MY->PAzi[Level].St   =  MY->PAzi[Level].Val/Cnst.DTR;
    MY->PAzi[Level].Scl /=  Cnst.DTR;
  }
  MY->Hd_Sp.St      = MY->Hd_Sp.Val;
  MY->Hd_An.St      = MY->Hd_An.Val/Cnst.DTR;
  MY->Hd_An.Scl    /= Cnst.DTR;
  MY->Piv_Tilt1.St   = MY->Piv_Tilt1.Val/Cnst.DTR;
  MY->Piv_Tilt1.Scl /= Cnst.DTR;
  MY->Piv_Slew1.St   = MY->Piv_Slew1.Val/Cnst.DTR;
  MY->Piv_Slew1.Scl /= Cnst.DTR;
  MY->Piv_Rot1.St   = MY->Piv_Rot1.Val/Cnst.DTR;
  MY->Piv_Rot1.Scl /= Cnst.DTR;
  MY->Piv_Tilt2.St   = MY->Piv_Tilt2.Val/Cnst.DTR;
  MY->Piv_Tilt2.Scl /= Cnst.DTR;
  MY->Piv_Slew2.St   = MY->Piv_Slew2.Val/Cnst.DTR;
  MY->Piv_Slew2.Scl /= Cnst.DTR;
  MY->Piv_Rot2.St   = MY->Piv_Rot2.Val/Cnst.DTR;
  MY->Piv_Rot2.Scl /= Cnst.DTR;  
  MY->Lat.St        = MY->Lat.Val/Cnst.DTR;
  MY->Lat.Scl      /= Cnst.DTR;
  MY->Rad.St        = MY->Rad.Val;
}
	
void Zero_Myosin_Mem(void)
{
  extern struct Myosin *MY;
     
  int Level,Head;

  for(Head=1;Head<=MY->N_Hds;Head++) {
    MY->Slew[Head].St   = 0.0;
    MY->Slew[Head].Scl  = 0.0;
    MY->Tilt[Head].St   = 0.0;
    MY->Tilt[Head].Scl  = 0.0;
    MY->Rot[Head].St    = 0.0;
    MY->Rot[Head].Scl   = 0.0;
    for(Level=1;Level<=MY->N_Crwns;Level++) {
      MY->PSlew[Level][Head].St  = 0.0;
      MY->PSlew[Level][Head].Scl = 0.0;  
      MY->PTilt[Level][Head].St  = 0.0;
      MY->PTilt[Level][Head].Scl = 0.0;  
      MY->PRot[Level][Head].St   = 0.0;
      MY->PRot[Level][Head].Scl  = 0.0;
    }
  }
  for(Level=1;Level<=MY->N_Crwns;Level++) {
    MY->PRad[Level].St    = 0.0;
    MY->PAxial[Level].St  = 0.0;
    MY->PAzi[Level].St    = 0.0;
    MY->PRad[Level].Scl   = 0.0;
    MY->PAxial[Level].Scl = 0.0;
    MY->PAzi[Level].Scl   = 0.0;
  }
  MY->Hd_Sp.St     = 0.0;
  MY->Hd_An.St     = 0.0;
  MY->Hd_An.Scl    = 0.0;
  MY->Piv_Tilt1.St  = 0.0;
  MY->Piv_Tilt1.Scl = 0.0;
  MY->Piv_Slew1.Scl = 0.0;
  MY->Piv_Slew1.St  = 0.0;
  MY->Piv_Rot1.Scl = 0.0;
  MY->Piv_Rot1.St  = 0.0;
  MY->Piv_Tilt2.St  = 0.0;
  MY->Piv_Tilt2.Scl = 0.0;
  MY->Piv_Slew2.Scl = 0.0;
  MY->Piv_Slew2.St  = 0.0;
  MY->Piv_Rot2.Scl = 0.0;
  MY->Piv_Rot2.St  = 0.0;  
  MY->Lat.St       = 0.0;
  MY->Lat.Scl      = 0.0;
  MY->Rad.St       = 0.0;
}

void Zero_Tropomyosin_Mem(void) 
{
  extern struct Tropomyosin *TR;

  TR->Phi = 0.0;
  TR->Rad = 0.0;
  TR->Tot_SubU = 0;
  TR->Repeat = 0.0;
  TR->Weight.St  = 0.0;
  TR->Weight.Scl = 0.0;
}

void Reset_Tropomyosin_Start(void)
{
  extern struct Tropomyosin *TR;

  TR->Weight.St = TR->Weight.Val;
}

void Zero_Actin_Mem(void) 
{
  extern struct Actin *AA;
  int doms;

  for(doms=1;doms<=4;doms++) {
    AA->Dom_Phi[doms] = 0.0;
    AA->Dom_Z[doms] = 0.0;
    AA->Dom_Rad[doms] = 0.0;
    AA->Sph_Sz[doms] = 0.0;
  }
  AA->Repeat = 0.0;
  AA->Azi_Pert = 0.0;
  AA->Z_Pert = 0.0;
  AA->Weight.St  = 0.0;
  AA->Weight.Scl = 0.0;
}

void Reset_Actin_Start(void)
{
  extern struct Actin *AA;

  AA->Weight.St = AA->Weight.Val;
}

void Reset_C_Protein_Start(void)
{
  extern struct C_Protein *CP;
  extern struct Constant Cnst;

  CP->Tilt.St         = CP->Tilt.Val/Cnst.DTR;
  CP->Tilt.Scl       /= Cnst.DTR;
  CP->Pivot_Tilt.St   = CP->Pivot_Tilt.Val/Cnst.DTR;
  CP->Pivot_Tilt.Scl /= Cnst.DTR;
  CP->Pivot_Slew.St   = CP->Pivot_Slew.Val/Cnst.DTR;
  CP->Pivot_Slew.Scl /= Cnst.DTR;
  CP->Azi.St          = CP->Azi.Val/Cnst.DTR;
  CP->Azi.Scl        /= Cnst.DTR;
  CP->Rad.St          = CP->Rad.Val;
  CP->Axial.St        = CP->Axial.Val;
  CP->Weight.St       = CP->Weight.Val;
}

void Zero_C_Protein_Mem(void)
{
  extern struct C_Protein *CP;
     
  CP->Tilt.St         = 0.0;
  CP->Tilt.Scl        = 0.0;
  CP->Pivot_Tilt.St   = 0.0;
  CP->Pivot_Tilt.Scl  = 0.0;
  CP->Pivot_Slew.St   = 0.0;
  CP->Pivot_Slew.Scl  = 0.0;
  CP->Azi.St          = 0.0;
  CP->Azi.Scl         = 0.0;
  CP->Rad.St          = 0.0;
  CP->Axial.St        = 0.0;
  CP->Weight.St       = 0.0;
}

void Reset_Titin_Start(void)
{
  extern struct Titin *TT;
  extern struct Constant Cnst;

  TT->Azi.St    = TT->Azi.Val/Cnst.DTR;
  TT->Azi.Scl  /= Cnst.DTR;
  TT->Rad.St    = TT->Rad.Val;
  TT->Weight.St = TT->Weight.Val;
}

void Zero_Titin_Mem(void)
{
  extern struct Titin *TT;
     
  TT->Azi.St    = 0.0;
  TT->Azi.Scl   = 0.0;
  TT->Rad.St    = 0.0;
  TT->Weight.St = 0.0;
}

void Zero_BackBone_Mem(void)
{
  extern struct BackBone *BB;
     
  BB->Azi.St  = 0.0;
  BB->Azi.Scl = 0.0;
  BB->Sph_Sz  = 0.0;
  BB->Repeat  = 0.0;
  BB->Model   = 0;
  BB->Rad     = 0.0;
}

void Reset_BackBone_Start(void)
{
  extern struct BackBone *BB;
  extern struct Constant Cnst;

  BB->Azi.St   = BB->Azi.Val/Cnst.DTR;
  BB->Azi.Scl /= Cnst.DTR;
}

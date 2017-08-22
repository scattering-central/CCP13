#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

void Myosin_Global_Search()
{
  extern struct Myosin *MY;
  extern struct Info *VAR;
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct Constant Cnst;
  extern struct BackBone *BB;

  int Head,Level;

  for(Head=1;Head<=MY->N_Hds;Head++) {
    if(Head == 1) MY->Slew[Head].St += MY->Slew[Head].Sz;		    
    if(MY->Slew[Head].St == MY->Slew[Head].Max) {
      MY->Slew[Head].St -= MY->Slew[Head].Stp*MY->Slew[Head].Sz;
      MY->Tilt[Head].St += MY->Tilt[Head].Sz;
    }
    MY->Slew[Head].Val = MY->Slew[Head].St*Cnst.DTR;
    if(MY->Tilt[Head].St == MY->Tilt[Head].Max) {
      MY->Tilt[Head].St -= MY->Tilt[Head].Stp*MY->Tilt[Head].Sz;
      MY->Rot[Head].St += MY->Rot[Head].Sz;
    }
    MY->Tilt[Head].Val = MY->Tilt[Head].St*Cnst.DTR;
    if(MY->Rot[Head].St == MY->Rot[Head].Max) {
      MY->Rot[Head].St -= MY->Rot[Head].Stp*MY->Rot[1].Sz;
      if(Head == MY->N_Hds) MY->PSlew[1][1].St += MY->PSlew[1][1].Sz;
      else MY->Slew[Head+1].St += MY->Slew[Head+1].Sz;
    }
    MY->Rot[Head].Val = MY->Rot[Head].St*Cnst.DTR;
  }
  for(Head=1;Head<=MY->N_Hds;Head++) {
    for(Level=1;Level<=MY->N_Crwns;Level++) {		    
      if(MY->PSlew[Level][Head].St == MY->PSlew[Level][Head].Max) {
	MY->PSlew[Level][Head].St -= MY->PSlew[Level][Head].Stp*MY->PSlew[Level][Head].Sz;
	MY->PTilt[Level][Head].St += MY->PTilt[Level][Head].Sz;
      }
      MY->PSlew[Level][Head].Val = MY->PSlew[Level][Head].St*Cnst.DTR;
      if(MY->PTilt[Level][Head].St == MY->PTilt[Level][Head].Max) {
	MY->PTilt[Level][Head].St -= MY->PTilt[Level][Head].Stp*MY->PTilt[Level][Head].Sz;
	MY->PRot[Level][Head].St  += MY->PRot[Level][Head].Sz;
      }
      MY->PTilt[Level][Head].Val = MY->PTilt[Level][Head].St*Cnst.DTR;
      if(MY->PRot[Level][Head].St == MY->PRot[Level][Head].Max) {
	MY->PRot[Level][Head].St -= MY->PRot[Level][Head].Stp*MY->PRot[1][Head].Sz;
	if((Level != MY->N_Crwns) && (Head != MY->N_Hds)) { 
	  MY->PSlew[Level][Head+1].St += MY->PSlew[Level][Head+1].Sz;
	}
	else MY->PRad[1].St += MY->PRad[1].Sz;
      }
      MY->PRot[Level][Head].Val = MY->PRot[Level][Head].St*Cnst.DTR;
    }
  }

  for(Level=1;Level<=MY->N_Crwns;Level++) {		    
    if(MY->PRad[Level].St == MY->PRad[Level].Max) {
      MY->PRad[Level].St -= MY->PRad[Level].Stp*MY->PRad[Level].Sz;
      MY->PAzi[Level].St += MY->PAzi[Level].Sz;
    }
    MY->PRad[Level].Val = MY->PRad[Level].St;
    if(MY->PAzi[Level].St == MY->PAzi[Level].Max) {
      MY->PAzi[Level].St -= MY->PAzi[Level].Stp*MY->PAzi[Level].Sz;
      MY->PAxial[Level].St += MY->PAxial[Level].Sz;
    }
    MY->PAzi[Level].Val = MY->PAzi[Level].St;
    if(MY->PAxial[Level].St == MY->PAxial[Level].Max) {
      MY->PAxial[Level].St -= MY->PAxial[Level].Stp*MY->PAxial[Level].Sz;
      if(Level != MY->N_Crwns) MY->PAzi[Level+1].St += MY->PAzi[Level+1].Sz;
      MY->Hd_Sp.St += MY->Hd_Sp.Sz;
    }
    MY->PAxial[Level].Val = MY->PAxial[Level].St;
  }
  if(MY->Hd_Sp.St == MY->Hd_Sp.Max) {
    MY->Hd_Sp.St -= MY->Hd_Sp.Stp*MY->Hd_Sp.Sz;
    MY->Piv_Tilt.St += MY->Piv_Tilt.Sz;
  }
  MY->Hd_Sp.Val = MY->Hd_Sp.Sz;
  if(MY->Piv_Tilt.St == MY->Piv_Tilt.Max) {
    MY->Piv_Tilt.St -= MY->Piv_Tilt.Stp*MY->Piv_Tilt.Sz;
    MY->Piv_Slew.St   += MY->Piv_Slew.Sz;
  }
  MY->Piv_Tilt.Val = MY->Piv_Tilt.St*Cnst.DTR;
  if(MY->Piv_Slew.St == MY->Piv_Slew.Max) {
    MY->Piv_Slew.St -= MY->Piv_Slew.Stp*MY->Piv_Slew.Sz;
    MY->Rad.St   += MY->Rad.Sz;
  }
  MY->Piv_Slew.Val = MY->Piv_Slew.St*Cnst.DTR;
  if(MY->Rad.St == MY->Rad.Max) {
    MY->Rad.St -= MY->Rad.Stp*MY->Rad.Sz;
    MY->Lat.St += MY->Lat.Sz;
  }
  MY->Rad.Val = MY->Rad.St;
  if(MY->Lat.St == MY->Lat.Max) {
    MY->Lat.St -= MY->Lat.Stp*MY->Lat.Sz;
  }
  MY->Lat.Val = MY->Lat.St*Cnst.DTR;
}

void C_Protein_Global_Search()
{
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct Info *VAR;
  extern struct Constant Cnst;

  if(VAR->Myo == FALSE) CP->Rad.St += CP->Rad.Sz;
  if(CP->Rad.St == CP->Rad.Max) {
    CP->Rad.St -= CP->Rad.Stp*CP->Rad.Sz;
    CP->Tilt.St += CP->Tilt.Sz;
  }
  CP->Rad.Val = CP->Rad.St;
  if(CP->Tilt.St == CP->Tilt.Max) {
    CP->Tilt.St       -= CP->Tilt.Stp*CP->Tilt.Sz;
    CP->Pivot_Tilt.St += CP->Pivot_Tilt.Sz;
  }
  CP->Tilt.Val = CP->Tilt.St*Cnst.DTR;
  if(CP->Pivot_Tilt.St == CP->Pivot_Tilt.Max) {
    CP->Pivot_Tilt.St -= CP->Pivot_Tilt.Stp*CP->Pivot_Tilt.Sz;
    CP->Pivot_Slew.St += CP->Pivot_Slew.Sz;
  }
  CP->Pivot_Tilt.Val = CP->Pivot_Tilt.St*Cnst.DTR;
  if(CP->Pivot_Slew.St == CP->Pivot_Slew.Max) {
    CP->Pivot_Slew.St -= CP->Pivot_Slew.Stp*CP->Pivot_Slew.Sz;
    CP->Axial.St      += CP->Axial.Sz;
  }
  CP->Pivot_Slew.Val = CP->Pivot_Slew.St*Cnst.DTR;
  if(CP->Axial.St == CP->Axial.Max) {
    CP->Axial.St -= CP->Axial.Stp*CP->Axial.Sz;
    CP->Azi.St   += CP->Azi.Sz;
  }
  CP->Axial.Val = CP->Axial.St;
  if(CP->Azi.St == CP->Azi.Max) {
    CP->Azi.St    -= CP->Azi.Stp*CP->Azi.Sz;
    CP->Weight.St += CP->Weight.Sz;
  }
  CP->Azi.Val = CP->Azi.St*Cnst.DTR;
  if(CP->Weight.St == CP->Weight.Max) {
    CP->Weight.St -= CP->Weight.Stp*CP->Weight.Sz;
  }
  CP->Weight.Val = CP->Weight.St;
}

void Titin_Global_Search()
{
  extern struct Titin *TT;
  extern struct Info *VAR;
  extern struct Constant Cnst;

  TT->Rad.St += TT->Rad.Sz;
  if(TT->Rad.St == TT->Rad.Max) {
    TT->Rad.St   -= TT->Rad.Stp*TT->Rad.Sz;
    TT->Azi.St += TT->Azi.Sz;
  }
  TT->Rad.Val = TT->Rad.St;
  if(TT->Azi.St == TT->Azi.Max) {
    TT->Azi.St    -= TT->Azi.Stp*TT->Azi.Sz;
    TT->Weight.St += TT->Weight.Sz;
  }
  TT->Azi.Val = TT->Azi.St*Cnst.DTR;
  if(TT->Weight.St == TT->Weight.Max) {
    TT->Weight.St -= TT->Weight.Stp*TT->Weight.Sz;
  }
  TT->Weight.Val = TT->Weight.St;
}

void BackBone_Global_Search()
{
  extern struct BackBone *BB;
  extern struct Info *VAR;
  extern struct Constant Cnst;

  BB->Azi.St += BB->Azi.Sz;
  if(BB->Azi.St == BB->Azi.Max) {
    BB->Azi.St -= BB->Azi.Stp*BB->Azi.Sz;
  }
  BB->Azi.Val = BB->Azi.St;
}

void Actin_Global_Search()
{
  extern struct Actin *AA;
  extern struct Info *VAR;
  extern struct Constant Cnst;

  AA->Weight.St += AA->Weight.Sz;
  if(AA->Weight.St == AA->Weight.Max) {
    AA->Weight.St -= AA->Weight.Stp*AA->Weight.Sz;
  }
  AA->Weight.Val = AA->Weight.St;
}

void Tropomyosin_Global_Search()
{
  extern struct Tropomyosin *TR;
  extern struct Info *VAR;
  extern struct Constant Cnst;

  TR->Weight.St += TR->Weight.Sz;
  if(TR->Weight.St == TR->Weight.Max) {
    TR->Weight.St -= TR->Weight.Stp*TR->Weight.Sz;
  }
  TR->Weight.Val = TR->Weight.St;
}

int Iterations()
{
  extern struct Myosin *MY;
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct Info *VAR;
  extern struct BackBone *BB;
  extern struct Tropomyosin *TR;
  extern struct Actin *AA;

  int Iter,Level,Head;

  Iter = 1;
  if(VAR->Myo) {
    for(Head=1;Head<=MY->N_Hds;Head++) {
      if(MY->Slew[Head].Stp > SMALL) Iter *= (int)MY->Slew[Head].Stp;
      if(MY->Tilt[Head].Stp > SMALL) Iter *= (int)MY->Tilt[Head].Stp;
      if(MY->Rot[Head].Stp > SMALL) Iter  *= (int)MY->Rot[Head].Stp;
      for(Level=1;Level<=MY->N_Crwns;Level++) {
	if(MY->PSlew[Level][Head].Stp > SMALL) Iter *= (int)MY->PSlew[Level][Head].Stp;
	if(MY->PTilt[Level][Head].Stp > SMALL) Iter *= (int)MY->PTilt[Level][Head].Stp;
	if(MY->PRot[Level][Head].Stp > SMALL) Iter *= (int)MY->PRot[Level][Head].Stp;
      }
    }
    for(Level=1;Level<=MY->N_Crwns;Level++) {
      if(MY->PRad[Level].Stp > SMALL)    Iter *= (int)MY->PRad[Level].Stp;
      if(MY->PAxial[Level].Stp > SMALL)  Iter *= (int)MY->PAxial[Level].Stp;
      if(MY->PAzi[Level].Stp > SMALL)    Iter *= (int)MY->PAzi[Level].Stp;
    }
    if(MY->Hd_Sp.Stp > SMALL)    Iter *= (int)MY->Hd_Sp.Stp;
    if(MY->Hd_An.Stp > SMALL)    Iter *= (int)MY->Hd_An.Stp;
    if(MY->Rad.Stp > SMALL)      Iter *= (int)MY->Rad.Stp;
    if(MY->Lat.Stp > SMALL)      Iter *= (int)MY->Lat.Stp;
    if(MY->Piv_Tilt.Stp > SMALL) Iter *= (int)MY->Piv_Tilt.Stp;
    if(MY->Piv_Slew.Stp > SMALL) Iter *= (int)MY->Piv_Slew.Stp;
  }
  if(VAR->CPro) {
    if(CP->Tilt.Stp > SMALL)       Iter *= (int)CP->Tilt.Stp;
    if(CP->Pivot_Tilt.Stp > SMALL) Iter *= (int)CP->Pivot_Tilt.Stp;
    if(CP->Pivot_Slew.Stp > SMALL) Iter *= (int)CP->Pivot_Slew.Stp;
    if(CP->Azi.Stp > SMALL)        Iter *= (int)CP->Azi.Stp;
    if(CP->Rad.Stp > SMALL)        Iter *= (int)CP->Rad.Stp;
    if(CP->Axial.Stp > SMALL)      Iter *= (int)CP->Axial.Stp;
    if(CP->Weight.Stp > SMALL)     Iter *= (int)CP->Weight.Stp;
  }
  if(VAR->Titin) {
    if(TT->Azi.Stp > SMALL)    Iter *= (int)TT->Azi.Stp;
    if(TT->Rad.Stp > SMALL)    Iter *= (int)TT->Rad.Stp;
    if(TT->Weight.Stp > SMALL) Iter *= (int)TT->Weight.Stp;
  }
  if(VAR->Actin) {
    if(AA->Weight.Stp > SMALL) Iter *= (int)AA->Weight.Stp;
  }
  if(VAR->Tropomyosin) {
    if(TR->Weight.Stp > SMALL) Iter *= (int)TR->Weight.Stp;
  }
  if(VAR->BBone) {
    if(BB->Azi.Stp > SMALL) Iter *= (int)BB->Azi.Stp;
  }
  return Iter;
}

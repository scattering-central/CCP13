#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

void Process_Data() /* Central Function Calling Routine */
{
  extern struct Info *VAR;
  extern struct Myosin *MY;
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct BackBone *BB;
  extern struct Constant Cnst;
  extern struct Tropomyosin *TR;
  extern struct Actin *AA;
  extern struct Intensity *ID;

  double temp1,temp2;
  int Head,Level,nRefinement,Iter;
  int No_Perts_Var1,No_Perts_Var2,l,m,i1,i2;

  nRefinement = 0;
  Iter = TRUE;

  if(VAR->NoPerts) {
    Generate_Bessel_Orders();
    Generate_Bessel_Table();
  }
  if((VAR->Observed) || (VAR->View) || 
     (VAR->HKLOutput) || (VAR->Fourier_Diff) || (VAR->Reflections)) { 
    if(VAR->Myo) {
      Set_Myosin_Vals();
      Trans_Myosin_Coords();
    }
    if(VAR->CPro) {
      Set_C_Protein_Vals();
      Trans_C_Protein_Coords();
    }
    if(VAR->Titin) {
      Set_Titin_Vals();
      Trans_Titin_Coords();
    }
    if(VAR->Tropomyosin) {
      Set_Tropomyosin_Vals();
      Trans_Tropomyosin_Coords();
    }
    if(VAR->Actin) {
      Set_Actin_Vals();
      Trans_Actin_Coords();
    }
    if(VAR->BBone) {
      if(BB->Model == 0) {
	Set_BackBone_Vals();
	Trans_BackBone_Coords();
      }
    }
    if(!VAR->View) Fourier_Calculation();
    Output();
  }
  if(VAR->Global) {
    printf("\nParameters Searching Over : ");
    Set_Initial_Vals();
    Iter = Iterations();
    printf("\n\n");
    while(nRefinement != Iter) {
      if(VAR->Myo)   Trans_Myosin_Coords();
      if(VAR->CPro)  Trans_C_Protein_Coords();
      if(VAR->Titin) Trans_Titin_Coords();
      if(VAR->BBone) if(BB->Model == 0)Trans_BackBone_Coords();
      Fourier_Calculation();
      Output();
      nRefinement++;
      if(VAR->Myo)   Myosin_Global_Search();
      if(VAR->CPro)  C_Protein_Global_Search();
      if(VAR->Titin) Titin_Global_Search();
      if(VAR->BBone) if(BB->Model == 0) BackBone_Global_Search();
    } 
  }
  if ((VAR->Simplex) || (VAR->Torus) || (VAR->Powell) || (VAR->Anneal) || (VAR->Replex)) {
    printf("\nParameters Searching Over : ");
    if(VAR->Myo)   Set_Myosin_Vals();
    if(VAR->CPro)  Set_C_Protein_Vals();
    if(VAR->Titin) Set_Titin_Vals();
    if(VAR->BBone) if(BB->Model == 0) Set_BackBone_Vals();
    if(VAR->Myo) {
      for(Head=1;Head<=MY->N_Hds;Head++) {
	if((MY->Slew[Head].Scl*=Cnst.DTR) > SMALL) printf("MS%d ",Head);
	if((MY->Tilt[Head].Scl*=Cnst.DTR) > SMALL) printf("MT%d ",Head);
	if((MY->Rot[Head].Scl*=Cnst.DTR) >  SMALL) printf("MR%d ",Head);
	for(Level=1;Level<=MY->N_Crwns;Level++) {
	  if((MY->PSlew[Level][Head].Scl*=Cnst.DTR) > SMALL) 
	    printf("MPS%d%d ",Level,Head);
	  if((MY->PTilt[Level][Head].Scl*=Cnst.DTR) > SMALL) 
	    printf("MPT%d%d ",Level,Head);
	  if((MY->PRot[Level][Head].Scl*=Cnst.DTR) > SMALL)  
	    printf("MPR%d%d ",Level,Head);
	}
      }
      for(Level=1;Level<=MY->N_Crwns;Level++) {
	if(MY->PRad[Level].Scl > SMALL)   printf("MPRd%d ",Level);
	if(MY->PAxial[Level].Scl > SMALL) printf("MPAx%d ",Level);
	if((MY->PAzi[Level].Scl*=Cnst.DTR) > SMALL ) printf("MPAz%d ",Level);
      }
	 
      if(MY->Hd_Sp.Scl > SMALL) printf("MHS ");
      if((MY->Hd_An.Scl*=Cnst.DTR) > SMALL) printf("MHA ");
      if(MY->Rad.Scl > SMALL) printf("MR ");
      if((MY->Lat.Scl*=Cnst.DTR) > SMALL) printf("MRL ");
      if((MY->Piv_Tilt1.Scl*=Cnst.DTR) > SMALL) printf("MPiT1 ");
      if((MY->Piv_Slew1.Scl*=Cnst.DTR) > SMALL) printf("MPiS1 ");
      if((MY->Piv_Rot1.Scl*=Cnst.DTR) > SMALL) printf("MPiR1 ");
      if((MY->Piv_Tilt2.Scl*=Cnst.DTR) > SMALL) printf("MPiT2 ");
      if((MY->Piv_Slew2.Scl*=Cnst.DTR) > SMALL) printf("MPiS2 ");
      if((MY->Piv_Rot2.Scl*=Cnst.DTR) > SMALL) printf("MPiR2 ");
    }
    if(VAR->CPro) {
      if((CP->Tilt.Scl*=Cnst.DTR) > SMALL) printf("CPT ");
      if((CP->Pivot_Tilt.Scl*=Cnst.DTR) > SMALL) printf("CPPT ");
      if(CP->Pivot_Type == 2) if((CP->Pivot_Slew.Scl*=Cnst.DTR) > SMALL) 
	printf("CPPS ");
      if((CP->Azi.Scl*=Cnst.DTR) > SMALL) printf("CPAz ");
      if(CP->Rad.Scl > SMALL) printf("CPR ");
      if(CP->Axial.Scl > SMALL) printf("CPAx ");
      if(CP->Weight.Scl > SMALL) printf("CPW ");
    }
    if(VAR->Titin) {
      if((TT->Azi.Scl*=Cnst.DTR) > SMALL) printf("TTAz ");
      if(TT->Rad.Scl > SMALL) printf("TTR ");
      if(TT->Weight.Scl > SMALL) printf("TTW ");
    }
    if(VAR->BBone) {
      if(BB->Model == 0)
	if((BB->Azi.Scl*=Cnst.DTR) > SMALL) printf("BBAz ");
    }
    if(VAR->Tropomyosin) {
      if(TR->Weight.Scl > SMALL) printf("TRW ");
    }
    if(VAR->Actin) {
      if(AA->Weight.Scl > SMALL) printf("AAW ");
    }
    printf("\n\n");
    if(VAR->Simplex) Simplex();
    if(VAR->Torus)   Torus();
    if(VAR->Powell)  Powell();
    if(VAR->Anneal)  Anneal();
    if(VAR->Replex)  Replex();
  }
}

void Generate_Bessel_Orders()
{
  extern struct Info *VAR;
  extern struct Constant Cnst;
  extern struct Intensity *ID;  
  
  int num,i,j,l;
  double bessel_order;

  ID->Bes_Orders = imatrix(0,ID->l_max,0,20);
  ID->Bes_Contrib = imatrix(0,ID->l_max,0,20);
  ID->Max_Bessels = 0;

  for(l=0;l<=ID->l_max;l++) {
    i = 0;
    j = -1;
    bessel_order = 0.0;
    num = 0;   
    while(fabs(bessel_order) <= ID->Bes_Num) {
      if(VAR->N_Strnds == 3) bessel_order = 3*l - 9*i;
      if(VAR->N_Strnds == 4) bessel_order = (4*l - 32*i)/3.0;
      if((double)(int)(bessel_order) != bessel_order) {
	bessel_order = 0.0;
	i++;
	continue;
      }      
      else {
	if(fabs(bessel_order) > ID->Bes_Num) continue;
	ID->Bes_Orders[l][num] = bessel_order;
	if(ID->Bes_Orders[l][num] < 0 ) ID->Bes_Contrib[l][num] = pow(-1,ID->Bes_Orders[l][num]);
	else ID->Bes_Contrib[l][num] = 1;
	num++;
	i++;
      }
    }
    bessel_order = 0.0;  
    while(fabs(bessel_order) <= ID->Bes_Num) {
      if(VAR->N_Strnds == 3) bessel_order = 3*l - 9*j;
      if(VAR->N_Strnds == 4) bessel_order = (4*l - 32*j)/3.0;
      if((double)(int)(bessel_order) != bessel_order) {
	bessel_order = 0.0;
	j--;
	continue;
      }      
      else {
	if(fabs(bessel_order) > ID->Bes_Num) continue;
	ID->Bes_Orders[l][num] = bessel_order;
	if(ID->Bes_Orders[l][num] < 0 ) ID->Bes_Contrib[l][num] = pow(-1,ID->Bes_Orders[l][num]);
	else ID->Bes_Contrib[l][num] = 1;
	num++;
	j--;
      }
    }
    ID->Bes_Orders[l][num] = 999;
    if(ID->Max_Bessels < num) ID->Max_Bessels = num;
  }
}


void Generate_Bessel_Table()
{
  extern struct Constant Cnst;
  extern struct Intensity *ID;
  extern struct Info *VAR;
  
  int Rad,R_Rad,m;
  double bes_arg,RR_Rad;
  
  ID->Bessel = d3tensor(0,901,0,ID->R_max,0,ID->Bes_Num);
  
  for(Rad = 0;Rad<=ID->R_max;Rad++) {
    for(R_Rad=0;R_Rad<=900;R_Rad++) {               /* Sample 900 points */
      RR_Rad = sqrt((double)Rad)/(VAR->U_Cl*Cnst.Root_tq);
      bes_arg = fabs(Cnst.Two_Pi*R_Rad*RR_Rad/2.0);
      ID->Bessel[R_Rad][Rad][0] = bessj0(bes_arg);
      ID->Bessel[R_Rad][Rad][1] = bessj1(bes_arg);
      for(m=2;m<=ID->Bes_Num;m++) {
	ID->Bessel[R_Rad][Rad][m] = bessj(m,bes_arg);
      }
    }
  }
}

void Set_Myosin_Vals()
{
  extern struct Myosin *MY;
  extern struct Constant Cnst;
  
  int Level,Head;
  
  for(Head=1;Head<=MY->N_Hds;Head++) {
    MY->Slew[Head].Val  =  MY->Slew[Head].St*Cnst.DTR;
    MY->Tilt[Head].Val  =  MY->Tilt[Head].St*Cnst.DTR;
    MY->Rot[Head].Val   =  MY->Rot[Head].St*Cnst.DTR;
    for(Level=1;Level<=MY->N_Crwns;Level++) {
      MY->PSlew[Level][Head].Val = MY->PSlew[Level][Head].St*Cnst.DTR;
      MY->PTilt[Level][Head].Val = MY->PTilt[Level][Head].St*Cnst.DTR;
      MY->PRot[Level][Head].Val  = MY->PRot[Level][Head].St*Cnst.DTR;
    }
  }
  for(Level=1;Level<=MY->N_Crwns;Level++) {
    MY->PRad[Level].Val   =  MY->PRad[Level].St;
    MY->PAxial[Level].Val =  MY->PAxial[Level].St;
    MY->PAzi[Level].Val   =  MY->PAzi[Level].St*Cnst.DTR;
  }
  MY->Hd_Sp.Val    = MY->Hd_Sp.St;
  MY->Hd_An.Val    = MY->Hd_An.St*Cnst.DTR;
  MY->Lat.Val      = MY->Lat.St*Cnst.DTR;
  MY->Rad.Val      = MY->Rad.St;
  MY->Piv_Tilt1.Val = MY->Piv_Tilt1.St*Cnst.DTR;
  MY->Piv_Slew1.Val = MY->Piv_Slew1.St*Cnst.DTR;
  MY->Piv_Rot1.Val = MY->Piv_Rot1.St*Cnst.DTR;
  MY->Piv_Tilt2.Val = MY->Piv_Tilt2.St*Cnst.DTR;
  MY->Piv_Slew2.Val = MY->Piv_Slew2.St*Cnst.DTR;
  MY->Piv_Rot2.Val = MY->Piv_Rot2.St*Cnst.DTR;  
}

void Set_Tropomyosin_Vals()
{
  extern struct Tropomyosin *TR;
  extern struct Constant Cnst;
  
  TR->Phi *= Cnst.DTR;
  TR->Weight.Val = TR->Weight.St;
}

void Set_Actin_Vals()
{
  extern struct Actin *AA;
  extern struct Constant Cnst;
  
  int doms;
  
  for(doms=1;doms<=AA->Tot_Dom;doms++) { 
    AA->Dom_Phi[doms] *= Cnst.DTR;
  }
  AA->Azi_Pert *= Cnst.DTR;
  AA->Weight.Val = AA->Weight.St;
}

void Set_C_Protein_Vals()
{
  extern struct C_Protein *CP;
  extern struct Constant Cnst;
  
  CP->Tilt.Val       = CP->Tilt.St*Cnst.DTR;
  CP->Pivot_Tilt.Val = CP->Pivot_Tilt.St*Cnst.DTR;
  CP->Pivot_Slew.Val = CP->Pivot_Slew.St*Cnst.DTR;
  CP->Azi.Val        = CP->Azi.St*Cnst.DTR;
  CP->Rad.Val        = CP->Rad.St;
  CP->Axial.Val      = CP->Axial.St;
  CP->Weight.Val     = CP->Weight.St;
}

void Set_Titin_Vals()
{
  extern struct Titin *TT;
  extern struct Constant Cnst;
  
  TT->Azi.Val    =  TT->Azi.St*Cnst.DTR;
  TT->Rad.Val    =  TT->Rad.St;
  TT->Weight.Val = TT->Weight.St;
}

void Set_BackBone_Vals()
{
  extern struct BackBone *BB;
  extern struct Constant Cnst;
  
  BB->Azi.Val = BB->Azi.St*Cnst.DTR;
}

void Set_Initial_Vals()
{
  extern struct Myosin *MY;
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct BackBone *BB;
  extern struct Info *VAR;
  extern struct Tropomyosin *TR;
  extern struct Actin *AA;

  int Head,Level;
  
  if(VAR->Myo) {
    Set_Myosin_Vals();
    for(Head=1;Head<=MY->N_Hds;Head++) {
      MY->Slew[Head].Max = MY->Slew[Head].St+(MY->Slew[Head].Sz*MY->Slew[Head].Stp);
      MY->Tilt[Head].Max = MY->Tilt[Head].St+(MY->Tilt[Head].Sz*MY->Tilt[Head].Stp);
      MY->Rot[Head].Max  = MY->Rot[Head].St+(MY->Rot[Head].Sz*MY->Rot[Head].Stp);
      if(MY->Slew[Head].Stp > SMALL) printf("MS%d ",Head);
      if(MY->Tilt[Head].Stp > SMALL) printf("MT%d ",Head);
      if(MY->Rot[Head].Stp > SMALL)  printf("MR%d ",Head);
      for(Level=1;Level<=MY->N_Crwns;Level++) {
	MY->PSlew[Level][Head].Max = MY->PSlew[Level][Head].St+(MY->PSlew[Level][Head].Sz*MY->PSlew[Level][Head].Stp);
	MY->PTilt[Level][Head].Max = MY->PTilt[Level][Head].St+(MY->PTilt[Level][Head].Sz*MY->PTilt[Level][Head].Stp);
	MY->PRot[Level][Head].Max  = MY->PRot[Level][Head].St+(MY->PRot[Level][Head].Sz *MY->PRot[Level][Head].Stp);
	if(MY->PSlew[Level][Head].Stp > SMALL) printf("MPS%d%d ",Level,Head);
	if(MY->PTilt[Level][Head].Stp > SMALL) printf("MPT%d%d ",Level,Head);
	if(MY->PRot[Level][Head].Stp > SMALL)  printf("MPR%d%d ",Level,Head);
      }
    }
    for(Level=1;Level<=MY->N_Crwns;Level++) {
      MY->PRad[Level].Max   = MY->PRad[Level].St+(MY->PRad[Level].Sz*MY->PRad[Level].Stp);
      MY->PAxial[Level].Max = MY->PAxial[Level].St+(MY->PAxial[Level].Sz*MY->PAxial[Level].Stp);
      MY->PAzi[Level].Max = MY->PAzi[Level].St+(MY->PAzi[Level].Sz*MY->PAzi[Level].Stp);
      if(MY->PRad[Level].Stp > SMALL)   printf("MPRd%d ",Level);
      if(MY->PAxial[Level].Stp > SMALL) printf("MPAx%d ",Level);
      if(MY->PAzi[Level].Stp > SMALL)   printf("MPAz%d ",Level);
    }
    MY->Hd_Sp.Max    = MY->Hd_Sp.St+(MY->Hd_Sp.Sz*MY->Hd_Sp.Stp);
    MY->Hd_An.Max    = MY->Hd_An.St+(MY->Hd_An.Sz*MY->Hd_An.Stp);
    MY->Rad.Max      = MY->Rad.St+(MY->Rad.Sz*MY->Rad.Stp);
    MY->Lat.Max      = MY->Lat.St+(MY->Lat.Sz*MY->Lat.Stp);
    MY->Piv_Tilt1.Max = MY->Piv_Tilt1.St+(MY->Piv_Tilt1.Sz*MY->Piv_Tilt1.Stp);
    MY->Piv_Slew1.Max = MY->Piv_Slew1.St+(MY->Piv_Slew1.Sz*MY->Piv_Slew1.Stp);
    MY->Piv_Rot1.Max = MY->Piv_Rot1.St+(MY->Piv_Rot1.Sz*MY->Piv_Rot1.Stp);
    MY->Piv_Tilt2.Max = MY->Piv_Tilt2.St+(MY->Piv_Tilt2.Sz*MY->Piv_Tilt2.Stp);
    MY->Piv_Slew2.Max = MY->Piv_Slew2.St+(MY->Piv_Slew2.Sz*MY->Piv_Slew2.Stp);
    MY->Piv_Rot2.Max = MY->Piv_Rot2.St+(MY->Piv_Rot2.Sz*MY->Piv_Rot2.Stp);    
    if(MY->Hd_Sp.Stp > SMALL)    printf("MHS ");
    if(MY->Hd_An.Stp > SMALL)    printf("MHA ");
    if(MY->Rad.Stp > SMALL)      printf("MR  ");
    if(MY->Lat.Stp > SMALL)      printf("ML  ");
    if(MY->Piv_Tilt1.Stp > SMALL) printf("MPiT1 ");
    if(MY->Piv_Slew1.Stp > SMALL) printf("MPiS1 ");
    if(MY->Piv_Rot1.Stp > SMALL) printf("MPiR1 ");
    if(MY->Piv_Tilt2.Stp > SMALL) printf("MPiT2 ");
    if(MY->Piv_Slew2.Stp > SMALL) printf("MPiS2 ");
    if(MY->Piv_Rot2.Stp > SMALL) printf("MPiR2 ");    
  }
  
  if(VAR->CPro) {
    Set_C_Protein_Vals();
    
    CP->Tilt.Max       = CP->Tilt.St+(CP->Tilt.Sz*CP->Tilt.Stp);
    CP->Pivot_Tilt.Max = CP->Pivot_Tilt.St+(CP->Pivot_Tilt.Sz*CP->Pivot_Tilt.Stp);
    CP->Pivot_Slew.Max = CP->Pivot_Slew.St+(CP->Pivot_Slew.Sz*CP->Pivot_Slew.Stp);
    CP->Azi.Max        = CP->Azi.St+(CP->Azi.Sz*CP->Azi.Stp);
    CP->Rad.Max        = CP->Rad.St+(CP->Rad.Sz*CP->Rad.Stp);
    CP->Weight.Max     = CP->Weight.St+(CP->Weight.Sz*CP->Weight.Stp);
    CP->Axial.Max      = CP->Axial.St+(CP->Axial.Sz*CP->Axial.Stp);
    if(CP->Tilt.Stp > SMALL)       printf("CPT ");
    if(CP->Pivot_Tilt.Stp > SMALL) printf("CPPT ");
    if(CP->Pivot_Slew.Stp > SMALL) printf("CPPS ");
    if(CP->Azi.Stp > SMALL)        printf("CPAz ");
    if(CP->Rad.Stp > SMALL)        printf("CPR ");
    if(CP->Axial.Stp > SMALL)      printf("CPAx ");
    if(CP->Weight.Stp > SMALL)     printf("CPR ");
  }
  
  if(VAR->Titin) {
    Set_Titin_Vals();
    
    TT->Azi.Max    = TT->Azi.St+(TT->Azi.Sz*TT->Azi.Stp);
    TT->Rad.Max    = TT->Rad.St+(TT->Rad.Sz*TT->Rad.Stp);
    TT->Weight.Max = TT->Weight.St+(TT->Weight.Sz*TT->Weight.Stp);
    if(TT->Azi.Stp > SMALL)   printf("TTAz ");
    if(TT->Rad.Stp > SMALL)   printf("TTR ");
    if(TT->Weight.Stp > SMALL) printf("TTW ");
  }
  
  if(VAR->BBone) if(BB->Model == 0) {
    Set_BackBone_Vals();
    
    BB->Azi.Max = BB->Azi.St+(BB->Azi.Sz*BB->Azi.Stp);
    if(BB->Azi.Stp > SMALL) printf("BBAz ");
  }
  
  if(VAR->Tropomyosin) {
    Set_Tropomyosin_Vals();
    
    TR->Weight.Max = TR->Weight.St+(TR->Weight.Sz*TR->Weight.Stp);    
    if(TR->Weight.Stp > SMALL) printf("TRW ");
  }
  
  if(VAR->Actin) {
    Set_Actin_Vals();
    
    AA->Weight.Max = AA->Weight.St+(AA->Weight.Sz*AA->Weight.Stp);
    if(AA->Weight.Stp > SMALL) printf("AAW ");
  }
}

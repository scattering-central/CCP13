#define NRANSI
#define FTOL 1e-8
#define ITMAX 5
#define MAXIT 5
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

double Refinement( double *x) /* Interface For Numerical Recipies */
{
  extern struct Info *VAR;  
  extern struct Myosin *MY; 
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct BackBone *BB;
  extern struct Intensity *ID; 

  int i,Head,Level;
  i = 1;

  if((VAR->Replex) || (VAR->Torus)) i--;

  if(VAR->Myo) {
    for(Head=1;Head<=MY->N_Hds;Head++) {
      if(MY->Slew[Head].Scl != 0.0) MY->Slew[Head].Val = x[i++];
      if(MY->Tilt[Head].Scl != 0.0) MY->Tilt[Head].Val = x[i++];
      if(MY->Rot[Head].Scl != 0.0)  MY->Rot[Head].Val = x[i++];
      for(Level=1;Level<=MY->N_Crwns;Level++) {
	if(MY->PSlew[Level][Head].Scl != 0.0) MY->PSlew[Level][Head].Val = x[i++];
	if(MY->PTilt[Level][Head].Scl != 0.0) MY->PTilt[Level][Head].Val = x[i++];
	if(MY->PRot[Level][Head].Scl != 0.0)  MY->PRot[Level][Head].Val = x[i++];
      } 
    }
    for(Level=1;Level<=MY->N_Crwns;Level++) {
      if(MY->PRad[Level].Scl != 0.0)   MY->PRad[Level].Val = x[i++];
      if(MY->PAxial[Level].Scl != 0.0) MY->PAxial[Level].Val = x[i++];
      if(MY->PAzi[Level].Scl != 0.0)   MY->PAzi[Level].Val = x[i++];

    }
    if(MY->Hd_Sp.Scl != 0.0)    MY->Hd_Sp.Val = x[i++];
    if(MY->Hd_An.Scl != 0.0)    MY->Hd_An.Val = x[i++];
    if(MY->Rad.Scl != 0.0)      MY->Rad.Val = x[i++];
    if(MY->Lat.Scl != 0.0)      MY->Lat.Val = x[i++];
    if(MY->Piv_Tilt1.Scl != 0.0) MY->Piv_Tilt1.Val = x[i++];
    if(MY->Piv_Slew1.Scl != 0.0) MY->Piv_Slew1.Val = x[i++];
    if(MY->Piv_Rot1.Scl != 0.0) MY->Piv_Rot1.Val = x[i++];
    if(MY->Piv_Tilt2.Scl != 0.0) MY->Piv_Tilt2.Val = x[i++];
    if(MY->Piv_Slew2.Scl != 0.0) MY->Piv_Slew2.Val = x[i++];
    if(MY->Piv_Rot2.Scl != 0.0) MY->Piv_Rot2.Val = x[i++];        
    Trans_Myosin_Coords();
  }

  if(VAR->CPro) {
    if(CP->Tilt.Scl != 0.0)       CP->Tilt.Val = x[i++];
    if(CP->Pivot_Tilt.Scl != 0.0) CP->Pivot_Tilt.Val = x[i++];
    if(CP->Pivot_Type == 2) {
      if(CP->Pivot_Slew.Scl != 0.0) { 
	CP->Pivot_Slew.Val = x[i++];
      }
    }
    if(CP->Azi.Scl != 0.0)        CP->Azi.Val = x[i++];
    if(CP->Rad.Scl != 0.0)        CP->Rad.Val = x[i++];
    if(CP->Axial.Scl != 0.0)      CP->Axial.Val = x[i++];
    if(CP->Weight.Scl != 0.0)     CP->Weight.Val = x[i++];
    Trans_C_Protein_Coords();
  }

  if(VAR->Titin) {
    if(TT->Azi.Scl != 0.0)    TT->Azi.Val = x[i++];
    if(TT->Rad.Scl != 0.0)    TT->Rad.Val = x[i++];
    if(TT->Weight.Scl != 0.0) TT->Weight.Val = x[i++];
    Trans_Titin_Coords();
  }

  if(VAR->BBone) {
    if(BB->Azi.Scl != 0.0) BB->Azi.Val = x[i++];
    Trans_BackBone_Coords();
  }

  Fourier_Calculation();
  Output();
  if((VAR->Least_Sq) || (VAR->Cryst)) {
    if(VAR->Combine) return VAR->CWeight*ID->R_Fac+ID->MR_Fac;
    else return ID->R_Fac;
  }
  if(VAR->Corr) {
    if(VAR->Combine) return (2.0 - (ID->MC_Fac+ID->C_Fac))/2.0;
    else return (1.0 - ID->C_Fac);
  }
  return 0.0; 
}

void Torus()
{

  extern struct Constant Cnst;
     
  int i,j,DIM,nRefinement,flag;
  double Scl[100],ans;
  double val[100],*lower,*upper;
  double *cut,*shft,*newval;
  char *min = "min";

  Torus_Input input;
     
  input.bump = 0.5;
  input.counter1 = 4;
  input.counter2 = 40;
  input.tor_exit = 1.0e-06;
  input.scalar1 = 1;
  input.scalar2 = 1;
  input.shrink_hit = 1.5;
  input.shrink_trial = 1.5;
  input.tor_hole = 4000.0;

  DIM = Dimension(val,Scl);

  lower = dvector(0,DIM+1);
  upper = dvector(0,DIM+1);
  cut   = dvector(0,DIM+1);

  for(i=0;i<=DIM;i++) {
    lower[i] = val[i] - Scl[i];
    upper[i] = val[i] + Scl[i];
    cut[i] = Scl[i]/20.0;
  }
  flag = torus ("d", lower, upper, cut, Refinement, min, val, DIM+1, &input);
  free_dvector(lower,0,DIM+1);
  free_dvector(upper,0,DIM+1);
  free_dvector(cut,0,DIM+1);
  Finish();
}

void Simplex() /* The DownHill Simplex Method */
{
  int i,j,DIM,NDIM,nRefinement;
  double Scl[100];
  double val[100],*Initial,**Result;

  DIM  = Dimension(val,Scl);
  NDIM = DIM + 1;
  Initial = dvector(1,NDIM+1);
  Result  = dmatrix(1,NDIM+1,1,DIM+1);

  for(i=1;i<=NDIM;i++) {
    for(j=1;j<=DIM;j++) {
      Result[i][j]=(i == (j+1) ? val[j]+Scl[j] : val[j]);
      val[j] = Result[i][j];
    }
    Initial[i]=Refinement(val);
  }
  amoeba(Result,Initial,DIM,FTOL,Refinement,&nRefinement);
  free_dvector(Initial,1,NDIM+1);
  free_dmatrix(Result,1,NDIM+1,1,DIM+1);
  Finish();
}

void Replex() /* The DownHill Replex Method */
{
  int DIM,iflag;
  double Scl[100],fret;
  double val[100];

  DIM = Dimension(val,Scl);

  iflag = replex(val,Scl,DIM+1,Refinement,ITMAX,MAXIT,FTOL,0,&fret);
  Finish();
}

void Powell() /* Powell's Method */
{
  int i,j,NDIM,nRefinement;
  double Scl[100],fret;
  double val[100],**Result;

  NDIM   = Dimension(val,Scl);
  Result = dmatrix(1,NDIM+1,1,NDIM+1);

  for(i=1;i<=NDIM;i++) {
    for(j=1;j<=NDIM;j++) {
      Result[i][j] = (i == j ? Scl[j] : 0.0);
    }
  }
  powell(val,Result,NDIM,FTOL,&nRefinement,&fret,Refinement);
  free_dmatrix(Result,1,NDIM+1,1,NDIM+1);
  Finish();
}

void Anneal() /* Simulated Annealing */
{
  extern struct Info *VAR;
  extern struct Info *VAR;
  extern long idum;

  int i,j,DIM,NDIM,nRefinement;
  int iter,jiter;
  double yb,ybb;
  double Scl[100];
  double val[100],*Initial,**Result,*Final;

  idum        = -64;         /* Random number seed for 'ran1()' */
  yb          = 1.0e30;
  ybb         = 1.0e30;
  nRefinement = 0;

  DIM     = Dimension(val,Scl);

  NDIM    = DIM + 1;
  Final   = dvector(1,DIM+1);
  Initial = dvector(1,NDIM+1);
  Result  = dmatrix(1,NDIM+1,1,DIM+1);

  for(i=1;i<=NDIM;i++) {
    for(j=1;j<=DIM;j++) {
      Result[i][j]=(i == (j+1) ? val[j]+Scl[j] : val[j]);
      val[j] = Result[i][j];
    }
    Initial[i]=Refinement(val);
  }
  for(jiter=1;jiter<=100;jiter++) {
    iter = VAR->A_Iter;
    VAR->A_Temp *= VAR->DTemp;
    amebsa(Result,Initial,DIM,Final,&yb,FTOL,Refinement,&iter,VAR->A_Temp);
    nRefinement += VAR->A_Iter - iter;
    if(yb < ybb) {
      ybb = yb;
      fprintf(VAR->Output,"\nNo of Iterations = %d\nTemperature = %10.3e\n",
	      nRefinement,VAR->A_Temp);
      fprintf(VAR->Output,"Best case so far:\n");
      Refinement(Final);   
      fprintf(VAR->Output,"\n");
    }
    if(iter > 0) break;
  }
  fprintf(VAR->Output,"\nNo of Iterations = %d\nTemperature = %10.3e\n",
	  nRefinement,VAR->A_Temp);
  fprintf(VAR->Output,"Best case so far:\n");
  Refinement(Final);   
  fprintf(VAR->Output,"\n");  
  free_dvector(Final,1,DIM+1);
  free_dvector(Initial,1,NDIM+1);
  free_dmatrix(Result,1,NDIM+1,1,DIM+1);
  Finish();
}

int Dimension( double *value, double *scale )
{
  extern struct Info *VAR;
  extern struct Myosin *MY;
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct BackBone *BB;

  int Level,Head,dim = 0;

  if((VAR->Replex) || (VAR->Torus)) dim--;
     
  if(VAR->Myo) {
    for(Head=1;Head<=MY->N_Hds;Head++) {
      if(MY->Slew[Head].Scl != 0.0) {
	dim++;
	value[dim] = MY->Slew[Head].Val;
	scale[dim] = MY->Slew[Head].Scl;
      }
      if(MY->Tilt[Head].Scl != 0.0) {
	dim++;
	value[dim] = MY->Tilt[Head].Val;
	scale[dim] = MY->Tilt[Head].Scl;
      }
      if(MY->Rot[Head].Scl != 0.0) {
	dim++;
	value[dim] = MY->Rot[Head].Val;
	scale[dim] = MY->Rot[Head].Scl;
      }
      for(Level=1;Level<=MY->N_Crwns;Level++) {
	if(MY->PSlew[Level][Head].Scl != 0.0) {
	  dim++;
	  value[dim] = MY->PSlew[Level][Head].Val;
	  scale[dim] = MY->PSlew[Level][Head].Scl;
	}
	if(MY->PTilt[Level][Head].Scl != 0.0) {
	  dim++;
	  value[dim] = MY->PTilt[Level][Head].Val;
	  scale[dim] = MY->PTilt[Level][Head].Scl;
	}
	if(MY->PRot[Level][Head].Scl != 0.0) {
	  dim++;
	  value[dim] = MY->PRot[Level][Head].Val;
	  scale[dim] = MY->PRot[Level][Head].Scl;
	}
      }
    }
    for(Level=1;Level<=MY->N_Crwns;Level++) {
      if(MY->PRad[Level].Scl != 0.0) {
	dim++;
	value[dim] = MY->PRad[Level].Val;
	scale[dim] = MY->PRad[Level].Scl;
      }
      if(MY->PAxial[Level].Scl != 0.0) {
	dim++;
	value[dim] = MY->PAxial[Level].Val;
	scale[dim] = MY->PAxial[Level].Scl;
      }
      if(MY->PAzi[Level].Scl != 0.0) {
	dim++;
	value[dim] = MY->PAzi[Level].Val;
	scale[dim] = MY->PAzi[Level].Scl;
      }
    }
    if(MY->Hd_Sp.Scl != 0.0) {
      dim++;
      value[dim] = MY->Hd_Sp.Val;
      scale[dim] = MY->Hd_Sp.Scl;
    }
    if(MY->Hd_An.Scl != 0.0) {
      dim++;
      value[dim] = MY->Hd_An.Val;
      scale[dim] = MY->Hd_An.Scl;
    }
    if(MY->Rad.Scl != 0.0) {
      dim++;
      value[dim] = MY->Rad.Val;
      scale[dim] = MY->Rad.Scl;
    }
    if(MY->Lat.Scl != 0.0) {
      dim++;
      value[dim] = MY->Lat.Val;
      scale[dim] = MY->Lat.Scl;
    }
    if(MY->Piv_Tilt1.Scl != 0.0) {
      dim++;
      value[dim] = MY->Piv_Tilt1.Val;
      scale[dim] = MY->Piv_Tilt1.Scl;
    }
    if(MY->Piv_Slew1.Scl != 0.0) {
      dim++;
      value[dim] = MY->Piv_Slew1.Val;
      scale[dim] = MY->Piv_Slew1.Scl;
    }
    if(MY->Piv_Rot1.Scl != 0.0) {
      dim++;
      value[dim] = MY->Piv_Rot1.Val;
      scale[dim] = MY->Piv_Rot1.Scl;
    }
    if(MY->Piv_Tilt2.Scl != 0.0) {
      dim++;
      value[dim] = MY->Piv_Tilt2.Val;
      scale[dim] = MY->Piv_Tilt2.Scl;
    }
    if(MY->Piv_Slew2.Scl != 0.0) {
      dim++;
      value[dim] = MY->Piv_Slew2.Val;
      scale[dim] = MY->Piv_Slew2.Scl;
    }
    if(MY->Piv_Rot2.Scl != 0.0) {
      dim++;
      value[dim] = MY->Piv_Rot2.Val;
      scale[dim] = MY->Piv_Rot2.Scl;
    }
  }

  if(VAR->CPro) {
    if(CP->Tilt.Scl != 0.0) {
      dim++;
      value[dim] = CP->Tilt.Val;
      scale[dim] = CP->Tilt.Scl;
    }
    if(CP->Pivot_Tilt.Scl != 0.0) {
      dim++;
      value[dim] = CP->Pivot_Tilt.Val;
      scale[dim] = CP->Pivot_Tilt.Scl;
    }
    if(CP->Pivot_Type == 2) {
      if(CP->Pivot_Slew.Scl != 0.0) {
	dim++;
	value[dim] = CP->Pivot_Slew.Val;
	scale[dim] = CP->Pivot_Slew.Scl;
      }
    }
    if(CP->Azi.Scl != 0.0) {
      dim++;
      value[dim] = CP->Azi.Val;
      scale[dim] = CP->Azi.Scl;
    }
    if(CP->Rad.Scl != 0.0) {
      dim++;
      value[dim] = CP->Rad.Val;
      scale[dim] = CP->Rad.Scl;
    }
    if(CP->Axial.Scl != 0.0) {
      dim++;
      value[dim] = CP->Axial.Val;
      scale[dim] = CP->Axial.Scl;
    }
    if(CP->Weight.Scl != 0.0) {
      dim++;
      value[dim] = CP->Weight.Val;
      scale[dim] = CP->Weight.Scl;
    }
  }

  if(VAR->Titin) {
    if(TT->Azi.Scl != 0.0) {
      dim++;
      value[dim] = TT->Azi.Val;
      scale[dim] = TT->Azi.Scl;
    }
    if(TT->Rad.Scl != 0.0) {
      dim++;
      value[dim] = TT->Rad.Val;
      scale[dim] = TT->Rad.Scl;
    }
    if(TT->Weight.Scl != 0.0) {
      dim++;
      value[dim] = TT->Weight.Val;
      scale[dim] = TT->Weight.Scl;
    }
  }

  if(VAR->BBone) {
    if(BB->Azi.Scl != 0.0) {
      dim++;
      value[dim] = BB->Azi.Val;
      scale[dim] = BB->Azi.Scl;
    }
  }
  return dim;
}


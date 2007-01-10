/*                                      
   Program    :    Movie 
   FileName   :    Simularity.c
   Author     :    Written By L.Hudson.
 */        

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

#define MAXIT 100
#define EPS 3.0e-15
#define FPMIN 1.0e-30
#define TINY 1.0e-20

void WLeast_SQR() /* Calculate a weighted least squares R-factor */
{
  extern struct Intensity *ID;

  int l,Rad;
  double TOIS,Scl,MScl;
  double TCIS,TOCF,Diff;
  double TOMS,TCMS,TOCMF;

  TOIS = TOMS = 0.0;
  TCIS = TCMS = 0.0;
  TOCF = TOCMF = 0.0;
  ID->MMRD = ID->MRD = 0;
  for(l = 0;l<=ID->l_max;l++) {
    for(Rad = 0;Rad<=ID->R_max;Rad++) { 
      if(ID->SD[Rad][l] == 0.0) continue;
      if(Rad == 0) {
	TOMS  += SQR(ID->OI[Rad][l]) / SQR(ID->SD[Rad][l]);
	TCMS  += SQR(ID->CI[Rad][l]) / SQR(ID->SD[Rad][l]);
	TOCMF += (ID->CI[Rad][l] * ID->OI[Rad][l]) / SQR(ID->SD[Rad][l]);
	continue; 
      }
      TOIS += SQR(ID->OI[Rad][l])/SQR(ID->SD[Rad][l]);
      TCIS += SQR(ID->CI[Rad][l])/SQR(ID->SD[Rad][l]);
      TOCF += (ID->CI[Rad][l] * ID->OI[Rad][l])/SQR(ID->SD[Rad][l]);
    }
  }
  if(TCIS == 0.0) Scl = 0.0;
  else Scl = TOCF/TCIS;
  if(TCMS == 0.0) MScl = 0.0;
  else MScl = TOCMF/TCMS;
  ID->R_Fac = ID->MR_Fac = 0.0;
  for(l = 0;l<=ID->l_max;l++) {   
    for(Rad = 0;Rad<=ID->R_max;Rad++) {
      if(ID->SD[Rad][l] == 0.0) continue;
      if(Rad == 0) {
	ID->MR_Fac += SQR(ID->OI[Rad][l]-MScl*ID->CI[Rad][l])/SQR(ID->SD[Rad][l]);
	Diff = (MScl * ID->CI[Rad][l]-ID->OI[Rad][l])/ID->SD[Rad][l];
	if(fabs(Diff) > (double)ID->MSD) ID->MMRD++;
	continue;
      } 
      ID->R_Fac += SQR((ID->OI[Rad][l] - Scl * ID->CI[Rad][l])) /SQR(ID->SD[Rad][l]);
      Diff = (Scl * ID->CI[Rad][l] - ID->OI[Rad][l])/ID->SD[Rad][l];
      if(fabs(Diff) > ID->MSD) ID->MRD++;
    }
  }
  if(TOIS != 0.0) ID->R_Fac /= TOIS;
  if(TOMS != 0.0) ID->MR_Fac /= TOMS;
}

void WCrystal() /* Calculate weighted crystallographic R-Factor */
{
  extern struct Intensity *ID;

  int l,Rad;
  double TOAS,Scl,MScl;
  double TCAS,TOCF,Diff;
  double TOMS,TCMS,TOCMF;

  TOAS = TOMS = 0.0;
  TCAS = TCMS = 0.0;
  TOCF = TOCMF = 0.0;
  ID->MMRD = ID->MRD = 0;
  for(l = 0;l<=ID->l_max;l++) {
    for(Rad = 0;Rad<=ID->R_max;Rad++) { 
      if(ID->SD[Rad][l] == 0.0) continue;
      if(Rad == 0) {
	TOMS  += sqrt(ID->OI[Rad][l])/ID->CSD[Rad][l];
	TCMS  += sqrt(ID->CI[Rad][l])/ID->CSD[Rad][l];
	TOCMF += sqrt(ID->CI[Rad][l])*sqrt(ID->OI[Rad][l])/ID->CSD[Rad][l];
	continue; 
      }
      TOAS += sqrt(ID->OI[Rad][l])/ID->CSD[Rad][l];
      TCAS += sqrt(ID->CI[Rad][l])/ID->CSD[Rad][l];
      TOCF += sqrt(ID->CI[Rad][l])*sqrt(ID->OI[Rad][l])/ID->CSD[Rad][l];
    }
  }
  if(TCAS == 0.0) Scl = 0.0;
  else Scl = TOCF/TCAS;
  if(TCMS == 0.0) MScl = 0.0;
  else MScl = TOCMF/TCMS;
  ID->R_Fac = ID->MR_Fac = 0.0;
  for(l = 0;l<=ID->l_max;l++) {   
    for(Rad = 0;Rad<=ID->R_max;Rad++) {
      if(ID->SD[Rad][l] == 0.0) continue;
      if(Rad == 0) {
	ID->MR_Fac += fabs(sqrt(ID->OI[Rad][l])-MScl*sqrt(ID->CI[Rad][l]))/ID->CSD[Rad][l];
	Diff = (MScl * sqrt(ID->CI[Rad][l])-sqrt(ID->OI[Rad][l]))/ID->CSD[Rad][l];
	if(fabs(Diff) > (double)ID->MSD) ID->MMRD++;
	continue;
      } 
      ID->R_Fac += fabs(sqrt(ID->OI[Rad][l])-Scl*sqrt(ID->CI[Rad][l]))/ID->CSD[Rad][l];
      Diff = (Scl * sqrt(ID->CI[Rad][l])-sqrt(ID->OI[Rad][l]))/ID->CSD[Rad][l];
      if(fabs(Diff) > ID->MSD) ID->MRD++;
    }
  }
  if(TOAS != 0.0) ID->R_Fac /= TOAS;
  if(TOMS != 0.0) ID->MR_Fac /= TOMS;
}

void Least_SQR() /* Calculate least squares R-Factor */
{
  extern struct Intensity *ID;

  int l,Rad;
  double TOIS,Scl,MScl;
  double TCI,Diff;
  double TOMS,TCM,TOI,TOM;

  TOIS = TOMS = 0.0;
  TCI = TCM = 0.0;
  TOI = TOM = 0.0;
  ID->MMRD = ID->MRD = 0;
  for(l = 0;l<=ID->l_max;l++) {
    for(Rad = 0;Rad<=ID->R_max;Rad++) { 
      if(ID->SD[Rad][l] == 0.0) continue;
      if(Rad == 0) {
	TOMS  += SQR(ID->OI[Rad][l]);
	TCM   += ID->CI[Rad][l];
	TOM   += ID->OI[Rad][l];
	continue; 
      }
      TOIS += SQR(ID->OI[Rad][l]);
      TCI += ID->CI[Rad][l];
      TOI += ID->OI[Rad][l];
    }
  }
  if(TCI == 0.0) Scl = 0.0;
  else Scl = TOI/TCI;
  if(TCM == 0.0) MScl = 0.0;
  else MScl = TOM/TCM;
  ID->R_Fac = ID->MR_Fac = 0.0;
  for(l = 0;l<=ID->l_max;l++) {   
    for(Rad = 0;Rad<=ID->R_max;Rad++) {
      if(ID->SD[Rad][l] == 0.0) continue;
      if(Rad == 0) {
	ID->MR_Fac += SQR(ID->OI[Rad][l]-MScl*ID->CI[Rad][l]);
	Diff = (MScl * ID->CI[Rad][l]-ID->OI[Rad][l])/ID->SD[Rad][l];
	if(fabs(Diff) > (double)ID->MSD) ID->MMRD++;
	continue;
      } 
      ID->R_Fac += SQR((ID->OI[Rad][l]-Scl*ID->CI[Rad][l]));
      Diff = (Scl * ID->CI[Rad][l]-ID->OI[Rad][l])/ID->SD[Rad][l];
      if(fabs(Diff) > ID->MSD) ID->MRD++;
    }
  }
  if(TOIS != 0.0) ID->R_Fac /= TOIS;
  if(TOMS != 0.0) ID->MR_Fac /= TOMS;
}

void Crystal() /* Calculate crystallographic R-Factor */
{
  extern struct Intensity *ID;

  int l,Rad;
  double TOAS,Scl,MScl;
  double TCA,Diff;
  double TOMS,TCM,TOM,TOA;

  TOAS = TOMS = 0.0;
  TCA = TCM = 0.0;
  TOA = TOM = 0.0;
  ID->MMRD = ID->MRD = 0;
  for(l = 0;l<=ID->l_max;l++) {
    for(Rad = 0;Rad<=ID->R_max;Rad++) { 
      if(ID->SD[Rad][l] == 0.0) continue;
      if(Rad == 0) {
	TCM   += sqrt(ID->CI[Rad][l]);
	TOM   += sqrt(ID->OI[Rad][l]);
	continue; 
      }
      TCA  += sqrt(ID->CI[Rad][l]);
      TOA  += sqrt(ID->OI[Rad][l]);
    }
  }
  if(TCA == 0.0) Scl = 0.0;
  else Scl = TOA/TCA;
  if(TCM == 0.0) MScl = 0.0;
  else MScl = TOM/TCM;
  ID->R_Fac = ID->MR_Fac = 0.0;
  for(l = 0;l<=ID->l_max;l++) {   
    for(Rad = 0;Rad<=ID->R_max;Rad++) {
      if(ID->SD[Rad][l] == 0.0) continue;
      if(Rad == 0) {
	ID->MR_Fac += fabs(sqrt(ID->OI[Rad][l])-MScl*sqrt(ID->CI[Rad][l]));
	Diff = (MScl * sqrt(ID->CI[Rad][l])-sqrt(ID->OI[Rad][l]))/ID->CSD[Rad][l];
	if(fabs(Diff) > (double)ID->MSD) ID->MMRD++;
	continue;
      } 
      ID->R_Fac += fabs(sqrt(ID->OI[Rad][l])-Scl*sqrt(ID->CI[Rad][l]));
      Diff = (Scl * sqrt(ID->CI[Rad][l])-sqrt(ID->OI[Rad][l]))/ID->CSD[Rad][l];
      if(fabs(Diff) > ID->MSD) ID->MRD++;
    }
  }
  if(TOA != 0.0) ID->R_Fac /= TOA;
  if(TOM != 0.0) ID->MR_Fac /= TOM;
}

void Correlation() /* Calculate weighted or unweighted correlation function ? */
{
  extern struct Intensity *ID;
  extern struct Info  *VAR;

  double Factor,MFactor;
  int Rad,i,j,l;

  i = j = 1;
  for(l = 0;l<=ID->l_max;l++) {
    for(Rad = 0;Rad<=ID->R_max;Rad++) { 
      if(ID->SD[Rad][l] == 0.0) continue;
      if(Rad == 0) {
	ID->MCCOR[j++] = ID->CI[Rad][l];
	continue;
      }
      ID->CCOR[i++] = ID->CI[Rad][l];
    }
  }
  if(VAR->Weighting) {
    if(i > 1) wcorrel(ID->OCOR,ID->CCOR,ID->CORSD,i-1,&Factor);
    if(j > 1) wcorrel(ID->MOCOR,ID->MCCOR,ID->MCORSD,j-1,&MFactor);
  } 
  else {
    if(i > 1) correl(ID->OCOR,ID->CCOR,i-1,&Factor);
    if(j > 1) correl(ID->MOCOR,ID->MCCOR,j-1,&MFactor);
  }
  ID->C_Fac = Factor;
  ID->MC_Fac = MFactor;
} 

void correl(double x[], double y[], unsigned long n, double *r) /* Calculate correlation function */
{
  unsigned long j;
  double yt,xt;
  double syy=0.0,sxy=0.0,sxx=0.0,ay=0.0,ax=0.0;
     
  for (j=1;j<=n;j++) {
    ax += x[j];
    ay += y[j];
  }
  ax /= n;
  ay /= n;
  for (j=1;j<=n;j++) {
    xt=x[j]-ax;
    yt=y[j]-ay;
    sxx += xt*xt;
    syy += yt*yt;
    sxy += xt*yt;
  }
  if((sxx == 0.0) || (syy == 0.0)) *r = 0.0;
  else *r=sxy/sqrt(sxx*syy);
}

void wcorrel(double x[], double y[], double sd[], unsigned long n, double *r) /* Calculate weighted correlation function */
{
  unsigned long j;
  double yt,xt;
  double syy=0.0,sxy=0.0,sxx=0.0,ay=0.0,ax=0.0;

  for (j=1;j<=n;j++) {
    ax += x[j];
    ay += y[j];
  }
  ax /= n;
  ay /= n;
  for (j=1;j<=n;j++) {
    xt=x[j]-ax;
    yt=y[j]-ay;
    sxx += xt*xt/SQR(sd[j]);
    syy += yt*yt;
    sxy += xt*yt/sd[j];
  }
  *r=sxy/sqrt(sxx*syy);
}

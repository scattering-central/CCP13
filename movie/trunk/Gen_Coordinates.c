#define NRANSI
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

void Trans_Myosin_Coords()
{
  extern struct Info *VAR;
  extern struct Myosin *MY;
  extern struct Constant Cnst;

  double z,z1,z2,x1,x2,y1,y2,azi,azi_t,rd;
  double TRot,TTilt,TSlew,No_Perts_Var1;
  double cosRot,sinRot,cosTilt,sinTilt,cosSlew,sinSlew;
  int reps,Sph,Head,Level,Hd_St,Points;

  Points = 0;
  if(VAR->NoPerts) {
    No_Perts_Var1 = MY->N_Crwns;
    MY->N_Crwns = 1;
  } 
  for(Sph=0;Sph<=MY->N_Pts;Sph++) {
    for(Head=1;Head<=MY->N_Hds;Head++) {
      for(Level=1;Level<=MY->N_Crwns;Level++) {
	x1 = MY->X_C[Sph];
	y1 = MY->Y_C[Sph];
	z1 = MY->Z_C[Sph];
	if(MY->Piv_Point > 0) {
	  if(Sph > MY->Piv_Point) {
	    if(Head == 1) {
	    cosRot = cos(MY->Piv_Rot1.Val);
	    sinRot = sin(MY->Piv_Rot1.Val);
	    cosSlew = cos(MY->Piv_Slew1.Val);
	    sinSlew = sin(MY->Piv_Slew1.Val);
	    cosTilt = cos(MY->Piv_Tilt1.Val);
	    sinTilt = sin(MY->Piv_Tilt1.Val);
	    x1 = MY->X_C[Sph] - MY->X_C[MY->Piv_Point];
	    y1 = MY->Y_C[Sph] - MY->Y_C[MY->Piv_Point];
	    z1 = MY->Z_C[Sph] - MY->Z_C[MY->Piv_Point];
	
	 x2 = x1*(cosTilt*cosSlew) +
	  y1*(sinSlew*cosRot + sinTilt*cosSlew*sinRot) +
	  z1*(sinSlew*sinRot - sinTilt*cosSlew*cosRot);

	 y2 = x1*(-cosTilt*sinSlew) +
	  y1*(cosSlew*cosRot - sinTilt*sinSlew*sinRot) +
	  z1*(cosSlew*sinRot + sinTilt*sinSlew*cosRot);
	    	    
	 z2 = x1*sinTilt +
	  y1*(-cosTilt*sinRot) +
	  z1*cosTilt*cosRot;

	    x1 = x2 +  MY->X_C[MY->Piv_Point];
	    y1 = y2 +  MY->Y_C[MY->Piv_Point];
	    z1 = z2 +  MY->Z_C[MY->Piv_Point];
            }
	     if(Head == 2) {
	    cosRot = cos(MY->Piv_Rot2.Val);
	    sinRot = sin(MY->Piv_Rot2.Val);
	    cosSlew = cos(MY->Piv_Slew2.Val);
	    sinSlew = sin(MY->Piv_Slew2.Val);
	    cosTilt = cos(MY->Piv_Tilt2.Val);
	    sinTilt = sin(MY->Piv_Tilt2.Val);
	    x1 = MY->X_C[Sph] - MY->X_C[MY->Piv_Point];
	    y1 = MY->Y_C[Sph] - MY->Y_C[MY->Piv_Point];
	    z1 = MY->Z_C[Sph] - MY->Z_C[MY->Piv_Point];
	
	 x2 = x1*(cosTilt*cosSlew) +
	  y1*(sinSlew*cosRot + sinTilt*cosSlew*sinRot) +
	  z1*(sinSlew*sinRot - sinTilt*cosSlew*cosRot);

	 y2 = x1*(-cosTilt*sinSlew) +
	  y1*(cosSlew*cosRot - sinTilt*sinSlew*sinRot) +
	  z1*(cosSlew*sinRot + sinTilt*sinSlew*cosRot);
	    	    
	 z2 = x1*sinTilt +
	  y1*(-cosTilt*sinRot) +
	  z1*cosTilt*cosRot;

	    x1 = x2 +  MY->X_C[MY->Piv_Point];
	    y1 = y2 +  MY->Y_C[MY->Piv_Point];
	    z1 = z2 +  MY->Z_C[MY->Piv_Point];
            }  	      	
	  }
	}
	TSlew = MY->Slew[Head].Val + MY->PSlew[Level][Head].Val;
	TTilt = MY->Tilt[Head].Val + MY->PTilt[Level][Head].Val;
	TRot  = MY->Rot[Head].Val  + MY->PRot[Level][Head].Val;
	cosRot = cos(TRot);
	sinRot = sin(TRot);
	cosSlew = cos(TSlew);
	sinSlew = sin(TSlew);
	cosTilt = cos(TTilt);
	sinTilt = sin(TTilt);
	x2 = x1*(cosTilt*cosSlew) +
	  y1*(sinSlew*cosRot + sinTilt*cosSlew*sinRot) +
	  z1*(sinSlew*sinRot - sinTilt*cosSlew*cosRot);
	y2 = x1*(-cosTilt*sinSlew) +
	  y1*(cosSlew*cosRot - sinTilt*sinSlew*sinRot) +
	  z1*(cosSlew*sinRot + sinTilt*sinSlew*cosRot);
	z2 = x1*sinTilt +
	  y1*(-cosTilt*sinRot) +
	  z1*cosTilt*cosRot;
	if(Head == 1) {
	  x1 = x2;    
	  y1 = y2 + (MY->Hd_Sp.Val/2.0)*cos(MY->Hd_An.Val);
	  z1 = z2 + (MY->Hd_Sp.Val/2.0)*sin(MY->Hd_An.Val);
	}
	if(Head == 2) {
	  x1 = x2;
	  y1 = y2 - (MY->Hd_Sp.Val/2.0)*cos(MY->Hd_An.Val);
	  z1 = z2 - (MY->Hd_Sp.Val/2.0)*sin(MY->Hd_An.Val);
	}
	rd    = sqrt(y1*y1+SQR(MY->Rad.Val + MY->PRad[Level].Val + x1));
	azi_t = atan2(y1,MY->Rad.Val + MY->PRad[Level].Val + x1); 
	if(VAR->NoPerts) {
	  Points++;
	  MY->Radial[Points] = rd;
	  MY->Azi[Points]    = azi_t + MY->Lat.Val;
	  MY->Z[Points]  = z1;
	  continue;
	}
	for(Hd_St = 1;Hd_St<=VAR->N_Strnds;Hd_St++) {
	  azi = azi_t+MY->Lat.Val+(Level-1)*
	    MY->Crwn_Twst+MY->PAzi[Level].Val+(Hd_St-1)*VAR->Twst;
	  z = z1 + MY->PAxial[Level].Val+
	    (Level-1)*(MY->Repeat/MY->N_Crwns);
	  for(reps = 1;reps<=(int)(VAR->Tot_Rep/MY->Repeat);reps++) {
	    Points++;
	    MY->X[Points]  = rd*cos(azi);
	    MY->Y[Points]  = rd*sin(azi);
	    MY->Z[Points]  = (reps-1)*MY->Repeat+z;
	    MY->RX[Points] = (MY->X[Points] + MY->Y[Points]/Cnst.Root_t)/VAR->U_Cl;
	    MY->RY[Points] = (MY->Y[Points]/Cnst.Root_tq)/VAR->U_Cl;  
	    MY->RZ[Points] = MY->Z[Points]/VAR->Tot_Rep;
	  }
	}
      }
    }
  }
  if(VAR->NoPerts) {
    MY->N_Crwns  = No_Perts_Var1;
  }        
}

void Trans_Actin_Coords()
{
  extern struct Info *VAR;
  extern struct Actin *AA;
  extern struct Constant Cnst;

  int Points,SubU;
  int Dom,reps,U_Fil;
  double rad,azi,z;
  double X_Pos[4],Y_Pos[4];
  double Mono_Angle,Mono_Sep;

  Mono_Angle = (6.0*360.0/AA->Tot_SubU)*Cnst.DTR;
  Mono_Sep = AA->Repeat/AA->Tot_SubU;
  if(AA->N_Fil == 2) {
    Y_Pos[1] = sqrt(1.0/3.0)*VAR->U_Cl;
    X_Pos[1] = 0.0;
    Y_Pos[2] = sqrt(1.0/12.0)*VAR->U_Cl;
    X_Pos[2] = 0.5*VAR->U_Cl;
  }
  else {
    X_Pos[1] = 0.5*VAR->U_Cl;
    Y_Pos[1] = 0.0;
    X_Pos[2] = 0.25*VAR->U_Cl;
    Y_Pos[2] = (Cnst.Root_tq/2.0)*VAR->U_Cl;
    X_Pos[3] = 0.75*VAR->U_Cl;
    Y_Pos[3] = (Cnst.Root_tq/2.0)*VAR->U_Cl;
  }
  Points = 0;
  for(Dom=1;Dom<=AA->Tot_Dom;Dom++) {
    azi = Mono_Angle + AA->Dom_Phi[Dom]+ AA->Azi_Pert;
    z   = -Mono_Sep + AA->Dom_Z[Dom]+ AA->Z_Pert;
    for(SubU=1;SubU<=AA->Tot_SubU;SubU++) {
      azi -= Mono_Angle;
      z   += Mono_Sep;
      rad = AA->Dom_Rad[Dom];
      for(U_Fil=1;U_Fil<=AA->N_Fil;U_Fil++) {
	for(reps = 1;reps<=(int)(VAR->Tot_Rep/AA->Repeat);reps++) {
	  Points++;
	  AA->X[Points] = rad*cos(azi) + X_Pos[U_Fil];
	  AA->Y[Points] = rad*sin(azi) + Y_Pos[U_Fil];
	  AA->Z[Points] = (reps - 1)*AA->Repeat + z;
	  AA->RX[Points] = (AA->X[Points]+AA->Y[Points]/Cnst.Root_t)/VAR->U_Cl;
	  AA->RY[Points] = (AA->Y[Points]/Cnst.Root_tq)/VAR->U_Cl;
	  AA->RZ[Points] = AA->Z[Points]/VAR->Tot_Rep;
	}
      }
    }
  }
}  

void Trans_Tropomyosin_Coords()
{
  extern struct Info *VAR;
  extern struct Tropomyosin *TR;
  extern struct Constant Cnst;
     
  int Points,SubU,reps,U_Fil,strand;
  double azi,z,rad,azi_strand;
  double X_Pos[3],Y_Pos[3];
  double Mono_Angle,Mono_Sep,Mono_Strand;

  Mono_Angle = (180.0/TR->Tot_SubU)*Cnst.DTR;
  Mono_Sep = TR->Repeat/TR->Tot_SubU;
  Mono_Strand = 180.0*Cnst.DTR; /* This is not correct... */
  if(TR->N_Fil == 2) {
    Y_Pos[1] = sqrt(1.0/3.0)*VAR->U_Cl;
    X_Pos[1] = 0.0;
    Y_Pos[2] = sqrt(1.0/12.0)*VAR->U_Cl;
    X_Pos[2] = 0.5*VAR->U_Cl;
  }
  else {
    X_Pos[1] = 0.5*VAR->U_Cl;
    Y_Pos[1] = 0.0;
    X_Pos[2] = 0.25*VAR->U_Cl;
    Y_Pos[2] = (Cnst.Root_tq/2.0)*VAR->U_Cl;
    X_Pos[3] = 0.75*VAR->U_Cl;
    Y_Pos[3] = (Cnst.Root_tq/2.0)*VAR->U_Cl;
  }
  Points = 0;
  azi = -Mono_Angle  + TR->Phi;
  z   = -Mono_Sep    + TR->Z_Pert;
  for(SubU=1;SubU<=TR->Tot_SubU;SubU++) {
    azi += Mono_Angle;
    z   += Mono_Sep;
    rad  = TR->Rad;
    for(strand=0;strand<=1;strand++) {
      azi_strand = azi + strand*Mono_Strand;
      for(U_Fil=1;U_Fil<=TR->N_Fil;U_Fil++) {
	for(reps = 1;reps<=(int)(VAR->Tot_Rep/TR->Repeat);reps++) {
	  Points++;
	  TR->X[Points] = rad*cos(azi_strand) + X_Pos[U_Fil];
	  TR->Y[Points] = rad*sin(azi_strand) + Y_Pos[U_Fil];
	  TR->Z[Points] = (reps - 1)*TR->Repeat + z;
	  TR->RX[Points] = (TR->X[Points]+TR->Y[Points]/Cnst.Root_t)/VAR->U_Cl;
	  TR->RY[Points] = (TR->Y[Points]/Cnst.Root_tq)/VAR->U_Cl;
	  TR->RZ[Points] = TR->Z[Points]/VAR->Tot_Rep;
	}
      }
    }
  }
}  

void Trans_C_Protein_Coords()
{
  extern struct C_Protein *CP;
  extern struct Info *VAR;
  extern struct Constant Cnst;

  double CP_Phi,CP_Axial;
  double Pivot_Axial,Pivot_Phi;
  double z,phi,r;
  int reps,Mol,SubU,Points;

  Points = 0;
  for(Mol=1;Mol<=VAR->N_Strnds;Mol++) {
    Pivot_Phi = Pivot_Axial = 0.0;
    for(SubU=1;SubU<=CP->Tot_SubU;SubU++) { 
      for(reps=1;reps<=(int)(VAR->Tot_Rep/CP->Repeat);reps++) {
	Points++;
	if(CP->Pivot_Type == 1) {
	  if(SubU <= CP->Pivot) {
	    CP_Phi = CP->Azi.Val+(Mol-1)*VAR->Twst+(SubU-1)*
	      atan2(CP->Dom_Sep*cos(CP->Tilt.Val),CP->Rad.Val); 
	    CP_Axial = (SubU-1)*CP->Dom_Sep*sin(CP->Tilt.Val);
	  }
	  else {
	    Pivot_Phi   = (SubU-CP->Pivot)*atan2(CP->Dom_Sep*cos(CP->Pivot_Tilt.Val),CP->Rad.Val); 
	    Pivot_Axial = (SubU-CP->Pivot)*CP->Dom_Sep*sin(CP->Pivot_Tilt.Val);
	  }
	  CP->X[Points] = CP->Rad.Val*cos(CP_Phi + Pivot_Phi);
	  CP->Y[Points] = CP->Rad.Val*sin(CP_Phi + Pivot_Phi);
	  CP->Z[Points] = (reps-1)*CP->Repeat + CP->Axial.Val + Pivot_Axial + CP_Axial;
	}
	if(CP->Pivot_Type == 2) {
	  if(SubU <= CP->Pivot) {
	    CP_Phi   = CP->Azi.Val+(Mol-1)*VAR->Twst+(SubU-1)*
	      atan2(CP->Dom_Sep*cos(CP->Tilt.Val),CP->Rad.Val);
	    CP_Axial = (SubU-1)*CP->Dom_Sep*sin(CP->Tilt.Val);
	    r = 0.0;
	    phi = 0.0;
	    z = 0.0;
	  }
	  else {
	    r = (SubU - CP->Pivot)*CP->Dom_Sep;
	    phi = 0.0;
	    z = 0.0;
	    phi = CP->Pivot_Slew.Val;
	    z = r*sin(CP->Pivot_Tilt.Val);
	  }
	  CP->X[Points] = CP->Rad.Val*cos(CP_Phi)+r*cos(phi+CP_Phi)*cos(CP->Pivot_Tilt.Val);
	  CP->Y[Points] = CP->Rad.Val*sin(CP_Phi)+r*sin(phi+CP_Phi)*cos(CP->Pivot_Tilt.Val);
	  CP->Z[Points] = (reps-1)*CP->Repeat + CP->Axial.Val + CP_Axial + z;
	}
	CP->RX[Points] = (CP->X[Points]+CP->Y[Points]/Cnst.Root_t)/VAR->U_Cl;
	CP->RY[Points] = ( CP->Y[Points]/Cnst.Root_tq)/VAR->U_Cl;
	CP->RZ[Points] = CP->Z[Points]/VAR->Tot_Rep;
      }
    }
  }
}

void Trans_Titin_Coords()
{
  extern struct Titin *TT;
  extern struct Info *VAR;
  extern struct Constant Cnst;

  double TT_Phi;
  int reps,Mol,SubU,Points;

  Points = 0;
  for(Mol=1;Mol<=VAR->N_Strnds;Mol++) {
    for(SubU=1;SubU<=TT->Tot_SubU;SubU++) {
      for(reps=1;reps<=(int)(VAR->Tot_Rep/TT->Repeat);reps++) {
	Points++;
	TT_Phi = TT->Azi.Val+(Mol-1)*VAR->Twst+VAR->Twst*((double)(SubU-1)/(double)TT->Tot_SubU);
	TT->X[Points] = TT->Rad.Val*cos(TT_Phi);
	TT->Y[Points] = TT->Rad.Val*sin(TT_Phi);
	TT->Z[Points] = (reps-1)*TT->Repeat+TT->Repeat*((double)(SubU-1)/(double)TT->Tot_SubU);
	TT->RX[Points] = (TT->X[Points]+TT->Y[Points]/Cnst.Root_t)/VAR->U_Cl;
	TT->RY[Points] = ( TT->Y[Points]/Cnst.Root_tq)/VAR->U_Cl;
	TT->RZ[Points] = TT->Z[Points]/VAR->Tot_Rep;
      }
    }
  }
}

void Trans_BackBone_Coords()
{
  extern struct BackBone *BB;
  extern struct Info *VAR;
  extern struct Constant Cnst;

  int reps,i,Points;

  Points = 0;
  for(reps=1;reps<=(int)(VAR->Tot_Rep/BB->Repeat);reps++) {
    for(i=0;i<=BB->N_Pts;i++) {
      Points++;
      BB->X[Points]  =  BB->X_C[i]*cos(BB->Azi.Val) + BB->Y_C[i]*sin(BB->Azi.Val);
      BB->Y[Points]  = -BB->X_C[i]*sin(BB->Azi.Val) + BB->Y_C[i]*cos(BB->Azi.Val);
      BB->Z[Points]  =  BB->Z_C[i] * (BB->Repeat/429.0) + (reps-1)*BB->Repeat;
      BB->RX[Points] = (BB->X[Points] + BB->Y[Points]/Cnst.Root_t)/VAR->U_Cl;
      BB->RY[Points] = (BB->Y[Points]/Cnst.Root_tq)/VAR->U_Cl;
      BB->RZ[Points] = BB->Z[Points]/VAR->Tot_Rep;
    }
  }
}

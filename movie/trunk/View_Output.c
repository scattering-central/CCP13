#define NRANSI
#define DATA 1
#define FIELD 0
#define DCAD3 2
#define PDBFORM 3
#define PDBFILE 3
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

void View_Output()
{
  extern struct Info *VAR;
  extern struct Myosin *MY;
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct Constant Cnst;
  extern struct BackBone *BB;
  extern struct Tropomyosin *TR;
  extern struct Actin *AA;
   
  int fil,Colour,flag;
  int nSph,Hd,Lvl,Hd_St,Mol,SubU,i,j;    
  int Dom,U_Fil,Points,Mod_Points,Mod_Points2,Step,reps,strand,Start,Finish;
  double MYCol1[3][5],MYCol2[3][5],MYCol3[3][5];
  double AACol1[5],AACol2[5],AACol3[5];
  double Col_1,Col_2,Col_3;
  double x_Fils[8],y_Fils[8];
  FILE *BB_FP[3],*MY_FP[3],*CP_FP[3];
  FILE *TT_FP[3],*TR_FP[3],*AA_FP[3];
  char *MY_File[] = {"Myosin.fld","Myosin.asc","Myosin.bsc","Myosin.pdb"};
  char *CP_File[] = {"C_Protein.fld","CProtein.asc","CProtein.bsc","CProtein.pdb"};
  char *TT_File[] = {"Titin.fld","Titin.asc","Titin.bsc","Titin.pdb"};
  char *TR_File[] = {"Tropomyosin.fld","Tropomyosin.asc","Tropomyosin.bsc","Tropomyosin.pdb"};
  char *AA_File[] = {"Actin.fld","Actin.asc","Actin.bsc","Actin.pdb"};
  char *BB_File[] = {"BackBone.fld","BackBone.asc","BackBone.bsc","BackBone.pdb"};
  char *myo_chain[] = {"A","B","C","D"};
  char *act_chain[] = {"E","F","G","H"};
  char Vari_File[100];   
  time_t The_Time;
  time(&The_Time);
   
  x_Fils[1] = 0.0;
  y_Fils[1] = 0.0;
  x_Fils[2] = 1.0*VAR->U_Cl;
  y_Fils[2] = 0.0;
  x_Fils[3] = cos(60*Cnst.DTR)*VAR->U_Cl;
  y_Fils[3] = sin(60*Cnst.DTR)*VAR->U_Cl;
  x_Fils[4] = (1.0 + cos(60*Cnst.DTR))*VAR->U_Cl;
  y_Fils[4] = sin(60*Cnst.DTR)*VAR->U_Cl;
  x_Fils[5] = 2.0*VAR->U_Cl;
  y_Fils[5] = 0.0;
  x_Fils[6] = cos(60*Cnst.DTR)*VAR->U_Cl;
  y_Fils[6] = -sin(60*Cnst.DTR)*VAR->U_Cl;
  x_Fils[7] = (1.0 + cos(60*Cnst.DTR))*VAR->U_Cl;
  y_Fils[7] = -sin(60*Cnst.DTR)*VAR->U_Cl;
      
  printf("\n  Writing Coordinates....................");
  for(fil=1;fil<=VAR->No_Fils;fil++) {
    printf("\n  Filament %d............................. ",fil);

    if(VAR->Myo) {  /* Myosin Output Coordindates */
      Points = 0;
      Mod_Points = 0;
      Step = MY->N_Hds*MY->N_Crwns*VAR->N_Strnds*(int)(VAR->Tot_Rep/MY->Repeat);
      Mod_Points2 = -Step+1;
      flag = 1; 
      MYCol1[1][1] = MYCol3[1][1] = MYCol3[1][2] = MYCol1[1][3] = 0.0;
      MYCol2[1][1] = MYCol1[1][2] = MYCol2[1][2] = MYCol2[1][3] = 1.0;
      MYCol3[1][3] = MYCol2[2][1] = MYCol1[2][2] = MYCol3[2][3] = 1.0;
      MYCol1[1][4] = MYCol2[1][4] = MYCol3[1][4] = MYCol3[2][1] = 0.5;
      MYCol1[2][4] = MYCol2[2][4] = MYCol3[2][4] = MYCol1[2][1] = 0.9;	
      MYCol2[2][2] = MYCol1[2][3] = MYCol2[2][3] = 0.5;
      MYCol3[2][2] = 0.0;	 
      printf(" Myosin ");
      if(fil == 1) {
	if(VAR->Avs) {
	  for(i=0;i<=1;i++) {
	    if( (MY_FP[i] = fopen(MY_File[i], "w") ) == NULL ) {
	      printf("Could not create file %s, Exiting",MY_File[i]);
	      CleanUp();
	    }
	  }
	}
	if(VAR->DCad) {
	  if( (MY_FP[DCAD3] = fopen(MY_File[DCAD3], "w") ) == NULL ) {
	    printf("Could not create file %s, Exiting",MY_File[DCAD3]);
	    CleanUp();
	  }
	}
	if(VAR->Pdb) {
	  if( (MY_FP[PDBFILE] = fopen(MY_File[PDBFORM], "w") ) == NULL ) {
	    printf("Could not create file %s, Exiting",MY_File[PDBFORM]);
	    CleanUp();
	  }  
	}
      }
      for(nSph=0;nSph<=MY->N_Pts;nSph++) {
	for(Hd=1;Hd<=MY->N_Hds;Hd++) {
	  for(Lvl=1;Lvl<=MY->N_Crwns;Lvl++) {
	    for(Hd_St = 1;Hd_St<=VAR->N_Strnds;Hd_St++) {
	      for(reps = 1;reps<=(int)(VAR->Tot_Rep/MY->Repeat);reps++) {
		j = reps;
		while(j > VAR->N_Strnds) j -= VAR->N_Strnds; 
		Colour = Hd_St - (j-1);
		if(Colour < 1) Colour += VAR->N_Strnds;
		if(Hd > 2) {
		  printf("\nOops I seem to have 3 heads !!\n\n");
		  CleanUp();
		}
		Points++;
		if(VAR->Avs) { /* Output Coordinate File For AVS */
		  fprintf(MY_FP[DATA],"%7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f\n",
			  MY->X[Points] + x_Fils[fil],
			  MY->Y[Points] + y_Fils[fil],
			  MY->Z[Points],MY->Sph_Sz,
			  MYCol1[Hd][Hd_St],
			  MYCol2[Hd][Hd_St],
			  MYCol3[Hd][Hd_St]);
		}
		if(VAR->DCad) { /* Output Macro File For DesignCAD 3D */
		  fprintf(MY_FP[DCAD3],">sphere\n");
		  fprintf(MY_FP[DCAD3],"{\n");
		  fprintf(MY_FP[DCAD3],"<color %d %d %d\n",
			  (int)(255.0*MYCol1[Hd][Hd_St]),
			  (int)(255.0*MYCol2[Hd][Hd_St]),
			  (int)(255.0*MYCol3[Hd][Hd_St]));
		  fprintf(MY_FP[DCAD3],"<pointxyz %f %f %f\n",
			  MY->X[Points] + x_Fils[fil],
			  MY->Y[Points] + y_Fils[fil],
			  MY->Z[Points]);
		  fprintf(MY_FP[DCAD3],"<pointxyz %f %f %f\n",
			  MY->X[Points] + x_Fils[fil] + MY->Sph_Sz,
			  MY->Y[Points] + y_Fils[fil],
			  MY->Z[Points]);
		  fprintf(MY_FP[DCAD3],"<longitude 20\n");
		  fprintf(MY_FP[DCAD3],"<latitude 20\n");
		  fprintf(MY_FP[DCAD3],"}\n");
		}
		if(VAR->Pdb) { /* Output Coordinates In BrookeHaven Format */
		  if(VAR->BrookeHaven) {
		    Mod_Points++;
		    if(Mod_Points > MY->N_Pts+1) Mod_Points = 1;
		    Mod_Points2 += Step;
		    if(Mod_Points2 > Step*(MY->N_Pts+1)) Mod_Points2 = ++flag;
		    fprintf(MY_FP[PDBFORM],"ATOM%7d %3s  %3s %1s%4d    %+8.3f%+8.3f%+8.3f  %s\n",
			    Points,
			    MY->Type[Mod_Points-1],
			    MY->Amino_Acid[Mod_Points-1],
			    MY->Chain[Mod_Points-1],
			    MY->Sequence[Mod_Points-1],
			    MY->X[Mod_Points2] + x_Fils[fil],
			    MY->Y[Mod_Points2] + y_Fils[fil],
			    MY->Z[Mod_Points2],
			    MY->Param[Mod_Points-1]);
		  }
		  else {
		    fprintf(MY_FP[PDBFORM],"ATOM  %5d  CA  VAL %s%4d    %+8.3f%+8.3f%+8.3f  1.00 20.00\n",
			    Points,
			    myo_chain[Hd-1],
			    Points,
			    MY->X[Points] + x_Fils[fil],
			    MY->Y[Points] + y_Fils[fil],
			    MY->Z[Points]);
		  }
		}
	      }
	    }
	  }
	}
      }
      if(VAR->Avs) if(fil == VAR->No_Fils) Field_File(MY_FP[FIELD],MY_File[DATA],Points,"Myosin");
    }

    if(VAR->Tropomyosin) { /* Tropomyosin Output Coordindates */
      Points = 0;
      printf(" Tropomyosin ");
      if(fil == 1) {
	if(VAR->Avs) {
	  for(i=0;i<=1;i++) {
	    if( (TR_FP[i] = fopen(TR_File[i], "w+") ) == NULL ) {
	      printf("Could not create file %s, Exiting",TR_File[i]);
	      CleanUp();
	    }
	  }
	}
	if(VAR->DCad) {
	  if( (TR_FP[DCAD3] = fopen(TR_File[DCAD3], "w") ) == NULL ) {
	    printf("Could not create file %s, Exiting",TR_File[DCAD3]);
	    CleanUp();
	  }
	}
	if(VAR->Pdb) {
	  if( (TR_FP[PDBFORM] = fopen(TR_File[PDBFORM], "w") ) == NULL ) {
	    printf("Could not create file %s, Exiting",TR_File[PDBFORM]);
	    CleanUp();
	  }
	}
      }
      for(reps = 1;reps<=(int)(VAR->Tot_Rep/TR->Repeat);reps++) {  
	for(SubU=1;SubU<=TR->Tot_SubU;SubU++) {
	  for(strand=0;strand<=1;strand++) {
	    for(U_Fil=1;TR->N_Fil<=2;U_Fil++) {
	      Points++;
	      Col_1 = 1.0;
	      Col_2 = 1.0;
	      Col_3 = 0.2;
	      if(VAR->Avs) { /* Output Coordinate File For AVS */
		fprintf(TR_FP[DATA],"%7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f\n",
			TR->X[Points] + x_Fils[fil],
			TR->Y[Points] + y_Fils[fil],
			TR->Z[Points],
			TR->Sph_Sz,
			Col_1,
			Col_2,
			Col_3);
	      }
	      if(VAR->DCad) { /* Output Macro File For DesignCAD 3D */
		fprintf(TR_FP[DCAD3],">sphere\n");
		fprintf(TR_FP[DCAD3],"{\n");
		fprintf(TR_FP[DCAD3],"<color %d %d %d\n",
			(int)(255.0*Col_1),
			(int)(255.0*Col_2),
			(int)(255.0*Col_3));
		fprintf(TR_FP[DCAD3],"<pointxyz %f %f %f\n",
			TR->X[Points] + x_Fils[fil],
			TR->Y[Points] + y_Fils[fil],
			TR->Z[Points]);
		fprintf(TR_FP[DCAD3],"<pointxyz %f %f %f\n",
			TR->X[Points] + x_Fils[fil] + TR->Sph_Sz,
			TR->Y[Points] + y_Fils[fil],
			TR->Z[Points]);
		fprintf(TR_FP[DCAD3],"<longitude 20\n");
		fprintf(TR_FP[DCAD3],"<latitude 20\n");
		fprintf(TR_FP[DCAD3],"}\n");
	      }
	      if(VAR->Pdb) { /* Output Coordinates In BrookeHaven Format */
		fprintf(TR_FP[PDBFORM],"ATOM   %4d  CA  VAL I%4d    %+8.3f%+8.3f%+8.3f  1.00 20.00\n",
			Points,
			Points,
			TR->X[Points] + x_Fils[fil],
			TR->Y[Points] + y_Fils[fil],
			TR->Z[Points]);
	      }
	    }
	  }
	}
      }
      if(VAR->Avs) if(fil == VAR->No_Fils) Field_File(TR_FP[FIELD],TR_File[DATA],Points,"Tropomyosin");
    }
 
    if(VAR->Actin) { /* Actin Output Coordindates */
      Points = 0;
      printf(" Actin ");
      if(fil == 1) {
	for(i=0;i<=1;i++) {
	  if( (AA_FP[i] = fopen(AA_File[i], "w+") ) == NULL ) {
	    printf("Could not create file %s, Exiting",AA_File[i]);
	    CleanUp();
	  }
	}
	if(VAR->DCad) {
	  if( (AA_FP[DCAD3] = fopen(AA_File[DCAD3], "w") ) == NULL ) {
	    printf("Could not create file %s, Exiting",AA_File[DCAD3]);
	    CleanUp();
	  }
	}
	if(VAR->Pdb) {
	  if( (AA_FP[PDBFORM] = fopen(AA_File[PDBFORM], "w") ) == NULL ) {
	    printf("Could not create file %s, Exiting",AA_File[PDBFORM]);
	    CleanUp();
	  }
	}
      }	 
      AACol2[1] = AACol3[1] = 0.0;
      AACol2[2] = AACol3[2] = 0.0;
      AACol2[3] = AACol3[3] = 0.0;
      AACol1[3] = AACol1[4] = 1.0;
      AACol2[4] = AACol3[4] = 0.2;
      AACol1[2] = 0.75;
      AACol1[1] = 0.5;
      for(Dom=1;Dom<=AA->Tot_Dom;Dom++) {
	for(SubU=1;SubU<=AA->Tot_SubU;SubU++) {
	  for(U_Fil=1;U_Fil<=AA->N_Fil;U_Fil++) {
	    for(reps = 1;reps<=(int)(VAR->Tot_Rep/AA->Repeat);reps++) {
	      Points++;
	      if(VAR->Avs) { /* Output Coordinate File For AVS */
		fprintf(AA_FP[DATA],"%7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f\n",
			AA->X[Points] + x_Fils[fil],
			AA->Y[Points] + y_Fils[fil],
			AA->Z[Points],
			AA->Sph_Sz[Dom],
			AACol1[Dom],
			AACol2[Dom],
			AACol3[Dom]);
	      }
	      if(VAR->DCad) { /* Output Macro File For DesignCAD 3D */
		fprintf(AA_FP[DCAD3],">sphere\n");
		fprintf(AA_FP[DCAD3],"{\n");
		fprintf(AA_FP[DCAD3],"<color %d %d %d\n",
			(int)(255.0*AACol1[Dom]),
			(int)(255.0*AACol2[Dom]),
			(int)(255.0*AACol3[Dom]));
		fprintf(AA_FP[DCAD3],"<pointxyz %f %f %f\n",
			AA->X[Points] + x_Fils[fil],
			AA->Y[Points] + y_Fils[fil],
			AA->Z[Points]);
		fprintf(AA_FP[DCAD3],"<pointxyz %f %f %f\n",
			AA->X[Points] + x_Fils[fil] + AA->Sph_Sz[Dom],
			AA->Y[Points] + y_Fils[fil],
			AA->Z[Points]);
		fprintf(AA_FP[DCAD3],"<longitude 20\n");
		fprintf(AA_FP[DCAD3],"<latitude 20\n");
		fprintf(AA_FP[DCAD3],"}\n");
	      }
	      if(VAR->Pdb) { /* Output Coordinates In BrookeHaven Format */
		fprintf(AA_FP[PDBFORM],"ATOM   %4d  CA  VAL %s%4d    %+8.3f%+8.3f%+8.3f  1.00 20.00\n",
			Points,
			act_chain[Dom-1],
			Points,
			AA->X[Points] + x_Fils[fil],
			AA->Y[Points] + y_Fils[fil],
			AA->Z[Points]);
	      }
	    }
	  }
	}
      }
      if(VAR->Avs)
	if(fil == VAR->No_Fils) Field_File(AA_FP[FIELD],AA_File[DATA],Points,"Actin");
    }
      
    if(VAR->CPro) { /* C-Protein Output Coordindates */
      Points = 0;
      printf(" C-Protein ");
      if(fil == 1) {
	for(i=0;i<=1;i++) {
	  if( (CP_FP[i] = fopen(CP_File[i], "w+") ) == NULL ) {
	    printf("Could not create file %s, Exiting",CP_File[i]);
	    CleanUp();
	  }
	}
	if(VAR->DCad) {
	  if( (CP_FP[DCAD3] = fopen(CP_File[DCAD3], "w") ) == NULL ) {
	    printf("Could not create file %s, Exiting",CP_File[DCAD3]);
	    CleanUp();
	  }
	}
	if(VAR->Pdb) {
	  if( (CP_FP[PDBFORM] = fopen(CP_File[PDBFORM], "w") ) == NULL ) {
	    printf("Could not create file %s, Exiting",CP_File[PDBFORM]);
	    CleanUp();
	  }
	}
      }
      for(reps = 1;reps<=(int)(VAR->Tot_Rep/CP->Repeat);reps++) {
	for(Mol=1;Mol<=VAR->N_Strnds;Mol++) {
	  for(SubU=1;SubU<=CP->Tot_SubU;SubU++) {
	    if(Mol > 3) {
	      printf("\nOops need colours for 4th strand\n\n");
	      CleanUp();
	    }
	    if(Mol == 1) {
		Col_1=1.0;
		Col_2=1.0;
		Col_3=0.2;
	      }
	    if(Mol == 2) {
		Col_1=1.0;
		Col_2=1.0;
		Col_3=0.2;
	      }
	    if(Mol == 3) {
		Col_1=1.0;
		Col_2=1.0;
		Col_3=0.2;
	    }
	    Points++;
	    if(VAR->Avs) { /* Output Coordinate File For AVS */
	      fprintf(CP_FP[DATA],"%7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f\n",
		      CP->X[Points] + x_Fils[fil],
		      CP->Y[Points] + y_Fils[fil],
		      CP->Z[Points],
		      CP->Sph_Sz,
		      Col_1,
		      Col_2,
		      Col_3);
	    }
	    if(VAR->DCad) { /* Output Macro File For DesignCAD 3D */
	      fprintf(CP_FP[DCAD3],">sphere\n");
	      fprintf(CP_FP[DCAD3],"{\n");
	      fprintf(CP_FP[DCAD3],"<color %d %d %d\n",
		      (int)(255.0*Col_1),
		      (int)(255.0*Col_2),
		      (int)(255.0*Col_3));
	      fprintf(CP_FP[DCAD3],"<pointxyz %f %f %f\n",
		      CP->X[Points] + x_Fils[fil],
		      CP->Y[Points] + y_Fils[fil],
		      CP->Z[Points]);
	      fprintf(CP_FP[DCAD3],"<pointxyz %f %f %f\n",
		      CP->X[Points] + x_Fils[fil] + CP->Sph_Sz,
		      CP->Y[Points] + y_Fils[fil],
		      CP->Z[Points]);
	      fprintf(CP_FP[DCAD3],"<longitude 20\n");
	      fprintf(CP_FP[DCAD3],"<latitude 20\n");
	      fprintf(CP_FP[DCAD3],"}\n");
	    }
	    if(VAR->Pdb) { /* Output Coordinates In BrookeHaven Format */
	      fprintf(CP_FP[PDBFORM],"ATOM   %4d  CA  VAL J%4d    %+8.3f%+8.3f%+8.3f  1.00 20.00\n",
		      Points,Points,
		      CP->X[Points] + x_Fils[fil],
		      CP->Y[Points] + y_Fils[fil],
		      CP->Z[Points]);
	    }
	  }
	}
      }
      if(VAR->Avs) 
	if(fil == VAR->No_Fils) Field_File(CP_FP[FIELD],CP_File[DATA],Points,"C-Protein");
    }
      
    if(VAR->Titin) { /* Titin Output Coordindates */
      Points = 0;
      printf(" Titin ");
      if(fil == 1) {
	for(i=0;i<=1;i++) {
	  if( (TT_FP[i] = fopen(TT_File[i], "w+") ) == NULL ) {
	    printf("Could not create file %s, Exiting",TT_File[i]);
	    CleanUp();
	  }
	}
	if(VAR->DCad) {
	  if( (TT_FP[DCAD3] = fopen(TT_File[DCAD3], "w") ) == NULL ) {
	    printf("Could not create file %s, Exiting",TT_File[DCAD3]);
	    CleanUp();
	  }
	}
	if(VAR->Pdb) {
	  if( (TT_FP[PDBFORM] = fopen(TT_File[PDBFORM], "w") ) == NULL ) {
	    printf("Could not create file %s, Exiting",TT_File[PDBFORM]);
	    CleanUp();
	  }
	}
      }
      for(reps = 1;reps<=(int)(VAR->Tot_Rep/TT->Repeat);reps++) {
	for(Mol=1;Mol<=VAR->N_Strnds;Mol++) {
	  for(SubU=1;SubU<=TT->Tot_SubU;SubU++) {
	    if(Mol > 3) {
	      printf("\nOops need colours for 4th strand\n\n");
	      CleanUp();
	    }     
	    if(Mol == 1) {
	      Col_1=1.0;
	      Col_2=0.5;
	      Col_3=1.0;
	    }
	    if(Mol == 2) {
	      Col_1=1.0;
	      Col_2=0.5;
	      Col_3=1.0;
	    }
	    if(Mol == 3) {
	      Col_1=1.0;
	      Col_2=0.5;
	      Col_3=1.0;
	    }
	    Points++;
	    if(VAR->Avs) { /* Output Coordinate File For AVS */
	      fprintf(TT_FP[DATA],"%7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f\n",
		      TT->X[Points] + x_Fils[fil],
		      TT->Y[Points] + y_Fils[fil],
		      TT->Z[Points],
		      TT->Sph_Sz,
		      Col_1,
		      Col_2,
		      Col_3);
	    }
	    if(VAR->DCad) { /* Output Macro File For DesignCAD 3D */
	      fprintf(TT_FP[DCAD3],">sphere\n");
	      fprintf(TT_FP[DCAD3],"{\n");
	      fprintf(TT_FP[DCAD3],"<color %d %d %d\n",
		      (int)(255.0*Col_1),
		      (int)(255.0*Col_2),
		      (int)(255.0*Col_3));
	      fprintf(TT_FP[DCAD3],"<pointxyz %f %f %f\n",
		      TT->X[Points] + x_Fils[fil],
		      TT->Y[Points] + y_Fils[fil],
		      TT->Z[Points]);
	      fprintf(TT_FP[DCAD3],"<pointxyz %f %f %f\n",
		      TT->X[Points] + x_Fils[fil] + TT->Sph_Sz,
		      TT->Y[Points] + y_Fils[fil],
		      TT->Z[Points]);
	      fprintf(TT_FP[DCAD3],"<longitude 20\n");
	      fprintf(TT_FP[DCAD3],"<latitude 20\n");
	      fprintf(TT_FP[DCAD3],"}\n");
	    }
	    if(VAR->Pdb) { /* Output Coordinates In BrookeHaven Format */
	      fprintf(TT_FP[PDBFORM],"ATOM   %4d  CA  VAL K%4d    %+8.3f%+8.3f%+8.3f  1.00 20.00\n",
		      Points,Points,
		      TT->X[Points] + x_Fils[fil],
		      TT->Y[Points] + y_Fils[fil],
		      TT->Z[Points]);
	    }
	  }		
	}
      }
      if(VAR->Avs)
	if(fil == VAR->No_Fils) Field_File(TT_FP[FIELD],TT_File[DATA],Points,"Titin"); 
    }
      
    if(VAR->BBone) { /* Backbone Output Coordindates */
      Points = 0;
      printf(" BackBone ");
      if(fil == 1) {
	for(i=0;i<=1;i++) {
	  if( (BB_FP[i] = fopen(BB_File[i], "w+") ) == NULL ) {
	    printf("Could not create file %s, Exiting",BB_File[i]);
	    CleanUp();
	  }
	}
	if(VAR->DCad) {
	  if( (BB_FP[DCAD3] = fopen(BB_File[DCAD3], "w") ) == NULL ) {
	    printf("Could not create file %s, Exiting",BB_File[DCAD3]);
	    CleanUp();
	  }
	}
	if(VAR->Pdb) {
	  if( (BB_FP[PDBFORM] = fopen(BB_File[PDBFORM], "w") ) == NULL ) {
	    printf("Could not create file %s, Exiting",BB_File[PDBFORM]);
	    CleanUp();
	  }
	}
      }
      if(BB->Model == 0) {
	Col_1 = 0.9;
	Col_2 = 0.9;
	Col_3 = 0.9;
	for(reps = 1;reps<=(int)(VAR->Tot_Rep/BB->Repeat);reps++) {
	  for(j=0;j<=BB->N_Pts-1;j++) {
	    Points++;
	    if(VAR->Avs) { /* Output Coordinate File For AVS */
	      fprintf(BB_FP[DATA],"%7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f\n",
		      BB->X[Points] + x_Fils[fil],
		      BB->Y[Points] + y_Fils[fil],
		      BB->Z[Points],
		      BB->Sph_Sz,
		      Col_1,
		      Col_2,
		      Col_3);
	    }
	    if(VAR->DCad) { /* Output Macro File For DesignCAD 3D */
	      fprintf(BB_FP[DCAD3],">sphere\n");
	      fprintf(BB_FP[DCAD3],"{\n");
	      fprintf(BB_FP[DCAD3],"<color %d %d %d\n",
		      (int)(255.0*Col_1),
		      (int)(255.0*Col_2),
		      (int)(255.0*Col_3));
	      fprintf(BB_FP[DCAD3],"<pointxyz %f %f %f\n",
		      BB->X[Points] + x_Fils[fil],
		      BB->Y[Points] + y_Fils[fil],
		      BB->Z[Points]);
	      fprintf(BB_FP[DCAD3],"<pointxyz %f %f %f\n",
		      BB->X[Points] + x_Fils[fil] + BB->Sph_Sz,
		      BB->Y[Points] + y_Fils[fil],
		      BB->Z[Points]);
	      fprintf(BB_FP[DCAD3],"<longitude 20\n");
	      fprintf(BB_FP[DCAD3],"<latitude 20\n");
	      fprintf(BB_FP[DCAD3],"}\n");
	    }
	    if(VAR->Pdb) { /* Output Coordinates In BrookeHaven Format */
	      fprintf(BB_FP[PDBFORM],"ATOM   %4d  CA  VAL L%4d    %+8.3f%+8.3f%+8.3f  1.00 20.00\n",
		      Points,Points,
		      BB->X[Points] + x_Fils[fil],
		      BB->Y[Points] + y_Fils[fil],
		      BB->Z[Points]);
	    }
	  } 
	}
      }
      if(VAR->Avs)
	if(fil == VAR->No_Fils) Field_File(BB_FP[FIELD],BB_File[DATA],Points,"BackBone"); 
      if(BB->Model == 1) {
	if(VAR->Avs) { /* Output Coordinate File For AVS */
	  fprintf(BB_FP[DATA],"%7.3f   %7.3f   %7.3f   %7.3f   %7.3f\n",
		  x_Fils[fil],
		  y_Fils[fil],
		  VAR->Tot_Rep/2.0,
		  BB->Rad,
		  VAR->Tot_Rep);
	}
	if(VAR->DCad) { /* Output Macro File For DesignCAD 3D */
	  fprintf(BB_FP[DCAD3],">cylinder\n");
	  fprintf(BB_FP[DCAD3],"{\n");
	  fprintf(BB_FP[DCAD3],"<color 200 200 200\n");
	  fprintf(BB_FP[DCAD3],"<pointxyz %f %f %f\n",
		  x_Fils[fil],
		  y_Fils[fil],
		  0.0);
	  fprintf(BB_FP[DCAD3],"<pointxyz %f %f %f\n",
		  x_Fils[fil] + BB->Rad,
		  y_Fils[fil],
		  0.0);
	  fprintf(BB_FP[DCAD3],"<pointxyz %f %f %f\n",
		  x_Fils[fil] + BB->Rad,
		  y_Fils[fil],
		  BB->Rad + VAR->Tot_Rep);
	  fprintf(BB_FP[DCAD3],"<NFace 50\n");
	  fprintf(BB_FP[DCAD3],"}\n");
	}
      }	
    }
  }
  if(VAR->Avs) {
    Start = FIELD;
    Finish = DATA;
  }
  if(VAR->DCad) {
    Start = Finish = DCAD3;
  }
  if(VAR->Pdb) {
    Start = Finish = PDBFORM;
  }
  for(i=Start;i<=Finish;i++) {
    if(VAR->CPro) fclose(CP_FP[i]);
    if(VAR->Tropomyosin) fclose(TR_FP[i]);
    if(VAR->Actin) fclose(AA_FP[i]);
    if(VAR->Myo) fclose(MY_FP[i]);
    if(VAR->Titin) fclose(TT_FP[i]);
    if(VAR->BBone) fclose(BB_FP[i]);
  }
  printf("\n");
}

void Field_File(FILE *output,char *data,int Points,char *protein) {
   
  extern struct Info *VAR;
   
  time_t The_Time;
  time(&The_Time);
   
  fprintf(output,"# AVS field header file \n");
  fprintf(output,"# Created By L.Hudson with MOVIE at %s",ctime(&The_Time));
  fprintf(output,"# This file is parsed by Avs and provides coordinates for %s\n",protein);
  fprintf(output,"ndim = 1\n");
  fprintf(output,"dim1 = %d\n",Points*VAR->No_Fils);
  fprintf(output,"nspace = 3\nveclen = 4\ndata = float\nfield = irregular\n");
  fprintf(output,"variable 1 file = ./%s filetype = ascii offset = 3 stride = 7\n",data);
  fprintf(output,"variable 2 file = ./%s filetype = ascii offset = 4 stride = 7\n",data);
  fprintf(output,"variable 3 file = ./%s filetype = ascii offset = 5 stride = 7\n",data);
  fprintf(output,"variable 4 file = ./%s filetype = ascii offset = 6 stride = 7\n",data);
  fprintf(output,"coord 1 file = ./%s filetype = ascii offset = 0 stride = 7\n",data);
  fprintf(output,"coord 2 file = ./%s filetype = ascii offset = 1 stride = 7\n",data);
  fprintf(output,"coord 3 file = ./%s filetype = ascii offset = 2 stride = 7\n",data);
}







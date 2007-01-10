#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

#define NUMWRD  200
#define NUMVAL  200

void Parse(FILE *input, FILE*output)
{
  extern struct Info *VAR;
  extern struct Intensity *ID;
  extern struct Myosin *MY;
  extern struct Titin *TT;
  extern struct C_Protein *CP;
  extern struct BackBone *BB;
  extern struct Actin *AA;
  extern struct Tropomyosin *TR;

  int i, j, nrd,nwrd, nval,Item[NUMWRD + NUMVAL],Domain,Head,Level;
  double Start,Size,Steps,Scale;
  int subnext = TRUE,next = TRUE,*Item_Ptr,N_Cntr;
  double vals[NUMVAL];
  char *wrdpp[NUMWRD],*wrdptr,Load_File[100];
  char *subwrdptr;
  FILE *Load,*Template;

  static char *optionpp[] = {
    "GLOBAL",             /* Globally Search Data */
    "SIMPLEX",            /* The DownHill Simplex Refinging Method */
    "POWELL",             /* Powell's Refining Method */
    "LEASTSQ",            /* Least Squares Simularity Measure */
    "CORRELATION",        /* Correlation Function Simularity Measure */
    "SCORING",            /* Scoring Method Of Comparing Data */
    "CRYSTAL",            /* Crystallographic Simularity Mesaure */
    "WEIGHTED",           /* Weighting Of Simularity Measure */
    "MSLEW",              /* Slew Of All Myosin Heads */
    "MTILT",              /* Tilt Of All Myosin Heads */
    "MROTATION",          /* Rotation Of All Myosin Heads */
    "MHEADSEP",           /* Separation of Pairs Of Myosin Heads */
    "MHEADANG",           /* Angle Of Head Separation Of Myosin Heads */
    "LATTICEROT",         /* Rotation Of Thick Filament In Lattice */
    "CELL",               /* Unit Cell Size */
    "MREPEAT",            /* Repeat Of The Myosin Heads */
    "MYOSIN",             /* Include Myosin ? */
    "ACTIN",              /* Include Actin ? */
    "TOTREPEAT",          /* Total Repeat Of Whole Molecule */
    "IFILE",              /* Intensity Data File Name */
    "HEADFILE",           /* S1-Head Data File Name */
    "MRADIUS",            /* Radial Position Of Myosin Heads */
    "MPSLEW",             /* Slew Of Myosin Heads At A Given Level */
    "MPTILT",             /* Tilt Of Myosin Heads At A Given Level */
    "MPROTATION",         /* Rotation Of Myosin Heads At A Given Level */
    "STATUS",             /* Display Information About The Current Parameters */
    "QUIT",               /* Exit the Program */       
    "EXIT",               /* Exit The ProGram */
    "VIEW",               /* Generate Coordinates File For Viewing Model */
    "STRANDS",            /* Number Of Molecular Strands */
    "MCROWN",             /* Number Of Myosin Levels Per Repeat */
    "MRASTER",            /* Scale Of S1-Head Coordinates */
    "MSPHERE",            /* Size Of S1-Head Spheres */
    "RUN",                /* Execute Program With Given Parameters */
    "SCOREDEV",           /* Number Of SD's For Use With Scoring Method */
    "HKLOUTPUT",          /* Output The Fourier Transform As H,K,L Reflections */
    "WARRENTY",           /* Information */
    "LICENSE",            /* Information */
    "COMBINE",            /* Combine Meridional and Off-Meridional Reflections When Comparing */
    "CWEIGHT",            /* Weighting Of Meridional To Off-Meridional Scaling For Above */
    "WRITE",              /* Output Current Parameters In A Reloadable Format */
    "TITIN",              /* Include Titin ? */
    "CPROTEIN",           /* Include C-Protein ? */
    "CPRADIUS",           /* Radial Position Of C-Protein */
    "CPAZIMUTH",          /* Azimuthal Position Of C-Protein */
    "CPTILT",             /* Tilt Of First Segment Of C-Protein */
    "CPWEIGHT",           /* Weighting Of Transform Of C-Protein */
    "CPAXIAL",            /* Axial Position Of C-Protein */
    "TTRADIUS",           /* Radial Position Of Titin */
    "TTAZIMUTH",          /* Azimuthal Position Of Titin */
    "TTWEIGHT",           /* Weighting Of Transform Of Titin */
    "CPDOMRAD",           /* Size Of C-Protein Spheres */
    "CPNODOM",            /* Number Of Domains (Spheres) Making Up C-Protein */
    "TTDOMRAD",           /* Size Of Titin Spheres */
    "TTNODOM",            /* Number Of Domains (Spheres) Making Up Titin */
    "TTREPEAT",           /* Repeat Of Titin */
    "CPREPEAT",           /* Repeat Of C-Protein */
    "ANNEALING",          /* Simulated Annealing Refining Process */
    "TEMPERATURE",        /* Inital Temperature For Simulated Annealing */
    "ITERATIONS",         /* Iterations N For Annealing Schedule */
    "TEMPDROP",           /* Temperature Drop Per N Iterations */
    "NUMREPS",            /* Number Of Whole Repeats To Show When Viewing */
    "BBRADIUS",           /* Radial Position Of Cylindrical BackBone */
    "FILAMENTS",          /* Number Of Filaments To Show When Viewing */
    "FOURIERDIF",         /* Perform A Fourier Differencing */
    "REFLECTIONS",        /* Output Calculated Reflections */
    "CPNUM_PIVOT",        /* Position Of 'Kink' In C-Protein */
    "CPPIVOT_TYPE",       /* Type Of 'Kink' In C-Protein (1 or 2) */
    "CPPIVOT_TILT",       /* Tilt Of Second Segment Of C-Protein */
    "CPPIVOT_SLEW",       /* Slew Of Secong Segments Of C-Protein (Model 2) */
    "BACKBONE",           /* Include BsckBone ? */
    "BBFILE",             /* BackBone Data File (Mikes Model Only) */
    "BBSPHERE",           /* Size Of Spheres Makeing Up BackBone (Mikes Model Only) */
    "BBREPEAT",           /* Repeat Of BackBone */
    "OSCALE",             /* Off-Meridional Scaling */
    "MSCALE",             /* Meridional Scaling */
    "BBAZI",              /* Azimuthal Postion Of BackBone (Mikes Model Only) */
    "CPDOMSEP",           /* Separation Of Domains In C-Protein */
    "MPRADIUS",           /* Radial Position Of Myosin Heads At A Given Level */
    "MPAXIAL",            /* Axial Position Of Myosin Heads At A Given Level */
    "OBSERVED",           /* Output Observed Reflections */
    "REPLEX",             /* DownHill Replex Refining Method */
    "DISPLAY",            /* Visualy Display Current Point In Parameters Space */
    "#",                  /* Comment */
    "LOAD",               /* Load A Parameter File */
    "SHELL",              /* Shell Out To Current XTerm */
    "BBMODEL",            /* BBModel (0 or 1) */
    "SCALEDATA",          /* ScaleData With OSCALE and MSCALE ? */
    "RESET",              /* Reset All Parameters To Zero */
    "FISH",               /* Fish Muscle */
    "INSECT",             /* Insect Flight Muscle */
    "CCP13",              /* Internal command for checking Fourier Differencing */
    "TROPOMYOSIN",        /* Include Tropomyosin ? */
    "TRRAD",              /* Radial Position Of Tropomyosin w.r.t thin filament */
    "TRPHI",              /* Azimuthal Positition of tropomyosin  */
    "TRZPERT",            /* Axial Perturbation Of Tropomyosin Molecule */
    "TRREPEAT",           /* Repeat Of Tropomyosin Molecule */
    "AARAD",              /* Radial Position Of Sub-Domain */
    "AAPHI",              /* Azimuthal Position Of Sub-Domain */
    "AAZ",                /* Axial Position Of Sub-Domain */
    "AAREPEAT",           /* Repeat Of Actin Molecule */
    "AAPERTPHI",          /* Azimuthal Perturbation Of Actin Molecule */
    "AAPERTZ",            /* Axial Perturbation Of Actin Molecule */
    "TRSUBU",             /* Total Number Of Tropomyosin SubUnits */
    "TRSPHSZ",            /* Size Of Sphere's Used To Construct Tropomyosin */
    "AASPHSZ",            /* Size Of Sub Domains For Actin */
    "OUTPUTFILE",         /* Name Of The File To Which Data Will Be Written */
    "ONESHOT",            /* Performs the Parsing just once (i.e. if in bg) */
    "TRWEIGHT",           /* Tropomyosin weighting */
    "AAWEIGHT",           /* Actin weighting */
    "BOGUSDATA",          /* Use make up data to generate reflections ?? */
    "RESBOGUSDATA",       /* At what resolution ?? */
    "MPAZIMUTHAL",        /* Myosin azimuthal perturbation per level */
    "MPIVPOINT",          /* Myosin Pivot Sphere Number */
    "MPIVTILT1",           /* Tilt of Myosin Head 1 Pivot */
    "MPIVSLEW1",           /* Slew of Myosin Head 1 Pivot */
    "MPIVROT1",            /* Rotation of Myosin Head 1 Pivot */
    "AVS",                /* Output View Info In AVS Format */
    "DCAD",               /* Output View Info In Design Cad 3 Format */
    "PDB",                /* Output View Info In PDB Format */
    "TORUS",              /* The Stochastic Torus Algorithm ! */
    "MYHEADS",            /* The number of Myosin Heads ! */
    "BROOKEHAVEN",        /* Load Myosin Head in Brookhaven Format */
    "NOPERTS",            /* No Perturbations In Model - Use Bessel Fns */
    "BESNUM",             /* Number of bessel functions per layer line */
    "REPLEVEL",           /* Number of levels in a full repeat */
    "CUTOFF",             /* Resolution limitation */
    "AAFIL",              /* Number of actin filaments */
    "TRFIL",              /* Number of tropomyosin filaments */
    "MPIVTILT2",           /* Tilt of Myosin Head 2 Pivot */
    "MPIVSLEW2",           /* Slew of Myosin Head 2 Pivot */
    "MPIVROT2",            /* Rotation of Myosin Head 2 Pivot */    
    ""                    /* Blank */
  };

  static char* suboptionpp[] = {
    "HEAD",               /* The Head Number Being Preferred To */
    "START",              /* Starting Position For Model */
    "SIZE",               /* Size of steps Used to vary the model */
    "STEPS",              /* Number of Steps */
    "SCALE",              /* Parameter's characteristic scale length */
    "LEVEL",              /* Myosin level being referred to */
    "DOMAIN",             /* Domain being referred to */
    ""
  };

  Scale = Steps = Start = 0.0; 
  Head = Level = 1;

  while(next) {
    if(input == stdin) {
      fprintf (output,"MOVIE > ");
    }
    Item_Ptr = Item;
    N_Cntr = 0;
    if (!(nrd = rdcomc (input, output,wrdpp, &nwrd, vals, &nval, Item, NUMWRD, NUMVAL)))
      printf ("Error reading input\n");
    else if (nrd < 0) {
      next = 0;
    } 
    if (nwrd > 0) {
      i = 0;
      while(i<nwrd) {
	wrdptr = wrdpp[i];
	upc(wrdptr);
	switch (optcmp (wrdptr, optionpp)) {

	case AMBIGUOUS:
	  printf ("\nAmbiguous command  -  %s\n",wrdptr);
	  break;
			 
	case NOMATCH:
	  printf ("\nNo command matching  - %s\n\n",wrdptr);
	  break;

	case GLOBAL:
	  Reset_Search();
	  VAR->Global = TRUE;
	  break;
			 
	case SIMPLEX:
	  Reset_Search();
	  VAR->Simplex = TRUE;
	  break;

	case TORUS:
	  Reset_Search();
	  VAR->Torus = TRUE;
	  break;

	case REPLEX:
	  Reset_Search();
	  VAR->Replex = TRUE;
	  break;
			 
	case POWELL:
	  Reset_Search();
	  VAR->Powell = TRUE;
	  break;

	case ANNEALING:
	  Reset_Search();
	  VAR->Anneal = TRUE;
	  break;
			 
	case VIEW:
	  Reset_Search();
	  VAR->View = TRUE;
	  break;

	case AVS:
	  Reset_Search();
	  VAR->View = TRUE;
	  VAR->Avs = TRUE;
	  break;

	case DCAD:
	  Reset_Search();
	  VAR->View = TRUE;
	  VAR->DCad = TRUE;
	  break;

	case PDB:
	  Reset_Search();
	  VAR->View = TRUE;
	  VAR->Pdb  = TRUE;
	  break;

	case HKLOUTPUT:
	  Reset_Search();
	  VAR->HKLOutput = TRUE;
	  break;

	case CCP13:
	  Reset_Search();
	  VAR->ccp13 = TRUE;
	  VAR->HKLOutput = TRUE;
	  break;

	case LEASTSQ:
	  Reset_Simul();
	  VAR->Least_Sq = TRUE;
	  break;
			 
	case CORRELATION:
	  Reset_Simul();
	  VAR->Corr = TRUE;
	  break;

	case SCORING:
	  VAR->Scoring = TRUE;
	  break;
			 
	case CRYSTALLOGRAPHIC:
	  Reset_Simul();
	  VAR->Cryst = TRUE;
	  break;
			 
	case WEIGHTED:
	  NOT(VAR->Weighting);
	  break;
	
	case BOGUSDATA:
	  NOT(VAR->BogusData);
	  VAR->BogusData = TRUE;
	  break;

	case SCALEDATA:
	  NOT(VAR->Scale_Data);
	  break;

	case FOURIERDIF:
	  Reset_Search();
	  VAR->Fourier_Diff = TRUE;
	  break;
		 
	case REFLECTIONS:
	  Reset_Search();
	  VAR->Reflections = TRUE;
	  break;

	case OBSERVED:
	  Reset_Search();
	  VAR->Observed = TRUE;
	  break;

	case AARAD:
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);
	  AA->Dom_Rad[Domain] = Start;
	  break;

	case AAPHI:
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);
	  AA->Dom_Phi[Domain] = Start;
	  break;

	case AAZ:
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);
	  AA->Dom_Z[Domain] = Start;
	  break;

	case AASPHSZ:
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);
	  AA->Sph_Sz[Domain] = Start;
	  break;


	case AAREPEAT:
	  Alloc_Actin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  AA->Repeat = vals[N_Cntr++];
	  break;

	case AAFIL:
	  Alloc_Actin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  AA->N_Fil = (int)vals[N_Cntr++];
	  break;

	case TRFIL:
	  Alloc_Tropomyosin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  TR->N_Fil = (int)vals[N_Cntr++];
	  break;


			 
	case RESBOGUSDATA:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  VAR->BogusDataRes = vals[N_Cntr++];
	  break;

	case AAWEIGHT:
	  Alloc_Actin();
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);
	  AA->Weight.St = Start;
	  AA->Weight.Sz = Size;
	  AA->Weight.Stp = Steps;
	  AA->Weight.Scl = Scale;
	  if(AA->Weight.St == 0.0) {
	    printf("Warning. Weight of zero inputted!\n");
	  }
	  break;

	case TRWEIGHT:
	  Alloc_Tropomyosin();
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);
	  TR->Weight.St = Start;
	  TR->Weight.Sz = Size;
	  TR->Weight.Stp = Steps;
	  TR->Weight.Scl = Scale;
	  if(TR->Weight.St == 0.0) {
	    printf("Warning. Weight of zero inputted!\n");
	  }
	  break;

	case AAPERTPHI:
	  Alloc_Actin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  AA->Azi_Pert = vals[N_Cntr++];
	  break;

	case AAPERTZ:
	  Alloc_Actin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  AA->Z_Pert = vals[N_Cntr++];
	  break;

	case TRREPEAT:
	  Alloc_Tropomyosin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  TR->Repeat = vals[N_Cntr++];
	  break;

	case TRRAD:
	  Alloc_Tropomyosin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  TR->Rad = vals[N_Cntr++];
	  break;

	case TRPHI:
	  Alloc_Tropomyosin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  TR->Phi = vals[N_Cntr++];
	  break;

	case TRSPHSZ:
	  Alloc_Tropomyosin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  TR->Sph_Sz = vals[N_Cntr++];
	  break;

	case TRZPERT:
	  Alloc_Tropomyosin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  TR->Z_Pert = vals[N_Cntr++];
	  break;

	case TRSUBU:
	  Alloc_Tropomyosin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  TR->Tot_SubU = (int)vals[N_Cntr++];
	  break;

	  /* Vary slew of myosin heads */

	case MSLEW:
	  Alloc_Myosin();
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  if(Bounds(Head,Level) == FALSE) break;
	  MY->Slew[Head].St = Start;
	  MY->Slew[Head].Sz = Size;
	  MY->Slew[Head].Stp = Steps;
	  MY->Slew[Head].Scl = Scale;
	  break;

	case MPSLEW:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);
	  if(Bounds(Head,Level) == FALSE) break;
	  MY->PSlew[Level][Head].St = Start;
	  MY->PSlew[Level][Head].Sz = Size;
	  MY->PSlew[Level][Head].Stp = Steps;
	  MY->PSlew[Level][Head].Scl = Scale;
	  break;

	case MTILT:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  if(Bounds(Head,Level) == FALSE) break;
	  MY->Tilt[Head].St = Start;
	  MY->Tilt[Head].Sz = Size;
	  MY->Tilt[Head].Stp = Steps;
	  MY->Tilt[Head].Scl = Scale;
	  break;

	case MPRADIUS:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  if(Bounds(Head,Level) == FALSE) break;
	  MY->PRad[Level].St = Start;
	  MY->PRad[Level].Sz = Size;
	  MY->PRad[Level].Stp = Steps;
	  MY->PRad[Level].Scl = Scale;
	  break;


	case MPAXIAL:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  if(Bounds(Head,Level) == FALSE) break;
	  MY->PAxial[Level].St = Start;
	  MY->PAxial[Level].Sz = Size;
	  MY->PAxial[Level].Stp = Steps;
	  MY->PAxial[Level].Scl = Scale;
	  break;

	case MPAZIMUTHAL:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  if(Bounds(Head,Level) == FALSE) break;
	  MY->PAzi[Level].St = Start;
	  MY->PAzi[Level].Sz = Size;
	  MY->PAzi[Level].Stp = Steps;
	  MY->PAzi[Level].Scl = Scale;
	  break;

	case CPTILT:
	  Alloc_C_Protein();
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  CP->Tilt.St = Start;
	  CP->Tilt.Sz = Size;
	  CP->Tilt.Stp = Steps;
	  CP->Tilt.Scl = Scale;
	  break;

	case CPPIVOT_TILT:
	  Alloc_C_Protein();
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  CP->Pivot_Tilt.St = Start;
	  CP->Pivot_Tilt.Sz = Size;
	  CP->Pivot_Tilt.Stp = Steps;
	  CP->Pivot_Tilt.Scl = Scale;
	  break;

	case CPPIVOT_SLEW:
	  Alloc_C_Protein();
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  CP->Pivot_Slew.St = Start;
	  CP->Pivot_Slew.Sz = Size;
	  CP->Pivot_Slew.Stp = Steps;
	  CP->Pivot_Slew.Scl = Scale;
	  break;

	case CPAZIMUTH:
	  Alloc_C_Protein();
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  CP->Azi.St = Start;
	  CP->Azi.Sz = Size;
	  CP->Azi.Stp = Steps;
	  CP->Azi.Scl = Scale;
	  break;

	case TTAZIMUTH:
	  Alloc_Titin();
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  TT->Azi.St = Start;
	  TT->Azi.Sz = Size;
	  TT->Azi.Stp = Steps;
	  TT->Azi.Scl = Scale;
	  break;

	case MPTILT:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  if(Bounds(Head,Level) == FALSE) break;
	  MY->PTilt[Level][Head].St = Start;
	  MY->PTilt[Level][Head].Sz = Size;
	  MY->PTilt[Level][Head].Stp = Steps;
	  MY->PTilt[Level][Head].Scl = Scale;
	  break;

	case MROTATION:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  if(Bounds(Head,Level) == FALSE) break;
	  MY->Rot[Head].St = Start;
	  MY->Rot[Head].Sz = Size;
	  MY->Rot[Head].Stp = Steps;
	  MY->Rot[Head].Scl = Scale;
	  break;

	case MPROTATION:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  if(Bounds(Head,Level) == FALSE) break;
	  MY->PRot[Level][Head].St = Start;
	  MY->PRot[Level][Head].Sz = Size;
	  MY->PRot[Level][Head].Stp = Steps;
	  MY->PRot[Level][Head].Scl = Scale;
	  break;

	case MHEADSEP:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  MY->Hd_Sp.St = Start;
	  MY->Hd_Sp.Sz = Size;
	  MY->Hd_Sp.Stp = Steps;
	  MY->Hd_Sp.Scl = Scale;
	  break;

	case MHEADANG:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  MY->Hd_An.St = Start;
	  MY->Hd_An.Sz = Size;
	  MY->Hd_An.Stp = Steps;
	  MY->Hd_An.Scl = Scale;
	  break;

	case MPIVTILT1:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  MY->Piv_Tilt1.St = Start;
	  MY->Piv_Tilt1.Sz = Size;
	  MY->Piv_Tilt1.Stp = Steps;
	  MY->Piv_Tilt1.Scl = Scale;
	  break;
			 
	case MPIVSLEW1:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  MY->Piv_Slew1.St = Start;
	  MY->Piv_Slew1.Sz = Size;
	  MY->Piv_Slew1.Stp = Steps;
	  MY->Piv_Slew1.Scl = Scale;
	  break;

	case MPIVROT1:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  MY->Piv_Rot1.St = Start;
	  MY->Piv_Rot1.Sz = Size;
	  MY->Piv_Rot1.Stp = Steps;
	  MY->Piv_Rot1.Scl = Scale;
	  break;

	case MPIVTILT2:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  MY->Piv_Tilt2.St = Start;
	  MY->Piv_Tilt2.Sz = Size;
	  MY->Piv_Tilt2.Stp = Steps;
	  MY->Piv_Tilt2.Scl = Scale;
	  break;
			 
	case MPIVSLEW2:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  MY->Piv_Slew2.St = Start;
	  MY->Piv_Slew2.Sz = Size;
	  MY->Piv_Slew2.Stp = Steps;
	  MY->Piv_Slew2.Scl = Scale;
	  break;

	case MPIVROT2:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  MY->Piv_Rot2.St = Start;
	  MY->Piv_Rot2.Sz = Size;
	  MY->Piv_Rot2.Stp = Steps;
	  MY->Piv_Rot2.Scl = Scale;
	  break;
	  
	  
	case LATTICEROT:
	  Alloc_Myosin(); 
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);

	  MY->Lat.St = Start;
	  MY->Lat.Sz = Size;
	  MY->Lat.Stp = Steps;
	  MY->Lat.Scl = Scale;
	  break;
	 
	case CELL:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  VAR->U_Cl = vals[N_Cntr++];
	  break;

	case CPDOMRAD:
	  Alloc_C_Protein();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  CP->Sph_Sz = vals[N_Cntr++];
	  break;

	case CPNUM_PIVOT:
	  Alloc_C_Protein();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  CP->Pivot = (int)vals[N_Cntr++];
	  break;

	case CPPIVOT_TYPE:
	  Alloc_C_Protein();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  if(((int)vals[N_Cntr] > 2) ||
	     ((int)vals[N_Cntr] < 1)) {
	    printf("\007Setting C-Protein model to 1\n");
	    CP->Pivot_Type = 1;
	    break;
	  }
	  CP->Pivot_Type = (int)vals[N_Cntr++];
	  break;


	case TEMPERATURE:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  VAR->A_Temp = (float)vals[N_Cntr++];
	  break;

	case TEMPDROP:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  VAR->DTemp = vals[N_Cntr++];
	  break;

	case BBRADIUS:
	  Alloc_BackBone();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  BB->Rad = vals[N_Cntr++];
	  break;

	case BBMODEL:
	  Alloc_BackBone();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  BB->Model = (int)vals[N_Cntr++];
	  break;

	case FILAMENTS:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  VAR->No_Fils = (int)vals[N_Cntr++];
	  break;

	case BESNUM:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  ID->Bes_Num = (int)vals[N_Cntr++];
	  break;

	case MPIVPOINT:
	  Alloc_Myosin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  MY->Piv_Point = (int)vals[N_Cntr++];
	  break;

	case MYHEADS:
	  if(!VAR->Myo) Alloc_Myosin();
          free_datavector(MY->Slew,0,MY->N_Hds+1);
          free_datavector(MY->Tilt,0,MY->N_Hds+1);
          free_datavector(MY->Rot,0,MY->N_Hds+1);			 
	  free_datavector(MY->PRad,0,MY->N_Crwns+1);
	  free_datavector(MY->PAxial,0,MY->N_Crwns+1);
	  free_datavector(MY->PAzi,0,MY->N_Crwns+1);
	  
	  free_datamatrix(MY->PSlew,0,MY->N_Crwns+1,0,MY->N_Hds+1);
	  free_datamatrix(MY->PTilt,0,MY->N_Crwns+1,0,MY->N_Hds+1);
	  free_datamatrix(MY->PRot,0,MY->N_Crwns+1,0,MY->N_Hds+1);

	  if(Check_Val(Item_Ptr) == FALSE) break;
		  
	  MY->N_Hds = (int)vals[N_Cntr++];

          MY->Slew= datavector(0,MY->N_Hds+1);
          MY->Tilt= datavector(0,MY->N_Hds+1);
          MY->Rot= datavector(0,MY->N_Hds+1);
	  MY->PRad   = datavector(0,MY->N_Crwns+1);
	  MY->PAxial = datavector(0,MY->N_Crwns+1);
	  MY->PAzi = datavector(0,MY->N_Crwns+1);
	  
	  MY->PSlew  = datamatrix(0,MY->N_Crwns+1,0,MY->N_Hds+1);
	  MY->PTilt  = datamatrix(0,MY->N_Crwns+1,0,MY->N_Hds+1);
	  MY->PRot   = datamatrix(0,MY->N_Crwns+1,0,MY->N_Hds+1);
 
	  Zero_Myosin_Mem();
			 
	  break;

	case NUMREPS:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  VAR->Num_Reps = (int)vals[N_Cntr++];
	  break;


	case ITERATIONS:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  VAR->A_Iter = (int)vals[N_Cntr++];
	  break;


	case TTDOMRAD:
	  Alloc_Titin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  TT->Sph_Sz = vals[N_Cntr++];
	  break;
		 
	case CPNODOM:
	  Alloc_C_Protein();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  CP->Tot_SubU = (int)vals[N_Cntr++];
	  break;

	case CPDOMSEP:
	  Alloc_C_Protein();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  CP->Dom_Sep = vals[N_Cntr++];
	  break;


	case TTNODOM:
	  Alloc_Titin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  TT->Tot_SubU = (int)vals[N_Cntr++];
	  break;

	case TTREPEAT:
	  Alloc_Titin();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  TT->Repeat = vals[N_Cntr++];
	  break;

	case BBAZI:
	  Alloc_BackBone();
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);
	  BB->Azi.St = Start;
	  BB->Azi.Sz = Size;
	  BB->Azi.Stp = Steps;
	  BB->Azi.Scl = Scale;
	  break;

	case OSCALE:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  VAR->Scale[0] = vals[N_Cntr++];
	  break;

	case MSCALE:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  VAR->Scale[1] = vals[N_Cntr++];
	  break;

	case CPREPEAT:
	  Alloc_C_Protein();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  CP->Repeat = vals[N_Cntr++];
	  break;

	case MREPEAT:
	  Alloc_Myosin(); 
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  MY->Repeat = vals[N_Cntr++];
	  break;

	case REPLEVEL:
	  Alloc_Myosin(); 
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  MY->Rep_Level = vals[N_Cntr++];
	  break;

	case BBREPEAT:
	  Alloc_BackBone();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  BB->Repeat = vals[N_Cntr++];
	  break;

	case STRANDS:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  VAR->N_Strnds = (int)vals[N_Cntr++];
	  break;
			 
	case CUTOFF:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  VAR->CutOff = (int)vals[N_Cntr++];
	  break;

	case MCROWN:
	  if(!VAR->Myo) Alloc_Myosin();
	
	  free_datavector(MY->Slew,0,MY->N_Hds+1);
          free_datavector(MY->Tilt,0,MY->N_Hds+1);
          free_datavector(MY->Rot,0,MY->N_Hds+1);			 
	  free_datavector(MY->PRad,0,MY->N_Crwns+1);
	  free_datavector(MY->PAxial,0,MY->N_Crwns+1);
	  free_datavector(MY->PAzi,0,MY->N_Crwns+1);

	  free_datamatrix(MY->PSlew,0,MY->N_Crwns+1,0,MY->N_Hds+1);
	  free_datamatrix(MY->PTilt,0,MY->N_Crwns+1,0,MY->N_Hds+1);
	  free_datamatrix(MY->PRot,0,MY->N_Crwns+1,0,MY->N_Hds+1);

	  if(Check_Val(Item_Ptr) == FALSE) break;		  
	  MY->N_Crwns = (int)vals[N_Cntr++];


          MY->Slew= datavector(0,MY->N_Hds+1);
          MY->Tilt= datavector(0,MY->N_Hds+1);
          MY->Rot= datavector(0,MY->N_Hds+1);
	  MY->PRad   = datavector(0,MY->N_Crwns+1);
	  MY->PAxial = datavector(0,MY->N_Crwns+1);
	  MY->PAzi = datavector(0,MY->N_Crwns+1);
	  
	  MY->PSlew  = datamatrix(0,MY->N_Crwns+1,0,MY->N_Hds+1);
	  MY->PTilt  = datamatrix(0,MY->N_Crwns+1,0,MY->N_Hds+1);
	  MY->PRot   = datamatrix(0,MY->N_Crwns+1,0,MY->N_Hds+1);
 
	  Zero_Myosin_Mem();
	  break;

	case MRASTER:
	  Alloc_Myosin(); 
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  MY->Raster = vals[N_Cntr++];
	  break;

	case MSPHERE:
	  Alloc_Myosin(); 
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  MY->Sph_Sz = vals[N_Cntr++];
	  break;
			 
	case BBSPHERE:
	  Alloc_BackBone();
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  BB->Sph_Sz = vals[N_Cntr++];
	  break;

	case ONESHOT:
	  NOT(VAR->OneShot);
	  break;

	case BROOKEHAVEN:
	  NOT(VAR->BrookeHaven);
	  break;

	case MYOSIN:
	  NOT(VAR->Myo);
	  if(VAR->Myo == TRUE) { 
	    if(Alloc_Mem_Myosin() == FALSE) {
	      printf("\nError allocating memory for Myosin\n\n");
	      CleanUp();
	    }
	    Zero_Myosin_Mem();
	  }
	  if(VAR->Myo == FALSE) {
	    free(MY);
	    free_datavector(MY->Slew,0,MY->N_Hds+1);
	    free_datavector(MY->Tilt,0,MY->N_Hds+1);
	    free_datavector(MY->Rot,0,MY->N_Hds+1);
	    free_datavector(MY->PRad,0,MY->N_Crwns+1);
	    free_datavector(MY->PAxial,0,MY->N_Crwns+1);
            free_datavector(MY->PAzi,0,MY->N_Crwns+1);

	    free_datamatrix(MY->PSlew,0,MY->N_Crwns+1,0,MY->N_Hds+1);
	    free_datamatrix(MY->PTilt,0,MY->N_Crwns+1,0,MY->N_Hds+1);
	    free_datamatrix(MY->PRot,0,MY->N_Crwns+1,0,MY->N_Hds+1);
	  }
	  break;

	case ACTIN:
	  NOT(VAR->Actin);
	  if(VAR->Actin == TRUE) {
	    if(Alloc_Mem_Actin() == FALSE) {
	      printf("\nError allocating memory for Actin\n\n");
	      CleanUp();
	    }
	    Zero_Actin_Mem();
	  }
	  if(VAR->Actin == FALSE) free(AA);
	  break;
			 
	case NOPERTS:
	  Alloc_Myosin();
	  NOT(VAR->NoPerts);
	  printf("\nhelloooooooooooooooo\n\n");
	  break;

	case TROPOMYOSIN:
	  NOT(VAR->Tropomyosin);
	  if(VAR->Tropomyosin == TRUE) {
	    if(Alloc_Mem_Tropomyosin() == FALSE) {
	      printf("\nError allocating memory for Tropomyosin\n\n");
	      CleanUp();
	    }
	    Zero_Tropomyosin_Mem();
	  }
	  if(VAR->Tropomyosin == FALSE) free(TR);
	  break;

	case BACKBONE:
	  NOT(VAR->BBone);
	  if(VAR->BBone == TRUE) {
	    if(Alloc_Mem_BackBone() == FALSE) {
	      printf("\nError allocating memory for BackBone\n\n");
	      CleanUp();
	    }
	    Zero_BackBone_Mem();
	  }
	  if(VAR->BBone == FALSE) free(BB);
	  break;
	 
	case CPROTEIN:
	  NOT(VAR->CPro);
	  if(VAR->CPro == TRUE) {
	    if(Alloc_Mem_C_Protein() == FALSE) {
	      printf("\nError allocating memory for C_Protein\n\n");
	      CleanUp();
	    }
	    Zero_C_Protein_Mem();
	  }
	  if(VAR->CPro == FALSE) free(CP);
	  break;

	case TITIN:
	  NOT(VAR->Titin);
	  if(VAR->Titin == TRUE) { 
	    if(Alloc_Mem_Titin() == FALSE) {
	      printf("\nError allocating memory for Titin\n\n");
	      CleanUp();
	    }
	    Zero_Titin_Mem();
	  }
	  if(VAR->Titin == FALSE) free(TT);
	  break;

	case TOTREPEAT:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  VAR->Tot_Rep = vals[N_Cntr++];
	  break;

	case IFILE:
	  if(Check_Char(Item_Ptr,&i) == FALSE) break;
	  strcpy(VAR->Intensity_File,wrdpp[i++]);
	  break;

	case OUTPUTFILE:
	  if(Check_Char(Item_Ptr,&i) == FALSE) break;
	  strcpy(VAR->Output_File,wrdpp[i++]);
	  break;

	case LOAD:
	  if(Check_Char(Item_Ptr,&i) == FALSE) break;
	  strcpy(Load_File,wrdpp[i++]);
	  if((Load = fopen(Load_File,"r")) == NULL ) {
	    printf("\nCannot Open %s ! \n",Load_File);
	    break;
	  }
	  Parse(Load,stdout);
	  fclose(Load);
	  break;

	case BBFILE:
	  Alloc_BackBone();
	  if(Check_Char(Item_Ptr,&i) == FALSE) break;
	  strcpy(BB->BackBone_File,wrdpp[i++]);
	  break;

	case WRITE:
	  if(Check_Char(Item_Ptr,&i) == FALSE) break;
	  if(Legal(output)) {
	    fprintf(output,"\nWriting ...\n");  
	  }
	  else break;
	  strcpy(VAR->Status_File,wrdpp[i++]);
	  Write_Status();
	  break;

	case DISPLAY:
	  Finish();
	  break;

	case SHELL:
	  shell(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		wrdpp,vals,nwrd,&N_Cntr);
	  break;

	case HEADFILE:
	  if(Check_Char(Item_Ptr,&i) == FALSE) break;
	  strcpy(MY->S1_Head_File,wrdpp[i++]);
	  break;

	case CPRADIUS:
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);
	  CP->Rad.St = Start;
	  CP->Rad.Sz = Size;
	  CP->Rad.Stp = Steps;
	  CP->Rad.Scl = Scale;
	  break;

	case TTRADIUS:
	  Alloc_Titin();
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);
	  TT->Rad.St = Start;
	  TT->Rad.Sz = Size;
	  TT->Rad.Stp = Steps;
	  TT->Rad.Scl = Scale;
	  break;

	case TTWEIGHT:
	  Alloc_Titin();
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);
	  TT->Weight.St = Start;
	  TT->Weight.Sz = Size;
	  TT->Weight.Stp = Steps;
	  TT->Weight.Scl = Scale;
	  if(TT->Weight.St == 0.0) {
	    printf("Warning. Weight of zero inputted!\n");
	  }
	  break;

	case CPWEIGHT:
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);
	  CP->Weight.St = Start;
	  CP->Weight.Sz = Size;
	  CP->Weight.Stp = Steps;
	  CP->Weight.Scl = Scale;
	  if(CP->Weight.St == 0.0) {
	    printf("Warning. Weight of zero inputted!\n");
	  }
	  break;

	case CPAXIAL:
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);
	  CP->Axial.St = Start;
	  CP->Axial.Sz = Size;
	  CP->Axial.Stp = Steps;
	  CP->Axial.Scl = Scale;
	  break;

	case MRADIUS:
	  subcommand(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		     wrdpp,vals,&Head,&Level,&Start,&Size,&Steps,
		     &Scale,&Domain,nwrd,&N_Cntr);
	  MY->Rad.St = Start;
	  MY->Rad.Sz = Size;
	  MY->Rad.Stp = Steps;
	  MY->Rad.Scl = Scale;
	  break;

	case SCOREDEV:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  ID->MSD = (int)vals[N_Cntr++];
	  break;

	case STATUS:
	  Status(output);
	  break;

	case WARRENTY:
	  Copyright(2);
	  break;
			
	case LICENSE:
	  Copyright(3);
	  break;

	case COMBINE:
	  VAR->Combine = TRUE;
	  break;

	case CWEIGHT:
	  if(Check_Val(Item_Ptr) == FALSE) break;
	  VAR->CWeight = vals[N_Cntr++];
	  break;

	case RESET:
	  Reset_Simul();
	  Reset_Search();
	  Reset_Molecule();
	  printf("Reloading Defaults...\n");
	  if((Template = fopen("Template.ini","r")) == NULL ) {
	    printf("\nCannot Open Template.ini ! \n");
	    break;
	  }
	  Parse(Template,NULL);
	  fclose(Template);
	  break;
	 
	case QUIT:
	  CleanUp();
	  break;
			 
	case EXIT:
	  CleanUp();
	  break;
			 
	case HASH:
	  comment(suboptionpp,&i,Item_Ptr,subwrdptr,&subnext,
		  wrdpp,vals,nwrd,&N_Cntr);
	  break;

	case RUN:
	  if(Legal(output) == FALSE) break;
	  fprintf(output,"\nExecuting ...\n");  
	  next = FALSE;
	}
	i++;
	Item_Ptr++;
      }
      for (i=0; i<nwrd; i++) 
	(void) free (wrdpp [i]);
    }
    else
      if(next) {
	fprintf(output,"\nAllowed  keywords...\n");
	i = j = 0;
	while (*optionpp[i] != '\0') {
	  fprintf(output,"   %-20s",optionpp[i++]);
	  if(j++ == 2) {
	    fprintf(output,"\n");
	    j = 0;
	  }
	}
	fprintf(output,"\n\nAllowed sub-keywords...\n");
	i = j = 0;
	while (*suboptionpp[i] != '\0') {
	  fprintf(output,"   %-20s",suboptionpp[i++]);
	  if(j++ == 2) {
	    fprintf(output,"\n");
	    j = 0;
	  }
	}
	fprintf(output,"\n");
      }
  }
}

int Check_Val(int *Item_Ptr)
{
  int Good_Value = TRUE;

  Item_Ptr++;
  if(*Item_Ptr != 1) {
    printf("\nError in input!\n");
    Item_Ptr--;
    Good_Value = FALSE;
  }
  return Good_Value;
}

int Check_Char(int *Item_Ptr, int *i)
{
  int Good_Char = TRUE;

  Item_Ptr++;
  (*i)++;
  if(*Item_Ptr != 2) {
    printf("\nError in input!\n");
    Item_Ptr--;
    Good_Char = FALSE;
  }
  return Good_Char;
}

int Bounds( int Head, int Level)
{
  extern struct Myosin *MY;

  int Good_Level,Good_Head;

  Good_Level = Good_Head = TRUE;
  if((Level > 3) || (Level < 0)) {
    printf("\nError inputting levels !\n\n");
    Good_Level = FALSE;
  }    
  if((Head > MY->N_Hds) || (Head < 1)){
    printf("\nError inputting heads!\n\n");
    Good_Head = FALSE;
  }
  if((Good_Head == FALSE) || (Good_Level == FALSE)) return FALSE;
  else return TRUE;
}

void comment(char **suboptionpp,int *i,int *Item_Ptr,char *subwrdptr,int *subnext,
	     char **wrdpp,double vals[],int nwrd,int *N_Cntr)
{
  *subnext = TRUE;
  while(*subnext) {
    if((*i)+1 == nwrd) break;
    (*i)++;
    Item_Ptr++;    
  }
}

void shell(char **suboptionpp,int *i,int *Item_Ptr,char *subwrdptr,int *subnext,
	   char **wrdpp,double vals[],int nwrd,int *N_Cntr)
{
  char shcmd[100];

  *subnext = TRUE;
  strcpy(shcmd," ");
  while(*subnext) {
    if((*i)+1 == nwrd) break;
    (*i)++;
    Item_Ptr++;
    strcat(shcmd,wrdpp[(*i)]);
    strcat(shcmd," ");
  }
  system(shcmd);
}

void subcommand(char **suboptionpp,int *i,int *Item_Ptr,char *subwrdptr,int *subnext,
		char **wrdpp,double vals[],int *Head,int *Level,double *Start,
		double *Size,double *Steps,double *Scale,int *Domain,int nwrd,int *N_Cntr)
{
  extern struct Myosin *MY;

  *subnext = TRUE;
  while(*subnext) {
    if((*i)+1 == nwrd) break;
    (*i)++;
    Item_Ptr++;    
    subwrdptr = wrdpp[(*i)];
    upc (subwrdptr); 
    switch (optcmp (subwrdptr, suboptionpp)) {
	       
    case AMBIGUOUS:
      printf ("\nAmbiguous sub-command  -  %s\n",subwrdptr);
      subnext = FALSE;
      break;
	       
    case NOMATCH:
      *subnext = FALSE;
      (*i)--;
      Item_Ptr--;
      break;
	       
    case HEAD:
      Item_Ptr++;
      if(*Item_Ptr != 1) {
	printf("\nError in inputting number of heads\n");
	Item_Ptr--;
	(*i)--;
	*subnext = FALSE;
	break;
      }
      *Head = (int)vals[(*N_Cntr)++];
      break;

    case LEVEL:
      Item_Ptr++;
      if(*Item_Ptr != 1) {
	printf("\nError in inputting crown level\n");
	Item_Ptr--;
	(*i)--;
	*subnext = FALSE;
	break;
      }
      if((int)vals[*N_Cntr] > MY->N_Crwns) {
	printf("\nCannot have level greater than %d\n",MY->N_Crwns);
	Item_Ptr--;
	(*i)--;
	*subnext = FALSE;
	break;
      }
      *Level = (int)vals[(*N_Cntr)++];
      break;

    case DOMAIN:
      Item_Ptr++;
      if(*Item_Ptr != 1) {
	printf("\nError in inputting domain number\n");
	Item_Ptr--;
	(*i)--;
	*subnext = FALSE;
	break;
      }
      if(((int)vals[*N_Cntr] > 4) || ((int)vals[*N_Cntr] < 1)) {
	printf("\nDomain Number Must be between 1 and 4\n");
	Item_Ptr--;
	(*i)--;
	*subnext = FALSE;
	break;
      }
      *Domain = (int)vals[(*N_Cntr)++];
      break;

    case START:
      Item_Ptr++;
      if(*Item_Ptr != 1) {
	printf("\nError in inputting start slew Parameter\n");
	Item_Ptr--;
	(*i)--;
	*subnext = FALSE;
	break;
      }
      *Start = vals[(*N_Cntr)++];
      break;

    case SIZE:
      Item_Ptr++;
      if(*Item_Ptr != 1) {
	printf("\nError in inputting size slew Parameter\n");
	Item_Ptr--;
	(*i)--;
	*subnext = FALSE;
	break;
      }
      *Size = vals[(*N_Cntr)++];
      break;

    case STEPS:
      Item_Ptr++;
      if(*Item_Ptr != 1) {
	printf("\nError in inputting step Parameter\n");
	Item_Ptr--;
	(*i)--;
	*subnext = FALSE;
	break;
      }
      *Steps = vals[(*N_Cntr)++];
      break;

    case SCALE:
      Item_Ptr++;
      if(*Item_Ptr != 1) {
	printf("\nError in inputting scale Parameter\n");
	Item_Ptr--;
	(*i)--;
	*subnext = FALSE;
	break;
      }
      *Scale = vals[(*N_Cntr)++];
      break;
    }
  }
  if((*Steps == 0.0) && (*Size != 0.0)) {
    printf("\n\007Resetting step size to zero.\n\n");
    *Size = 0.0;
  }
}



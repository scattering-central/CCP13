#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"
#include "build.h"

struct C_Protein *CP;
struct Titin *TT;
struct Myosin *MY;
struct Actin *AA;
struct Tropomyosin *TR;
struct BackBone *BB;
struct Intensity *ID;
struct Info *VAR;
struct Constant Cnst = {
  3.1415926535897931,
  6.2831853071795862,
  1.7320508075688772,
  0.8660254037844386,
  3.1415926535897931/180.0};

long idum; /* For random number generator in annealing */

main(int argc, char *argv[])
{
  FILE *Log,*Template,*Input;
  time_t The_Time;
  time(&The_Time);

  ID = (struct Intensity*) malloc((unsigned) sizeof(struct Intensity));
  VAR = (struct Info*) malloc((unsigned) sizeof(struct Info));
     
  Reset_Simul();
  Reset_Search();
  Reset_Molecule();
     
  printf("\n\n\nMOVIE, by Liam Hudson  --  Build %d at %s",BUILD,ctime(&The_Time));
  printf("Movie comes with ABSOLUTELY NO WARRANTY; type WARRANTY at prompt for details.\n");
  printf("This is free software, and you are welcome to redistribute it\n");
  printf("under certain conditions; type LICENSE at command prompt for details\n");
     
  if((Template = fopen("Template.ini","r")) == NULL ) {
    printf("\nCannot Open Template.ini ! \n");
    CleanUp();
    return (1);
  }
     
  if((Log = fopen("Movie.log","w")) == NULL ) {
    printf("\nCannot Create Movie.log ! \n");
    CleanUp();
  }
  Parse(Template,Log);
  fclose(Template);
  if(argc > 1) {
    if((Input = fopen(argv[1],"r")) == NULL ) {
      printf("\nCannot Open %s ! \n",argv[1]);
      CleanUp(); 
    }
    printf("\nParsing %s...\n",argv[1]);
    Parse(Input,Log);
    fclose(Input);
  }
  if(argc > 2) strcpy(VAR->Output_File,argv[2]);
  if((argc == 1) || (argc > 3)) printf("\nAccepting commandline input...\n\n");
  fclose(Log);
  while(TRUE != FALSE) {
    Parse(stdin,stdout);
    Initialization();
    if(!VAR->View) Load_Intensity();
    Process_Data();
    Reset();
    if(VAR->OneShot == TRUE) {
      strcpy(VAR->Status_File,"Movie.Final");
      Write_Status();
      CleanUp();
    }
    fflush(VAR->Output);
  }
  
  return (1);
}

void CleanUp( void )
{
  extern struct Info *VAR;
  extern struct Myosin *MY;
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct Constant Cnst;
  extern struct Intensity *ID;
     
  int heads,crowns;

  printf("\nExiting to the Operating System...\n\n");
  fclose(VAR->Output);
  if(VAR->Myo) {
    heads  = MY->N_Hds+1;
    crowns = MY->N_Crwns+1;
    free_datavector(MY->Slew,0,heads);
    free_datavector(MY->Tilt,0,heads);
    free_datavector(MY->Rot,0,heads);
    free_datavector(MY->PRad,0,crowns);
    free_datavector(MY->PAxial,0,crowns);
    free_datavector(MY->PAzi,0,crowns);
    free_datamatrix(MY->PSlew,0,crowns,0,heads);
    free_datamatrix(MY->PTilt,0,crowns,0,heads);
    free_datamatrix(MY->PRot,0,crowns,0,heads);
    free(MY);
  }
  if(VAR->Actin) free(AA);
  if(VAR->Tropomyosin) free(TR);
  if(VAR->CPro)  free(CP);
  if(VAR->Titin) free(TT);
  if(VAR->BBone) free(BB);
  free(ID);
  free(VAR);
  exit(0);
}






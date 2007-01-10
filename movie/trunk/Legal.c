#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

int Legal(FILE *output)
{
  extern struct Info *VAR;
  extern struct Myosin *MY;
  extern struct C_Protein *CP;
  extern struct Titin *TT;
  extern struct BackBone *BB;
     
  int Search,Search2,Simul,Cell;
  Search = VAR->Global    + VAR->Replex +
    VAR->Anneal    + VAR->Simplex + 
    VAR->Powell    + VAR->Torus;
  Search2 = VAR->View        + VAR->HKLOutput + 
    VAR->Reflections + VAR->Fourier_Diff +
    VAR->Observed;
  Simul  = VAR->Corr      + VAR->Least_Sq + 
    VAR->Cryst;
  Cell   = VAR->Myo       + VAR->Actin +
    VAR->Titin     + VAR->CPro + 
    VAR->BBone     + VAR->Tropomyosin;
  if((VAR->View == TRUE) && (VAR->NoPerts == TRUE)) {
    printf("\n\nCannot use no perturbations with view mode..\n\n");
    return FALSE;
  }
  if((Search+Search2 == FALSE) || (Search+Search2 != TRUE)) {
    printf("\n\nError in model searching method...\n\n");
    return FALSE;
  }
  if((VAR->Weighting == TRUE) || (VAR->Combine) == TRUE)
    {
      if(Simul + Search2 == FALSE) {
	printf("\n\nPlease select a simularity measure...\n\n");
	return FALSE;
      }
    }
  if((Simul == FALSE) && (Search2 == FALSE)) {
    printf("\n\nPlease input Simularity measure...\n\n");
    return FALSE;
  }
  if(VAR->Scoring) {
    if(VAR->Corr) {
      fprintf(output,"\n\nScoring cannot be used with correlation function\n\n");
      return FALSE;	       
    }
  }
  if(Cell == FALSE) {
    fprintf(output,"\n\n Please input part of unit cell to be transformed\n\n");
    return FALSE;
  }
  if(VAR->View) {
    if((VAR->Avs + VAR->DCad + VAR->Pdb == FALSE)) {
      fprintf(output,"\n\n Please input what type of format the view data will be in\n\n");
      return FALSE;
    }
  }
  if(!strcmp(VAR->Output_File,"STDOUT")) VAR->Output = stdout;
  else {
    if((VAR->Output = fopen(VAR->Output_File,"w")) == NULL ) {
      printf("\nCannot Open %s ! \n",VAR->Output_File);
      return FALSE;
    }
  }
  if(VAR->BBone) {
    if(BB->Model == 1) {
      if(BB->Rad == 0.0) {
	printf("\007 Cannot have a BackBone radius of zero.\n");
	return FALSE;
      }
      if(VAR->View == FALSE) {
	printf("\007 Can only use BBMODEL 1 with VIEW.\n");
	return FALSE;
      }
    }
  }
  return TRUE;
}




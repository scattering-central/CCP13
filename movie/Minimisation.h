/***********************************************************************
 *                            torus.h                                  *
 ***********************************************************************
 Purpose: Torus header file
 Authors: R.C.Denny
 Returns: Nil
 Updates: 12/09/95 RCD Initial implementation
 
*/
 
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

typedef struct
{
  double bump;
  int counter1;
  int counter2;
  double tor_exit;
  int scalar1;
  int scalar2;
  double shrink_hit;
  double shrink_trial;
  double tor_hole;
} Torus_Input;

typedef union
{
  double dfun;
  float ffun;
  int ifun;
} Function_Type;













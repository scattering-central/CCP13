/***********************************************************************
 *                          fixdefs.h                                  *
 ***********************************************************************
 Purpose: Image header file
 Authors: G.R.Mant
 Returns: Nil
 Updates: 24/10/95 RCD 
 
*/
 
#define MAXCOLOR 240
#define DATA_TYPE unsigned int
#ifndef FALSE
#  define FALSE   0
#  define TRUE    !FALSE
#endif
#define MAXWIN  10
#define MAXTERM 80
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define SWAP(a, b) (itemp = (a), (a) = (b), (b) = itemp)
#define STDDIM  512
#define NUMWRD  10
#define NUMVAL  10
#define MAXVERT 10
#define MAXDAT  100

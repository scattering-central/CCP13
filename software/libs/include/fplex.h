/***********************************************************************
 *                             fplex.h                                 *
 ***********************************************************************
 Purpose: fplex header file
 Authors: R.C.Denny
 Returns: Nil
 Updates: 27/02/96 RCD Initial implementation
 
*/

#define MINGRP  2
#define MAXGRP  5
 
#ifdef titan
 
#define FREPLX FREPLX
#define FSMPLX FSMPLX
 
#elif defined (AIX) || defined (__hpux)
 
#define FREPLX freplx
#define FSMPLX fsmplx
 
#else      /* solaris/convex/irix/OSF1/linux */ 
 
#define FREPLX freplx_
#define FSMPLX fsmplx_
 
#endif

int freplex (float *, float *, int, float (*)(), int, int, float, float, 
             float *);
int fsimplex (float *, float *, int, float *, int, float, float, int *, 
              float (*)(), int, int *, int *, int *);
void FREPLX (float *, float *, int *, float (*)(), int *, int *, float *, 
             float *, float *, int *);
void FSMPLX (float *, float *, int *, float *, float *, float (*)(),
             int *, int *, int *);





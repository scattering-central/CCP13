/***********************************************************************
 *                          fixproto.h                                 *
 ***********************************************************************
 Purpose: Defines prototypes for c routines used in image
 Authors: R.C.Denny
 Returns: Nil
 Updates: 24/10/95 RCD initial implementation
*/

/*
 * image.c prototypes
 */
#ifdef titan

#  define IMAGE  IMAGE
#  define CFREE  CFREE
#  define DRAWPT DRAWPT
#  define DRAWCL DRAWCL

#else
#  if defined (AIX) || defined (__hpux)

#    define IMAGE image
#    define CFREE cfree
#    define DRAWPT drawpt
#    define DRAWCL drawcl

#  else         /*    sun / convex / irix / linux    */ 

#    define IMAGE image_
#    define CFREE cfree_
#    define DRAWPT drawpt_
#    define DRAWCL drawcl_

#  endif
#endif

void IMAGE (void **, int *, int *, int *, int *, int *, int *, int *);
void CFREE ();
void DRAWPT (float *, float *, int *);
void DRAWCL (float *, float *, float *);

/*
 * scale_image.c prototypes 
 */
int file_to_image (float *, int, int, int, int, long int);
int image_to_file_coords (int *, int *, int, int, int *, int *);
int i2f_scale (int, int);
int f2i_scale (double, int);
int data_thresh (int);
int file_to_image_coords (float *, float *, int, int, int *, int *);

/*
 * putimage.c prototypes
 */
int put_image (float *, int, int, int *);
void process_event (int, int, int, float *);

/*
 * getimage.c prototypes
 */
int get_polygon (int *, int *, int *, int, int, int);
int variable_line (int, int, int *, int *, int *, int *);
int variable_rectangle (int, int, int *, int *, int *, int *);
int skew_rectangle (int, int, int *, int *, int *, int *, int *);



		


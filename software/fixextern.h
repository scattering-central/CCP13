/***********************************************************************
 *                          fixextern.h                                *
 ***********************************************************************
 Purpose: Image header file (for source files other than image.c)
 Authors: G.R.Mant
 Returns: Nil
 Updates: 27/06/89 GRM Initial implementation
          18/01/94 RCD Modified from bslimage.h for use with FIX

*/

#include "fixdefs.h"
#include "fixproto.h"
#include "XfDraw.h"

extern Display	                *bsl_display;
extern Window	                bsl_window[MAXWIN];
extern GC	                bsl_gc[MAXWIN];
extern XImage                   *xi[MAXWIN];
extern XColor                   colors[MAXCOLOR];
extern XVisualInfo              *visualList;
extern XSetWindowAttributes     attributes;
extern Cursor                   cursor;
extern DATA_TYPE                *buff [MAXWIN];
extern DATA_TYPE                *cbuf [MAXWIN];
extern int	                current_win;
extern int	                NColor;
extern int	                NColorAlloc;
extern unsigned long            pixcol[MAXCOLOR];
extern int                      screen;
extern int                      screen_depth;
extern int                      offset;
extern int                      bitmap_pad;
extern int                      bits_per_pixel;
extern float                    tmin, tmax;

	


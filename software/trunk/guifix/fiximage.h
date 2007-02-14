/***********************************************************************
 *                          fiximage.h                                 *
 ***********************************************************************
 Purpose: Image header file (for image.c)
 Authors: G.R.Mant
 Returns: Nil
 Updates: 27/06/89 GRM Initial implementation
          18/01/94 RCD Modified from bslimage.h for use with FIX

*/

#include "fixdefs.h"
#include "fixproto.h"
#include "XfDraw.h"

Display	                 *bsl_display;
Window	                 bsl_window[MAXWIN];
GC	                 bsl_gc[MAXWIN];
XImage                   *xi[MAXWIN];
XColor                   colors[MAXCOLOR];
XVisualInfo              *visualList;
XSetWindowAttributes     attributes;
Cursor                   cursor;
DATA_TYPE                *buff [MAXWIN];
DATA_TYPE                *cbuf [MAXWIN];
int	                 current_win;
int	                 NColor;
int	                 NColorAlloc;
unsigned long            pixcol[MAXCOLOR];
int                      screen;
int                      screen_depth;
int                      offset;
int                      bitmap_pad;
int                      bits_per_pixel;
float                    tmin, tmax;

	


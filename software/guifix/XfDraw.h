/***********************************************************************
 *                            XfDraw.h                                 *
 ***********************************************************************
 Purpose: Defines prototypes for drawing functions
 Authors: R.C.Denny
 Returns: Nil
 Updates: 24/10/95 RCD initial implementation
*/

void XDrawCircle (Display *, Window, GC, int, int, int, int, int);
void XDrawPlus (Display *, Window, GC, int *, int *, int, int);
void XDrawCross (Display *, Window, GC, int *, int *, int, int);

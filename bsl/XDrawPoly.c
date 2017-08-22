/***********************************************************************
 **                    XDrawPoly.c                                    **
 ***********************************************************************

 Purpose: X Windows routine to draw a polygon.
 Authors: G.R.Mant
 Returns: Nil
 Updates: 27/06/89 Initial implementation

*/

#include <stdio.h>
#include <errno.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/Xos.h>

void XDrawPoly (Display *display, Window window, GC gc,
		int *xverts, int *yverts, int nvert)
{
   int i;

   for (i=1; i<nvert; i++)
      XDrawLine (display, window, gc, xverts[i-1], yverts[i-1],
                 xverts[i], yverts[i]);
   XDrawLine (display, window, gc, xverts[nvert-1], yverts[nvert-1],
                 xverts[0], yverts[0]);
   return;
}

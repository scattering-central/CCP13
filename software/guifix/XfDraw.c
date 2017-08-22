/***********************************************************************
 **                    XfDrawCircle.c                                 **
 ***********************************************************************
 Purpose: X Windows routine to draw a circle (properly).
 Authors: R.C.Denny
 Returns: Nil
 Updates: 18/01/94 Initial implementation

*/

#ifdef __hpux
#  define caddr_t char *
#endif
#include <stdio.h>
#include <errno.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/Xos.h>
#include <math.h>
#include "XfDraw.h"

void XfDrawCircle (Display *display, Window window, GC gc, int xcen, int ycen, 
		  int radius, int npix, int nrast)

{
  int i;
  int phi1 = 0, phi2 = 23040;        /*  angles in degrees*64  */
  int d [4];
  float dx, dy, ddx, ddy, r, diag, dmin;
  static float rtod;
  
  if (rtod == 0.0)
    rtod = 45.0 / atan (1.0);
  
  d [0] = npix - xcen;
  d [1] = ycen;
  d [2] = xcen;
  d [3] = nrast - ycen;
  r = (float) radius;

  for (i=0; i<4 ; i++)
  {
  
    if (d [((i+2) % 4)] < 0 && radius < d [i])
    {
      if (radius < abs (d [((i+2) % 4)]))
	  return;
      ddx = (float) d [((i+2) % 4)];
      dy = sqrt (r * r - ddx * ddx);
    }
    else
    {
      ddx = 0.0;
      dy = (float) d [((i+1) % 4)];
    }

    if (d [((i+3) % 4)] < 0 && radius < d [((i+1) % 4)])
    {
      if (radius < abs (d[((i+3) % 4)]))
	  return;
      ddy = (float) d [((i+3) % 4)];
      dx = sqrt (r * r - ddy * ddy);
    }
    else
    {
      ddy = 0.0;
      dx = (float) d [i];
    }

    diag = sqrt (dx * dx + dy * dy);
    dmin = sqrt (ddx * ddx + ddy * ddy);
  
    if ((diag > r) && (r > dmin) && (dx > 0.0) && (dy > 0.0))
    {
      if (r > dx)
	phi1 = 64 * (90 * i + (int) (acos (dx / r) * rtod)) + 32;

      if (r > dy)
	phi2 = 64 * (90 * i + (int) (asin (dy / r) * rtod)) - 32; 
      
      if (((phi2 % 5760) != 0) || (i == 3))
      {
	XDrawArc (display, window, gc,
		  (xcen - radius), (ycen - radius),
		  (2 * radius), (2 * radius), phi1, phi2);
	phi2 = 23040;
      }
    }
    else
      phi1 = 5760 * i;
  }
  return;
}

/***********************************************************************
 **                    XfDrawPlus.c                                   **
 ***********************************************************************
 Purpose: X Windows routine to draw a set of +'s of height 2 * size + 1.
 Authors: R.C.Denny
 Returns: Nil
 Updates: 18/01/94 Initial implementation

*/

void XfDrawPlus (Display *display, Window window, GC gc, int *xverts, int *yverts, 
		int nvert, int size)

/*  int     xverts[], yverts[];        selected x,y coordinates    */
/*  int     nvert, size;               nos. of vertices and size   */

{
   int i;

   for (i=0; i<nvert; i++)
   {
      XDrawLine (display, window, gc, xverts[i]-size, yverts[i],
                 xverts[i]+size, yverts[i]);
      XDrawLine (display, window, gc, xverts[i], yverts[i]-size,
                 xverts[i], yverts[i]+size);
   }
   return;
}

/***********************************************************************
 **                    XfDrawCross.c                                  **
 ***********************************************************************
 Purpose: X Windows routine to draw a set of x's of height 2 * size + 1.
 Authors: R.C.Denny
 Returns: Nil
 Updates: 20/10/95 Initial implementation

*/

void XfDrawCross (Display *display, Window window, GC gc, int *xverts, int *yverts, 
		int nvert, int size)

/*  int     xverts[], yverts[];        selected x,y coordinates    */
/*  int     nvert, size;               nos. of vertices and size   */

{
   int i;

   for (i=0; i<nvert; i++)
   {
      XDrawLine (display, window, gc, xverts[i]-size, yverts[i]-size,
                 xverts[i]+size, yverts[i]+size);
      XDrawLine (display, window, gc, xverts[i]+size, yverts[i]-size,
                 xverts[i]-size, yverts[i]+size);
   }
   return;
}






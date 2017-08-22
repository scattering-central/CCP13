#include <math.h>
#include <errno.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/Xos.h>
#include "bslimage.h"

void circle_set (int *ixcent, int *iycent, int *radius, int npix, int nrast)
{
   XEvent event;
   int    first = TRUE;                /* first pass through routine */
   int    button;                      /* mouse button depressed     */
   int    ifpix, ilpix, ifrast, ilrast;
   int    i, j, k, itemp, xpt, ypt;
   static int count, rad1;
   register int win;
 
   if ((count % 2) == 0)
   {
     printf ("Button 1: Depress and move to select centre of circle\n");
     printf ("Button 2: Depress and move to adjust radius of circle\n");
     printf ("Button 3: Click button to exit selection\n");
   }
   win = current_win;
   XSelectInput (bsl_display, bsl_window[win],
		 Button1MotionMask | Button2MotionMask | ButtonPressMask);

   XSetForeground (bsl_display, bsl_gc[win], 0xffffff);
   XSetFunction   (bsl_display, bsl_gc[win], GXxor);
   if (NColor == 128)
       XSetPlaneMask (bsl_display, bsl_gc[win], 0x7f); 

   (void) circle_draw (*ixcent, *iycent, *radius, npix, nrast, win);
   first = FALSE;

   while (1)
   {   
      XNextEvent (bsl_display, &event);
      switch (event.type)
      {
         case ButtonPress:
            button = event.xbutton.button;
            if (button == 3)
            {   
               first = TRUE;
	       XSetFunction   (bsl_display, bsl_gc[win], GXcopy);
	       XSetPlaneMask (bsl_display, bsl_gc[win], AllPlanes);
               if ((count % 2) == 0)
		 rad1 = *radius;

               count++;
               return;
            }
            break;
         case MotionNotify:
            if (button == 1)
            {
	      xpt = event.xbutton.x;
	      ypt = event.xbutton.y;
		if (!first)
	        {
		  if ((count % 2) == 1)
		    (void) circle_draw (*ixcent, *iycent, rad1, npix, nrast, win);       

		  (void) circle_draw (*ixcent, *iycent, *radius, npix, nrast, win);
		}
		first = FALSE;
		*ixcent = xpt;
		*iycent = ypt;
		if ((count % 2) == 1)
		  (void) circle_draw (*ixcent, *iycent, rad1, npix, nrast, win);

		(void) circle_draw (*ixcent, *iycent, *radius, npix, nrast, win);
	    }

            if (button == 2)
            {
	      xpt = event.xbutton.x - *ixcent;
	      ypt = event.xbutton.y - *iycent;
	  
	      itemp = (int) sqrt ((double)((xpt * xpt) + (ypt * ypt)));
	      if (!first) 
		(void) circle_draw (*ixcent, *iycent, *radius, npix, nrast, win);
		
	      first  = FALSE;
	      *radius = itemp;
	      (void) circle_draw (*ixcent, *iycent, *radius, npix, nrast, win);
	    }
	    break;
	  }
    }
}

int circle_draw (int xcen, int ycen, int radius, int npix, int nrast, int win)

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
	XDrawArc (bsl_display, bsl_window[win], bsl_gc[win],
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

/***********************************************************************
 *                       polfil.c                                      *
 ***********************************************************************
 Purpose: Define a set of polygonal shapes using the cursor.
          The result is stored as a mask of 1's & 0's.
          Use of buttons:-
             1 - Accept this position and mark it (if the first point)
                 or else join it to the previous point.
             2 - Delete the previous point and continue.
             3 - Accept this as the last point of the polygon & fill it.
 Authors: G.R.Mant
 Returns: Nil
 Updates: 11/07/89 Initial implementation

*/

#include <stdio.h>
#include <errno.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/Xos.h>
#include "bslimage.h"

void polygon_fill (mask,npix,nrast)

float mask[];            /* mask buffer   */
int   npix,nrast;        /* size of image */

{
   XEvent event;
   int    first = TRUE;           /* first pass through routine */
   int    button;                 /* button selected            */
   int    ipx[512],ipy[512];      /* selected x,y coordinates   */
   int    xpt, ypt, ix, iy;       /* current coordinate         */
   int    ipoint;                 /* nos. of points selected    */
   register int win;

   printf ("Button 1: Depress and move to select points\n");
   printf ("Button 2: Click button to delete last point\n");
   printf ("Button 3: Click button to exit selection\n");

   win = current_win;

   XSelectInput (bsl_display, bsl_window[win],
		 Button1MotionMask | ButtonPressMask | ButtonReleaseMask);

   XSetForeground (bsl_display, bsl_gc[win], 0xffffff);
   XSetFunction   (bsl_display, bsl_gc[win], GXxor);
   if (NColor == 128)
       XSetPlaneMask (bsl_display, bsl_gc[win], 0x7f);

   ipoint = 0;
   while (1)
   {   
      XNextEvent (bsl_display, &event);
      switch (event.type)
      {
         case ButtonPress:
            button = event.xbutton.button;
            if (button == 2 && ipoint > 0)
            {
               ipoint--;
               if (ipoint > 0)
                  XDrawLine (bsl_display, bsl_window[win], bsl_gc[win],
			     ipx[ipoint-1], ipy[ipoint-1], ipx[ipoint],
			     ipy[ipoint]);
               else
                  XDrawPoint (bsl_display, bsl_window[win], bsl_gc[win],
			      ipx[0], ipy[0]);
            }
            if (button == 3)
            {
               first = TRUE;
               ipx[ipoint] = ipx[0];
               ipy[ipoint] = ipy[0];
               XDrawLine (bsl_display, bsl_window[win], bsl_gc[win], ipx[0],
                          ipy[0], ipx[ipoint-1], ipy[ipoint-1]);
               XFlush (bsl_display);
               ipoint++;
               if (ipoint > 2)
                  bitset (ipx, ipy, ipoint, mask, npix, nrast);
	       XSetFunction   (bsl_display, bsl_gc[win], GXcopy);
	       XSetPlaneMask (bsl_display, bsl_gc[win], AllPlanes);
	       return;
            }
            break;
	 case ButtonRelease:
            button = event.xbutton.button;
	    if (button == 1)
            {
               ix = event.xbutton.x;
               iy = event.xbutton.y;
               if (ix >= 0 && ix < npix && iy >= 0 && iy < nrast)
               {
                  if (ipoint == 0)
                     XDrawPoint (bsl_display, bsl_window[win], bsl_gc[win],
				 ix, iy);
                  if (ipoint > 0 && first)
                     XDrawLine (bsl_display, bsl_window[win], bsl_gc[win],
				ipx[ipoint-1], ipy[ipoint-1], ix, iy);
                  ipx[ipoint] = ix;
                  ipy[ipoint] = iy;
                  ipoint++;
                  first = TRUE;
               }
            }
            break;
         case MotionNotify:
            button = event.xbutton.button;
            if (button == 1 && ipoint > 0)
            {
               xpt = event.xbutton.x;
               ypt = event.xbutton.y;
               if (xpt >= 0 && xpt < npix && ypt >= 0 && ypt < nrast)
               {
                  if (!first)
                     XDrawLine (bsl_display, bsl_window[win], bsl_gc[win],
				ipx[ipoint-1], ipy[ipoint-1], ix, iy);
                  first = FALSE;
                  ix = xpt;
                  iy = ypt;
                  XDrawLine (bsl_display, bsl_window[win], bsl_gc[win],
			     ipx[ipoint-1], ipy[ipoint-1], ix, iy);
               }
            }
            break;
      }
   }
}

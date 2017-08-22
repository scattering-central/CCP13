/***********************************************************************
 **                       cirfil.c                                    **
 ***********************************************************************

 Purpose: Create & move a circle over an image and return a mask
          of 1's and 0's.
          Use of buttons:-
             1 - Adjust the centre of the circle.
             2 - Adjust the radius of the circle.
             3 - Terminates the selection.
 Authors: G.R.Mant
 Returns: Nil
 Updates: 27/06/89 Initial implementation

*/

#include <stdio.h>
#include <math.h>
#include <errno.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/Xos.h>
#include "bslimage.h"

void circle_fill (mask, npix, nrast)

float mask[];                      /* mask buffer   */
int   npix,nrast;                  /* size of image */

{
   XEvent event;
   int    first = TRUE;                /* first pass through routine */
   int    button;                      /* mouse button depressed     */
   int    ixcent, iycent;              /* circle centre coordinates  */
   int    radius, diam;                /* circle radius and diameter */
   int    ifpix, ilpix, ifrast, ilrast;
   int    i, j, k, itemp, xpt, ypt;
   register int win;
 
   printf ("Button 1: Depress and move to select centre of circle\n");
   printf ("Button 2: Depress and move to adjust radius of circle\n");
   printf ("Button 3: Click button to exit selection\n");

   win = current_win;
   XSelectInput (bsl_display, bsl_window[win],
		 Button1MotionMask | Button2MotionMask | ButtonPressMask);

   ixcent = npix  / 2;
   iycent = nrast / 2;
   radius = npix  / 8;
   diam   = radius * 2;

   XSetForeground (bsl_display, bsl_gc[win], 0xffffff);
   XSetFunction   (bsl_display, bsl_gc[win], GXxor);
   if (NColor == 128)
       XSetPlaneMask (bsl_display, bsl_gc[win], 0x7f);

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
               itemp = radius * radius;
               ifpix = ixcent - radius;
               ilpix = ixcent + radius;
               ifrast = iycent - radius;
               ilrast = iycent + radius;
               for (i=ifrast; i<=ilrast; i++)
               {
                  k = i * npix;
                  ypt = (i - iycent) * (i - iycent);
                  for (j=ifpix; j<=ilpix; j++)
                  {
                     xpt = (j-ixcent) * (j - ixcent);
                     if ((xpt + ypt) <= itemp) mask[k+j] = 1.0;
                  }
               }
	       XSetFunction   (bsl_display, bsl_gc[win], GXset);
	       XSetPlaneMask (bsl_display, bsl_gc[win], AllPlanes);
               return;
            }
            break;
         case MotionNotify:
            if (button == 1)
            {
               xpt = event.xbutton.x;
               ypt = event.xbutton.y;
               if ((xpt - radius) >= 0 && (xpt + radius) < npix &&
                   (ypt - radius) >= 0 && (ypt + radius) < nrast)
               {
                  if (!first)
                     XDrawArc (bsl_display, bsl_window[win], bsl_gc[win],
			       (ixcent - radius), (iycent - radius),
			       diam, diam, 0, (360 * 64));
                  first = FALSE;
                  ixcent = xpt;
                  iycent = ypt;
                  XDrawArc (bsl_display, bsl_window[win], bsl_gc[win],
			    (ixcent - radius), (iycent - radius),
			    diam, diam, 0, (360 * 64));
               }
            }  
            if (button == 2)
            {
               xpt = event.xbutton.x - ixcent;
               ypt = event.xbutton.y - iycent;
               itemp = (int) sqrt ((double)((xpt * xpt) + (ypt * ypt)));
               if ((ixcent - itemp) >= 0 && (ixcent + itemp) < npix &&
                   (iycent - itemp) >= 0 && (iycent + itemp) < nrast)
               {
                  if (!first) 
                     XDrawArc (bsl_display, bsl_window[win], bsl_gc[win],
			       (ixcent - radius), (iycent - radius),
			       diam, diam, 0, (360 * 64));
                  first  = FALSE;
                  radius = itemp;
                  diam   = radius *2;
                  XDrawArc (bsl_display, bsl_window[win], bsl_gc[win],
			    (ixcent - radius), (iycent - radius),
			    diam, diam, 0, (360 * 64));
               }
            }
            break;
      }
   }
}

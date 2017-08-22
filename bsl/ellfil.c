/***********************************************************************
 **                       ellfil.c                                    **
 ***********************************************************************
 Purpose: Create & move an ellipse over an image and return a mask
          of 1's and 0's.
          Use of buttons:-
             1 - Adjust the centre of the ellipse.
             2 - Adjust the major & minor axes.
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

void ellipse_fill (mask, npix, nrast)

float mask[];                      /* mask buffer   */
int   npix,nrast;                  /* size of image */

{
   XEvent event;
   float  xpt, ypt;	
   int    first = TRUE;                /* first pass through routine */
   int    button;                      /* mouse button depressed     */
   int    ixcent, iycent;              /* ellipse centre coordinates */
   int    axmaj, axmin, hbox, wbox;    /* major and minor axes       */
   int    ifpix, ilpix, ifrast, ilrast;
   int    i, j, k, itemp, jtemp, ix, iy;
   register int win;

   printf ("Button 1: Depress and move to select centre of ellipse\n");
   printf ("Button 2: Depress and move to adjust major & minor axes\n");
   printf ("Button 3: Click button to exit selection\n");

   win = current_win;

   XSelectInput (bsl_display, bsl_window[win],
		 Button1MotionMask | Button2MotionMask | ButtonPressMask);

   ixcent = npix  / 2;
   iycent = nrast / 2;
   axmaj  = npix  / 8;
   axmin  = npix / 16;
   wbox   = axmaj * 2;
   hbox   = axmin * 2;

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
            if (button == 3)                  /* exit from this option */
            {   
               first = TRUE;
               itemp = axmaj * axmaj;
               jtemp = axmin * axmin;
               ifpix = ixcent - axmaj;
               ilpix = ixcent + axmaj;
               ifrast = iycent - axmin;
               ilrast = iycent + axmin;
               for (i=ifrast; i<=ilrast; i++)
               {
                  k = i * npix;
                  ypt = (float) ((i - iycent) * (i - iycent)) / (float) jtemp;
                  for (j=ifpix; j<=ilpix; j++)
                  {
                     xpt = (float) ((j - ixcent) * (j - ixcent)) / 
                           (float) itemp;
                     if ((xpt + ypt) <= 1.0) mask[k+j] = 1.0;
                  }
               }
	       XSetFunction  (bsl_display, bsl_gc[win], GXcopy);
	       XSetPlaneMask (bsl_display, bsl_gc[win], AllPlanes);
               return;
            }
            break;
         case MotionNotify:
            if (button == 1)                  /* move centre of ellipse */
            {
               ix = event.xbutton.x;
               iy = event.xbutton.y;
               if ((ix - axmaj) >= 0 && (ix + axmaj) < npix &&
                   (iy - axmin) >= 0 && (iy + axmin) < nrast)
               {
                  if (!first) 
                     XDrawArc (bsl_display, bsl_window[win], bsl_gc[win],
			       (ixcent - axmaj), (iycent - axmin),
			       wbox, hbox, 0, (360 * 64));
                  first = FALSE;
                  ixcent = ix;
                  iycent = iy;
                  XDrawArc (bsl_display, bsl_window[win], bsl_gc[win],
			    (ixcent - axmaj), (iycent - axmin),
			    wbox, hbox, 0, (360 * 64));
               }
            }  
            if (button == 2)              /* change major & minor axes */
            {
               ix = abs (ixcent - event.xbutton.x);
               iy = abs (iycent - event.xbutton.y);
               if ((ixcent - ix) >= 0 && (ixcent + ix) < npix &&
                   (iycent - iy) >= 0 && (iycent + iy) < nrast &&
                    ix != 0 && iy != 0)
               {
                  if (!first)
                  {
                     XDrawArc (bsl_display, bsl_window[win], bsl_gc[win],
			       (ixcent - axmaj), (iycent - axmin),
			       wbox, hbox, 0, (360 * 64));
                  }
                  first  = FALSE;
                  axmaj = ix;
                  axmin = iy;
                  wbox = axmaj * 2;
                  hbox = axmin * 2;
                  XDrawArc (bsl_display, bsl_window[win], bsl_gc[win],
			    (ixcent - axmaj), (iycent - axmin),
			    wbox, hbox, 0, (360 * 64));
               }
            }
            break;
      }
   }
}

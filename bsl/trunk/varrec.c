/***********************************************************************
 *                         varrec.c                                    *
 ***********************************************************************
 Purpose: Create & move a variable size rectangle over an image and
          the coordinates of two opposite corners.
          Use of buttons:-
             1 - Varies the first pixel & raster coordinates.
             2 - Varies the last pixel & raster coordinates.
             3 - Terminates the selection.
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
#include "bslimage.h"

void variable_rectangle (npix, nrast, ifpix, ilpix, ifrast, ilrast)
int  npix,nrast;                         /* size of image                  */
int  *ifpix, *ilpix, *ifrast, *ilrast;   /* RETURNS coordinates of corners */

{
   XEvent event;
   int    first = TRUE;           /* first pass through routine */
   int    button;                 /* mouse button depressed     */
   int    boxwidth, boxheight;    /* size of selected rectangle */
   int    ipx, ipy, itemp;
   int    ifp, ilp, ifr, ilr;
   register int win;

   printf ("Button 1: Depress and move to select first  corner\n");
   printf ("Button 2: Depress and move to select second corner\n");
   printf ("Button 3: Click button to exit selection\n");

   win = current_win;

   XSelectInput (bsl_display, bsl_window[win], 
		 Button1MotionMask | Button2MotionMask | ButtonPressMask);

   ifp = 3 * npix  / 8;
   ifr = 3 * nrast / 8;
   ilp = 5 * npix  / 8;
   ilr = 5 * nrast / 8;
   boxwidth  = ilp - ifp + 1;
   boxheight = ilr - ifr + 1;

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
               if (ifp > ilp) SWAP (ifp, ilp);
               if (ifr > ilr) SWAP (ifr, ilr);
               XDrawRectangle (bsl_display, bsl_window[win], bsl_gc[win],
			       ifp, ifr, boxwidth, boxheight);
               *ifpix  = ++ifp;
               *ilpix  = ++ilp;
               *ifrast = ++ifr;
               *ilrast = ++ilr;
	       XSetFunction   (bsl_display, bsl_gc[win], GXcopy);
	       XSetPlaneMask (bsl_display, bsl_gc[win], AllPlanes);
               return;
            }
         case MotionNotify:
            if (button == 1)
            {
               ipx = event.xbutton.x;
               ipy = event.xbutton.y;
               if (ipx >= 0 && ipx < npix && ipy >= 0 && ipy < nrast)
               {
                  if (!first)
                     XDrawRectangle (bsl_display, bsl_window[win], bsl_gc[win],
				     ifp, ifr, boxwidth, boxheight);
                  first = FALSE;
                  ifp = ipx;
                  ifr = ipy;
                  boxwidth  = ilp - ifp + 1;
                  boxheight = ilr - ifr +1;
                  XDrawRectangle (bsl_display, bsl_window[win], bsl_gc[win],
				  ifp, ifr, boxwidth, boxheight);
               }
            }
            if (button == 2)
            {   
               ipx = event.xbutton.x;
               ipy = event.xbutton.y;
               if (ipx >= 0 && ipx < npix && ipy >= 0 && ipy < nrast)
               {
                  if (!first)
                     XDrawRectangle (bsl_display, bsl_window[win], bsl_gc[win],
				     ifp, ifr, boxwidth, boxheight);
                  first = FALSE;
                  ilp = ipx;
                  ilr = ipy;
                  boxwidth  = ilp - ifp + 1;
                  boxheight = ilr - ifr +1;
                  XDrawRectangle (bsl_display, bsl_window[win], bsl_gc[win],
				  ifp, ifr, boxwidth, boxheight);
               }
            }
            break;
      }
   }
}

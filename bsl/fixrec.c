/***********************************************************************
 *                        fixrec.c                                     *
 ***********************************************************************
 Purpose: Create & move a fixed size rectangle over an image and
          the coordinates of two opposite corners.
          Use of buttons:-
             1 - Varies the coordinates of top left corner of rectangle.
             2 - Varies the coordinates of top left corner of rectangle.
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

void fixed_rectangle (npix, nrast, wbox, hbox, ifpix, ifrast)
int  npix, nrast;           /* size of image                  */
int  wbox, hbox;            /* rectangle dimensions           */
int  *ifpix, *ifrast;       /* RETURNS coordinates of corner  */

{
   XEvent event;
   int    first = TRUE;           /* first pass through routine */
   int    button;                 /* mouse button depressed     */
   int    ipx, ipy, ifp, ifr;
   register int win;

   printf ("Button 1: Depress and move to position rectangle\n");
   printf ("Button 2: Depress and move to position rectangle\n");
   printf ("Button 3: Click button to exit selection\n");

   win = current_win;

   XSelectInput (bsl_display, bsl_window[win],
		 Button1MotionMask | Button2MotionMask | ButtonPressMask);

   ifp = (npix - wbox) / 2;
   ifr = (nrast - hbox) / 2;

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
               *ifpix  = ++ifp;
               *ifrast = ++ifr;
	       XSetFunction   (bsl_display, bsl_gc[win], GXcopy);
	       XSetPlaneMask (bsl_display, bsl_gc[win], AllPlanes);
               return;
            }
         case MotionNotify:
            if (button == 1 || button == 2)
            {
               ipx = event.xbutton.x;
               ipy = event.xbutton.y;
               if (ipx >= 0 && (ipx + wbox) < npix &&
                   ipy >= 0 && (ipy + hbox) < nrast)
               {
                  if (!first)
                     XDrawRectangle (bsl_display, bsl_window[win],
				     bsl_gc[win], ifp, ifr, wbox, hbox);
                  first = FALSE;
                  ifp = ipx;
                  ifr = ipy;
                  XDrawRectangle (bsl_display, bsl_window[win], bsl_gc[win],
				  ifp, ifr, wbox, hbox);
               }
            }
            break;
      }
   }
}

/***********************************************************************
 *                        parfil.c                                     *
 ***********************************************************************
 Purpose: Create & move a parallelogram an image and return a mask of
          1's & 0's.
          Use of buttons:-
             1 - Varies the position of 1st corner & length of 1 edge
             2 - Varies the opposite corner & adjoining edge
             3 - Terminates the selection.
 Authors: G.R.Mant
 Returns: Nil
 Updates: 03/08/89 Initial implementation

*/

#include <stdio.h>
#include <errno.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/Xos.h>
#include "bslimage.h"

void parallelogram_fill (mask, npix, nrast)

float mask[];                            /* mask buffer   */
int   npix,nrast;                         /* size of image */

{
   XEvent event;
   int    first = TRUE;           /* first pass through routine */
   int    button;                 /* mouse button depressed     */
   int    ix[5], iy[5];
   int    ipx, ipy, jpx, jpy;
   register int win;

   printf ("Button 1: Depress and move to select first  corner\n");
   printf ("Button 2: Depress and move to select opposite corner\n");
   printf ("Button 3: Click button to exit selection\n");

   win = current_win;

   XSelectInput (bsl_display, bsl_window[win],
		 Button1MotionMask | Button2MotionMask | ButtonPressMask);

   ix[0] = ix[1] = 3 * npix  / 8;
   iy[0] = iy[3] = 3 * nrast / 8;
   ix[2] = ix[3] = 5 * npix  / 8;
   iy[2] = iy[1] = 5 * nrast / 8;

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
               ix[4] = ix[0];
               iy[4] = iy[0];
               bitset (ix, iy, 5, mask, npix, nrast);
	       XSetFunction   (bsl_display, bsl_gc[win], GXcopy);
	       XSetPlaneMask (bsl_display, bsl_gc[win], AllPlanes);
               return;
            }
         case MotionNotify:
            if (button == 1)
            {
               ipx = event.xbutton.x;
               ipy = event.xbutton.y;
               jpx = ipx + ix[1] - ix[0];
               jpy = ipy + iy[1] - iy[0];
               if (ipx >= 0 && ipx < npix && ipy >= 0 && ipy < nrast &&
                   jpx >= 0 && jpx < npix && jpy >= 0 && jpy < nrast)
               {
                  if (!first)
                     XDrawPoly (bsl_display, bsl_window[win], bsl_gc[win],
				ix, iy, 4);
                  first = FALSE;
                  ix[1] = jpx;
                  iy[1] = jpy;
                  ix[0] = ipx;
                  iy[0] = ipy;
                  XDrawPoly (bsl_display, bsl_window[win], bsl_gc[win],
			     ix, iy, 4);
               }
            }
            if (button == 2)
            {   
               ipx = event.xbutton.x;
               ipy = event.xbutton.y;
               jpx = ipx + ix[0] - ix[3];
               jpy = ipy + iy[0] - iy[3];
               if (ipx >= 0 && ipx < npix && ipy >= 0 && ipy < nrast &&
                   jpx >= 0 && jpx < npix && jpy >= 0 && jpy < nrast)
               {
                  if (!first)
                     XDrawPoly (bsl_display, bsl_window[win], bsl_gc[win],
				ix, iy, 4);
                  first = FALSE;
                  ix[0] = jpx;
                  iy[0] = jpy;
                  ix[3] = ipx;
                  iy[3] = ipy;
                  XDrawPoly (bsl_display, bsl_window[win], bsl_gc[win],
			     ix, iy, 4);
               }
            }
            break;
      }
   }
}

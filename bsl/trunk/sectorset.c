/***********************************************************************
 **                       sectorset.c                                 **
 ***********************************************************************

 Purpose: Create & move a sector over an image and return coordinates
          Use of buttons:-
             1 - Adjust the starting angle and radius.
             2 - Adjust the finishing angle and radius.
       shift+1 - Will complete sector to starting point
       shift+2 - Will complete sector to finishing point
        ctrl+1 - Will adjust centre point
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

void DrawSector (Display *display, Window window, GC gc, int xcen, int ycen, 
int x1, int y1, int x2, int y2);

void sector_set (int *ixc, int *iyc, int *x1, int *y1, int *x2, int *y2)
{
	XEvent event;
	int button, x, y;
	double r, phi, dx, dy, xc, yc;
	static int call = 0;
	register int win;

	printf ("Button 1: Depress and move to starting angle and radius 1\n");
	printf ("Button 2: Depress and move to final angle and radius 2\n");
	printf ("Shift + Button 1: Will complete sector to starting point\n");
	printf ("Shift + Button 2: Will complete sector to final point\n");
	printf ("Ctrl + Button 1: Depress and move to adjust centre position\n");
	printf ("Button 3: Click button to exit selection\n");

	win = current_win;
	XSelectInput (bsl_display, bsl_window[win],
	    Button1MotionMask | Button2MotionMask | ButtonPressMask);
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
				switch (button)
				{
					case 1:
						if (event.xbutton.state & ShiftMask)
						{
							if (call)
								DrawSector (bsl_display, bsl_window[win], bsl_gc[win], *ixc, *iyc, 
						    				*x1, *y1, *x2, *y2);
							dx = (double) (*x2 - *ixc);
							dy = (double) (*iyc - *y2);
							r = sqrt (dx * dx + dy * dy);
							dx = (double) (*x1 - *ixc);
							dy = (double) (*iyc - *y1);
							phi = atan2 (dy, dx);
							*x2 = *ixc + (int) (r * cos (phi) + sin (phi));
							*y2 = *iyc - (int) (r * sin (phi) - cos (phi));
							DrawSector (bsl_display, bsl_window[win], bsl_gc[win], *ixc, *iyc, 
					    				*x1, *y1, *x2, *y2);
						}
						break;
					case 2:
						if (event.xbutton.state & ShiftMask)
						{
							if (call)
								DrawSector (bsl_display, bsl_window[win], bsl_gc[win], *ixc, *iyc, 
						    				*x1, *y1, *x2, *y2);
							dx = (double) (*x1 - *ixc);
							dy = (double) (*iyc - *y1);
							r = sqrt (dx * dx + dy * dy);
							dx = (double) (*x2 - *ixc);
							dy = (double) (*iyc - *y2);
							phi = atan2 (dy, dx);
							*x1 = *ixc + (int) (r * cos (phi) - sin (phi));
							*y1 = *iyc - (int) (r * sin (phi) + cos (phi));
							DrawSector (bsl_display, bsl_window[win], bsl_gc[win], *ixc, *iyc, 
					  				    *x1, *y1, *x2, *y2);
						}
						break;
					case 3:
						if (call)
							DrawSector (bsl_display, bsl_window[win], bsl_gc[win], *ixc, *iyc, 
						    			*x1, *y1, *x2, *y2);
						call = 0;
						XSetFunction   (bsl_display, bsl_gc[win], GXcopy);
						XSetPlaneMask (bsl_display, bsl_gc[win], AllPlanes);
						return;
					default:
						break;
				}
			case MotionNotify:
				do {
					x = event.xmotion.x;
					y = event.xmotion.y;
				} 
				while (XCheckTypedWindowEvent (bsl_display, bsl_window[win], MotionNotify, 
			    		&event));

				if (call) 
					DrawSector (bsl_display, bsl_window[win], bsl_gc[win], *ixc, *iyc, 
			    				*x1, *y1, *x2, *y2);

				switch (button)
				{
					case 1:
						if (event.xbutton.state & ControlMask)
						{
							*ixc = x;
							*iyc = y;
						}
						else if (!(event.xbutton.state & ShiftMask))
						{
							*x1 = x;
							*y1 = y;
						}
						break;
					case 2:
						if (!(event.xbutton.state & ShiftMask))
						{
							*x2 = x;
							*y2 = y;
						}
						break;
					default:
						break;
				}
				DrawSector (bsl_display, bsl_window[win], bsl_gc[win], *ixc, *iyc, 
			   				*x1, *y1, *x2, *y2);
			}
			call++;
	}
}

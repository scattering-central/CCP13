/***********************************************************************
 *                             getpoly.c                               *
 ***********************************************************************
 Purpose: Define a set of polygonal shapes using the cursor.
          Use of buttons:-
             1 - Accept this position and mark it (if the first point)
                 or else join it to the previous point.
             2 - Delete the previous point and continue.
             3 - Accept this as the last point of the polygon.
 Authors: G.R.Mant
 Returns: Nil
 Updates: 11/07/89 Initial implementation
          26/01/94 modified for use with FIX  (RCD)

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
#include "fixextern.h"

static void fpoint (int, int, int, int, int, int ,int, XPoint *);
static int fwidth (int, int, int, int, int, int);

int get_polygon (int *ipx, int *ipy, int *nvert, int maxvert, int npix, int nrast)

/*  int   ipx[], ipy[];                 selected x,y coordinates   */
/*  int   *nvert;                       number of vertices chosen  */
/*  int   maxvert;                      maximum number of vertices */
/*  int   npix, nrast;                  size of image              */

{
   XEvent event;
   int    first = TRUE;            /* first pass through routine */
   int    button;                  /* button selected            */
   int    ipoint;                  /* nos. of points selected    */
   int    xpt, ypt, ix, iy;        /* current coordinate         */
   int    bcount = -1;
   register int win;

/*     Don't need these prompts here
   printf ("Button 1: Depress and move to select points\n");
   printf ("Button 2: Click button to delete last point\n");
   printf ("Button 3: Click button to exit selection\n");
*/

   win = current_win;

   XSelectInput (bsl_display, bsl_window[win],
		 Button1MotionMask | ButtonPressMask | ButtonReleaseMask);

   XSetForeground (bsl_display, bsl_gc[win], 0xffffff);
   XSetFunction   (bsl_display, bsl_gc[win], GXxor);
   if (NColor == 128)
       XSetPlaneMask (bsl_display, bsl_gc[win], 0x7f);

   *nvert = ipoint = 0;
   while (1)
   {   
      XNextEvent (bsl_display, &event);
      switch (event.type)
      {
         case ButtonPress:
            bcount++;
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
               if (bcount)
                  XDrawLine (bsl_display, bsl_window[win], bsl_gc[win], ipx[0],
                             ipy[0], ipx[ipoint-1], ipy[ipoint-1]);
               XFlush (bsl_display);
               if (ipoint > 2)
                  *nvert = ipoint;
	       XSetFunction   (bsl_display, bsl_gc[win], GXcopy);
	       XSetPlaneMask (bsl_display, bsl_gc[win], AllPlanes);
	       return (bcount);
            }
            break;
	 case ButtonRelease:
            button = event.xbutton.button;
	    if (button == 1)
            {
	       if (ipoint >= maxvert)
	       {
		  printf ("Too many vertices!\n");
		  return (0);
	       }
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

/***********************************************************************
 *                         varlin.c                                    *
 ***********************************************************************
 Purpose: Create & move a variable size line over an image and
          the coordinates of two ends.
          Use of buttons:-
             1 - Varies the first pixel & raster coordinates.
             2 - Varies the last pixel & raster coordinates.
             3 - Terminates the selection.
 Authors: R.C.Denny
 Returns: Nil
 Updates: 18/01/94 Initial implementation

*/

int variable_line (int npix, int nrast, int *ifpix, int *ilpix, int *ifrast, int *ilrast)
/*  int npix,nrast;                          size of image                  */
/*  int *ifpix, *ilpix, *ifrast, *ilrast;    RETURNS coordinates of corners */

{
   XEvent event;
   int    first = TRUE;           /* first pass through routine */
   int    button;                 /* mouse button depressed     */
   int    ipx, ipy, itemp;
   int    ifp, ilp, ifr, ilr;
   int bcount = -1;
   register int win;

/*      Don't need these prompts here anymore
   printf ("Button 1: Depress and move to select beginning of line\n");
   printf ("Button 2: Depress and move to select end of line\n");
   printf ("Button 3: Click button to exit selection\n");
*/
   win = current_win;

   XSelectInput (bsl_display, bsl_window[win], 
		 Button1MotionMask | Button2MotionMask | ButtonPressMask);

   ifp = 3 * npix  / 8;
   ifr = 4 * nrast / 8;
   ilp = 5 * npix  / 8;
   ilr = 4 * nrast / 8;

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
            bcount++;
            button = event.xbutton.button;
            if (button == 3)
            {
               first = TRUE;
/* Leave the line there for now
               if (bcount)
                  XDrawLine (bsl_display, bsl_window[win], bsl_gc[win],
		             ifp, ifr, ilp, ilr);
*/
               *ifpix  = ifp;
               *ilpix  = ilp;
               *ifrast = ifr;
               *ilrast = ilr;
	       XSetFunction   (bsl_display, bsl_gc[win], GXcopy);
	       XSetPlaneMask (bsl_display, bsl_gc[win], AllPlanes);
               return (bcount);
            }
         case MotionNotify:
            if (button == 1)
            {
               ipx = event.xbutton.x;
               ipy = event.xbutton.y;
               if (ipx >= 0 && ipx < npix && ipy >= 0 && ipy < nrast)
               {
                  if (!first)
                     XDrawLine (bsl_display, bsl_window[win], bsl_gc[win],
			        ifp, ifr, ilp, ilr);
                  first = FALSE;
                  ifp = ipx;
                  ifr = ipy;
                  XDrawLine (bsl_display, bsl_window[win], bsl_gc[win],
			     ifp, ifr, ilp, ilr);
               }
            }
            if (button == 2)
            {   
               ipx = event.xbutton.x;
               ipy = event.xbutton.y;
               if (ipx >= 0 && ipx < npix && ipy >= 0 && ipy < nrast)
               {
                  if (!first)
                     XDrawLine (bsl_display, bsl_window[win], bsl_gc[win],
				     ifp, ifr, ilp, ilr);
                  first = FALSE;
                  ilp = ipx;
                  ilr = ipy;
                  XDrawLine (bsl_display, bsl_window[win], bsl_gc[win],
			     ifp, ifr, ilp, ilr);
               }
            }
            break;
      }
   }
}
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
          26/01/94 Modified for use with FIX  (RCD)

*/

int variable_rectangle (int npix, int nrast, int *ifpix, int *ilpix, int *ifrast, 
			int *ilrast)
/*  int npix,nrast;                          size of image                  */
/*  int *ifpix, *ilpix, *ifrast, *ilrast;    RETURNS coordinates of corners */

{
   XEvent event;
   int    first = TRUE;           /* first pass through routine */
   int    button;                 /* mouse button depressed     */
   int    boxwidth, boxheight;    /* size of selected rectangle */
   int    ipx, ipy, itemp;
   int    ifp, ilp, ifr, ilr;
   int    bcount = -1;
   register int win;

/*       Don't need these prompts here anymore
   printf ("Button 1: Depress and move to select first  corner\n");
   printf ("Button 2: Depress and move to select second corner\n");
   printf ("Button 3: Click button to exit selection\n");
*/

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
            bcount++;
            button = event.xbutton.button;
            if (button == 3)
            {
               first = TRUE;
               if (ifp > ilp) SWAP (ifp, ilp);
               if (ifr > ilr) SWAP (ifr, ilr);
               boxwidth  = ilp - ifp + 1;
               boxheight = ilr - ifr + 1;

/* This makes the rectangle disappear
               if (bcount)
                  XDrawRectangle (bsl_display, bsl_window[win], bsl_gc[win],
		       	          ifp, ifr, boxwidth, boxheight);
*/
               *ifpix  = ifp;
               *ilpix  = ilp;
               *ifrast = ifr;
               *ilrast = ilr;
	       XSetFunction   (bsl_display, bsl_gc[win], GXcopy);
	       XSetPlaneMask (bsl_display, bsl_gc[win], AllPlanes);
               return (bcount);
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
                  boxheight = ilr - ifr + 1;
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
/***********************************************************************
 *                         varrec2.c                                   *
 ***********************************************************************
 Purpose: Create & move a variable size rectangle over an image and
          the coordinates of two opposite corners. Now with adjustable
	  orientation.
          Use of buttons:
             1 - Varies the first pixel & raster coordinates of a line 
	         which bisects the rectangle.
             2 - Varies the last pixel & raster coordinates of a line
	         which bisects the rectangle.
      <shft> 1 - Varies width of rectangle.
             3 - Terminates the selection.
 Authors: G.R.Mant
 Returns: Nil
 Updates: 27/06/89 Initial implementation
          26/01/94 Modified for use with FIX  (RCD)
	  18/10/95 Modified for adjustable orientation to become 
	           varrec2.c

*/

int skew_rectangle (int npix, int nrast, int *ifpix, int *ilpix, int *ifrast, 
		    int *ilrast, int *width)
/* int npix,nrast;                          size of image                  */
/* int *ifpix, *ilpix, *ifrast, *ilrast;    RETURNS coordinates of bisecting line */
/* int *width                               RETURNS width of line          */

{
   XEvent event;
   int    first = TRUE;           /* first pass through routine */
   int    button;                 /* mouse button depressed     */
   int    state;
   int    boxwidth           ;    /* size of selected rectangle */
   int    ipx, ipy, itemp;
   int    ifp, ilp, ifr, ilr;
   XPoint points[5];
   int    bcount = -1;
   register int win;

/*       Don't need these prompts here anymore
   printf ("Button 1: Depress and move to select first  corner\n");
   printf ("Button 2: Depress and move to select second corner\n");
   printf ("Button 3: Click button to exit selection\n");
*/

   win = current_win;

   XSelectInput (bsl_display, bsl_window[win], 
		 Button1MotionMask | Button2MotionMask | ButtonPressMask);

/*
 * Assume horizontal orientation of rectangle so it's like a .VER in BSL
 */

   ifp = 2 * npix  / 8;
   ifr = 4 * nrast / 8;
   ilp = 6 * npix  / 8;
   ilr = 4 * nrast / 8;
   boxwidth  = 10;

   fpoint (npix, nrast, ifp, ilp, ifr, ilr, boxwidth, points);

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
            bcount++;
            button = event.xbutton.button;
	    state = event.xbutton.state;
            if (button == 3)
            {
               first = TRUE;

/* This makes the rectangle disappear
               if (bcount)
	          XDrawLines (bsl_display, bsl_window[win], bsl_gc[win],
	                      points, 5, CoordModeOrigin);
*/
               *ifpix  = ifp;
               *ilpix  = ilp;
               *ifrast = ifr;
               *ilrast = ilr;
	       *width = boxwidth;
	       XSetFunction   (bsl_display, bsl_gc[win], GXcopy);
	       XSetPlaneMask (bsl_display, bsl_gc[win], AllPlanes);
               return (bcount);
            }
         case MotionNotify:
            if (button == 1)
            {
               ipx = event.xbutton.x;
               ipy = event.xbutton.y;
               if (ipx >= 0 && ipx < npix && ipy >= 0 && ipy < nrast)
               {
                  if (!first)
                     XDrawLines (bsl_display, bsl_window[win], bsl_gc[win],
				 points, 5, CoordModeOrigin);
                  first = FALSE;
		  if (state & ShiftMask)
		    {
		      boxwidth = fwidth (ifp, ilp, ifr, ilr, ipx, ipy);
		    }
		  else
		    {
		      ifp = ipx;
		      ifr = ipy;
		    }
		  fpoint (npix, nrast, ifp, ilp, ifr, ilr, boxwidth, points);
	
		  XDrawLines (bsl_display, bsl_window[win], bsl_gc[win],
			      points, 5, CoordModeOrigin);
               }
            }
            if (button == 2)
            {   
               ipx = event.xbutton.x;
               ipy = event.xbutton.y;
               if (ipx >= 0 && ipx < npix && ipy >= 0 && ipy < nrast)
               {
                  if (!first)
		    XDrawLines (bsl_display, bsl_window[win], bsl_gc[win],
				points, 5, CoordModeOrigin);
                  first = FALSE;
                  ilp = ipx;
                  ilr = ipy;
		  fpoint (npix, nrast, ifp, ilp, ifr, ilr, boxwidth, points);
	
		  XDrawLines (bsl_display, bsl_window[win], bsl_gc[win],
			      points, 5, CoordModeOrigin);
               }
            }
            break;
      }
   }
}

static void fpoint (int npix, int nrast, int ifp, int ilp, int ifr, int ilr,
		    int boxwidth, XPoint *points)
{
  int hit_limit = 0;
  float dx, dy, length;
  int idx, idy;
  short int ix[4], iy[4];
  int i;

  dx = (float) (ilp - ifp);
  dy = (float) (ilr - ifr);
  length = (float) sqrt (dx * dx + dy * dy);


  if (length > 0.0)
    {
      idx = (int) ((float) boxwidth * dy / length);
      idy = (int) ((float) boxwidth * dx / length);
    }
  else
    {
      idx = 0;
      idy = 0;
    }

  ix[0] = ifp + idx; iy[0] = ifr - idy;
  ix[1] = ilp + idx; iy[1] = ilr - idy;
  ix[2] = ilp - idx; iy[2] = ilr + idy;
  ix[3] = ifp - idx; iy[3] = ifr + idy;

  for (i=0; i<4; i++)
    {
      if (ix[i] < 0 || ix[i] >= npix || iy[i] < 0 || iy[i] >= nrast)
	{
	  hit_limit = 1;
	}
    }
  if (!hit_limit)
    {
      for (i=0; i<4; i++)
	{
	  points[i].x = ix[i];
	  points[i].y = iy[i];
	}
      points[4].x = points[0].x; points[4].y = points[0].y;
    }
  return;
}

static int fwidth (int ifp, int ilp, int ifr, int ilr, int ipx, int ipy)
{
  float m, c, dx, dy, u, v;
  int itemp;


  if ((ilp - ifp) == 0)
    {
      SWAP (ifp, ifr);
      SWAP (ilp, ilr);
      SWAP (ipx, ipy);
    }

  if ((ilp - ifp) == 0)
    {
      return (0);
    }

  dx = (float) (ilp - ifp);
  dy = (float) (ilr - ifr);
  u = (float) (ilp + ifp);
  v = (float) (ilr + ifr);

  m = dy / dx;
  c = (v - m * u) / 2.0;

  u = (float) ipx;
  v = (float) ipy;

  dx = (u + m*(v - c))/(1 + m*m);
  dy = v - m*dx - c;
  dx = u - dx;

  return ((int) sqrt (dx*dx + dy*dy));
}

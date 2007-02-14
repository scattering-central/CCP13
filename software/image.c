/*******************************************************************************
 *                                 fix_image.c                                 *
 *******************************************************************************
 Purpose: Provides the C/X11 interface for FIX
 Author:  R.C.Denny
 Returns: Nil
 Updates: 
 16/10/95 RCD Initial implementation

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
#include <X11/cursorfont.h>
#include <math.h>
#include "fiximage.h"
#include "fixcursor"
#include "fixmask"

static void box (float *, int, int);
static void close_window (int *, int);
static void list ();
static void point();
static void line ();
static void rectangle ();
static void polygon ();
static void convert_data (int *, int *, int *, int *);
static void select_palette ();
static void gray_palette ();
static void colour_palette1 ();
static void colour_palette2 ();
static void colour_palette3 ();
static void psout ();
static void thresholds ();
static void thickline ();
static void refresh ();

typedef struct                    /* Structure for storing data points */
{
   int win;                       /* Window this data point came from  */
   int npts;                      /* Number of image points in this data point */
   int xpts [MAXVERT], 
       ypts [MAXVERT];            /* X,Y arrays storing image space coordinates */
   int width;                     /* Width of line */
} DataPoint;

static XStandardColormap def_map_info;
static Colormap cmap;
static DataPoint data [MAXDAT];
static int default_visual = TRUE;
static int Opened = 0;
static int Colour_freed = 1;
static int shift;

/*******************************************************************************
 *                                  image.c                                    *
 *******************************************************************************
 Purpose: Displays file, reads command line input and calls the appropriate 
          routines. Fortran callable.
 Author:  R.C.Denny
 Returns: Nil
 Updates:
 18/01/94 RCD Initial implementation

*/

void IMAGE (void **vbuff, int *npixpt, int *nrastpt, int *npts, int *fxpts, 
	    int *fypts, int *fwidth, int *init)
{
   float *buf = (float *) *vbuff;
   static int count = 0;
   XEvent event;
   XVisualInfo vinfo;
   Visual *defaultVisual;
   long VisualMask = VisualClassMask | VisualScreenMask | VisualDepthMask;
   int cursor_shape = XC_dotbox;
   unsigned long plane_masks[1];
   DataPoint *dptr;
   char *display_name = NULL;
   char message[80];
   int npix, nrast, nxwid, nywid;
   long offset;
   int nwrd, nval, item [NUMWRD + NUMVAL];
   int cwin [MAXWIN];
   int i, j, nrd;
   int next = 1;
   int nvisuals = 0;
   int ndirect = 0;
   float vals [NUMVAL];
   char *wrdpp [NUMWRD], *wrdptr;
   static char *visual_class[] =
   {
     "StaticGray",
     "GrayScale",
     "StaticColor",
     "PseudoColor",
     "TrueColor",
     "DirectColor"
   };
   static XColor black, black_def, white, white_def;
   Pixmap fixcursor, fixmask;
/*
 * Set up options list
 */
   static char *optionpp [] = 
   {
/* 1  */    "BOX",                 /* Select a rectangle on an image */
/* 2  */    "CLOSE",               /* Close selected window          */
/* 3  */    "LIST",                /* List point buffer              */
/* 4  */    "POINT",               /* Set input option to point      */ 
/* 5  */    "LINE",                /* Set input option to line       */
/* 6  */    "RECTANGLE",           /* Set input option to rectangle  */
/* 7  */    "POLYGON",             /* Set input option to polygon    */
/* 8  */    "FIX",                 /* Return to FIX                  */
/* 9  */    "PALETTE",             /* Adjust palette                 */
/*10  */    "POSTSCRIPT",          /* Postscript ouput               */
/*11  */    "THRESHOLDS",          /* Change display thresholds      */
/*12  */    "THICKLINE",           /* Set input option to thick line */
/*13  */    "REFRESH",             /* Refresh all windows            */
            ""                     /* Option list terminator         */
   };
/*
 * Do initialization of X stuff
 */
   if (!Opened)
   {
      if (!(bsl_display = XOpenDisplay (display_name)))
      {   
	 sprintf (message, "Error: Cannot connect to X Server %s\n",
		  XDisplayName (display_name));
	 errmsg (message);
	 return;
      }
      Opened = TRUE;

/* Debugging */
      XSynchronize (bsl_display, (int) 1);
 
      current_win = -1;
      NColor = MAXCOLOR;
      offset = 0;
      bitmap_pad = 8*sizeof (DATA_TYPE);
      bits_per_pixel = bitmap_pad;
/*
 * Get visual information for default visual
 */
      screen = DefaultScreen (bsl_display);
      screen_depth =  DefaultDepth (bsl_display, screen);
      defaultVisual = DefaultVisual (bsl_display, screen);
      vinfo.screen = screen;
      vinfo.class  = defaultVisual->class;
      vinfo.depth  = screen_depth;
      visualList = XGetVisualInfo (bsl_display, VisualMask, &vinfo, &nvisuals);   
      visualList->visual = defaultVisual;
      printf ("Visual class = %s \n", visual_class [visualList->class]);
/*
 * Use default visual with read-only colour map
 */
      cmap = DefaultColormap (bsl_display, screen);
      XInstallColormap (bsl_display, cmap);
/*
 * Set up cursor from bitmap files
 */
      if (!XAllocNamedColor (bsl_display, cmap, "black", &black, &black_def) ||
	  !XAllocNamedColor (bsl_display, cmap, "white", &white, &white_def))
	{
	  printf ("Don't know what black and white are\n");
	}
      fixcursor = XCreatePixmapFromBitmapData (bsl_display, 
					       RootWindow (bsl_display, screen),
					       fixcursor_bits, 16, 16,
					       1, 0, 1);
      fixmask = XCreatePixmapFromBitmapData (bsl_display, 
					     RootWindow (bsl_display, screen),
					     fixmask_bits, 16, 16,
					     1, 0, 1);

      if (!(cursor = XCreatePixmapCursor (bsl_display, fixcursor, fixmask, 
					  &black, &white, 7, 7)))
	{
	  printf ("Couldn't create cursor\n");
	  cursor = XCreateFontCursor (bsl_display, cursor_shape);
	}
      XFreePixmap (bsl_display, fixcursor);
      XFreePixmap (bsl_display, fixmask);
/*
 * Set common window attributes
 */
      attributes.background_pixel = 0x0;
      attributes.border_pixel = 0xe0;
      attributes.colormap = cmap;
      attributes.backing_store = WhenMapped;
/*
 * Set shift for grayscale RGB values
 */
      if (NColor > 128)
         shift = 8;
      else 
         shift = 9;
/*
 * Set up grayscale palette
 */
      gray_palette ();
      Colour_freed = 0;

   } /* End of X initializations */

   if (Colour_freed)
     {
       XInstallColormap (bsl_display, cmap);
       Colour_freed = 0;
     }

   nxwid = npix = *npixpt;
   nywid = nrast = *nrastpt;
   offset = 0;
   dptr = data;
   for (i=0; i<MAXDAT; i++,dptr++)
   {
      dptr->npts = 0; 
      for (j=0; j<MAXVERT; j++)
      {
         dptr->xpts [j] = 0;
         dptr->ypts [j] = 0;
      }
   }
/*
 * Display image of whole file
 */
   if (*init)
      if (!file_to_image (buf, npix, nrast, nxwid, nywid, offset))
	 return;
      else
	 *init = 0;

   while (next)
   {
/*
 * Watch out for exposure events
 */
      for (i=0; i<MAXWIN; i++)
	 if (bsl_window [i] != 0)
	    XSelectInput (bsl_display, bsl_window [i], ExposureMask); 
/*
 * Read command line input
 */
      printf ("image> ");
      if (!(nrd = rdcomc (stdin, wrdpp, &nwrd, vals, &nval, item, NUMWRD, 
			  NUMVAL)))
	 printf ("Error reading input\n");
      else if (nrd < 0)
      {
	 convert_data (npts, fxpts, fypts, fwidth);
	 next = 0;
      } 

      if (nwrd > 0)
      {
	 wrdptr = wrdpp [0];
         (void) upc (wrdptr);
/*
 * Switch for options
 */
	 switch (optcmp (wrdptr, optionpp))
	 {
         case -1:
            printf ("Ambiguous command\n");
            break;

         case 0:
            printf ("No matching command\n");
            break;

         case 1:
            box (buf, npix, nrast);
            break;
 
         case 2:
	    for (i=0; i<nval; i++)
	       cwin [i] = (int) vals [i];
            close_window (cwin, nval);
            break;

         case 3:
            list ();
            break;

         case 4:
            point ();
            break;

         case 5:
            line ();
            break;
 
         case 6:
            rectangle ();
            break;

         case 7:
            polygon ();
            break;
 
         case 8:
	    convert_data (npts, fxpts, fypts, fwidth);
            next = 0;
	    break;
 
         case 9:
            select_palette ();
	    break;

	 case 10:
	    psout ();
	    break;

	 case 11:
	    thresholds ();
	    break;

	 case 12:
	    thickline ();
	    break;

	 case 13:
	    refresh ();
	    break;
	 }
/*
 * Free memory allocated in rdcomc for character arrays
 */
	 for (i=0; i<nwrd; i++)
            (void) free (wrdpp [i]);
      }
      else
         if (next)
         {
            printf ("Allowed  keywords...\n");
            i = 0;
            while (*optionpp [i] != '\0')
               printf ("   %s\n",optionpp [i++]);
         }
/*
 * Process expose events
 */
      XSync (bsl_display, 0);
      for (i=0; i<MAXWIN; i++)
	 if (bsl_window [i] != 0)
	 {
	    if (XCheckWindowEvent (bsl_display, bsl_window [i], ExposureMask, 
				   &event)) 
	       XPutImage (bsl_display ,bsl_window [i], bsl_gc [i], xi [i], 0, 0, 
			  0, 0, xi[i]->width, xi[i]->height);
	 }
   }

   return;
}

/*******************************************************************************
 *                                  box.c                                      *
 *******************************************************************************
 Purpose: Allows the user to draw a rectangle in a selected window. Data
          corresponding to this region are then mapped onto the whole of
          new or existing window 
 Author:  R.C.Denny
 Returns: Nil
 Updates:
 21/01/94 RCD Initial implementation

*/
  
static void box (float *buf, int npix, int nrast)
{
   int nw = 0, got_event = 0;
   XEvent event;
   int i, win, ipix, irast, offset, width, height, np; 
   int ifp, ilp, ifr, ilr;
   int ixp [2], iyp [2], fxp [2], fyp [2];
/*
 * Check how many image windows are open
 */
   for (i=0; i<MAXWIN; i++)
      if (bsl_window [i] > 0)
         nw++;   
   
   if (!nw)
   {
      printf ("No windows available\n");
      return;
   }
/*
 * Print instructions
 */
   printf (" Button 1: Depress and move to select first  corner\n");
   printf (" Button 2: Depress and move to select second corner\n");
   printf (" Button 3: Click button to exit selection\n");
/*
 * Check for exposure events
 */
   XSync (bsl_display, 0);
   for (i=0; i<MAXWIN; i++)
      if (bsl_window [i] != 0) 
      {
	 if (XCheckWindowEvent (bsl_display, bsl_window [i], ExposureMask, 
				&event))
	 {
	    ipix = xi [i]->width;
	    irast = xi [i]->height;
	    XPutImage (bsl_display, bsl_window [i], bsl_gc [i], xi [i], 0, 0, 0, 
                       0, ipix, irast);
	 }
     }
/*
 * Now check for buttonpress events
 */
   while (!got_event)
      for (i=0; i<MAXWIN; i++)
      {
	 if (bsl_window [i] != 0)
	 {
	    XSelectInput (bsl_display, bsl_window [i], ButtonPressMask | 
			  OwnerGrabButtonMask);
            if (XCheckWindowEvent (bsl_display, bsl_window [i], ButtonPressMask, 
				   &event))
	    {
	       got_event = 1;
	       win = current_win = i;
	       ipix = xi [i]->width;
	       irast = xi [i]->height;
	       XPutBackEvent (bsl_display, &event);
	       break;
	    }
         }
      }
/*
 * Get rectangle from chosen window
 */
   if (!variable_rectangle (ipix, irast, &ifp, &ilp, &ifr, &ilr))
      return;
   ixp [0] = ifp;
   iyp [0] = ifr;
   ixp [1] = ilp;
   iyp [1] = ilr;
   np = 2;
/*
 * Scale image points to filespace
 */
   (void) image_to_file_coords (ixp, iyp, np, win, fxp, fyp);
   offset = npix * fyp [0] + fxp [0];
   width = fxp [1] - fxp [0] + 1;
   height = fyp [1] - fyp [0] + 1;
   printf ("Box: width %d,  height %d,  offset %d\n", width, height, offset);
/*
 * Display image
 */
   if (!file_to_image (buf, npix, nrast, width, height, offset))
   {
      printf ("Error displaying image\n");
      return;
   }
   return;
}

/*******************************************************************************
 *                                close.c                                      *
 *******************************************************************************
 Purpose: Closes an image window and reinitializes the necessary
          variables  
 Author:  R.C.Denny
 Returns: Nil
 Updates:
 21/01/94 RCD Initial implementation

*/

static void close_window (int *cwin, int ncw)
{
   int i, nw, nv, irc;
   char *wrdpp [1];
   float vals [MAXWIN];
   int item [MAXWIN];

   if (!ncw)
   {
      printf ("Enter window numbers to be closed: ");
      if ((irc = rdcomc (wrdpp, &nw, vals, &nv, item, 0, MAXWIN)) <= 0)
	 return;
      else
	 for (i=0; i<nv; i++)
	    cwin [i] = (int) vals [i];
   }
   else
      nv = ncw;
/*
 * Close windows
 */
   for (i=0; i<nv; i++,cwin++)
   {
      if (!bsl_window [*cwin])
      	 printf ("Invalid window number %d\n", *cwin);
      else
      {
	 printf ("Closing FIX%d...\n", *cwin);
	 XDestroyImage (xi [*cwin]);
	 XDestroyWindow (bsl_display, bsl_window [*cwin]);
	 bsl_window [*cwin] = 0;
         free (buff [*cwin]);
      }
   }
   return;
}

/*******************************************************************************
 *                                   list.c                                    *
 *******************************************************************************
 Purpose: Lists the points held in the point buffer and allows deletions
 Author:  R.C.Denny
 Returns: 
 Updates:
 25/01/94 RCD Initial implementation

*/

static void list ()
{
   int edit = 1, ndata = 0;
   int i, j, np, nd1, nd2, dif, nd;
   char termbuf [MAXTERM];
   DataPoint *dptr;
   static char *datatype [] =
   {
      "point",
      "line",
      "polygon"
   };

   while (edit)
   {
/*
 * List data
 */
      i = 0;
      dptr = data;
      if (!dptr->npts)
         return;
      printf ("\nNumber     Type          Window      X_image      Y_image\n");
      while (np = dptr->npts)
      {
	 printf ("%4d       %-7s       %4d        %5d        %5d\n", 
	         ++i, datatype [MIN((dptr->npts - 1),2)], dptr->win, 
	         dptr->xpts [0], dptr->ypts [0]);
	 for (j=1; j < np; j++)
	    printf ("                                     %5d        %5d\n",
		    dptr->xpts [j], dptr->ypts [j]);
         ndata++;
	 dptr++;
      }
/*
 * Allow deletion of selected data
 */
      printf ("\nDelete data in range [0,0]: ");
      fgets (termbuf, MAXTERM, stdin);
      if (feof (stdin))
      {
	 clearerr (stdin);
	 printf ("\n");
	 return;
      }
      else
      {
	 nd1 = 0;
	 j = 0;
	 while (termbuf [j] != '\0')
	    if (termbuf [j++] == ',')
	       termbuf [j-1] = ' ';
	 nd = sscanf (termbuf, "%d%d", &nd1, &nd2);
	 if (!nd || !nd1)
	     return;
      }

      if (nd < 2)
	 nd2 = nd1;
      dif = nd2 - nd1 + 1;
      for (i=nd1-1; i<ndata; i++)
      {
	 if (i+dif > ndata)
	    data [i].npts = 0;
	 else
      	    if (data [i].npts = data [i+dif].npts)
	    {
	       data [i].win = data [i+dif].win;
	       for (j=0; j<MAXVERT; j++)
	       {
		  data [i].xpts [j] = data [i+dif].xpts [j];
		  data [i].ypts [j] = data [i+dif].ypts [j];
	       }
	    }
      }
      if(i < MAXDAT-1)
         data [i].npts = 0;
   }
}

/*******************************************************************************
 *                                  point.c                                    *
 *******************************************************************************
 Purpose: Allow the user to select points from the chosen window and record them
          in the data buffer.
 Author:  R.C.Denny
 Returns: 
 Updates:
 25/01/94 RCD Initial implementation

*/

static void point ()
{
   int ndata = 0, got_event = 0;
   int i, ipix, irast, button, ipx, ipy;
   XEvent event;
   DataPoint *dptr = data;
/*
 * Count along to end of data buffer
 */
   while (dptr->npts > 0)
   {
      dptr++;
      ndata++;
   }
/*
 * Print instructions
 */
   printf (" Button 1: Click button to select points\n");
   printf (" Button 2: \n");
   printf (" Button 3: Click button to exit selection\n");
/*
 * Check for exposure events
 */
   XSync (bsl_display, 0);
   for (i=0; i<MAXWIN; i++)
      if (bsl_window [i] != 0)
      {
	 if (XCheckWindowEvent (bsl_display, bsl_window [i], ExposureMask, 
				&event))
	 {
	    ipix = xi [i]->width;
	    irast = xi [i]->height;
	    XPutImage (bsl_display, bsl_window [i], bsl_gc [i], xi [i], 0, 0, 0, 
		       0, ipix, irast);
	 }
      }
/*
 * Now check for buttonpress events
 */
   while (!got_event)
      for (i=0; i<MAXWIN; i++)
      {
	 if (bsl_window [i] != 0)
	 {
	    XSelectInput (bsl_display, bsl_window [i], ButtonPressMask | 
			  OwnerGrabButtonMask);
            if (XCheckWindowEvent (bsl_display, bsl_window [i], ButtonPressMask, 
				   &event))
	    {
	       got_event = 1;
	       current_win = i;
	       ipix = xi [i]->width;
	       irast = xi [i]->height;
	       XPutBackEvent (bsl_display, &event);
	       break;
	    }
         }
      }

   XSelectInput (bsl_display, bsl_window [i], ButtonPressMask);
   XSetForeground (bsl_display, bsl_gc [i], 0xffffff);
   XSetFunction (bsl_display, bsl_gc [i], GXxor);
   if (NColor == 128)
      XSetPlaneMask (bsl_display, bsl_gc [i], 0x7f);
   while (ndata < MAXDAT)
   {
      XNextEvent (bsl_display, &event);
      if (event.type == ButtonPress)
      {
         button = event.xbutton.button;
         if (button == 3)
         {
            XSetFunction (bsl_display, bsl_gc [i], GXcopy);
            XSetPlaneMask (bsl_display, bsl_gc [i], AllPlanes);
            if (ndata < MAXDAT)
                dptr->npts = 0;
            return;
	 }
	 if (button == 1)
	 {
	    ipx = event.xbutton.x;
	    ipy = event.xbutton.y;
	    if (ipx >= 0 && ipx < ipix && ipy >= 0 && ipy < irast)
	    {
	       XfDrawPlus (bsl_display, bsl_window [i], bsl_gc [i], &ipx, &ipy, 
			   1, 5);
	       dptr->npts = 1;
	       dptr->win = i;
	       dptr->xpts [0] = ipx;
	       dptr->ypts [0] = ipy;
	       dptr++;
               ndata++;
	    }
	 }
      }
   }  
   printf ("Too much data!\n");
   return;
}

/*******************************************************************************
 *                                   line.c                                    *
 *******************************************************************************
 Purpose: Allow user to select a line from chosen window and store the end 
          coordinates in the data buffer.
 Author:  R.C.Denny
 Returns: 
 Updates:
 26/01/94 RCD Initial implementation

*/

static void line ()
{
   int ndata = 0, got_event = 0, cont = 1;
   int i, ipix, irast, ifp, ilp, ifr, ilr;
   XEvent event;
   DataPoint *dptr = data;

/*
 * Count along to end of data buffer
 */
   while (dptr->npts > 0)
   {
      dptr++;
      ndata++;
   }
/*
 * Print instructions
 */
   printf (" Button 1: Depress and move to select beginning of line\n");
   printf (" Button 2: Depress and move to select end of line\n");
   printf (" Button 3: Click to exit selection\n");
/*
 * Check for exposure events
 */
   XSync (bsl_display, 0);
   for (i=0; i<MAXWIN; i++)
      if (bsl_window [i] != 0)
      {
	 if (XCheckWindowEvent (bsl_display, bsl_window [i], ExposureMask, 
				&event))
	 {
	    ipix = xi [i]->width;
	    irast = xi [i]->height;
	    XPutImage (bsl_display, bsl_window [i], bsl_gc [i], xi [i], 0, 0, 0, 
		       0, ipix, irast);
	 }
      }
/*
 * Now check for buttonpress events
 */
   while (!got_event)
      for (i=0; i<MAXWIN; i++)
      {
	 if (bsl_window [i] != 0)
	 {
	    XSelectInput (bsl_display, bsl_window [i], ButtonPressMask | 
			  OwnerGrabButtonMask);
            if (XCheckWindowEvent (bsl_display, bsl_window [i], ButtonPressMask, 
				   &event))
	    {
	       got_event = 1;
	       current_win = i;
	       ipix = xi [i]->width;
	       irast = xi [i]->height;
	       XPutBackEvent (bsl_display, &event);
	       break;
	    }
         }
      } 

   while (cont)
   {
      if (!variable_line (ipix, irast, &ifp, &ilp, &ifr, &ilr))
         return;
      if (ndata++ < MAXDAT)
      {
         dptr->npts = 2;
         dptr->win = i;
         dptr->xpts [0] = ifp;
         dptr->xpts [1] = ilp;
         dptr->ypts [0] = ifr;
         dptr->ypts [1] = ilr;
	 dptr->width = 0;
         dptr++;
         if (ndata < MAXDAT)
            dptr->npts = 0;
      }
      else
      {
         printf ("Too much data!\n");
         return;
      }
   }

}

/*******************************************************************************
 *                                 rectangle.c                                 *
 *******************************************************************************
 Purpose: Select a rectangle from chosen window and store the four 
          corners in the data buffer.
 Author:  R.C.Denny
 Returns: 
 Updates:
 26/01/94 RCD Initial implementation

*/

static void rectangle ()
{
   int ndata = 0, got_event = 0, cont = 1;
   int i, ifp, ilp, ifr, ilr, ipix, irast;
   XEvent event;
   DataPoint *dptr = data;
/*
 * Count along to end of data buffer
 */
   while (dptr->npts > 0)
   {
      dptr++;
      ndata++;
   }
/*
 * Print instructions
 */
   printf (" Button 1: Depress and move to select first  corner\n");
   printf (" Button 2: Depress and move to select second corner\n");
   printf (" Button 3: Click button to exit selection\n");
/*
 * Check for exposure events
 */
   XSync (bsl_display, 0);
   for (i=0; i<MAXWIN; i++)
      if (bsl_window [i] != 0)
      {
	 if (XCheckWindowEvent (bsl_display, bsl_window [i], ExposureMask, 
				&event))
	 {
	    ipix = xi [i]->width;
	    irast = xi [i]->height;
	    XPutImage (bsl_display, bsl_window [i], bsl_gc [i], xi [i], 0, 0, 0, 
		       0, ipix, irast);
	 }
      }
/*
 * Now check for buttonpress events
 */
   while (!got_event)
      for (i=0; i<MAXWIN; i++)
      {
	 if (bsl_window [i] != 0)
	 {
	    XSelectInput (bsl_display, bsl_window [i], ButtonPressMask | 
			  OwnerGrabButtonMask);
            if (XCheckWindowEvent (bsl_display, bsl_window [i], ButtonPressMask, 
				   &event))
	    {
	       got_event = 1;
	       current_win = i;
	       ipix = xi [i]->width;
	       irast = xi [i]->height;
	       XPutBackEvent (bsl_display, &event);
	       break;
	    }
         }
      }  

   while (cont)
   {
      if (!variable_rectangle (ipix, irast, &ifp, &ilp, &ifr, &ilr))
         return;
      if (ndata++ < MAXDAT)
      {
         dptr->npts = 4;
         dptr->win = i;
         dptr->xpts [0] = ifp;
         dptr->ypts [0] = ifr;
         dptr->xpts [1] = ilp;
         dptr->ypts [1] = ifr;
         dptr->xpts [2] = ilp;
         dptr->ypts [2] = ilr;
         dptr->xpts [3] = ifp;
         dptr->ypts [3] = ilr;
         dptr++;
         if (ndata < MAXDAT)
            dptr->npts = 0;
      }
      else
      {
         printf ("Too much data!\n");
         return;
      }
   }

}
/*******************************************************************************
 *                                   polygon.c                                 *
 *******************************************************************************
 Purpose: Select a set of polygons from the chosen window and store the vertices
          in the data buffer.
 Author:  R.C.Denny
 Returns: 
 Updates:
 26/01/94 RCD Initial implementation

*/

static void polygon ()
{
   int ndata = 0, got_event = 0, cont = 1;
   int i, j, nvert, ipix, irast;
   int ipx [MAXVERT], ipy [MAXVERT];
   XEvent event;
   DataPoint *dptr = data;
/*
 * Count along to end of data buffer
 */
   while (dptr->npts > 0)
   {
      dptr++;
      ndata++;
   }
/*
 * Print instructions
 */
   printf (" Button 1: Depress and move to select points\n");
   printf (" Button 2: Click button to delete last point\n");
   printf (" Button 3: Click button to exit selection\n");
/*
 * Check for exposure events
 */
   XSync (bsl_display, 0);
   for (i=0; i<MAXWIN; i++)
      if (bsl_window [i] != 0)
      {
	 if (XCheckWindowEvent (bsl_display, bsl_window [i], ExposureMask, 
				&event))
	 {
	    ipix = xi [i]->width;
	    irast = xi [i]->height;
	    XPutImage (bsl_display, bsl_window [i], bsl_gc [i], xi [i], 0, 0, 0, 
		       0, ipix, irast);
	 }
      }
/*
 * Now check for buttonpress events
 */
   while (!got_event)
      for (i=0; i<MAXWIN; i++)
      {
	 if (bsl_window [i] != 0)
	 {
	    XSelectInput (bsl_display, bsl_window [i], ButtonPressMask | 
			  OwnerGrabButtonMask);
            if (XCheckWindowEvent (bsl_display, bsl_window [i], ButtonPressMask, 
				   &event))
	    {
	       got_event = 1;
	       current_win = i;
	       ipix = xi [i]->width;
	       irast = xi [i]->height;
	       XPutBackEvent (bsl_display, &event);
	       break;
	    }
         }
      }

   while (cont)
   {
      if (!get_polygon (ipx, ipy, &nvert, MAXVERT, ipix, irast))
         return;
      if (ndata++ < MAXDAT)
      {
         dptr->npts = nvert;
         dptr->win = i;
         for (j=0; j<nvert; j++)
         {
            dptr->xpts [j] = ipx [j];
            dptr->ypts [j] = ipy [j];
         }
         dptr++;
         if (ndata < MAXDAT)
             dptr->npts = 0;
      }
      else
      {
         printf ("Too much data!\n");
         return;
      }
   }

}

/*******************************************************************************
 *                               convert_data.c                                *
 *******************************************************************************
 Purpose: Convert the data structure array into arrays suitable for FORTRAN
 Author:  R.C.Denny
 Returns: 
 Updates:
 26/01/94 RCD Initial implementation

*/

static void convert_data (int *npts, int *fxpts, int *fypts, int *fwidth)
{
   DataPoint *dptr = data;

   while (*npts = dptr->npts)
   {
      (void) image_to_file_coords (dptr->xpts, dptr->ypts, dptr->npts, dptr->win, 
				   fxpts, fypts);
      if (*npts == 2)
	{
	  *fwidth++ = i2f_scale (dptr->width, dptr->win);
	}
      fxpts += *npts;
      fypts += *npts++;
      dptr++;
   }
   return;
}

/*******************************************************************************
 *                               select_palette.c                               *
 *******************************************************************************
 Purpose: Allows setting of grayscale or colour palette, inverts palette. 
 Author:  R.C.Denny
 Returns: Nil
 Updates:
 08/03/94 RCD Initial implementation
*/

static void select_palette ()
{
  int got_event = 0;
  float x, xstep;
  int i, ipix, irast;
  XEvent event;
  DATA_TYPE *cptr, *bptr;
  int button = 0, state = 0;
  unsigned long temp;
/*
 * Print instructions
 */
  printf (" Button 1: grayscale palette   + <Shift>: Thomas palette\n");
  printf (" Button 2: invert palette      + <Shift>: colour palette 2\n");  
  printf (" Button 3: exit palette        + <Shift>: colour palette 3\n");

  while (1)
    {
/*
 * Check for exposure events
 */
      XSync (bsl_display, 0);
      for (i=0; i<MAXWIN; i++)
	if (bsl_window[i] != 0)
	  {
	    if (XCheckWindowEvent (bsl_display, bsl_window[i], ExposureMask, 
				   &event))
	      {
		ipix = xi[i]->width;
		irast = xi[i]->height;
		XPutImage (bsl_display, bsl_window[i], bsl_gc[i], xi[i], 0, 0, 
			   0, 0, ipix, irast);  
	      }
	  }
/*
 * Now check for buttonpress events
 */
      while (!got_event)
	for (i=0; i<MAXWIN; i++)
	  {
	    if (bsl_window[i] != 0)
	      {
		XSelectInput (bsl_display, bsl_window[i], ButtonPressMask | 
			      OwnerGrabButtonMask);
		if (XCheckWindowEvent (bsl_display, bsl_window[i], 
				       ButtonPressMask, &event))
		  {
		    got_event = 1;
		    current_win = i;
		    ipix = xi[i]->width;
		    irast = xi[i]->height;
/*		    XPutBackEvent (bsl_display, &event); */
		    break;
		  }
	      }
	  }
/*
 * Handle different button events to select palette
 */
      button = event.xbutton.button;
      state = event.xbutton.state;
      
      switch (event.type)
	{
	case ButtonPress:
	  if (button == 1)
	    {
	      if (state & ShiftMask)
		{
		  colour_palette1 ();
		}
	      else
/*
 * Set palette back to grayscale
 */
		gray_palette ();
	    }
	  
	  if (button == 2)
	    {
	      if (state & ShiftMask)
		{
		  colour_palette2 ();
		}
	      else
		{
/*
 * Invert palette
 */
		  printf ("Invert...\n");
		  for (i=0; i<NColorAlloc/2; i++)
		    {
		      temp = pixcol[i];
		      pixcol[i] = pixcol[NColorAlloc - i - 1];
		      pixcol[NColorAlloc - i - 1] = temp;
		    }
		}
	    }

	  if (button == 3)
	    {
	      if (state & ShiftMask)
		{
		  colour_palette3 ();
		}
	      else
/*
 * Finished
 */
		return;
	    }
	  
	default:
	  break;
	}

      cptr = cbuf[current_win];
      bptr = buff[current_win];
      for (i=0; i<ipix*irast; i++)
	{
	  *bptr++ = pixcol[*cptr++];
	}
/*
 * Send image to display  
 */
      XPutImage (bsl_display, bsl_window[current_win], bsl_gc[current_win], 
		 xi[current_win], 0, 0, 0, 0, ipix, irast);

      XFlush (bsl_display);
      got_event = 0;
    }  /* end of while (1) {} */
}

/*******************************************************************************
 *                                gray_palette.c                               *
 *******************************************************************************
 Purpose: Sets up grayscale palette
 Author:  G.R. Mant
 Returns: 
 Updates:
 09/03/94 RCD taken from putimage.c into image.c
*/

static void gray_palette ()
{
  int i, numcol = 0;

  for (i=0; i<NColor; i++)
    {
      colors[i].red   = i<<shift;
      colors[i].green = i<<shift;
      colors[i].blue  = i<<shift;
      colors[i].flags = DoRed | DoGreen | DoBlue;
      if (XAllocColor (bsl_display, cmap, &colors[i]) == 0)
	{
	  printf ("Couldn't allocate: red %d , green %d , blue %d\n",
		  colors[i].red, colors[i].green, colors[i].blue);
	}
      else
	{
	  pixcol[numcol] = colors[i].pixel;
	  numcol++;
	}
    }
  
  printf ("Grayscale: Colours requested: %d  Colours allocated: %d\n", 
	  NColor, numcol);
  NColorAlloc = numcol;
  Colour_freed = 0;
  CFREE ();
}



/*******************************************************************************
 *                               colour_palette.c                              *
 *******************************************************************************
 Purpose: Creates a cyclic lookup table see: Thomas D.J. (1989), J. Appl. Cryst.
          22, 498-499.
 Author: Adapted from Steve Kinder's Image widget. 
 Returns: Nil  
 Updates:
 10/03/94 RCD Initial implementation
*/

static void colour_palette1 ()
{
   float x, xstep, temp, temp1, tempx1, tempx2, gtanh, twopi_n;
   float yred, fred, ygreen, fgreen, yblue, fblue; 
   static float c_red = -0.35, c_green = 0.25, c_blue = 0.35;
   static float phi_red = 4.18879, phi_green = 0.0, phi_blue = 2.09439;
   static float gamma = 1.28;
   static float pi = 3.14159265;
   static int fshift = 32768;
   static int cycles = 7;
   int i, numcol = 0;

   x = 0.0;
   xstep = 1.0 / (float) (NColor - 1);
   twopi_n = 2.0 * pi * (float) cycles;
   gtanh = tanh (gamma);

   for (i=0; i<NColor; i++)
   {
      tempx1 = twopi_n * x;
      tempx2 = x * (1.0 - x);
/*
 * Red
 */
      temp = sin (tempx1 + phi_red);
      temp1 = tanh (gamma * temp) / gtanh;
      yred = x + tempx2 * temp1;
      fred = yred * (1.0 + c_red - yred * c_red); 
/*
 * Green  
 */
      temp = sin (tempx1 + phi_green);
      temp1 = tanh (gamma * temp) / gtanh;
      ygreen = x + tempx2 * temp1;
      fgreen = ygreen * (1.0 + c_green - ygreen * c_green); 
/*
 * Blue 
 */
      temp = sin (tempx1 + phi_blue);
      temp1 = tanh (gamma * temp) / gtanh;
      yblue = x + tempx2 * temp1;
      fblue = yblue * (1.0 + c_blue - yblue * c_blue); 
/*
 * Set up new colour table
 */
      colors[i].red =  (unsigned short) (fshift + fshift * fred);
      colors[i].green =  (unsigned short) (fshift + fshift * fgreen);
      colors[i].blue =  (unsigned short) (fshift + fshift * fblue);
      colors[i].flags = DoRed | DoGreen | DoBlue;
      
      if (XAllocColor (bsl_display, cmap, &colors[i]) == 0)
	{
	  printf ("Couldn't allocate: red %d , green %d , blue %d\n",
		  colors[i].red, colors[i].green, colors[i].blue);
	}
      else
	{
	  pixcol[numcol] = colors[i].pixel;
	  numcol++;
	}
/*
 * Increment x
 */
      x += xstep;
   }

   printf ("Thomas: Colours requested: %d  Colours allocated: %d\n", 
	   NColor, numcol); 
   NColorAlloc = numcol;
   Colour_freed = 0;
   CFREE ();
}

static void colour_palette2 ()
{
  float red, green, blue, x, xstep, phi, phistep;
  static float pi = 3.14159265, root3 = 1.732051, third = 0.333333;
  float a, b, xp;
  static int fshift = 32768, ncycles = 2;
  int i, numcol = 0;

  x = 0.0;
  xstep = 1.0 / (float) (NColor - 1);
  phi = pi / 3.0;
  phistep = (float) ncycles * 2.0 * pi / (float) (NColor - 1);
  
  for (i=0; i<NColor; i++)
    {
      red = green = blue = 0.0;
      xp = x*x;
      a = (1.0 - xp) * 0.5 * (cos(phi) + 0.5 * sin(phi));
      b = (1.0 - xp) * 0.5 * root3 * sin(phi) / 2.0;
      
      red   = third * (2.0 + a - 2.0 * b);
      blue  = third * (2.0 + a + b);
      green = third * (2.0 - 2.0 * a + b);
/*
 * Set up new colour table
 */
      colors[i].red =  (unsigned short) (fshift + fshift * red);
      colors[i].green =  (unsigned short) (fshift + fshift * green);
      colors[i].blue =  (unsigned short) (fshift + fshift * blue);
      colors[i].flags = DoRed | DoGreen | DoBlue;
      
      if (XAllocColor (bsl_display, cmap, &colors[i]) == 0)
	{
	  printf ("Couldn't allocate: red %d , green %d , blue %d\n",
		  colors[i].red, colors[i].green, colors[i].blue);
	}
      else
	{
	  pixcol[numcol] = colors[i].pixel;
	  numcol++;
	}
/*
 * Increment x
 */
      x += xstep;
      phi += phistep;
   }

   printf ("Colour 2: Colours requested: %d  Colours allocated: %d\n", 
	   NColor, numcol); 
   NColorAlloc = numcol;
   Colour_freed = 0;     
  CFREE ();
}

static void colour_palette3 ()
{
  float red, green, blue, x, xstep;
  static float third = 0.333333;
  static int fshift = 32768;
  int i, numcol = 0;

  x = 0.0;
  xstep = 1.0 / (float) (NColor - 1);
  
  for (i=0; i<NColor; i++)
    {
      red = green = blue = 0.0;
      if (x < third)
	{
	  blue = 1.0 - 3.0 * x;
	  green = 3.0 * x;
	}
      else if (x < 2.0 * third)
	{
	  green = 2.0 - 3.0 * x;
	  red = 3.0 * x - 1.0;
	}
      else
	{
	  red = 3.0 - 3.0 * x;
	  blue = 3.0 * x - 2.0;
	}
/*
 * Set up new colour table
 */
      colors[i].red =  (unsigned short) (fshift + fshift * red);
      colors[i].green =  (unsigned short) (fshift + fshift * green);
      colors[i].blue =  (unsigned short) (fshift + fshift * blue);
      colors[i].flags = DoRed | DoGreen | DoBlue;
      
      if (XAllocColor (bsl_display, cmap, &colors[i]) == 0)
	{
	  printf ("Couldn't allocate: red %d , green %d , blue %d\n",
		  colors[i].red, colors[i].green, colors[i].blue);
	}
      else
	{
	  pixcol[numcol] = colors[i].pixel;
	  numcol++;
	}
/*
 * Increment x
 */
      x += xstep;
   }

   printf ("Colour 3: Colours requested: %d  Colours allocated: %d\n", 
	   NColor, numcol); 
   NColorAlloc = numcol;
   Colour_freed = 0;     
  CFREE ();
}

void CFREE ()
{
  if (Colour_freed == 0)
    {
      XFreeColors (bsl_display, cmap, pixcol, NColorAlloc, (unsigned long) 0x0);
      XFlush (bsl_display);
      Colour_freed = 1;
    }
  return;
}


static void psout ()
{
   FILE *fp, *fopen ();
   char termbuf [MAXTERM], fname[80];
   char *defname = "fix.ps";
   int i, j, k, ipix, irast, n, ixb1, iyb1, ixb2, iyb2;
   int win = 0;
   short int ir, ig, ib;
   DATA_TYPE *dptr;

   while (win < MAXWIN)
   { 
      while (win < MAXWIN)
      {
	 if (bsl_window [win] != 0)
	    break;
	 win++;
      }
      if (win >= MAXWIN)
	 break;
       
      printf ("Enter window number to save as Postscript file [%d]: ", win);
      fgets (termbuf, MAXTERM, stdin);
      if (feof (stdin))
      {
	 clearerr (stdin);
	 break;
      }
      else
	 sscanf (termbuf, "%u", &win);

      k = 0;
      while ((fname [k] = defname [k++]) !=  '\0');
	 
      printf ("Enter output Postscript filename [%s]: ", defname);
      fgets (termbuf, MAXTERM, stdin);
      if (feof (stdin))
      {
         clearerr (stdin);
	 break;
      }
      else
         sscanf (termbuf, "%s", fname);


      if ((fp = fopen (fname, "w")) == NULL)
      {
         fprintf (stderr, "Error opening file\n");
         break;
      }
      else
      {
	 ipix = xi [win]->width;
	 irast = xi [win]->height;
	 ixb1 = (596 - ipix)/2;
	 ixb2 = ixb1 + ipix;
	 iyb1 = (1005 - irast)/2;
	 iyb2 = iyb1 + irast;

	 fprintf (fp, "%%!PS-Adobe-2.0\n");
	 fprintf (fp, "%%%%Title: %s\n", fname);
	 fprintf (fp, "%%%%Creator: FIX\n");
	 fprintf (fp, "%%%%BoundingBox: %u %u %u %u\n", ixb1, iyb1, ixb2, iyb2);
	 fprintf (fp, "%%%%Pages: 1\n");
         fprintf (fp, "%%%%DocumentFonts:\n");
         fprintf (fp, "%%%%EndComments\n");
         fprintf (fp, "%%%%EndProlog\n");        
         putc ('\n', fp);
	 fprintf (fp, "%%%%Page: 1 1\n");
         putc ('\n', fp);

         fprintf (fp, "%% remember original state\n");
         fprintf (fp, "/origstate save def\n");
         putc ('\n', fp);

         fprintf (fp, "%% build a temporary dictionary\n");
         fprintf (fp, "20 dict begin\n");
         putc ('\n', fp);

	 fprintf (fp, "%% define string to hold a scanline's worth of data\n");
         fprintf (fp, "/pix %u string def\n", 3*ipix);
         putc ('\n', fp);

	 fprintf (fp, "%% lower left corner\n");
         fprintf (fp, "%u %u translate\n", ixb1, iyb1);
         putc ('\n', fp);

	 fprintf (fp, "%% size of image (on paper, in 1/72inch coords)\n");
         fprintf (fp, "%f %f scale\n", (float) ipix, (float) irast);
         putc ('\n', fp);

	 fprintf (fp, "%% define 'colorimage' if it isn't defined\n");
         fprintf (fp, "%%   ('colortogray' and 'mergeprocs' come from xwd2ps\n");
         fprintf (fp, "%%     via xgrab)\n");
         fprintf (fp, "/colorimage where   %% do we know about 'colorimage'?\n");
         fprintf (fp, "{ pop }           %% yes: pop off the 'dict' returned\n");
         fprintf (fp, "  {                 %% no:  define one\n");
         fprintf (fp, "    /colortogray {  %% define an RGB->I function\n");
         fprintf (fp, "      /rgbdata exch store    %% call input 'rgbdata'\n");
         fprintf (fp, "      rgbdata length 3 idiv\n");
         fprintf (fp, "      /npixls exch store\n");
         fprintf (fp, "      /rgbindx 0 store\n");
         fprintf (fp, "      /grays npixls string store  %% str to hold the result\n");
         fprintf (fp, "      0 1 npixls 1 sub {\n");
         fprintf (fp, "        grays exch\n");
         fprintf (fp, "        rgbdata rgbindx       get 20 mul    %% Red\n");
         fprintf (fp, "        rgbdata rgbindx 1 add get 32 mul    %% Green\n");
         fprintf (fp, "        rgbdata rgbindx 2 add get 12 mul    %% Blue\n");
         fprintf (fp, "        add add 64 idiv      %% I = .5G + .31R + .18B\n");
         fprintf (fp, "        put\n");
         fprintf (fp, "        /rgbindx rgbindx 3 add store\n");
         fprintf (fp, "      } for\n");
         fprintf (fp, "      grays\n");
         fprintf (fp, "    } bind def\n");
         putc ('\n', fp);

	 fprintf (fp, "    %% Utility procedure for colorimage operator.\n");
         fprintf (fp, "    %% This procedure takes two procedures off the\n");
         fprintf (fp, "    %% stack and merges them into a single procedure.\n");
         putc ('\n', fp);

         fprintf (fp, "    /mergeprocs { %% def\n");
         fprintf (fp, "      dup length\n");
         fprintf (fp, "      3 -1 roll\n");
         fprintf (fp, "      dup\n");
         fprintf (fp, "      length\n");
         fprintf (fp, "      dup\n");
         fprintf (fp, "      5 1 roll\n");
         fprintf (fp, "      3 -1 roll\n");
         fprintf (fp, "      add   \n");
         fprintf (fp, "      array cvx\n");
         putc ('\n', fp);

         fprintf (fp, "      dup\n");
         fprintf (fp, "      3 -1 roll\n");
         fprintf (fp, "      0 exch\n");
         fprintf (fp, "      putinterval\n");
         fprintf (fp, "      dup\n");
         fprintf (fp, "      4 2 roll\n");
         fprintf (fp, "      putinterval\n");
         fprintf (fp, "    } bind def\n");
         putc ('\n', fp);

         fprintf (fp, "    /colorimage { %% def\n");
         fprintf (fp, "      pop pop     %% remove 'false 3' operands\n");
         fprintf (fp, "      {colortogray} mergeprocs\n");
         fprintf (fp, "      image\n");
         fprintf (fp, "    } bind def\n");
         fprintf (fp, "  } ifelse          %% end of 'false' case\n");
         putc ('\n', fp);
         putc ('\n', fp);


	 fprintf (fp, "%u %u  8                  %% dimensions of data\n", 
		  ipix, irast);
	 fprintf (fp, "[%d 0 0 %d 0 %d]          %% mapping matrix\n", 
		  ipix, -irast, irast);
	 fprintf (fp, "{currentfile pix readhexstring pop}\n");
         fprintf (fp, "false 3 colorimage\n");

	 dptr = (DATA_TYPE *) xi [win]->data;
	 for (j=0; j<irast; j++)
	 {
            for (i=0; i<ipix; i++)
            {
               for (n=0; n<NColor; n++)
	       {
		  if (*dptr == colors [n].pixel)
		  {
		     ir = (colors [n].red >> 8) & 0XFF;
		     ig = (colors [n].green >> 8) & 0XFF;
		     ib = (colors [n].blue >> 8) & 0XFF;
		     break;
		  }
	       }
	       if (i%12 == 0)
		  putc ('\n', fp);
	       fprintf (fp, "%02X%02X%02X", ir, ig, ib);
	       dptr++;
	    }
	 }

	 fprintf (fp, "\nshowpage\n");
         putc ('\n', fp);

         fprintf (fp, "%% stop using temporary dictionary\n");
         fprintf (fp, "end\n");
         putc ('\n', fp);

         fprintf (fp, "%% restore original state\n");
         fprintf (fp, "origstate restore\n");
         putc ('\n', fp);

         fprintf (fp, "%%%%Trailer");
      }
      fclose (fp);
      win++;
   }
   return;
}

static void thresholds ()
{
  int win = 0;
  char termbuf[MAXTERM];

  while (win < MAXWIN)
    { 
      while (win < MAXWIN)
	{
	  if (bsl_window[win] != 0)
	    break;
	  win++;
	}
      if (win >= MAXWIN)
	break;
      
      printf ("Enter window number for threshold change [%d]: ", win);
      fgets (termbuf, MAXTERM, stdin);
      if (feof (stdin))
	{  
	  clearerr (stdin);
	  break;
	}
      else
	sscanf (termbuf, "%u", &win);
      
      if (!data_thresh (win))
	{
	  return;
	}
      win++;
    }
  return;
}


void DRAWPT (float *fx, float *fy, int *npts)
{
  int i, n;
  int *ix, *iy;

  if (!(ix = (int *) malloc (*npts * sizeof (int))) ||
      !(iy = (int *) malloc (*npts * sizeof (int))))
    {
      printf ("Error allocating memory\n");
      return;
    }

  for (i=0; i<MAXWIN; i++)
    {
      if (bsl_window [i] != 0)
	{
	  n = file_to_image_coords (fx, fy, *npts, i, ix, iy);
	  if (n > 0)
	    {
	      XSetForeground (bsl_display, bsl_gc [i], 0xffffff);
	      XSetFunction (bsl_display, bsl_gc [i], GXxor);
	      if (NColor == 128)
		XSetPlaneMask (bsl_display, bsl_gc [i], 0x7f);
	      XfDrawCross (bsl_display, bsl_window[i], bsl_gc[i], ix, iy, n, 5);
	      XSetFunction (bsl_display, bsl_gc [i], GXcopy);
	      XSetPlaneMask (bsl_display, bsl_gc [i], AllPlanes);
	    }
	}
    }
  XFlush (bsl_display);
  free (ix);
  free (iy);
  return;
}


static void thickline ()
{
   int ndata = 0, got_event = 0, cont = 1;
   int i, ifp, ilp, ifr, ilr, ipix, irast, width;
   XEvent event;
   DataPoint *dptr = data;
/*
 * Count along to end of data buffer
 */
   while (dptr->npts > 0)
   {
      dptr++;
      ndata++;
   }
/*
 * Print instructions
 */
   printf (" Button 1: Depress and move to select beginning of line\n");
   printf (" Button 1 & <shift>: Depress and move to select width of line\n");
   printf (" Button 2: Depress and move to select end of line\n");
   printf (" Button 3: Click button to exit selection\n");
/*
 * Check for exposure events
 */
   XSync (bsl_display, 0);
   for (i=0; i<MAXWIN; i++)
      if (bsl_window [i] != 0)
      {
	 if (XCheckWindowEvent (bsl_display, bsl_window [i], ExposureMask, 
				&event))
	 {
	    ipix = xi [i]->width;
	    irast = xi [i]->height;
	    XPutImage (bsl_display, bsl_window [i], bsl_gc [i], xi [i], 0, 0, 0, 
		       0, ipix, irast);
	 }
      }
/*
 * Now check for buttonpress events
 */
   while (!got_event)
      for (i=0; i<MAXWIN; i++)
      {
	 if (bsl_window [i] != 0)
	 {
	    XSelectInput (bsl_display, bsl_window [i], ButtonPressMask | 
			  OwnerGrabButtonMask);
            if (XCheckWindowEvent (bsl_display, bsl_window [i], ButtonPressMask, 
				   &event))
	    {
	       got_event = 1;
	       current_win = i;
	       ipix = xi [i]->width;
	       irast = xi [i]->height;
	       XPutBackEvent (bsl_display, &event);
	       break;
	    }
         }
      }  

   while (cont)
   {
      if (!skew_rectangle (ipix, irast, &ifp, &ilp, &ifr, &ilr, &width))
         return;
      if (ndata++ < MAXDAT)
      {
         dptr->npts = 2;
         dptr->win = i;
         dptr->xpts [0] = ifp;
         dptr->ypts [0] = ifr;
         dptr->xpts [1] = ilp;
         dptr->ypts [1] = ilr;
	 dptr->width = width;
         dptr++;
         if (ndata < MAXDAT)
            dptr->npts = 0;
      }
      else
      {
         printf ("Too much data!\n");
         return;
      }
   }
}


static void refresh ()
{
  int i;

  for (i=0; i<MAXWIN; i++)
    {
      if (bsl_window [i] != 0)
	{
	  XPutImage (bsl_display, bsl_window[i], bsl_gc[i], xi[i], 0, 0, 0, 0,
		     xi[i]->width, xi[i]->height);
	}
    }
}

void DRAWCL (float *xc, float *yc, float *frad)
{
  int i, ipix, irast, xcen, ycen, radius;
  double rad = (double) *frad;

  for (i=0; i<MAXWIN; i++)
    {
      if (bsl_window [i] != 0)
	{
	  ipix = xi[i]->width;
	  irast = xi[i]->height;
	  radius = f2i_scale (rad, i);
	  (void) file_to_image_coords (xc, yc, (int) 1, i, &xcen, &ycen);
	  XSetForeground (bsl_display, bsl_gc [i], 0xffffff);
	  XSetFunction (bsl_display, bsl_gc [i], GXxor);
	  if (NColor == 128)
	    XSetPlaneMask (bsl_display, bsl_gc [i], 0x7f);
	  XfDrawCircle (bsl_display, bsl_window[i], bsl_gc[i], xcen, ycen, 
			radius, ipix, irast);
	  XSetFunction (bsl_display, bsl_gc [i], GXcopy);
	  XSetPlaneMask (bsl_display, bsl_gc [i], AllPlanes);
	}
    }
  XFlush (bsl_display);
}

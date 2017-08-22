/***********************************************************************
 *                           putimage.c                                *
 ***********************************************************************
 Purpose:  Opens window for display if necessary, scales pixel values in
           image, selects window and displays image.
 Authors: G.R.Mant
 Returns: TRUE if successful, else FALSE on error condition
 Updates: 
 27/06/89 GRM Initial implementation
 28/08/91 GRM Added window selection
 17/01/94 RCD Modified for use in FIX
 06/10/95 RCD ANSI prototypes and other bits and pieces.
*/

#ifdef __hpux
#  define caddr_t char *
#endif
#include <stdio.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/Xos.h>
#include "fixextern.h"

static void scale (int, int, int, float *);
static int open_window (int, int, int);
static int select_window (int, int);

int put_image (float *data, int npix, int nrast, int *win)
{
    int bytes;
    int window_no;
    int bytes_per_line;
    register float *dptr;
    register int i;


/* Calculate minimum & maximum values of data buffer */

    bytes = npix * nrast * sizeof (DATA_TYPE);
    dptr = data;
    tmin = tmax = *dptr;
    for (i=0; i<npix*nrast; i++, dptr++)
    {
	if (*dptr < tmin) tmin = *dptr;
	if (*dptr > tmax) tmax = *dptr;
    }

/* Create windows where necessary */

    if ((window_no = select_window (npix, nrast)) == -1)
	return (FALSE);

    if (bsl_window[window_no] == 0)
    {
	if ((buff[window_no] = (DATA_TYPE *) malloc (bytes)) == 
	    (DATA_TYPE *) NULL)
	{   
	    errmsg ("Error: Unable to allocate enough memory for image");
	    return (FALSE);
	}
	if ((cbuf[window_no] = (DATA_TYPE *) malloc (bytes)) == 
	    (DATA_TYPE *) NULL)
	  {   
	    errmsg ("Error: Unable to allocate enough memory for image");
	    return (FALSE);
	  }

	if (!open_window (window_no, npix, nrast))
	{
	    errmsg ("Error: Failed to create new window");
	    return (FALSE);
	}
    }
    else
    {
	bytes_per_line = sizeof (DATA_TYPE) * npix;
        xi[window_no] = XCreateImage (bsl_display, visualList->visual, 
				      screen_depth, ZPixmap, offset, 
				      (char *) buff[window_no], npix, nrast, 
				      bitmap_pad, bytes_per_line);
	xi[window_no]->bits_per_pixel = bits_per_pixel;
    }


    current_win = window_no;
    scale (window_no, npix, nrast, data); 

/* Process events */

    process_event (window_no, npix, nrast, data);
    *win = window_no;
    return (TRUE);
}

static int open_window (int window_no, int xsize, int ysize)
{
    XSizeHints size_hints;		/* preferred sizes  */
    XVisualInfo vinfo;
    Visual *defaultVisual;
    char window_name[10];
    int xorig = 0, yorig = 0;
    int nvisuals;
    int bytes_per_line;
    unsigned long ValueMask = CWBackPixel | CWBorderPixel | CWColormap | 
                              CWBackingStore;
    long VisualMask = VisualClassMask | VisualScreenMask | VisualDepthMask;
    unsigned int border = 0;
    int i;
    register int w = window_no;

    sprintf (window_name,"FIX %d",window_no);
    window_name [9] = '\0';

/* Now create the window */

    if (!(bsl_window[w] = XCreateWindow ((Display *) bsl_display,
			       (Window) RootWindow (bsl_display, screen),
			       (int) xorig, (int) yorig, 
			       (unsigned int) xsize, (unsigned int) ysize, 
			       (unsigned int) border, (int) screen_depth,
			       InputOutput, (Visual *) visualList->visual,
			       ValueMask, &attributes)))
	return (FALSE);

/* Give window manager a few clues */

    size_hints.flags  = PPosition | PSize | PMinSize | PMaxSize;
    size_hints.x  = xorig;
    size_hints.y  = yorig;
    size_hints.width  = xsize;
    size_hints.height = ysize;
    size_hints.min_width  = xsize;
    size_hints.min_height = ysize;
    size_hints.max_width  = xsize;
    size_hints.max_height = ysize;

    XSetStandardProperties (bsl_display, bsl_window[w], window_name,
			    NULL, None, NULL, 0, &size_hints);    
    bsl_gc[w] = XCreateGC (bsl_display, bsl_window[w], 0, 0);
    XDefineCursor (bsl_display, bsl_window[w], cursor);  

    bytes_per_line = sizeof (DATA_TYPE) * xsize;
    xi[w] = XCreateImage (bsl_display, visualList->visual, screen_depth, ZPixmap,
			  offset, (char *) buff[w], xsize, ysize, bitmap_pad, 
			  bytes_per_line);
    xi[w]->bits_per_pixel = bits_per_pixel;

/* Initialize events and map windows */

    for (i=0; i<MAXWIN; i++)
       if (bsl_window[i] != 0)
	  XSelectInput (bsl_display, bsl_window[i], ExposureMask);

    XMapWindow (bsl_display, bsl_window[w]);
    return (TRUE);
}

void process_event (int window_no, int npix, int nrast, float *data)
{
    char termbuf[MAXTERM];
    XEvent event;
    register int i, w = window_no;

    XPutImage (bsl_display, bsl_window[w], bsl_gc[w], xi[w],
               0, 0, 0, 0, npix, nrast);

    do
    {
        XSync (bsl_display, 0);
	for (i=0; i<MAXWIN; i++)
	{
	    if (bsl_window[i] != 0 &&
		XCheckWindowEvent (bsl_display, bsl_window[i], ExposureMask,
				   &event))
		XPutImage (bsl_display, bsl_window[i], bsl_gc[i], xi[i],
			   0, 0, 0, 0, xi[i]->width, xi[i]->height);
	}

	printf (" Enter threshold values [%g,%g] or <ctrl-D>: ", tmin, tmax);
	fgets (termbuf, MAXTERM, stdin);
	if (feof (stdin))
	{
	    clearerr (stdin);
	    break;
	}
	else
	{
	    i = 0;
	    while (termbuf[i] != '\0')
		if (termbuf[i++] == ',')
		    termbuf[i-1] = ' ';
	    sscanf (termbuf,"%f%f", &tmin, &tmax);
	    scale (w, npix, nrast, data);
	    XPutImage (bsl_display, bsl_window[w], bsl_gc[w], xi[w],
		       0, 0, 0, 0, npix, nrast);
	}
    }
    while (1);
    printf ("\n");
    return;
}

static void scale (int w, int npix, int nrast, float *data)
{
    register float *dptr;
    register DATA_TYPE *bptr, *cptr;
    register int i;
    DATA_TYPE temp;
    float range, value;
    float lo, hi;

    range = (float) (NColorAlloc - 1) / (tmax - tmin);
    dptr = data;
    bptr = buff[w];
    cptr = cbuf[w];
    lo = tmin;
    hi = tmax;
    if (tmin > tmax)
    {
	lo = tmax;
	hi = tmin;
    }
    for (i=0; i<npix*nrast; i++)
    {
	value = *dptr++;
	value = MAX (value, lo);
	value = MIN (value, hi);
	temp = (DATA_TYPE) ((value - tmin) * range);
	*cptr++ = temp;
	*bptr++ = (DATA_TYPE) pixcol[temp];
    }
}
 
static int select_window (int npix, int nrast)
{
    char termbuf[MAXTERM];
    int win = current_win + 1;
    XWindowAttributes win_attr;

    while (1)
    {
	printf (" Enter window number (0-%d) [%1d] : ", MAXWIN-1, win);
	fgets (termbuf, MAXTERM, stdin);
	if (feof (stdin))
	{
	    clearerr (stdin);
	    printf ("\n");
	    return (-1);
	}
	else
	{
	    sscanf (termbuf,"%d", &win);
	    if (win >= 0 && win < MAXWIN)
            {
                if (bsl_window[win] &&
                    (npix != xi[win]->width || nrast != xi[win]->height))
                { 
                    XGetWindowAttributes (bsl_display, bsl_window[win],
                                          &win_attr);
                    XResizeWindow (bsl_display, bsl_window[win],
                                   win_attr.width + npix - xi[win]->width, 
                                   win_attr.height + nrast - xi[win]->height); 
                } 
		return (win);
            }
	    else
		errmsg ("Error: Invalid window number selection");
	}
    }
}


/***********************************************************************
 *                           putimage.c                                *
 ***********************************************************************
 Purpose: Open X window display, initialise colour palette, scale image
          create window and display the image.
 Authors: G.R.Mant
 Returns: TRUE if successful, else FALSE on error condition
 Updates: 
 27/06/89 GRM Initial implementation
 28/08/91 GRM Added window selection
*/

#include <stdio.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/Xos.h>
#include <X11/cursorfont.h>

int put_image (float *, int, int);

static int open_window (int, int, int);
static void set_palette ();
static void process_event (int, int, int, float *);
static void scale (int, int, int, float *);
static int select_window ();

#define MAXCOLOR  256

#define DATA_TYPE unsigned char
#define FALSE	0
#define TRUE	!FALSE
#define MAXWIN	4
#define MAXTERM	80
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

Display		*bsl_display;
Window		bsl_window[MAXWIN] = {0,0,0,0};
GC		bsl_gc[MAXWIN] = {0,0,0,0};
Colormap 	cmap;
XImage		*xi[MAXWIN];
int		Opened = FALSE;
int		current_win = -1;
int		NColor = 0, numcol;
DATA_TYPE 	*buff[MAXWIN];
float		tmin, tmax;     /* minimum & maximum threshold values */
unsigned long	pixcol[MAXCOLOR];
XColor colors[MAXCOLOR];

int put_image (float *data, int npix, int nrast)
{
    char *display_name = NULL;
    char message[80];
    int bytes;
    int window_no;
    register float *dptr;
    register int i;

    void scale (), set_palette (), process_event ();
    int open_window (), select_window ();


/* Calculate minimum & maximum values of data buffer */

    bytes = npix * nrast * sizeof (char);
    dptr = data;
    tmin = tmax = *dptr;
    for (i=0; i<npix*nrast; i++, dptr++)
    {
	if (*dptr < tmin) tmin = *dptr;
	if (*dptr > tmax) tmax = *dptr;
    }

/* Open display and create windows where necessary */

    if (!Opened)
    {
	if (!(bsl_display = XOpenDisplay (display_name)))
	{   
	    sprintf (message, "Error: Cannot connect to X Server %s\n",
		    XDisplayName (display_name));
	    errmsg (message);
	    return (FALSE);
	}
	Opened = TRUE;
    }

    if ((window_no = select_window ()) == -1)
	return (FALSE);

    if (bsl_window[window_no] == 0)
    {
	if ((buff[window_no] = (DATA_TYPE *) malloc (bytes)) == (DATA_TYPE *) NULL)
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
    current_win = window_no;
    scale (window_no, npix, nrast, data);

/* Process events */

    process_event (window_no, npix, nrast, data);
    return (TRUE);
}

static int open_window (int window_no, int xsize, int ysize)
{
    XSizeHints size_hints;		/* preferred sizes  */
    XVisualInfo *visualList, vinfo;
    XSetWindowAttributes attributes;
    Visual *defaultVisual;
    int screen;
    char *window_name = "BSL image";
    int xorig = 0, yorig = 0;
    int nvisuals;
    int ValueMask = CWBackPixel | CWBorderPixel | CWColormap;
    long VisualMask = VisualClassMask | VisualScreenMask | VisualDepthMask;
    unsigned int border = 0;
    int depth;
    Cursor cursor;
    int cursor_shape = XC_tcross;	/* form of cursor   */
    int offset = 0;			/* offset into data */
    int bitmap_pad = 8;
    int bytes_per_line = 0;
    register int w = window_no;

    screen = DefaultScreen (bsl_display);
    depth =  DefaultDepth (bsl_display, screen);
    printf ("screen depth is %d\n", depth);
    XSynchronize (bsl_display, (int) 1);

/* Get visual information for window */

    defaultVisual = DefaultVisual (bsl_display, screen);
    if (defaultVisual->class == PseudoColor)
    {
	vinfo.screen = screen;
	vinfo.depth  = 8;
	vinfo.class  = PseudoColor;
	visualList = XGetVisualInfo (bsl_display, VisualMask,
				     &vinfo, &nvisuals);
	visualList->visual = DefaultVisual (bsl_display, screen);
	cmap = DefaultColormap (bsl_display, screen);
	NColor = 128;
	set_palette ();
    }
    else
    {
	vinfo.screen = screen;
	vinfo.class  = PseudoColor;
	vinfo.depth  = 8;
	visualList = XGetVisualInfo (bsl_display, VisualMask,
				     &vinfo, &nvisuals);
	if (nvisuals == 0)
	    cmap = DefaultColormap (bsl_display, screen);
	else
	{
	    cmap = XCreateColormap (bsl_display,
				    RootWindow (bsl_display, screen),
				    visualList->visual,
				    AllocNone);
	    XInstallColormap (bsl_display, cmap);
	    NColor = 256;
	    set_palette ();
	}
    }

    depth = visualList->depth;

    attributes.background_pixel = 0x0;
    attributes.border_pixel = 0xe0;
    attributes.colormap = cmap;

/* Now create the window */

    if (!(bsl_window[w] = XCreateWindow ((Display *) bsl_display,
			       (Window) RootWindow (bsl_display, screen),
			       (int) xorig, (int) yorig, 
			       (unsigned int) xsize, (unsigned int) ysize, 
			       (unsigned int) border, (int) depth,
			       InputOutput, (Visual *) visualList->visual,
			       (unsigned long) ValueMask, &attributes)))
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
    cursor = XCreateFontCursor (bsl_display, cursor_shape);
    XDefineCursor (bsl_display, bsl_window[w], cursor);

   xi[w] = XCreateImage (bsl_display, visualList->visual, depth, ZPixmap, offset,
		  (char *) buff[w], xsize, ysize, bitmap_pad, bytes_per_line);

/* Initialize events and map windows */

    XSelectInput (bsl_display, bsl_window[w], ExposureMask);
    XMapWindow (bsl_display, bsl_window[w]);
    return (TRUE);
}

static void set_palette ()
{
    XColor colors[MAXCOLOR];
    int i, shift;

    if (NColor == 256)
	shift = 8;
    else 
	shift = 9;

    for (i=0, numcol=0; i<NColor; i++)
    {
	colors[i].red   = i<<shift;
	colors[i].green = i<<shift;
	colors[i].blue  = i<<shift;
	colors[i].flags = DoRed | DoGreen | DoBlue;
	if (XAllocColor (bsl_display, cmap, &colors[i]))
	    pixcol[numcol++] = colors[i].pixel;
    }

    if (numcol != NColor)
	errmsg ("Not all requested colors have been allocated");


}

static void process_event (int window_no, int npix, int nrast, float *data)
{
    char termbuf[MAXTERM];
    XEvent event;
    register int i, w = window_no;

    if (!XCheckWindowEvent (bsl_display, bsl_window[w], ExposureMask,
			    &event))
	XPutImage (bsl_display, bsl_window[w], bsl_gc[w], xi[w],
		   0, 0, 0, 0, npix, nrast);
    do
    {

	for (i=0; i<MAXWIN; i++)
	{
	    if (bsl_window[i] != 0 &&
		XCheckWindowEvent (bsl_display, bsl_window[i], ExposureMask,
				   &event))
		XPutImage (bsl_display, bsl_window[i], bsl_gc[i], xi[i],
			   0, 0, 0, 0, npix, nrast);
	}

	printf (" Enter threshold values [%g,%g] : ", tmin, tmax);
	fgets (termbuf, MAXTERM, stdin);
	if (feof (stdin))
	{
	    clearerr (stdin);
	    break;
	}
	else if ((termbuf[0] == '^') && termbuf[1] == 'd' || termbuf[1] == 'D')
	    break;
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
    register DATA_TYPE *bptr;
    register int i;
    float range, value;
    float lo, hi;

    range = (float) (numcol - 1) / (tmax - tmin);
    dptr = data;
    bptr = buff[w];
    lo = tmin;
    hi = tmax;
    if (tmin > tmax)
    {
	lo = tmax;
	hi = tmin;
    }
    for (i=0; i<npix*nrast; i++, bptr++)
    {
	value = *dptr++;
	value = MAX (value, lo);
	value = MIN (value, hi);
	*bptr = (DATA_TYPE) ((value - tmin) * range);
	*bptr = (DATA_TYPE) pixcol[*bptr];
    }
}
 
static int select_window ()
{
    char termbuf[MAXTERM];
    int win = 1;

    while (1)
    {
	printf (" Enter window number (1-%d) [%1d] : ", MAXWIN, win);
	fgets (termbuf, MAXTERM, stdin);
	if (feof (stdin))
	{
	    clearerr (stdin);
	    printf ("\n");
	    return (-1);
	}
	else if ((termbuf[0] == '^') && termbuf[1] == 'd' || termbuf[1] == 'D')
	    break;
	else
	{
	    sscanf (termbuf,"%d", &win);
	    if (win > 0 && win <= MAXWIN)
		return (--win);
	    else
		errmsg ("Error: Invalid window number selection");
	}
    }
}


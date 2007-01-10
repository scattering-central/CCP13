#include <stdio.h>
#include <math.h>
#include <errno.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/Xos.h>

void DrawSector (Display *display, Window window, GC gc, int xcen, int ycen, 
int x1, int y1, int x2, int y2)
{
	static double rtod = 3.66692988883e+03;    /* 64 times 180 over pi */
	double r1, phi1, r2, phi2, dx1, dy1, dx2, dy2;
	int ir1, ir2, ip1, ip2, xc, yc;

	dx1 = (double) (x1 - xcen);
	dy1 = (double) (ycen - y1);
	dx2 = (double) (x2 - xcen);
	dy2 = (double) (ycen - y2);

	phi1 = atan2 (dy1, dx1);
	phi2 = atan2 (dy2, dx2);
	ip1 = (int) rtod * phi1;
	ip2 = (int) rtod * (phi2 - phi1);

	if (ip2 < 0)
		ip2 += 23040;

	r1 = sqrt (dx1 * dx1 + dy1 * dy1);
	r2 = sqrt (dx2 * dx2 + dy2 * dy2);
	ir1 = (int) r1;
	ir2 = (int) r2;

	XDrawArc (display, window, gc, (xcen - ir1), (ycen - ir1), (2 * ir1), (2 * ir1), ip1, ip2);
	XDrawArc (display, window, gc, (xcen - ir2), (ycen - ir2), (2 * ir2), (2 * ir2), ip1, ip2);

	xc = xcen + (int) r1 * cos (phi2);
	yc = ycen - (int) r1 * sin (phi2);
	XDrawLine (display, window, gc, xc, yc, x2, y2);

	xc = xcen + (int) r2 * cos (phi1);
	yc = ycen - (int) r2 * sin (phi1);
	XDrawLine (display, window, gc, xc, yc, x1, y1);
}

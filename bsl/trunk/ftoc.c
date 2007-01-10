/***********************************************************************
 **                          ftoc.c                                   **
 ***********************************************************************
 Purpose: Machine dependent FORTRAN to C interface for BSL
 Authors: G.R.Mant
 Returns: Nil
 Updates: 01/11/89 Initial implementation

*/

#ifdef titan

#define putimage PUTIMAGE
#define cirfil   CIRFIL
#define ellfil   ELLFIL
#define parfil   PARFIL 
#define polfil   POLFIL
#define recfil   RECFIL
#define fixrec   FIXREC
#define varrec   VARREC
#define cirset   CIRSET
#define sectorset   SECTORSET

#else
#ifndef hpux                            /* sun/convex/iris */

#define putimage putimage_
#define cirfil   cirfil_
#define ellfil   ellfil_
#define parfil   parfil_
#define polfil   polfil_
#define recfil   recfil_
#define fixrec   fixrec_
#define varrec   varrec_
#define cirset   cirset_
#define sectorset   sectorset_

#endif
#endif

int putimage (data, npix, nrast)
float   data[];				/* data buffer   */
int     *npix, *nrast;			/* size of image */
{
    return (put_image (data, *npix, *nrast));
}

void cirfil (mask, npix, nrast)
float mask[];                      /* mask buffer   */
int   *npix, *nrast;               /* size of image */
{
    circle_fill (mask, *npix, *nrast);
}

void ellfil (mask, npix, nrast)
float mask[];                      /* mask buffer   */
int   *npix, *nrast;               /* size of image */
{
    ellipse_fill (mask, *npix, *nrast);
}

void parfil (mask, npix, nrast)
float mask[];                      /* mask buffer   */
int   *npix, *nrast;               /* size of image */
{
    parallelogram_fill (mask, *npix, *nrast);
}


void polfil (mask, npix, nrast)
float mask[];                      /* mask buffer   */
int   *npix, *nrast;               /* size of image */
{
    polygon_fill (mask, *npix, *nrast);
}

void recfil (mask, npix, nrast)
float mask[];                      /* mask buffer   */
int   *npix, *nrast;               /* size of image */
{
    rectangle_fill (mask, *npix, *nrast);
}

void fixrec (npix, nrast, wbox, hbox, ifpix, ifrast)
int  *npix, *nrast;                /* size of image                  */
int  *wbox, *hbox;                 /* rectangle dimensions           */
int  *ifpix, *ifrast;              /* RETURNS coordinates of corner  */
{
    fixed_rectangle (*npix, *nrast, *wbox, *hbox, ifpix, ifrast);
}


void varrec (npix, nrast, ifpix, ilpix, ifrast, ilrast)
int  *npix, *nrast;                      /* size of image                  */
int  *ifpix, *ilpix, *ifrast, *ilrast;   /* RETURNS coordinates of corners */
{
    variable_rectangle (*npix, *nrast, ifpix, ilpix, ifrast, ilrast);
}

void cirset (ixc1, iyc1, irad, npix, nrast)
int  *npix, *nrast;                      /* size of image                  */
int  *ixc1, *iyc1, *irad;                /* RETURNS coordinates of circle */
{
    circle_set (ixc1, iyc1, irad, *npix, *nrast);
}

void sectorset (ixc, iyc, ix1, iy1, ix2, iy2)
int  *ixc, *iyc, *ix1, *iy1, *ix2, *iy2;
{
    sector_set (ixc, iyc, ix1, iy1, ix2, iy2);
}






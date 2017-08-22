/***********************************************************************
 **                       bitset.c                                    **
 ***********************************************************************

 Purpose: Set bits in mask to define polygon. Checks that values are
          in range are made.
 Authors: G.R.Mant
 Returns: nil
 Limits : Maximum nos of intersections is 512.
 Updates: 12/07/89 Initial implementation

*/

#include <stdio.h>

#define TRUE  1
#define FALSE 0
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define SWAP(a, b) (itemp = (a), (a) = (b), (b) = itemp)

void bitset (xverts, yverts, nverts, mask, npix, nrast)

float mask[];                      /* mask buffer                    */
int   xverts[], yverts[], nverts;  /* coordinates & nos. of vertices */
int   npix,nrast;                  /* size of mask buffer            */

{
   int xsects[512];       /* intersections of raster by polygon vertex    */
   int ifrast, ilrast;    /* first and last rasters of intersection       */
   int ifpix, ilpix;      /* first and last pixels of intersection        */
   int nxsect = 0;        /* number of intersections of raster by polygon */
   int i, j, k, n, ix, itemp;

   ifrast = ilrast = yverts[0];
   for (i=1; i<nverts; i++)
   {
      ilrast = MAX (yverts[i], ilrast);
      ifrast = MIN (yverts[i], ifrast);
   }
   if (ilrast < ifrast) SWAP (ifrast, ilrast);
   ifrast = MAX (0, ifrast);
   ilrast = MIN ((nrast - 1), ilrast);

/* find all intersections of raster with line segments of the polygon */
/* if regions between intersections are interior points fill them in  */

   for (j=ifrast; j<=ilrast; j++)
      if ((nxsect = xxsect (xverts, yverts, nverts, j, xsects)) > 1)
         for (i=1; i<nxsect; i++)
	 {
            n = (j * npix);
            ix = (xsects[i-1] + xsects[i]) / 2;
            if (inside (xverts, yverts, nverts, ix, j))
            {
               ifpix = MAX (0, xsects[i-1]);
               ilpix = MIN ((npix - 1), xsects[i]);
               for (k=ifpix; k<=ilpix; k++)
                  mask[n+k] = 1.0;
            }
	 }
}

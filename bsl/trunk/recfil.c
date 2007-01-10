/***********************************************************************
 **                       recfil.c                                    **
 ***********************************************************************

 Purpose: Create & move a variable size rectangle over an image and
          the coordinates of two opposite corners. The result is stored
          as a mask of 1's & 0's.
          Use of buttons:-
             1 - Varies the first pixel & raster coordinates.
             2 - Varies the last pixel & raster coordinates.
             3 - Terminates the selection.
 Authors: G.R.Mant
 Returns: Nil
 Updates: 11/07/89 Initial implementation

*/

#include <stdio.h>

void rectangle_fill (mask, npix, nrast)
float mask[];            /* mask buffer   */
int   npix,nrast;        /* size of image */

{
   int ifpix = 0, ilpix = 0;     /* first & last pixels  */
   int ifrast = 0, ilrast = 0;   /* first & last rasters */
   int i, j, k;

   variable_rectangle (npix, nrast, &ifpix, &ilpix, &ifrast, &ilrast);

   printf ("limits %d %d %d %d\n",ifpix,ilpix,ifrast,ilrast);
   for (i=ifrast; i<=ilrast; i++)
   {
      k = (i - 1) * npix - 1;
      for (j=ifpix; j<=ilpix; j++)
            mask[k+j] = 1.0;
   }
   return;
}

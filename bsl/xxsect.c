/***********************************************************************
 **                       xxsect.c                                    **
 ***********************************************************************

 Purpose: Calculate the intersections of a polygon with a line.
 Authors: G.R.Mant
 Returns: Number of intersections
 Updates: 12/07/89 Initial implementation

*/

#include <stdio.h>

#define TRUE  1
#define FALSE 0
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define SWAP(a, b) (itemp = (a), (a) = (b), (b) = itemp)

int xxsect (xverts, yverts, nverts, line, xsects)

int xverts[], yverts[], nverts;   /* coordinates & nos of vertices      */
int xsects[];                     /* coordinates in intersection points */
int line;                         /* raster intersecting with polygon   */

{
   int nxsect;                    /* nos of intersections               */
   int x1, x2, y1, y2;
   int i, itemp, sorted;

   nxsect = 0;
   for (i=1; i<nverts; i++)
   {
      y1 = yverts[i-1];
      y2 = yverts[i];
      if (y1 != y2 && line >= MIN (y1,y2) && line <= MAX (y1,y2))
      {
         x1 = xverts[i-1];
         x2 = xverts[i];
         xsects[nxsect] = 0.5 + (float) x1 + 
                        (float) ((x2-x1) * (line-y1)) / (float) (y2-y1);
         nxsect++;
      }
   }

   sorted = FALSE;                      /* sort them */
   while (!sorted)
   {
      sorted = TRUE;
      for (i=1; i<nxsect; i++)
         if (xsects[i-1] > xsects[i])
         {
            SWAP (xsects[i-1], xsects[i]);
            sorted = FALSE;
         }
   }
   return nxsect;
}

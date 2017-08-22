/***********************************************************************
 **                       inside.c                                    **
 ***********************************************************************

 Purpose: Uses Cauchy's integral theorem to test for inside. Connect
          test point to each vertex in turn and if the sum of the 
          rotation angles is zero then the point is exterior.
          The rotation angle between (x1,y1) and (x2,y2)
          relative to the central point (x0,y0) is calculated
          using the ratio of the cross product(prop to sin(ang)) to
          the dot product(prop to cos) the sense +/- is important.
 Authors: G.R.Mant
 Returns: TRUE if inside polygon, else FALSE.
 Updates: 12/07/89 Initial implementation

*/

#include <stdio.h>
#include <math.h>

#define TRUE  1
#define FALSE 0

int inside (xverts, yverts, nverts, xpos, ypos)

int xverts[], yverts[], nverts;  /* coordinates & nos. of vertices  */
int xpos, ypos;                  /* coordinate of point to evaluate */

{
   float angsum, cross, dot, pi, angle;
   int   i;

   pi = acos (-1.0);
   if (nverts >= 3)
   {
      angsum = 0.0;
      for (i=1; i<nverts; i++)
      {
         cross = (float) ((xverts[i-1] - xpos) * (yverts[i] - ypos) -
                          (xverts[i] - xpos) * (yverts[i-1] - ypos));
         dot = (float) ((xverts[i-1] - xpos) * (xverts[i] - xpos) +
                        (yverts[i-1] - ypos) * (yverts[i] - ypos));

/* check for right angle */

         if (fabs (dot) <= 0.00001)
               angle = pi / 2.0;
         else
         {
            angle = atan (fabs (cross / dot));
            if (dot < 0.0) angle = pi - angle;
         }
         if (cross < 0.0)  angle = -angle;
         angsum += angle;
      }
      if (fabs (angsum) > pi) return TRUE;
   }
   return FALSE;
}

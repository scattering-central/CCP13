/***********************************************************************
 *                          trmode.c                                   *
 ***********************************************************************
 Purpose: Set terminal into transparent mode (alpha) 
          after using graphics.
          n.b.  This routine does not clear any screens.
 Authors: G.R.Mant
 Returns: Void
 Updates: 
 23/07/92 GRM Initial implementation
*/

#include <stdio.h>

#ifdef titan                            /* Stardent */
#define send_can TRMODE
#else
#ifdef hpux                    /* brain dead hp */
#define send_can trmode
#else
#define send_can trmode_                /* normal computers */
#endif
#endif

#define CAN '\030'

void send_can ()
{

      fflush (stdout);
      putc (CAN, stdout);

}

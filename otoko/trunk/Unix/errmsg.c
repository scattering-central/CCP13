/***********************************************************************
 *                          errmsg.c                                   *
 ***********************************************************************
 Purpose: Machine dependent FORTRAN to C interface for errmsg
 Authors: G.R.Mant
 Returns: Nil
 Updates: 01/11/89 Initial implementation

*/

#include <stdio.h>
#include <curses.h>
#include <term.h>

#ifdef titan                        /* stardent */
typedef struct {
    char *addr;
    int len;
} Str_Desc;

void ERRMSG (Str_Desc *mesg)
{
    errmsg (mesg->addr);
}

#else
#if defined(sgi) || defined(Sun) || defined(convex) || defined(Solaris) || defined (osf)
void errmsg (char *message);

void errmsg_ (char *mesg)
{
    errmsg (mesg);
}
#endif
#endif

void errmsg (char *message)
{
    static int once = 0;
    static int irc = 0;
    
    if (once == 0)
	setupterm (NULL, fileno(stdout), &irc);
		
    if (irc == 1)
	vidattr (A_REVERSE);
    
    fprintf (stdout, "%s\n", message);
    fflush (stdout);
    if (irc == 1)
	vidattr (A_NORMAL);
}

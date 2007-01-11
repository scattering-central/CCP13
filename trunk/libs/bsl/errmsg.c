/***********************************************************************
 *                          errmsg.c                                   *
 ***********************************************************************
 Purpose: Machine dependent FORTRAN to C interface for BSL errmsg
 Authors: G.R.Mant
 Returns: Nil
 Updates: 01/11/89 Initial implementation

*/

#ifdef TITAN                        /* STARDENT */
typedef struct {
    char *addr;
    int len;
} Str_Desc;

int ERRMSG (mesg)
Str_Desc *mesg;
{
    return (errmsg (mesg->addr));
}

#else
#ifndef __hpux                   /* SOLARIS , CONVEX , IRIX , LINUX */
int errmsg_ (mesg)
char *mesg;
{
    return (errmsg (mesg));
}
#endif
#endif
/***********************************************************************
 **                       errmsg.c                                    **
 ***********************************************************************
 Purpose: Display an error message using the terminal's standout mode
          (usually inverse video), in a terminal independent way using
          the setup defined in /etc/termcap.
 Authors: D.Hines & G.R.Mant
 Returns: int - < 0 failure else success.
 Limits : Escape sequences should not exceed 80 characters.
 Updates: 27/09/89 Initial implementation

*/

#include <stdio.h>

#ifdef OS9
extern char PC_;
#else
extern char PC;
#endif

extern char *UP;
extern char *BC;
extern short ospeed;
extern char *term;
extern char tcbuff[2048];
extern char *tgetstr();
extern void tputs ();

static int outc ();
static void terminit ();

int errmsg (message)
char *message;                                /* error message....       */
{
    int outc ();
    void terminit ();
    int err = -1;
    char *da_ptr;                             /* terminal capabilties    */

    static int sg = 0;                        /* magic cookie number     */
    static char *so = NULL;                   /* pointer to standout     */
    static char *se = NULL;                   /* pointer to end standout */
    static char *bl = NULL;                   /* bell                    */
    static char da_area[80];                  /* escape sequence buffer  */
           
    da_ptr = da_area;   
    if (term == NULL)                         /* initialise - once only  */
	terminit ();

    if (term != NULL)
    {
	sg = tgetnum ("sg");                  /* magic cookie terminal?  */
	so = tgetstr ("so", &da_ptr);         /* get standout entry      */
	se = tgetstr ("se", &da_ptr);         /* get end standout entry  */
	bl = tgetstr ("bl", &da_ptr);         /* bell                    */
	if (sg <= 0 && so != NULL && se != NULL)
	{
	    tputs (so, 1, outc);              /* output padding + so     */
	    (void) fputs (message, stdout);   /* output user message     */
	    tputs (se, 1, outc);              /* output padding + se     */
	    outc ('\n');
	    fflush (stdout);
	    err = 0;
	}
	else                                  /* cant do: normal display */
	{
	    (void) fprintf (stdout, "%s\n", message);
	    fflush (stdout);
	}
	if (bl != NULL) 
	    tputs (bl, 1, outc);              /* audible warning!!!!!!!! */
    }
  
    return (err);
}
/***********************************************************************
 **                       outc                                        **
 ***********************************************************************
 Purpose: Output a single character to the terminal.
 Authors: K.S.Turner.
 Returns: >= 0 Good result, < 0 error.
 Limits : Escape sequences should not exceed 80 characters.
 Updates: 12/11/89 Initial implementation.

*/

#include <stdio.h>

static int outc (c)          	              /* character to be output  */
char c;
{
    return (putc (c, stdout));
}
/***********************************************************************
 **                       terminit                                    **
 ***********************************************************************
 Purpose: Collect terminal padding ad output speed information.
 Authors: K.S.Turner.
 Params : PC - pad character, ospeed - output speed both set in function.
 Returns: None, term will be NULL if routine fails.
 Limits : Escape sequences should not exceed 80 characters.
 Updates: 12/11/89 Initial implementation.

*/

#include <stdio.h>

#ifdef OS9
#include <termcap.h>
#include <sgstat.h>
#else
#if defined TITAN || IRIX || LINUX || __hpux
#include <termio.h>
#else
#include <sgtty.h>
#endif
#endif


extern char *tgetstr ();
extern char *getenv ();
extern int tgetent ();
extern int tgetnum ();

#ifdef OS9
char PC_;
#else
char PC;
#endif

short ospeed;
char *BC;
char *UP;
char *term = NULL;
char tcbuff[2048];

static void terminit ()
{
	
#ifdef OS9
    struct sgbuf usertty;
#else
#if defined TITAN || IRIX || LINUX || __hpux
    struct termio usertty;
#else
    struct sgttyb usertty;
#endif
#endif
    char *pc, *da_ptr, da_area[80];

    da_ptr = da_area;
    if ((term = getenv ("TERM")) != NULL)
    {
	if (tgetent (tcbuff, term) == 1)
	{
	    pc = tgetstr ("pc", &da_ptr);
#ifdef OS9
	    UP = tgetstr ("up", &da_ptr);
	    BC = tgetstr ("bc", &da_ptr);
	    PC_ = (pc != NULL) ? *pc : '\0';
	    if (_gs_opt (1, &usertty) >= 0)
		ospeed = usertty.sg_baud;

#else
#if defined TITAN || IRIX || LINUX || __hpux

	    PC = (pc != NULL) ? *pc : '\0';
	    if (ioctl (0, TCGETA, &usertty) >=0 )
		ospeed = usertty.c_cflag & 017;
#else	
	    PC = (pc != NULL) ? *pc : '\0';
	    if (ioctl (0, TIOCGETP, (char *) &usertty) >= 0)
		ospeed = usertty.sg_ospeed;
#endif
#endif
	}
    }

}

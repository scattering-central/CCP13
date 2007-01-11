/***********************************************************************
 **                       igets.c                                     **
 ***********************************************************************

 Purpose: C version of IGETS.F to mimic Fortran read and which handles
          EOF in the correct method compatible with VAX VMS. Selection
          of EOF character is left to the user to set with UNIX command.
 Authors: G.R.Mant
 Returns: Null for EOF, else -1
 Updates: 14/11/89 Initial implementation

*/

#include <stdio.h>

#ifdef TITAN                            /* Ardent - titan */

typedef struct { char* addr;
                 int   length;
               } str_desc;


int IGETS (iterm, string)
int  *iterm;                             /* not used in C implementation */
str_desc* string;
{
   get_string (string->addr, string->length);
}

#else
#   if defined (AIX) || defined (__hpux)      /* IBM, HP   */

int igets (iterm, string, length)
int  *iterm;    /* not used in C implementation */ 
char *string;
int *length;
{
   return (get_string (string, *length));
}

#   else                                   /* CONVEX , SOLARIS , IRIX , LINUX */

int igets_ (iterm, string, length)
int  *iterm;                             /* not used in C implementation */
char *string;
int *length;
{
   return (get_string (string, *length));
}

#   endif
#endif

int get_string (buff, n)                /* hopefully machine indepenent */
char *buff;
int  n;
{
    char *ptr;
    int i, nline;

    ptr = buff;
    if (fgets (buff, n, stdin) == NULL)
    {
       clearerr (stdin);
       fflush (stdin);
       return (0);
    }

    if (feof (stdin))
    {
       clearerr (stdin);
       fflush (stdin);
       printf ("\n");
       return (0);
    }
    else
    {
       nline = 0;
       for (i=0; i<n; i++, ptr++)
       {
	  if (*ptr == '\n')
	     nline = 1;
	  if (nline)
	     *ptr = ' ';
       }
       
       fflush (stdout);
       clearerr (stdin);
       fflush (stdin);
       return (-1);

   }

}









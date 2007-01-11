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
#ifdef titan                            /* Ardent - titan */

typedef struct { char* addr;
                 int   length;
               } str_desc;

int IGETS (iterm, string)
int  iterm;                             /* not used in C implementation */
str_desc* string;
{
   get_string (string->addr, string->length);
}

#else                                   /* Convex, Sun, Iris */

int igets_ (iterm, string, length)
int  iterm;                             /* not used in C implementation */
char *string;
int length;
{
   return (get_string (string, length));
}

#endif

int get_string (buff, n)                /* hopefully machine indepenent */
char *buff;
int  n;
{
    char *ptr, c;
    int i, j;

    i=0;
    ptr = buff;
    while ((c=getc(stdin)) != (char) EOF && c != '\n')
	if (i++ < n) *ptr++ = c;        /* put character in fortran string */

    for (j=i; j<n; j++)
        *ptr++ = ' ';                   /* fill fortran buffer with blanks */
    if (c == '\n')
        return (-1);       		/* set return code                 */

    printf ("\n");                      /* force new line for EOF          */

#ifdef sun
    fflush (stdout);
    clearerr (stdin);
#endif

    return (0);
}

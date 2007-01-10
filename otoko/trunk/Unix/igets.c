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

int IGETS (int iterm, str_desc *string)
{
   get_string (string->addr, string->length);
}

#else
#ifdef hpux

int igets (int iterm, char *string, int length)
{
   return (get_string (string, length));
}
#else
int igets_ (int iterm, char *string, int length)
{
   return (get_string (string, length));
}
#endif
#endif

int get_string (char *buff, int n)     /* hopefully machine indepenent */
{
    char *ptr, c;
    int i, j;

    i=0;
    ptr = buff;
    while ((c=getc(stdin)) != (char) EOF && c != '\n')
	if (i++ < n) *ptr++ = c;        /* put character in fortran string */

    for (j=i; j<n; j++)
        *ptr++ = ' ';                   /* fill fortran buffer with blanks */

    if ((buff[0] == '^') &&
	(buff[1] == 'D' || buff[1] == 'd'))
	return (0);

    if (c == '\n')
        return (-1);       		/* set return code                 */

    printf ("\n");                      /* force new line for EOF          */

#if defined sun || sgi
    fflush (stdout);
    clearerr (stdin);
#endif

    return (0);
}

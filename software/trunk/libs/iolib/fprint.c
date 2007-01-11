#include <stdio.h>

#if defined (AIX) || defined (__hpux)

#define SETNNL setnnl
#define GETNNL getnnl
#define STROUT strout

#else

#define SETNNL setnnl_
#define GETNNL getnnl_
#define STROUT strout_

#endif

static char nonl = '$';

void SETNNL (char *);
void GETNNL (char *);
void STROUT (char *, int *);

void SETNNL (char *newnnl)
{
  if (newnnl != NULL)
    {
      if (*newnnl == ' ')
	nonl = '$';
      else
	nonl = *newnnl;
    }
  return; 
}

void GETNNL (char *curnnl)
{
  if (curnnl != NULL)
    *curnnl = nonl;

  return;
}

void STROUT (char *str, int *len)
{
  int i;
  char *cptr;

  if (str == NULL)
    return;

  for (i = *len - 2; i >= 0; i--)
    {
      cptr = str + i;
      if (*cptr != ' ')
	{
	  if (*cptr == nonl)
	    {      
	      *cptr = '\0';
	      fprintf (stdout, "%s", str);
	    }
	  else
	    {
	      *(cptr + 1) = '\0';
	      fprintf (stdout, "%s\n", str);
	    }
	  break;
	}
    }

  fflush (stdout);
  return;
}










#include <time.h>
#include <string.h>

#ifdef AIX
#   define STRTIM STRTIM
#elif defined (__hpux)
#   define STRTIM strtim
#else      /* SOLARIS , CONVEX , IRIX , LINUX */ 
#   define STRTIM strtim_
#endif

void STRTIM (char *, int *);

void STRTIM (char *string, int *maxlen)
{
  time_t t = time (NULL);
  size_t s = strftime (string, (size_t) *maxlen, "%c", localtime (&t));
  int i;

  for (i = (int) strlen (string); i < *maxlen; i++)
    *(string + i) = ' ';
}

#include <sys/types.h>
#include <unistd.h>

#if defined (AIX) 
#   define PROCID PROCID
#elif  defined (__hpux)
#   define PROCID procid
#else      /* SOLARIS , CONVEX , IRIX , LINUX */ 
#   define PROCID procid_
#endif

void PROCID (int *);

void PROCID (int *iproc)
{
  *iproc = (int) getpid ();
}

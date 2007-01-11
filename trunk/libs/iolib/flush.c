/* Simple Fortran flush for HP */

#include <stdio.h>

void flush (int *);

void flush (int *unit)
{
  switch (*unit)
    {
    case 0:
    case 6:
      fflush (stderr);
      fflush (stdout);
    default:
      break;
    }
}

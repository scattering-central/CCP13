#include <stdio.h>

#ifdef titan

#define GETMEM  GETMEM
#define FREMEM  FREMEM

#elif defined (AIX) || defined (__hpux)

#define GETMEM  getmem
#define FREMEM  fremem

#else

#define GETMEM  getmem_
#define FREMEM  fremem_

#endif

int  GETMEM (long int *, long int *);
void FREMEM (long int *);

/*      Replacement for %val when using f2c      */
#define PVAL    pval_
void *PVAL (long int *);

/*
	Fortran callable memory allocator

	Called as :
		ier = GETMEM (size, pointer)

	where : size is an integer size of memory to allocate
		pointer is an integer to return the pointer into

*/
int GETMEM (long int *size, long int *pointer)
{
    void *area;

    area = (void *) malloc (*size);
    if (area == (void *) NULL) return (0);
    *pointer = (long int) area;
    return (1);
}

/*
	Fortran callable memory deallocator

	Called as :
		call FREMEM (pointer)

	where : pointer is an integer that contains the pointer

*/
void FREMEM (long int *pointer)
{
    void *area = (void *) *pointer;

    free (area);
    return;
}

void *PVAL (long int *pointer)
{
  return ((void *) *pointer);
}

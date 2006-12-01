/***********************************************************************
 * 
 * pck1
 *
 * Copyright by:	Dr. Claudio Klein
 * 			X-ray Research GmbH, Hamburg
 * Pck format by:	Dr. J.P. Abrahams
 *			LMB, MRC Cambridge, UK
 *
 * Version: 	1.0 
 * Date:	12/02/1997
 *
 **********************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <math.h>
#include <ctype.h>
#include <string.h>

#define BYTE char
#define WORD  short int
#define LONG int

#define MAX_NON_OVERFLOW 65535
#define FPOS(a)          ((int)( a/8. + 0.875 )*64)

#define PACKIDENTIFIER "\nCCP4 packed image, X: %04d, Y: %04d\n"
#define PACKBUFSIZ BUFSIZ
#define DIFFBUFSIZ 16384L
#define max(x, y) (((x) > (y)) ? (x) : (y))
#define min(x, y) (((x) < (y)) ? (x) : (y))
#define abs(x) (((x) < 0) ? (-(x)) : (x))
const LONG setbits[33] = {0x00000000L, 0x00000001L, 0x00000003L, 0x00000007L,
			  0x0000000FL, 0x0000001FL, 0x0000003FL, 0x0000007FL,
			  0x000000FFL, 0x000001FFL, 0x000003FFL, 0x000007FFL,
			  0x00000FFFL, 0x00001FFFL, 0x00003FFFL, 0x00007FFFL,
			  0x0000FFFFL, 0x0001FFFFL, 0x0003FFFFL, 0x0007FFFFL,
			  0x000FFFFFL, 0x001FFFFFL, 0x003FFFFFL, 0x007FFFFFL,
			  0x00FFFFFFL, 0x01FFFFFFL, 0x03FFFFFFL, 0x07FFFFFFL,
			  0x0FFFFFFFL, 0x1FFFFFFFL, 0x3FFFFFFFL, 0x7FFFFFFFL,
                          0xFFFFFFFFL};
#define shift_left(x, n)  (((x) & setbits[32 - (n)]) << (n))
#define shift_right(x, n) (((x) >> (n)) & setbits[32 - (n)])

/******************************************************************************/

/* Some fortran compilers require c-functions to end with an underscore. */

#if defined(_AIX) || defined(__hpux)
/* no underscore by default */
#else
#  if defined (VMS) || defined (vms) || defined (__vms) || defined (__VMS)\
      || defined (ardent) || defined (titan) || defined (stardent)
#    define openpckfile OPENFILE
#  else
#    define openpckfile openfile_
#  endif
#endif

/******************************************************************************/
/*
 * Function prototypes
 */
static void 	get_pck		(FILE *,           WORD *);
static void 	unpack_wordmar	(FILE *, int, int, WORD *);
static void 	rotate_clock90	(WORD *, int);
static void 	swaplong	( int*, int );
extern WORD *		openpckfile	(FILE *);
extern  int getimagesize(FILE *);

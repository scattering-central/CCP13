#ifndef BSL_GOT_TYPES
#define BSL_GOT_TYPES

#include "Configure.h"

/************************************/
/* 8 bit char                       */
/************************************/

#if(SIZEOF_CHAR==1)
  typedef signed char BSL_CHAR8;
  typedef unsigned char BSL_UCHAR8;
#else
#  error SIZEOF_CHAR must be 1!
#endif

/************************************/
/* 16 bit int                       */
/************************************/

#if(SIZEOF_SHORT==2)
  typedef signed short BSL_INT16;
  typedef unsigned short BSL_UINT16;
#else
#if(SIZEOF_INT==2)
  typedef signed int BSL_INT16;
  typedef unsigned int BSL_UINT16;
#else
#  error Neither SIZEOF_SHORT nor SIZEOF_INT is 2!
#endif
#endif

/************************************/
/* 32 bit int                       */
/************************************/

#if(SIZEOF_LONG==4)
  typedef signed long BSL_INT32;
  typedef unsigned long BSL_UINT32;
#else
#if(SIZEOF_INT==4)
  typedef signed int BSL_INT32;
  typedef unsigned int BSL_UINT32;
#else
#  error Neither SIZEOF_LONG nor SIZEOF_INT is 4!
#endif
#endif

/************************************/
/* 64 bit int                       */
/************************************/
#ifndef DESIGN_TIME
#if(SIZEOF_LONG==8)
  typedef signed long BSL_INT64;
  typedef unsigned long BSL_UINT64;
#else
#if(SIZEOF_LONG_LONG==8)
  typedef signed long long BSL_INT64;
  typedef unsigned long long BSL_UINT64;
#else
#  error Neither SIZEOF_LONG nor SIZEOF_LONG_LONG is 8!
#endif
#endif
#endif

/************************************/
/* 32 bit float                     */
/************************************/

#if(SIZEOF_FLOAT==4)
  typedef float BSL_FLOAT32;
#else
#  error SIZEOF_FLOAT must be 4!
#endif

/************************************/
/* 64 bit float                     */
/************************************/

#if(SIZEOF_DOUBLE==8)
  typedef double BSL_FLOAT64;
#else
#  error SIZEOF_DOUBLE must be 8!
#endif

#endif

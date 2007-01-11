/*******************************************************************************
 *                             readc.h                                         * 
 ******************************************************************************* 
 Purpose: Include file for readc.c
 Author:  R.C.Denny
 Returns:
 Updates:
 19/01/94 RCD Initial implementation
 
*/
 
#ifdef TITAN
typedef struct {
        char * addr;
        int len;
      } Str_Desc;
#else
#define Str_Desc char
#endif
 
#define MAXC 132
#define MAXL 5
#define MAXFILES  10
 
int rdcomc (FILE *, char **, int *, float *, int *, int *, int, int);
int upc (char *);
int optcmp (char *, char **);
 
#ifdef TITAN
 
#define RDCOMF    RDCOMF
#define FILEOPEN  FILEOPEN
#define FILECLOSE FILECLOSE
#define OPTCMPF   OPTCMPF
 
#elif defined (AIX) || defined (__hpux)
 
#define RDCOMF    rdcomf
#define FILEOPEN  fileopen
#define FILECLOSE fileclose
#define OPTCMPF   optcmpf
 
#else
 
#define RDCOMF    rdcomf_
#define FILEOPEN  fileopen_
#define FILECLOSE fileclose_
#define OPTCMPF   optcmpf_
 
#endif
 
void RDCOMF (int *, Str_Desc *, int *, float *, int *, int *, int *, int *, 
             int *, int *);
void FILEOPEN (int *, Str_Desc *, int *, int *);
void FILECLOSE (int *);
void OPTCMPF (Str_Desc *, int *, Str_Desc *, int *, int *, int *);

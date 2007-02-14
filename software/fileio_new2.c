/***********************************************************************
 *                          fileio_dev.c                               *
 ***********************************************************************
 Purpose: Machine dependent FORTRAN to C interface for BSL file I/O
 Authors: G.R.Mant
 Returns: Nil
 Updates: 01/11/89 Initial implementation
          04/07/97 Memory mapping added

*/
#include <stdio.h>
#include <unistd.h>
#ifdef MMAP
#include <sys/mman.h>
#endif
#include <errno.h>
#include "bsl.h"

#ifdef TITAN

#  define rframe	RFRAME
#  define wframe	WFRAME
#  define opnfil	OPNFIL
#  define opnnew	OPNNEW
#  define fcls	        FCLOSE
#  define outfil	OUTFIL
#  define timer	        TIMER
#  define rdhdr	        RDHDR

#else
# if defined (AIX) || defined (__hpux)

#    define rframe	rframe
#    define wframe	wframe
#    define opnfil	opnfil
#    define opnnew	opnnew
#    define fcls	fcls
#    define outfil	outfil
#    define timer	timer
#    define rdhdr	rdhdr

#  else    /* SOLARIS , CONVEX , IRIX , LINUX */                   

#    define rframe	rframe_
#    define wframe	wframe_
#    define opnfil	opnfil_
#    define opnnew	opnnew_
#    define fcls	fclose_
#    define outfil	outfil_
#    define timer	timer_
#    define rdhdr	rdhdr_

#  endif
#endif

#ifdef TITAN
typedef struct {
    char *addr;
    int len;
} Str_Desc;
#else
#define Str_Desc char
#endif

#include <sys/types.h>
#ifdef __hpux
#   include <time.h>
#else
#   include <sys/time.h>
#endif

void timer (void);
void rframe (int *, int *, int *, int *, long int *, int *);
void wframe (int *, int *, int *, int *, void *, int *);
void opnfil (int *, Str_Desc *, int *, int *, int *, int *, int *, int *, int *, int *);
void opnnew (int *, int *, int *, int *, Str_Desc *, int *, Str_Desc *, Str_Desc *, int *);
void outfil (int *, int *, Str_Desc *, Str_Desc *, Str_Desc *, int *);
void rdhdr  (Str_Desc*, Str_Desc*, int *, int *, int *, int *, int *, int *, int *);
void fcls   (int *);

int rframe_c (int, int, int, int, void **);
int wframe_c (int, int, int, int, void *);
int opnfil_c (char *, int, int, int *, int *, int *);
int opnnew_c (int, int, int, char *, char *, char *);
int outfil_c (char *, char *, char *);
int rdhdr_c  (char *, char *, int, int, int *, int *, int *);

static int hdrgen (int, int, int, char *, char *, char *);

static int fendian;
static int dtype;

void timer (void)
{
     time_t *tloc = '\0';

     printf ("time in seconds since midnight is %d\n", time (tloc));
     return;
}

void rframe (int *fd, int *frame, int *npix, int *nrast, long int *pointer, int *irc)
{
    void *buff;

    *irc = ReadFrame (*fd, *frame, *npix, *nrast, &buff);
    *pointer = (long int) buff;
    return;
}

void wframe (int *fd, int *frame, int *npix, int *nrast, void *buff, int *irc)
{
    *irc = wframe_c (*fd, *frame, *npix, *nrast, buff);
    return;
}

void opnfil (int *fd, Str_Desc *filename, int *ispec, int *filenum, int *iffr,
	     int *ilfr, int *npix, int *nrast, int *nframe, int *irc)
{
int i;

#ifdef TITAN
    char *fnam = filename->addr;
#else
    char *fnam = filename;
#endif

i=0;
do
{
  if(fnam[i]==' ')
  {
     fnam[i]='\0';
     break;
  }
  i++;
}while(fnam[i]);

    if ((*fd = opnfil_c (fnam, *ispec, *filenum, npix, nrast, nframe)) == -1)
	*irc = 1;
    else
	*irc = 0;

    return;
}

void opnnew (int *fd, int *npix, int *nrast, int *nframe, Str_Desc *filename,
	     int *filenum, Str_Desc *title1, Str_Desc *title2, int *irc)
{
int i;

#ifdef TITAN
    char *fnam = filename->addr;
    char *titl1 = title1->addr;
    char *titl2 = title2->addr;
#else
    char *fnam = filename;
    char *titl1 = title1;
    char *titl2 = title2;
#endif
    *(titl1 + 79) = '\0';
    *(titl2 + 79) = '\0';

    i=0;
    do
    {
      if(fnam[i]==' ')
      {
        fnam[i]='\0';
        break;
      }
      i++;
    }while(fnam[i]);


    if ((*fd = opnnew_c (*npix, *nrast, *nframe, fnam, titl1, titl2)) == -1)
	*irc = 1;
    else
	*irc = 0;

    return;
}

void rdhdr (Str_Desc *filename, Str_Desc *binary, int *ispec, int *filenum, 
		  int *iunit, int *npix, int *nrast, int *nframe, int *irc)
{
int i;

#ifdef TITAN
    char *fnam = filename->addr;
    char *biny = binary->addr;
#else
    char *fnam = filename;
    char *biny = binary;
#endif
    *(biny + 10) = '\0';

    i=0;
    do
    {
      if(fnam[i]==' ')
      {
        fnam[i]='\0';
        break;
      }
      i++;
    }while(fnam[i]);
    
    if (rdhdr_c (fnam, biny, *ispec, *filenum, npix, nrast, nframe))
	*irc = 0;
    else
	*irc = 1;

    return;
}

void fcls (int *fd)
{
    close (*fd);
    *fd = -1;
    return;
}

void outfil (int *iterm, int *iprint, Str_Desc *filename,
	     Str_Desc *title1, Str_Desc *title2, int *irc)
{
#ifdef TITAN
    char *fnam = filename->addr;
    char *titl1 = title1->addr;
    char *titl2 = title2->addr;
#else
    char *fnam = filename;
    char *titl1 = title1;
    char *titl2 = title2;
#endif
    if ((outfil_c (fnam, titl1, titl2)) == -1)
	*irc = 1;
    else
	*irc = 0;

    return;
}
/***********************************************************************
 *                              rframe.c                               *
 ***********************************************************************
 Purpose: Read a frame of image data
 Author:  G.R.Mant
 Returns: TRUE or FALSE
 Updates: Initial C implementation 24/07/91
 18/08/94 RCD: Modified to use memory mapping for reading binary input
*/

#if defined(__hpux) || defined(IRIX) || defined(TITAN) || defined (AIX) || defined (LINUX)
#  include <fcntl.h>
#  include <ctype.h>
#else
#  ifdef ULTRIX
#    include <sys/file.h>
#  else
#    ifdef SOLARIS
#      include <sys/fcntl.h>
#    else
#      include <sys/fcntlcom.h>
#    endif
#  endif
#endif
#include <unistd.h>
#include <sys/mman.h>
#ifdef __hpux
#   define _SC_PAGESIZE _SC_PAGE_SIZE
#endif
#define OK	0
#define ERROR	-1
#define FALSE	0
#define TRUE	!FALSE
#define PMODE	0664

int rframe_c (int fd, int frame, int npix, int nrast, void **buff)
{
    int nbytes = npix*nrast*sizeof (float);	/* Nos of bytes to read */
    long offset = (frame - 1) * nbytes;	        /* Offset from start	*/
    int c;                                      /* Actual bytes read    */

#ifdef MMAP

    int psize = sysconf (_SC_PAGESIZE);         /* System page size     */
    char *tmp;
    off_t off;

    off = (off_t) (offset - offset % psize);
    nbytes += offset - off;

    if ((tmp = (char *) mmap ((void *) 0, (size_t) nbytes, PROT_READ, MAP_SHARED, 
			      fd, off)) == (caddr_t) -1)
    {
        perror ("mmap");
	return (ERROR);
    }

    *buff = (void *) (tmp + offset - off);

#else

    if ((lseek (fd, offset, SEEK_SET)) == ERROR)
    {
	errmsg ("Error: Unable to access specified frame number");
	return (ERROR);
    }

    if (!(*buff = (void *) malloc (nbytes)))
    {
        errmsg ("Error: Unable to allocate sufficient memory");
	return (ERROR);
    }

    if ((c = read (fd, *buff, nbytes)) != nbytes)
    {
	errmsg ("Error: Reading frame of binary data");
	return (ERROR);
    }

#endif

    return (OK);
}
/***********************************************************************
 *                              wframe.c                               *
 ***********************************************************************
 Purpose: Write sequential frames of image data.
 Author:  G.R.Mant
 Returns: TRUE or FALSE
 Updates: Initial C implementation 24/07/91
*/

int wframe_c (int fd, int frame, int npix, int nrast, void *buff)
{
    int nbytes = npix*nrast*sizeof (float);	/* No of bytes to write */
    int c;					/* Actual bytes written */

#ifdef MMAP_WRITE

    char *cbuf = (char *) buff;
    char *tmp;
    int i;

    if ((tmp = (char *) mmap ((void *) 0, (size_t) nbytes, PROT_WRITE, MAP_SHARED,
			      fd, (off_t) 0)) == (caddr_t) -1)
    {
        perror ("mmap");
	return (ERROR);
    }
    
    for (i=0; i<nbytes; i++)
    {
        *tmp++ = *cbuf++;
    }

    if ((c = munmap ((void *) tmp, (size_t) nbytes)) == -1)
    {
        perror ("munmap");
	return (ERROR);
    }

#else

    if ((c = write (fd, buff, nbytes)) != nbytes)
    {
	errmsg ("Error: Writing frame of binary data");
	return (ERROR);
    }

#endif

    return (OK);
}
/***********************************************************************
 *                              opnfil.c                               *
 ***********************************************************************
 Purpose: Open a binary dataset
 Author:  G.R.Mant
 Returns: file descriptor number else -1
 Updates: Initial C implementation 24/07/91
*/

int opnfil_c (char *filename, int ispec, int filenum, int *npix, int *nrast, int *nframe)
{
    char binary[80];
    int fd;

    if (!(rdhdr_c (filename, binary, ispec, filenum, npix, nrast, nframe)))
    {
	errmsg ("Error: Header file not found");
	return (ERROR);
    }	
    if ((fd = open (binary, O_RDONLY)) == ERROR)
    {
	errmsg ("Error: Unable to open binary file");
	return (ERROR);
    }	
    return (fd);
}
/***********************************************************************
 *                              opnnew.c                               *
 ***********************************************************************
 Purpose: Open a binary dataset for output
 Author:  G.R.Mant
 Returns: file descriptor number else -1
 Updates: Initial C implementation 24/07/91
*/

int opnnew_c (int npix, int nrast, int nframe, char *filename,
	      char *title1, char *title2)
{
    int fd,i,iflag;
    char *cptr;

    i=0;
    iflag=0;
    do
    {
      if(filename[i]=='/')iflag=i;
      i++;
    }while(filename[i]);

    if(iflag)
      cptr=filename+iflag+1;
    else
      cptr = filename;

    while (*cptr != '\0')
    {
	if (islower(*cptr))
	    *cptr = toupper(*cptr);
	cptr++;
    }

    if (!(hdrgen (npix, nrast, nframe, filename, title1, title2)))

	return (ERROR);
		
    if ((fd = creat (filename, PMODE)) == ERROR)
    {
	errmsg ("Error: Unable to create output binary file");
	return (ERROR);
    }	
    return (fd);
}
/***********************************************************************
 *                              hdrgen.c                               *
 ***********************************************************************
 Purpose: Output header file.
 Author:  G.Mant
 Returns: TRUE for successful, else FALSE 
 Updates: Initial C implementation 27/11/89
 
*/

static int hdrgen (int npix, int nrast, int nframe, char *filename,
		   char *title1, char *title2)
{
    int indice[10], i, iflag;
    FILE *fp, *fpopen ();
	
    for (i=0; i<10; i++)
	indice[i]=0;

    if ((fp = fopen (filename, "w")) == NULL)
    {
	errmsg ("Error: Unable to open header dataset");
	return (FALSE);
    }
    else
    {
	fprintf (fp, "%s\n", title1);
	fprintf (fp, "%s\n", title2);

	indice[0] = npix;
	indice[1] = nrast;
	indice[2] = nframe;
        indice[3] = endian();

	for (i=0; i<10; i++)
	    fprintf (fp, "%8d", indice[i]);

        i=0;
        iflag=0;
	do
	{
          if(filename[i]=='/')iflag=i;
          i++;
        }while(filename[i]);

        if(iflag)filename=filename+iflag+1;
	
	*(filename+strlen(filename) - 5) = '1';
	fprintf (fp, "\n%s\n", filename);
		
	fclose (fp);
	return (TRUE);
    }
}
/***********************************************************************
 *                          rdhdr.c                                    *
 ***********************************************************************
 Purpose: Read the header file for the associated binary file,
          corresponding to the file number.
 Author : G.R.Mant
 Returns: TRUE or FALSE;
 Updates:
 24/07/91 GRM Initial C implementation
*/ 
#define MAXLIN 120
 
int rdhdr_c (char *filename, char *binary, int ispec, int filenum, 
		  int *npix, int *nrast, int *nframe)
{
    char buff[MAXLIN+1], *cptr;
    register int i = 0;
    register int j = 0;
    FILE *fp, *fopen ();
    char binpluspath[81];

    for(j=strlen(filename);j>=0;j--)
    {
      if(filename[j]=='/')
      {
        break;
      }
    }
    j++;

    strcpy(binpluspath,"");

    if (ispec > 0)
    {
	cptr =&filename[j];
         *++cptr = (ispec / 10000) + '0';
         *++cptr = ((ispec % 10000) / 1000) + '0';
    }


    if ((fp = fopen (filename, "r")) == NULL)
	return (FALSE);
    else
    {
	if ((fgets (buff, MAXLIN, fp)) == NULL)
	    return (FALSE);
	else if ((fgets (buff, MAXLIN, fp)) == NULL)
	    return (FALSE);
	else
	{
	    do {
	       if ((fgets (buff, MAXLIN, fp)) == NULL)
		   return (FALSE);
               else if (sscanf (buff, "%8d%8d%8d%8d%8d", npix, nrast, nframe,
                                &fendian,&dtype) != 5)
                   return (FALSE); 	       
               else if ((fgets (binary, MAXLIN, fp)) == NULL)
		   return (FALSE);
	    }
	    while (++i < filenum);
	}

	*(binary+10) = '\0';	/* Remove new line character */

        if(j)
        {
          strncpy(binpluspath,filename,j);
          binpluspath[j]='\0';
          strcat(binpluspath,binary);
          strcpy(binary,binpluspath);
        }

        fclose (fp);	
	return (TRUE);
    }
}

/***********************************************************************
 *                             outfil.c                                *
 ***********************************************************************
 Purpose: Get header filename and title records from terminal.
 Author:  G.R.Mant
 Returns: TRUE or FALSE
 Updates: Initial C implementation 24/07/91
*/

int outfil_c (char *filename, char *title1, char *title2)
{
    int len,i,iflag;
    char* filedum;

    do {
	printf ("Enter output filename [Xnn000.xxx]: ");
	fflush (stdout);
	if (fgets (filename, 80, stdin) == NULL || feof (stdin))
	{
	    fflush (stdin);
	    clearerr (stdin);
	    printf ("\n");
	    fflush (stdout);
	    return (ERROR);
	}

     i=0;
     iflag=0;
     do
     {
       if(filename[i]=='/')iflag=i;
       i++;
     }while(filename[i]);

     if(iflag)
     {
       filedum=filename;
       filename=filename+iflag+1;
     }

	len = strlen (filename);
	*(filename + --len) = '\0';	/* Remove new line character */

	if (strcmp (filename, "^D") == 0)
	  {
	    fflush (stdin);
	    clearerr (stdin);
	    printf ("\n");
	    fflush (stdout);
	    return (ERROR);
	  }

	if (len != 10)
	    errmsg ("Error: Invalid header filename");
	else
	{

#ifdef VMS
	    *(filename+len) = ';';
	    *(filename+len+1) = '1';
	    *(filename+len+2) = '\0';		
#endif

	    if (isalpha (*filename) && isdigit(*(filename+1)) &&
		isdigit (*(filename+2)) && *(filename+3) == '0' &&
		*(filename+4) == '0' && *(filename+5) == '0' &&
		*(filename+6) == '.')
		break;
	    else
		errmsg ("Error: Invalid header filename");
	}
    }	
    while (1);

    filename=filedum;

    printf ("Enter first header: ");
    fflush (stdout);
    if (fgets (title1, 80, stdin) == NULL)
    {
        fflush (stdin);
	clearerr (stdin);
	printf ("\n");
	fflush (stdout);
	return (ERROR);
    }

    len = strlen (title1);
    *(title1 + --len) = '\0';		/* Remove new line character */

    printf ("Enter second header: ");
    fflush (stdout);
    if (fgets (title2, 80, stdin) == NULL)
    {
        fflush (stdin);
	clearerr (stdin);
	printf ("\n");
	fflush (stdout);
	return (ERROR);
    }

    len = strlen (title2);
    *(title2 + --len) = '\0';		/* Remove new line character */

    fflush (stdin);
    fflush (stdout);   
    clearerr (stdin);
    return (OK);
}

/***********************************************************************
 *                               ReadFrame.c                           *
 ***********************************************************************
 Purpose: Read a frame of image data
 Author:  G.R.Mant
 Returns: Pointer to data buffer on success, NULL pointer on failure
 Updates: Initial C implementation 17/03/92
*/


int ReadFrame (int fd, int frame, int npix, int nrast, void** dptr)
{
    int psize = getpagesize();                 /*   System page size   */
    int swab = fendian ^ endian ();            /*   Byte swap flag     */
    int nbytes, dsize, offset, ntotal, c, i;
    off_t off;
    caddr_t tmp, ctmp;
    float *ftmp;

    switch (dtype)
    {
        case FLOAT:
           dsize = sizeof (float);
           break;

        case CHAR:
        case UCHAR:
           dsize = sizeof (char);
           break;

        case SHORT16:
        case USHORT16:
	   dsize = sizeof (short);
	   break;

        case LONG32:
        case ULONG32:
	   dsize = sizeof (long);
	   break;

        default:
	   errmsg ("Error: Data type not supported");
	   return (ERROR);
    }

    nbytes = npix * nrast * dsize;
    offset = (frame - 1) * nbytes;

#ifdef MMAP
    off = (off_t) (offset - offset % psize);
    nbytes += offset - off;

    if ((tmp = mmap ((void *) 0, (size_t) nbytes, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, off))
	== (caddr_t) -1)
    {
        errmsg ("Error: Unable to map specified frame number");
	return (ERROR);
    }
    
    *dptr = (void *) (tmp + offset - off);

#else 
    if ((tmp = (caddr_t) malloc (nbytes)) == NULL)
    {
       errmsg ("Error: Unable to allocate enough memory to read file");
       return (ERROR);
    }

    if ((lseek (fd, offset, SEEK_SET)) == BSLERR)
    {
	errmsg ("Error: Unable to access specified frame number");
	return (ERROR);
    }
    if ((c = read (fd, tmp, nbytes)) != nbytes)
    {
	errmsg ("Error: Reading frame of binary data");
	return (ERROR);
    }

    *dptr = (void *) tmp;

#endif

    ntotal = npix * nrast;
    ctmp = tmp;

    if (dtype != FLOAT)
    {
       if ((*dptr = (void *) malloc (ntotal * sizeof (float))) == NULL)
       {
	  errmsg ("Error: Unable to allocate enough memory for data buffer");
	  return (ERROR);
       }
       ftmp = (float *) *dptr;
    }

    switch (dtype)
    {
       case FLOAT:
          if (swab)
	     swablong (*dptr, ntotal);
          return (OK);

       case CHAR:
	  for (i=0; i<ntotal; i++, tmp += dsize)
	      *ftmp++ = (float) *((char *) tmp);
	  break;

       case UCHAR:
	  for (i=0; i<ntotal; i++, tmp += dsize)
	      *ftmp++ = (float) *((unsigned char *) tmp);
	  break;

       case SHORT16:
	  if (swab)
	     swabshort ((void*)tmp, ntotal);
	  for (i=0; i<ntotal; i++, tmp += dsize)
	      *ftmp++ = (float) *((short *) tmp);
	  break;

       case USHORT16:
	  if (swab)
	     swabshort ((void*)tmp, ntotal);
	  for (i=0; i<ntotal; i++, tmp += dsize)
	      *ftmp++ = (float) *((unsigned short *) tmp);
	  break;

       case LONG32:
	  if (swab)
	     swablong ((void*)tmp, ntotal);
	  for (i=0; i<ntotal; i++, tmp += dsize)
	      *ftmp++ = (float) *((long *) tmp);
	  break;

       case ULONG32:
	  for (i=0; i<ntotal; i++, tmp += dsize)
	      *ftmp++ = (float) *((unsigned long *) tmp);
	  if (swab)
	     swablong (*dptr, ntotal);
	  break;
    }


#ifdef MMAP
    if (munmap (ctmp, nbytes) == BSLERR)
    {
        errmsg ("Error: Unable to unmap data");
    }
    
#else
    free (ctmp);

#endif

    return (OK);

}


int endian () 
{
    short int one = 1;
    return ((int) *(char *) &one); 
}

void swabshort (void *vp, int n)
{
    unsigned short *sp = (unsigned short *) vp;
    unsigned char *cp;
    int t;

    while (n-- > 0)
    {
       cp = (unsigned char*) sp;
       t = cp[1]; cp[1] = cp[0]; cp[0] = t;
       sp++;
    }
       
}

void swablong (void *vp, int n)
{
    unsigned long *lp = (unsigned long *) vp;
    unsigned char *cp;
    int t;

    while (n-- > 0)
    {
       cp = (unsigned char *) lp;
       t = cp[3]; cp[3] = cp[0]; cp[0] = t;
       t = cp[2]; cp[2] = cp[1]; cp[1] = t;
       lp++;
    }
}


/***********************************************************************
 *                          fileio.c                                   *
 ***********************************************************************
 Purpose: Machine dependent FORTRAN to C interface for BSL file I/O
 Authors: G.R.Mant
 Returns: Nil
 Updates: 01/11/89 Initial implementation

*/
#include <stdio.h>

#ifdef titan

#define rframe	RFRAME
#define wframe	WFRAME
#define opnfil	OPNFIL
#define opnnew	OPNNEW
#define fcls	FCLOSE
#define outfil	OUTFIL
#define timer	TIMER
#define rdhdr	RDHDR

typedef struct {
    char *addr;
    int len;
} Str_Desc;
#else
#define Str_Desc char
#ifndef hpux
                            /* sun/convex/sgi */
#define rframe	rframe_
#define wframe	wframe_
#define opnfil	opnfil_
#define opnnew	opnnew_
#define fcls	fclose_
#define outfil	outfil_
#define timer	timer_
#define rdhdr	rdhdr_
#endif
#endif

#include <sys/types.h>
#include <sys/time.h>

void timer  (void);
void rframe (int *, int *, int *, int *, char *, int *);
void wframe (int *, int *, int *, int *, char *, int *);
void opnfil (int *, Str_Desc *, int *, int *, int *, int *, int *, int *, int *, int *);
void opnnew (int *, int *, int *, int *, Str_Desc *, int *, Str_Desc *, Str_Desc *, int *);
void outfil (int *, int *, Str_Desc *, Str_Desc *, Str_Desc *, int *);
void rdhdr  (Str_Desc*, Str_Desc*, int *, int *, int *, int *, int *, int *, int *);
void fcls   (int *);

int rframe_c (int, int, int, int, char *);
int wframe_c (int, int, int, int, char *);
int opnfil_c (char *, int, int, int *, int *, int *);
int opnnew_c (int, int, int, char *, char *, char *);
int outfil_c (char *, char *, char *);
int rdhdr_c  (char *, char *, int, int, int *, int *, int *);

static int hdrgen (int, int, int, char *, char *, char *);

void timer (void)
{
     time_t time();
     time_t *tloc = '\0';

     printf ("time in seconds since midnight is %d\n", time (tloc));
}

void rframe (int *fd, int *frame, int *npix, int *nrast, char *buff, int *irc)
{
    *irc = rframe_c (*fd, *frame, *npix, *nrast, buff);
}

void wframe (int *fd, int *frame, int *npix, int *nrast, char *buff, int *irc)
{
    *irc = wframe_c (*fd, *frame, *npix, *nrast, buff);
}

void opnfil (int *fd, Str_Desc *filename, int *ispec, int *filenum, int *iffr,
	     int *ilfr, int *npix, int *nrast, int *nframe, int *irc)
{
#ifdef titan
    char *fnam = filename->addr;
#else
    char *fnam = filename;
#endif

    *(fnam + 10) = '\0';
    if ((*fd = opnfil_c (fnam, *ispec, *filenum, npix, nrast, nframe)) == -1)
	*irc = 1;
    else
	*irc = 0;
}

void opnnew (int *fd, int *npix, int *nrast, int *nframe, Str_Desc *filename,
	     int *filenum, Str_Desc *title1, Str_Desc *title2, int *irc)
{
#ifdef titan
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
    *(fnam + 10) = '\0';
    if ((*fd = opnnew_c (*npix, *nrast, *nframe, fnam, titl1, titl2)) == -1)
	*irc = 1;
    else
	*irc = 0;
}

void rdhdr (Str_Desc *filename, Str_Desc *binary, int *ispec, int *filenum, 
		  int *iunit, int *npix, int *nrast, int *nframe, int *irc)
{
#ifdef titan
    char *fnam = filename->addr;
    char *biny = binary->addr;
#else
    char *fnam = filename;
    char *biny = binary;
#endif
    *(biny + 10) = '\0';
    *(fnam + 10) = '\0';
    if (rdhdr_c (fnam, biny, *ispec, *filenum, npix, nrast, nframe))
	*irc = 0;
    else
	*irc = 1;
}

void fcls (int *fd)
{
    if (*fd != -1)
    {
	close (*fd);
	*fd = -1;
    }
}

void outfil (int *iterm, int *iprint, Str_Desc *filename,
	     Str_Desc *title1, Str_Desc *title2, int *irc)
{
#ifdef titan
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
}
/***********************************************************************
 *                              rframe.c                               *
 ***********************************************************************
 Purpose: Read a frame of image data
 Author:  G.R.Mant
 Returns: TRUE or FALSE
 Updates: Initial C implementation 24/07/91
*/

#if defined titan || sgi || hpux || SYSV
#include <sys/fcntl.h>
#include <ctype.h>
#else
#ifdef DEC5000
#include <sys/file.h>
#else
#include <sys/fcntlcom.h>
#endif
#endif
#include <unistd.h>

#define OK	0
#define ERROR	-1
#define FALSE	0
#define TRUE	!FALSE
#define PMODE	0664

int rframe_c (int fd, int frame, int npix, int nrast, char *buff)
{
    int nbytes = npix*nrast*sizeof (float);	/* Nos of bytes to read */
    int c;					/* Actual bytes read    */
    long offset = (frame - 1) * nbytes;		/* Offset from start	*/
	
    if ((lseek (fd, offset, SEEK_SET)) == ERROR)
    {
	errmsg ("Error: Unable to access specified frame number");
	return (ERROR);
    }
    if ((c = read (fd, buff, nbytes)) != nbytes)
    {
	errmsg ("Error: Reading frame of binary data");
	return (ERROR);
    }
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

int wframe_c (int fd, int frame, int npix, int nrast, char *buff)
{
    int nbytes = npix*nrast*sizeof (float);	/* No of bytes to write */
    int c;					/* Actual bytes written */
	
    if ((c = write (fd, buff, nbytes)) != nbytes)
    {
	errmsg ("Error: Writing frame of binary data");
	return (ERROR);
    }
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

#ifdef hpux
#  define O_RDONLY      0000000   /* Open for reading only */
#  define O_WRONLY      0000001   /* Open for writing only */
#  define O_RDWR        0000002   /* Open for reading or writing */
#  define O_ACCMODE     0000003   /* Mask for file access modes */
#endif

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
    int fd;
    char *cptr;

    cptr = filename;
    while (*cptr != NULL)
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
    int indice[10], i;
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

	for (i=0; i<10; i++)
	    fprintf (fp, "%8d", indice[i]);
		
	*(filename + 5) = '1';
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
    FILE *fp, *fopen ();

    if (ispec > 0)
    {
	cptr = filename;
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
	       else if (sscanf (buff, "%8d%8d%8d", npix, nrast, nframe) != 3)
		   return (FALSE);
	       else if ((fgets (binary, MAXLIN, fp)) == NULL)
		   return (FALSE);
	    }
	    while (++i < filenum);
	}
	*(binary+10) = '\0';	/* Remove new line character */
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
    int len;

    do {
	printf ("Enter output filename [Xnn000.xxx]: ");
	if (fgets (filename, 80, stdin) == NULL)
	{
	    clearerr (stdin);
	    printf ("\n");
	    return (ERROR);
	}
	else if ((filename[0] == '^') && filename[1] == 'd' || filename[1] == 'D')
	    return (ERROR);

	len = strlen (filename);
	*(filename + --len) = '\0';	/* Remove new line character */

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

    printf ("Enter first header: ");
    if (fgets (title1, 80, stdin) == NULL)
    {
	clearerr (stdin);
	printf ("\n");
	return (ERROR);
    }
    else if ((title1[0] == '^') && title1[1] == 'd' || title1[1] == 'D')
	return (ERROR);
    len = strlen (title1);
    *(title1 + --len) = '\0';		/* Remove new line character */

    printf ("Enter second header: ");
    if (fgets (title2, 80, stdin) == NULL)
    {
	clearerr (stdin);
	printf ("\n");
	return (ERROR);
    }
    else if ((title2[0] == '^') && title2[1] == 'd' || title2[1] == 'D')
	return (ERROR);
    len = strlen (title2);
    *(title2 + --len) = '\0';		/* Remove new line character */

    return (OK);
}



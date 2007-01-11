/*******************************************************************************
 *                                 readc.c                                     *
 *******************************************************************************
 Purpose: Parse command line input
 Author:  R.C.Denny
 Returns: 1 for success, 0 on error, -1 on EOF  
 Updates:
 19/01/94 RCD Initial implementation

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "readc.h"

FILE *files [MAXFILES];
int  funit [MAXFILES];
int Nopen = 0;

/*******************************************************************************
 *                               rdcomc.c                                      *
 *******************************************************************************
 Purpose: Identify character strings
 Author:  R.C.Denny
 Returns: 1 for success, 0 for failure
 Updates:
 19/01/94 RCD Initial implementation

*/

int rdcomc (FILE *fp, char **wrdpp, int *nwrd, float *valp, int *nval, int *item,
	    int maxwrd, int maxval)
{
   int digit = 0, string = 0, next = 1, nw = 0, nv = 0, ilin = 0;
   int i, j, len;
   char *wrdptr, *cptr;
   char *sptr, str [MAXC];
   char line [MAXC], *lptr;
   static char chnum [] = "1234567890.+-";
   extern int errno;

/*
 * Do initialization
 */
   sptr = str;
/*
 * Start reading input lines
 */
   while (next)
   {
      if (++ilin > MAXL)
      {
	 printf ("Too many lines!\n");
	 break;
      }
      if (fgets (line, MAXC, fp) == NULL)
      {
	 clearerr (fp);
	 printf ("\n");
	 *nwrd = *nval = 0;
	 return (-1);
      }
      if (feof (fp))
      {
         clearerr (fp);
         printf ("\n");
         *nwrd = *nval = 0;
         return (-1);
      }
      next = 0;
      for (i=0,lptr=line; i<= (int) strlen (line); i++,lptr++)
      {
/*
 * Check for comment or string terminator
 */
	 if (*lptr == '!' || *lptr == '\0' || *lptr == '\n')
	 {
	    if (string)
	    {
	       string = 0;
	       *sptr = '\0';
	       if (digit)
	       {
		  nv++;
		  if (nv > maxval)
		  {
		     printf ("Too many values!\n");
		     return (0);
		  }
		  *item++ = 1;
		  *valp++ = atof (str);
	       }
	       else
	       {
     		  *item++ = 2;
		  if (nw >= maxwrd)
	          {
		     printf ("Too many words!\n");
		     return (0);
		  }
		  len = strlen (str);
                  if ((wrdpp [nw] = (char *) malloc (sizeof (char) * ++len)) == NULL)
                  {
                     printf ("Error allocating memory for input buffer\n");
                     return (0);
                  }
		  wrdptr = wrdpp [nw++];
		  cptr = str;
		  while (*wrdptr++ = *cptr++);
	       }
	    }
            break;
	 }
/*
 * Check for continuation mark
 */
	 else if (*lptr == '&')
	 {
	    next = 1;
	    break;
	 }
/*
 * Check for separator
 */
	 else if (!string && *lptr != ' ' && *lptr != ',' && *lptr != '\t')
         {
	    sptr = str;
            *sptr++ = *lptr;
	    digit = 0;
	    string = 1;
	    for (j=0,cptr=chnum; j<13; j++,cptr++)
	      if (*lptr == *cptr)
		digit = 1;
	 }
/*
 * Check for end of string
 */
	 else if (string && (*lptr == ' ' || *lptr == ',' || *lptr == '\t'))
         {
	    string = 0;
	    *sptr = '\0';
	    if (digit)
	    {
	       nv++;
	       if (nv > maxval)
	       {
		 printf ("Too many values!\n");
		 return (0);
	       }
	       *item++ = 1;
	       *valp++ = atof (str);
	    } 
	    else
	    {
	       *item++ = 2;
	       if (nw >= maxwrd)
	       {
		  printf ("Too many words!\n");
		  return (0);
	       }
	       len = strlen (str);
               if ((wrdpp [nw] = (char *) malloc (sizeof (char) * ++len)) == NULL)
               {
                  printf ("Error allocating memory for input buffer\n");
                  return (0);
               }
	       wrdptr = wrdpp [nw++];
	       cptr = str;
               while (*wrdptr++ = *cptr++);
	    }
	 }
	 else
	    *sptr++ = *lptr;
      }
   }
   *nwrd = nw;
   *nval = nv;
   return (1);
}

/*******************************************************************************
 *                                  upc.c                                      * 
 *******************************************************************************
 Purpose: Convert string of lowercase letters to uppercase
 Author:  R.C.Denny
 Returns: 1 for success, 0 for failure
 Updates:
 19/01/94 RCD Initial implementation

*/
   
int upc (char *wptr)
{
   int j;
   char *lptr, *uptr;
   static char upp [] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
   static char low [] = "abcdefghijklmnopqrstuvwxyz";

   if (wptr == NULL)
      return (0);

   while (*wptr)
   {
      for (j=0,lptr=low,uptr=upp; j<26; j++,lptr++,uptr++)
	if (*wptr == *lptr)
	   *wptr = *uptr;
      wptr++;
   }

   return (1);
}
     
/*******************************************************************************
 *                               optcmp.c                                      * 
 *******************************************************************************
 Purpose: Compares input character string against option list 
 Author:  R.C.Denny
 Returns: index of match found, 0 for no match, -1 for ambiguous input 
 Updates:
 20/01/94 RCD Initial implementation

*/

int optcmp (char *wrdptr, char **optionpp)
{
   char *optptr, *wptr;
   int i = 0, index = 0, consistent, match = 0;

   while (**optionpp)
   {
      optptr = *optionpp++;
      wptr = wrdptr;
      i++;
      consistent = 1;
      if ((int) strlen (optptr) >= (int) strlen (wptr))
         while (*wptr && consistent)
         {
            if (*wptr++ != *optptr++)
               consistent = 0;
         }
      else
         consistent = 0;

      if (consistent)
      {
         match++;
         index = i;
      }
   }

   if (match > 1)
      return (-1);
   else
      return (index);
}


/*******************************************************************************
 *                               rdcomf.c                                      *
 *******************************************************************************
 Purpose: Fortran interface for rdcomc.c
 Author:  R.C.Denny
 Returns: 0 for success, 1 for EOF, 2 for failure.
 Updates:
 12/09/94 RCD Initial implementation

*/
void RDCOMF (int *unit, Str_Desc *words, int *nwrd, float *valp, int *nval, int *item,
	     int *maxwrd, int *maxval, int *wrdlen, int *irc)
{
   int i, j, tmp;
   FILE *fp;
   char **wrdpp, *wptr;
#ifdef TITAN
   char *wrdptr = words->addr;
#else
   char *wrdptr = words;
#endif

   wrdpp = (char **) malloc (sizeof (char *) * *maxwrd);

/*
 * Initialize file pointer for terminal input (Fortran unit 5)
 */
   if (Nopen == 0)
   {
      files [0] = stdin;
      funit [0] = 5;
      Nopen++;
   }
/*
 * Find appropriate file pointer
 */
   for (i=0; i<Nopen; i++)
   {
      if (funit [i] == *unit)
      {
	 fp = files [i];
	 if (fp == NULL)
	 {
	    *irc = 2;
	    return;
	 }
	 break;
      }
   }
/*
 * Read words and numbers
 */
   tmp = rdcomc (fp, wrdpp, nwrd, valp, nval, item, *maxwrd, *maxval);
/*
 * Set return code
 */
   if (tmp < 1)
   {
      *irc = tmp + 2;
      return;
   }
/*
 * Copy words into Fortran style array and free pointers malloced in rdcomc
 */
   for (i=0; i<*nwrd; i++)
   {
      wptr = wrdpp [i];

      for (j=0; j<*wrdlen; j++,wrdptr++)
      {
	 if (*wptr == '\0')
	    *wrdptr = ' ';
	 else
	    *wrdptr = *wptr++;
      }
      (void) free (wrdpp [i]);
   }
   
   (void) free (wrdpp);
   *irc = 0;
   return;
}

/*******************************************************************************
 *                               fileopen.c                                    *
 *******************************************************************************
 Purpose: Fortran interface for fopen() - used for opening readonly ascii files
 Author:  R.C.Denny
 Returns: 0 for success, 1 file aleady open, 2 failure.
 Updates:
 12/09/94 RCD Initial implementation

*/

void FILEOPEN (int *unit, Str_Desc *filename, int *len, int *irc)
{
   int i, found_end = 0;
   char *cptr;
#ifdef TITAN
   char *fptr = filename->addr;
#else
   char *fptr = filename;
#endif

   if (Nopen == 0)
   {
      files [0] = stdin;
      funit [0] = 5;
      Nopen++;
   }

   for (i=0; i<Nopen; i++)
   {
      if (funit [i] == *unit)
      {
	 *irc = 1;
	 return;
      }
   }
   
   for (i=*len; i>0; i--)
   {
      if (!found_end)
         if (*(fptr + i - 1) != ' ')
         {
	    cptr = (char *) malloc (sizeof (char) * (i + 1));
	    *(cptr + i) = '\0';
	    found_end = 1;
	 }
      if (found_end)
	 *(cptr + i - 1) = *(fptr + i - 1);
   }

   if (Nopen < MAXFILES)
      if ((files [Nopen] = fopen (cptr, "r")) != NULL)
      {
	 funit [Nopen++] = *unit;
	 *irc = 0;
      }
      else
         *irc = 2;
   else
      *irc = 2;

   (void) free (cptr);
   return;
}

void FILECLOSE (int *unit)
{
   int i;
   int closed = 0;

   if (*unit == 5)
      return;

   for (i=0; i<Nopen; i++)
   {
      if (closed)
      {
	 files [i-1] = files [i];
	 funit [i-1] = funit [i];
      }
      if (funit [i] == *unit)
      {
	 fclose (files [i]);
	 funit [i] = 0;
	 closed = 1;
      }
   }
   Nopen--;
   return;
}


void OPTCMPF (Str_Desc *wrdptr, int *wrdlen, Str_Desc *optionptr, int *noptions, 
	     int *optlen, int *irc)
{
   int i, j, len;
   char **options, *word, *cptr, *optr;

#ifdef TITAN
   optr = optionptr->addr;
#else
   optr = optionptr;
#endif

   options = (char **) malloc (sizeof (char *) * (*noptions + 1));
   for (i=0; i<*noptions; i++)
   {
      cptr = optr + *optlen - 1;
      len = 0;
      for (j=*optlen; j>0; j--,cptr--)
	 if (*cptr != ' ')
	 {
	    if (len == 0)
	    {
	       options [i] = (char *) malloc (sizeof (char) * (j + 1));
	       *(options [i] + j) = '\0';
	       len = j;
	    }
	    *(options [i] + j - 1) = *cptr;
	 }      
      optr += *optlen;
   }
   options [*noptions] = (char *) malloc (sizeof (char));
   *options [*noptions] = '\0';

#ifdef TITAN
   cptr = wrdptr->addr + *wrdlen - 1;
#else
   cptr = wrdptr + *wrdlen - 1;
#endif

   len = 0;
   for (i=*wrdlen; i>0; i--,cptr--)
      if (*cptr != ' ')
      {
	 if (len == 0)
	 {
	    word = (char *) malloc (sizeof (char) * (i + 1));
	    *(word + i) = '\0';
	    len = i;
	 }
	 *(word + i - 1) = *cptr;
      }

   *irc = optcmp (word, options);

   for (i=0; i<*noptions+1; i++)
      (void) free (options [i]);

   (void) free (word);
   (void) free (options);
   return;
}


#define Str_Desc char
#define rdcomf    rdcomf_
#define fileopen  fileopen_
#define fileclose fileclose_
#define optcmpf   optcmpf_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXC 132
#define MAXL 5

#define MAXFILES  10
FILE *files [MAXFILES];
int  funit [MAXFILES];
int Nopen = 0;

int rdcomc (FILE *fp, FILE *output,char **wrdpp, int *nwrd, double *valp, int *nval, int *item,
	    int maxwrd, int maxval)
{
  int digit = 0, string = 0, next = 1, nw = 0, nv = 0, ilin = 0;
  int i, j, len;
  char *wrdptr, *cptr;
  char *sptr, str [MAXC];
  char line [MAXC], *lptr;
  static char chnum [] = "1234567890.+-";
  sptr = str;

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
	  fprintf(output,"\n");
	  *nwrd = *nval = 0;
	  return (-1);
	}
      if (feof (fp))
	{
	  clearerr (fp);
	  fprintf(output,"\n");
	  *nwrd = *nval = 0;
	  return (-1);
	}
      next = 0;
      for (i=0,lptr=line; i<=strlen (line); i++,lptr++)
	{
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
			  fprintf(output,"Too many values!\n");
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
			  fprintf(output,"Too many words!\n");
			  return (0);
			}
		      len = strlen (str);
		      if ((wrdpp [nw] = (char *) malloc (sizeof (char) * ++len)) == NULL)
			{
			  fprintf(output,"Error allocating memory for input buffer\n");
			  return (0);
			}
		      wrdptr = wrdpp [nw++];
		      cptr = str;
		      while (*wrdptr++ = *cptr++);
		    }
		}
	      break;
	    }
	  else if (*lptr == '&')
	    {
	      next = 1;
	      break;
	    }
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
	  else if (string && (*lptr == ' ' || *lptr == ',' || *lptr == '\t'))
	    {
	      string = 0;
	      *sptr = '\0';
	      if (digit)
		{
		  nv++;
		  if (nv > maxval)
		    {
		      fprintf(output,"Too many values!\n");
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
		      fprintf(output,"Too many words!\n");
		      return (0);
		    }
		  len = strlen (str);
		  if ((wrdpp [nw] = (char *) malloc (sizeof (char) * ++len)) == NULL)
		    {
		      fprintf(output,"Error allocating memory for input buffer\n");
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
   
int upc (char *wptr)
{
  int j;
  char *lptr, *uptr;
  static char upp [] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static char low [] = "abcdefghijklmnopqrstuvwxyz";
  if (wptr == NULL) return (0);
  while (*wptr)
    {
      for (j=0,lptr=low,uptr=upp; j<26; j++,lptr++,uptr++)
	if (*wptr == *lptr)
	  *wptr = *uptr;
      wptr++;
    }
     
  return (1);
}

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
      if (strlen (optptr) >= strlen (wptr))
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









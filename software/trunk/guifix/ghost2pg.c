#include <stdio.h>
#include <string.h>

main (int argc, char *argv[])
{
  char *filename, ofname[100] = "PG", *cptr;
  FILE *fp, *ofp;
  float vals[10];
  char *wrdpp[10];
  int item[20];
  int nwrd,nval,irc;
  char line[81];
  int ghost_code = 0, pgplot_code = 0;

  if (argc < 2)
    {
      printf ("Enter GHOST source file: ");
      if (!(irc = rdcomc (stdin, wrdpp, &nwrd, vals, &nval, item, 10, 10)))
	{
	  printf ("Error reading input\n");
	  exit (1);
	}
      else if (irc < 0)
	{
	  exit (0);
	}
      else
	{
	  filename = wrdpp[0];
	}
    }
  else
    {
      filename = argv[1];
    }

  if (!(fp = fopen (filename, "r")))
    {
      printf ("Error opening file %s\n", filename);
      exit (1);
    }
  else
    {
      strcat (ofname, filename);
      if (!(ofp = fopen (ofname, "w")))
	{
	  printf ("Error opening output file %s\n", ofname);
	  exit(1);
	}
      while (1)
	{
	  if (fgets (line, 80, fp) == NULL)
	    if (feof (fp))
	      {
		fclose (fp);
		fclose (ofp);
		exit (0);
	      }
	    else
	      {
		printf ("Error reading input file\n");
		exit (1);
	      }
	  else
	    {
	      if (cptr = strstr (line, "c++++++++"))
		  fprintf (ofp, "%s", line);

	      if (cptr = strstr (line, "++GHOST++"))
		{
		  pgplot_code = 0;
		  ghost_code = 1;
		}
	      else if (cptr = strstr (line, "++PGPLOT++"))
		{
		  ghost_code = 0;
		  pgplot_code = 1;
		}
	      else if (cptr = strstr (line, "++END++"))
		{
		  ghost_code = 0;
		  pgplot_code = 0;
		}
	      else
		{
		  if (line[0] == 'C')
		    {
		      fprintf (ofp, "%s", line);
		    }
		  else if (pgplot_code)
		    {
		      fprintf (ofp, "%s", (line + 1));
		    }
		  else if (ghost_code)
		    {
		      fprintf (ofp, "c%s", line);
		    }
		  else
		    {
		      fprintf (ofp, "%s", line);
		    }
		}
	    }
	}
    }
}

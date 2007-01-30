
void command (char *fmt, ...)
{
#ifndef DESIGN_TIME
  char buff[256];
  va_list args;
  
  va_start (args, fmt);
  vsprintf (buff, fmt, args);
  va_end (args);
  
  XGputstring (buff);
  update_messages (buff);
#endif
}

void update_messages (char *msg)
{
    Widget text = UxGetWidget (scrolledText1);
    if (msg)
      {
	XmTextInsert (text, XmTextGetLastPosition(text), msg);
	XmTextShowPosition (text, XmTextGetLastPosition(text));
      }
}
 
void SetBusyPointer (int busyState)
{ 
    if (busyState)
    {
        if (setup != NULL && XtIsRealized (setup))
            XDefineCursor (UxDisplay, XtWindow (setup), watch);
 
        if (info != NULL && XtIsRealized (info))
            XDefineCursor (UxDisplay, XtWindow (info), watch);
 
        if (fitShell != NULL && XtIsRealized (fitShell))
        {
            XDefineCursor (UxDisplay, XtWindow (fitShell), watch);
            XFlush (UxDisplay);
        }
    }
    else
    {
        if (setup != NULL && XtIsRealized (setup))
            XDefineCursor (UxDisplay, XtWindow (setup), None);
 
        if (info != NULL && XtIsRealized (info))
            XDefineCursor (UxDisplay, XtWindow (info), None);
 
        if (fitShell != NULL && XtIsRealized (fitShell))
        {
            XDefineCursor (UxDisplay, XtWindow (fitShell), None);
            XFlush (UxDisplay);
        }
    }
}

static int put_file (char *filename, char *string)
{
  char *cptr = findtok (string, " ");
  static int fframe = 1, lframe = 1, inc = 1;

  *cptr = '\0';

  if (strcmp (string, "Enter") == 0)
    {
      cptr++;
      cptr = strtok (cptr, " ");
      if (strcmp (cptr, "filename") == 0)
	{
	  if (filename != yfile)
	    command ("%s\n", filename);
	}
      if (strcmp (cptr, "first") == 0)
	{
	  command ("%d %d %d\n", iffr, ilfr, ifinc);
	} 
      if (strcmp (cptr, "[1]") == 0)
	{
	  command ("%d\n", filenum);
	}
    }
  
  if (strcmp (string, "Total") == 0)
    {
      fframe = 1;
      lframe = 1;
      inc = 1;
      cptr++;
      cptr = strtok (cptr, ":");
      cptr = strtok (NULL, " \n");
      lframe = atoi (cptr);
    }

  if (strcmp (string, "Memory") == 0)
    {
      return (1);
    }
  
  if (strcmp (string, "Error:") == 0)
    {
      *cptr = ' ';
      inputPause = 1;
      errorDialog_popup (error, &UxEnv, string);
      if (filename != yfile)
	{
	  command ("^D\n");
	}
      return (-1);
    }
  
  return (0);
}

static int get_file (char *filename, char *string)
{
  char *cptr = findtok (string, " ");

  *cptr = '\0';

  if (strcmp (string, "Enter") == 0)
    {
      cptr++;
      cptr = strtok (cptr, " ");
      if (strcmp (cptr, "output") == 0)
	{
	  command ("%s\n", filename);
	}
      if (strcmp (cptr, "first") == 0)
	{
	  command ("%s\n", header1);
	  free (header1);
	}
      if (strcmp (cptr, "second") == 0)
	{
	  command ("%s\n", header2);
	  free (header2);
	  return (1);
	}
    }

  if (strcmp (string, "Error:") == 0)
    {
      *cptr = ' ';
      inputPause = 1;
      errorDialog_popup (error, &UxEnv, string);
      command ("^D\n");
      return (-1);
    }

  return (0);
}
  
void message_handler (XtPointer client_data, int *fdin, XtInputId *id)
{
  char buf[512];
  int n;

  if ((n = read (*fdin, buf, 511)))
    {
      buf[n] = '\0';
      message_parser (buf);
    }

  return;
}

static void message_parser (char *buf)
{
  static int lastcode = 0;
  static char line[512] = "";
  static char *current_ptr = NULL, *store = NULL, *buffer = NULL;
  int icode, idif, irc;
  char *bptr, *cptr, *endptr, *endtmp, tmp;

  if (buf)
    {
      current_ptr = AddString (store, buf);
      free (store);
      store = current_ptr;

      if (inputPause)
	{
	  return;
	}
    }
  else
    {
      inputPause = 0;
    }

  do
    {
      endptr = findtok (current_ptr, ":\n");
      if (!(*endptr))
	{
	  cptr = strcat (line, current_ptr);
	  break;
	}
      endptr++;
      tmp = *endptr;
      *endptr = '\0';
      cptr = strcat (line, current_ptr);
      *endptr = tmp;
      cptr = checkstr (cptr, &icode);
      if (strcmp (cptr, "Error:") == 0 ||
	  strcmp (cptr, "Total number of frames:") == 0)
	{
	  current_ptr = endptr;
	  endptr = findtok (current_ptr, "\n");
	  if (!(*endptr))
	    {   
	      cptr = strcat (line, current_ptr);
	      break;
	    }
	  endptr++;
	  tmp = *endptr;
	  *endptr = '\0';
	  cptr = strcat (line, current_ptr);
	  *endptr = tmp;
	  cptr = checkstr (cptr, &icode);
	}

      if (icode != 900 && lastcode != 900)
	update_messages (cptr);
      
      if (icode)
	{
	  cptr = findtok (cptr, " \n");
	  cptr = firstnon(cptr, " ");
	}

      if (icode > 0 && icode != lastcode)
	{
	  switch (lastcode)
	    {
	    case 300: 	
	      break;
	    case 400: 	
	      break;
	    case 600:
	      UxPopdownInterface (info);
	      infoDialog_popup (info, &UxEnv, buffer);
	      break;
	    case 805:
	      if (firstrun)
		{
		  UxPopupInterface (setup, exclusive_grab);
		  firstrun = 0;
		}
	      else
		{
		  /* UxPopupInterface (setup); */
		}
	    default:
	      break;
	    } 
	  
	  lastcode = icode;
	  idif = icode % 100;
	  icode = (icode / 100) * 100;
	  
	  switch (icode)
	    {
	    case 200:
	      if (idif == 1)
		{
		  file_ready = 0;
		  if (firstrun == 0)
		    {
		      setupDialog_quit (setup, &UxEnv);
		      firstrun = 1;
		    }
		  freelinks ();
		}
	      break;
	    case 300:
	      inputPause = 1;
	      warningDialog_popup (warning, &UxEnv, cptr);
	      break;
	    case 400:
	      inputPause = 1;
	      errorDialog_popup (error, &UxEnv, cptr);
	      break;
	    case 500:
	    case 600:
              free (buffer);
              buffer = NULL;
              buffer = AddString (buffer, cptr);
	      break;
	    case 700:
	      switch (idif)
		{
		case 1:
		  if (xfile)
		    {
		      say_yes ();
		    }
		  else
		    {
		      say_no ();
		    }
		  break;
		case 2:
		  if (mode)
		    {
		      say_yes ();
		    }
		  else
		    {
		      say_no ();
		    }
		  break;
		case 3:
		  if (initfile)
		    {
		      say_yes ();
		    }
		  else
		    {
		      say_no ();
		    }
		  break;
		case 4:
		  if (outfile)
		    {
		      say_yes ();
		    }
		  else
		    {
		      inputPause = 1;
		      ConfirmDialogAsk (confirm, "Save parameters to file?", 
					 save_pars, say_no, NULL);
		    }
		  break;
		case 5:
		  say_no ();
		  break;
		case 6:
		  cptr = strtok (cptr, "[");
		  SetBusyPointer (FALSE);
		  ConfirmDialogAsk (confirm, cptr, retry, say_no, NULL);
		  break;
		case 7:
		  if (mode == 2)
		    {
		      say_yes ();
		    }
		  else
		    {
		      say_no ();
		    }
		  break;	
		case 13:
		  if (sfile)
		    {
		      say_yes ();
		    }
		  else
		    {
		      say_no ();
		    }
		  break;
		default:
		  cptr = strtok (cptr, "[");
		  ConfirmDialogAsk (confirm, cptr, say_yes, say_no, NULL);
		  break;
		}
	      break;
	    case 800:
	      switch (idif)
		{
		case 1: /* File type */
		  break;
		case 2: /* Frames */
		  break;
		case 3: /* Channels */
		  channelDialog_popup (channels, &UxEnv, cptr);
		  break;
		case 4: /* Min. & max. Y */
		  yDialog_popup (minmaxy, &UxEnv, cptr);
		  break;
		case 5: /* Setup */
		  SetBusyPointer (FALSE);
		  setupDialog_sensitive (UxGetWidget (setup), &UxEnv, TRUE);
		  break;
		case 6:
		  UxPopupInterface (continueD, no_grab);
		default:
		  break;
		}
	      break;
	    default:
	      break;
	    }     
	}
      else
	{
	  if (file_ready)
	    {
	      switch (lastcode)
		{
		case 201:
		  if (yfile)
		    {
		      if ((irc = put_file (yfile, cptr)) == -1)
			{
			  yfile = NULL;
			  file_ready = 0;
			}
		    }
		  break;
		case 300:
		case 400:
		case 500:
		case 600:
		  bptr = AddString (buffer, cptr);
		  free (buffer);
		  buffer = bptr;
		  break;
		case 701:
		  if (xfile)
		    {
		      if ((irc = put_file (xfile, cptr)) == -1)
			xfile = NULL;
		    }
		  break;
		case 702:
		  break;
		case 703:
		  if (initfile)
		    {
		      if ((irc = put_file (initfile, cptr)) == -1)
			initfile = NULL;
		    }
		  break;
		case 704:
		  if (outfile)
		    {
		      if ((irc = get_file (outfile, cptr)) == -1)
			outfile = NULL;
		    }
		  break;
		case 705:
		  break;
		case 713:
		  if (sfile)
		    {
		      if ((irc = put_file (sfile, cptr)) == -1)
			sfile = NULL;
		    }
		  break;
		case 805:
		  if (firstrun)
		    {
		      setupDialog_put (setup, &UxEnv, cptr);
		    }
		  else
		    {
		      setupDialog_set (setup, &UxEnv, cptr);
		    }
		  break;
		default:
		  break;		
		}
	    }
	}
      (void) strcpy (line, "");
      current_ptr = endptr;

    } while (*current_ptr && !inputPause);

  free (store);
  store = NULL;
  return;
}

static void say_yes ()
{
  command ("Y\n");
}

static void say_no ()
{
  command ("N\n");
  message_parser (NULL);
}

static void save_pars ()
{
  command ("Y\n");
  show_fileSelect (fileSelect, "*000.*", get_outfile, CancelSave);
}

static void CancelSave ()
{
  command ("^d\n");
  message_parser (NULL);
}

static void retry ()
{
  setupDialog_quit (setup, &UxEnv);
  firstrun = 1;
  command ("Y\n");
}

static void quit ()
{
  int i;
  XGputstring ("^D\n");
  XGclose ();
  freelinks ();
  exit(0);
}

static void get_yfile (char *string, int np, int nr, int ff, int lf, int inc, int fnum)
{
  yfile = chopdir (string);
  iffr = ff;
  ilfr = lf;
  ifinc = inc;
  filenum = fnum;
}

static void get_xfile (char *string, int np, int nr, int ff, int lf, int inc, int fnum)
{
  xfile = chopdir (string);
}

static void get_initfile (char *string, int np, int nr, int ff, int lf, int inc, int fnum)
{
  initfile = chopdir (string);
}

static void get_outfile (char *string)
{
  outfile = chopdir (string);
  headerDialog_popup (header, &UxEnv, outfile);
}

static void get_hardfile (char *string)
{
  hardfile = chopdir (string);
}

static void get_sfile (char *string, int np, int nr, int ff, int lf, int inc, int fnum)
{
  sfile = chopdir (string);
}

static char *chopdir (char *string)
{
  int len = (int) strlen (string);
  char *cptr = string + len;
  int i;

  for (i=0; i<len; i++)
    {
      cptr--;
      if (islower ((int) *cptr))
	*cptr = (char) toupper ((int) *cptr);
	  
      if (*cptr == '/')
	{
	  cptr++;
	  break;
	}
    }

  return ((char *) strdup (cptr));
}

static char *checkstr (char *string, int *icode)
{
  char *cptr = string, *endtmp, tmp;
  int start = 1;
  int len;

  if (!cptr)
    return (NULL);

  while (*cptr)
    {
      if (*cptr != '\n')
	if ((int) *cptr < (int) ' ' || (int) *cptr > (int) '}')
	  {
	    *cptr = ' ';
	  }
      cptr++;
    }

  *icode = 0;
  cptr = string;
  while (*(cptr = firstnon (cptr, " \n")))
    {
      if (start)
	{
	  if (((int) *cptr < (int) 'A' || (int) *cptr > (int) 'Z') &&
	      ((int) *cptr < (int) '1' || (int) *cptr > (int) '9'))
	    {
	      *cptr = ' ';
	    }
	  else
	    {
	      endtmp = findtok (cptr, " :\n");
	      tmp = *endtmp;
	      *endtmp = '\0';
	      len = (int) strlen (cptr);
	      if (((int) *cptr < (int) '1' || (int) *cptr > (int) '9'))
		{
		  while (*cptr)
		    {
		      if (((int) *cptr < (int) 'A' ||
			   (int) *cptr > (int) 'Z') &&
			  ((int) *cptr < (int) 'a' ||
			   (int) *cptr > (int) 'z'))
			{
			  len = 1;
			  break;
			}
		      cptr++;
		    }
		  if (len < 3)
		    {
		      cptr = string;
		      while (*cptr)
			*cptr++ = ' ';
		    }
		  else
		    {
		      start = 0;
		      cptr = firstnon (endtmp, " ");
		    }
		}
	      else
		{
		  if (len == 3)
		    sscanf (cptr, "%d", icode);

		  if (*icode < 100)
		    {
		      while (*cptr)
			*cptr++ = ' ';
		    }
		  else
		    {
		      start = 0;
		      cptr = firstnon (endtmp, " ");
		    }
		}
	      *endtmp = tmp;
	    }
	}
      else
	{
	  cptr = findtok (cptr, " \n");
	}
    }
  
  cptr = firstnon (string, " ");
  return (cptr);
}

static char *AddString (char *string1, char *string2)
{
  char *temp = NULL;
 
  if (string1)
    {
      if ((temp = (char *) malloc (sizeof (char) * (strlen (string1) + strlen (string2) + 1))))
        {      
          temp = strcpy (temp, string1);
          temp = strcat (temp, string2);
        }
    }
  else
    {
      temp = (char *) strdup (string2);
    }
  return (temp);
}
      
static char *findtok (char *string, char *tok)
{
  char *cptr = string, *tptr = tok;

  if (!cptr)
    return (NULL);

  if (!tptr)
    return (NULL);

  while (*cptr)
    {
      while (*tptr)
	  if (*cptr == *tptr++)
	    return (cptr);

      tptr = tok;
      cptr++;
    }

  return (cptr);
}


static char *firstnon (char *string, char *tok)
{
  char *cptr = string, *tptr = tok;
  int match;

  if (!cptr)
    return (NULL);

  if (!tptr)
    return (NULL);

  while (*cptr)
    {
      match = 0;
      while (*tptr)
	if (*cptr == *tptr++)
	  match++;

      if (!match)
	return (cptr);

      tptr = tok;
      cptr++;
    }

  return (cptr);
}

static void freelinks ()
{
  if (yfile)
    {
      free (yfile);
      yfile = NULL;
    }
  if (xfile)
    {
      free (xfile);
      xfile = NULL;
    }
  if (initfile)
    {
      free (initfile);
      initfile = NULL;
    }
  if (outfile)
    {
      free (outfile);
      outfile = NULL;
    }
  if (sfile)
    {
      free (sfile);
      sfile = NULL;
    }
}

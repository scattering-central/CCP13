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
 
        if (working != NULL && XtIsRealized (working))
            XDefineCursor (UxDisplay, XtWindow (working), watch);
 
        if (drawingArea1 != NULL && XtIsRealized (drawingArea1))
        {
            XDefineCursor (UxDisplay, XtWindow (drawingArea1), watch);
            XFlush (UxDisplay);
        }     
   
        if (drawingArea2 != NULL && XtIsRealized (drawingArea2))
        {
            XDefineCursor (UxDisplay, XtWindow (drawingArea2), watch);
            XFlush (UxDisplay);
        }
        if (mainWS != NULL && XtIsRealized (mainWS))
        {
            XDefineCursor (UxDisplay, XtWindow (mainWS), watch);
            XFlush (UxDisplay);
        }
        if (BgWinParams != NULL && XtIsRealized (BgWinParams))
        {
            XDefineCursor (UxDisplay, XtWindow (BgWinParams), watch);
            XFlush (UxDisplay);
        }
    }
    else
    {
        if (setup != NULL && XtIsRealized (setup))
            XDefineCursor (UxDisplay, XtWindow (setup), None);
 
        if (info != NULL && XtIsRealized (info))
            XDefineCursor (UxDisplay, XtWindow (info), None);

        if (working != NULL && XtIsRealized (working))
            XDefineCursor (UxDisplay, XtWindow (working), None);
 
        if (drawingArea1 != NULL && XtIsRealized (drawingArea1))
        {
            XDefineCursor (UxDisplay, XtWindow (drawingArea1), currentCursor);
            XFlush (UxDisplay);
        }
        if (drawingArea2 != NULL && XtIsRealized (drawingArea2))
        {
            XDefineCursor (UxDisplay, XtWindow (drawingArea2), currentCursor);
            XFlush (UxDisplay);
        }
        if (mainWS != NULL && XtIsRealized (mainWS))
        {
            XDefineCursor (UxDisplay, XtWindow (mainWS), None);
            XFlush (UxDisplay);
        }
        if (BgWinParams != NULL && XtIsRealized (BgWinParams))
        {
            XDefineCursor (UxDisplay, XtWindow (BgWinParams), None);
            XFlush (UxDisplay);
        }
    }
}

static int put_file (char *filename, char *string)
{
  char *cptr = findtok (string, " ");

  *cptr = '\0';

  if (strcmp (string, "Enter") == 0)
    {
      cptr++;
      cptr = strtok (cptr, " ");
      if (strcmp (cptr, "filename") == 0)
	{
	  if (filename != NULL)
	    command ("%s\n", filename);
	  else
	    command ("^D\n");
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

  if (strcmp (string, "Memory") == 0)
    {
      return (1);
    }
  
  if (strcmp (string, "Error:") == 0)
    {
      return (-1);
    }
  
  return (0);
}

static int put_backfile (char *filename,int bfram, char *string)
{
  char *cptr = findtok (string, " ");

  *cptr = '\0';

  if (strcmp (string, "Enter") == 0)
    {
      cptr++;
      cptr = strtok (cptr, " ");
      if (strcmp (cptr, "filename") == 0)
	{
	  if (filename != NULL)
	    command ("%s\n", filename);
	  else
	    command ("^D\n");
	}
      if (strcmp (cptr, "first") == 0)
	{
	  command ("%d %d %d\n", bfram, bfram, 0);
	} 
      if (strcmp (cptr, "[1]") == 0)
	{
	  command ("%d\n", 1);
	}
    }

  if (strcmp (string, "Memory") == 0)
    {
      return (1);
    }
  
  if (strcmp (string, "Error:") == 0)
    {
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
	  if (filename != NULL && header1 != NULL && header2 != NULL)
	    command ("%s\n", filename);
	  else
	    command ("^D\n");
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
      return (-1);
    }

  return (0);
}
  
static int get_backfile (char *filename, char *string)
{
  char *cptr = findtok (string, " ");

  *cptr = '\0';

  if (strcmp (string, "Enter") == 0)
    {
      cptr++;
      cptr = strtok (cptr, " ");
      if (strcmp (cptr, "output") == 0)
	{
	  if (filename != NULL && header1 != NULL && header2 != NULL)
	    command ("%s\n", filename);
	  else
	    command ("^D\n");
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
  static int lastcode = 0, irc = 0;
  static char line[512] = "";
  static char *current_ptr = NULL, *store = NULL, *buffer = NULL;
  int icode, idif;
  char *bptr, *cptr, *endptr, *endtmp, *sptr, tmp;

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
      
      if ((sptr = strstr (cptr, "Total number of frames:")) != NULL)
	cptr = sptr;
      else if ((sptr = strstr (cptr, "Error:")) != NULL )
	cptr = sptr;

      if (sptr)
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
	}
      cptr = checkstr (cptr, &icode);

      if (icode != 900 && lastcode != 900 && icode != 500)
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
	    case 500:
	      break;
	    case 600:
	      UxPopdownInterface (info);
	      infoDialog_popup (info, &UxEnv, buffer);
	      break;
	    case 805:
	      if (firstRun)
		{
		  UxPopupInterface (setup, exclusive_grab);
		  firstRun = 0;
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
	      switch (idif)
		{
		case 2:
		  setupDialog_quit (setup, &UxEnv);
		  firstRun = 1;
		  break;
		case 3:
		  workingDialog_popup (working, &UxEnv, cptr);
		  SetBusyPointer (1);
		  break;
		case 4:
		  SetBusyPointer (0);
		  UxPopdownInterface (working);
		  break;
		case 5:
		  RefreshPalette ();
		  break;
		case 6:
		  SetBusyPointer (0);
		  UxPopdownInterface (working);
                  ConfirmDialogAsk(confirmD,"View background?",DisBackFile,NULL,NULL);
		  break;
		case 7:
		  SetBusyPointer (0);
		  UxPopdownInterface (working);
                  ConfirmDialogAsk(confirmD,"View background?",DisBackFile2,DoMore,NULL);
                  break;
		default:
		  break;
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
	      CommandHandler (cptr);
	      break;
	    case 600:
	      free (buffer);
	      buffer = NULL;
	      buffer = AddString (buffer, cptr);
	      break;
	    case 700:
	      switch (idif)
		{
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
		case 5:
		  say_no ();
		  break;
		case 6:
		  cptr = strtok (cptr, "[");
		  SetBusyPointer (FALSE);
		  ConfirmDialogAsk (confirmD, cptr, retry, say_no, NULL);
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
		case 8:
		  if (refineCentre)
		    {
		      say_yes ();
		    }
		  else
		    {
		      say_no ();
		    }
		  break;
		case 9:
		  if (refineRotX)
		    {
		      say_yes ();
		    }
		  else
		    {
		      say_no ();
		    }
		  break;
		case 10:
		  if (refineRotY)
		    {
		      say_yes ();
		    }
		  else
		    {
		      say_no ();
		    }
		  break;
		case 11:
		  if (refineRotZ)
		    {
		      say_yes ();
		    }
		  else
		    {
		      say_no ();
		    }
		  break;
		case 12:
		  if (refineTilt)
		    {
		      say_yes ();
		    }
		  else
		    {
		      say_no ();
		    }
		  break;
		case 14:
		  inputPause = 1;
		  ConfirmDialogAsk (confirmD, "Save data to new OTOKO file?", 
				    SaveData, CancelSave, NULL);
		  break;	  
		default:
		  cptr = strtok (cptr, "[");
		  ConfirmDialogAsk (confirmD, cptr, say_yes, say_no, NULL);
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
	  switch (lastcode)
	    {
	    case 201:
	      if ((irc = put_file (fileName, cptr)) < 0)
		{
		  fileName = NULL;
		}
	      break;
/*	    case 208:
	      irc=put_backfile(sBackInFile,binfram,cptr);
	      break;
	    case 209:
	      irc=get_backfile(sBackFile,cptr);
	      break;
*/
	    case 500: /* commands from fix e.g. DRAW CROSS x y */
	      CommandHandler (cptr);
	      break;
	    case 300:
	    case 400:
	    case 600:
	      bptr = AddString (buffer, cptr);
	      free (buffer);
	      buffer = bptr;
	      break;
	    case 714:
	      if ((irc = get_file (outfile, cptr)) < 0)
		{
		  outfile = NULL;
		}
	      break;
	    case 805:
	      if (firstRun)
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
   
      (void) strcpy (line, "");
      current_ptr = endptr;

    } while (*current_ptr && !inputPause);

  free (store);
  store = NULL;
  return;
}

static void RefreshPalette ()
{
  Widget wgt;

  XFlush (UxDisplay);

  XtVaGetValues (UxGetWidget (palettePane),
		 XmNmenuHistory, &wgt,
		 NULL);

  if (wgt == UxGetWidget (colour0Toggle))
    GreyScale ();
  else if (wgt == UxGetWidget (colour1Toggle))
    ColourPalette1 ();
  else if (wgt == UxGetWidget (colour2Toggle))
    ColourPalette2 ();
  else if (wgt == UxGetWidget (colour3Toggle))
    ColourPalette3 ();
  else if (wgt == UxGetWidget (colour4Toggle))
    ColourPalette4 ();
  else if (wgt == UxGetWidget (colour5Toggle))
    ColourPalette5 ();
  else
    GreyScale ();

  if (invertedPalette)
    InvertPalette ();

  if (currentImage >= 0)
    LoadImage (xi[currentImage]);
}

static void CommandHandler (char *cptr)
{
  float x, y, r;
  static char *pFixOptions [] = 
    {
      "DRAW",
      "DISTANCE", 
      "CENTRE", 
      "ROTATION", 
      "TILT", 
      "" 
    };
  static char *pDrawOptions [] = 
    { 
      "CROSS", 
      "CIRCLE", 
      "POINT",
      "RING",
      "" 
    };

  cptr = strtok (cptr, " ");
  switch (optcmp (cptr, pFixOptions))
    {
    case -1:
      printf ("Ambiguous command: %s\n", cptr);
      break;
    case 0:
      printf ("No matching command: %s\n", cptr);
      break;
    case 1: /* Draw */
      cptr = strtok (NULL, " ");
      switch (optcmp (cptr, pDrawOptions))
	{
	case -1:
	  printf ("Ambiguous command: %s\n", cptr);
	  break;
	case 0:
	  printf ("No matching command: %s\n", cptr);
	  break;
	case 1: /* crosses */
	  cptr = strtok (NULL, " ");
	  x = atof (cptr);
	  cptr = strtok (NULL, " ");
	  y = atof (cptr);
	  FixDrawCross (x, y, XtWindow (UxGetWidget (drawingArea1)));
	  (void) CreateFixDrawnCross (x, y);
	  break;
	case 2: /* circles */
	  cptr = strtok (NULL, " ");
	  x = atof (cptr);
	  cptr = strtok (NULL, " ");
	  y = atof (cptr);
	  cptr = strtok (NULL, " ");
	  r = atof (cptr);
	  FixDrawCircle (x, y, r, XtWindow (UxGetWidget (drawingArea1)));
	  (void) CreateFixDrawnCircle (x, y, r);
	  break;
	case 3: /* points */
	  cptr = strtok (NULL, " ");
	  x = atof (cptr);
	  cptr = strtok (NULL, " ");
	  y = atof (cptr);
	  if (showPoints) 
	    FixDrawPoint (x, y, XtWindow (UxGetWidget (drawingArea1)));
	  (void) CreateFixDrawnPoint (x, y);
	  break;		      
	case 4: /* rings */
	  cptr = strtok (NULL, " ");
	  x = atof (cptr);
	  cptr = strtok (NULL, " ");
	  y = atof (cptr);
	  cptr = strtok (NULL, " ");
	  r = atof (cptr);
	  FixDrawRing (x, y, r, XtWindow (UxGetWidget (drawingArea1)));
	  (void) CreateFixDrawnRing (x, y, r);
	  break;
	default:
	  printf ("Option %s not yet installed\n", cptr);
	  break;
	}
      break;
    case 2: /* Distance */
      cptr = strtok (NULL, " ");
      distance = atof (cptr);
      parameterDialog_setDistance (parameterD, &UxEnv, distance);
      break;
    case 3: /* Centre */
      cptr = strtok (NULL, " ");
      centreX = atof (cptr);
      cptr = strtok (NULL, " ");
      centreY = atof (cptr);
      parameterDialog_setCentre (parameterD, &UxEnv, centreX, centreY);
      break;
    case 4: /* Rotation */
      cptr = strtok (NULL, " ");
      rotX = atof (cptr);
      cptr = strtok (NULL, " ");
      rotY = atof (cptr);
      cptr = strtok (NULL, " ");
      rotZ = atof (cptr);
      parameterDialog_setRotation (parameterD, &UxEnv, rotX, rotY, rotZ);
      break;
    case 5: /* Tilt */
      cptr = strtok (NULL, " ");
      tilt = atof (cptr);
      parameterDialog_setTilt (parameterD, &UxEnv, tilt);
      break;
    default:
      printf ("Option %s not yet installed\n", cptr);
      break;
    }
}

static int optcmp (char *wrdptr, char **optionpp)
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

static void say_yes ()
{
  command ("Y\n");
}

static void say_no ()
{
  command ("N\n");
}

static void DisBackFile ()
{
  NewFile(sBackFile,npix,nrast,1,2,1,1);
}

static void DisBackFile2 ()
{
  NewFile(sBackFile,npix,nrast,1,2,1,1);
  ConfirmDialogAsk(confirmD,"Perform more smoothing cycles?",DoCycles,EndCycles,NULL);
}

static void DoMore ()
{
  ConfirmDialogAsk(confirmD,"Perform more smoothing cycles?",DoCycles,EndCycles,NULL);
}

static void DoCycles ()
{
  UxPopupInterface(CycleParam,no_grab);
}

static void EndCycles ()
{
  command("n\n");
}

static void retry ()
{
  setupDialog_quit (setup, &UxEnv);
  firstRun = 1;
  command ("Y\n");
}

static void quit ()
{
  int i;
  XGputstring ("^D\n");
  XGclose ();
  exit(0);
}

static char *checkstr (char *string, int *icode)
{
  char *cptr = string, *endtmp, *sptr, tmp;
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
	      sptr = cptr;
	      endtmp = findtok (sptr, " :\n");
	      tmp = *endtmp;
	      *endtmp = '\0';
	      len = (int) strlen (sptr);
	      if (len < 3)
		{
		  while (*cptr)
		    {
		      *cptr++ = ' ';
		    }
		  *cptr++ = ' ';
		}
	      else
		{
		  if (((int) *cptr < (int) '1' || (int) *cptr > (int) '9'))
		    {
		      cptr++;
		      while (*cptr)
			{
			  if (((int) *cptr < (int) 'A' ||
			       (int) *cptr > (int) 'Z') &&
			      ((int) *cptr < (int) 'a' ||
			       (int) *cptr > (int) 'z'))
			    {
			      *cptr = '\0';
			      break;
			    }
			  cptr++;
			}
		      
		      if (strlen (sptr) < len)
			{
			  cptr = sptr;
			  while (*cptr)
			    {
			      *cptr++ = ' ';
			    }
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
		      cptr++;
		      while (*cptr)
			{
			  if ((int) *cptr < (int) '0' || (int) *cptr > (int) '9')
			    {
			      *cptr = '\0';
			      break;
			    }
			  cptr++;
			}

		      if (strlen (sptr) < len)
			{
			  cptr = sptr;
			  while (*cptr)
			    {
			      *cptr++ = ' ';
			    }
			  *cptr++ = ' ';		      
			}
		      else
			{ 
			  if (len == 3)
			    sscanf (sptr, "%d", icode);
			  
			  if (*icode < 100)
			    {
			      cptr = sptr;
			      while (*cptr)
				*cptr++ = ' ';
			    }
			  else
			    {
			      start = 0;
			      cptr = firstnon (endtmp, " ");
			    }
			}
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

static void SaveData ()
{
  command ("Y\n");
  show_fileSelect (drawFSD, "*000.*", currentDir, get_outfile, CancelSave);
}

static void CancelSave ()
{
  command ("^d\n");
  message_parser (NULL);
}

static void get_outfile (char *string)
{
  if (outfile)
    {
      free (outfile);
      outfile = NULL;
    }

  outfile = (char *) strdup (string + strlen (string) - 10);
  headerDialog_popup (header, &UxEnv, outfile);
}








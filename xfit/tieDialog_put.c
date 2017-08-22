  char *cptr, tmp[5];

  cptr = (char *) setupDialog_getDescription (setup, pEnv, par);
  if (cptr)
    {
      XtVaSetValues (labelPeak,
		     XmNlabelString, XmStringCreateLtoR (cptr, XmSTRING_DEFAULT_CHARSET),
		     NULL);

      sprintf (tmp, "%d", par);
      XmTextFieldSetString (textPar, tmp);
      
      setupDialog_getTie (setup, pEnv, par, &tiepar, &ctype, &ih, &ik, &il);

      cptr = (char *) setupDialog_getDescription (setup, pEnv, tiepar);

      if (cptr)
	{
	  XtSetSensitive (arrowButton2, TRUE);
	  XtSetSensitive (arrowButton1, TRUE);

	  XtVaSetValues (labelPeak2,
			 XmNlabelString, XmStringCreateLtoR (cptr, XmSTRING_DEFAULT_CHARSET),
			 NULL);

	  sprintf (tmp, "%d", tiepar);
	  XmTextFieldSetString (textTie_par, tmp);

	  switch (ctype)
	    {
	    case 0:
	      XtVaSetValues (tieMenu1,
			     XmNmenuHistory, tieMenu_equal,
			     NULL);
	      setH (FALSE, ih); setK (FALSE, ik); setL (FALSE, il);
	      break;
	      
	    case 1:
	      XtVaSetValues (tieMenu1,
			     XmNmenuHistory, tieMenu_hex,
			     NULL);
	      setH (TRUE, il); setK (TRUE, il);
	      break;
	    case 2:
	      XtVaSetValues (tieMenu1,
			     XmNmenuHistory, tieMenu_tet,
			     NULL);
	      setH (TRUE, il); setK (TRUE, il);
	      break;
	      
	    case 3:
	      XtVaSetValues (tieMenu1,
			     XmNmenuHistory, tieMenu_cub,
			     NULL);
	      setH (TRUE, il); setK (TRUE, il); setL (TRUE, il);
	    default:
	      break;
	    }
	}
      else
	{
	  /* Error Dialog */
	}
    }
  else
    {
      if (par == 0)
	{
	  par = 1;
	  XtSetSensitive (arrowButton2, FALSE);
	  XtSetSensitive (arrowButton1, TRUE);
	}
      else
	{
	  par--;
	  XtSetSensitive (arrowButton2, TRUE);
	  XtSetSensitive (arrowButton1, FALSE);
	}

    }

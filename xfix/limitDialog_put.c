/*
void limitDialog_put (swidget UxThis, Environment *pEnv)
{
*/
  char *cptr, tmp[20];

  cptr = (char *) setupDialog_getDescription (setup, pEnv, lpar);
  if (cptr)
    {
      XtSetSensitive (arrowB_limit2, TRUE);
      XtSetSensitive (arrowB_limit1, TRUE);

      XtVaSetValues (labelPeak1,
		     XmNlabelString, XmStringCreateLtoR (cptr, XmSTRING_DEFAULT_CHARSET),
		     NULL);

      sprintf (tmp, "%d", lpar);
      XmTextFieldSetString (textPar1, tmp);
      
      setupDialog_getLimits (setup, pEnv, lpar, &lim1, &lim2);

      sprintf (tmp,"%g", lim1);
      XmTextFieldSetString (textLimit1_1, tmp);

      sprintf (tmp,"%g", lim2);
      XmTextFieldSetString (textLimit1_2, tmp);
    }
  else
    {
      if (lpar == 0)
	{
	  lpar = 1;
	  XtSetSensitive (arrowB_limit2, FALSE);
	  XtSetSensitive (arrowB_limit1, TRUE);
	}
      else
	{
	  lpar--;
	  XtSetSensitive (arrowB_limit2, TRUE);
	  XtSetSensitive (arrowB_limit1, FALSE);
	}

    }
/*
}
End of limitDialog_put */


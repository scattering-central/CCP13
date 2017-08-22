/*
void setupDialog_reinit (swidget wgt, Environment *pEnv)
{
*/
  int i;
  double v;
  char *pcValue;

  if (stepitsChanged)
    {
      pcValue = XmTextFieldGetString (stepText);
      i = atoi (pcValue);
      free (pcValue);
      command ("siz %d\n", i);
      stepitsChanged = False;
    }

  if (maxitsChanged)
    {
      pcValue = XmTextFieldGetString (runmaxText);
      i = atoi (pcValue);
      free (pcValue);
      command ("max %d\n", i);
      maxitsChanged = False;
    }

  if (chitestChanged)
    {
      pcValue = XmTextFieldGetString (chitestText);
      i = atoi (pcValue);
      free (pcValue);
      command ("tes %f\n", i);
      chitestChanged = False;
    }

  if (autowarnChanged)
    {
      pcValue = XmTextFieldGetString (autowarnText);
      i = atoi (pcValue);
      free (pcValue);
      command ("war %f\n", i);
      autowarnChanged = False;
    }


  for (i=1; i<=npar; i++)
    {
      if (parRowColumn_checkVal (par_rowColInstance[i], pEnv, &v))
	{
	  command ("ini %d %g\n", i, v);
	}
    }

  return;
/*
}
End of setupDialog_reinit */

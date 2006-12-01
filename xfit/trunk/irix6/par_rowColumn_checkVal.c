/*
int par_rowColumn_checkVal (swidget UxThis, Environment *pEnv, double *v)
{
*/
  char *cp = (char *) XmTextFieldGetString (textVal);

  if ((*v = atof (cp)) != val)
    {
      val = *v;
      free (cp);
      return (1);
    }

  free (cp);
  return (0);
/*
}
End of par_rowColumn_checkVal */

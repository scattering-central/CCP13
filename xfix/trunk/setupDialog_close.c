/*
void setupDialog_close (swidget wgt, Environment *pEnv)
{
*/
  int i;

  UxPopdownInterface (UxThis);

  for (i=1; i<=npeak; i++)
    {
      XtDestroyWidget (peak_rowColInstance[i]);
    }

  for (i=1; i<=npar; i++)
    {
      XtDestroyWidget (par_rowColInstance[i]);
    }

  XtDestroyWidget (separator);
  XtDestroyWidget (labelBack_poly_degree);
  if (fexp)
    XtDestroyWidget (labelBack_exp_comp);

  npar = 0;
  npeak = 0;
  fexp = 0;
  current_y = 10;

  XtVaSetValues (UxGetWidget (form3),
		 XmNheight, 400,
		 NULL);

  return;
/*
}
End of setupDialog_close */

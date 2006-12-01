/*
int setupDialog_sensitive (swidget wgt, Environment *pEnv, Boolean tf)
{
*/
  int i;

  XtSetSensitive (UxGetWidget(pushButton_plot), tf);
  XtSetSensitive (UxGetWidget(pushButton_step), tf);
  XtSetSensitive (UxGetWidget(pushButton_run), tf);

  for (i=1; i<=npar; i++)
    {
      parRowColumn_sensitive (par_rowColInstance[i], pEnv, tf);
    }

  return;
/*
}
End of setupDialog_sensitive */

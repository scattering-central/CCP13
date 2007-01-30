/*
char *setupDialog_getDescr (swidget wgt, Environment *pEnv, int n)
{
*/
  char *cptr = NULL;

  if (n > 0 && n <= npar)
    cptr = (char *) parRowColumn_getDes (par_rowColInstance[n], pEnv);

  return (cptr);
/*
}
End of setupDialog_getDescr */

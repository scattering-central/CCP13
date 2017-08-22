/*
void setupDialog_set (swidget wgt, Environment *pEnv, char *string)
{
*/
  char *cptr;
  int i;

  cptr = strtok (string, " \n");
  if (!cptr)
    {
      return;
    }

  if (strcmp ("Parameter", cptr) == 0)
    {
      cptr = strtok (NULL, " ");
      i = atoi (cptr);
      cptr = strtok (NULL, " ");
      cptr = strtok (NULL, " ");
      parRowColumn_set (par_rowColInstance[i], &UxEnv, cptr);
    }

  return;
/*
}
End of setupDialog_set */

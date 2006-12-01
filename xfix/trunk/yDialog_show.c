/*
void yDialog_show (swidget UxThis, Environment *pEnv, char *string)
{
*/
  char *cptr;

  cptr = strtok (string, "[");
  cptr = strtok (NULL, ", ");
  XmTextFieldSetString (textField1, cptr);

  cptr = strtok (NULL, " ,]");
  XmTextFieldSetString (textField2, cptr);

  UxPopupInterface (UxThis, exclusive_grab);
/*
}
End of yDialog_show.c */

/*
void channelDialog_show (swidget UxThis, Environment *pEnv, char *string)
{
*/
  char *cptr;

  cptr = strtok (string, "[");
  cptr = strtok (NULL, ", ");
  XmTextFieldSetString (textChann1, cptr);

  cptr = strtok (NULL, " ,]");
  XmTextFieldSetString (textChann2, cptr);

  UxPopupInterface (UxThis, exclusive_grab);
/*
}
End of channelDialog_show */

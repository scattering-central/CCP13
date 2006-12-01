
static void setH (Boolean tf, int ind)
{
  char tmp[5];
#ifndef DESIGN_TIME 
  XtSetSensitive (UxGetWidget (label5), tf);
  XtSetSensitive (UxGetWidget (textH), tf);
  if (tf)
    {
      sprintf (tmp, "%d", ind);
    }
  else
    {
      sprintf (tmp, "");
    }
  XmTextFieldSetString (UxGetWidget(textH), tmp);
#endif
}
static void setK (Boolean tf, int ind)
{
  char tmp[5];
#ifndef DESIGN_TIME 
  XtSetSensitive (UxGetWidget (label6), tf);
  XtSetSensitive (UxGetWidget (textK), tf);
  if (tf)
    {
      sprintf (tmp, "%d", ind);
    }
  else
    {
      sprintf (tmp, "");
    }
  XmTextFieldSetString (UxGetWidget(textK), tmp);
#endif
}
static void setL (Boolean tf, int ind)
{
  char tmp[5];
#ifndef DESIGN_TIME 
  XtSetSensitive (UxGetWidget (label7), tf);
  XtSetSensitive (UxGetWidget (textL), tf);
  if (tf)
    {
      sprintf (tmp, "%d", ind);
    }
  else
    {
      sprintf (tmp, "");
    }
  XmTextFieldSetString (UxGetWidget(textL), tmp);
#endif
}




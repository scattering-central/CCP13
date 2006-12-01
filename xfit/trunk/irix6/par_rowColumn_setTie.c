/*
void par_rowColumn_setTie (swidget UxThis, Environment *pEnv, int t_num, int c_type, int ih, int ik, int il)
{
*/
  char buf[20];

  sprintf (buf, "%d", t_num);
  XmTextFieldSetString (textLimit1, buf);

  XtUnmapWidget (UxWidgetToSwidget (labelLimto));
  XtUnmapWidget (UxWidgetToSwidget (textLimit2));

  XtMapWidget (UxWidgetToSwidget (labelTieto));
  XtMapWidget (UxWidgetToSwidget (textLimit1));

  tie_num = t_num;
  constraint_type = c_type;
  ch = ih; ck = ik; cl = il;

  parRowColumn_setState (UxThis, pEnv, 3);
/*
}
End of par_rowColumn_setTie */

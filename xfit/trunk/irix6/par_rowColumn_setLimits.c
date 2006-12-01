/*
void par_rowColumn_setLimits (swidget UxThis, Environment *pEnv, double lim1, double lim2)
{
*/
  char buf[20];

  sprintf (buf, "%g", lim1);
  XmTextFieldSetString (textLimit1, buf);

  sprintf (buf, "%g", lim2);
  XmTextFieldSetString (textLimit2, buf);

  XtUnmapWidget (UxWidgetToSwidget (labelTieto));

  XtMapWidget (UxWidgetToSwidget (textLimit1));
  XtMapWidget (UxWidgetToSwidget (labelLimto));
  XtMapWidget (UxWidgetToSwidget (textLimit2));

  limit1 = lim1; limit2 = lim2;
  parRowColumn_setState (UxThis, pEnv, 2);
/*
}
End of par_rowColumn_setLimits */

par--;

#ifndef DESIGN_TIME
cptr = get_description (par_rowColumn(par));
#else
cptr = NULL;
#endif

if (cptr)
{
  XtVaSetValues (labelPeak,
		 XmNlabelString, XmStringCreateLtoR (cptr, XmSTRING_DEFAULT_CHARSET),
		 NULL);

  sprintf (tmp, "%d", par);
  XtVaSetValues (textPar,
		 XmNvalue, XmStringCreateLtoR (tmp, XmSTRING_DEFAULT_CHARSET),
		 NULL);
}
else
{
  par++;
  XtVaSetValues (UxWidget,
		 XmNsensitive, FALSE,
		 NULL);
}

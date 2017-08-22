void confirmDialog_ask (swidget wgt, char *msg, void (*yesfunc)(), void (*nofunc) (), char *helpptr)
{
    ok_function = yesfunc;
    cancel_function = nofunc;
    helpfile = helpptr;

    XtVaSetValues (UxGetWidget (wgt),
                   XmNmessageString,
                   XmStringCreateLtoR (msg, XmSTRING_DEFAULT_CHARSET),
		   NULL);

    if (helpfile)
      {
	XtSetSensitive (XmMessageBoxGetChild (UxGetWidget (wgt),
                         XmDIALOG_HELP_BUTTON), TRUE);
      }
    else
      {
	XtSetSensitive (XmMessageBoxGetChild (UxGetWidget (wgt),
                         XmDIALOG_HELP_BUTTON), FALSE);
      }

    UxPopupInterface (wgt, no_grab);

}
/* End of confirmDialog_ask */

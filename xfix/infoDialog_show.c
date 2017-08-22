/*
void infoDialog_show (swidget UxThis, Environment *pEnv, char *msg)
{
*/
    XtVaSetValues (UxGetWidget (UxThis),
                   XmNmessageString,
                   XmStringCreateLtoR (msg, XmSTRING_DEFAULT_CHARSET),
                   NULL);
    UxPopupInterface (UxThis, no_grab);
/*
}
End of infoDialog_show */

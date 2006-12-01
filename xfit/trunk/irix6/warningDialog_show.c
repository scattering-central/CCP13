/*
void warningDialog_show (swidget UxThis, Environment *pEnv, char *msg)
{
*/
    XtVaSetValues (UxGetWidget (UxThis),
                   XmNmessageString,
                   XmStringCreateLtoR (msg, XmSTRING_DEFAULT_CHARSET),
                   NULL);
    UxPopupInterface (UxThis, nonexclusive_grab);
/*
}
End of warningDialog_show.c */

/*
void errorDialog_show (swidget UxThis, Environment *pEnv, char *msg)
{
*/
    XtVaSetValues (UxGetWidget (UxThis),
                   XmNmessageString,
                   XmStringCreateLtoR (msg, XmSTRING_DEFAULT_CHARSET),
                   NULL);
    UxPopupInterface (UxThis, exclusive_grab);
/*
}
End of errorDialog_show */

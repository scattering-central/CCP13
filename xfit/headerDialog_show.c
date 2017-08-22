/*
void headerDialog_show (swidget UxThis, Environment *pEnv, char *filename)
{
*/
    char buf[80];

    sprintf (buf, "Header file information - %s", filename);
    XtVaSetValues (UxGetWidget (UxThis),
                   XmNmessageString,
                   XmStringCreateLtoR (buf, XmSTRING_DEFAULT_CHARSET),
                   NULL);

    UxPopupInterface (UxThis, exclusive_grab);
/*
}
End of headerDialog_show */

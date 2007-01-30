/*
void par_rowColumn_SetSensitive (swidget wgt, Environment *pEnv, Boolean tf)
{
*/
   XtSetSensitive (UxGetWidget (parMenu), tf);
   XtSetSensitive (UxGetWidget (textLimit1), tf);
   XtSetSensitive (UxGetWidget (textLimit2), tf);
   if (state != 1)
     XtSetSensitive (UxGetWidget (textVal), tf);
/*
}
End of par_row_column_set */

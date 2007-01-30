/*
void tieDialog_show (swidget UxThis, Environment *pEnv, int num)
{
*/
  cpar = par = num;
  setupDialog_getStat (setup, &UxEnv, num, &istate);
  tieDialog_tput (UxThis, pEnv);
  UxPopupInterface (UxThis, no_grab);
/*
}
End of tieDialog_show */

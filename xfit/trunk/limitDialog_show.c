/*
void limitDialog_show (swidget UxThis, Environment *pEnv, int num)
{
*/
  cpar = lpar = num;
  setupDialog_getState (setup, &UxEnv, num, &cstate);
  limitDialog_lput (UxThis, pEnv);
  UxPopupInterface (UxThis, no_grab); 
/*
}
End of limitDialog_show */

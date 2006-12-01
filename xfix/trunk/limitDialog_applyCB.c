char *cptr;

cptr = (char *) XmTextFieldGetString (textLimit1_1);
lim1 = atof (cptr);
free (cptr);

cptr = (char *) XmTextFieldGetString (textLimit1_2);
lim2 = atof (cptr);
free (cptr);

if (lim2 != lim1)
{
  command ("delta %d %g %g\n", lpar, lim1, lim2);
  setupDialog_setLimitsN (setup, &UxEnv, lpar, lim1, lim2);
  if (lpar == cpar)
    cstate = 2;
}







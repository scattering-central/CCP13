char *cptr;
double d1, d2;

cptr  = XmTextFieldGetString (textField1);
d1 = atof (cptr);
free (cptr);

cptr = XmTextFieldGetString (textField2);
d2 = atof (cptr);
free (cptr);

command ("%g %g", d1, d2);

command ("\n");
UxPopdownInterface (UxThisWidget);
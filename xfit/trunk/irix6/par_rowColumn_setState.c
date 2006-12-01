/*
void par_rowColumn_setState (swidget UxThis, Environment *pEnv, int istate)
{
*/
  switch (istate)
    {
    case 0:
      XtVaSetValues (parMenu,
		     XmNmenuHistory, stateMenu_free1,
		     NULL);
      XtVaSetValues (stateMenu_tied1,
		     XmNlabelString, XmStringCreateLtoR ("Tie...", XmSTRING_DEFAULT_CHARSET),
		     NULL);
      XtVaSetValues (stateMenu_limited1,
		     XmNlabelString, XmStringCreateLtoR ("Limit...", XmSTRING_DEFAULT_CHARSET),
		     NULL);
      break;

    case 1:
      XtVaSetValues (parMenu,
		     XmNmenuHistory, stateMenu_set1,
		     NULL);
      XtVaSetValues (stateMenu_tied1,
		     XmNlabelString, XmStringCreateLtoR ("Tie...", XmSTRING_DEFAULT_CHARSET),
		     NULL);
      XtVaSetValues (stateMenu_limited1,
		     XmNlabelString, XmStringCreateLtoR ("Limit...", XmSTRING_DEFAULT_CHARSET),
		     NULL);
      break;

    case 2:
      XtVaSetValues (parMenu,
		     XmNmenuHistory, stateMenu_limited1,
		     NULL);
      XtVaSetValues (stateMenu_tied1,
		     XmNlabelString, XmStringCreateLtoR ("Tie...", XmSTRING_DEFAULT_CHARSET),
		     NULL);
      XtVaSetValues (stateMenu_limited1,
		     XmNlabelString, XmStringCreateLtoR ("Limited", XmSTRING_DEFAULT_CHARSET),
		     NULL);
      break;

    case 3:
      XtVaSetValues (parMenu,
		     XmNmenuHistory, stateMenu_tied1,
		     NULL);
      XtVaSetValues (stateMenu_tied1,
		     XmNlabelString, XmStringCreateLtoR ("Tied", XmSTRING_DEFAULT_CHARSET),
		     NULL);
      XtVaSetValues (stateMenu_limited1,
		     XmNlabelString, XmStringCreateLtoR ("Limit...", XmSTRING_DEFAULT_CHARSET),
		     NULL);
      break;
    default:
      return;
    }

  state = istate;
/*
}
End of par_rowColumn_setState */



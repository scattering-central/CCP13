char *cptr, tmp[20];
double v;
int tmppar, s_tmp, t_tmp, c_tmp, th, tk, tl;

cptr = (char *) XmTextFieldGetString (UxGetWidget (textTie_par));
tiepar = atoi (cptr);
free (cptr);
cptr = (char *) XmTextFieldGetString (UxGetWidget (textH));
ih = atoi (cptr);
free (cptr);
cptr = (char *) XmTextFieldGetString (UxGetWidget (textK));
ik = atoi (cptr);
free (cptr);
cptr = (char *) XmTextFieldGetString (UxGetWidget (textL));
il = atoi (cptr);
free (cptr);

if (tiepar != par)
{
/*
 * Check parameter order
 */
  if (tiepar > par)
    {
      tmppar = tiepar;
      tiepar = par;
      par = tmppar;
    }
/*
 * Search down to find base parameter of constraint
 */
  tmppar = tiepar;
  while (tmppar > 0)
    {
      setupDialog_getStateN (setup, &UxEnv, tmppar, &s_tmp);
      if (s_tmp == 3)
	{
	  setupDialog_getTieN (setup, &UxEnv, tmppar, &t_tmp, &c_tmp, &th, &tk, &tl);
	  if (t_tmp == tmppar)
	    {
	      tiepar = tmppar;
	      tmppar = 0;
	    }
	  else
	    {
	      tmppar = t_tmp;
	    }
	}
      else
	{
	  tiepar = tmppar;
	  tmppar = 0; 
	}
    }
/*
 * Check tiepar is a valid parameter
 */
  cptr = (char *) setupDialog_getDescrN (setup, &UxEnv, tiepar);

  if (cptr)
    {
/*
 * Set up tie for par parameter
 */ 
      setupDialog_setTieN (setup, &UxEnv, par, tiepar, ctype, ih, ik, il);
      tieDialog_tput (UxThisWidget, &UxEnv);
      (void) setupDialog_checkValN (setup, &UxEnv, tiepar, &v);
      sprintf (tmp, "%g", v);
      setupDialog_setParRC (setup, &UxEnv, par, tmp);
      command ("fre %d\n", par);
      command ("ini %d %g\n", par , v);

      switch ( (int) constraint[0] )
	{
	case (int) 'h':
	case (int) 't':
	  command ("tie %d %d %s %d %d\n", par, tiepar, constraint, ih, ik);
	  break;
	case (int) 'c':
	  command ("tie %d %d %s %d %d %d\n", par, tiepar, constraint, ih, ik, il);
	  break;
	case (int) '\0':
	default:
	  command ("tie %d %d\n", par, tiepar);
	}

      if (par == cpar)
	istate = 3;
/*
 * Search to last parameter resetting ties
 */
      tmppar = par + 1;
      while (setupDialog_getDescrN (setup, &UxEnv, tmppar))
	{
	  setupDialog_getStateN (setup, &UxEnv, tmppar, &s_tmp);
	  if (s_tmp == 3)
	    {
	      setupDialog_getTieN (setup, &UxEnv, tmppar, &t_tmp, &c_tmp, &th, &tk, &tl);
	      if (t_tmp == par)
		{
		  setupDialog_setParRC (setup, &UxEnv, tmppar, tmp);
		  command ("fre %d\n", tmppar);
		  command ("ini %d %g\n", tmppar , v);
		  
		  switch (c_tmp)
		    {
		    case 3:
		      command ("tie %d %d cub %d %d %d\n", tmppar, tiepar, th, tk, tl);
		      break;
		    case 2:
		      command ("tie %d %d tet %d %d\n", tmppar, tiepar, th, tk);
		      break;
		    case 1:
		      command ("tie %d %d hex %d %d\n", tmppar, tiepar, th, tk);
		      break;
		    case 0:
		    default:
		      command ("tie %d %d\n", tmppar, tiepar);
		      break;
		    }
		  
		  setupDialog_setTieN (setup, &UxEnv, tmppar, tiepar, c_tmp, th, tk, tl);
		}
	    }
	  tmppar++;
	}     
    }
  else
    {
      /* Error Dialog */
    }
}


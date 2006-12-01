{
  int button, x, y;
  static int ifp, ilp, ifr, ilr, itemp;
  static unsigned int width, height;
  static int call = 0;

  if (call == 0)
    {
      ifp = 3 * MAGDIM / 8;
      ifr = 3 * MAGDIM / 8;
      ilp = 5 * MAGDIM / 8;
      ilr = 5 * MAGDIM / 8;
      width = ilp - ifp + 1;
      height = ilr - ifr + 1;
    }

  switch (UxEvent->type)
    {
    case ButtonPress:
      button = UxEvent->xbutton.button;
      switch (button)
	{
	case 3:
	  if (call) 
	    {
	      XDrawRectangle (UxDisplay, XtWindow (UxWidget), drawGC, ifp, ifr, 
			      width, height);
	      ProcessRect2 (ifp, ilp, ifr, ilr);
	      call = 0;
	    }
	  return;
	default:
	  break;
	}

    case MotionNotify:
      do
	{
	  x = UxEvent->xmotion.x;
	  y = UxEvent->xmotion.y;
	}
      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, 
				     UxEvent));

      if (call) XDrawRectangle (UxDisplay, XtWindow (UxWidget), drawGC, ifp, ifr, 
				width, height);
      TrackArea2 (UxWidget, UxEvent);
			   
      switch (button)
	{
	case 1:
	  ifp = x;
	  ifr = y;  
	  break;
	case 2:
	  ilp = x;
	  ilr = y;
	  break;
	default:
	  break;
	}

      if (ifp > ilp) SWAP (ifp, ilp);
      if (ifr > ilr) SWAP (ifr, ilr);
      width = ilp - ifp + 1;
      height = ilr - ifr + 1;
      XDrawRectangle (UxDisplay, XtWindow (UxWidget), drawGC, ifp, ifr, width, height);
    }
  call++;
}

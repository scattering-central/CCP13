{
  int button, x, y;
  static int xOld, yOld;
  static int xv[MAXVERTS], yv[MAXVERTS];
  static int motion = 0, press = 0, nv = 0;

  switch (UxEvent->type)
    {
    case ButtonPress:
      button = UxEvent->xbutton.button;
      switch (button)
	{
	case 2:
	  if (nv > 0)
	    {
	      nv--;
	      if (nv > 0)
		{
		  XDrawLine (UxDisplay, XtWindow (UxWidget), drawGC, 
			     xv[nv - 1], yv[nv - 1], xv[nv], yv[nv]);
		}
	      else
		{
		  XDrawPoint (UxDisplay, XtWindow (UxWidget), drawGC, xv[0], yv[0]);
		}
	    }
	  break;
 
	case 3:
	  if (press)
	    XDrawLine (UxDisplay, XtWindow (UxWidget), drawGC, xv[0], yv[0],
		       xv[nv - 1], yv[nv - 1]);

	  if (nv > 2)ProcessPoly2 (xv, yv, nv);
	  nv = 0;
	  motion = 0;
	  press = 0;
	  return;

	default:
	  break;
	}
      press++;
      break;

    case ButtonRelease:
      button = UxEvent->xbutton.button;
      switch (button)
	{
	case 1:
	  if (nv >= MAXVERTS)
	    {
	      printf ("Too many vertices!\n");
	      return;
	    }

	  x = UxEvent->xbutton.x;
	  y = UxEvent->xbutton.y;
	  
	  if (x >= 0 && x < MAGDIM && y >= 0 && y < MAGDIM)
	    {
	      if (nv == 0)
		XDrawPoint (UxDisplay, XtWindow (UxWidget), drawGC, x, y);
	      
	      if (nv > 0 && motion == 0)
		XDrawLine (UxDisplay, XtWindow (UxWidget), drawGC, 
			   xv[nv - 1], yv[nv - 1], x, y);
	  
	      xv[nv] = x;
	      yv[nv] = y;
	      nv++;  
	    }
	  break;

	default:
	  break;
	}
      motion = 0;
      break;

    case MotionNotify:
      do
	{
	  x = UxEvent->xmotion.x;
	  y = UxEvent->xmotion.y;
	}
      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, 
				     UxEvent));

      TrackArea2 (UxWidget, UxEvent);

      switch (button)
	{
	case 1:
	  if (nv > 0)
	    {
	      if (motion) XDrawLine (UxDisplay, XtWindow (UxWidget), drawGC, 
				     xv[nv - 1], yv[nv - 1], xOld, yOld);
	  
	      xOld = x;
	      yOld = y;
	      XDrawLine (UxDisplay, XtWindow (UxWidget), drawGC, 
			 xv[nv - 1], yv[nv - 1], x, y);
	  
	      motion++;
	    }
	  break;

	default:
	  break;
	}
      break;

    default:
      break;
    }
}

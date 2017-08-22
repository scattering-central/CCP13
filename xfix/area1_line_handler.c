{
  int button, x, y;
  static int ifp, ilp, ifr, ilr;
  static int call = 0;

  if (currentImage < 0)
    return;

  if (call == 0)
    {
      ifp = 3 * xi[currentImage]->width / 8;
      ifr = 4 * xi[currentImage]->height / 8;
      ilp = 5 * xi[currentImage]->width / 8;
      ilr = 4 * xi[currentImage]->height / 8;
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
	      XDrawLine (UxDisplay, XtWindow (UxWidget), drawGC, ifp, ifr, ilp, ilr);
	      ProcessLine1 (ifp, ilp, ifr, ilr, 0);
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

      if (call) XDrawLine (UxDisplay, XtWindow (UxWidget), drawGC, ifp, ifr, ilp, ilr);
      UpdateArea2 (UxWidget, UxEvent);
			   
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

      XDrawLine (UxDisplay, XtWindow (UxWidget), drawGC, ifp, ifr, ilp, ilr);
    }
  call++;
}

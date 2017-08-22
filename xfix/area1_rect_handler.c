{
  int button, x, y;
  static int ifp, ilp, ifr, ilr, itemp;
  static unsigned int width, height;
  static int call = 0;

  if (currentImage < 0)
    return;

  if (call == 0)
    {
      ifp = 3 * xi[currentImage]->width / 8;
      ifr = 3 * xi[currentImage]->height / 8;
      ilp = 5 * xi[currentImage]->width / 8;
      ilr = 5 * xi[currentImage]->height / 8;
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
	      ProcessRect1 (ifp, ilp, ifr, ilr);
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
	  
      if (ifp > ilp) SWAP (ifp, ilp);
      if (ifr > ilr) SWAP (ifr, ilr);
      width = ilp - ifp + 1;
      height = ilr - ifr + 1;
      XDrawRectangle (UxDisplay, XtWindow (UxWidget), drawGC, ifp, ifr, width, height);
    }
  call++;
}

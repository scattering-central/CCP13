{
  int button, state, x, y;
  static int ifp, ilp, ifr, ilr, width;
  static XPoint points[5];
  static int call = 0;

  if (call == 0)
    {
      ifp = 2 * MAGDIM / 8;
      ifr = 4 * MAGDIM / 8;
      ilp = 6 * MAGDIM / 8;
      ilr = 4 * MAGDIM / 8;
      width = 10;
    }

  switch (UxEvent->type)
    {
    case ButtonPress:
      button = UxEvent->xbutton.button;
      state = UxEvent->xbutton.state;
      switch (button)
	{
	case 3:
	  if (call) 
	    {
	      XDrawLines (UxDisplay, XtWindow (UxWidget), drawGC, points, 5, 
			  CoordModeOrigin);
	      ProcessLine2 (ifp, ilp, ifr, ilr, width);
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

      if (call) XDrawLines (UxDisplay, XtWindow (UxWidget), drawGC, points, 5, 
			    CoordModeOrigin);
      TrackArea2 (UxWidget, UxEvent);
			   
      switch (button)
	{
	case 1:
	  if (state & ShiftMask)
	    {
	      width = fwidth (ifp, ilp, ifr, ilr, x, y);
	    }
	  else
	    {
	      ifp = x;
	      ifr = y;
	    }
	  break;
	case 2:
	  ilp = x;
	  ilr = y;
	  break;
	default:
	  break;
	}

      fpoint (xi[currentImage]->width, xi[currentImage]->height, ifp, ilp, ifr, ilr, 
	      width, points);
      XDrawLines (UxDisplay, XtWindow (UxWidget), drawGC, points, 5, CoordModeOrigin);  
    }
  call++;
}

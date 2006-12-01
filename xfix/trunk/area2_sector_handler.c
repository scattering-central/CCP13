{
  int button, x, y;
  double r, phi, dx, dy, xc, yc;
  static int x1, y1, x2, y2, ixc, iyc;
  static int call = 0;

  if (currentImage < 0)
    return;

  if (call == 0)
    {
      mainWS_getCentre (mainWS, &UxEnv, &xc, &yc);
      FileToImageCoords ((float) xc, (float) yc, xi[currentImage], &ixc, &iyc);
      x1 = ixc + 2 * MAGDIM / 8;
      y1 = iyc + MAGDIM / 8;
      x2 = ixc + MAGDIM / 8;
      y2 = iyc - MAGDIM / 8;
    }

  switch (UxEvent->type)
    {
    case ButtonPress:
      button = UxEvent->xbutton.button;
      switch (button)
	{
	case 1:
	  if (UxEvent->xbutton.state & ShiftMask)
	    {
              if (call)
                {
	          DrawSector (UxDisplay, XtWindow (UxWidget), drawGC, ixc, iyc, 
			      x1, y1, x2, y2);	
                }      
	      dx = (double) (x2 - ixc);
	      dy = (double) (iyc - y2);	      
	      r = sqrt (dx * dx + dy * dy);
              dx = (double) (x1 - ixc);
	      dy = (double) (iyc - y1);
	      phi = atan2 (dy, dx);
	      x2 = ixc + (int) (r * cos (phi) + sin (phi));
	      y2 = iyc - (int) (r * sin (phi) - cos (phi));
	      DrawSector (UxDisplay, XtWindow (UxWidget), drawGC, ixc, iyc, 
			  x1, y1, x2, y2);
	    }
	  break;
	case 2:
	  if (UxEvent->xbutton.state & ShiftMask)
	    {
              if (call)
                {
	          DrawSector (UxDisplay, XtWindow (UxWidget), drawGC, ixc, iyc, 
			      x1, y1, x2, y2);	
                }      
              dx = (double) (x1 - ixc);
	      dy = (double) (iyc - y1);
	      r = sqrt (dx * dx + dy * dy);
	      dx = (double) (x2 - ixc);
	      dy = (double) (iyc - y2);	      
	      phi = atan2 (dy, dx);
	      x1 = ixc + (int) (r * cos (phi) - sin (phi));
	      y1 = iyc - (int) (r * sin (phi) + cos (phi));
	      DrawSector (UxDisplay, XtWindow (UxWidget), drawGC, ixc, iyc, 
			  x1, y1, x2, y2);
	    }
	  break;
	case 3:
	  if (call) 
	    {
	      DrawSector (UxDisplay, XtWindow (UxWidget), drawGC, ixc, iyc, 
			  x1, y1, x2, y2);
	      ProcessSector1 (x1, y1, x2, y2);
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

      if (call)	DrawSector (UxDisplay, XtWindow (UxWidget), drawGC, ixc, iyc, 
			    x1, y1, x2, y2);
 
      TrackArea2 (UxWidget, UxEvent);
			   
      switch (button)
	{
	case 1:
	  x1 = x;
	  y1 = y;  
	  break;
	case 2:
	  x2 = x;
	  y2 = y;
	  break;
	default:
	  break;
	}
	  
      DrawSector (UxDisplay, XtWindow (UxWidget), drawGC, ixc, iyc, x1, y1, x2, y2);  
    }

  call++; 
}

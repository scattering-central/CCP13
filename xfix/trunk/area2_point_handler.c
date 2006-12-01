{
  switch (UxEvent->type)
    {
    case ButtonPress:
      switch (UxEvent->xbutton.button)
	{
	case 1:
	  if (setMagnify) ProcessPoint2 (UxWidget, UxEvent);
	  break;
	case 3:
	  setMagnify = False;
	  break;
	default:
          break;
	}

    case MotionNotify:
      if (setMagnify) TrackArea2 (UxWidget, UxEvent);

    default:
      break;
    }
}

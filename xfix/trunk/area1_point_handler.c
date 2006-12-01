{
  switch (UxEvent->type)
    {
    case ButtonPress:
      switch (UxEvent->xbutton.button)
	{
	case 1:
	  ProcessPoint1 (UxWidget, UxEvent);
	  break;
	case 2:
	  setMagnify = True;
	  break;
	case 3:
	  setMagnify = False;
	  break;
	default:
          break;
	}

    case MotionNotify:
      UpdateArea2 (UxWidget, UxEvent);

    default:
      break;
    }
}

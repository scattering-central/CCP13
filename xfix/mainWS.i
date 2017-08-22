! UIMX ascii 2.9 key: 377                                                       
*action.refresh_image1: {Refresh1 (UxWidget, UxEvent);}
*action.area1_point_handler: {\
  switch (UxEvent->type)\
    {\
    case ButtonPress:\
      switch (UxEvent->xbutton.button)\
	{\
	case 1:\
	  ProcessPoint1 (UxWidget, UxEvent);\
	  break;\
	case 2:\
	  setMagnify = True;\
	  break;\
	case 3:\
	  setMagnify = False;\
	  break;\
	default:\
          break;\
	}\
\
    case MotionNotify:\
      UpdateArea2 (UxWidget, UxEvent);\
\
    default:\
      break;\
    }\
}\

*action.refresh_image2: {Refresh2 (UxWidget, UxEvent);}
*action.area2_point_handler: {\
  switch (UxEvent->type)\
    {\
    case ButtonPress:\
      switch (UxEvent->xbutton.button)\
	{\
	case 1:\
	  if (setMagnify) ProcessPoint2 (UxWidget, UxEvent);\
	  break;\
	case 3:\
	  setMagnify = False;\
	  break;\
	default:\
          break;\
	}\
\
    case MotionNotify:\
      if (setMagnify) TrackArea2 (UxWidget, UxEvent);\
\
    default:\
      break;\
    }\
}\

*action.area1_line_handler: {\
  int button, x, y;\
  static int ifp, ilp, ifr, ilr;\
  static int call = 0;\
\
  if (currentImage < 0)\
    return;\
\
  if (call == 0)\
    {\
      ifp = 3 * xi[currentImage]->width / 8;\
      ifr = 4 * xi[currentImage]->height / 8;\
      ilp = 5 * xi[currentImage]->width / 8;\
      ilr = 4 * xi[currentImage]->height / 8;\
    }\
\
  switch (UxEvent->type)\
    {\
    case ButtonPress:\
      button = UxEvent->xbutton.button;\
      switch (button)\
	{\
	case 3:\
	  if (call) \
	    {\
	      XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, ilp, ilr);\
	      ProcessLine1 (ifp, ilp, ifr, ilr, 0);\
	      call = 0;\
	    }\
	  return;\
	default:\
	  break;\
	}\
\
    case MotionNotify:\
      do\
	{\
	  x = UxEvent->xmotion.x;\
	  y = UxEvent->xmotion.y;\
	}\
      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, \
				     UxEvent));\
\
      if (call) XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, ilp, ilr);\
      UpdateArea2 (UxWidget, UxEvent);\
			   \
      switch (button)\
	{\
	case 1:\
	  ifp = x;\
	  ifr = y;\
	  break;\
	case 2:\
	  ilp = x;\
	  ilr = y;\
	  break;\
	default:\
	  break;\
	}\
\
      XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, ilp, ilr);\
    }\
  call++;\
}\

*action.area1_thick_handler: {\
  int button, state, x, y;\
  static int ifp, ilp, ifr, ilr, width;\
  static XPoint points[5];\
  static int call = 0;\
\
  if (currentImage < 0)\
    return;\
\
  if (call == 0)\
    {\
      ifp = 2 * xi[currentImage]->width / 8;\
      ifr = 4 * xi[currentImage]->height / 8;\
      ilp = 6 * xi[currentImage]->width / 8;\
      ilr = 4 * xi[currentImage]->height / 8;\
      width = 10;\
    }\
\
  switch (UxEvent->type)\
    {\
    case ButtonPress:\
      button = UxEvent->xbutton.button;\
      state = UxEvent->xbutton.state;\
      switch (button)\
	{\
	case 3:\
	  if (call) \
	    {\
	      XDrawLines (UxDisplay, XtWindow (UxWidget), actionGC, points, 5, \
			  CoordModeOrigin);\
	      ProcessLine1 (ifp, ilp, ifr, ilr, width);\
	      call = 0;\
	    }\
	  return;\
	default:\
	  break;\
	}\
\
    case MotionNotify:\
      do\
	{\
	  x = UxEvent->xmotion.x;\
	  y = UxEvent->xmotion.y;\
	}\
      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, \
				     UxEvent));\
\
      if (call) XDrawLines (UxDisplay, XtWindow (UxWidget), actionGC, points, 5, \
			    CoordModeOrigin);\
      UpdateArea2 (UxWidget, UxEvent);\
			   \
      switch (button)\
	{\
	case 1:\
	  if (state & ShiftMask)\
	    {\
	      width = fwidth (ifp, ilp, ifr, ilr, x, y);\
	    }\
	  else\
	    {\
	      ifp = x;\
	      ifr = y;\
	    }\
	  break;\
	case 2:\
	  ilp = x;\
	  ilr = y;\
	  break;\
	default:\
	  break;\
	}\
\
      fpoint (xi[currentImage]->width, xi[currentImage]->height, ifp, ilp, ifr, ilr, \
	      width, points);\
      XDrawLines (UxDisplay, XtWindow (UxWidget), actionGC, points, 5, CoordModeOrigin);  \
    }\
  call++;\
}\

*action.area1_rect_handler: {\
  int button, x, y;\
  static int ifp, ilp, ifr, ilr, itemp;\
  static unsigned int width, height;\
  static int call = 0;\
\
  if (currentImage < 0)\
    return;\
\
  if (call == 0)\
    {\
      ifp = 3 * xi[currentImage]->width / 8;\
      ifr = 3 * xi[currentImage]->height / 8;\
      ilp = 5 * xi[currentImage]->width / 8;\
      ilr = 5 * xi[currentImage]->height / 8;\
      width = ilp - ifp + 1;\
      height = ilr - ifr + 1;\
    }\
\
  switch (UxEvent->type)\
    {\
    case ButtonPress:\
      button = UxEvent->xbutton.button;\
      switch (button)\
	{\
	case 3:\
	  if (call) \
	    {\
	      XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, \
			      width, height);\
	      ProcessRect1 (ifp, ilp, ifr, ilr);\
	      call = 0;\
	    }\
	  return;\
	default:\
	  break;\
	}\
\
    case MotionNotify:\
      do\
	{\
	  x = UxEvent->xmotion.x;\
	  y = UxEvent->xmotion.y;\
	}\
      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, \
				     UxEvent));\
\
      if (call) XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, \
				width, height);\
      UpdateArea2 (UxWidget, UxEvent);\
			   \
      switch (button)\
	{\
	case 1:\
	  ifp = x;\
	  ifr = y;  \
	  break;\
	case 2:\
	  ilp = x;\
	  ilr = y;\
	  break;\
	default:\
	  break;\
	}\
	  \
      if (ifp > ilp) SWAP (ifp, ilp);\
      if (ifr > ilr) SWAP (ifr, ilr);\
      width = ilp - ifp + 1;\
      height = ilr - ifr + 1;\
      XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, width, height);\
    }\
  call++;\
}\

*action.area1_poly_handler: {\
  int button, x, y;\
  static int xOld, yOld;\
  static int xv[MAXVERTS], yv[MAXVERTS];\
  static int motion = 0, press = 0, nv = 0;\
\
  if (currentImage < 0)\
    return;\
\
  switch (UxEvent->type)\
    {\
    case ButtonPress:\
      button = UxEvent->xbutton.button;\
      switch (button)\
	{\
	case 2:\
	  if (nv > 0)\
	    {\
	      nv--;\
	      if (nv > 0)\
		{\
		  XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, \
			     xv[nv - 1], yv[nv - 1], xv[nv], yv[nv]);\
		}\
	      else\
		{\
		  XDrawPoint (UxDisplay, XtWindow (UxWidget), actionGC, xv[0], yv[0]);\
		}\
	    }\
	  break;\
 \
	case 3:\
	  if (press)\
	    XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, xv[0], yv[0],\
		       xv[nv - 1], yv[nv - 1]);\
\
	  if (nv > 2)ProcessPoly1 (xv, yv, nv);\
	  nv = 0;\
	  motion = 0;\
	  press = -1;\
	  return;\
\
	default:\
	  break;\
	}\
      press++;\
      break;\
\
    case ButtonRelease:\
      button = UxEvent->xbutton.button;\
      switch (button)\
	{\
	case 1:\
	  if (nv >= MAXVERTS)\
	    {\
	      printf ("Too many vertices!\n");\
	      return;\
	    }\
\
	  x = UxEvent->xbutton.x;\
	  y = UxEvent->xbutton.y;\
	  \
	  if (x >= 0 && x < xi[currentImage]->width && \
	      y >= 0 && y < xi[currentImage]->height)\
	    {\
	      if (nv == 0)\
		XDrawPoint (UxDisplay, XtWindow (UxWidget), actionGC, x, y);\
	      \
	      if (nv > 0 && motion == 0)\
		XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, \
			   xv[nv - 1], yv[nv - 1], x, y);\
	  \
	      xv[nv] = x;\
	      yv[nv] = y;\
	      nv++;  \
	    }\
	  break;\
\
	default:\
	  break;\
	}\
      motion = 0;\
      break;\
\
    case MotionNotify:\
      do\
	{\
	  x = UxEvent->xmotion.x;\
	  y = UxEvent->xmotion.y;\
	}\
      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, \
				     UxEvent));\
\
      UpdateArea2 (UxWidget, UxEvent);\
\
      switch (button)\
	{\
	case 1:\
	  if (nv > 0)\
	    {\
	      if (motion) XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, \
				     xv[nv - 1], yv[nv - 1], xOld, yOld);\
	  \
	      xOld = x;\
	      yOld = y;\
	      XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, \
			 xv[nv - 1], yv[nv - 1], x, y);\
	  \
	      motion++;\
	    }\
	  break;\
\
	default:\
	  break;\
	}\
      break;\
\
    default:\
      break;\
    }\
}\

*action.area1_zoom_handler: {\
  int button, x, y;\
  static int ifp, ilp, ifr, ilr, itemp;\
  static unsigned int width, height;\
  static int call = 0;\
\
  if (currentImage < 0)\
    return;\
\
  if (call == 0)\
    {\
      ifp = 2 * xi[currentImage]->width / 8;\
      ifr = 2 * xi[currentImage]->height / 8;\
      ilp = 6 * xi[currentImage]->width / 8;\
      ilr = 6 * xi[currentImage]->height / 8;\
      width = ilp - ifp + 1;\
      height = ilr - ifr + 1;\
    }\
\
  switch (UxEvent->type)\
    {\
    case ButtonPress:\
      button = UxEvent->xbutton.button;\
      switch (button)\
	{\
	case 3:\
	  if (call) \
	    {\
	      width = ilp - ifp + 1;\
	      height = ilr - ifr + 1;\
	      XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr,\
			      width, height);\
	      ProcessBox1 (ifp, ifr, width, height);\
	      call = 0;\
	    }\
	  return;\
	default:\
	  break;\
	}\
\
    case MotionNotify:\
      do\
	{\
	  x = UxEvent->xmotion.x;\
	  y = UxEvent->xmotion.y;\
	}\
      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, \
				     UxEvent));\
\
      if (call) XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, \
				width, height);\
      UpdateArea2 (UxWidget, UxEvent);\
			   \
      switch (button)\
	{\
	case 1:\
	  ifp = x;\
	  ifr = y;  \
	  break;\
	case 2:\
	  ilp = x;\
	  ilr = y;\
	  break;\
	default:\
	  break;\
	}\
      \
      if (ifp > ilp) SWAP (ifp, ilp);\
      if (ifr > ilr) SWAP (ifr, ilr);\
      width = ilp - ifp + 1;\
      height = ilr - ifr + 1;\
      XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, width, height);\
    }\
  call++;\
}\

*action.area2_line_handler: {\
  int button, x, y;\
  static int ifp, ilp, ifr, ilr;\
  static int call = 0;\
\
  if (call == 0)\
    {\
      ifp = 3 * MAGDIM / 8;\
      ifr = 4 * MAGDIM / 8;\
      ilp = 5 * MAGDIM / 8;\
      ilr = 4 * MAGDIM / 8;\
    }\
\
  switch (UxEvent->type)\
    {\
    case ButtonPress:\
      button = UxEvent->xbutton.button;\
      switch (button)\
	{\
	case 3:\
	  if (call) \
	    {\
	      XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, ilp, ilr);\
	      ProcessLine2 (ifp, ilp, ifr, ilr, 0);\
	      call = 0;\
	    }\
	  return;\
	default:\
	  break;\
	}\
\
    case MotionNotify:\
      do\
	{\
	  x = UxEvent->xmotion.x;\
	  y = UxEvent->xmotion.y;\
	}\
      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, \
				     UxEvent));\
\
      if (call) XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, ilp, ilr);\
      TrackArea2 (UxWidget, UxEvent);\
			   \
      switch (button)\
	{\
	case 1:\
	  ifp = x;\
	  ifr = y;\
	  break;\
	case 2:\
	  ilp = x;\
	  ilr = y;\
	  break;\
	default:\
	  break;\
	}\
\
      XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, ilp, ilr);\
    }\
  call++;\
}\

*action.area2_thick_handler: {\
  int button, state, x, y;\
  static int ifp, ilp, ifr, ilr, width;\
  static XPoint points[5];\
  static int call = 0;\
\
  if (call == 0)\
    {\
      ifp = 2 * MAGDIM / 8;\
      ifr = 4 * MAGDIM / 8;\
      ilp = 6 * MAGDIM / 8;\
      ilr = 4 * MAGDIM / 8;\
      width = 10;\
    }\
\
  switch (UxEvent->type)\
    {\
    case ButtonPress:\
      button = UxEvent->xbutton.button;\
      state = UxEvent->xbutton.state;\
      switch (button)\
	{\
	case 3:\
	  if (call) \
	    {\
	      XDrawLines (UxDisplay, XtWindow (UxWidget), actionGC, points, 5, \
			  CoordModeOrigin);\
	      ProcessLine2 (ifp, ilp, ifr, ilr, width);\
	      call = 0;\
	    }\
	  return;\
	default:\
	  break;\
	}\
\
    case MotionNotify:\
      do\
	{\
	  x = UxEvent->xmotion.x;\
	  y = UxEvent->xmotion.y;\
	}\
      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, \
				     UxEvent));\
\
      if (call) XDrawLines (UxDisplay, XtWindow (UxWidget), actionGC, points, 5, \
			    CoordModeOrigin);\
      TrackArea2 (UxWidget, UxEvent);\
			   \
      switch (button)\
	{\
	case 1:\
	  if (state & ShiftMask)\
	    {\
	      width = fwidth (ifp, ilp, ifr, ilr, x, y);\
	    }\
	  else\
	    {\
	      ifp = x;\
	      ifr = y;\
	    }\
	  break;\
	case 2:\
	  ilp = x;\
	  ilr = y;\
	  break;\
	default:\
	  break;\
	}\
\
      fpoint (xi[currentImage]->width, xi[currentImage]->height, ifp, ilp, ifr, ilr, \
	      width, points);\
      XDrawLines (UxDisplay, XtWindow (UxWidget), actionGC, points, 5, CoordModeOrigin);  \
    }\
  call++;\
}\

*action.area2_rect_handler: {\
  int button, x, y;\
  static int ifp, ilp, ifr, ilr, itemp;\
  static unsigned int width, height;\
  static int call = 0;\
\
  if (call == 0)\
    {\
      ifp = 3 * MAGDIM / 8;\
      ifr = 3 * MAGDIM / 8;\
      ilp = 5 * MAGDIM / 8;\
      ilr = 5 * MAGDIM / 8;\
      width = ilp - ifp + 1;\
      height = ilr - ifr + 1;\
    }\
\
  switch (UxEvent->type)\
    {\
    case ButtonPress:\
      button = UxEvent->xbutton.button;\
      switch (button)\
	{\
	case 3:\
	  if (call) \
	    {\
	      XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, \
			      width, height);\
	      ProcessRect2 (ifp, ilp, ifr, ilr);\
	      call = 0;\
	    }\
	  return;\
	default:\
	  break;\
	}\
\
    case MotionNotify:\
      do\
	{\
	  x = UxEvent->xmotion.x;\
	  y = UxEvent->xmotion.y;\
	}\
      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, \
				     UxEvent));\
\
      if (call) XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, \
				width, height);\
      TrackArea2 (UxWidget, UxEvent);\
			   \
      switch (button)\
	{\
	case 1:\
	  ifp = x;\
	  ifr = y;  \
	  break;\
	case 2:\
	  ilp = x;\
	  ilr = y;\
	  break;\
	default:\
	  break;\
	}\
\
      if (ifp > ilp) SWAP (ifp, ilp);\
      if (ifr > ilr) SWAP (ifr, ilr);\
      width = ilp - ifp + 1;\
      height = ilr - ifr + 1;\
      XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, width, height);\
    }\
  call++;\
}\

*action.area2_poly_handler: {\
  int button, x, y;\
  static int xOld, yOld;\
  static int xv[MAXVERTS], yv[MAXVERTS];\
  static int motion = 0, press = 0, nv = 0;\
\
  switch (UxEvent->type)\
    {\
    case ButtonPress:\
      button = UxEvent->xbutton.button;\
      switch (button)\
	{\
	case 2:\
	  if (nv > 0)\
	    {\
	      nv--;\
	      if (nv > 0)\
		{\
		  XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, \
			     xv[nv - 1], yv[nv - 1], xv[nv], yv[nv]);\
		}\
	      else\
		{\
		  XDrawPoint (UxDisplay, XtWindow (UxWidget), actionGC, xv[0], yv[0]);\
		}\
	    }\
	  break;\
 \
	case 3:\
	  if (press)\
	    XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, xv[0], yv[0],\
		       xv[nv - 1], yv[nv - 1]);\
\
	  if (nv > 2)ProcessPoly2 (xv, yv, nv);\
	  nv = 0;\
	  motion = 0;\
	  press = 0;\
	  return;\
\
	default:\
	  break;\
	}\
      press++;\
      break;\
\
    case ButtonRelease:\
      button = UxEvent->xbutton.button;\
      switch (button)\
	{\
	case 1:\
	  if (nv >= MAXVERTS)\
	    {\
	      printf ("Too many vertices!\n");\
	      return;\
	    }\
\
	  x = UxEvent->xbutton.x;\
	  y = UxEvent->xbutton.y;\
	  \
	  if (x >= 0 && x < MAGDIM && y >= 0 && y < MAGDIM)\
	    {\
	      if (nv == 0)\
		XDrawPoint (UxDisplay, XtWindow (UxWidget), actionGC, x, y);\
	      \
	      if (nv > 0 && motion == 0)\
		XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, \
			   xv[nv - 1], yv[nv - 1], x, y);\
	  \
	      xv[nv] = x;\
	      yv[nv] = y;\
	      nv++;  \
	    }\
	  break;\
\
	default:\
	  break;\
	}\
      motion = 0;\
      break;\
\
    case MotionNotify:\
      do\
	{\
	  x = UxEvent->xmotion.x;\
	  y = UxEvent->xmotion.y;\
	}\
      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, \
				     UxEvent));\
\
      TrackArea2 (UxWidget, UxEvent);\
\
      switch (button)\
	{\
	case 1:\
	  if (nv > 0)\
	    {\
	      if (motion) XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, \
				     xv[nv - 1], yv[nv - 1], xOld, yOld);\
	  \
	      xOld = x;\
	      yOld = y;\
	      XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, \
			 xv[nv - 1], yv[nv - 1], x, y);\
	  \
	      motion++;\
	    }\
	  break;\
\
	default:\
	  break;\
	}\
      break;\
\
    default:\
      break;\
    }\
}\

*action.area1_sector_handler: {\
  int button, x, y;\
  double r, phi, dx, dy, xc, yc;\
  static int x1, y1, x2, y2, ixc, iyc;\
  static int call = 0;\
\
  if (currentImage < 0)\
    return;\
\
  if (call == 0)\
    {\
      mainWS_getCentre (mainWS, &UxEnv, &xc, &yc);\
      FileToImageCoords ((float) xc, (float) yc, xi[currentImage], &ixc, &iyc);\
      x1 = ixc + 2 * xi[currentImage]->width / 8;\
      y1 = iyc + xi[currentImage]->height / 8;\
      x2 = ixc + 3 * xi[currentImage]->width / 8;\
      y2 = iyc - xi[currentImage]->height / 8;\
    }\
\
  switch (UxEvent->type)\
    {\
    case ButtonPress:\
      button = UxEvent->xbutton.button;\
      switch (button)\
	{\
	case 1:\
	  if (UxEvent->xbutton.state & ShiftMask)\
	    {\
              if (call)\
                {\
	          DrawSector (UxDisplay, XtWindow (UxWidget), actionGC, ixc, iyc, \
			      x1, y1, x2, y2);	\
                }      \
	      dx = (double) (x2 - ixc);\
	      dy = (double) (iyc - y2);	      \
	      r = sqrt (dx * dx + dy * dy);\
              dx = (double) (x1 - ixc);\
	      dy = (double) (iyc - y1);\
	      phi = atan2 (dy, dx);\
	      x2 = ixc + (int) (r * cos (phi) + sin (phi));\
	      y2 = iyc - (int) (r * sin (phi) - cos (phi));\
	      DrawSector (UxDisplay, XtWindow (UxWidget), actionGC, ixc, iyc, \
			  x1, y1, x2, y2);\
	    }\
	  break;\
	case 2:\
	  if (UxEvent->xbutton.state & ShiftMask)\
	    {\
              if (call)\
                {\
	          DrawSector (UxDisplay, XtWindow (UxWidget), actionGC, ixc, iyc, \
			      x1, y1, x2, y2);	\
                }      \
              dx = (double) (x1 - ixc);\
	      dy = (double) (iyc - y1);\
	      r = sqrt (dx * dx + dy * dy);\
	      dx = (double) (x2 - ixc);\
	      dy = (double) (iyc - y2);	      \
	      phi = atan2 (dy, dx);\
	      x1 = ixc + (int) (r * cos (phi) - sin (phi));\
	      y1 = iyc - (int) (r * sin (phi) + cos (phi));\
	      DrawSector (UxDisplay, XtWindow (UxWidget), actionGC, ixc, iyc, \
			  x1, y1, x2, y2);\
	    }\
	  break;\
	case 3:\
	  if (call) \
	    {\
	      DrawSector (UxDisplay, XtWindow (UxWidget), actionGC, ixc, iyc, \
			  x1, y1, x2, y2);\
	      ProcessSector1 (x1, y1, x2, y2);\
	      call = 0;\
	    }\
	  return;\
	default:\
	  break;\
	}\
\
    case MotionNotify:\
      do\
	{\
	  x = UxEvent->xmotion.x;\
	  y = UxEvent->xmotion.y;\
	}\
      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, \
				     UxEvent));\
\
      if (call)	DrawSector (UxDisplay, XtWindow (UxWidget), actionGC, ixc, iyc, \
			    x1, y1, x2, y2);\
 \
      UpdateArea2 (UxWidget, UxEvent);\
			   \
      if (!(UxEvent->xbutton.state & ShiftMask))\
	{\
	  switch (button)\
	    {\
	    case 1:\
	      x1 = x;\
	      y1 = y;\
	      break;\
	    case 2:\
	      x2 = x;\
	      y2 = y;\
	      break;\
	    default:\
	      break;\
	    }\
	}\
	  \
      DrawSector (UxDisplay, XtWindow (UxWidget), actionGC, ixc, iyc, x1, y1, x2, y2);  \
    }\
\
  call++; \
}\


*translation.table: area1PointTable
*translation.parent: mainWS
*translation.policy: override
*translation.<Expose>: refresh_image1()
*translation.<ButtonPress>: area1_point_handler()
*translation.<MotionNotify>: area1_point_handler()

*translation.table: area2PointTable
*translation.parent: mainWS
*translation.policy: override
*translation.<Expose>: refresh_image2()
*translation.<ButtonPress>: area2_point_handler()
*translation.<MotionNotify>: area2_point_handler()

*translation.table: area1LineTable
*translation.parent: mainWS
*translation.policy: override
*translation.<Expose>: refresh_image1()
*translation.<ButtonPress>: area1_line_handler()
*translation.<Btn1Motion>: area1_line_handler()
*translation.<Btn2Motion>: area1_line_handler()

*translation.table: area1ThickTable
*translation.parent: mainWS
*translation.policy: override
*translation.<Expose>: refresh_image1()
*translation.<ButtonPress>: area1_thick_handler()
*translation.<Btn1Motion>: area1_thick_handler()
*translation.<Btn2Motion>: area1_thick_handler()

*translation.table: area1RectTable
*translation.parent: mainWS
*translation.policy: override
*translation.<Expose>: refresh_image1()
*translation.<ButtonPress>: area1_rect_handler()
*translation.<Btn1Motion>: area1_rect_handler()
*translation.<Btn2Motion>: area1_rect_handler()

*translation.table: area1PolyTable
*translation.parent: mainWS
*translation.policy: override
*translation.<Expose>: refresh_image1()
*translation.<ButtonPress>: area1_poly_handler()
*translation.<ButtonRelease>: area1_poly_handler()
*translation.<Btn1Motion>: area1_poly_handler()

*translation.table: area1ZoomTable
*translation.parent: mainWS
*translation.policy: override
*translation.<Expose>: refresh_image1()
*translation.<ButtonPress>: area1_zoom_handler()
*translation.<Btn1Motion>: area1_zoom_handler()
*translation.<Btn2Motion>: area1_zoom_handler()

*translation.table: area2LineTable
*translation.parent: mainWS
*translation.policy: override
*translation.<Expose>: refresh_image2()
*translation.<ButtonPress>: area2_line_handler()
*translation.<Btn1Motion>: area2_line_handler()
*translation.<Btn2Motion>: area2_line_handler()

*translation.table: area2ThickTable
*translation.parent: mainWS
*translation.policy: override
*translation.<Expose>: refresh_image2()
*translation.<ButtonPress>: area2_thick_handler()
*translation.<Btn1Motion>: area2_thick_handler()
*translation.<Btn2Motion>: area2_thick_handler()

*translation.table: area2RectTable
*translation.parent: mainWS
*translation.policy: override
*translation.<Expose>: refresh_image2()
*translation.<ButtonPress>: area2_rect_handler()
*translation.<Btn1Motion>: area2_rect_handler()
*translation.<Btn2Motion>: area2_rect_handler()

*translation.table: area2PolyTable
*translation.parent: mainWS
*translation.policy: override
*translation.<Expose>: refresh_image2()
*translation.<ButtonPress>: area2_poly_handler()
*translation.<ButtonRelease>: area2_poly_handler()
*translation.<Btn1Motion>: area2_poly_handler()

*translation.table: area1SectorTable
*translation.parent: mainWS
*translation.policy: override
*translation.<Expose>: refresh_image1()
*translation.<ButtonPress>: area1_sector_handler()
*translation.<Btn1Motion>: area1_sector_handler()
*translation.<Btn2Motion>: area1_sector_handler()

*mainWS.class: applicationShell
*mainWS.classinc:
*mainWS.classspec:
*mainWS.classmembers:
*mainWS.classconstructor:
*mainWS.classdestructor:
*mainWS.gbldecl: #include <stdio.h>\
#include <string.h>\
#include <Xm/Protocols.h>\
#include <stdlib.h>\
#include <ctype.h>\
#include <unistd.h>\
#include <sys/types.h>\
#include <sys/stat.h>\
#include <stdarg.h>\
#include <sys/mman.h>\
#include <sys/fcntl.h>\
#include <errno.h>\
#include <X11/Xlib.h>\
#include <X11/Xutil.h>\
#include <X11/Xatom.h>\
#include <X11/Xos.h>\
#include <X11/cursorfont.h>\
#include <math.h>\
\
#ifndef DESIGN_TIME\
typedef void (*vfptr)();\
#endif\
\
#include "xfix.x.pm"\
#include "graphics.h"\
#include "get_types.h"\
\
#define FLOAT32 0\
#define CHAR8 1\
#define UCHAR8 2\
#define INT16 3\
#define UINT16 4\
#define INT32 5\
#define UINT32 6\
#define INT64 7\
#define UINT64 8\
#define FLOAT64 9\
\
static void CreateWindowManagerProtocols (Widget ,void (*)(Widget, XtPointer, XtPointer));\
static void SetIconImage (Widget);\
static void OpenFile (char *);\
static void setupFile (char *, int, int, int, int, int, int, int, int);\
void NewFile (char *, int, int, int, int, int, int,int, int);\
static void ReadFrame ();\
static int endian();\
static void swabytes(void*,int,int);\
static int put_file (char *, char *);\
static int put_backfile(char*,int,char*);\
static int get_file (char *, char *);\
static int get_backfile(char*,char*);\
static void message_parser (char *);\
static void RefreshPalette ();\
static void CommandHandler (char *);\
static int optcmp (char *, char **);\
static void say_yes ();\
static void say_no ();\
static void retry ();\
static char *checkstr (char *, int *);\
static char *AddString (char *, char *);\
static char *findtok (char *, char *);\
static char *firstnon (char *, char *);\
static void quit ();\
static void SaveData ();\
static void CancelSave ();\
static void get_outfile (char *);\
static void DisBackFile();\
static void DisBackFile2 ();\
static void DoCycles();\
static void EndCycles();\
static void DoMore();\
\
void SetBusyPointer (int);\
void command (char *, ...);\
void update_messages (char *);\
void message_handler (XtPointer, int *, XtInputId *);\
void Continue ();\
void ExitCB (Widget, XtPointer, XtPointer);\
\
char *stripws(char*);\
\
extern void show_fileSelect (Widget, char *, char *, void (*) (char *), void (*) ());\
extern void ConfirmDialogAsk (Widget, char *, void (*)(), void (*)(), char *);\
\
#ifndef DESIGN_TIME\
\
#include "fileSelect.h"\
#include "confirmDialog.h"\
#include "parameterDialog.h"\
#include "objectEditDialog.h"\
#include "lineEditDialog.h"\
#include "scanEditDialog.h"\
#include "cellDialog.h"\
#include "continueDialog.h"\
#include "errorDialog.h"\
#include "infoDialog.h"\
#include "limitDialog.h"\
#include "parRowColumn.h"\
#include "peakRowColumn.h"\
#include "setupDialog.h"\
#include "tieDialog.h"\
#include "warningDialog.h"\
#include "workingDialog.h"\
#include "yDialog.h"\
#include "headerDialog.h"\
#include "channelDialog.h"\
#include "refineDialog.h"\
#include "bslFileSelect.h"\
#include "BackWindowParams.h"\
#include "BackCsymParams.h"\
#include "BackSmoothParams.h"\
#include "ErrorMessage.h"\
#include "FileSelection.h"\
#include "CyclesParams.h"\
#include "frameDialog.h"\
\
#else\
\
extern swidget create_fileSelect();\
extern swidget create_confirmDialog();\
extern swidget create_parameterDialog();\
extern swidget create_objectEditDialog();\
extern swidget create_lineEditDialog();\
extern swidget create_scanEditDialog();\
extern swidget create_cellDialog();\
extern swidget create_continueDialog();\
extern swidget create_errorDialog();\
extern swidget create_infoDialog();\
extern swidget create_limitDialog();\
extern swidget create_par_rowColumn();\
extern swidget create_peakRowColumn();\
extern swidget create_setupDialog();\
extern swidget create_tieDialog();\
extern swidget create_warningDialog();\
extern swidget create_workingDialog();\
extern swidget create_yDialog();\
extern swidget create_headerDialog();\
extern swidget create_channelDialog();\
extern swidget create_refineDialog();\
extern swidget create_bslFileSelect();\
extern swidget create_BackWindowParams();\
extern swidget create_BackCsymParams();\
extern swidget create_BackSmoothParams();\
extern swidget create_ErrorMessage();\
extern swidget create_FileSelection();\
extern swidget create_CyclesParams();\
extern swidget create_frameDialog();\
\
#endif\
\
static swidget drawFSD;\
static swidget parameterD;\
static swidget objectD;\
static swidget lineD;\
static swidget scanD;\
static swidget cellD;\
static swidget error;\
static swidget warning;\
static swidget working;\
static swidget info;\
static swidget channels;\
static swidget frameD;\
\
static swidget minmaxy;\
static swidget continueD;\
static swidget refineD;\
static swidget bslSelect;\
static swidget BgWinParams;\
static swidget BgCsymParams;\
static swidget BgSmoothParams;\
\
swidget CycleParam;\
swidget header;\
swidget FileSelect;\
swidget ErrMessage;\
swidget setup;\
swidget confirmD;\
\
Cursor watch, currentCursor;\
\
static float *data;\
static char *mapAddress;\
static int fileDescriptor;\
static int npix, nrast, iffr, ilfr, ifinc, filenum, fframe, fendian, dtype;
*mainWS.ispecdecl: Boolean fitLines, repeat, radialScan, invertedPalette, plotLatticePoints;\
Boolean gotcentreX,gotcentreY;\
double wavelength, distance, centreX, centreY, rotX, rotY, rotZ, tilt, dcal;\
Boolean refineCentre, refineRotX, refineRotY, refineRotZ, refineTilt;\
char *currentDir, *fileName, *yfile, *helpfile, *ccp13ptr, *outfile;\
char *header1, *header2;\
int file_input, file_ready, mode, firstRun, inputPause, psCounter;\
Widget lastToggle;\
char *sBackOutFile,*sBackInFile;\
int binfram;
*mainWS.ispeclist: fitLines, repeat, radialScan, invertedPalette, plotLatticePoints, gotcentreX, gotcentreY, wavelength, distance, centreX, centreY, rotX, rotY, rotZ, tilt, dcal, refineCentre, refineRotX, refineRotY, refineRotZ, refineTilt, currentDir, fileName, yfile, helpfile, ccp13ptr, outfile, header1, header2, file_input, file_ready, mode, firstRun, inputPause, psCounter, lastToggle, sBackOutFile, sBackInFile, binfram
*mainWS.ispeclist.fitLines: "Boolean", "%fitLines%"
*mainWS.ispeclist.repeat: "Boolean", "%repeat%"
*mainWS.ispeclist.radialScan: "Boolean", "%radialScan%"
*mainWS.ispeclist.invertedPalette: "Boolean", "%invertedPalette%"
*mainWS.ispeclist.plotLatticePoints: "Boolean", "%plotLatticePoints%"
*mainWS.ispeclist.gotcentreX: "Boolean", "%gotcentreX%"
*mainWS.ispeclist.gotcentreY: "Boolean", "%gotcentreY%"
*mainWS.ispeclist.wavelength: "double", "%wavelength%"
*mainWS.ispeclist.distance: "double", "%distance%"
*mainWS.ispeclist.centreX: "double", "%centreX%"
*mainWS.ispeclist.centreY: "double", "%centreY%"
*mainWS.ispeclist.rotX: "double", "%rotX%"
*mainWS.ispeclist.rotY: "double", "%rotY%"
*mainWS.ispeclist.rotZ: "double", "%rotZ%"
*mainWS.ispeclist.tilt: "double", "%tilt%"
*mainWS.ispeclist.dcal: "double", "%dcal%"
*mainWS.ispeclist.refineCentre: "Boolean", "%refineCentre%"
*mainWS.ispeclist.refineRotX: "Boolean", "%refineRotX%"
*mainWS.ispeclist.refineRotY: "Boolean", "%refineRotY%"
*mainWS.ispeclist.refineRotZ: "Boolean", "%refineRotZ%"
*mainWS.ispeclist.refineTilt: "Boolean", "%refineTilt%"
*mainWS.ispeclist.currentDir: "char", "*%currentDir%"
*mainWS.ispeclist.fileName: "char", "*%fileName%"
*mainWS.ispeclist.yfile: "char", "*%yfile%"
*mainWS.ispeclist.helpfile: "char", "*%helpfile%"
*mainWS.ispeclist.ccp13ptr: "char", "*%ccp13ptr%"
*mainWS.ispeclist.outfile: "char", "*%outfile%"
*mainWS.ispeclist.header1: "char", "*%header1%"
*mainWS.ispeclist.header2: "char", "*%header2%"
*mainWS.ispeclist.file_input: "int", "%file_input%"
*mainWS.ispeclist.file_ready: "int", "%file_ready%"
*mainWS.ispeclist.mode: "int", "%mode%"
*mainWS.ispeclist.firstRun: "int", "%firstRun%"
*mainWS.ispeclist.inputPause: "int", "%inputPause%"
*mainWS.ispeclist.psCounter: "int", "%psCounter%"
*mainWS.ispeclist.lastToggle: "Widget", "%lastToggle%"
*mainWS.ispeclist.sBackOutFile: "char", "*%sBackOutFile%"
*mainWS.ispeclist.sBackInFile: "char", "*%sBackInFile%"
*mainWS.ispeclist.binfram: "int", "%binfram%"
*mainWS.funcdecl: swidget create_mainWS(swidget parent)\

*mainWS.funcname: create_mainWS
*mainWS.funcdef: "swidget", "<create_mainWS>(%)"
*mainWS.argdecl: swidget parent;
*mainWS.arglist: parent
*mainWS.arglist.parent: "swidget", "%parent%"
*mainWS.icode: int argcMain;\
char **argvMain;
*mainWS.fcode: frameD=create_frameDialog(rtrn);\
drawFSD = create_fileSelect(rtrn);\
confirmD = create_confirmDialog(rtrn);\
parameterD = create_parameterDialog(rtrn);\
objectD = create_objectEditDialog(rtrn);\
lineD = create_lineEditDialog(rtrn);\
scanD = create_scanEditDialog(rtrn);\
cellD = create_cellDialog(rtrn);\
setup = create_setupDialog (rtrn);\
error = create_errorDialog (rtrn);\
warning = create_warningDialog (rtrn);\
working = create_workingDialog (rtrn);\
info = create_infoDialog (rtrn);\
channels = create_channelDialog (rtrn);\
minmaxy = create_yDialog (rtrn);\
continueD = create_continueDialog (rtrn);\
refineD = create_refineDialog(rtrn);\
bslSelect = create_bslFileSelect(rtrn);\
header = create_headerDialog(rtrn);\
BgWinParams = create_BackWindowParams(rtrn);\
BgCsymParams = create_BackCsymParams(rtrn);\
BgSmoothParams = create_BackSmoothParams(rtrn);\
ErrMessage = create_ErrorMessage(rtrn);\
FileSelect=create_FileSelection(rtrn);\
CycleParam=create_CyclesParams(rtrn);\
\
CreateWindowManagerProtocols(UxGetWidget(rtrn), ExitCB);\
SetIconImage (UxGetWidget (mainWS));\
\
watch = XCreateFontCursor (UxDisplay, XC_watch);\
lastToggle = UxGetWidget (togglePoint);\
firstRun = 1;\
inputPause = 0;\
psCounter = 0;\
currentDir = NULL;\
fileName = NULL;\
yfile = NULL;\
outfile = NULL;\
iffr = 1;\
ilfr = 1;\
ifinc = 0;\
filenum = 1;\
gotcentreX=FALSE;\
gotcentreY=FALSE;\
\
if ((ccp13ptr = (char *) getenv ("CCP13HOME")))\
{\
    helpfile = AddString (ccp13ptr, "/doc/xfix.html");\
}\
else\
{\
    helpfile = "http://www.dl.ac.uk/SRS/CCP13/program/xfix.html";\
}\
\
fitLines = False;\
mode = 0;\
repeat = False;\
radialScan = False;\
invertedPalette = False;\
plotLatticePoints = True;\
wavelength = 1.5418;\
distance = 1000.0;\
centreX = centreY = 0.0;\
rotX = rotY = rotZ = 0.0;\
tilt = 0.0;\
\
header1=NULL;\
header2=NULL;\
\
refineCentre = refineRotX = True;\
refineRotY = refineRotZ = refineTilt = False;\
\
UxPopupInterface(rtrn, no_grab);\
InitGraphics ();\
update_messages ("\nPoints: Use the cursor to select points in the main window ");\
update_messages ("or the magnification window\n\n");\
update_messages ("Left mouse button selects point\n");\
update_messages ("Middle mouse button freezes magnification window\n");\
update_messages ("Right mouse button releases magnification window\n\n");\
update_messages ("\nStarting Fix program...\n");\
\
XtVaGetValues (UxTopLevel, XmNargc, &argcMain, XmNargv, &argvMain, NULL);\
switch (argcMain)\
{\
   case 10:\
      dtype= atoi(argvMain[9]);\
      fendian = atoi(argvMain[8]);\
   case 8:\
      filenum = atoi (argvMain[7]);\
      ifinc = atoi (argvMain[6]);\
      ilfr = atoi (argvMain[5]);\
      iffr = atoi (argvMain[4]);\
   case 4:\
      nrast = atoi (argvMain[3]);\
      npix = atoi (argvMain[2]);\
      OpenFile (argvMain[1]);\
      break;\
   default:\
      break;\
}\
\
return(rtrn);
*mainWS.auxdecl: /******************************************************************\
   This function establishes a protocol callback that detects \
   the window manager Close command.  */\
\
static void CreateWindowManagerProtocols(Widget shell, void (*CloseFunction) ())\
{\
  Atom  xa_WM_DELETE_WINDOW;\
\
  xa_WM_DELETE_WINDOW = XInternAtom (UxDisplay, "WM_DELETE_WINDOW", False);\
  XmAddWMProtocolCallback (shell, xa_WM_DELETE_WINDOW, CloseFunction, NULL);\
}\
\
/* This function pops up the Exit dialog box. */\
void ExitCB(Widget w, XtPointer client_data, XtPointer call_data)\
{\
   ConfirmDialogAsk (confirmD, "Do you really want to exit?", quit, NULL, NULL);\
}\
static void ReadFrame ()\
{\
    int psize = getpagesize();                 /*   System page size   */\
    int swab = fendian ^ endian ();            /*   Byte swap flag     */\
    int nbytes, dsize, offset, ntotal, c, i;\
    off_t off;\
    caddr_t tmp, ctmp;\
    float *ftmp;\
    void* dptr;\
\
    switch (dtype)\
    {\
        case FLOAT32:\
           dsize = sizeof (BSL_FLOAT32);\
           break;\
\
        case CHAR8:\
        case UCHAR8:\
           dsize = sizeof (BSL_CHAR8);\
           break;\
\
        case INT16:\
        case UINT16:\
           dsize = sizeof (BSL_INT16);\
           break;\
\
        case INT32:\
        case UINT32:\
           dsize = sizeof (BSL_INT32);\
           break;\
\
#ifndef DESIGN_TIME\
        case INT64:\
        case UINT64:\
           dsize = sizeof (BSL_INT64);\
           break;\
#endif\
        case FLOAT64:\
           dsize = sizeof (BSL_FLOAT64);\
           break;\
\
        default:\
           perror ("Error: Data type not supported");\
           return;\
    }\
\
    nbytes = npix * nrast * dsize;\
    offset = (iffr - 1) * nbytes;\
\
    off = (off_t) (offset - offset % psize);\
    nbytes += offset - off;\
\
    if ((tmp = mmap ((void *) 0, (size_t) nbytes, PROT_READ|PROT_WRITE, MAP_PRIVATE, fileDescriptor, off))\
        == (caddr_t) -1)\
    {\
        perror ("Error: Unable to map specified frame number");\
        return;\
    }\
\
    tmp+=offset-off;\
    ntotal = npix * nrast;\
\
    if ((dptr = (void *) malloc (ntotal * sizeof (float))) == NULL)\
    {\
       perror ("Error: Unable to allocate enough memory for data buffer");\
       return;\
\
    }\
    ftmp = (float *) dptr;\
\
    switch (dtype)\
    {\
       case FLOAT32:\
          if (swab)\
             swabytes ((void*)tmp, ntotal, dsize);\
          for (i=0; i<ntotal; i++, tmp += dsize)\
              *ftmp++ = (float) *((BSL_FLOAT32 *) tmp);\
          break;\
\
       case CHAR8:\
          for (i=0; i<ntotal; i++, tmp += dsize)\
              *ftmp++ = (float) *((BSL_CHAR8 *) tmp);\
          break;\
\
       case UCHAR8:\
          for (i=0; i<ntotal; i++, tmp += dsize)\
              *ftmp++ = (float) *((BSL_UCHAR8 *) tmp);\
          break;\
\
       case INT16:\
          if (swab)\
             swabytes ((void*)tmp, ntotal, dsize);\
          for (i=0; i<ntotal; i++, tmp += dsize)\
              *ftmp++ = (float) *((BSL_INT16 *) tmp);\
          break;\
\
       case UINT16:\
          if (swab)\
             swabytes ((void*)tmp, ntotal, dsize);\
          for (i=0; i<ntotal; i++, tmp += dsize)\
              *ftmp++ = (float) *((BSL_UINT16 *) tmp);\
          break;\
\
       case INT32:\
          if (swab)\
             swabytes ((void*)tmp, ntotal, dsize);\
          for (i=0; i<ntotal; i++, tmp += dsize)\
              *ftmp++ = (float) *((BSL_INT32 *) tmp);\
          break;\
\
       case UINT32:\
          if (swab)\
             swabytes ((void*)tmp, ntotal, dsize);\
          for (i=0; i<ntotal; i++, tmp += dsize)\
              *ftmp++ = (float) *((BSL_UINT32 *) tmp);\
          break;\
#ifndef DESIGN_TIME\
       case INT64:\
          if (swab)\
             swabytes ((void*)tmp, ntotal, dsize);\
          for (i=0; i<ntotal; i++, tmp += dsize)\
              *ftmp++ = (float) *((BSL_INT64 *) tmp);\
          break;\
\
       case UINT64:\
          if (swab)\
             swabytes ((void*)tmp, ntotal, dsize);\
          for (i=0; i<ntotal; i++, tmp += dsize)\
              *ftmp++ = (float) *((BSL_UINT64 *) tmp);\
          break;\
#endif\
       case FLOAT64:\
\
          if (swab)\
             swabytes ((void*)tmp, ntotal, dsize);\
          for (i=0; i<ntotal; i++, tmp += dsize)\
              *ftmp++ = (float) *((BSL_FLOAT64 *) tmp);\
          break;\
    }\
\
    data=(float*)dptr;\
}\
  \
int endian ()\
{\
    short int one = 1;\
    return ((int) *(char *) &one);\
}\
\
static void swabytes (void *vp, int n, int dsize)\
{\
    unsigned char *cp = (unsigned char *)vp;\
    int t,i,j;\
\
    while (n-- > 0)\
    {\
       j=0;\
       for(i=dsize-1;i>j;i--)\
       {\
         t = cp[i]; cp[i] = cp[j]; cp[j] = t;\
         j++;\
       }\
       cp+=dsize;\
    }\
}\
\
static void OpenFile (char *fname)\
{\
    if (currentDir)\
    {\
        free (currentDir);\
        currentDir = NULL;\
    }    \
    if (fileName)\
    {\
        free (fileName);\
        fileName = NULL;\
    }\
    if (yfile)\
    {\
        free (yfile);\
        yfile = NULL;\
    }\
    psCounter = 0;\
\
    currentDir = (char *) strdup (fname);\
    *(currentDir + strlen (fname) - 10) = '\0';\
/*    fileName = (char *) strdup (fname + strlen (fname) - 10);\
*/\
    fileName=(char*)strdup(fname);\
    yfile = (char *) strdup (fileName);\
\
    switch (filenum)\
    {\
    case 1:\
      *(yfile + strlen(currentDir)+5) = '1';\
      break;\
    case 2:\
      *(yfile + strlen(currentDir)+5) = '2';\
      break;\
    case 3:\
      *(yfile + strlen(currentDir)+5) = '3';\
      break;\
    default:\
      break;\
    }\
\
    if ((fileDescriptor = open (yfile, O_RDONLY)) < 0)\
    {\
        fprintf (stderr, "Error opening binary file %s\n", yfile);\
        return;\
    }\
\
    SetBusyPointer (1);\
    ReadFrame ();\
    sprintf (textBuf, "%10s", (fileName + strlen (fileName) - 10));\
    XmTextFieldSetString (UxGetWidget (fileText), textBuf);\
    sprintf (textBuf, "%4d", iffr);\
    XmTextFieldSetString (UxGetWidget (frameText), textBuf);\
    \
    CloseAllImages ();\
    DestroyAllObjects ();\
    DestroyAllLines ();\
    DestroyAllScans ();\
    DestroyDrawnPoints ();\
    totalImages = 1;\
    currentImage = 0;\
    xi[currentImage] = CreateFixImage (0, 0, npix, nrast);\
    SetBusyPointer (0);\
\
    fframe=iffr;\
\
    if (iffr <= ilfr - ifinc)\
        XtSetSensitive (UxGetWidget (frameButton), True);\
    else	\
        XtSetSensitive (UxGetWidget (frameButton), False);\
\
    if(ilfr-iffr>0)\
        XtSetSensitive (UxGetWidget (gotoButton), True);\
    else	\
        XtSetSensitive (UxGetWidget (gotoButton), False);\
\
    if (xi[currentImage])\
    {\
       LoadImage (xi[currentImage]);\
       XmTextFieldSetString (UxGetWidget (imageText), "0");\
    }\
    else\
    {\
       errorDialog_popup (error, &UxEnv, "Unable to create image");\
       totalImages = 0;\
       currentImage = -1;\
    }\
\
    XtSetSensitive (UxGetWidget (textHigh), True);\
    XtSetSensitive (UxGetWidget (textLow), True);\
\
    if(!gotcentreX&&!gotcentreY)\
    {\
      mainWS_setCentreX(mainWS,&UxEnv,(double)(npix/2));\
      mainWS_setCentreY(mainWS,&UxEnv,(double)(nrast/2));\
      parameterDialog_setCentre(parameterD,&UxEnv,(double)(npix/2),(double)(nrast/2));\
      command ("Centre %f %f\n",(float)(npix/2),(float)(nrast/2));\
    }\
    \
    command ("File\n");\
}\
\
static void setupFile (char *fname, int np, int nr, int ff, int lf, int inc, int fnum, int fend, int dtyp)\
{\
   npix = np;\
   nrast = nr;\
   iffr = ff;\
   ilfr = lf;\
   ifinc = inc;\
   filenum = fnum;\
   fendian=fend;\
   dtype=dtyp;\
   OpenFile (fname);\
}\
\
void NewFile (char *fname, int np, int nr, int ff, int lf, int inc, int fnum, int fend, int dtyp)\
{\
   char *argv[11], buf[10];\
   int pid;\
\
   SetBusyPointer (1);\
   switch (pid = fork ())\
   {\
      case 0:\
         argv[0] = "xfix";\
         argv[1] = fname;\
         sprintf (buf, "%d", np);\
         argv[2] = (char *) strdup (buf);\
         sprintf (buf, "%d", nr);\
         argv[3] = (char *) strdup (buf);\
         sprintf (buf, "%d", ff);\
         argv[4] = (char *) strdup (buf);\
         sprintf (buf, "%d", lf);\
         argv[5] = (char *) strdup (buf);\
         sprintf (buf, "%d", inc);\
         argv[6] = (char *) strdup (buf);\
         sprintf (buf, "%d", fnum);\
         argv[7] = (char *) strdup (buf);\
         sprintf (buf, "%d", fend);\
         argv[8] = (char *) strdup (buf);\
         sprintf (buf, "%d", dtyp);\
         argv[9] = (char *) strdup (buf);\
         argv[10] = (char *) NULL;\
\
         execvp ("xfix", argv);\
         perror ("fork");\
         fprintf (stderr,"Could not exec new xfix\n");\
         _exit (0);\
\
      case -1:\
         fprintf (stderr,"Could not fork xfix\n");\
         exit (0);\
\
      default:\
         break;\
   }\
   SetBusyPointer (0);\
}\
static void SetIconImage (Widget wgt)\
{\
    static Pixmap icon = None;\
    static unsigned int iconW = 1, iconH = 1;\
    Window iconWindow;\
    XWMHints wmHints;\
    Screen *screen = XtScreen(wgt);\
    Display *dpy = XtDisplay(wgt);\
/*\
 *  Build the icon\
 */\
    iconWindow = XCreateSimpleWindow(dpy, RootWindowOfScreen(screen),\
                                     0, 0, /* x, y */\
                                     iconW, iconH, 0,\
                                     BlackPixelOfScreen(screen),\
                                     BlackPixelOfScreen(screen));\
\
    if (icon == None)\
    {\
        Window          root;\
        int             x, y;\
        unsigned int    bw, depth;\
 \
        XpmCreatePixmapFromData(dpy, iconWindow,\
                                xfix_x_pm, &icon, NULL, NULL);\
 \
	if (icon != None)\
	{\
            XGetGeometry(dpy, icon, &root, &x, &y, &iconW, &iconH, &bw, &depth);\
            XResizeWindow(dpy, iconWindow, iconW, iconH);\
    	    XSetWindowBackgroundPixmap(dpy, iconWindow, icon);\
            XtVaSetValues (wgt, XtNiconWindow, iconWindow, NULL);    \
	}\
    }\
}\
\
/*************************************************************/\
/* Strip off leading and trailing whitespace in a string     */\
/*************************************************************/\
\
char* stripws(char* pptr)\
{\
  int iflag;\
\
/* Strip off leading white space */\
\
  iflag=0;\
  do\
  {\
    if(isspace((int)pptr[0]))\
      pptr++;\
    else\
      iflag=1;\
  }while(!iflag);\
\
/* Strip off trailing spaces */\
\
  iflag=0;\
  do\
  {\
    if(isspace((int)pptr[strlen(pptr)-1]))\
      pptr[strlen(pptr)-1]='\0';\
    else\
      iflag=1;\
  }while(!iflag);\
\
  return pptr;\
}\
\
\
void Continue ()\
{\
    message_parser (NULL);\
}\
\
#include "mainWS_aux.c"\
#include "graphics.c"
*mainWS_setWavelength.class: method
*mainWS_setWavelength.name: setWavelength
*mainWS_setWavelength.parent: mainWS
*mainWS_setWavelength.methodType: void
*mainWS_setWavelength.methodArgs: double value;\

*mainWS_setWavelength.methodBody: wavelength = value;
*mainWS_setWavelength.methodSpec: virtual
*mainWS_setWavelength.accessSpec: public
*mainWS_setWavelength.arguments: value
*mainWS_setWavelength.value.def: "double", "%value%"

*mainWS_setDistance.class: method
*mainWS_setDistance.name: setDistance
*mainWS_setDistance.parent: mainWS
*mainWS_setDistance.methodType: void
*mainWS_setDistance.methodArgs: double value;\

*mainWS_setDistance.methodBody: distance = value;
*mainWS_setDistance.methodSpec: virtual
*mainWS_setDistance.accessSpec: public
*mainWS_setDistance.arguments: value
*mainWS_setDistance.value.def: "double", "%value%"

*mainWS_setCentreX.class: method
*mainWS_setCentreX.name: setCentreX
*mainWS_setCentreX.parent: mainWS
*mainWS_setCentreX.methodType: void
*mainWS_setCentreX.methodArgs: double value;\

*mainWS_setCentreX.methodBody: centreX = value;\
gotcentreX=TRUE;
*mainWS_setCentreX.methodSpec: virtual
*mainWS_setCentreX.accessSpec: public
*mainWS_setCentreX.arguments: value
*mainWS_setCentreX.value.def: "double", "%value%"

*mainWS_setCentreY.class: method
*mainWS_setCentreY.name: setCentreY
*mainWS_setCentreY.parent: mainWS
*mainWS_setCentreY.methodType: void
*mainWS_setCentreY.methodArgs: double value;\

*mainWS_setCentreY.methodBody: centreY = value;\
gotcentreY=TRUE;
*mainWS_setCentreY.methodSpec: virtual
*mainWS_setCentreY.accessSpec: public
*mainWS_setCentreY.arguments: value
*mainWS_setCentreY.value.def: "double", "%value%"

*mainWS_setRotX.class: method
*mainWS_setRotX.name: setRotX
*mainWS_setRotX.parent: mainWS
*mainWS_setRotX.methodType: void
*mainWS_setRotX.methodArgs: double value;\

*mainWS_setRotX.methodBody: rotX = value;
*mainWS_setRotX.methodSpec: virtual
*mainWS_setRotX.accessSpec: public
*mainWS_setRotX.arguments: value
*mainWS_setRotX.value.def: "double", "%value%"

*mainWS_setRotY.class: method
*mainWS_setRotY.name: setRotY
*mainWS_setRotY.parent: mainWS
*mainWS_setRotY.methodType: void
*mainWS_setRotY.methodArgs: double value;\

*mainWS_setRotY.methodBody: rotY = value;
*mainWS_setRotY.methodSpec: virtual
*mainWS_setRotY.accessSpec: public
*mainWS_setRotY.arguments: value
*mainWS_setRotY.value.def: "double", "%value%"

*mainWS_setRotZ.class: method
*mainWS_setRotZ.name: setRotZ
*mainWS_setRotZ.parent: mainWS
*mainWS_setRotZ.methodType: void
*mainWS_setRotZ.methodArgs: double value;\

*mainWS_setRotZ.methodBody: rotZ = value;
*mainWS_setRotZ.methodSpec: virtual
*mainWS_setRotZ.accessSpec: public
*mainWS_setRotZ.arguments: value
*mainWS_setRotZ.value.def: "double", "%value%"

*mainWS_setTilt.class: method
*mainWS_setTilt.name: setTilt
*mainWS_setTilt.parent: mainWS
*mainWS_setTilt.methodType: void
*mainWS_setTilt.methodArgs: double value;\

*mainWS_setTilt.methodBody: tilt = value;
*mainWS_setTilt.methodSpec: virtual
*mainWS_setTilt.accessSpec: public
*mainWS_setTilt.arguments: value
*mainWS_setTilt.value.def: "double", "%value%"

*mainWS_setCal.class: method
*mainWS_setCal.name: setCal
*mainWS_setCal.parent: mainWS
*mainWS_setCal.methodType: void
*mainWS_setCal.methodArgs: double value;\

*mainWS_setCal.methodBody: dcal = value;
*mainWS_setCal.methodSpec: virtual
*mainWS_setCal.accessSpec: public
*mainWS_setCal.arguments: value
*mainWS_setCal.value.def: "double", "%value%"

*mainWS_imageLimits.class: method
*mainWS_imageLimits.name: imageLimits
*mainWS_imageLimits.parent: mainWS
*mainWS_imageLimits.methodType: int
*mainWS_imageLimits.methodArgs: int *x;\
int *y;\
int *width;\
int *height;\

*mainWS_imageLimits.methodBody: if (currentImage >= 0)\
{\
   *x = xi[currentImage]->x;\
   *y = xi[currentImage]->y;\
   *width = xi[currentImage]->ipix;\
   *height = xi[currentImage]->irast;\
   return (0);\
}\
else\
{\
   return (1);\
}\

*mainWS_imageLimits.methodSpec: virtual
*mainWS_imageLimits.accessSpec: public
*mainWS_imageLimits.arguments: x, y, width, height
*mainWS_imageLimits.x.def: "int", "*%x%"
*mainWS_imageLimits.y.def: "int", "*%y%"
*mainWS_imageLimits.width.def: "int", "*%width%"
*mainWS_imageLimits.height.def: "int", "*%height%"

*mainWS_setRefineCentre.class: method
*mainWS_setRefineCentre.name: setRefineCentre
*mainWS_setRefineCentre.parent: mainWS
*mainWS_setRefineCentre.methodType: void
*mainWS_setRefineCentre.methodArgs: Boolean value;\

*mainWS_setRefineCentre.methodBody: refineCentre = value;
*mainWS_setRefineCentre.methodSpec: virtual
*mainWS_setRefineCentre.accessSpec: public
*mainWS_setRefineCentre.arguments: value
*mainWS_setRefineCentre.value.def: "Boolean", "%value%"

*mainWS_setRefineRotX.class: method
*mainWS_setRefineRotX.name: setRefineRotX
*mainWS_setRefineRotX.parent: mainWS
*mainWS_setRefineRotX.methodType: void
*mainWS_setRefineRotX.methodArgs: Boolean value;\

*mainWS_setRefineRotX.methodBody: refineRotX = value;
*mainWS_setRefineRotX.methodSpec: virtual
*mainWS_setRefineRotX.accessSpec: public
*mainWS_setRefineRotX.arguments: value
*mainWS_setRefineRotX.value.def: "Boolean", "%value%"

*mainWS_setRefineRotY.class: method
*mainWS_setRefineRotY.name: setRefineRotY
*mainWS_setRefineRotY.parent: mainWS
*mainWS_setRefineRotY.methodType: void
*mainWS_setRefineRotY.methodArgs: Boolean value;\

*mainWS_setRefineRotY.methodBody: refineRotY = value;
*mainWS_setRefineRotY.methodSpec: virtual
*mainWS_setRefineRotY.accessSpec: public
*mainWS_setRefineRotY.arguments: value
*mainWS_setRefineRotY.value.def: "Boolean", "%value%"

*mainWS_setRefineRotZ.class: method
*mainWS_setRefineRotZ.name: setRefineRotZ
*mainWS_setRefineRotZ.parent: mainWS
*mainWS_setRefineRotZ.methodType: void
*mainWS_setRefineRotZ.methodArgs: Boolean value;\

*mainWS_setRefineRotZ.methodBody: refineRotZ = value;
*mainWS_setRefineRotZ.methodSpec: virtual
*mainWS_setRefineRotZ.accessSpec: public
*mainWS_setRefineRotZ.arguments: value
*mainWS_setRefineRotZ.value.def: "Boolean", "%value%"

*mainWS_setRefineTilt.class: method
*mainWS_setRefineTilt.name: setRefineTilt
*mainWS_setRefineTilt.parent: mainWS
*mainWS_setRefineTilt.methodType: void
*mainWS_setRefineTilt.methodArgs: Boolean value;\

*mainWS_setRefineTilt.methodBody: refineTilt = value;
*mainWS_setRefineTilt.methodSpec: virtual
*mainWS_setRefineTilt.accessSpec: public
*mainWS_setRefineTilt.arguments: value
*mainWS_setRefineTilt.value.def: "Boolean", "%value%"

*mainWS_getCentre.class: method
*mainWS_getCentre.name: getCentre
*mainWS_getCentre.parent: mainWS
*mainWS_getCentre.methodType: void
*mainWS_getCentre.methodArgs: double *xc;\
double *yc;\

*mainWS_getCentre.methodBody: *xc = centreX;\
*yc = centreY;\

*mainWS_getCentre.methodSpec: virtual
*mainWS_getCentre.accessSpec: public
*mainWS_getCentre.arguments: xc, yc
*mainWS_getCentre.xc.def: "double", "*%xc%"
*mainWS_getCentre.yc.def: "double", "*%yc%"

*mainWS_continue.class: method
*mainWS_continue.name: continue
*mainWS_continue.parent: mainWS
*mainWS_continue.methodType: void
*mainWS_continue.methodArgs: 
*mainWS_continue.methodBody: message_parser (NULL);
*mainWS_continue.methodSpec: virtual
*mainWS_continue.accessSpec: public

*mainWS_SetHeaders.class: method
*mainWS_SetHeaders.name: SetHeaders
*mainWS_SetHeaders.parent: mainWS
*mainWS_SetHeaders.methodType: void
*mainWS_SetHeaders.methodArgs: char *h1;\
char *h2;\

*mainWS_SetHeaders.methodBody: header1 = h1;\
header2 = h2;\

*mainWS_SetHeaders.methodSpec: virtual
*mainWS_SetHeaders.accessSpec: public
*mainWS_SetHeaders.arguments: h1, h2
*mainWS_SetHeaders.h1.def: "char", "*%h1%"
*mainWS_SetHeaders.h2.def: "char", "*%h2%"

*mainWS_removeLattice.class: method
*mainWS_removeLattice.name: removeLattice
*mainWS_removeLattice.parent: mainWS
*mainWS_removeLattice.methodType: void
*mainWS_removeLattice.methodArgs: 
*mainWS_removeLattice.methodBody: RepaintOverDrawnPoints ();\
DestroyDrawnPoints ();\
\
RepaintOverDrawnRings ();\
DestroyDrawnRings ();\

*mainWS_removeLattice.methodSpec: virtual
*mainWS_removeLattice.accessSpec: public

*mainWS_help.class: method
*mainWS_help.name: help
*mainWS_help.parent: mainWS
*mainWS_help.methodType: void
*mainWS_help.methodArgs: char *string;\

*mainWS_help.methodBody: char *helpString, *tmp;\
\
helpString = (char *) strdup ("netscape -raise -remote ");\
\
if (ccp13ptr)\
{\
    tmp = AddString (helpString, " 'openFile (");\
}\
else\
{\
    tmp = AddString (helpString, " 'openURL (");\
}\
free (helpString);\
helpString = AddString (tmp, helpfile);\
free (tmp);\
tmp = AddString (helpString, string);\
free (helpString);\
helpString = AddString (tmp, ")'");\
free (tmp);\
\
if ((system (helpString) == -1))\
{\
    fprintf (stderr, "Error opening Netscape browser\n");\
} \
\
free (helpString);\

*mainWS_help.methodSpec: virtual
*mainWS_help.accessSpec: public
*mainWS_help.arguments: string
*mainWS_help.string.def: "char", "*%string%"

*mainWS_CheckOutFile.class: method
*mainWS_CheckOutFile.name: CheckOutFile
*mainWS_CheckOutFile.parent: mainWS
*mainWS_CheckOutFile.methodType: int
*mainWS_CheckOutFile.methodArgs: char *sptr;\
char *error;\
int bsl;\

*mainWS_CheckOutFile.methodBody: /**************************************************************************/\
/***** Check that output file has been specified **************************/\
/***** and is writable and a valid BSL filename  **************************/\
/**************************************************************************/\
\
char *mptr,*pptr,*jptr;\
struct stat buf;\
\
if(strlen(sptr)==0)\
{\
  strcpy(error,"Output file not specified");\
  return 0;\
}\
else if(bsl&&!mainWS_Legalbslname(mainWS,&UxEnv,sptr))\
{\
  strcpy(error,"Output file: Invalid header filename");\
  return 0;\
}\
else if(access(sptr,F_OK)==-1)\
{\
  mptr=(char*)malloc( (strlen(sptr)+1)*sizeof(char) );\
  strcpy(mptr,sptr);\
  pptr=strrchr(mptr,'/');\
\
  if(pptr!=NULL)\
    mptr[strlen(sptr)-strlen(pptr)+1]='\0';\
  else\
    strcpy(mptr,"./");\
\
  if(access(mptr,W_OK)==-1)\
  {\
    strcpy(error,"Output file: ");\
    strcat(error,strerror(errno));\
    free(mptr);\
    return 0;\
  }\
  else\
  {\
    free(mptr);\
  }\
}\
else if(access(sptr,W_OK)==-1)\
{\
  strcpy(error,"Output file: ");\
  strcat(error,strerror(errno));\
  return 0;\
}\
else\
{\
  jptr=(char*)malloc(80*sizeof(char));\
  strcpy(jptr,"");\
  if(strchr(sptr,(int)'/')==NULL)\
    strcat(jptr,"./");\
  strcat(jptr,sptr);\
  stat(jptr,&buf);\
  if(S_ISDIR(buf.st_mode))\
  {\
    strcpy(error,"Selection is a directory");\
    free(jptr);\
    return 0;\
  }\
  else\
  {\
    free(jptr);\
  }\
}\
return 1;\
\

*mainWS_CheckOutFile.methodSpec: virtual
*mainWS_CheckOutFile.accessSpec: public
*mainWS_CheckOutFile.arguments: sptr, error, bsl
*mainWS_CheckOutFile.sptr.def: "char", "*%sptr%"
*mainWS_CheckOutFile.error.def: "char", "*%error%"
*mainWS_CheckOutFile.bsl.def: "int", "%bsl%"

*mainWS_Legalbslname.class: method
*mainWS_Legalbslname.name: Legalbslname
*mainWS_Legalbslname.parent: mainWS
*mainWS_Legalbslname.methodType: int
*mainWS_Legalbslname.methodArgs: char *fptr;\

*mainWS_Legalbslname.methodBody: char *sptr;\
int i;\
\
/* Strip off path */\
sptr=strrchr(fptr,'/');\
if(sptr!=NULL)\
{\
  fptr=++sptr;\
}\
\
if(strlen(fptr)!=10)\
{\
  return(0);\
}\
\
if(isalpha((int)fptr[0]) && isdigit((int)fptr[1]) && isdigit((int)fptr[2]))\
{\
  if (strstr(fptr,"000.")!=fptr+3)\
  {\
    return(0);\
  }\
}\
else\
{\
  return(0);\
}\
\
if(isalnum((int)fptr[7]) && isalnum((int)fptr[8]) && isalnum((int)fptr[9]))\
{\
  return(1);\
}\
else\
{\
  return(0);\
}\

*mainWS_Legalbslname.methodSpec: virtual
*mainWS_Legalbslname.accessSpec: public
*mainWS_Legalbslname.arguments: fptr
*mainWS_Legalbslname.fptr.def: "char", "*%fptr%"

*mainWS_FileSelectionOK.class: method
*mainWS_FileSelectionOK.name: FileSelectionOK
*mainWS_FileSelectionOK.parent: mainWS
*mainWS_FileSelectionOK.methodType: int
*mainWS_FileSelectionOK.methodArgs: char *sptr;\
swidget *sw;\

*mainWS_FileSelectionOK.methodBody: #ifndef DESIGN_TIME\
  XmTextSetString(UxGetWidget(*sw),sptr);\
  XmTextSetInsertionPosition(UxGetWidget(*sw),strlen(sptr)) ;\
  return 1;\
#endif
*mainWS_FileSelectionOK.methodSpec: virtual
*mainWS_FileSelectionOK.accessSpec: public
*mainWS_FileSelectionOK.arguments: sptr, sw
*mainWS_FileSelectionOK.sptr.def: "char", "*%sptr%"
*mainWS_FileSelectionOK.sw.def: "swidget", "*%sw%"

*mainWS_CheckInFile.class: method
*mainWS_CheckInFile.name: CheckInFile
*mainWS_CheckInFile.parent: mainWS
*mainWS_CheckInFile.methodType: int
*mainWS_CheckInFile.methodArgs: char *sptr;\
char *error;\
Boolean mult;\
Boolean bsl;\

*mainWS_CheckInFile.methodBody: #ifndef DESIGN_TIME\
\
/************************************************************************\
 Check that input files have been specified\
 and are readable\
*************************************************************************/\
\
int i;\
char *jptr;\
struct stat buf;\
\
if(strlen(sptr)==0)\
{\
  strcpy(error,"Input file not specified");\
  return 0;\
}\
else if(bsl&&!mainWS_Legalbslname(mainWS,&UxEnv,sptr))\
{\
  strcpy(error,"Input file : Invalid header filename");\
  return 0;\
}\
else if(access(sptr,R_OK)==-1)\
{\
  strcpy(error,"Input file: ");\
  strcat(error,strerror(errno));\
  return 0;\
}\
else\
{\
  jptr=(char*) malloc(sizeof(char)*80);\
  strcpy(jptr,"");\
  if(strchr(sptr,(int)'/')==NULL)\
    strcat(jptr,"./");\
  strcat(jptr,sptr);\
  stat(jptr,&buf);\
  if(S_ISDIR(buf.st_mode))\
  {\
    strcpy(error,"Selection is a directory");\
    free(jptr);\
    return 0;\
  }\
  else\
  {\
     free(jptr);\
  }\
}\
\
return 1;\
\
#endif
*mainWS_CheckInFile.methodSpec: virtual
*mainWS_CheckInFile.accessSpec: public
*mainWS_CheckInFile.arguments: sptr, error, mult, bsl
*mainWS_CheckInFile.sptr.def: "char", "*%sptr%"
*mainWS_CheckInFile.error.def: "char", "*%error%"
*mainWS_CheckInFile.mult.def: "Boolean", "%mult%"
*mainWS_CheckInFile.bsl.def: "Boolean", "%bsl%"

*mainWS_setBackInFile.class: method
*mainWS_setBackInFile.name: setBackInFile
*mainWS_setBackInFile.parent: mainWS
*mainWS_setBackInFile.methodType: void
*mainWS_setBackInFile.methodArgs: char *fnam;\
int frame;\

*mainWS_setBackInFile.methodBody: sBackInFile=fnam;\
binfram=frame;
*mainWS_setBackInFile.methodSpec: virtual
*mainWS_setBackInFile.accessSpec: public
*mainWS_setBackInFile.arguments: fnam, frame
*mainWS_setBackInFile.fnam.def: "char", "*%fnam%"
*mainWS_setBackInFile.frame.def: "int", "%frame%"

*mainWS_setBackOutFile.class: method
*mainWS_setBackOutFile.name: setBackOutFile
*mainWS_setBackOutFile.parent: mainWS
*mainWS_setBackOutFile.methodType: void
*mainWS_setBackOutFile.methodArgs: char *sFile;\

*mainWS_setBackOutFile.methodBody: sBackOutFile=sFile;
*mainWS_setBackOutFile.methodSpec: virtual
*mainWS_setBackOutFile.accessSpec: public
*mainWS_setBackOutFile.arguments: sFile
*mainWS_setBackOutFile.sFile.def: "char", "*%sFile%"

*mainWS_gotoFrame.class: method
*mainWS_gotoFrame.name: gotoFrame
*mainWS_gotoFrame.parent: mainWS
*mainWS_gotoFrame.methodType: int
*mainWS_gotoFrame.methodArgs: int frameno;\

*mainWS_gotoFrame.methodBody: char *sframe;\
\
\
if (frameno<=ilfr&&frameno>=fframe)\
{\
  sframe=(char*)malloc(sizeof(char)*5);\
  SetBusyPointer(1);\
  iffr=frameno;\
  ReadFrame();\
\
  CloseAllImages ();\
  if (!repeat)\
  {\
     DestroyAllObjects ();\
     DestroyAllLines ();\
  }\
\
  totalImages = 1;\
  currentImage = 0;\
  xi[currentImage] = CreateFixImage (0, 0, npix, nrast);\
  SetBusyPointer (0);\
\
  if (xi[currentImage])\
  {\
     LoadImage (xi[currentImage]);\
     XmTextFieldSetString (UxGetWidget (imageText), "0");\
  }\
  else\
  {\
     errorDialog_popup (error, &UxEnv, "Unable to create image");\
     totalImages = 0;\
     currentImage = -1;\
  }\
\
  sprintf(sframe,"%4d",frameno);\
  XmTextFieldSetString(frameText,sframe);\
  XtSetSensitive (UxGetWidget (textHigh), True);\
  XtSetSensitive (UxGetWidget (textLow), True);\
  command ("Gofr %d\n",iffr);\
  free(sframe);\
}
*mainWS_gotoFrame.methodSpec: virtual
*mainWS_gotoFrame.accessSpec: public
*mainWS_gotoFrame.arguments: frameno
*mainWS_gotoFrame.frameno.def: "int", "%frameno%"

*mainWS.name.source: public
*mainWS.static: false
*mainWS.name: mainWS
*mainWS.parent: NO_PARENT
*mainWS.x: 338
*mainWS.y: 10
*mainWS.width: 690
*mainWS.height: 800
*mainWS.title: "xfix v4.0"
*mainWS.deleteResponse: "do_nothing"
*mainWS.keyboardFocusPolicy.source: public
*mainWS.keyboardFocusPolicy: "explicit"
*mainWS.iconName: "xfix"

*mainWindow.class: mainWindow
*mainWindow.static: true
*mainWindow.name: mainWindow
*mainWindow.parent: mainWS
*mainWindow.x: 200
*mainWindow.y: 180
*mainWindow.width: 700
*mainWindow.height: 800

*pullDownMenu.class: rowColumn
*pullDownMenu.static: true
*pullDownMenu.name: pullDownMenu
*pullDownMenu.parent: mainWindow
*pullDownMenu.borderWidth: 0
*pullDownMenu.menuHelpWidget: "helpCascade"
*pullDownMenu.rowColumnType: "menu_bar"
*pullDownMenu.menuAccelerator: "<KeyUp>F10"

*filePane.class: rowColumn
*filePane.static: true
*filePane.name: filePane
*filePane.parent: pullDownMenu
*filePane.rowColumnType: "menu_pulldown"

*newButton.class: pushButtonGadget
*newButton.static: true
*newButton.name: newButton
*newButton.parent: filePane
*newButton.labelString: "New ..."
*newButton.activateCallback: {\
   obFileSelect_OKfunction (bslSelect, &UxEnv, NewFile);\
   UxPopupInterface (bslSelect, nonexclusive_grab);\
} \
\

*newButton.accelerator: "Ctrl<Key>N"
*newButton.acceleratorText: "Ctrl+N"

*openButton.class: pushButtonGadget
*openButton.static: true
*openButton.name: openButton
*openButton.parent: filePane
*openButton.labelString: "Open ..."
*openButton.activateCallback: {   \
   obFileSelect_OKfunction (bslSelect, &UxEnv, setupFile);\
   UxPopupInterface (bslSelect, nonexclusive_grab);\
}
*openButton.accelerator: "Ctrl<Key>O"
*openButton.acceleratorText: "Ctrl+O"

*frameButton.class: pushButton
*frameButton.static: true
*frameButton.name: frameButton
*frameButton.parent: filePane
*frameButton.labelString: "Next Frame"
*frameButton.accelerator: "Ctrl<Key>X"
*frameButton.acceleratorText: "Ctrl+X"
*frameButton.activateCallback: { \
  if (iffr <= ilfr - ifinc)\
  {\
    SetBusyPointer (1);\
    iffr += ifinc;\
\
    ReadFrame ();\
\
    sprintf (textBuf, "%4d", iffr);\
    XmTextFieldSetString (UxGetWidget (frameText), textBuf);\
    \
    CloseAllImages ();\
    if (!repeat)\
    {\
       DestroyAllObjects ();\
       DestroyAllLines ();\
    }\
\
    totalImages = 1;\
    currentImage = 0;\
    xi[currentImage] = CreateFixImage (0, 0, npix, nrast);\
    SetBusyPointer (0);\
\
    if (xi[currentImage])\
    {\
       LoadImage (xi[currentImage]);\
       XmTextFieldSetString (UxGetWidget (imageText), "0");\
    }\
    else\
    {\
       errorDialog_popup (error, &UxEnv, "Unable to create image");\
       totalImages = 0;\
       currentImage = -1;\
    }\
\
    XtSetSensitive (UxGetWidget (textHigh), True);\
    XtSetSensitive (UxGetWidget (textLow), True);\
    command ("Frame\n");\
  }\
\
}
*frameButton.sensitive: "false"

*gotoButton.class: pushButton
*gotoButton.static: true
*gotoButton.name: gotoButton
*gotoButton.parent: filePane
*gotoButton.labelString: "Goto Frame ..."
*gotoButton.activateCallback: {\
UxPopupInterface(frameD,no_grab);\
}
*gotoButton.sensitive: "false"

*filePane_b7.class: separatorGadget
*filePane_b7.static: true
*filePane_b7.name: filePane_b7
*filePane_b7.parent: filePane

*saveAsButton.class: pushButtonGadget
*saveAsButton.static: true
*saveAsButton.name: saveAsButton
*saveAsButton.parent: filePane
*saveAsButton.labelString: "Save As Postscript ..."
*saveAsButton.activateCallback: {\
   char count[8];\
   char *tmp, *pathName;\
   char *defName = (char *) strdup (fileName);\
\
   *(defName + 6) = '_';\
   *(defName + 7) = '\0';\
\
   psCounter++;\
   sprintf (count, "%d", psCounter);\
\
   tmp = AddString (defName, count);\
   free (defName);\
\
   defName = AddString (tmp, ".ps");\
   free (tmp);\
\
   pathName = AddString (currentDir, defName);\
   free (defName);\
\
   show_fileSelect (drawFSD, "*.ps", pathName, psout, CancelSave);\
\
   free (pathName);\
}
*saveAsButton.accelerator: "Ctrl<Key>S"
*saveAsButton.acceleratorText: "Ctrl+S"

*filePane_b9.class: separatorGadget
*filePane_b9.static: true
*filePane_b9.name: filePane_b9
*filePane_b9.parent: filePane

*exitButton.class: pushButtonGadget
*exitButton.static: true
*exitButton.name: exitButton
*exitButton.parent: filePane
*exitButton.labelString: "Quit"
*exitButton.activateCallback: {\
   ConfirmDialogAsk (confirmD, "Do you really want to exit?", quit, NULL, NULL);\
}
*exitButton.accelerator: "Ctrl<Key>Q"
*exitButton.acceleratorText: "Ctrl+Q"

*editPane.class: rowColumn
*editPane.static: true
*editPane.name: editPane
*editPane.parent: pullDownMenu
*editPane.rowColumnType: "menu_pulldown"

*parameterButton.class: pushButtonGadget
*parameterButton.static: true
*parameterButton.name: parameterButton
*parameterButton.parent: editPane
*parameterButton.labelString: "Parameters ..."
*parameterButton.activateCallback: {\
  UxPopupInterface (parameterD, no_grab);\
}

*objectButton.class: pushButton
*objectButton.static: true
*objectButton.name: objectButton
*objectButton.parent: editPane
*objectButton.labelString: "Objects ..."
*objectButton.activateCallback: {\
    UxPopupInterface (objectD, no_grab);\
}

*lineButton.class: pushButton
*lineButton.static: true
*lineButton.name: lineButton
*lineButton.parent: editPane
*lineButton.labelString: "Lines ..."
*lineButton.activateCallback: {\
    UxPopupInterface (lineD, no_grab);\
}

*scanButton.class: pushButton
*scanButton.static: true
*scanButton.name: scanButton
*scanButton.parent: editPane
*scanButton.labelString: "Scans ..."
*scanButton.activateCallback: {\
    UxPopupInterface (scanD, no_grab);\
}

*cellButton.class: pushButton
*cellButton.static: true
*cellButton.name: cellButton
*cellButton.parent: editPane
*cellButton.labelString: "Cell ..."
*cellButton.activateCallback: {\
   UxPopupInterface (cellD, no_grab);   \
}

*findPane.class: rowColumn
*findPane.static: true
*findPane.name: findPane
*findPane.parent: pullDownMenu
*findPane.radioBehavior: "false"
*findPane.rowColumnType: "menu_pulldown"

*centreButton.class: pushButton
*centreButton.static: true
*centreButton.name: centreButton
*centreButton.parent: findPane
*centreButton.labelString: "Centre"
*centreButton.activateCallback: {\
   command ("Centre fit  ");\
   ListRangesOfSelectedItems (objectD);\
}
*centreButton.accelerator: "Ctrl<Key>C"
*centreButton.acceleratorText: "Ctrl+C"

*rotationButton.class: pushButton
*rotationButton.static: true
*rotationButton.name: rotationButton
*rotationButton.parent: findPane
*rotationButton.labelString: "Rotation"
*rotationButton.activateCallback: {\
   command ("Rotation fit  ");\
   ListSelectedItems (objectD);\
}
*rotationButton.accelerator: "Ctrl<Key>R"
*rotationButton.acceleratorText: "Ctrl+R"

*tiltButton.class: pushButton
*tiltButton.static: true
*tiltButton.name: tiltButton
*tiltButton.parent: findPane
*tiltButton.labelString: "Tilt"
*tiltButton.activateCallback: {\
   command ("Tilt fit  ");\
   ListSelectedItems (objectD);\
}
*tiltButton.accelerator: "Ctrl<Key>T"
*tiltButton.acceleratorText: "Ctrl+T"

*processPane.class: rowColumn
*processPane.static: true
*processPane.name: processPane
*processPane.parent: pullDownMenu
*processPane.rowColumnType: "menu_pulldown"

*listButton.class: pushButton
*listButton.static: true
*listButton.name: listButton
*listButton.parent: processPane
*listButton.labelString: "List Objects"
*listButton.accelerator: "Ctrl<Key>L"
*listButton.acceleratorText: "Ctrl+L"
*listButton.activateCallback: {\
    command ("List\n");\
}

*plotLineButton.class: pushButton
*plotLineButton.static: true
*plotLineButton.name: plotLineButton
*plotLineButton.parent: processPane
*plotLineButton.labelString: "Plot Lines ..."
*plotLineButton.activateCallback: {\
   command ("Plot Lines  ");\
   ListRangesOfSelectedItems (lineD);\
}

*plotScanButton.class: pushButton
*plotScanButton.static: true
*plotScanButton.name: plotScanButton
*plotScanButton.parent: processPane
*plotScanButton.labelString: "Plot Scans ..."
*plotScanButton.activateCallback: {\
   command ("Plot Scans  ");\
   ListRangesOfSelectedItems (scanD);\
}

*refineButton.class: pushButton
*refineButton.static: true
*refineButton.name: refineButton
*refineButton.parent: processPane
*refineButton.labelString: "Refine ..."
*refineButton.activateCallback: {\
    UxPopupInterface (refineD, no_grab);\
}
*refineButton.accelerator: "Ctrl<Key>F"
*refineButton.acceleratorText: "Ctrl+F"

*backgroundPane1.class: cascadeButton
*backgroundPane1.static: true
*backgroundPane1.name: backgroundPane1
*backgroundPane1.parent: processPane
*backgroundPane1.labelString: "Background"
*backgroundPane1.subMenuId: "backgroundPane"

*backgroundPane.class: rowColumn
*backgroundPane.static: true
*backgroundPane.name: backgroundPane
*backgroundPane.parent: processPane
*backgroundPane.rowColumnType: "menu_pulldown"

*windowButton.class: pushButton
*windowButton.static: true
*windowButton.name: windowButton
*windowButton.parent: backgroundPane
*windowButton.labelString: "roving window"
*windowButton.activateCallback: if(totalImages<=0)\
{\
  ErrorMessage_set(ErrMessage,&UxEnv,"No data loaded");\
  UxPopupInterface(ErrMessage,no_grab);\
}\
else\
{\
  BackWindowParams_setSize(BgWinParams,&UxEnv,npix,nrast);\
  BackWindowParams_setCentre(BgWinParams,&UxEnv,centreX,centreY);\
  UxPopupInterface(BgWinParams,no_grab);\
}\


*csymButton.class: pushButton
*csymButton.static: true
*csymButton.name: csymButton
*csymButton.parent: backgroundPane
*csymButton.labelString: "circularly symmetric"
*csymButton.activateCallback: if(totalImages<=0)\
{\
  ErrorMessage_set(ErrMessage,&UxEnv,"No data loaded");\
  UxPopupInterface(ErrMessage,no_grab);\
}\
else\
{\
  BackCsymParams_setCentre(BgCsymParams,&UxEnv,centreX,centreY);\
  BackCsymParams_setSize(BgCsymParams,&UxEnv,npix,nrast);\
  UxPopupInterface(BgCsymParams,no_grab);\
}\


*smoothButton.class: pushButton
*smoothButton.static: true
*smoothButton.name: smoothButton
*smoothButton.parent: backgroundPane
*smoothButton.labelString: "smooth"
*smoothButton.activateCallback: if(totalImages<=0)\
{\
  ErrorMessage_set(ErrMessage,&UxEnv,"No data loaded");\
  UxPopupInterface(ErrMessage,no_grab);\
}\
else\
{\
  BackSmoothParams_setCentre(BgSmoothParams,&UxEnv,centreX,centreY);\
  BackSmoothParams_setSize(BgSmoothParams,&UxEnv,npix,nrast);\
  UxPopupInterface(BgSmoothParams,no_grab);\
}

*optionsPane.class: rowColumn
*optionsPane.static: true
*optionsPane.name: optionsPane
*optionsPane.parent: pullDownMenu
*optionsPane.rowColumnType: "menu_pulldown"

*paletteCascade.class: cascadeButton
*paletteCascade.static: true
*paletteCascade.name: paletteCascade
*paletteCascade.parent: optionsPane
*paletteCascade.labelString: "Palette"
*paletteCascade.subMenuId: "palettePane"

*magCascade.class: cascadeButton
*magCascade.static: true
*magCascade.name: magCascade
*magCascade.parent: optionsPane
*magCascade.labelString: "Magnification"
*magCascade.subMenuId: "magPane"

*lineColourCascade.class: cascadeButton
*lineColourCascade.static: true
*lineColourCascade.name: lineColourCascade
*lineColourCascade.parent: optionsPane
*lineColourCascade.labelString: "Line Colour"
*lineColourCascade.subMenuId: "lineColourPane"

*pointColourCascade.class: cascadeButton
*pointColourCascade.static: true
*pointColourCascade.name: pointColourCascade
*pointColourCascade.parent: optionsPane
*pointColourCascade.labelString: "Lattice Point Colour"
*pointColourCascade.subMenuId: "pointColourPane"

*optionsPane_b8.class: separator
*optionsPane_b8.static: true
*optionsPane_b8.name: optionsPane_b8
*optionsPane_b8.parent: optionsPane

*logButton.class: toggleButton
*logButton.static: true
*logButton.name: logButton
*logButton.parent: optionsPane
*logButton.labelString: "Log Scale"
*logButton.valueChangedCallback: logarithmic = !logarithmic;

*interpolateButton.class: toggleButton
*interpolateButton.static: true
*interpolateButton.name: interpolateButton
*interpolateButton.parent: optionsPane
*interpolateButton.labelString: "Interpolate"
*interpolateButton.valueChangedCallback: interpolation = !interpolation;

*lineFitButton.class: toggleButtonGadget
*lineFitButton.static: true
*lineFitButton.name: lineFitButton
*lineFitButton.parent: optionsPane
*lineFitButton.labelString: "Fit Lines/Scans"
*lineFitButton.valueChangedCallback: fitLines = !fitLines;\
\
if (fitLines)\
   mode = 1;\
else\
   mode = 0;

*showPointsButton.class: toggleButton
*showPointsButton.static: true
*showPointsButton.name: showPointsButton
*showPointsButton.parent: optionsPane
*showPointsButton.labelString: "Show Lattice Points/Rings"
*showPointsButton.valueChangedCallback: showPoints = !showPoints;\
if (showPoints)\
{\
    DrawDrawnPoints (XtWindow (UxGetWidget (drawingArea1)));\
    DrawDrawnRings (XtWindow (UxGetWidget (drawingArea1)));\
}\
else\
{\
    RepaintOverDrawnPoints ();\
    RepaintOverDrawnRings ();\
}
*showPointsButton.set: "true"

*optionsPane_b10.class: separator
*optionsPane_b10.static: true
*optionsPane_b10.name: optionsPane_b10
*optionsPane_b10.parent: optionsPane

*azimuthalButton.class: toggleButton
*azimuthalButton.static: true
*azimuthalButton.name: azimuthalButton
*azimuthalButton.parent: optionsPane
*azimuthalButton.labelString: "Azimuthal Scan"
*azimuthalButton.set: "true"
*azimuthalButton.valueChangedCallback: XmToggleButtonSetState (UxGetWidget (azimuthalButton), True, False);\
XmToggleButtonSetState (UxGetWidget (radialButton), False, False);\
command ("Azimuthal\n");\
radialScan = False;
*azimuthalButton.indicatorType: "one_of_many"

*radialButton.class: toggleButton
*radialButton.static: true
*radialButton.name: radialButton
*radialButton.parent: optionsPane
*radialButton.labelString: "Radial Scan"
*radialButton.valueChangedCallback: XmToggleButtonSetState (UxGetWidget (azimuthalButton), False, False);\
XmToggleButtonSetState (UxGetWidget (radialButton), True, False);\
command ("Radial\n");\
radialScan = True;
*radialButton.indicatorType: "one_of_many"

*optionsPane_b12.class: separator
*optionsPane_b12.static: true
*optionsPane_b12.name: optionsPane_b12
*optionsPane_b12.parent: optionsPane

*latticePointButton.class: toggleButton
*latticePointButton.static: true
*latticePointButton.name: latticePointButton
*latticePointButton.parent: optionsPane
*latticePointButton.labelString: "Generate lattice points"
*latticePointButton.valueChangedCallback: XmToggleButtonSetState (UxGetWidget (latticePointButton), True, False);\
XmToggleButtonSetState (UxGetWidget (latticeCircleButton), False, False);\
\
command ("spot\n");\
plotLatticePoints = True;
*latticePointButton.indicatorType: "one_of_many"
*latticePointButton.set: "true"

*latticeCircleButton.class: toggleButton
*latticeCircleButton.static: true
*latticeCircleButton.name: latticeCircleButton
*latticeCircleButton.parent: optionsPane
*latticeCircleButton.labelString: "Generate lattice rings"
*latticeCircleButton.valueChangedCallback: XmToggleButtonSetState (UxGetWidget (latticePointButton), False, False);\
XmToggleButtonSetState (UxGetWidget (latticeCircleButton), True, False);\
\
command ("ring\n");\
plotLatticePoints = False;
*latticeCircleButton.indicatorType: "one_of_many"

*magPane.class: rowColumn
*magPane.static: true
*magPane.name: magPane
*magPane.parent: optionsPane
*magPane.rowColumnType: "menu_pulldown"
*magPane.radioBehavior: "true"

*x2Toggle.class: toggleButton
*x2Toggle.static: true
*x2Toggle.name: x2Toggle
*x2Toggle.parent: magPane
*x2Toggle.labelString: "x2"
*x2Toggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  magnification = 2;

*x4Toggle.class: toggleButton
*x4Toggle.static: true
*x4Toggle.name: x4Toggle
*x4Toggle.parent: magPane
*x4Toggle.labelString: "x4"
*x4Toggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  magnification = 4;

*x8Toggle.class: toggleButton
*x8Toggle.static: true
*x8Toggle.name: x8Toggle
*x8Toggle.parent: magPane
*x8Toggle.labelString: "x8"
*x8Toggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  magnification = 8;
*x8Toggle.set: "true"

*x16Toggle.class: toggleButton
*x16Toggle.static: true
*x16Toggle.name: x16Toggle
*x16Toggle.parent: magPane
*x16Toggle.labelString: "x16"
*x16Toggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  magnification = 16;

*x32Toggle.class: toggleButton
*x32Toggle.static: true
*x32Toggle.name: x32Toggle
*x32Toggle.parent: magPane
*x32Toggle.labelString: "x32"
*x32Toggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  magnification = 32;

*palettePane.class: rowColumn
*palettePane.static: true
*palettePane.name: palettePane
*palettePane.parent: optionsPane
*palettePane.rowColumnType: "menu_pulldown"
*palettePane.radioBehavior: "true"

*colour0Toggle.class: toggleButton
*colour0Toggle.static: true
*colour0Toggle.name: colour0Toggle
*colour0Toggle.parent: palettePane
*colour0Toggle.labelString: "Gray scale"
*colour0Toggle.accelerator: "Ctrl<Key>G"
*colour0Toggle.acceleratorText: "Ctrl+G"
*colour0Toggle.valueChangedCallback: if(XmToggleButtonGetState(UxWidget))\
{\
  GreyScale ();\
  invertedPalette = False;\
\
  if (currentImage >= 0)\
    LoadImage (xi[currentImage]);\
}
*colour0Toggle.set: "true"

*colour1Toggle.class: toggleButton
*colour1Toggle.static: true
*colour1Toggle.name: colour1Toggle
*colour1Toggle.parent: palettePane
*colour1Toggle.labelString: "Colour 1"
*colour1Toggle.accelerator: "Ctrl<Key>1"
*colour1Toggle.acceleratorText: "Ctrl+1"
*colour1Toggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
{\
  ColourPalette1 ();\
  invertedPalette = False;\
\
  if (currentImage >= 0)\
    LoadImage (xi[currentImage]);\
}

*colour2Toggle.class: toggleButton
*colour2Toggle.static: true
*colour2Toggle.name: colour2Toggle
*colour2Toggle.parent: palettePane
*colour2Toggle.labelString: "Colour 2"
*colour2Toggle.accelerator: "Ctrl<Key>2"
*colour2Toggle.acceleratorText: "Ctrl+2"
*colour2Toggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
{\
  ColourPalette2 ();\
  invertedPalette = False;\
\
  if (currentImage >= 0)\
    LoadImage (xi[currentImage]);\
}

*colour3Toggle.class: toggleButton
*colour3Toggle.static: true
*colour3Toggle.name: colour3Toggle
*colour3Toggle.parent: palettePane
*colour3Toggle.labelString: "Colour 3"
*colour3Toggle.accelerator: "Ctrl<Key>3"
*colour3Toggle.acceleratorText: "Ctrl+3"
*colour3Toggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
{\
  ColourPalette3 ();\
  invertedPalette = False;\
\
  if (currentImage >= 0)\
    LoadImage (xi[currentImage]);\
}

*colour4Toggle.class: toggleButton
*colour4Toggle.static: true
*colour4Toggle.name: colour4Toggle
*colour4Toggle.parent: palettePane
*colour4Toggle.labelString: "Colour 4"
*colour4Toggle.accelerator: "Ctrl<Key>4"
*colour4Toggle.acceleratorText: "Ctrl+4"
*colour4Toggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
{\
  ColourPalette4 ();\
  invertedPalette = False;\
\
  if (currentImage >= 0)\
    LoadImage (xi[currentImage]);\
}

*colour5Toggle.class: toggleButton
*colour5Toggle.static: true
*colour5Toggle.name: colour5Toggle
*colour5Toggle.parent: palettePane
*colour5Toggle.labelString: "Colour 5"
*colour5Toggle.accelerator: "Ctrl<Key>5"
*colour5Toggle.acceleratorText: "Ctrl+5"
*colour5Toggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
{\
  ColourPalette5 ();\
  invertedPalette = False;\
\
  if (currentImage >= 0)\
    LoadImage (xi[currentImage]);\
}

*pointColourPane.class: rowColumn
*pointColourPane.static: true
*pointColourPane.name: pointColourPane
*pointColourPane.parent: optionsPane
*pointColourPane.rowColumnType: "menu_pulldown"
*pointColourPane.radioBehavior: "true"

*greenToggle.class: toggleButton
*greenToggle.static: true
*greenToggle.name: greenToggle
*greenToggle.parent: pointColourPane
*greenToggle.labelString: "Green"
*greenToggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  XSetForeground (UxDisplay, pointGC, green.pixel);
*greenToggle.set: "true"
*greenToggle.indicatorType: "one_of_many"

*redToggle.class: toggleButton
*redToggle.static: true
*redToggle.name: redToggle
*redToggle.parent: pointColourPane
*redToggle.labelString: "Red"
*redToggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  XSetForeground (UxDisplay, pointGC, red.pixel);
*redToggle.indicatorType: "one_of_many"

*blueToggle.class: toggleButton
*blueToggle.static: true
*blueToggle.name: blueToggle
*blueToggle.parent: pointColourPane
*blueToggle.labelString: "Blue"
*blueToggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  XSetForeground (UxDisplay, pointGC, blue.pixel);
*blueToggle.indicatorType: "one_of_many"

*yellowToggle.class: toggleButton
*yellowToggle.static: true
*yellowToggle.name: yellowToggle
*yellowToggle.parent: pointColourPane
*yellowToggle.labelString: "Yellow"
*yellowToggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  XSetForeground (UxDisplay, pointGC, yellow.pixel);

*whiteToggle.class: toggleButton
*whiteToggle.static: true
*whiteToggle.name: whiteToggle
*whiteToggle.parent: pointColourPane
*whiteToggle.labelString: "White"
*whiteToggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  XSetForeground (UxDisplay, pointGC, white.pixel);
*whiteToggle.indicatorType: "one_of_many"

*blackToggle.class: toggleButton
*blackToggle.static: true
*blackToggle.name: blackToggle
*blackToggle.parent: pointColourPane
*blackToggle.labelString: "Black"
*blackToggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  XSetForeground (UxDisplay, pointGC, black.pixel);
*blackToggle.indicatorType: "one_of_many"

*lineColourPane.class: rowColumn
*lineColourPane.static: true
*lineColourPane.name: lineColourPane
*lineColourPane.parent: optionsPane
*lineColourPane.rowColumnType: "menu_pulldown"
*lineColourPane.radioBehavior: "true"

*lineGreenToggle.class: toggleButton
*lineGreenToggle.static: true
*lineGreenToggle.name: lineGreenToggle
*lineGreenToggle.parent: lineColourPane
*lineGreenToggle.labelString: "Green"
*lineGreenToggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  XSetForeground (UxDisplay, drawGC, green.pixel);
*lineGreenToggle.indicatorType: "one_of_many"

*lineRedToggle.class: toggleButton
*lineRedToggle.static: true
*lineRedToggle.name: lineRedToggle
*lineRedToggle.parent: lineColourPane
*lineRedToggle.labelString: "Red"
*lineRedToggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  XSetForeground (UxDisplay, drawGC, red.pixel);
*lineRedToggle.indicatorType: "one_of_many"

*lineBlueToggle.class: toggleButton
*lineBlueToggle.static: true
*lineBlueToggle.name: lineBlueToggle
*lineBlueToggle.parent: lineColourPane
*lineBlueToggle.labelString: "Blue"
*lineBlueToggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  XSetForeground (UxDisplay, drawGC, blue.pixel);
*lineBlueToggle.indicatorType: "one_of_many"

*lineYellowToggle.class: toggleButton
*lineYellowToggle.static: true
*lineYellowToggle.name: lineYellowToggle
*lineYellowToggle.parent: lineColourPane
*lineYellowToggle.labelString: "Yellow"
*lineYellowToggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  XSetForeground (UxDisplay, drawGC, yellow.pixel);
*lineYellowToggle.set: "true"
*lineYellowToggle.indicatorType: "one_of_many"

*lineWhiteToggle.class: toggleButton
*lineWhiteToggle.static: true
*lineWhiteToggle.name: lineWhiteToggle
*lineWhiteToggle.parent: lineColourPane
*lineWhiteToggle.labelString: "White"
*lineWhiteToggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  XSetForeground (UxDisplay, drawGC, white.pixel);
*lineWhiteToggle.indicatorType: "one_of_many"

*lineBlackToggle.class: toggleButton
*lineBlackToggle.static: true
*lineBlackToggle.name: lineBlackToggle
*lineBlackToggle.parent: lineColourPane
*lineBlackToggle.labelString: "Black"
*lineBlackToggle.valueChangedCallback: if (XmToggleButtonGetState(UxWidget))\
  XSetForeground (UxDisplay, drawGC, black.pixel);
*lineBlackToggle.indicatorType: "one_of_many"

*helpPane.class: rowColumn
*helpPane.static: true
*helpPane.name: helpPane
*helpPane.parent: pullDownMenu
*helpPane.rowColumnType: "menu_pulldown"

*introButton.class: pushButton
*introButton.static: true
*introButton.name: introButton
*introButton.parent: helpPane
*introButton.labelString: "Introduction ..."
*introButton.activateCallback: {\
mainWS_help (mainWS, &UxEnv, "#INTRO");\
}

*helpPane_b10.class: separator
*helpPane_b10.static: true
*helpPane_b10.name: helpPane_b10
*helpPane_b10.parent: helpPane

*onFileButton.class: pushButtonGadget
*onFileButton.static: true
*onFileButton.name: onFileButton
*onFileButton.parent: helpPane
*onFileButton.labelString: "On File ..."
*onFileButton.mnemonic: "C"
*onFileButton.activateCallback: {\
mainWS_help (mainWS, &UxEnv, "#MENU1");\
}

*onEditButton.class: pushButtonGadget
*onEditButton.static: true
*onEditButton.name: onEditButton
*onEditButton.parent: helpPane
*onEditButton.labelString: "On Edit ..."
*onEditButton.mnemonic: "W"
*onEditButton.activateCallback: {\
mainWS_help (mainWS, &UxEnv, "#MENU2");\
}

*onEstimateButton.class: pushButtonGadget
*onEstimateButton.static: true
*onEstimateButton.name: onEstimateButton
*onEstimateButton.parent: helpPane
*onEstimateButton.labelString: "On Estimate ..."
*onEstimateButton.mnemonic: "K"
*onEstimateButton.activateCallback: {\
mainWS_help (mainWS, &UxEnv, "#MENU3");\
}

*onProcessButton.class: pushButtonGadget
*onProcessButton.static: true
*onProcessButton.name: onProcessButton
*onProcessButton.parent: helpPane
*onProcessButton.labelString: "On Process ..."
*onProcessButton.mnemonic: "H"
*onProcessButton.activateCallback: {\
mainWS_help (mainWS, &UxEnv, "#MENU4");\
}

*onOptionsButton.class: pushButton
*onOptionsButton.static: true
*onOptionsButton.name: onOptionsButton
*onOptionsButton.parent: helpPane
*onOptionsButton.labelString: "On Options ..."
*onOptionsButton.activateCallback: {\
mainWS_help (mainWS, &UxEnv, "#MENU5");\
}

*onToolsButton.class: pushButtonGadget
*onToolsButton.static: true
*onToolsButton.name: onToolsButton
*onToolsButton.parent: helpPane
*onToolsButton.labelString: "On Tools ..."
*onToolsButton.activateCallback: {\
mainWS_help (mainWS, &UxEnv, "#TOOLS");\
}

*fileCascade.class: cascadeButton
*fileCascade.static: true
*fileCascade.name: fileCascade
*fileCascade.parent: pullDownMenu
*fileCascade.labelString: "File"
*fileCascade.subMenuId: "filePane"
*fileCascade.width: 40

*editCascade.class: cascadeButton
*editCascade.static: true
*editCascade.name: editCascade
*editCascade.parent: pullDownMenu
*editCascade.labelString: "Edit"
*editCascade.subMenuId: "editPane"
*editCascade.width: 40

*viewCascade.class: cascadeButton
*viewCascade.static: true
*viewCascade.name: viewCascade
*viewCascade.parent: pullDownMenu
*viewCascade.labelString: "Estimate"
*viewCascade.subMenuId: "findPane"
*viewCascade.width: 73

*pullDownMenu_top_b1.class: cascadeButton
*pullDownMenu_top_b1.static: true
*pullDownMenu_top_b1.name: pullDownMenu_top_b1
*pullDownMenu_top_b1.parent: pullDownMenu
*pullDownMenu_top_b1.labelString: "Process"
*pullDownMenu_top_b1.subMenuId: "processPane"
*pullDownMenu_top_b1.width: 65

*optionsCascade.class: cascadeButton
*optionsCascade.static: true
*optionsCascade.name: optionsCascade
*optionsCascade.parent: pullDownMenu
*optionsCascade.labelString: "Options"
*optionsCascade.subMenuId: "optionsPane"
*optionsCascade.width: 65

*helpCascade.class: cascadeButton
*helpCascade.static: true
*helpCascade.name: helpCascade
*helpCascade.parent: pullDownMenu
*helpCascade.labelString: "Help"
*helpCascade.subMenuId: "helpPane"

*panedWindow1.class: panedWindow
*panedWindow1.static: true
*panedWindow1.name: panedWindow1
*panedWindow1.parent: mainWindow
*panedWindow1.spacing: 10

*form1.class: form
*form1.static: true
*form1.name: form1
*form1.parent: panedWindow1
*form1.resizePolicy: "resize_none"
*form1.isCompound: "true"
*form1.compoundIcon: "form.xpm"
*form1.compoundName: "form_"

*label1.class: label
*label1.static: true
*label1.name: label1
*label1.parent: form1
*label1.isCompound: "true"
*label1.compoundIcon: "label.xpm"
*label1.compoundName: "label_"
*label1.x: 10
*label1.y: 0
*label1.width: 80
*label1.height: 30
*label1.labelString: "Filename:"
*label1.alignment: "alignment_beginning"
*label1.leftAttachment: "attach_form"
*label1.topAttachment: "attach_form"
*label1.leftOffset: 10
*label1.fontList: "7x14"

*label2.class: label
*label2.static: true
*label2.name: label2
*label2.parent: form1
*label2.isCompound: "true"
*label2.compoundIcon: "label.xpm"
*label2.compoundName: "label_"
*label2.x: 550
*label2.y: 0
*label2.width: 15
*label2.height: 30
*label2.labelString: "X:"
*label2.alignment: "alignment_beginning"
*label2.leftAttachment: "attach_form"
*label2.leftOffset: 300
*label2.topAttachment: "attach_form"
*label2.fontList: "7x14"

*label3.class: label
*label3.static: true
*label3.name: label3
*label3.parent: form1
*label3.isCompound: "true"
*label3.compoundIcon: "label.xpm"
*label3.compoundName: "label_"
*label3.x: 440
*label3.y: 0
*label3.width: 45
*label3.height: 30
*label3.labelString: "Pixel:"
*label3.alignment: "alignment_beginning"
*label3.leftAttachment: "attach_form"
*label3.leftOffset: 450
*label3.topAttachment: "attach_form"
*label3.topOffset: 0
*label3.fontList: "7x14"

*frame1.class: frame
*frame1.static: true
*frame1.name: frame1
*frame1.parent: form1
*frame1.x: 530
*frame1.y: 10
*frame1.width: 128
*frame1.height: 128
*frame1.rightAttachment: "attach_form"
*frame1.rightOffset: 10
*frame1.topAttachment: "attach_form"
*frame1.topOffset: 32

*drawingArea2.class: drawingArea
*drawingArea2.static: true
*drawingArea2.name: drawingArea2
*drawingArea2.parent: frame1
*drawingArea2.resizePolicy: "resize_any"
*drawingArea2.width: 128
*drawingArea2.height: 128
*drawingArea2.isCompound: "true"
*drawingArea2.compoundIcon: "drawing.xpm"
*drawingArea2.compoundName: "drawing_Area"
*drawingArea2.createCallback: {\
\
\
\
}
*drawingArea2.background: "white"
*drawingArea2.foreground: "white"
*drawingArea2.translations: area2PointTable

*label4.class: label
*label4.static: true
*label4.name: label4
*label4.parent: form1
*label4.isCompound: "true"
*label4.compoundIcon: "label.xpm"
*label4.compoundName: "label_"
*label4.x: 185
*label4.y: 0
*label4.width: 55
*label4.height: 30
*label4.labelString: "Frame:"
*label4.alignment: "alignment_beginning"
*label4.leftAttachment: "attach_form"
*label4.leftOffset: 185
*label4.topAttachment: "attach_form"
*label4.fontList: "7x14"

*rowColumn1.class: rowColumn
*rowColumn1.static: true
*rowColumn1.name: rowColumn1
*rowColumn1.parent: form1
*rowColumn1.isCompound: "true"
*rowColumn1.compoundIcon: "row.xpm"
*rowColumn1.compoundName: "row_Column"
*rowColumn1.borderWidth: 1
*rowColumn1.entryVerticalAlignment: "alignment_contents_top"
*rowColumn1.labelString: "Tools"
*rowColumn1.packing: "pack_tight"
*rowColumn1.isResizable: "true"
*rowColumn1.radioBehavior: "true"
*rowColumn1.rightAttachment: "attach_form"
*rowColumn1.rightOffset: 20
*rowColumn1.topAttachment: "attach_form"
*rowColumn1.topOffset: 330

*togglePoint.class: toggleButton
*togglePoint.static: true
*togglePoint.name: togglePoint
*togglePoint.parent: rowColumn1
*togglePoint.isCompound: "true"
*togglePoint.compoundIcon: "toggle.xpm"
*togglePoint.compoundName: "toggle_Button"
*togglePoint.labelString: "Points"
*togglePoint.shadowThickness: 1
*togglePoint.set: "true"
*togglePoint.valueChangedCallback: {\
if (XmToggleButtonGetState (UxWidget))\
{\
   XtVaSetValues (drawingArea1,\
                  XmNtranslations, XtParseTranslationTable (area1PointTable),\
                  NULL);\
\
   XtVaSetValues (drawingArea2,\
                  XmNtranslations, XtParseTranslationTable (area2PointTable),\
                  NULL);\
\
   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorPoint);\
   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea2)), cursorPoint);\
\
   if (lastToggle != UxWidget)\
   {\
      lastToggle = UxWidget;\
      update_messages ("\nPoints: Use the cursor to select points in the main window ");\
      update_messages ("or the magnification window\n\n");\
      update_messages ("Left mouse button selects point\n");\
      update_messages ("Middle mouse button freezes magnification window\n");\
      update_messages ("Right mouse button releases magnification window\n\n");\
   }\
}\
}
*togglePoint.valueChangedCallbackClientData: (XtPointer) 0x0
*togglePoint.fontList: "7x14"
*togglePoint.recomputeSize: "false"
*togglePoint.marginHeight: 0

*toggleLine.class: toggleButton
*toggleLine.static: true
*toggleLine.name: toggleLine
*toggleLine.parent: rowColumn1
*toggleLine.isCompound: "true"
*toggleLine.compoundIcon: "toggle.xpm"
*toggleLine.compoundName: "toggle_Button"
*toggleLine.labelString: "Lines"
*toggleLine.shadowThickness: 1
*toggleLine.valueChangedCallback: {\
if (XmToggleButtonGetState (UxWidget))\
{\
   XtVaSetValues (drawingArea1,\
                  XmNtranslations, XtParseTranslationTable (area1LineTable),\
                  NULL);\
\
   XtVaSetValues (drawingArea2,\
                  XmNtranslations, XtParseTranslationTable (area2LineTable),\
                  NULL); \
\
   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorPoint);\
   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea2)), cursorPoint);\
\
   if (lastToggle != UxWidget)\
   {\
      lastToggle = UxWidget;\
      update_messages ("\nLines: Use the cursor to select lines in the main window ");\
      update_messages ("or the magnification window\n\n");\
      update_messages ("Left mouse button selects start point\n");\
      update_messages ("Middle mouse button selects end point\n");\
      update_messages ("Right mouse button ends selection of line\n\n");\
   }\
}\
}
*toggleLine.valueChangedCallbackClientData: (XtPointer) 0x0
*toggleLine.fontList: "7x14"
*toggleLine.recomputeSize: "false"
*toggleLine.marginHeight: 0

*toggleThick.class: toggleButton
*toggleThick.static: true
*toggleThick.name: toggleThick
*toggleThick.parent: rowColumn1
*toggleThick.isCompound: "true"
*toggleThick.compoundIcon: "toggle.xpm"
*toggleThick.compoundName: "toggle_Button"
*toggleThick.labelString: "Thick Lines"
*toggleThick.shadowThickness: 1
*toggleThick.valueChangedCallback: {\
if (XmToggleButtonGetState (UxWidget))\
{\
   XtVaSetValues (drawingArea1,\
                  XmNtranslations, XtParseTranslationTable (area1ThickTable),\
                  NULL);\
\
   XtVaSetValues (drawingArea2,\
                  XmNtranslations, XtParseTranslationTable (area2ThickTable),\
                  NULL); \
\
   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorPoint);\
   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea2)), cursorPoint);\
\
   if (lastToggle != UxWidget)\
   {\
      lastToggle = UxWidget;      \
      update_messages ("\nThick Lines: Use the cursor to select lines in the main window ");\
      update_messages ("or the magnification window\n\n");\
      update_messages ("Left mouse button selects start point\n");\
      update_messages ("Shift + left mouse button selects width\n");\
      update_messages ("Middle mouse button selects end point\n");\
      update_messages ("Right mouse button ends selection of line\n\n");\
   }\
}\
}
*toggleThick.valueChangedCallbackClientData: (XtPointer) 0x0
*toggleThick.fontList: "7x14"
*toggleThick.recomputeSize: "false"
*toggleThick.marginHeight: 0

*toggleRect.class: toggleButton
*toggleRect.static: true
*toggleRect.name: toggleRect
*toggleRect.parent: rowColumn1
*toggleRect.isCompound: "true"
*toggleRect.compoundIcon: "toggle.xpm"
*toggleRect.compoundName: "toggle_Button"
*toggleRect.labelString: "Rectangles"
*toggleRect.shadowThickness: 1
*toggleRect.valueChangedCallback: {\
if (XmToggleButtonGetState (UxWidget))\
{\
   XtVaSetValues (drawingArea1,\
                  XmNtranslations, XtParseTranslationTable (area1RectTable),\
                  NULL);\
\
   XtVaSetValues (drawingArea2,\
                  XmNtranslations, XtParseTranslationTable (area2RectTable),\
                  NULL); \
\
   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorBox);\
   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea2)), cursorBox);\
\
   if (lastToggle != UxWidget)\
   {\
      lastToggle = UxWidget;      \
      update_messages ("\nRectangles: Use the cursor to select rectangles in the main window ");\
      update_messages ("or the magnification window\n\n");\
      update_messages ("Left mouse button selects top-left corner\n");\
      update_messages ("Middle mouse button selects bottom-right corner\n");\
      update_messages ("Right mouse button ends selection of rectangle\n\n");\
   }\
}\
}
*toggleRect.valueChangedCallbackClientData: (XtPointer) 0x0
*toggleRect.fontList: "7x14"
*toggleRect.recomputeSize: "false"
*toggleRect.marginHeight: 0

*togglePoly.class: toggleButton
*togglePoly.static: true
*togglePoly.name: togglePoly
*togglePoly.parent: rowColumn1
*togglePoly.isCompound: "true"
*togglePoly.compoundIcon: "toggle.xpm"
*togglePoly.compoundName: "toggle_Button"
*togglePoly.labelString: "Polygons"
*togglePoly.shadowThickness: 1
*togglePoly.valueChangedCallback: {\
if (XmToggleButtonGetState (UxWidget))\
{\
   XtVaSetValues (drawingArea1,\
                  XmNtranslations, XtParseTranslationTable (area1PolyTable),\
                  NULL);\
\
   XtVaSetValues (drawingArea2,\
                  XmNtranslations, XtParseTranslationTable (area2PolyTable),\
                  NULL); \
\
   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorPoly);\
   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea2)), cursorPoly);\
\
   if (lastToggle != UxWidget)\
   {\
      lastToggle = UxWidget;\
      update_messages ("\nPolygons: Use the cursor to select polygons in the main window ");\
      update_messages ("or the magnification window\n\n");\
      update_messages ("Left mouse button selects a vertex\n");\
      update_messages ("Middle mouse button deletes last vertex\n");\
      update_messages ("Right mouse button closes the polygon\n\n");\
   }\
}\
}
*togglePoly.valueChangedCallbackClientData: (XtPointer) 0x0
*togglePoly.fontList: "7x14"
*togglePoly.recomputeSize: "false"
*togglePoly.marginHeight: 0
*togglePoly.x: -3
*togglePoly.y: 33

*toggleSector.class: toggleButton
*toggleSector.static: true
*toggleSector.name: toggleSector
*toggleSector.parent: rowColumn1
*toggleSector.isCompound: "true"
*toggleSector.compoundIcon: "toggle.xpm"
*toggleSector.compoundName: "toggle_Button"
*toggleSector.labelString: "Sectors"
*toggleSector.shadowThickness: 1
*toggleSector.valueChangedCallback: {\
if (XmToggleButtonGetState (UxWidget))\
{\
\
  XtVaSetValues (drawingArea1,\
                  XmNtranslations, XtParseTranslationTable (area1SectorTable),\
                  NULL);\
\
   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorBox);\
\
   if (lastToggle != UxWidget)\
   {\
      lastToggle = UxWidget;      \
      update_messages ("\nSectors: Use the cursor to select sectors in the main window\n\n");\
      update_messages ("Left mouse button selects start angle and radius\n");\
      update_messages ("Middle mouse button selects end angle and radius\n");\
      update_messages ("Right mouse button ends selection of sector\n\n");\
   }\
}\
}
*toggleSector.valueChangedCallbackClientData: (XtPointer) 0x0
*toggleSector.fontList: "7x14"
*toggleSector.recomputeSize: "false"
*toggleSector.marginHeight: 0

*toggleScan.class: toggleButton
*toggleScan.static: true
*toggleScan.name: toggleScan
*toggleScan.parent: rowColumn1
*toggleScan.isCompound: "true"
*toggleScan.compoundIcon: "toggle.xpm"
*toggleScan.compoundName: "toggle_Button"
*toggleScan.labelString: "Scans"
*toggleScan.shadowThickness: 1
*toggleScan.valueChangedCallback: {\
if (XmToggleButtonGetState (UxWidget))\
{\
   XtVaSetValues (drawingArea1,\
                  XmNtranslations, XtParseTranslationTable (area1SectorTable),\
                  NULL);\
\
   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorBox);\
\
   if (lastToggle != UxWidget)\
   {\
      lastToggle = UxWidget;      \
      update_messages ("\nScans: Use the cursor to select scans in the main window\n\n");\
      update_messages ("Left mouse button selects start angle and radius\n");\
      update_messages ("Middle mouse button selects end angle and radius\n");\
      update_messages ("Right mouse button ends selection of scan\n\n");\
   }\
\
}\
}
*toggleScan.valueChangedCallbackClientData: (XtPointer) 0x0
*toggleScan.fontList: "7x14"
*toggleScan.recomputeSize: "false"
*toggleScan.marginHeight: 0

*toggleZoom.class: toggleButton
*toggleZoom.static: true
*toggleZoom.name: toggleZoom
*toggleZoom.parent: rowColumn1
*toggleZoom.isCompound: "true"
*toggleZoom.compoundIcon: "toggle.xpm"
*toggleZoom.compoundName: "toggle_Button"
*toggleZoom.labelString: "Zoom"
*toggleZoom.shadowThickness: 1
*toggleZoom.valueChangedCallback: {\
if (XmToggleButtonGetState (UxWidget))\
{\
   XtVaSetValues (drawingArea1,\
                  XmNtranslations, XtParseTranslationTable (area1ZoomTable),\
                  NULL);\
\
   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorBox);\
\
   if (lastToggle != UxWidget)\
   {\
      lastToggle = UxWidget;      \
      update_messages ("\nZoom: Use the cursor to select zoom area in the main window\n\n");\
      update_messages ("Left mouse button selects top-left corner\n");\
      update_messages ("Middle mouse button selects bottom-right corner\n");\
      update_messages ("Right mouse button ends selection of zoom area\n\n");\
   }\
}\
}
*toggleZoom.valueChangedCallbackClientData: (XtPointer) 0x0
*toggleZoom.fontList: "7x14"
*toggleZoom.recomputeSize: "false"
*toggleZoom.marginHeight: 0

*label5.class: label
*label5.static: true
*label5.name: label5
*label5.parent: form1
*label5.isCompound: "true"
*label5.compoundIcon: "label.xpm"
*label5.compoundName: "label_"
*label5.x: 640
*label5.y: 160
*label5.width: 15
*label5.height: 30
*label5.labelString: "Y:"
*label5.alignment: "alignment_beginning"
*label5.leftAttachment: "attach_form"
*label5.leftOffset: 370
*label5.topAttachment: "attach_form"
*label5.topOffset: 0
*label5.fontList: "7x14"

*textHigh.class: textField
*textHigh.static: true
*textHigh.name: textHigh
*textHigh.parent: form1
*textHigh.width: 90
*textHigh.isCompound: "true"
*textHigh.compoundIcon: "textfield.xpm"
*textHigh.compoundName: "text_Field"
*textHigh.height: 30
*textHigh.activateCallback: {\
char *cptr  = XmTextFieldGetString (UxWidget);\
xi[currentImage]->tmax = atof (cptr);\
free (cptr);\
\
cptr  = XmTextFieldGetString (UxGetWidget (textLow));\
xi[currentImage]->tmin = atof (cptr);\
free (cptr);\
\
SetBusyPointer (1);\
if (logarithmic)\
    ScaleLog (xi[currentImage]);\
else\
    ScaleLinear (xi[currentImage]);\
\
LoadImage (xi[currentImage]);\
SetBusyPointer (0);\
\
cptr = (char *) malloc (20 * sizeof (char));\
sprintf (cptr, "%9g", xi[currentImage]->tmax);\
XmTextFieldSetString (UxWidget, cptr);\
sprintf (cptr, "%9g", xi[currentImage]->tmin);\
XmTextFieldSetString (UxGetWidget (textLow), cptr);\
free (cptr);\
}
*textHigh.sensitive: "false"
*textHigh.text: ""
*textHigh.columns: 12
*textHigh.rightAttachment: "attach_form"
*textHigh.rightOffset: 10
*textHigh.topAttachment: "attach_form"
*textHigh.topOffset: 175
*textHigh.fontList: "7x14"
*textHigh.x: 582
*textHigh.y: 176

*textLow.class: textField
*textLow.static: true
*textLow.name: textLow
*textLow.parent: form1
*textLow.width: 90
*textLow.isCompound: "true"
*textLow.compoundIcon: "textfield.xpm"
*textLow.compoundName: "text_Field"
*textLow.height: 30
*textLow.activateCallback: {\
char *cptr  = XmTextFieldGetString (UxWidget);\
xi[currentImage]->tmin = atof (cptr);\
free (cptr);\
\
cptr  = XmTextFieldGetString (UxGetWidget (textHigh));\
xi[currentImage]->tmax = atof (cptr);\
free (cptr);\
\
SetBusyPointer (1);\
if (logarithmic)\
    ScaleLog (xi[currentImage]);\
else\
    ScaleLinear (xi[currentImage]);\
\
LoadImage (xi[currentImage]);\
SetBusyPointer (0);\
\
cptr = (char *) malloc (20 * sizeof (char));\
sprintf (cptr, "%9g", xi[currentImage]->tmin);\
XmTextFieldSetString (UxWidget, cptr);\
sprintf (cptr, "%9g", xi[currentImage]->tmax);\
XmTextFieldSetString (UxGetWidget (textHigh), cptr);\
free (cptr);\
}
*textLow.sensitive: "false"
*textLow.text: ""
*textLow.columns: 12
*textLow.rightAttachment: "attach_form"
*textLow.rightOffset: 10
*textLow.topAttachment: "attach_form"
*textLow.topOffset: 210
*textLow.fontList: "7x14"
*textLow.x: 582
*textLow.y: 211

*label6.class: label
*label6.static: true
*label6.name: label6
*label6.parent: form1
*label6.isCompound: "true"
*label6.compoundIcon: "label.xpm"
*label6.compoundName: "label_"
*label6.width: 45
*label6.height: 30
*label6.labelString: "High:"
*label6.alignment: "alignment_beginning"
*label6.rightAttachment: "attach_form"
*label6.rightOffset: 100
*label6.topAttachment: "attach_form"
*label6.topOffset: 175
*label6.fontList: "7x14"
*label6.x: 537
*label6.y: 176

*label7.class: label
*label7.static: true
*label7.name: label7
*label7.parent: form1
*label7.isCompound: "true"
*label7.compoundIcon: "label.xpm"
*label7.compoundName: "label_"
*label7.width: 45
*label7.height: 30
*label7.alignment: "alignment_beginning"
*label7.labelString: "Low:"
*label7.rightAttachment: "attach_form"
*label7.rightOffset: 100
*label7.topAttachment: "attach_form"
*label7.topOffset: 210
*label7.fontList: "7x14"
*label7.x: 542
*label7.y: 211

*textX.class: textField
*textX.static: true
*textX.name: textX
*textX.parent: form1
*textX.width: 50
*textX.isCompound: "true"
*textX.compoundIcon: "textfield.xpm"
*textX.compoundName: "text_Field"
*textX.x: 580
*textX.y: 170
*textX.height: 30
*textX.cursorPositionVisible: "false"
*textX.editable: "false"
*textX.text: ""
*textX.leftAttachment: "attach_form"
*textX.leftOffset: 320
*textX.topAttachment: "attach_form"
*textX.topOffset: 0
*textX.fontList: "7x14"

*textY.class: textField
*textY.static: true
*textY.name: textY
*textY.parent: form1
*textY.width: 50
*textY.isCompound: "true"
*textY.compoundIcon: "textfield.xpm"
*textY.compoundName: "text_Field"
*textY.x: 440
*textY.y: 0
*textY.height: 30
*textY.cursorPositionVisible: "false"
*textY.editable: "false"
*textY.text: ""
*textY.leftAttachment: "attach_form"
*textY.leftOffset: 390
*textY.topAttachment: "attach_form"
*textY.topOffset: 0
*textY.fontList: "7x14"

*textValue.class: textField
*textValue.static: true
*textValue.name: textValue
*textValue.parent: form1
*textValue.width: 90
*textValue.isCompound: "true"
*textValue.compoundIcon: "textfield.xpm"
*textValue.compoundName: "text_Field"
*textValue.x: -140
*textValue.y: 195
*textValue.height: 30
*textValue.cursorPositionVisible: "false"
*textValue.editable: "false"
*textValue.text: ""
*textValue.leftAttachment: "attach_form"
*textValue.leftOffset: 495
*textValue.topAttachment: "attach_form"
*textValue.topOffset: 0
*textValue.fontList: "7x14"

*arrowButton1.class: arrowButton
*arrowButton1.static: true
*arrowButton1.name: arrowButton1
*arrowButton1.parent: form1
*arrowButton1.isCompound: "true"
*arrowButton1.compoundIcon: "arrow.xpm"
*arrowButton1.compoundName: "arrow_Button"
*arrowButton1.x: 650
*arrowButton1.y: 0
*arrowButton1.arrowDirection: "arrow_right"
*arrowButton1.sensitive: "false"
*arrowButton1.activateCallback: {\
currentImage++;\
sprintf (textBuf, "%1d", currentImage);\
XmTextFieldSetString (UxGetWidget (imageText), textBuf);\
LoadImage (xi[currentImage]);\
\
\
\
}
*arrowButton1.highlightColor: "black"
*arrowButton1.foreground: "green"
*arrowButton1.height: 30
*arrowButton1.width: 30

*imageText.class: textField
*imageText.static: true
*imageText.name: imageText
*imageText.parent: form1
*imageText.width: 30
*imageText.isCompound: "true"
*imageText.compoundIcon: "textfield.xpm"
*imageText.compoundName: "text_Field"
*imageText.x: 620
*imageText.y: 10
*imageText.height: 30
*imageText.columns: 2
*imageText.cursorPositionVisible: "false"
*imageText.editable: "false"
*imageText.text: ""
*imageText.valueChangedCallback: {\
int value;\
char *cptr = XmTextFieldGetString (UxWidget);\
\
if (*cptr)\
{\
   value = atoi (cptr);\
   if (value > 0)\
   {\
      XtSetSensitive (UxGetWidget (arrowButton2), True);\
   }\
   else\
   {\
      XtSetSensitive (UxGetWidget (arrowButton2), False);\
   }\
\
\
   if (value < totalImages - 1)\
   {\
      XtSetSensitive (UxGetWidget (arrowButton1), True);\
   }\
   else\
   {\
      XtSetSensitive (UxGetWidget (arrowButton1), False);\
   }\
}\
else\
{\
   XtSetSensitive (UxGetWidget (arrowButton1), False);\
   XtSetSensitive (UxGetWidget (arrowButton2), False);\
}\
}
*imageText.topAttachment: "attach_form"
*imageText.topOffset: 0
*imageText.fontList: "7x14"

*arrowButton2.class: arrowButton
*arrowButton2.static: true
*arrowButton2.name: arrowButton2
*arrowButton2.parent: form1
*arrowButton2.isCompound: "true"
*arrowButton2.compoundIcon: "arrow.xpm"
*arrowButton2.compoundName: "arrow_Button"
*arrowButton2.y: 0
*arrowButton2.height: 30
*arrowButton2.arrowDirection: "arrow_left"
*arrowButton2.sensitive: "false"
*arrowButton2.activateCallback: {\
currentImage--;\
sprintf (textBuf, "%1d", currentImage);\
XmTextFieldSetString (UxGetWidget (imageText), textBuf);\
LoadImage (xi[currentImage]);\
}
*arrowButton2.highlightColor: "black"
*arrowButton2.foreground: "green"
*arrowButton2.width: 30
*arrowButton2.x: 590

*fileText.class: textField
*fileText.static: true
*fileText.name: fileText
*fileText.parent: form1
*fileText.width: 90
*fileText.isCompound: "true"
*fileText.compoundIcon: "textfield.xpm"
*fileText.compoundName: "text_Field"
*fileText.x: 90
*fileText.y: 10
*fileText.height: 30
*fileText.cursorPositionVisible: "false"
*fileText.editable: "false"
*fileText.topAttachment: "attach_form"
*fileText.topOffset: 0
*fileText.leftAttachment: "attach_form"
*fileText.leftOffset: 90
*fileText.fontList: "7x14"

*frameText.class: textField
*frameText.static: true
*frameText.name: frameText
*frameText.parent: form1
*frameText.width: 50
*frameText.isCompound: "true"
*frameText.compoundIcon: "textfield.xpm"
*frameText.compoundName: "text_Field"
*frameText.x: 240
*frameText.y: 10
*frameText.height: 30
*frameText.cursorPositionVisible: "false"
*frameText.editable: "false"
*frameText.leftAttachment: "attach_form"
*frameText.topAttachment: "attach_form"
*frameText.topOffset: 0
*frameText.leftOffset: 240
*frameText.fontList: "7x14"

*scrolledWindow1.class: scrolledWindow
*scrolledWindow1.static: true
*scrolledWindow1.name: scrolledWindow1
*scrolledWindow1.parent: form1
*scrolledWindow1.scrollingPolicy: "automatic"
*scrolledWindow1.width: 530
*scrolledWindow1.height: 530
*scrolledWindow1.isCompound: "true"
*scrolledWindow1.compoundIcon: "scrlwnd.xpm"
*scrolledWindow1.compoundName: "scrolled_Window"
*scrolledWindow1.scrollBarDisplayPolicy: "static"
*scrolledWindow1.visualPolicy: "variable"
*scrolledWindow1.shadowThickness: 1
*scrolledWindow1.borderWidth: 1
*scrolledWindow1.spacing: 0
*scrolledWindow1.bottomAttachment: "attach_form"
*scrolledWindow1.leftAttachment: "attach_form"
*scrolledWindow1.rightAttachment: "attach_form"
*scrolledWindow1.rightOffset: 152
*scrolledWindow1.topAttachment: "attach_form"
*scrolledWindow1.topOffset: 32

*drawingArea1.class: drawingArea
*drawingArea1.static: true
*drawingArea1.name: drawingArea1
*drawingArea1.parent: scrolledWindow1
*drawingArea1.resizePolicy: "resize_any"
*drawingArea1.width: 512
*drawingArea1.height: 512
*drawingArea1.isCompound: "true"
*drawingArea1.compoundIcon: "drawing.xpm"
*drawingArea1.compoundName: "drawing_Area"
*drawingArea1.x: 0
*drawingArea1.y: 0
*drawingArea1.marginHeight: 0
*drawingArea1.marginWidth: 0
*drawingArea1.translations: area1PointTable
*drawingArea1.createCallback: {\
\
}
*drawingArea1.background: "white"
*drawingArea1.foreground: "white"

*invertButton.class: pushButton
*invertButton.static: true
*invertButton.name: invertButton
*invertButton.parent: form1
*invertButton.isCompound: "true"
*invertButton.compoundIcon: "push.xpm"
*invertButton.compoundName: "push_Button"
*invertButton.width: 110
*invertButton.height: 30
*invertButton.activateCallback: {\
InvertPalette ();\
invertedPalette = !invertedPalette;\
\
if (currentImage >= 0)\
    LoadImage (xi[currentImage]);\
}
*invertButton.leftAttachment: "attach_none"
*invertButton.rightAttachment: "attach_form"
*invertButton.rightOffset: 20
*invertButton.topOffset: 255
*invertButton.labelString: "Invert Palette"
*invertButton.topAttachment: "attach_form"
*invertButton.fontList: "7x14"

*refreshButton.class: pushButton
*refreshButton.static: true
*refreshButton.name: refreshButton
*refreshButton.parent: form1
*refreshButton.isCompound: "true"
*refreshButton.compoundIcon: "push.xpm"
*refreshButton.compoundName: "push_Button"
*refreshButton.width: 110
*refreshButton.height: 30
*refreshButton.activateCallback: {\
RefreshPalette ();\
}
*refreshButton.labelString: "Refresh"
*refreshButton.topOffset: 290
*refreshButton.leftAttachment: "attach_none"
*refreshButton.rightAttachment: "attach_form"
*refreshButton.rightOffset: 20
*refreshButton.topAttachment: "attach_form"
*refreshButton.fontList: "7x14"

*scrolledWindowText1.class: scrolledWindow
*scrolledWindowText1.static: true
*scrolledWindowText1.name: scrolledWindowText1
*scrolledWindowText1.parent: panedWindow1
*scrolledWindowText1.scrollingPolicy: "application_defined"
*scrolledWindowText1.visualPolicy: "variable"
*scrolledWindowText1.scrollBarDisplayPolicy: "static"
*scrolledWindowText1.isCompound: "true"
*scrolledWindowText1.compoundIcon: "scrltext.xpm"
*scrolledWindowText1.compoundName: "scrolled_Text"
*scrolledWindowText1.x: 15
*scrolledWindowText1.y: 595
*scrolledWindowText1.borderWidth: 1
*scrolledWindowText1.width: 680
*scrolledWindowText1.height: 300
*scrolledWindowText1.allowResize: "true"

*scrolledText1.class: scrolledText
*scrolledText1.static: true
*scrolledText1.name: scrolledText1
*scrolledText1.parent: scrolledWindowText1
*scrolledText1.width: 680
*scrolledText1.height: 200
*scrolledText1.text: "xfix GUI: last update 09/04/99\n"
*scrolledText1.cursorPositionVisible: "false"
*scrolledText1.editable: "false"
*scrolledText1.scrollHorizontal: "true"
*scrolledText1.scrollVertical: "true"
*scrolledText1.resizeHeight: "true"
*scrolledText1.resizeWidth: "true"
*scrolledText1.editMode: "multi_line_edit"
*scrolledText1.rows: 24


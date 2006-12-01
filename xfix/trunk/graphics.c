void InitGraphics()
{
  XColor colour_def;
  XFontStruct *pFontInfo;
  XCharStruct *pCharStruct;
  Pixmap fixcursor, fixmask;
  int dir;

  unsigned short one=1;  
  
  depth = DefaultDepth (UxDisplay, UxScreen);
  visual = DefaultVisual (UxDisplay, UxScreen);
  cmap = DefaultColormap (UxDisplay, UxScreen);

/*
 * Get some read-only colours
 */
  if (!XAllocNamedColor (UxDisplay, cmap, "red", &red, &colour_def) ||
      !XAllocNamedColor (UxDisplay, cmap, "blue", &blue, &colour_def) ||
      !XAllocNamedColor (UxDisplay, cmap, "green", &green, &colour_def) ||
      !XAllocNamedColor (UxDisplay, cmap, "yellow", &yellow, &colour_def) ||
      !XAllocNamedColor (UxDisplay, cmap, "black", &black, &colour_def) ||
      !XAllocNamedColor (UxDisplay, cmap, "white", &white, &colour_def))
    {
      update_messages ("Don't know what red, blue, green, yellow, black or white are\n");
    }
/*
 * Set up some graphics contexts
 */
  paintGC = XCreateGC(UxDisplay, XtWindow (UxGetWidget (drawingArea1)), 0, NULL);
  textGC = XCreateGC(UxDisplay, XtWindow (UxGetWidget (drawingArea1)), 0, NULL);
  XSetForeground (UxDisplay, textGC, white.pixel);

  actionGC = XCreateGC(UxDisplay, XtWindow (UxGetWidget (drawingArea1)), 0, NULL);
  XSetFunction (UxDisplay, actionGC, GXxor);
  XSetForeground (UxDisplay, actionGC, 0xff);

  drawGC = XCreateGC(UxDisplay, XtWindow (UxGetWidget (drawingArea1)), 0, NULL);
  XSetLineAttributes (UxDisplay, drawGC, 1, LineSolid, CapButt, JoinMiter);
  XSetForeground (UxDisplay, drawGC, yellow.pixel);

  pointGC = XCreateGC(UxDisplay, XtWindow (UxGetWidget (drawingArea1)), 0, NULL);
  XSetForeground (UxDisplay, pointGC, green.pixel);
  XSetFillStyle (UxDisplay, pointGC, FillSolid);
/*
 * Create a region to describe drawingArea1
 */
  area1Region = XCreateRegion ();
/*
 * Set up point cursor from bitmap files
 */
  fixcursor = XCreatePixmapFromBitmapData (UxDisplay,
					   RootWindow (UxDisplay, UxScreen),
					   fixcursor_bits, 16, 16,
					   1, 0, 1);
  fixmask = XCreatePixmapFromBitmapData (UxDisplay, 
					 RootWindow (UxDisplay, UxScreen),
					 fixmask_bits, 16, 16,
					 1, 0, 1);
  
  if (!(cursorPoint = XCreatePixmapCursor (UxDisplay, fixcursor, fixmask, 
					   &black, &white, 7, 7)))
    update_messages ("Couldn't create cursor\n");
  
  XFreePixmap (UxDisplay, fixcursor);
  XFreePixmap (UxDisplay, fixmask);
  
  cursorBox = XCreateFontCursor (UxDisplay, XC_tcross);
  cursorPoly = XCreateFontCursor (UxDisplay, XC_dotbox);
  
  XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorPoint);
  XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea2)), cursorPoint);
  currentCursor = cursorPoint;
/*
 * Set up defaults
 */
  NColor = 128;
  magnification = 8;
  pointWidth = 2;
  interpolation = False;
  logarithmic = False;
  setMagnify = False;
  showPoints = True;
  currentImage = -1;
  totalImages = totalObjects = totalLines = totalScans = 0;
  pFirstObject = (FixObject *) NULL;
  pFirstLine = (FixLine *) NULL;
  pFirstScan = (FixScan *) NULL;
  pFirstDrawnCircle = (FixDrawnCircle *) NULL;
  pFirstDrawnCross = (FixDrawnCross *) NULL;
  pFirstDrawnPoint = (FixDrawnPoint *) NULL;
  pFirstDrawnRing = (FixDrawnRing *) NULL;

/* get screen info*/

  bitmap_pad = BitmapPad(UxDisplay);
  bits_per_pixel = sizeof(long)*8;
  server_order=ImageByteOrder(UxDisplay);
  client_order=(int)*((unsigned char*)&one)^1;

/*
 * Get font and size of marker area
 */
  if ((pFontInfo = XLoadQueryFont (UxDisplay, "8x13")) == NULL)
    {
      fprintf (stderr, "Error loading font\n");
    }
  XSetFont (UxDisplay, textGC, pFontInfo->fid);
  pCharStruct = (XCharStruct *) malloc (sizeof (XCharStruct));
  XQueryTextExtents (UxDisplay, pFontInfo->fid, " 00 ", 4, &dir, &fontAscent, 
		     &fontDescent, pCharStruct);
  fontWidth = pCharStruct->width;
  fontHeight = fontAscent + fontDescent;
		     
  free (pCharStruct);
  XFreeFont (UxDisplay, pFontInfo);
/*
 * Set default palette
 */		     
  GreyScale ();
}

FixImage *CreateFixImage (int x, int y, int ipix, int irast)
{
  int vbytes, cbytes, bytes_per_line, i, j, m;
  unsigned short width, height;
  float scaleX, scaleY;
  FixImage *pImage;

  if ((pImage = (FixImage *) malloc (sizeof (FixImage))))
    {
      if (x < 0)
	x = 0;
      else if (x > npix - 1)
	x = npix - 1;

      if (x + ipix > npix - 1)
	ipix = npix - x - 1;

      if (y < 0)
	y = 0;
      else if (y > nrast - 1)
	x = nrast - 1;

      if (y + irast > nrast - 1)
	irast = nrast - y - 1;

      pImage->x = x;
      pImage->y = y;
      pImage->ipix = ipix;
      pImage->irast = irast;
      pImage->magx = pImage->magy = 0;
      pImage->pixelValues = (unsigned char *) NULL;
      pImage->pixelColours = (unsigned long *) NULL;
      pImage->magnifyColours = (unsigned long *) NULL;

      if (interpolation)
	{
	  XtVaGetValues (UxGetWidget (scrolledWindow1), 
			 XmNwidth, &width, XmNheight, &height, NULL);
			 			 
	  scaleX = (float) ipix / (float) ((int) width - 18);
	  scaleY = (float) irast / (float) ((int) height - 18);
	  pImage->scale = MAX (scaleX, scaleY);
	  pImage->width = (int) ((float) ipix / pImage->scale);
	  pImage->height = (int) ((float) irast / pImage->scale);
	}
      else
	{
	  pImage->scale = 1.0;
	  pImage->width = ipix;
	  pImage->height = irast;
	}

      pImage->tmin = pImage->tmax = *(data + y * npix + x);
      for (j = y; j < y + irast; j++)
	{
	  m = j * npix;
	  for (i = x; i < x + ipix; i++)
	    {
	      if (*(data + m + i) < pImage->tmin) pImage->tmin = *(data + m + i);
	      if (*(data + m + i) > pImage->tmax) pImage->tmax = *(data + m + i);
	    }
	}

      vbytes = pImage->width * pImage->height * sizeof (unsigned char);
      cbytes = pImage->width * pImage->height * sizeof (unsigned long);

      if ((pImage->pixelValues = (unsigned char *) malloc (vbytes)) &&
	  (pImage->pixelColours = (unsigned long *) malloc (cbytes)) &&
	  (pImage->magnifyColours = (unsigned long *) malloc (MAGDIM * MAGDIM * 
							      sizeof (unsigned long))))
	{
	  bytes_per_line = pImage->width * sizeof (unsigned long);
	  pImage->pXimage1 = XCreateImage (UxDisplay, visual, depth, ZPixmap, (int) 0,
					   (char *) pImage->pixelColours,
					   pImage->width, pImage->height, bitmap_pad,
					   bytes_per_line);
	  pImage->pXimage1->bits_per_pixel = bits_per_pixel;
          pImage->pXimage1->byte_order=client_order;

#ifndef OSF
          if(!XInitImage(pImage->pXimage1))
            fprintf(stderr,"\nInconsistency in XImage - XInitImage failed\n");
#endif

	  bytes_per_line = MAGDIM * sizeof (unsigned long);
	  pImage->pXimage2 = XCreateImage (UxDisplay, visual, depth, ZPixmap, (int) 0,
					   (char *) pImage->magnifyColours,
					   (int) MAGDIM, (int) MAGDIM, bitmap_pad,
					   bytes_per_line);
	  pImage->pXimage2->bits_per_pixel = bits_per_pixel;
          pImage->pXimage1->byte_order=client_order;

#ifndef OSF
          if(!XInitImage(pImage->pXimage1))
            fprintf(stderr,"\nInconsistency in XImage - XInitImage failed\n");
#endif

	  if (logarithmic)
	    ScaleLog (pImage);
	  else
	    ScaleLinear (pImage);
	}
      else
	{
	  free (pImage->pixelValues);
	  free (pImage->pixelColours);
	  free (pImage->magnifyColours);
	  free (pImage);
	  pImage = (FixImage *) NULL;
	}
    }

  return (pImage);
}

FixObject *CreateFixObject (float *xv, float *yv, int nv, char *type)
{
  int i;
  FixObject *pObject;
  FixObject *pNew = (FixObject *) NULL;
  
  if (pNew = (FixObject *) malloc (sizeof (FixObject)))
    {
      pNew->number = totalObjects + 1;
      pNew->points = nv;
      pNew->selected = False;
      
      if ((pNew->type = (char *) strdup (type)) &&
	  (pNew->xv = (float *) malloc (sizeof (int) * nv)) &&
	  (pNew->yv = (float *) malloc (sizeof (int) * nv)))
	{
	  for (i = 0; i < nv; i++)
	    {
	      pNew->xv[i] = xv[i];
	      pNew->yv[i] = yv[i];
	    }
	}
      else
	{
	  return (FixObject *) NULL;
	}

      pNew->pNext = (FixObject *) NULL;

      if (pFirstObject)
	{
	  pObject = pFirstObject;

	  while (pObject->pNext)
	    pObject = pObject->pNext;

	  pObject->pNext = pNew;
	}
      else
	{
	  pFirstObject = pNew;
	}

      totalObjects++;
    }

  return (pNew);
}

void DestroyObject (FixObject *pObject)
{
  FixObject *pO;

  if (pObject)
    {
      if (pObject == pFirstObject)
	{
	  pFirstObject = pObject->pNext;
	}
      else
	{
	  pO = pFirstObject;
	  while (pO->pNext != pObject)
	    pO = pO->pNext;
	  
	  pO->pNext = pObject->pNext;
	}

      free (pObject->xv);
      free (pObject->yv);
      free (pObject->type);
      free (pObject);
    }
}

void DestroyAllObjects ()
{
  FixObject *pN, *pO = pFirstObject;

  while (pO)
    {
      pN = pO->pNext;
      free (pO->xv);
      free (pO->yv);
      free (pO->type);
      free (pO);
      pO = pN;
    }

  editDialog_deleteAllItems (objectD, &UxEnv);
  pFirstObject = (FixObject *) NULL;
  totalObjects = 0;
}      

void CentreObject (FixObject *pObject)
{
  int xmin = npix, xmax = 0, ymin = nrast, ymax = 0;
  int i, j, n, next, m;
  float xf, yf, xd, yd, d;
  double angsum, cross, dot;

  int nbak = 0, nval = 0;
  float bak = 0.0, avv = 0.0, xc = 0.0, yc = 0.0;
  double pi = 3.1415926536;

  if (pObject->points < 3)
    {
      pObject->xc = pObject->xv[0];
      pObject->yc = pObject->yv[0];
      return;
    }

  for (n = 1; n < pObject->points; n++)
    {
      if ((int) pObject->xv[n] < xmin) xmin = (int) pObject->xv[n];
      if ((int) pObject->yv[n] < ymin) ymin = (int) pObject->yv[n];
      if ((int) pObject->xv[n] > xmax) xmax = (int) pObject->xv[n];
      if ((int) pObject->yv[n] > ymax) ymax = (int) pObject->yv[n];
    }

  for (n = 0; n < pObject->points; n++)
    {
      if (n == pObject->points - 1)
	next = 0;
      else
	next = n + 1;

      xd = pObject->xv[next] - pObject->xv[n];
      yd = pObject->yv[next] - pObject->yv[n];
      d = sqrt (xd * xd + yd * yd);

      if (d > 0.0)      
	{
	  xd /= d;
	  yd /= d;
	  for (m = 0; m < (int) d; m++)
	    {
	      i = (int) (pObject->xv[n] + (float) m * xd);
	      j = (int) (pObject->yv[n] + (float) m * yd);

	      bak += *(data + j * npix + i);
	      nbak++;
	    }
	}
    }

  if (nbak > 0) bak /= (float) nbak;

  for (j = ymin; j <= ymax; j++)
    {
      m = j * npix + xmin;
      for (i = xmin; i <= xmax; i++)
	{
	  angsum = 0.0;
	  for (n = 0; n < pObject->points; n++)
	    {
	      if (n == pObject->points - 1)
		next = 0;
	      else
		next = n + 1;
	      
	      cross = (double) ((pObject->xv[n] - i - 0.5) * (pObject->yv[next] - j - 0.5) - 
				(pObject->yv[n] - j - 0.5) * (pObject->xv[next] - i - 0.5));

	      dot = (double) ((pObject->xv[n] - i - 0.5) * (pObject->xv[next] - i - 0.5) + 
			      (pObject->yv[n] - j - 0.5) * (pObject->yv[next] - j - 0.5));
		
	      if (fabs (cross) > 0.0)
		angsum += atan2 (cross, dot);
	    }

	  if (fabs (angsum) > pi)
	    {
	      nval++;
	      xc += ((float) i + 0.5) * (*(data + m) - bak);
	      yc += ((float) j + 0.5) * (*(data + m) - bak);
	      avv += *(data + m) - bak;
	    }
	     
	  m++;
	}
    }

  if (avv > 0.0)
    {
      xc /= avv;
      yc /= avv;
    }
  else
    {
      xc = yc = 0.0;
      for (n = 0; n < pObject->points; n++)
	{
	  xc += pObject->xv[n];
	  yc += pObject->yv[n];
	}
      xc /= (float) pObject->points;
      yc /= (float) pObject->points;
    }

  pObject->xc = xc;
  pObject->yc = yc;
}

void CentreSector (FixObject *pObject)
{
  double dx1, dx2, dy1, dy2, r1, r2, phi1, phi2, r, phi, dphi, delx[2], dely[2];
  double avv = 0.0, bak = 0.0, xcg = 0.0, ycg = 0.0;
  float x, y, dx, dy, temp, *dptr;
  int i, j, nr, nphi, ix, iy;
  int nbak = 0, nval = 0;

  dx1 = pObject->xv[1] - pObject->xv[0];
  dy1 = pObject->yv[0] - pObject->yv[1];
  dx2 = pObject->xv[2] - pObject->xv[0];
  dy2 = pObject->yv[0] - pObject->yv[2];
  r1 = hypot (dx1, dy1);
  r2 = hypot (dx2, dy2);
  phi1 = atan2 (dy1, dx1);
  phi2 = atan2 (dy2, dx2);
  if (phi2 < phi1)
    phi2 += 2.0 * M_PI;

  if (r2 > r1)
    {
      delx[0] = cos (phi1);
      dely[0] = -sin (phi1);
      delx[1] = cos (phi2);
      dely[1] = -sin (phi2);
    }
  else
    {
      delx[0] = -cos (phi1);
      dely[0] = sin (phi1);
      delx[1] = -cos (phi2);
      dely[1] = sin (phi2);
    }

  nr = (int) (fabs (r2 - r1) + 0.5);
  
  for (i = 0; i <= nr; i++)
    {
      for (j = 0; j < 2; j++)
	{
	  x = pObject->xv[j+1] + i * delx[j] - 0.5;
	  y = pObject->yv[j+1] + i * dely[j] - 0.5;
	  ix = (int) x;
	  iy = (int) y;
	  if (ix >= 0 && ix < npix && iy >= 0 && iy < nrast)
	    {
	      nbak++;
	      dptr = data + iy * npix + ix;
	      dx = x - (float) ix;
	      dy = y - (float) iy;
	      bak += (1.0 - dx) * (1.0 - dy) * *dptr;
	      if (ix < npix - 1)
		bak += dx         * (1.0 - dy) * *(dptr + 1);
	      if (iy < nrast - 1)
		bak += (1.0 - dx) * dy         * *(dptr + npix);
	      if (ix < npix - 1 && iy < nrast - 1)
		bak += dx         * dy         * *(dptr + npix + 1);
	    }
        }
    }

  dphi = 1/r1;
  nphi = (int) (r1 * (phi2 - phi1) + 0.5);
  
  for (i = 0; i <= nphi; i++)
    {
      phi = (double) i * dphi;
      x = pObject->xv[0] + r1 * cos (phi) - 0.5;
      y = pObject->yv[0] - r1 * sin (phi) - 0.5;
      ix = (int) x;
      iy = (int) y;
      if (ix >= 0 && ix < npix && iy >= 0 && iy < nrast)
	{
	  nbak++;
	  dptr = data + iy * npix + ix;
	  dx = x - (float) ix;
	  dy = y - (float) iy;
	  bak += (1.0 - dx) * (1.0 - dy) * *dptr;
	  if (ix < npix - 1)
	    bak += dx         * (1.0 - dy) * *(dptr + 1);
	  if (iy < nrast - 1)
	    bak += (1.0 - dx) * dy         * *(dptr + npix);
	  if (ix < npix - 1 && iy < nrast - 1)
	    bak += dx         * dy         * *(dptr + npix + 1);
	}
    }

  dphi = 1/r2;
  nphi = (int) (r2 * (phi2 - phi1) + 0.5);
  
  for (i = 0; i <= nphi; i++)
    {
      phi = (double) i * dphi;
      x = pObject->xv[0] + r2 * cos (phi) - 0.5;
      y = pObject->yv[0] - r2 * sin (phi) - 0.5;
      ix = (int) x;
      iy = (int) y;
      if (ix >= 0 && ix < npix && iy >= 0 && iy < nrast)
	{
	  nbak++;
	  dptr = data + iy * npix + ix;
	  dx = x - (float) ix;
	  dy = y - (float) iy;
	  bak += (1.0 - dx) * (1.0 - dy) * *dptr;
	  if (ix < npix - 1)
	    bak += dx         * (1.0 - dy) * *(dptr + 1);
	  if (iy < nrast - 1)
	    bak += (1.0 - dx) * dy         * *(dptr + npix);
	  if (ix < npix - 1 && iy < nrast - 1)
	    bak += dx         * dy         * *(dptr + npix + 1);
	}
    }

  if (nbak > 0)
    bak = bak / (double) nbak;
  
  for (i = 1; i < nr; i++)
    {
      r = r1 + copysign ((double) i, r2 - r1);
      dphi = 1/r;
      nphi = (int) (r * (phi2 - phi1) + 0.5);
      for (j = 1; j < nphi; j++)
	{
	  phi = phi1 + (double) j * dphi;
	  x = pObject->xv[0] + r * cos (phi) - 0.5;
	  y = pObject->yv[0] - r * sin (phi) - 0.5;
	  ix = (int) x;
	  iy = (int) y;
	  if (ix >= 0 && ix < npix && iy >= 0 && iy < nrast)
	    {
	      nbak++;
	      dptr = data + iy * npix + ix;
	      dx = x - (float) ix;
	      dy = y - (float) iy;
	      temp = (1.0 - dx) * (1.0 - dy) * *dptr;
	      if (ix < npix - 1)
		temp += dx         * (1.0 - dy) * *(dptr + 1);
	      if (iy < nrast - 1)
		temp += (1.0 - dx) * dy         * *(dptr + npix);
	      if (ix < npix - 1 && iy < nrast - 1)
		temp += dx         * dy         * *(dptr + npix + 1);

	      temp -= bak;
	      xcg += (x + 0.5) * temp;
	      ycg += (y + 0.5) * temp;
	      avv += temp;
	    }
	}
    }
  
  if (fabs (avv) > 0.0)
    {
      xcg /= avv;
      ycg /= avv;
    }
  else
    {
      phi = (phi2 + phi1) / 2.0;
      dphi = (phi2 - phi1) / 2.0;
      r = fabs (2.0 * sin (dphi) * (r2 * r2 * r2 - r1 * r1 * r1) / 
		(3.0 * dphi * (r2 * r2 - r1 * r1)));
      xcg = pObject->xv[0] + r * cos (phi);
      ycg = pObject->yv[0] - r * sin (phi);
    }

  pObject->xc = (float) xcg;
  pObject->yc = (float) ycg;
}

int CreateObjectItem (FixObject *pObject)
{
  sprintf (textBuf, " %3d     %6.1f     %6.1f         %-10s    %3d", 
	   pObject->number, pObject->xc, pObject->yc, pObject->type, pObject->points);
  
  return (editDialog_addItem (objectD, &UxEnv, textBuf));
}

void DestroyObjectPos (int position)
{
  FixObject *pObject, *pO = pFirstObject;
  int count = 1;

  if (position > totalObjects)
    return;

  if (pO)
    {
      if (position == 1)
	{
	  pObject = pFirstObject;
	  pFirstObject = pO->pNext;
	}
      else
	{
	  while (count < position - 1)
	    {
	      count++;
	      pO = pO->pNext;
	    }
	  
	  pObject = pO->pNext;
	  pO->pNext = pObject->pNext;
	}

      free (pObject->xv);
      free (pObject->yv);
      free (pObject->type);
      free (pObject);
    }
}

void MarkObjects (int n1, int n2, int select)
{
  MarkObjectsOnDrawable (n1, n2, select, XtWindow (UxGetWidget (drawingArea1)));
}

void MarkObjectsOnDrawable (int n1, int n2, int select, Drawable d)
{
  FixObject *pObject = pFirstObject;
  int count = 0;
  int x, y, len;

  if (n2 < n1)
    return;

  while (pObject)
    {
      count++;
      if (count >= n1 && count <= n2)
	{
	  if (select > 0) pObject->selected = True;
	  if (select < 0) pObject->selected = False;

	  FileToImageCoords (pObject->xc, pObject->yc, xi[currentImage], &x, &y);
	  sprintf (textBuf, " %d ", pObject->number);
	  len = strlen (textBuf);

	  if (pObject->selected)
	    XSetBackground (UxDisplay, textGC, red.pixel);
	  else
	    XSetBackground (UxDisplay, textGC, black.pixel);
	    
	  XDrawImageString (UxDisplay, d, textGC, 
			    x - fontWidth, 
			    y - fontAscent,
			    textBuf, len);
	}
      pObject = pObject->pNext;
    }

  XSetBackground (UxDisplay, textGC, black.pixel);
}
	  
void DrawObjects ()
{
  DrawObjectsOnDrawable (XtWindow (UxGetWidget (drawingArea1)));
}

void DrawObjectsOnDrawable (Drawable d)
{
  FixObject *pObject = pFirstObject;
  int x, y;

  while (pObject)
    {
      FileToImageCoords (pObject->xc, pObject->yc, xi[currentImage], &x, &y);
      DrawPlus (UxDisplay, d, drawGC, &x, &y, 1, 4);
      pObject = pObject->pNext;
    }
}

void RepaintOverObjectMarkers ()
{
  Region redrawRegion = XCreateRegion ();
  Region drawRegion = XCreateRegion ();
  FixObject *pObject = pFirstObject;
  XRectangle rect;
  int x, y;

  if (pObject == NULL)
    return;

  while (pObject)
    {
      FileToImageCoords (pObject->xc, pObject->yc, xi[currentImage], &x, &y);
      rect.x = (short) x - fontWidth;
      rect.y = (short) y - 2 * fontAscent;
      rect.width = (unsigned short) fontWidth;
      rect.height = (unsigned short) fontHeight;
      if (rect.x < xi[currentImage]->width && rect.y < xi[currentImage]->height && 
	 (int) (rect.x + rect.width) >= 0 && (int) (rect.y + rect.height) >= 0)  
	{
	  XUnionRectWithRegion (&rect, drawRegion, drawRegion);
	}
      pObject = pObject->pNext;
    }

  XIntersectRegion (drawRegion, area1Region, redrawRegion);
  XDestroyRegion (drawRegion);

  XSetRegion (UxDisplay, paintGC, redrawRegion);
  XClipBox (redrawRegion, &rect);
  XPutImage (UxDisplay, XtWindow (drawingArea1), paintGC, xi[currentImage]->pXimage1, 
	     (int) rect.x, (int) rect.y, (int) rect.x, (int) rect.y, 
	     (unsigned int) rect.width, (unsigned int) rect.height);
  XSetClipMask (UxDisplay, paintGC, None);

  XSetRegion (UxDisplay, drawGC, redrawRegion);
  DrawObjects ();
  DrawLines ();
  DrawScans ();
  DrawDrawnCircles (XtWindow (UxGetWidget (drawingArea1)));
  DrawDrawnCrosses (XtWindow (UxGetWidget (drawingArea1)));
  XSetClipMask (UxDisplay, drawGC, None);

  XSetRegion (UxDisplay, textGC, redrawRegion);
  MarkLines (1, editDialog_itemCount (lineD, &UxEnv), 0);
  MarkScans (1, editDialog_itemCount (scanD, &UxEnv), 0);
  XSetClipMask (UxDisplay, textGC, None);

  if (showPoints)
    {
      XSetRegion (UxDisplay, pointGC, redrawRegion);
      DrawDrawnPoints (XtWindow (UxGetWidget (drawingArea1)));
      DrawDrawnRings (XtWindow (UxGetWidget (drawingArea1)));
      XSetClipMask (UxDisplay, pointGC, None);
    }

  XDestroyRegion (redrawRegion);
  XFlush (UxDisplay);
}

void renumberObjects ()
{
  FixObject *pObject = pFirstObject;
  int i = 0;

  while (pObject)
    {
      pObject->number = ++i;
      sprintf (textBuf, " %3d     %6.1f     %6.1f         %-10s    %3d", 
	       pObject->number, pObject->xc, pObject->yc, pObject->type, pObject->points);
      
      editDialog_modifyItemPos (objectD, &UxEnv, pObject->number, textBuf);
      
      pObject = pObject->pNext;
    }
  
  totalObjects = i;
}
  
void ListSelectedItems (Widget wgt)
{
  int i, number, *list;

  if (editDialog_getSelPos (wgt, &UxEnv, &list, &number))
    {
      for (i = 0; i < number; i++)
	{
	  command ("%d ", list[i]);
	}
      command ("\n");
      free (list);
    }
  else
    {
      command ("\n");
    }
}

void ListRangesOfSelectedItems (Widget wgt)
{
  int i, number, *list;
  Boolean start = True, end = False;

  if (editDialog_getSelPos (wgt, &UxEnv, &list, &number))
    { 
      for (i = 0; i < number; i++)
	{
	  if (i < number - 1)
	    {
	      if (list[i+1] != list[i] + 1)
		{
		  end = True;
		}
	    }
	  else
	    {
	      end = True;
	    }
	  
	  if (start) 
	    {
	      command ("%d ", list[i]);
	      start = False;
	    }

	  if (end) 
	    {
	      command ("%d  ", list[i]);
	      start = True;
	      end = False;
	    }
	}
      command ("\n");
      free (list);
    }
  else
    {
      command ("1 %d\n", editDialog_itemCount (wgt, &UxEnv));
    }
}

FixLine *CreateFixLine (float xs, float ys, float xe, float ye, float w)
{
  FixLine *pLine;
  FixLine *pNew = (FixLine *) NULL;
  
  if (pNew = (FixLine *) malloc (sizeof (FixLine)))
    {
      pNew->number = totalLines + 1;
      pNew->xStart = xs;
      pNew->yStart = ys;
      pNew->xEnd = xe;
      pNew->yEnd = ye;
      pNew->width = w;
      pNew->selected = False;
      pNew->pNext = (FixLine *) NULL;

      if (pFirstLine)
	{
	  pLine = pFirstLine;

	  while (pLine->pNext)
	    pLine = pLine->pNext;

	  pLine->pNext = pNew;
	}
      else
	{
	  pFirstLine = pNew;
	}

      totalLines++;
    }

  return (pNew);
}

void DestroyLine (FixLine *pLine)
{
  FixLine *pL;

  if (pLine)
    {
      if (pLine == pFirstLine)
	{
	  pFirstLine = pLine->pNext;
	}
      else
	{
	  pL = pFirstLine;
	  while (pL->pNext != pLine)
	    pL = pL->pNext;
	  
	  pL->pNext = pLine->pNext;
	}
      
      free (pLine);
    }
}

void DestroyAllLines ()
{
  FixLine *pN, *pL = pFirstLine;

  while (pL)
    {
      pN = pL->pNext;
      free (pL);
      pL = pN;
    }
  
  editDialog_deleteAllItems (lineD, &UxEnv);
  pFirstLine = (FixLine *) NULL;
  totalLines = 0;
}

int CreateLineItem (FixLine *pLine)
{
  sprintf (textBuf, 
	   " %3d     %6.1f     %6.1f     %6.1f     %6.1f     %6.1f", 
	   pLine->number, pLine->xStart, pLine->yStart, pLine->xEnd, pLine->yEnd, pLine->width);
  
  return (editDialog_addItem (lineD, &UxEnv, textBuf));
}

void DestroyLinePos (int position)
{
  FixLine *pLine, *pL = pFirstLine;
  int count = 1;

  if (position > totalLines)
    return;

  if (pL)
    {
      if (position == 1)
	{
	  pLine = pFirstLine;
	  pFirstLine = pL->pNext;
	}
      else
	{
	  while (count < position - 1)
	    {
	      count++;
	      pL = pL->pNext;
	    }
	  
	  pLine = pL->pNext;
	  pL->pNext = pLine->pNext;
	}

      free (pLine);
    }
}

void MarkLines (int n1, int n2, int select)
{
  MarkLinesOnDrawable (n1, n2, select, XtWindow (UxGetWidget (drawingArea1)));
}

void MarkLinesOnDrawable (int n1, int n2, int select, Drawable dr)

{
  FixLine *pLine = pFirstLine;
  int count = 0;
  int x, y, len, xm, ym;
  float xd, yd, d;

  if (n2 < n1)
    return;

  while (pLine)
    {
      count++;
      if (count >= n1 && count <= n2)
	{
	  if (select > 0) pLine->selected = True;
	  if (select < 0) pLine->selected = False;

	  FileToImageCoords (pLine->xStart, pLine->yStart,
			     xi[currentImage], &x, &y);
	  sprintf (textBuf, " %d ", pLine->number);
	  len = strlen (textBuf);

	  xd = (float) (pLine->xEnd - pLine->xStart);
	  yd = (float) (pLine->yEnd - pLine->yStart);

	  d = sqrt (xd * xd + yd * yd);
	  xd /= d;
	  yd /= d;

	  xm = x - (int) (fontWidth * xd) - fontWidth / 2;
	  ym = y - (int) (fontHeight * yd) + fontAscent;

	  if (pLine->selected)
	    XSetBackground (UxDisplay, textGC, green.pixel);
	  else
	    XSetBackground (UxDisplay, textGC, blue.pixel);
	    
	  XDrawImageString (UxDisplay, dr, textGC, xm, ym,
			    textBuf, len);
	}
      pLine = pLine->pNext;
    }

  XSetBackground (UxDisplay, textGC, black.pixel);
}
	  
void DrawLines ()
{
  DrawLinesOnDrawable (XtWindow (UxGetWidget (drawingArea1)));
}

void DrawLinesOnDrawable (Drawable d)
{
  FixLine *pLine = pFirstLine;
  int x1, y1, x2, y2, w;

  while (pLine)
    {
      FileToImageCoords (pLine->xStart, pLine->yStart, xi[currentImage], &x1, &y1);
      FileToImageCoords (pLine->xEnd, pLine->yEnd, xi[currentImage], &x2, &y2);
      w = (int) (pLine->width / xi[currentImage]->scale + 0.5);
      DrawLine (UxDisplay, d, drawGC, x1, y1, x2, y2, w);
      pLine = pLine->pNext;
    }
}

void RepaintOverLineMarkers ()
{
  Region redrawRegion = XCreateRegion ();
  Region drawRegion = XCreateRegion ();
  FixLine *pLine = pFirstLine;
  XRectangle rect;
  int x, y;
  float xd, yd, d;

  if (pLine == NULL)
    return;

  while (pLine)
    {
      FileToImageCoords (pLine->xStart, pLine->yStart, 
			 xi[currentImage], &x, &y);

      xd = (float) (pLine->xEnd - pLine->xStart);
      yd = (float) (pLine->yEnd - pLine->yStart);
      
      d = sqrt (xd * xd + yd * yd);
      xd /= d;
      yd /= d;
      
      rect.x = (short) (x - (int) (fontWidth * xd) - fontWidth / 2);
      rect.y = (short) (y - (int) (fontHeight * yd));
      rect.width = (unsigned short) fontWidth;
      rect.height = (unsigned short) fontHeight;
      if (rect.x < xi[currentImage]->width && rect.y < xi[currentImage]->height && 
	 (int) (rect.x + rect.width) >= 0 && (int) (rect.y + rect.height) >= 0)  
	{
	  XUnionRectWithRegion (&rect, drawRegion, drawRegion);
	}
      pLine = pLine->pNext;
    }

  XIntersectRegion (drawRegion, area1Region, redrawRegion);
  XDestroyRegion (drawRegion);

  XSetRegion (UxDisplay, paintGC, redrawRegion);
  XClipBox (redrawRegion, &rect);
  XPutImage (UxDisplay, XtWindow (drawingArea1), paintGC, xi[currentImage]->pXimage1, 
	     (int) rect.x, (int) rect.y, (int) rect.x, (int) rect.y, 
	     (unsigned int) rect.width, (unsigned int) rect.height);
  XSetClipMask (UxDisplay, paintGC, None);

  XSetRegion (UxDisplay, drawGC, redrawRegion);
  DrawObjects ();
  DrawLines ();
  DrawScans ();
  DrawDrawnCircles (XtWindow (UxGetWidget (drawingArea1)));
  DrawDrawnCrosses (XtWindow (UxGetWidget (drawingArea1)));
  XSetClipMask (UxDisplay, drawGC, None);

  XSetRegion (UxDisplay, textGC, redrawRegion);
  MarkObjects (1, editDialog_itemCount (objectD, &UxEnv), 0);
  MarkScans (1, editDialog_itemCount (scanD, &UxEnv), 0);
  XSetClipMask (UxDisplay, textGC, None);
  
  if (showPoints)
    {
      XSetRegion (UxDisplay, pointGC, redrawRegion);
      DrawDrawnPoints (XtWindow (UxGetWidget (drawingArea1)));
      DrawDrawnRings (XtWindow (UxGetWidget (drawingArea1)));
      XSetClipMask (UxDisplay, pointGC, None);
    }

  XDestroyRegion (redrawRegion);
  XFlush (UxDisplay);
}

void renumberLines ()
{
  FixLine *pLine = pFirstLine;
  int i = 0;

  while (pLine)
    {
      pLine->number = ++i;
      sprintf (textBuf, 
	       " %3d     %6.1f     %6.1f     %6.1f     %6.1f     %6.1f", 
	       pLine->number, pLine->xStart, pLine->yStart, pLine->xEnd, pLine->yEnd, 
	       pLine->width);
      
      editDialog_modifyItemPos (lineD, &UxEnv, pLine->number, textBuf);

      pLine = pLine->pNext;
    }

  totalLines = i;
}
  
FixScan *CreateFixScan (float *xs, float *ys)
{
  FixScan *pScan;
  FixScan *pNew = (FixScan *) NULL;
  
  if (pNew = (FixScan *) malloc (sizeof (FixScan)))
    {
      pNew->number = totalScans + 1;
      pNew->xCentre = xs[0];
      pNew->yCentre = ys[0];
      pNew->xStart = xs[1];
      pNew->yStart = ys[1];
      pNew->xEnd = xs[2];
      pNew->yEnd = ys[2];
      pNew->selected = False;
      pNew->pNext = (FixScan *) NULL;

      if (pFirstScan)
	{
	  pScan = pFirstScan;

	  while (pScan->pNext)
	    pScan = pScan->pNext;

	  pScan->pNext = pNew;
	}
      else
	{
	  pFirstScan = pNew;
	}

      totalScans++;
    }

  return (pNew);
}

void DestroyScan (FixScan *pScan)
{
  FixScan *pS;

  if (pScan)
    {
      if (pScan == pFirstScan)
	{
	  pFirstScan = pScan->pNext;
	}
      else
	{
	  pS = pFirstScan;
	  while (pS->pNext != pScan)
	    pS = pS->pNext;
	  
	  pS->pNext = pScan->pNext;
	}
      
      free (pScan);
    }
}

void DestroyAllScans ()
{
  FixScan *pN, *pS = pFirstScan;

  while (pS)
    {
      pN = pS->pNext;
      free (pS);
      pS = pN;
    }
  
  editDialog_deleteAllItems (scanD, &UxEnv);
  pFirstScan = (FixScan *) NULL;
  totalScans = 0;
}

int CreateScanItem (FixScan *pScan)
{
  static double rtod = 57.295779513;
  double dx1, dy1, dx2, dy2, r1, r2, radius, width, phi1, phi2;

  dx1 = (double) (pScan->xStart - pScan->xCentre);
  dy1 = (double) (pScan->yCentre - pScan->yStart); 
  dx2 = (double) (pScan->xEnd - pScan->xCentre);
  dy2 = (double) (pScan->yCentre - pScan->yEnd); 

  r1 = hypot (dx1, dy1);
  r2 = hypot (dx2, dy2);
  radius = (r1 + r2) / 2.0;
  width = fabs (r2 - r1) / 2.0;

  phi1 = rtod * atan2 (dy1, dx1);
  phi2 = rtod * atan2 (dy2, dx2);
  if (phi2 < phi1)
    phi2 += 360.0;

  sprintf (textBuf, 
	   " %3d     %6.1f     %6.1f     %6.1f     %6.1f     %6.1f     %6.1f", 
	   pScan->number, pScan->xCentre, pScan->yCentre, radius, width, phi1, phi2);
  
  return (editDialog_addItem (scanD, &UxEnv, textBuf));
}

void DestroyScanPos (int position)
{
  FixScan *pScan, *pS = pFirstScan;
  int count = 1;

  if (position > totalScans)
    return;

  if (pS)
    {
      if (position == 1)
	{
	  pScan = pFirstScan;
	  pFirstScan = pS->pNext;
	}
      else
	{
	  while (count < position - 1)
	    {
	      count++;
	      pS = pS->pNext;
	    }
	  
	  pScan = pS->pNext;
	  pS->pNext = pScan->pNext;
	}

      free (pScan);
    }
}

void MarkScans (int n1, int n2, int select)
{
  MarkScansOnDrawable (n1, n2, select, XtWindow (UxGetWidget (drawingArea1)));
}

void MarkScansOnDrawable (int n1, int n2, int select, Drawable d)
{
  FixScan *pScan = pFirstScan;
  int count = 0;
  int x, y, len, xm, ym;
  double dx, dy, r, phi, xp, yp;
  float mx, my;

  if (n2 < n1)
    return;

  while (pScan)
    {
      count++;
      if (count >= n1 && count <= n2)
	{
	  if (select > 0) pScan->selected = True;
	  if (select < 0) pScan->selected = False;

	  sprintf (textBuf, " %d ", pScan->number);
	  len = strlen (textBuf);

	  dx = (double) (pScan->xEnd - pScan->xCentre);
	  dy = (double) (pScan->yCentre - pScan->yEnd);
	  r = hypot (dx, dy);

	  dx = (double) (pScan->xStart - pScan->xCentre);
	  dy = (double) (pScan->yCentre - pScan->yStart);
	  phi = atan2 (dy, dx);

	  xp = cos (phi);
	  yp = sin (phi);

	  mx = (float) ((double) pScan->xCentre + (r * xp + dx) / 2.0);
	  my = (float) ((double) pScan->yCentre - (r * yp + dy) / 2.0);
	  
	  FileToImageCoords (mx, my, xi[currentImage], &x, &y);

	  xm = x + (int) (fontWidth * yp) - fontWidth / 2;
	  ym = y + (int) (fontHeight * xp) + fontAscent;

	  if (pScan->selected)
	    XSetBackground (UxDisplay, textGC, green.pixel);
	  else
	    XSetBackground (UxDisplay, textGC, blue.pixel);
	    
	  XDrawImageString (UxDisplay, d, textGC, xm, ym,
			    textBuf, len);
	}
      pScan = pScan->pNext;
    }

  XSetBackground (UxDisplay, textGC, black.pixel);
}
	  
void DrawScans ()
{
  DrawScansOnDrawable (XtWindow (UxGetWidget (drawingArea1)));
}

void DrawScansOnDrawable (Drawable d)
{
  FixScan *pScan = pFirstScan;
  int x1, y1, x2, y2, xc, yc;

  while (pScan)
    {
      FileToImageCoords (pScan->xCentre, pScan->yCentre, xi[currentImage], &xc, &yc);
      FileToImageCoords (pScan->xStart, pScan->yStart, xi[currentImage], &x1, &y1);
      FileToImageCoords (pScan->xEnd, pScan->yEnd, xi[currentImage], &x2, &y2);
      DrawSector (UxDisplay, d, drawGC, xc, yc, x1, y1, x2, y2);
      pScan = pScan->pNext;
    }
}

void RepaintOverScanMarkers ()
{
  Region redrawRegion = XCreateRegion ();
  Region drawRegion = XCreateRegion ();
  FixScan *pScan = pFirstScan;
  XRectangle rect;
  int x, y, xm, ym;
  double dx, dy, r, phi, xp, yp;
  float mx, my;

  if (pScan == NULL)
    return;

  while (pScan)
    {
      dx = (double) (pScan->xEnd - pScan->xCentre);
      dy = (double) (pScan->yCentre - pScan->yEnd);
      r = hypot (dx, dy);
      
      dx = (double) (pScan->xStart - pScan->xCentre);
      dy = (double) (pScan->yCentre - pScan->yStart);
      phi = atan2 (dy, dx);
      
      xp = cos (phi);
      yp = sin (phi);
      
      mx = (float) ((double) pScan->xCentre + (r * xp + dx) / 2.0);
      my = (float) ((double) pScan->yCentre - (r * yp + dy) / 2.0);
      
      FileToImageCoords (mx, my, xi[currentImage], &x, &y);
      
      xm = x + (int) (fontWidth * yp) - fontWidth / 2;
      ym = y + (int) (fontHeight * xp) + fontAscent;

      rect.x = (short) xm;
      rect.y = (short) (ym - fontAscent);
      rect.width = (unsigned short) fontWidth;
      rect.height = (unsigned short) fontHeight;
      if (rect.x < xi[currentImage]->width && rect.y < xi[currentImage]->height && 
	 (int) (rect.x + rect.width) >= 0 && (int) (rect.y + rect.height) >= 0)  
	{
	  XUnionRectWithRegion (&rect, drawRegion, drawRegion);
	}
      pScan = pScan->pNext;
    }

  XIntersectRegion (drawRegion, area1Region, redrawRegion);
  XDestroyRegion (drawRegion);

  XSetRegion (UxDisplay, paintGC, redrawRegion);
  XClipBox (redrawRegion, &rect);
  XPutImage (UxDisplay, XtWindow (drawingArea1), paintGC, xi[currentImage]->pXimage1, 
	     (int) rect.x, (int) rect.y, (int) rect.x, (int) rect.y, 
	     (unsigned int) rect.width, (unsigned int) rect.height);
  XSetClipMask (UxDisplay, paintGC, None);

  XSetRegion (UxDisplay, drawGC, redrawRegion);
  DrawObjects ();
  DrawLines ();
  DrawScans ();
  DrawDrawnCircles (XtWindow (UxGetWidget (drawingArea1)));
  DrawDrawnCrosses (XtWindow (UxGetWidget (drawingArea1)));
  XSetClipMask (UxDisplay, drawGC, None);

  XSetRegion (UxDisplay, textGC, redrawRegion);
  MarkObjects (1, editDialog_itemCount (objectD, &UxEnv), 0);
  MarkLines (1, editDialog_itemCount (lineD, &UxEnv), 0);
  XSetClipMask (UxDisplay, textGC, None);
  
  if (showPoints)
    {
      XSetRegion (UxDisplay, pointGC, redrawRegion);
      DrawDrawnPoints (XtWindow (UxGetWidget (drawingArea1)));
      DrawDrawnRings (XtWindow (UxGetWidget (drawingArea1)));
      XSetClipMask (UxDisplay, pointGC, None);
    }

  XDestroyRegion (redrawRegion);
  XFlush (UxDisplay);
}

void renumberScans ()
{
  FixScan *pScan = pFirstScan;
  int i = 0;
  static double rtod = 57.295779513;
  double dx1, dy1, dx2, dy2, r1, r2, radius, width, phi1, phi2;

  while (pScan)
    {
      pScan->number = ++i;

      dx1 = (double) (pScan->xStart - pScan->xCentre);
      dy1 = (double) (pScan->yCentre - pScan->yStart); 
      dx2 = (double) (pScan->xEnd - pScan->xCentre);
      dy2 = (double) (pScan->yCentre - pScan->yEnd); 

      r1 = hypot (dx1, dy1);
      r2 = hypot (dx2, dy2);
      radius = (r1 + r2) / 2.0;
      width = fabs (r2 - r1) / 2.0;

      phi1 = rtod * atan2 (dy1, dx1);
      phi2 = rtod * atan2 (dy2, dx2);
      if (phi2 < phi1)
	phi2 += 360.0;

      sprintf (textBuf, 
	       " %3d     %6.1f     %6.1f     %6.1f     %6.1f     %6.1f     %6.1f", 
	       pScan->number, pScan->xCentre, pScan->yCentre, radius, width, phi1, phi2);

      editDialog_modifyItemPos (scanD, &UxEnv, pScan->number, textBuf);
      
      pScan = pScan->pNext;
    }

  totalScans = i;
}

FixDrawnCircle *CreateFixDrawnCircle (float x, float y, float r)
{
  FixDrawnCircle *pCircle;
  FixDrawnCircle *pNew = (FixDrawnCircle *) NULL;
  
  if (pNew = (FixDrawnCircle *) malloc (sizeof (FixDrawnCircle)))
    {
      pNew->xCentre = x;
      pNew->yCentre = y;
      pNew->radius = r;
      pNew->pNext = (FixDrawnCircle *) NULL;

      if (pFirstDrawnCircle)
	{
	  pCircle = pFirstDrawnCircle;

	  while (pCircle->pNext)
	    pCircle = pCircle->pNext;

	  pCircle->pNext = pNew;
	}
      else
	{
	  pFirstDrawnCircle = pNew;
	}
    }

  return (pNew);
}

void DestroyDrawnCircles ()
{
  FixDrawnCircle *pN, *pC = pFirstDrawnCircle;

  while (pC)
    {
      pN = pC->pNext;
      free (pC);
      pC = pN;
    }
  
  pFirstDrawnCircle = (FixDrawnCircle *) NULL;
}

void DrawDrawnCircles (Drawable d)
{
  FixDrawnCircle *pCircle = pFirstDrawnCircle;

  while (pCircle)
    {
      FixDrawCircle (pCircle->xCentre, pCircle->yCentre, pCircle->radius, d);
      pCircle = pCircle->pNext;
    }
}

FixDrawnCross *CreateFixDrawnCross (float x, float y)
{
  FixDrawnCross *pCross;
  FixDrawnCross *pNew = (FixDrawnCross *) NULL;
  
  if (pNew = (FixDrawnCross *) malloc (sizeof (FixDrawnCross)))
    {
      pNew->xCentre = x;
      pNew->yCentre = y;
      pNew->pNext = (FixDrawnCross *) NULL;

      if (pFirstDrawnCross)
	{
	  pCross = pFirstDrawnCross;

	  while (pCross->pNext)
	    pCross = pCross->pNext;

	  pCross->pNext = pNew;
	}
      else
	{
	  pFirstDrawnCross = pNew;
	}
    }

  return (pNew);
}

void DestroyDrawnCrosses ()
{
  FixDrawnCross *pN, *pC = pFirstDrawnCross;

  while (pC)
    {
      pN = pC->pNext;
      free (pC);
      pC = pN;
    }
  
  pFirstDrawnCross = (FixDrawnCross *) NULL;
}

void DrawDrawnCrosses (Drawable d)
{
  FixDrawnCross *pCross = pFirstDrawnCross;

  while (pCross)
    {
      FixDrawCross (pCross->xCentre, pCross->yCentre, d);
      pCross = pCross->pNext;
    }
}

FixDrawnPoint *CreateFixDrawnPoint (float x, float y)
{
  FixDrawnPoint *pPoint;
  FixDrawnPoint *pNew = (FixDrawnPoint *) NULL;
  
  if (pNew = (FixDrawnPoint *) malloc (sizeof (FixDrawnPoint)))
    {
      pNew->xCentre = x;
      pNew->yCentre = y;
      pNew->pNext = (FixDrawnPoint *) NULL;

      if (pFirstDrawnPoint)
	{
	  pPoint = pFirstDrawnPoint;

	  while (pPoint->pNext)
	    pPoint = pPoint->pNext;

	  pPoint->pNext = pNew;
	}
      else
	{
	  pFirstDrawnPoint = pNew;
	}
    }

  return (pNew);
}

void DestroyDrawnPoints ()
{
  FixDrawnPoint *pN, *pP = pFirstDrawnPoint;

  while (pP)
    {
      pN = pP->pNext;
      free (pP);
      pP = pN;
    }
  
  pFirstDrawnPoint = (FixDrawnPoint *) NULL;
}

void DrawDrawnPoints (Drawable d)
{
  FixDrawnPoint *pPoint = pFirstDrawnPoint;

  while (pPoint)
    {
      FixDrawPoint (pPoint->xCentre, pPoint->yCentre, d);
      pPoint = pPoint->pNext;
    }
}

void RepaintOverDrawnPoints ()
{
  Region redrawRegion = XCreateRegion ();
  Region drawRegion = XCreateRegion ();
  FixDrawnPoint *pPoint = pFirstDrawnPoint;
  XRectangle rect;
  int x, y;

  if (pPoint == NULL)
    return;

  while (pPoint)
    {
      FileToImageCoords (pPoint->xCentre, pPoint->yCentre, xi[currentImage], &x, &y);
      rect.x = (short) (x - pointWidth); 
      rect.y = (short) (y - pointWidth);
      rect.width = (unsigned short) (2 * pointWidth);
      rect.height = (unsigned short) (2 * pointWidth);
      if (rect.x < xi[currentImage]->width && rect.y < xi[currentImage]->height && 
	 (int) (rect.x + rect.width) >= 0 && (int) (rect.y + rect.height) >= 0)  
	{
	  XUnionRectWithRegion (&rect, drawRegion, drawRegion);
	}
      pPoint = pPoint->pNext;
    }

  XIntersectRegion (drawRegion, area1Region, redrawRegion);
  XDestroyRegion (drawRegion);

  XSetRegion (UxDisplay, paintGC, redrawRegion);
  XClipBox (redrawRegion, &rect);
  XPutImage (UxDisplay, XtWindow (drawingArea1), paintGC, xi[currentImage]->pXimage1, 
	     (int) rect.x, (int) rect.y, (int) rect.x, (int) rect.y, 
	     (unsigned int) rect.width, (unsigned int) rect.height);
  XSetClipMask (UxDisplay, paintGC, None);

  XSetRegion (UxDisplay, drawGC, redrawRegion);
  DrawObjects ();
  DrawLines ();
  DrawScans ();
  DrawDrawnCircles (XtWindow (UxGetWidget (drawingArea1)));
  DrawDrawnCrosses (XtWindow (UxGetWidget (drawingArea1)));
  XSetClipMask (UxDisplay, drawGC, None);

  XSetRegion (UxDisplay, textGC, redrawRegion);
  MarkObjects (1, editDialog_itemCount (objectD, &UxEnv), 0);
  MarkLines (1, editDialog_itemCount (lineD, &UxEnv), 0);
  MarkScans (1, editDialog_itemCount (scanD, &UxEnv), 0);
  XSetClipMask (UxDisplay, textGC, None);

  XDestroyRegion (redrawRegion);
  XFlush (UxDisplay);
}

/* starting ring stuff */

FixDrawnRing *CreateFixDrawnRing (float x, float y, float r)
{
  FixDrawnRing *pRing;
  FixDrawnRing *pNew = (FixDrawnRing *) NULL;
  
  if (pNew = (FixDrawnRing *) malloc (sizeof (FixDrawnRing)))
    {
      pNew->xCentre = x;
      pNew->yCentre = y;
      pNew->radius = r;
      pNew->pNext = (FixDrawnRing *) NULL;

      if (pFirstDrawnRing)
	{
	  pRing = pFirstDrawnRing;

	  while (pRing->pNext)
	    pRing = pRing->pNext;

	  pRing->pNext = pNew;
	}
      else
	{
	  pFirstDrawnRing = pNew;
	}
    }

  return (pNew);
}

void DestroyDrawnRings ()
{
  FixDrawnRing *pN, *pP = pFirstDrawnRing;

  while (pP)
    {
      pN = pP->pNext;
      free (pP);
      pP = pN;
    }
  
  pFirstDrawnRing = (FixDrawnRing *) NULL;
}

void DrawDrawnRings (Drawable d)
{
  FixDrawnRing *pRing = pFirstDrawnRing;

  while (pRing)
    {
      FixDrawRing (pRing->xCentre, pRing->yCentre, pRing->radius, d);
      pRing = pRing->pNext;
    }
}

void RepaintOverDrawnRings ()
{
  Region redrawRegion = XCreateRegion ();
  Region drawRegion = XCreateRegion ();
  FixDrawnRing *pRing = pFirstDrawnRing;
  XRectangle rect;
  int x, y, r;

  if (pRing == NULL)
    return;

  while (pRing)
    {
      FileToImageCoords (pRing->xCentre, pRing->yCentre, xi[currentImage], &x, &y);
      r = (int) (pRing->radius / xi[currentImage]->scale + 0.5);
      rect.x = (short) (x - r - 1); 
      rect.y = (short) (y - r - 1);
      rect.width = (unsigned short) (2 * r + 2);
      rect.height = (unsigned short) (2 * r + 2);
      if (rect.x < xi[currentImage]->width && rect.y < xi[currentImage]->height && 
	 (int) (rect.x + rect.width) >= 0 && (int) (rect.y + rect.height) >= 0)  
	{
	  XUnionRectWithRegion (&rect, drawRegion, drawRegion);
	}
      pRing = pRing->pNext;
    }

  XIntersectRegion (drawRegion, area1Region, redrawRegion);
  XDestroyRegion (drawRegion);

  XSetRegion (UxDisplay, paintGC, redrawRegion);
  XClipBox (redrawRegion, &rect);
  XPutImage (UxDisplay, XtWindow (drawingArea1), paintGC, xi[currentImage]->pXimage1, 
	     (int) rect.x, (int) rect.y, (int) rect.x, (int) rect.y, 
	     (unsigned int) rect.width, (unsigned int) rect.height);
  XSetClipMask (UxDisplay, paintGC, None);

  XSetRegion (UxDisplay, drawGC, redrawRegion);
  DrawObjects ();
  DrawLines ();
  DrawScans ();
  DrawDrawnCircles (XtWindow (UxGetWidget (drawingArea1)));
  DrawDrawnCrosses (XtWindow (UxGetWidget (drawingArea1)));
  XSetClipMask (UxDisplay, drawGC, None);

  XSetRegion (UxDisplay, textGC, redrawRegion);
  MarkObjects (1, editDialog_itemCount (objectD, &UxEnv), 0);
  MarkLines (1, editDialog_itemCount (lineD, &UxEnv), 0);
  MarkScans (1, editDialog_itemCount (scanD, &UxEnv), 0);
  XSetClipMask (UxDisplay, textGC, None);

  XDestroyRegion (redrawRegion);
  XFlush (UxDisplay);
}

/* end of ring stuff */

void ScaleLinear (FixImage *pImage)
{
  float range, value, lo, hi;
  unsigned char *vptr;
  unsigned long *cptr;
  unsigned char temp;
  int i, j;

  range = (float) (NColorAlloc - 1) / (pImage->tmax - pImage->tmin);
  vptr = pImage->pixelValues;
  cptr = pImage->pixelColours;

  lo = pImage->tmin;
  hi = pImage->tmax;
  if (lo > hi)
    {
      hi = pImage->tmin;
      lo = pImage->tmax;
    }

  for (j = 0; j < pImage->height; j++)
    {
      for (i = 0; i < pImage->width; i++)
	{
	  value = Interpolate (pImage, (float) i, (float) j);
	  value = MAX (value, lo);
	  value = MIN (value, hi);
	  temp = (unsigned char) ((value - pImage->tmin) * range);
	  *vptr++ = temp;
	  *cptr++ = pixcol[(int) temp];
	}
    }
}

void ScaleLog (FixImage *pImage)
{
  float base = 10.0;
  float colourRange, range, value, lo, hi;
  unsigned char *vptr;
  unsigned long *cptr;
  unsigned char temp;
  int i, j;

  range = (base - 1.0) / (pImage->tmax - pImage->tmin);
  colourRange = (float) (NColorAlloc - 1);
  vptr = pImage->pixelValues;
  cptr = pImage->pixelColours;

  lo = pImage->tmin;
  hi = pImage->tmax;
  if (lo > hi)
    {
      hi = pImage->tmin;
      lo = pImage->tmax;
    }

  for (j = 0; j < pImage->height; j++)
    {
      for (i = 0; i < pImage->width; i++)
	{
	  value = Interpolate (pImage, (float) i, (float) j);
	  value = MAX (value, lo);
	  value = MIN (value, hi);
	  temp = (unsigned char) (colourRange * 
				  log10 (1.0 + (value - pImage->tmin) * range));
	  *vptr++ = temp;
	  *cptr++ = pixcol[(int) temp];
	}
    }
}

void GreyScale ()
{
  static float fshift = 65536.0;
  float x = 0.0;
  float xstep;
  int numcol = 0;
  int i;

  xstep = 1.0 / (float) (NColor - 1);

  for (i = 0; i < NColor; i++)
    {
      colors[i].red   = (unsigned short) (x * fshift);
      colors[i].green = (unsigned short) (x * fshift);
      colors[i].blue  = (unsigned short) (x * fshift);
      colors[i].flags = DoRed | DoGreen | DoBlue;
      if (XAllocColor (UxDisplay, cmap, &colors[i]))
        {
          pixcol[numcol++] = colors[i].pixel;
        }
      x += xstep;
    }

  NColorAlloc = numcol;
  sprintf (textBuf, "Grayscale: Colours requested: %d  Colours allocated: %d\n", 
	   NColor, numcol);
  update_messages (textBuf);

  XFreeColors (UxDisplay, cmap, pixcol, NColorAlloc, (unsigned long) 0x0);
  XFlush (UxDisplay);
}

void ColourPalette1 ()
{
  float x, xstep, temp, temp1, tempx1, tempx2, gtanh, twopi_n;
  float yred, fred, ygreen, fgreen, yblue, fblue; 
  static float c_red = -0.35, c_green = 0.25, c_blue = 0.35;
  static float phi_red = 4.18879, phi_green = 0.0, phi_blue = 2.09439;
  static float gamma = 1.28;
  static float pi = 3.14159265;
  static int fshift = 32768;
  static int cycles = 7;
  int i, numcol = 0;
 
  x = 0.0;
  xstep = 1.0 / (float) (NColor - 1);
  twopi_n = 2.0 * pi * (float) cycles;
  gtanh = tanh (gamma);
  
  for (i=0; i<NColor; i++)
    {
      tempx1 = twopi_n * x;
      tempx2 = x * (1.0 - x);
/*
 * Red
 */
      temp = sin (tempx1 + phi_red);
      temp1 = tanh (gamma * temp) / gtanh;
      yred = x + tempx2 * temp1;
      fred = yred * (1.0 + c_red - yred * c_red); 
/*
 * Green  
 */
      temp = sin (tempx1 + phi_green);
      temp1 = tanh (gamma * temp) / gtanh;
      ygreen = x + tempx2 * temp1;
      fgreen = ygreen * (1.0 + c_green - ygreen * c_green); 
/*
 * Blue 
 */
      temp = sin (tempx1 + phi_blue);
      temp1 = tanh (gamma * temp) / gtanh;
      yblue = x + tempx2 * temp1;
      fblue = yblue * (1.0 + c_blue - yblue * c_blue); 
/*
 * Set up new colour table
 */
      colors[i].red = (unsigned short) (fshift + fshift * fred);
      colors[i].green = (unsigned short) (fshift + fshift * fgreen);
      colors[i].blue = (unsigned short) (fshift + fshift * fblue);
      colors[i].flags = DoRed | DoGreen | DoBlue;
      
      if (XAllocColor (UxDisplay, cmap, &colors[i]))
	pixcol[numcol++] = colors[i].pixel;
/*
 * Increment x
 */
      x += xstep;
    }
 
  sprintf (textBuf, "Thomas: Colours requested: %d  Colours allocated: %d\n", 
	   NColor, numcol); 
  update_messages (textBuf);

  NColorAlloc = numcol;
  XFreeColors (UxDisplay, cmap, pixcol, NColorAlloc, (unsigned long) 0x0);
  XFlush (UxDisplay);
}

void ColourPalette2 ()
{
  float red, green, blue, x, xstep, phi, phistep;
  static float pi = 3.14159265, root3 = 1.732051, third = 0.333333;
  float a, b, xp;
  static int fshift = 65536, ncycles = 1;
  int i, numcol = 0;
 
  x = 0.0;
  xstep = 1.0 / (float) (NColor - 1);
  phi = pi / 3.0;
  phistep = (float) ncycles * 2.0 * pi / (float) (NColor - 1);
 
  for (i=0; i<NColor; i++)
    {
      red = green = blue = 0.0;
      xp = x*x;
      a = (1.0 - xp) * 0.5 * (cos(phi) + 0.5 * sin(phi));
      b = (1.0 - xp) * 0.5 * root3 * sin(phi) / 2.0;
      
      red   = third * (2.0 + a - 2.0 * b);
      blue  = third * (2.0 + a + b);
      green = third * (2.0 - 2.0 * a + b);
/*
 * Set up new colour table
 */
      colors[i].red = (unsigned short) (fshift * red);
      colors[i].green = (unsigned short) (fshift * green);
      colors[i].blue = (unsigned short) (fshift * blue);
      colors[i].flags = DoRed | DoGreen | DoBlue;
      
      if (XAllocColor (UxDisplay, cmap, &colors[i]))
	pixcol[numcol++] = colors[i].pixel;
/*
 * Increment x
 */
      x += xstep;
      phi += phistep;
    }
 
  sprintf (textBuf, "Colour 2: Colours requested: %d  Colours allocated: %d\n", 
           NColor, numcol); 
  update_messages (textBuf);

  NColorAlloc = numcol;
  XFreeColors (UxDisplay, cmap, pixcol, NColorAlloc, (unsigned long) 0x0);
  XFlush (UxDisplay);
}

void ColourPalette3 ()
{
  float red, green, blue, x, xstep;
  static float third = 0.333333;
  static int fshift = 65536;
  int i, numcol = 0;
 
  x = 0.0;
  xstep = 1.0 / (float) (NColor - 1);
  
  for (i=0; i<NColor; i++)
    {
      red = green = blue = 0.0;
      if (x < third)
        {
          blue = 1.0 - 3.0 * x;
          green = 3.0 * x;
        }
      else if (x < 2.0 * third)
        {
          green = 2.0 - 3.0 * x;
          red = 3.0 * x - 1.0;
        }
      else
        {
          red = 3.0 - 3.0 * x;
          blue = 3.0 * x - 2.0;
        }
/*
 * Set up new colour table
 */
      colors[i].red = (unsigned short) (fshift * red);
      colors[i].green = (unsigned short) (fshift * green);
      colors[i].blue = (unsigned short) (fshift * blue);
      colors[i].flags = DoRed | DoGreen | DoBlue;
      
      if (XAllocColor (UxDisplay, cmap, &colors[i]))
	pixcol[numcol++] = colors[i].pixel;
/*
 * Increment x
 */
      x += xstep;
    }
 
  sprintf (textBuf, "Colour 3: Colours requested: %d  Colours allocated: %d\n", 
	   NColor, numcol); 
  update_messages (textBuf);

  NColorAlloc = numcol;
  XFreeColors (UxDisplay, cmap, pixcol, NColorAlloc, (unsigned long) 0x0);
  XFlush (UxDisplay);
}

void ColourPalette4 ()
{
  double red, green, blue, temp, factor;
  int i, numcol = 0;

  factor = 3.1416 / (double) (NColor - 1);

  colors[0].red   = 0;
  colors[0].green = 0;
  colors[0].blue  = 0;
  
  if (XAllocColor (UxDisplay, cmap, &colors[0]))
    pixcol[numcol++] = colors[0].pixel;

  for (i = 1; i < NColor - 1; i++)
    {
      temp = (double) i;
      green = sin (temp * factor);
      colors[i].green = (unsigned short) (255.0 * green) << 8;
      if (i < NColor / 2 + 1)
	{
	  red =  sin (temp * factor * 2.0);
	  blue = cos (temp * factor);
	}
      else
	{
	  red =  sin ((temp - (double) (NColor / 2)) * factor);
	  blue = sin ((temp - (double) (NColor / 2)) * factor * 2.0);
	}
      colors[i].red  = (unsigned short) (255.0 * red) << 8;
      colors[i].blue = (unsigned short) (255.0 * blue) << 8;

      if (XAllocColor (UxDisplay, cmap, &colors[i]))
	pixcol[numcol++] = colors[i].pixel;
    }

  colors[NColor-1].red   = 0xffff;
  colors[NColor-1].green = 0;
  colors[NColor-1].blue  = 0;

  if (XAllocColor (UxDisplay, cmap, &colors[i]))
    pixcol[numcol++] = colors[i].pixel;

  sprintf (textBuf, "Colour 4: Colours requested: %d  Colours allocated: %d\n", 
	   NColor, numcol); 
  update_messages (textBuf);

  NColorAlloc = numcol;
  XFreeColors (UxDisplay, cmap, pixcol, NColorAlloc, (unsigned long) 0x0);
  XFlush (UxDisplay);
}

void ColourPalette5 ()
{
  int nsector = 8;
  int i, j, k, n, r, g, b, numcol;
  int red[] = {0, 16, 64, 96, 160, 192, 224, 240};
  int green[] = {0, 32, 96, 224, 240, 128, 16, 0};
  int blue[] = {0, 192, 160, 128, 96, 64, 16, 0};

  n = NColor / nsector;

  i = 0;
  numcol = 0;
  for (j = 0; j < nsector; j++)
    {
      r = red[j]; 
      g = green[j]; 
      b = blue[j];

      for (k = 0; k < n; k++)
	{
	  colors[i].red = (unsigned short) r << 8;
	  colors[i].green = (unsigned short) g << 8;
	  colors[i].blue = (unsigned short) b << 8;
	  r++; 
	  g++;

	  if (XAllocColor (UxDisplay, cmap, &colors[i]))
	    pixcol[numcol++] = colors[i].pixel;
	  i++;
	}
    }

  sprintf (textBuf, "Colour 5: Colours requested: %d  Colours allocated: %d\n", 
	   NColor, numcol); 
  update_messages (textBuf);

  NColorAlloc = numcol;
  XFreeColors (UxDisplay, cmap, pixcol, NColorAlloc, (unsigned long) 0x0);
  XFlush (UxDisplay);
}

void InvertPalette ()
{
  int i;
  unsigned long temp;

  for (i = 0; i < NColorAlloc / 2; i++)
    {
      temp = pixcol[i];
      pixcol[i] = pixcol[NColorAlloc - i - 1];
      pixcol[NColorAlloc - i - 1] = temp;
    }
}

float Interpolate (FixImage *pImage, float ix, float iy)
{
  float value = 0.0;
  float *dptr;
  float fx, fy, dx, dy;
  int intx, inty;

  if ((int) ix >= 0 && (int) ix < pImage->width && 
      (int) iy >= 0 && (int) iy < pImage->height)
    {
      fx = pImage->scale * ix + (float) pImage->x;
      fy = pImage->scale * iy + (float) pImage->y;
      intx = (int) fx;
      inty = (int) fy;
      
      if (intx >= 0 && intx < npix && inty >=0 && inty < nrast)
	{
	  dptr = data + inty * npix + intx;
	  dx = fx - (float) intx;
	  dy = fy - (float) inty;
	  
	  value   += (1.0 - dx) * (1.0 - dy) * *dptr;
	  if (intx < npix - 1)
	    value += dx         * (1.0 - dy) * *(dptr + 1);
	  if (inty < nrast - 1)
	    value += (1.0 - dx) * dy         * *(dptr + npix);
	  if (intx < npix - 1 && inty < nrast - 1)
	    value += dx         * dy         * *(dptr + npix + 1);
	}
    }
  return (value);
}
  
void ImageToFileCoords (float ix, float iy, FixImage *pImage, float *fx, float *fy)
{
  *fx = (float) pImage->x + pImage->scale * (ix + 0.5);
  *fy = (float) pImage->y + pImage->scale * (iy + 0.5);
}

void FileToImageCoords (float fx, float fy, FixImage *pImage, int *ix, int *iy)
{
  *ix = (int) ((fx - (float) pImage->x) / pImage->scale);
  *iy = (int) ((fy - (float) pImage->y) / pImage->scale);
}

void MagToImageCoords (int mx, int my, FixImage *pImage, float *ix, float *iy)
{
  int scale, xstart, ystart;

  scale = MAGDIM / magnification;
  xstart = pImage->magx - scale / 2;
  ystart = pImage->magy - scale / 2;
  *ix = (float) xstart + ((float) mx + 0.5) / (float) magnification;
  *iy = (float) ystart + ((float) my + 0.5) / (float) magnification;
}

void LoadImage (FixImage *pImage)
{
  XRectangle rect;
  int i;
  unsigned char *vptr = pImage->pixelValues;
  unsigned long *cptr = pImage->pixelColours;

  SetBusyPointer (1);

  for (i = 0; i < pImage->width * pImage->height; i++)
    {
      *cptr++ = pixcol[*vptr++];
    }

  XtVaSetValues (UxGetWidget (drawingArea1),
		 XmNwidth, pImage->width,
		 XmNheight, pImage->height,
		 NULL);

  if (!XEmptyRegion (area1Region))
    {
      XDestroyRegion (area1Region);
      area1Region = XCreateRegion ();
    }
  rect.x = (short) 0;
  rect.y = (short) 0;
  rect.width = (unsigned short) pImage->width;
  rect.height = (unsigned short) pImage->height;
  XUnionRectWithRegion (&rect, area1Region, area1Region);

  XPutImage (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), paintGC, 
	     pImage->pXimage1, 0, 0, 0, 0, pImage->width, pImage->height);
	     
  Magnify (pImage);
  XPutImage (UxDisplay, XtWindow (UxGetWidget (drawingArea2)), paintGC, 
	     pImage->pXimage2, 0, 0, 0, 0, (int) MAGDIM, (int) MAGDIM);

  sprintf (textBuf, "%9g", pImage->tmax);
  XmTextFieldSetString (UxGetWidget (textHigh), textBuf);
  sprintf (textBuf, "%9g", pImage->tmin);
  XmTextFieldSetString (UxGetWidget (textLow), textBuf);
  
  DrawObjects ();
  MarkObjects (1, editDialog_itemCount (objectD, &UxEnv), 0);

  DrawLines ();
  MarkLines (1, editDialog_itemCount (lineD, &UxEnv), 0);

  DrawScans ();
  MarkScans (1, editDialog_itemCount (scanD, &UxEnv), 0);

  if (showPoints)
    {
      DrawDrawnPoints (XtWindow (UxGetWidget (drawingArea1)));
      DrawDrawnRings (XtWindow (UxGetWidget (drawingArea1)));
    }

  DestroyDrawnCrosses ();
  DestroyDrawnCircles ();

  SetBusyPointer (0);
  XFlush (UxDisplay);
}

void CloseImage (FixImage *pImage)
{
/*
  free (pImage->pixelValues);
  free (pImage->pixelColours);
  free (pImage->magnifyColours);
*/
  XDestroyImage (pImage->pXimage1);
  XDestroyImage (pImage->pXimage2);
  free (pImage);
}

void CloseAllImages ()
{
  int i;

  for (i = 0; i < totalImages; i++)
    CloseImage (xi[i]);

  currentImage = -1;
  totalImages = 0;

  XtSetSensitive (UxGetWidget (textHigh), False);
  XtSetSensitive (UxGetWidget (textLow), False);
  XmTextFieldSetString (UxGetWidget (imageText), "");
}

void Magnify (FixImage *pImage)
{
  int xstart, ystart, scale;
  int x, y, i, j, istart, jstart, ix, iy;
  unsigned long pixel;

  scale = MAGDIM / magnification;
  xstart = pImage->magx - scale / 2;
  ystart = pImage->magy - scale / 2;

  for (y = 0; y < scale; y++)
    {
      jstart = y * magnification;
      iy = y + ystart;
      for (x = 0; x < scale; x++)
	{
	  istart = x * magnification;
	  ix = x + xstart;

	  if (ix >= 0 && ix < pImage->width && iy >= 0 && iy < pImage->height)
	    pixel = XGetPixel (pImage->pXimage1, ix, iy);
	  else
	    pixel = 0;

	  for (j = jstart; j < jstart + magnification; j++)
	    {
	      for (i = istart; i < istart + magnification; i++)
		{
		  XPutPixel (pImage->pXimage2, i, j, pixel);
		}
	    }
	}
    }
}

void ProcessPoint1 (Widget wid, XEvent *ev)
{
  int x, y, len, n;
  float fx, fy;
  FixObject *point;
  
  if (currentImage >= 0)
    {
      x = ev->xbutton.x;
      y = ev->xbutton.y;
      
      DrawPlus (UxDisplay, XtWindow (wid), drawGC, &x, &y, 1, 4);

      ImageToFileCoords ((float) x, (float) y, xi[currentImage], &fx, &fy); 
      point = CreateFixObject (&fx, &fy, 1, "Point");
      CentreObject (point);
      n = CreateObjectItem (point);
      MarkObjects (n, n, 0);
      XFlush (UxDisplay);

      command ("Point %6.1f %6.1f\n", fx, fy);
    } 
}

void ProcessPoint2 (Widget wid, XEvent *ev)
{
  int x, y, len, n;
  float fx, fy, ix, iy, value;
  FixObject *point;
  
  if (currentImage >= 0)
    {
      x = ev->xbutton.x;
      y = ev->xbutton.y;
      
      DrawPlus (UxDisplay, XtWindow (wid), drawGC, &x, &y, 1, 4);

      MagToImageCoords (x, y, xi[currentImage], &ix, &iy);
      ImageToFileCoords (ix, iy, xi[currentImage], &fx, &fy);

      x = (int) (ix + 0.5);
      y = (int) (iy + 0.5);

      DrawPlus (UxDisplay, XtWindow (drawingArea1), drawGC, &x, &y, 1, 4);

      point = CreateFixObject (&fx, &fy, 1, "Point");
      CentreObject (point);
      n = CreateObjectItem (point);
      MarkObjects (n, n, 0);

      XFlush (UxDisplay);

      command ("Point %6.1f %6.1f\n", fx, fy);
    } 
} 

void TrackArea2 (Widget wid, XEvent *ev)
{
  static int fxOld = -1, fyOld = -1;
  int x, y; 
  float fx, fy, ix, iy, value;

  if (setMagnify && currentImage >= 0)
    {
      do
      	{
	  x = ev->xmotion.x;
	  y = ev->xmotion.y;
	}
      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (wid), MotionNotify, ev));

      MagToImageCoords (x, y, xi[currentImage], &ix, &iy);
      ImageToFileCoords (ix, iy, xi[currentImage], &fx, &fy);
      if ((int) fx != fxOld || (int) fy != fyOld)
	{
	  fxOld = (int) fx;
	  fyOld = (int) fy;
	  value = Interpolate (xi[currentImage], ix, iy);
	  UpdateXYLabels (fxOld, fyOld, value);
	}
    }
}

void UpdateArea2 (Widget wid, XEvent *ev)
{
  static int fxOld = -1, fyOld = -1;
  int x, y; 
  float fx, fy, value;

  if (!setMagnify && currentImage >= 0)
    {
      do
      	{
	  x = xi[currentImage]->magx = ev->xmotion.x;
	  y = xi[currentImage]->magy = ev->xmotion.y;
	}
      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (wid), MotionNotify, ev));

      ImageToFileCoords ((float) x, (float) y, xi[currentImage], &fx, &fy);
      if ((int) fx != fxOld || (int) fy != fyOld)
	{
	  fxOld = (int) fx;
	  fyOld = (int) fy;
	  value = Interpolate (xi[currentImage], (float) x, (float) y);
	  UpdateXYLabels (fxOld, fyOld, value);
	}

      Magnify (xi[currentImage]);
      XPutImage (UxDisplay, XtWindow (UxGetWidget (drawingArea2)), paintGC, 
		 xi[currentImage]->pXimage2, 0, 0, 0, 0, (int) MAGDIM, (int) MAGDIM);
		 
      XFlush (UxDisplay);
    }
}

void RefreshImage (Widget wid, XEvent *ev, XImage *pXimage)
{
  Region exposedRegion = XCreateRegion ();
  XRectangle rect;

  do
    {
      rect.x = (short) ev->xexpose.x;
      rect.y = (short) ev->xexpose.y;
      rect.width = (unsigned short) ev->xexpose.width;
      rect.height = (unsigned short) ev->xexpose.height;
      XUnionRectWithRegion (&rect, exposedRegion, exposedRegion);
    } 
  while (XCheckTypedWindowEvent (UxDisplay, XtWindow(wid), Expose, ev));
  
  XSetRegion (UxDisplay, paintGC, exposedRegion);
  XClipBox (exposedRegion, &rect);
  XPutImage (UxDisplay, XtWindow (wid), paintGC, pXimage, 
	     (int) rect.x, (int) rect.y, (int) rect.x, (int) rect.y, 
	     (unsigned int) rect.width, (unsigned int) rect.height);
  XSetClipMask (UxDisplay, paintGC, None);
	
  if (wid == UxGetWidget (drawingArea1))
    {
      XSetRegion (UxDisplay, drawGC, exposedRegion);
      DrawObjects ();
      DrawLines ();
      DrawScans ();
      DrawDrawnCircles (XtWindow (UxGetWidget (drawingArea1)));
      DrawDrawnCrosses (XtWindow (UxGetWidget (drawingArea1)));
      XSetClipMask (UxDisplay, drawGC, None);

      XSetRegion (UxDisplay, textGC, exposedRegion);
      MarkObjects (1, editDialog_itemCount (objectD, &UxEnv), 0);
      MarkLines (1, editDialog_itemCount (lineD, &UxEnv), 0);
      MarkScans (1, editDialog_itemCount (scanD, &UxEnv), 0);
      XSetClipMask (UxDisplay, textGC, None);

      if (showPoints)
	{
	  XSetRegion (UxDisplay, pointGC, exposedRegion);
	  DrawDrawnPoints (XtWindow (UxGetWidget (drawingArea1)));
	  DrawDrawnRings (XtWindow (UxGetWidget (drawingArea1)));
	  XSetClipMask (UxDisplay, pointGC, None);
	}
    }
     
  XDestroyRegion (exposedRegion);
  XFlush (UxDisplay);
}

void Refresh1 (Widget wid, XEvent *ev)
{
  if (currentImage >= 0)
    RefreshImage (wid, ev, xi[currentImage]->pXimage1);
}

void Refresh2 (Widget wid, XEvent *ev)
{
  if (currentImage >= 0)
    RefreshImage (wid, ev, xi[currentImage]->pXimage2);
}

void ProcessLine1 (int ifp, int ilp, int ifr, int ilr, int width)
{
  float x1, y1, x2, y2, w;
  int n;
  FixLine *line;

  if (currentImage >= 0)
    {
      DrawLine (UxDisplay, XtWindow (drawingArea1), drawGC, ifp, ifr, ilp, ilr, width);

      ImageToFileCoords ((float) ifp, (float) ifr, xi[currentImage], &x1, &y1);
      ImageToFileCoords ((float) ilp, (float) ilr, xi[currentImage], &x2, &y2);
      w = (float) width * xi[currentImage]->scale;

      line = CreateFixLine (x1, y1, x2, y2, w);
      n = CreateLineItem (line);
      MarkLines (n, n, 0);

      command ("Line %6.1f %6.1f %6.1f %6.1f %6.1f\n", x1, y1, x2, y2, w);
    }
}

void ProcessRect1 (int ifp, int ilp, int ifr, int ilr)
{
  float x1, y1, x2, y2;
  int x, y, n;
  float xrect[4], yrect[4];
  FixObject *rectangle;

  if (currentImage >= 0)
    {
      ImageToFileCoords ((float) ifp, (float) ifr, xi[currentImage], &x1, &y1);
      ImageToFileCoords ((float) ilp, (float) ilr, xi[currentImage], &x2, &y2);
      
      xrect[0] = x1; yrect[0] = y1;
      xrect[1] = x1; yrect[1] = y2;
      xrect[2] = x2; yrect[2] = y2;
      xrect[3] = x2; yrect[3] = y1;

      command ("Polygon 4  ");
      command ("%6.1f %6.1f  ", x1, y1);
      command ("%6.1f %6.1f  ", x1, y2);
      command ("%6.1f %6.1f  ", x2, y2);
      command ("%6.1f %6.1f\n", x2, y1);

      rectangle = CreateFixObject (xrect, yrect, 4, "Rectangle");
      CentreObject (rectangle);

      FileToImageCoords (rectangle->xc, rectangle->yc, xi[currentImage], &x, &y);
      DrawPlus (UxDisplay, XtWindow (drawingArea1), drawGC, &x, &y, 1, 4);

      n = CreateObjectItem (rectangle);
      MarkObjects (n, n, 0);
    }
}

void ProcessPoly1 (int *xv, int *yv, int nv)
{
  float fx, fy;
  int i, x, y, n;
  float xpoly[MAXVERTS], ypoly[MAXVERTS];
  FixObject *polygon;

  if (currentImage >= 0)
    {
      command ("Polygon %d  ", nv);
      for (i = 0; i < nv; i++)
	{
	  ImageToFileCoords ((float) xv[i], (float) yv[i], xi[currentImage], &fx, &fy);
	  xpoly[i] = fx;
	  ypoly[i] = fy;
	  command ("%6.1f %6.1f  ", fx, fy);
	} 
      command ("\n");
      
      polygon = CreateFixObject (xpoly, ypoly, nv, "Polygon");
      CentreObject (polygon);

      FileToImageCoords (polygon->xc, polygon->yc, xi[currentImage], &x, &y);
      DrawPlus (UxDisplay, XtWindow (drawingArea1), drawGC, &x, &y, 1, 4);

      n = CreateObjectItem (polygon);
      MarkObjects (n, n, 0);

    }
}

void ProcessSector1 (int x1, int y1, int x2, int y2)
{
  Widget wgt;
  int n, x, y;
  float xs[3], ys[3];
  FixScan *scan;
  FixObject *sector;

  if (currentImage >= 0)
    {
      xs[0] = (float) centreX;
      ys[0] = (float) centreY;

      ImageToFileCoords ((float) x1, (float) y1, xi[currentImage], &xs[1], &ys[1]);
      ImageToFileCoords ((float) x2, (float) y2, xi[currentImage], &xs[2], &ys[2]);

      XtVaGetValues (UxGetWidget (rowColumn1), XmNmenuHistory, &wgt, NULL);

      if (wgt == UxGetWidget (toggleScan))
	{
	  FileToImageCoords (xs[0], ys[0], xi[currentImage], &x, &y);
	  DrawSector (UxDisplay, XtWindow (drawingArea1), drawGC, x, y, x1, y1, x2, y2);

	  scan = CreateFixScan (xs, ys);
	  n = CreateScanItem (scan);
	  MarkScans (n, n, 0);
	  
	  command ("Scan %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f\n", 
		   xs[0], ys[0], xs[1], ys[1], xs[2], ys[2]);
	}
      else
	{
	  command ("Sector %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f\n",
		   xs[0], ys[0], xs[1], ys[1], xs[2], ys[2]);

	  sector = CreateFixObject (xs, ys, 3, "Sector");
	  CentreSector (sector);

	  FileToImageCoords (sector->xc, sector->yc, xi[currentImage], &x, &y);
	  DrawPlus (UxDisplay, XtWindow (drawingArea1), drawGC, &x, &y, 1, 4);
	  
	  n = CreateObjectItem (sector);
	  MarkObjects (n, n, 0);

	}
    }
}

void ProcessLine2 (int ifp, int ilp, int ifr, int ilr, int width)
{
  float x1, y1, x2, y2, w;
  float ix, iy;
  int ix1, iy1, ix2, iy2, n;
  FixLine *line;

  if (currentImage >= 0)
    {
      MagToImageCoords (ifp, ifr, xi[currentImage], &ix, &iy);
      ImageToFileCoords (ix, iy, xi[currentImage], &x1, &y1);
      MagToImageCoords (ilp, ilr, xi[currentImage], &ix, &iy);
      ImageToFileCoords (ix, iy, xi[currentImage], &x2, &y2);
      w = (float) width * xi[currentImage]->scale / (float) magnification;

      FileToImageCoords (x1, y1, xi[currentImage], &ix1, &iy1);
      FileToImageCoords (x2, y2, xi[currentImage], &ix2, &iy2);
      width = (int) (w / xi[currentImage]->scale + 0.5);
      DrawLine (UxDisplay, XtWindow (drawingArea1), drawGC, ix1, iy1, ix2, iy2, width);

      line = CreateFixLine (x1, y1, x2, y2, w);
      n = CreateLineItem (line);
      MarkLines (n, n, 0);

      command ("Line %6.1f %6.1f %6.1f %6.1f %6.1f\n", x1, y1, x2, y2, w);
    }
}

void ProcessRect2 (int ifp, int ilp, int ifr, int ilr)
{
  float x1, y1, x2, y2;
  float ix, iy;
  float xrect[4], yrect[4];
  int x, y, n;
  FixObject *rectangle;

  if (currentImage >= 0)
    {
      MagToImageCoords (ifp, ifr, xi[currentImage], &ix, &iy);
      ImageToFileCoords (ix, iy, xi[currentImage], &x1, &y1);
      MagToImageCoords (ilp, ilr, xi[currentImage], &ix, &iy);
      ImageToFileCoords (ix, iy, xi[currentImage], &x2, &y2);

      xrect[0] = x1; yrect[0] = y1;
      xrect[1] = x1; yrect[1] = y2;
      xrect[2] = x2; yrect[2] = y2;
      xrect[3] = x2; yrect[3] = y1;

      command ("Polygon 4  ");
      command ("%6.1f %6.1f  ", x1, y1);
      command ("%6.1f %6.1f  ", x1, y2);
      command ("%6.1f %6.1f  ", x2, y2);
      command ("%6.1f %6.1f\n", x2, y1);

      rectangle = CreateFixObject (xrect, yrect, 4, "Rectangle");
      CentreObject (rectangle);

      FileToImageCoords (rectangle->xc, rectangle->yc, xi[currentImage], &x, &y);
      DrawPlus (UxDisplay, XtWindow (drawingArea1), drawGC, &x, &y, 1, 4);

      n = CreateObjectItem (rectangle);
      MarkObjects (n, n, 0);
    }
}

void ProcessPoly2 (int *xv, int *yv, int nv)
{
  int i, x, y, n;
  float xpoly[MAXVERTS], ypoly[MAXVERTS];
  FixObject *polygon;
  float fx, fy, ix, iy;

  if (currentImage >= 0)
    {
      command ("Polygon %d  ", nv);
      for (i = 0; i < nv; i++)
	{
	  MagToImageCoords (xv[i], yv[i], xi[currentImage], &ix, &iy);
	  ImageToFileCoords (ix, iy, xi[currentImage], &fx, &fy);
	  xpoly[i] = fx;
	  ypoly[i] = fy;
	  command ("%6.1f %6.1f  ", fx, fy);
	}
      command ("\n");
 
      polygon = CreateFixObject (xpoly, ypoly, nv, "Polygon");
      CentreObject (polygon);

      FileToImageCoords (polygon->xc, polygon->yc, xi[currentImage], &x, &y);
      DrawPlus (UxDisplay, XtWindow (drawingArea1), drawGC, &x, &y, 1, 4);

      n = CreateObjectItem (polygon);
      MarkObjects (n, n, 0);
    }
}

void ProcessBox1 (int ifp, int ifr, int width, int height)
{
  int x, y, ipix, irast;
  float fx, fy, fpix, frast;
  int oldImage = currentImage;
  Boolean interpFlag = interpolation;

  if (currentImage >= 0)
    {
      if (totalImages < MAXIMAGE)
	{
	  ImageToFileCoords ((float) ifp, (float) ifr, xi[currentImage], &fx, &fy);
	  ImageToFileCoords ((float) (ifp + width), (float) (ifr + height), 
			     xi[currentImage], &fpix, &frast);
	  
	  x = (int) fx;
	  y = (int) fy;
	  ipix = (int) (fpix - fx);
	  irast = (int) (frast - fy);
	  
	  currentImage = totalImages++;
	  sprintf (textBuf, "Creating image %d...\n", currentImage);
	  update_messages (textBuf);
	  sprintf (textBuf, "File space:  x = %d, y = %d, width = %d, height = %d\n", 
		   x, y, ipix, irast);
	  update_messages (textBuf);
	  sprintf (textBuf, "Image space: x = %d, y = %d, width = %d, height = %d\n", 
		   ifp, ifr, width, height);
	  update_messages (textBuf);
	  
	  SetBusyPointer (1);
	  interpolation = True;	  
	  xi[currentImage] = CreateFixImage (x, y, ipix, irast);
	  interpolation = interpFlag;
	  SetBusyPointer (0);

	  if (xi[currentImage])
	    {
	      LoadImage (xi[currentImage]);
	      sprintf (textBuf, "%1d", currentImage);
	      XmTextFieldSetString (UxGetWidget (imageText), textBuf);
	    }
	  else
	    {
	      errorDialog_popup (error, &UxEnv, "Unable to create image");
	      totalImages--;
	      currentImage = oldImage;
	    }
	}
      else
	{
	  update_messages ("Too many images!\n");
	}
    }
}

void UpdateXYLabels (int fx, int fy, float value)
{
  sprintf (textBuf, "%4d", fx);
  XmTextFieldSetString (UxGetWidget (textX), textBuf);

  sprintf (textBuf, "%4d", fy);
  XmTextFieldSetString (UxGetWidget (textY), textBuf);

  sprintf (textBuf, "%9g", value);
  XmTextFieldSetString (UxGetWidget (textValue), textBuf);
}

void DrawPlus (Display *display, Drawable window, GC gc, int *xverts, int *yverts, 
	       int nvert, int size)
{
   int i;
 
   for (i=0; i<nvert; i++)
   {
      XDrawLine (display, window, gc, xverts[i] - size, yverts[i],
                 xverts[i] + size, yverts[i]);
      XDrawLine (display, window, gc, xverts[i], yverts[i] - size,
                 xverts[i], yverts[i] + size);
   }
   return;
}

void DrawCross (Display *display, Drawable window, GC gc, int *xverts, int *yverts, 
                int nvert, int size) 
{
   int i;
 
   for (i=0; i<nvert; i++)
   {
      XDrawLine (display, window, gc, xverts[i]-size, yverts[i]-size,
                 xverts[i]+size, yverts[i]+size);
      XDrawLine (display, window, gc, xverts[i]+size, yverts[i]-size,
                 xverts[i]-size, yverts[i]+size);
   }
   return;
}

void DrawLine (Display *display, Drawable window, GC gc, int x1, int y1, int x2, int y2, 
	       int w)
{
  Status geomstat; 
  Window w_root;
  int w_x, w_y;
  unsigned int w_width, w_height;
  unsigned int w_border_width;
  unsigned int w_depth;
  XPoint points[5];

  if (w > 0)
    {
      geomstat = XGetGeometry (UxDisplay, window, &w_root, &w_x, &w_y, &w_width, &w_height,
			       &w_border_width, &w_depth);
      fpoint (w_width, w_height, x1, x2, y1, y2, w, points);
      XDrawLines (display, window, gc, points, 5, CoordModeOrigin);
    }
  else
    {
      XDrawLine (display, window, gc, x1, y1, x2, y2);
    }
}

void DrawCircle (Display *display, Drawable window, GC gc, int xcen, int ycen, 
		 int radius, int npix, int nrast)
{
  int i;
  int phi1 = 0, phi2 = 23040;        /*  angles in degrees*64  */
  int d[4];
  float dx, dy, ddx, ddy, r, diag, dmin;
  static float rtod = 57.2957795;
  
  d[0] = npix - xcen;
  d[1] = ycen;
  d[2] = xcen;
  d[3] = nrast - ycen;
  r = (float) radius;
 
  for (i=0; i<4 ; i++)
    {
      
      if (d[((i + 2) % 4)] < 0 && radius < d[i])
	{
	  if (radius < abs (d[((i + 2) % 4)]))
	    return;
	  ddx = (float) d[((i + 2) % 4)];
	  dy = sqrt (r * r - ddx * ddx);
	}
      else
	{
	  ddx = 0.0;
	  dy = (float) d[((i + 1) % 4)];
	}
 
      if (d[((i + 3) % 4)] < 0 && radius < d[((i + 1) % 4)])
	{
	  if (radius < abs (d[((i +3) % 4)]))
	    return;
	  ddy = (float) d[((i + 3) % 4)];
	  dx = sqrt (r * r - ddy * ddy);
	}
      else
	{
	  ddy = 0.0;
	  dx = (float) d[i];
	}
 
      diag = sqrt (dx * dx + dy * dy);
      dmin = sqrt (ddx * ddx + ddy * ddy);
  
      if ((diag > r) && (r > dmin) && (dx > 0.0) && (dy > 0.0))
	{
	  if (r > dx)
	    phi1 = 64 * (90 * i + (int) (acos (dx / r) * rtod)) + 32;
 
	  if (r > dy)
	    phi2 = 64 * (90 * i + (int) (asin (dy / r) * rtod)) - 32; 
      
	  if (((phi2 % 5760) != 0) || (i == 3))
	    {
	      XDrawArc (display, window, gc,
			(xcen - radius), (ycen - radius),
			(2 * radius), (2 * radius), phi1, phi2);
	      phi2 = 23040;
	    }
	}
      else
	phi1 = 5760 * i;
    }
  return;
}

void DrawSector (Display *display, Drawable window, GC gc, int xcen, int ycen, 
		 int x1, int y1, int x2, int y2)
{
  static double rtod = 3.66692988883e+03;    /* 64 times 180 over pi */
  double r1, phi1, r2, phi2, dx1, dy1, dx2, dy2;
  int ir1, ir2, ip1, ip2, xc, yc;

  dx1 = (double) (x1 - xcen);
  dy1 = (double) (ycen - y1);
  dx2 = (double) (x2 - xcen);
  dy2 = (double) (ycen - y2);

  phi1 = atan2 (dy1, dx1);
  phi2 = atan2 (dy2, dx2);
  ip1 = (int) rtod * phi1;
  ip2 = (int) rtod * (phi2 - phi1);

  if (ip2 < 0) 
    ip2 += 23040;

  r1 = sqrt (dx1 * dx1 + dy1 * dy1);
  r2 = sqrt (dx2 * dx2 + dy2 * dy2);
  ir1 = (int) r1;
  ir2 = (int) r2;

  XDrawArc (display, window, gc, (xcen - ir1), (ycen - ir1), (2 * ir1), (2 * ir1), ip1, ip2);
  XDrawArc (display, window, gc, (xcen - ir2), (ycen - ir2), (2 * ir2), (2 * ir2), ip1, ip2);
			
  xc = xcen + (int) r1 * cos (phi2);
  yc = ycen - (int) r1 * sin (phi2);
  XDrawLine (display, window, gc, xc, yc, x2, y2);

  xc = xcen + (int) r2 * cos (phi1);
  yc = ycen - (int) r2 * sin (phi1);
  XDrawLine (display, window, gc, xc, yc, x1, y1);
}

void FixDrawCross (float x, float y, Drawable d)
{
  int ix, iy;
  
  FileToImageCoords (x, y, xi[currentImage], &ix, &iy);
  DrawCross (UxDisplay, d, drawGC, &ix, &iy, 1, 4);
}

void FixDrawCircle (float x, float y, float r, Drawable d)
{
  int ix, iy, ir;

  FileToImageCoords (x, y, xi[currentImage], &ix, &iy);
  ir = (int) (r / xi[currentImage]->scale + 0.5);

  DrawCircle (UxDisplay, d, drawGC, ix, iy, ir,
	      xi[currentImage]->width, xi[currentImage]->height);
}

void FixDrawRing (float x, float y, float r, Drawable d)
{
  int ix, iy, ir;

  FileToImageCoords (x, y, xi[currentImage], &ix, &iy);
  ir = (int) (r / xi[currentImage]->scale + 0.5);

  DrawCircle (UxDisplay, d, pointGC, ix, iy, ir,
	      xi[currentImage]->width, xi[currentImage]->height);
}

void FixDrawPoint (float x, float y, Drawable d)
{
  int ix, iy;
  
  FileToImageCoords (x, y, xi[currentImage], &ix, &iy);

  XFillRectangle (UxDisplay, d, pointGC, 
		  (int) (ix - pointWidth), (int) (iy - pointWidth),
		  (unsigned int) (2 * pointWidth), (unsigned int) (2 * pointWidth));
}

void fpoint (int npix, int nrast, int ifp, int ilp, int ifr, int ilr,
	     int boxwidth, XPoint *points)
{
  int hit_limit = 0;
  float dx, dy, length;
  int idx, idy;
  short int ix[4], iy[4];
  int i;
 
  dx = (float) (ilp - ifp);
  dy = (float) (ilr - ifr);
  length = (float) sqrt (dx * dx + dy * dy);
 
 
  if (length > 0.0)
    {
      idx = (int) ((float) boxwidth * dy / length);
      idy = (int) ((float) boxwidth * dx / length);
    }
  else
    {
      idx = 0;
      idy = 0;
    }
 
  ix[0] = ifp + idx; iy[0] = ifr - idy;
  ix[1] = ilp + idx; iy[1] = ilr - idy;
  ix[2] = ilp - idx; iy[2] = ilr + idy;
  ix[3] = ifp - idx; iy[3] = ifr + idy;
 
  for (i=0; i<4; i++)
    {
      if (ix[i] < 0 || ix[i] >= npix || iy[i] < 0 || iy[i] >= nrast)
        {
          hit_limit = 1;
        }
    }
  if (!hit_limit)
    {
      for (i=0; i<4; i++)
        {
          points[i].x = ix[i];
          points[i].y = iy[i];
        }
      points[4].x = points[0].x; points[4].y = points[0].y;
    }
  return;
}

int fwidth (int ifp, int ilp, int ifr, int ilr, int ipx, int ipy)
{
  float m, c, dx, dy, u, v;
  int itemp;
 
  if ((ilp - ifp) == 0)
    {
      SWAP (ifp, ifr);
      SWAP (ilp, ilr);
      SWAP (ipx, ipy);
    }
 
  if ((ilp - ifp) == 0)
    {
      return (0);
    }
 
  dx = (float) (ilp - ifp);
  dy = (float) (ilr - ifr);
  u = (float) (ilp + ifp);
  v = (float) (ilr + ifr);
 
  m = dy / dx;
  c = (v - m * u) / 2.0;
 
  u = (float) ipx;
  v = (float) ipy;
 
  dx = (u + m*(v - c))/(1 + m*m);
  dy = v - m*dx - c;
  dx = u - dx;
 
  return ((int) sqrt (dx*dx + dy*dy));
}

void psout (char *psname)
{
  Pixmap pm;
  XImage *pXi;
  int width = xi[currentImage]->width, height = xi[currentImage]->height;

  pm = XCreatePixmap (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), width, height, depth);
		      
  XPutImage (UxDisplay, pm, paintGC, xi[currentImage]->pXimage1, 0, 0, 0, 0, width, height);
    
  DrawObjectsOnDrawable (pm);
  MarkObjectsOnDrawable  (1, editDialog_itemCount (objectD, &UxEnv), 0, pm);

  DrawLinesOnDrawable  (pm);
  MarkLinesOnDrawable  (1, editDialog_itemCount (lineD, &UxEnv), 0, pm);

  DrawScansOnDrawable  (pm);
  MarkScansOnDrawable  (1, editDialog_itemCount (scanD, &UxEnv), 0, pm);

  if (showPoints)
    {
      DrawDrawnPoints (pm);
      DrawDrawnRings (pm);
    }

  pXi = XGetImage (UxDisplay, pm, 0, 0, width, height, AllPlanes, ZPixmap);
  
  pswrite (psname, pXi);

  XDestroyImage (pXi);
  XFreePixmap (UxDisplay, pm);
 
  return;
}

void pswrite(char *psname, XImage *pXi)
{
  FILE *fp;
  int i, j, ipix, irast, n, ixb1, iyb1, ixb2, iyb2;
  float xscale, yscale;
  short int ir, ig, ib;
  unsigned long ulPixel;
  
  if ((fp = fopen (psname, "w")) == NULL)
    {
      fprintf (stderr, "Error opening file\n");
      return;
    }

  fprintf (fp, "%%!PS-Adobe-2.0\n");
  fprintf (fp, "%%%%Title: %s\n", psname);
  fprintf (fp, "%%%%Creator: XFIX\n");

  ipix = pXi->width;
  irast = pXi->height;
  
  ixb1 = (596 - ipix)/2;
  ixb2 = ixb1 + ipix;
  iyb1 = (1005 - irast)/2;
  iyb2 = iyb1 + irast;
  
  if ((float) ipix / (float) irast > 0.7)
    {
      xscale = 504.0;
      yscale = (float) irast * xscale / (float) ipix;
    }
  else
    {
      yscale = 720.0;
      xscale = (float) ipix * yscale / (float) irast;
    }
  
  fprintf (fp, "%%%%BoundingBox: %u %u %u %u\n", ixb1, iyb1, ixb2, iyb2);
  fprintf (fp, "%%%%Pages: 1\n");
  fprintf (fp, "%%%%DocumentFonts:\n");
  fprintf (fp, "%%%%EndComments\n");
  fprintf (fp, "%%%%EndProlog\n");        
  putc ('\n', fp);
  fprintf (fp, "%%%%Page: 1 1\n");
  putc ('\n', fp);
  
  fprintf (fp, "%% remember original state\n");
  fprintf (fp, "/origstate save def\n");
  putc ('\n', fp);
  
  fprintf (fp, "%% build a temporary dictionary\n");
  fprintf (fp, "20 dict begin\n");
  putc ('\n', fp);
  
  fprintf (fp, "%% define string to hold a scanline's worth of data\n");
  fprintf (fp, "/pix %u string def\n", 3*ipix);
  putc ('\n', fp);
  
  fprintf (fp, "%% lower left corner\n");
  fprintf (fp, "36 36 translate\n");
  putc ('\n', fp);
  
  fprintf (fp, "%% size of image (on paper, in 1/72inch coords)\n");
  fprintf (fp, "%f %f scale\n", xscale, yscale);
  putc ('\n', fp);
  
  fprintf (fp, "%% define 'colorimage' if it isn't defined\n");
  fprintf (fp, "%%   ('colortogray' and 'mergeprocs' come from xwd2ps\n");
  fprintf (fp, "%%     via xgrab)\n");
  fprintf (fp, "/colorimage where   %% do we know about 'colorimage'?\n");
  fprintf (fp, "{ pop }           %% yes: pop off the 'dict' returned\n");
  fprintf (fp, "  {                 %% no:  define one\n");
  fprintf (fp, "    /colortogray {  %% define an RGB->I function\n");
  fprintf (fp, "      /rgbdata exch store    %% call input 'rgbdata'\n");
  fprintf (fp, "      rgbdata length 3 idiv\n");
  fprintf (fp, "      /npixls exch store\n");
  fprintf (fp, "      /rgbindx 0 store\n");
  fprintf (fp, "      /grays npixls string store  %% str to hold the result\n");
  fprintf (fp, "      0 1 npixls 1 sub {\n");
  fprintf (fp, "        grays exch\n");
  fprintf (fp, "        rgbdata rgbindx       get 20 mul    %% Red\n");
  fprintf (fp, "        rgbdata rgbindx 1 add get 32 mul    %% Green\n");
  fprintf (fp, "        rgbdata rgbindx 2 add get 12 mul    %% Blue\n");
  fprintf (fp, "        add add 64 idiv      %% I = .5G + .31R + .18B\n");
  fprintf (fp, "        put\n");
  fprintf (fp, "        /rgbindx rgbindx 3 add store\n");
  fprintf (fp, "      } for\n");
  fprintf (fp, "      grays\n");
  fprintf (fp, "    } bind def\n");
  putc ('\n', fp);
  
  fprintf (fp, "    %% Utility procedure for colorimage operator.\n");
  fprintf (fp, "    %% This procedure takes two procedures off the\n");
  fprintf (fp, "    %% stack and merges them into a single procedure.\n");
  putc ('\n', fp);
  
  fprintf (fp, "    /mergeprocs { %% def\n");
  fprintf (fp, "      dup length\n");
  fprintf (fp, "      3 -1 roll\n");
  fprintf (fp, "      dup\n");
  fprintf (fp, "      length\n");
  fprintf (fp, "      dup\n");
  fprintf (fp, "      5 1 roll\n");
  fprintf (fp, "      3 -1 roll\n");
  fprintf (fp, "      add   \n");
  fprintf (fp, "      array cvx\n");
  putc ('\n', fp);
  
  fprintf (fp, "      dup\n");
  fprintf (fp, "      3 -1 roll\n");
  fprintf (fp, "      0 exch\n");
  fprintf (fp, "      putinterval\n");
  fprintf (fp, "      dup\n");
  fprintf (fp, "      4 2 roll\n");
  fprintf (fp, "      putinterval\n");
  fprintf (fp, "    } bind def\n");
  
  fprintf (fp, "    /colorimage { %% def\n");
  fprintf (fp, "      pop pop     %% remove 'false 3' operands\n");
  fprintf (fp, "      {colortogray} mergeprocs\n");
  fprintf (fp, "      image\n");
  fprintf (fp, "    } bind def\n");
  fprintf (fp, "  } ifelse          %% end of 'false' case\n");
  putc ('\n', fp);
  putc ('\n', fp);
  
  fprintf (fp, "%u %u  8                  %% dimensions of data\n", 
	   ipix, irast);
  fprintf (fp, "[%d 0 0 %d 0 %d]          %% mapping matrix\n", 
	   ipix, -irast, irast);
  fprintf (fp, "{currentfile pix readhexstring pop}\n");
  fprintf (fp, "false 3 colorimage\n");
  
  for (j = 0; j < irast; j++)
    {
      for (i = 0; i < ipix; i++)
	{
	  ulPixel = XGetPixel (pXi, i, j);

	  if (ulPixel == red.pixel)
	    {
	      ir = (red.red >> 8) & 0XFF;
	      ig = (red.green >> 8) & 0XFF;
	      ib = (red.blue >> 8) & 0XFF;
	     } 
	  else if (ulPixel == blue.pixel)
	    {
	      ir = (blue.red >> 8) & 0XFF;
	      ig = (blue.green >> 8) & 0XFF;
	      ib = (blue.blue >> 8) & 0XFF;
	     } 
	  else if (ulPixel == green.pixel)
	    {
	      ir = (green.red >> 8) & 0XFF;
	      ig = (green.green >> 8) & 0XFF;
	      ib = (green.blue >> 8) & 0XFF;
	     }
	  else if (ulPixel == yellow.pixel)
	    {
	      ir = (yellow.red >> 8) & 0XFF;
	      ig = (yellow.green >> 8) & 0XFF;
	      ib = (yellow.blue >> 8) & 0XFF;
	     }
	  else if (ulPixel == black.pixel)
	    {
	      ir = (black.red >> 8) & 0XFF;
	      ig = (black.green >> 8) & 0XFF;
	      ib = (black.blue >> 8) & 0XFF;
	     }
	  else if (ulPixel == white.pixel)
	    {
	      ir = (white.red >> 8) & 0XFF;
	      ig = (white.green >> 8) & 0XFF;
	      ib = (white.blue >> 8) & 0XFF;
	     }
	  else
	    {
	      for (n = 0; n < NColorAlloc; n++)
		{
		  if (ulPixel == colors[n].pixel)
		    {
		      ir = (colors[n].red >> 8) & 0XFF;
		      ig = (colors[n].green >> 8) & 0XFF;
		      ib = (colors[n].blue >> 8) & 0XFF;
		      break;
		    }
		}
	    }
	  
	  if (i > 0 && i%12 == 0)
	    putc ('\n', fp);
	  
	  fprintf (fp, "%02X%02X%02X", ir, ig, ib);
	}
    }
  
  fprintf (fp, "\nshowpage\n");
  putc ('\n', fp);
  
  fprintf (fp, "%% stop using temporary dictionary\n");
  fprintf (fp, "end\n");
  putc ('\n', fp);
  
  fprintf (fp, "%% restore original state\n");
  fprintf (fp, "origstate restore\n");
  putc ('\n', fp);
  
  fprintf (fp, "%%%%Trailer");

  fclose (fp);

  return;
}


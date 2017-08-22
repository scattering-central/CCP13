char *cptr;
double wave, dist, cx, cy, drota, dtilt, dtwist, stilt, dcal;

if (waveChanged || firstLook)
{
  cptr = XmTextFieldGetString (UxGetWidget (waveText));
  wave = atof (cptr);
  free (cptr);
  command ("Wavelength %f\n", wave);
  mainWS_setWavelength (mainWS, &UxEnv, wave);
  waveChanged = False;
 }

if (distanceChanged)
{
  cptr = XmTextFieldGetString (UxGetWidget (distanceText));
  dist = atof (cptr);
  free (cptr);
  command ("Distance %f\n", dist);
  mainWS_setDistance (mainWS, &UxEnv, dist);
  distanceChanged = False;
}

if (centreChanged || firstLook)
{
  cptr = XmTextFieldGetString (UxGetWidget (centreXText));
  cx = atof (cptr);
  free (cptr);
  cptr = XmTextFieldGetString (UxGetWidget (centreYText));
  cy = atof (cptr);
  free (cptr);
  command ("Centre %f %f\n", cx, cy);
  mainWS_setCentreX (mainWS, &UxEnv, cx);
  mainWS_setCentreY (mainWS, &UxEnv, cy);
  centreChanged = False;
}

if (rotationChanged || firstLook)
{
  cptr = XmTextFieldGetString (UxGetWidget (detectorRotText));
  drota = atof (cptr);
  free (cptr);
  cptr = XmTextFieldGetString (UxGetWidget (detectorTwistText));
  dtwist = atof (cptr);
  free (cptr);
  cptr = XmTextFieldGetString (UxGetWidget (detectorTiltText));
  dtilt = atof (cptr);
  free (cptr);
  command ("Rotation %f %f %f\n", drota, dtwist, dtilt);
  mainWS_setRotX (mainWS, &UxEnv, drota);
  mainWS_setRotY (mainWS, &UxEnv, dtwist);
  mainWS_setRotZ (mainWS, &UxEnv, dtilt);
  rotationChanged = False;
}

if (tiltChanged || firstLook)
{
  cptr = XmTextFieldGetString (UxGetWidget (specimenTiltText));
  stilt = atof (cptr);
  free (cptr);
  command ("Tilt %f\n", stilt);
  mainWS_setTilt (mainWS, &UxEnv, stilt);
  tiltChanged = False;
}

if (calibrationChanged || firstLook)
{
  cptr = XmTextFieldGetString (UxGetWidget (calibrationText));
  dcal = atof (cptr);
  free (cptr);
  command ("Calibrant %f\n", dcal);
  mainWS_setCal (mainWS, &UxEnv, dcal);
  calibrationChanged = False;
}


if (firstLook) firstLook = False;



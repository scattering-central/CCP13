/*
void setupDialog_put (swidget wgt, Environment *pEnv, char *string)
{
*/
  static char descr[20];
  char peak_label[20], par_label[20], description[20], buf[80], *cptr;
  static int lastpeak = 0;
  int poly_degree, par_number;
  double par_value;

  cptr = strtok (string, " \n");
  if (!cptr)
    {
      return;
    }

#ifndef DESIGN_TIME
   while (*cptr)
     {
       if (strcmp (cptr, "Peak") == 0)
	 {
	   cptr = strtok (NULL, " ");
	   lastpeak = atoi (cptr);
	   cptr = strtok (NULL, " ");
	   sprintf (descr, "Peak %2d", lastpeak);
	   
	   /* Creation of peak_rowColInstance(lastpeak) */
	   peak_rowColInstance[lastpeak] = create_peakRowColumn( form3, descr, cptr);
	   UxPUT_PROPERTY(peak_rowColInstance[lastpeak],x,int,0);
	   UxPUT_PROPERTY(peak_rowColInstance[lastpeak],y,int,current_y);
	   UxPUT_PROPERTY(peak_rowColInstance[lastpeak],width,int,300);
	   UxPUT_PROPERTY(peak_rowColInstance[lastpeak],height,int,30);
	   
	   Interface_UxManage(peak_rowColInstance[lastpeak], &UxEnv );  
	   npeak++;
	   break;
	 }
       
       else if (strcmp (cptr, "Polynomial") == 0)
	 {
	   cptr = strtok (NULL, "=");
	   cptr = strtok (NULL, " ");
	   poly_degree = atoi (cptr);
	   sprintf (buf, "Polynomial background degree  %d", poly_degree);
	   sprintf (descr, "Polynomial");
	   
	   /* Creation of separator */
	   separator = XtVaCreateManagedWidget( "separator",
					       xmSeparatorWidgetClass,
					       form3,
					       XmNwidth, 630,
					       XmNheight, 10,
					       XmNx, 0,
					       XmNy, current_y,
					       NULL );
	   UxPutContext( separator, (char *) UxSetupDialogContext ); 
 
	   /* Creation of labelBack_poly_degree */
	   current_y += 20;
	   labelBack_poly_degree = XtVaCreateManagedWidget( "labelBack_poly_degree",
							   xmLabelWidgetClass,
							   form3,
							   XmNx, 10,
							   XmNy, current_y,
							   XmNwidth, 250,
							   XmNheight, 30,
							   RES_CONVERT( XmNlabelString, buf ),
							   XmNfontList, UxConvertFontList( "8x13bold" ),
							   RES_CONVERT( XmNforeground, "white" ),
							   NULL );
	   UxPutContext( labelBack_poly_degree, (char *) UxSetupDialogContext );
	   break;
	 }

       else if (strcmp (cptr, "Exponential") == 0)
	 {
	   sprintf (descr, "Exponential");
	   /* Creation of labelBack_exp_comp */
	   labelBack_exp_comp = XtVaCreateManagedWidget( "labelBack_exp_comp",
							xmLabelWidgetClass,
							form3,
							XmNx, 10,
							XmNy, current_y,
							XmNwidth, 250,
							XmNheight, 30,
							RES_CONVERT( XmNlabelString, "Exponential background component" ),
							XmNfontList, UxConvertFontList( "8x13bold" ),
							RES_CONVERT( XmNforeground, "white" ),
							NULL );
	   UxPutContext( labelBack_exp_comp, (char *) UxSetupDialogContext );  
	   fexp = 1;
	 }
       
       else if (strcmp (cptr, "Parameter") == 0)
	 {
	   cptr = strtok (NULL, " ");
	   par_number = atoi (cptr);
	   cptr = strtok (NULL, " ");
	   (void) strcpy (par_label, cptr);
	   sprintf (description, "(%s: %s)", descr, par_label);
	   cptr = strtok (NULL, " ");
	   par_value = atof (cptr);
	   sprintf (buf, "%2d  %s:", par_number, par_label);
	   sprintf (par_label, "%g", par_value);
	   
	   /* Creation of par_rowColInstance */
	   par_rowColInstance[par_number] = create_parRowColumn( form3, buf, par_label, description);
	   UxPUT_PROPERTY(par_rowColInstance[par_number],x,int,0);
	   UxPUT_PROPERTY(par_rowColInstance[par_number],y,int,current_y);
	   UxPUT_PROPERTY(par_rowColInstance[par_number],width,int,630);
	   UxPUT_PROPERTY(par_rowColInstance[par_number],height,int,30);
	   
	   Interface_UxManage(par_rowColInstance[par_number], &UxEnv );  
	   npar++;
	   break;
	 }
       else
	 {
	   cptr++;
	 }

     }
   current_y += 40;
   if (current_y > 400)
     {
       XtVaSetValues (UxGetWidget (form3),
		      XmNheight, current_y,
		      NULL);
     }
#endif
/* 
}
End of setupDialog_put  */

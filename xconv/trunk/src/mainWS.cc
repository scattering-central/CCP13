
/*******************************************************************************
	mainWS.cc

       Associated Header file: mainWS.h
*******************************************************************************/
#include <stdio.h>
#include<iostream.h>
#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/Separator.h>
#include <Xm/ToggleB.h>
#include <Xm/RowColumn.h>
#include <Xm/Text.h>
#include <Xm/ScrolledW.h>
#include <Xm/TextF.h>
#include <Xm/PushB.h>
#include <Xm/Label.h>
#include <Xm/SeparatoG.h>
#include <Xm/BulletinB.h>
#include <X11/Shell.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <X11/cursorfont.h>

#include "xpm.h"
#include "xconv.x.pm"

#ifndef DESIGN_TIME
  #include "FileSelection.h"
  #include "ErrorMessage.h"
  #include "QuestionDialog.h"
  #include "InformationDialog.h"

  #include <iostream.h>
  #include <fstream.h>

#ifndef LINUX
  #include <exception.h>
#else
  #include <exception>
#endif

  #include "xerror.h"
  #include "strng.h"
  #include "file.h"
#endif

extern swidget create_FileSelection();
extern swidget create_ErrorMessage();
extern swidget create_QuestionDialog();
extern swidget create_InformationDialog();

swidget FileSelect;
swidget ErrMessage;
swidget QuestDialog;
swidget InfoDialog;

Cursor busyCursor;

char* stripws(char*);

#ifndef DESIGN_TIME

  // Declarations for main conversion routine

  int match(strng[],int,strng&);

  static const int nTypes=24;

static strng psTypes[nTypes]=
{
  strng ("char"),
  strng ("short"),
  strng ("int"),
  strng ("float"),
  strng ("smar"),
  strng ("bmar"),
  strng ("fuji"),
  strng ("fuji2500"),
  strng ("rax2"),
  strng ("psci"),
  strng ("riso"),
  strng ("id2"),
  strng ("id3"),
  strng ("loq_1d"),
  strng ("loq_2d"),
  strng ("smv"),
  strng ("bruker_gfrm"),
  strng ("bruker_asc"),
  strng ("bruker_plosto"),
  strng ("tiff"),
  strng ("mar345"),
  strng ("bsl"),
  strng ("rax4"),
  strng ("ILL_SANS"),
};


  static const int CHAR=0;
  static const int SHORT=1;
  static const int INT=2;
  static const int FLOAT=3;
  static const int SMAR=4;
  static const int BMAR=5;
  static const int FUJI=6;
  static const int FUJI2500=7;
  static const int RAX2=8;
  static const int PSCI=9;
  static const int RISO=10;
  static const int ESRF_ID2=11;
  static const int ESRF_ID3=12;
  static const int LOQ1D=13;
  static const int LOQ2D=14;
  static const int SMV=15;
  static const int BR_GFRM=16;
  static const int BR_ASC=17;
  static const int BR_PLOSTO=18;
  static const int TIF=19;
  static const int MAR345=20;
  static const int BSL=21;
  static const int RAX4=22;
  static const int SANS=23;

  static myBool bSwap,tiffseries;
  static strng sType,sFile,sNthFile,sOutFile,soFile;
  static strng sHead1,sHead2;
  static int nSkip,nInPix,nInRast,nOutPix,nOutRast,nDataType;
  static int nFirst,nLast,nInc,nFrames,indice10,fileNo;
  static double dAspect,dRange;

  static strng gotFile;

#endif


#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#include "mainWS.h"

Widget	mainWS;

/*******************************************************************************
Auxiliary code from the Declarations Editor:
*******************************************************************************/

#ifndef DESIGN_TIME

// *************************************************************
// Match input file type to allowed options
// *************************************************************

int match (strng psOptions[], int nOptions, strng& sSelection)
{
  for (int i = 0; i < nOptions; i++)
    if (psOptions[i] == sSelection)
      return i;
  
  return -1;
}


// *************************************************************
// Strip off leading and trailing whitespace in a string
// *************************************************************

char* stripws(char* pptr)
{
  int iflag;

// Strip off leading white space

  iflag=0;
  do
    {
      if(isspace((int)pptr[0]))
	pptr++;
      else
	iflag=1;
    }while(!iflag);

  // Strip off trailing spaces
  
  iflag=0;
  do
    {
      if(isspace((int)pptr[strlen(pptr)-1]))
      pptr[strlen(pptr)-1]='\0';
      else
	iflag=1;
    }while(!iflag);
  
  return pptr;
}

// *************************************************************
// Build icon pixmap
// *************************************************************


static void SetIconImage(Widget wgt)
{
    Pixmap iconmap;
    Screen *screen=XtScreen(wgt);
    Display *dpy=XtDisplay(wgt);
    
    XpmCreatePixmapFromData(dpy,RootWindowOfScreen(screen),xconv_x_pm,&iconmap,NULL,NULL);
    XtVaSetValues(wgt,XmNiconPixmap,iconmap,NULL);
}


#endif

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

int _UxCmainWS::SaveProfile( Environment * pEnv, char *error )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
#ifndef DESIGN_TIME

	const char* pptr;
	if((pptr=strrchr(gotFile.data(),(int)'/'))==NULL)
	  pptr=gotFile.data();
	else
	  pptr++;

	ofstream out_profile(gotFile.data(),ios::out);
	if(out_profile.bad())
	{
	  strcpy(error,"Error opening output file");
	  return 0;
	}
	else
	{
	  out_profile<<"Xconv v1.0 profile"<<endl
	             <<pptr<<endl
	             <<sType.data()<<endl;

	  if(SaveInPix)
	    out_profile<<nInPix<<endl;
	  else
	    out_profile<<endl;

	  if(SaveInRast)
	    out_profile<<nInRast<<endl;
	  else
	    out_profile<<endl;

	  if(SaveSkip)
	    out_profile<<nSkip<<endl;
	  else
	    out_profile<<endl;

	  if(SaveAspect)
	    out_profile<<dAspect<<endl;
	  else
	    out_profile<<endl;

	   if(SaveRange)
	    out_profile<<dRange<<endl;
	  else
	    out_profile<<endl;

	 if(SaveOutPix)
	    out_profile<<nOutPix<<endl;
	  else
	    out_profile<<endl;

	  if(SaveOutRast)
	    out_profile<<nOutRast<<endl;
	  else
	    out_profile<<endl;

	  if(bSwap)
	    out_profile<<1<<endl;
	  else
	    out_profile<<0<<endl;

	  return 1;
	}
#endif
}

void _UxCmainWS::UpdateRun( Environment * pEnv )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	XtVaSetValues(UxGetWidget(firstField),XmNvalue,firstptr,NULL);
	XtVaSetValues(UxGetWidget(lastField),XmNvalue,lastptr,NULL);
	XtVaSetValues(UxGetWidget(incField),XmNvalue,incptr,NULL);
}

void _UxCmainWS::UpdateOutFields( Environment * pEnv )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	XtVaSetValues(UxGetWidget(outpixField),XmNvalue,outpixptr,NULL);
	XtVaSetValues(UxGetWidget(outrastField),XmNvalue,outrastptr,NULL);
}

int _UxCmainWS::Convert( Environment * pEnv, char *error )
{
  if (pEnv)
    pEnv->_major = NO_EXCEPTION;
#ifndef DESIGN_TIME
  
  // *************************************************************
  // Create input and output file objects and perform conversion
  // *************************************************************
  
  try
    {
      BSLHeader* pHeader;
      BinaryOutFile* pBinary;
      InConvFile* pInFile;
      tiffOutFile* tifffile;
       txtOutFile* txtfile;
      int j;
	   if(dtype>10)
	 {
		 soFile=sOutFile;
		 int nOff; 
		 if ((nOff = soFile.find("#")) != NPS)
		 {
			 tiffseries=1;
		 }
		 else
		 {	 tiffseries=0;
		 }
	 }
	   
	   // Loop over run numbers
      



      for (int i = nFirst; i <= nLast; i += nInc)
	{
	  // Get file name for this run number
	  
	  sNthFile = InConvFile::getNthFileName (sFile, i);
	  
	  // Create an input binary/text file object of the required type
	  
	  switch(match(psTypes,nTypes,sType))
	    {
	    case CHAR: // unsigned char
	      pInFile=new BinInFile<unsigned char>(sNthFile.data(),nInPix,nInRast,bSwap,nSkip,dAspect);
	      break;
	   case SHORT: // unsigned short
	      pInFile=new BinInFile<unsigned short>(sNthFile.data(),nInPix,nInRast,bSwap,nSkip,dAspect);
	      break;
	      
	    case INT: // unsigned int
	      pInFile=new BinInFile<unsigned int>(sNthFile.data(),nInPix,nInRast,bSwap,nSkip,dAspect);
	      break;

	    case FLOAT: // float
	      pInFile=new BinInFile<float>(sNthFile.data(),nInPix,nInRast,bSwap,nSkip,dAspect);
	      break;
	      
	    case SMAR: // small MAR (1200 x 1200)
	      pInFile = new SMarInFile (sNthFile.data (), bSwap);
	      break;

	    case BMAR: // big MAR (2000 x 2000)
	      pInFile = new BMarInFile (sNthFile.data (), bSwap);
	      break;

	    case FUJI: // Fuji image plate
	      pInFile = new FujiInFile (sNthFile.data (), bSwap, dRange);
	      break;
	      
	    case FUJI2500: // BAS2500 Fuji image plate
	      pInFile = new Fuji2500InFile (sNthFile.data (), bSwap);
	      break;

	    case RAX2: // R-Axis II
	      pInFile = new RAxisInFile (sNthFile.data (), bSwap);
	      break;
	    case RAX4: // R-Axis 4
 	      pInFile = new RAxis4InFile (sNthFile.data (), bSwap);
	      break;
	    case PSCI: // Photonics Science CCD
	      pInFile = new PSciInFile (sNthFile.data (), bSwap);
	      break;
	    case RISO: // Riso file format
	      pInFile = new RisoInFile (sNthFile.data ());
	      if(strlen(XmTextGetString(header1Text))==0)
		{
		  sHead1=strng(pInFile->GetTitle());
		}
	      break;
	    case ESRF_ID2: // MAR CCD ESRF_ID2
	      pInFile = new MARInFile (sNthFile.data ());
	      break;
	    case MAR345://MAR345
	      pInFile = new Mar345InFile (sNthFile.data ());
	      break;
	    case ESRF_ID3://ESRF ID3
	      pInFile = new TiffInFile (sNthFile.data (),0);
	      break;
	    case LOQ1D: //log ID image
	      pInFile = new LOQ1dInFile (sNthFile.data (),0);
	      break;
	    case LOQ2D://log 2D image
	      pInFile = new LOQ2dInFile (sNthFile.data (),0);
	      break;
	    case SMV: //smv format
	      pInFile = new SMVInFile (sNthFile.data ());
	      break;
	    case BR_GFRM:
	       pInFile =new BrukerInFile (sNthFile.data ());
	       break;
	    case   BR_ASC:
	      pInFile =new BrukerAscInFile (sNthFile.data ());
	      break;
	      /*
		case   BR_PLOSTO:
		pInFile =new BrukerPLOSTOInFile (sNthFile.data ());
		break;*/
	     case   BSL: //BSl file
	       pInFile =new BslInFile(sNthFile.data (),0,0);
	       break;
	case SANS: // sans file format
			pInFile =new SANSInFile (sNthFile.data (),0);                
			// pInFile = new TiffInFile (sNthFile.data (),0);
			 break;
			 
	    case TIF: // Tif file format
	                 pInFile = new TiffInFile (sNthFile.data (),0);
			 break;
			 
	    default:
	                strcpy(error,"No matching file format: ");
	                strcat(error,sType.data());
	                return 0;
	    }

#ifndef SOLARIS
	  if (pInFile == NULL)
	    {
	      strcpy(error,"Error allocating memory");
	        return 0;
	    }
	    #endif
	  
	   if(dtype<10){
	     
		  if (i == nFirst)
	    	{

				// Get the number of pixels from input file object if
		     // none were specified from the command line
		   	 if (nOutPix == 0)
		       {
		        nOutPix = pInFile->pixels ();
			   }
		    // Calculate number of rasters if necessary
		     if (nOutRast == 0)
	          {
		       nOutRast = pInFile->rasters (nOutPix);
	          }
		    //pInFile->putcurrentdir(0);
		    // Create BSL header and binary file objects
		     nFrames = (nLast - nFirst + nInc) / nInc;

		    //tiff multi frame image 
		     if (match(psTypes,nTypes,sType)==TIF &&nFrames==1)
		      {
		     
				  nFrames=pInFile->getdircount();
			
		      pHeader = new BSLHeader(sOutFile.data(),nOutPix,nOutRast,dtype,nFrames,sHead1.data(),sHead2.data(),0);
			//  AfxMessageBox(pHeader->binaryName ().data());
			  pBinary = new BinaryOutFile ((pHeader->binaryName ()).data ());
		     
		       for ( j=0; j<(nFrames-1);j++)
		         {
				 pInFile->putdtype(dtype);
				 pInFile->convert (*pHeader, *pBinary);
				 delete pInFile;
				 pInFile = new TiffInFile(sNthFile.data (),(j+1));
				 }
			   }
               // BSL multi frame image 
		      else if (match(psTypes,nTypes,sType)==BSL &&nFrames==1)
		      {
			   int bslcount;
			   bslcount=0;
			   nFrames=pInFile->getdircount();
		       indice10 =  pInFile->bslind();
			   fileNo =pInFile->bslfilNo();
			   pHeader = new BSLHeader(sOutFile.data(),nOutPix,nOutRast,dtype,nFrames,sHead1.data(),sHead2.data(),indice10);
		   	   pBinary = new BinaryOutFile ((pHeader->binaryName ()).data ());
		       
			   while(indice10!=0)
			   {

	            for (  j=0; j<(nFrames-1);j++)
				  {
				   pInFile->putdtype(dtype);
				   pInFile->convert (*pHeader, *pBinary);
				   delete pInFile;
				   pInFile = new  BslInFile(sNthFile.data (),(j+1),bslcount);
		   		  }
				  pInFile->putdtype(dtype);
                  pInFile->convert (*pHeader, *pBinary);
			      delete pInFile;
			      delete pBinary;
				  bslcount++;
				  pInFile = new  BslInFile(sNthFile.data (),0,bslcount);
				  //pInFile = new  BslInFile(sNthFile.data (),(j+1),1);
				  nFrames=pInFile->getdircount();
		          indice10 =  pInFile->bslind();
			      fileNo =pInFile->bslfilNo();
				  nOutPix = pInFile->pixels ();
			      nOutRast = pInFile->rasters (nOutPix);
				  pHeader->WriteHeader(nOutPix,nOutRast,dtype,nFrames,indice10,fileNo);
				  pBinary = new BinaryOutFile ((pHeader->binaryName ()).data ());
			   }
				  for (  j=0; j<(nFrames-1);j++)
				  {
				   pInFile->putdtype(dtype);
				   pInFile->convert (*pHeader, *pBinary);
				   delete pInFile;
				   pInFile = new  BslInFile(sNthFile.data (),(j+1),bslcount);
		   		  }

			   
		       }
			  //////////////////////////LOQ file///////////////////////
			  else if ((match(psTypes,nTypes,sType)==LOQ1D||match(psTypes,nTypes,sType)==LOQ2D)&&nFrames==1)
				
		      {
               pHeader = new BSLHeader(sOutFile.data(),nOutPix,nOutRast,dtype,nFrames,sHead1.data(),sHead2.data(),1);
		   	   pBinary = new BinaryOutFile ((pHeader->binaryName ()).data ());
			   pInFile->putdtype(dtype);
			   pInFile->convert (*pHeader, *pBinary);
			   delete pInFile;
			   delete pBinary;
			    //error of intensities file 3-for error file
				if (match(psTypes,nTypes,sType)==LOQ1D)
			   {
				 pInFile = new LOQ1dInFile (sNthFile.data (),3);
			   }else //LOQ2D
			   {
				 pInFile = new LOQ2dInFile (sNthFile.data (),3);
			   }
               nOutPix = pInFile->pixels ();
			   nOutRast = pInFile->rasters (nOutPix);
			   pHeader->WriteHeader(nOutPix,nOutRast,dtype,nFrames,0,2);
			   pBinary = new BinaryOutFile ((pHeader->binaryName ()).data ());
			   pInFile->putdtype(dtype);
			   pInFile->convert (*pHeader, *pBinary);
			   delete pInFile;
			   delete pBinary;
			   delete pHeader;
			   //create calibration file 2-for calibration  
			   if (match(psTypes,nTypes,sType)==LOQ1D)
			   {
				 pInFile = new LOQ1dInFile (sNthFile.data (),2);
			   }else //LOQ2D
			   {
				 pInFile = new LOQ2dInFile (sNthFile.data (),2);
			   }
			   nOutPix = pInFile->pixels ();
			   nOutRast = pInFile->rasters (nOutPix);
			   pHeader = new BSLHeader(InConvFile::getQAxFileName(sOutFile.data()).data(),nOutPix,nOutRast,dtype,nFrames,sHead1.data(),sHead2.data(),0);
		   	   pBinary = new BinaryOutFile ((pHeader->binaryName ()).data ()); 			 
			 
			  } 
			   //////////////////////////SANSfile///////////////////////
			   else if (match(psTypes,nTypes,sType)==SANS&&nFrames==1)
				
		      {
			   int error,dim;
               dim=pInFile->rasters();
			   error=pInFile->bslfilNo();			  
				if(error==0)
				{
					pHeader = new BSLHeader(sOutFile.data(),nOutPix,nOutRast,dtype,nFrames,sHead1.data(),sHead2.data(),0);
					pBinary = new BinaryOutFile ((pHeader->binaryName ()).data ());
				} 
				 else
  				{
				    pHeader = new BSLHeader(sOutFile.data(),nOutPix,nOutRast,dtype,nFrames,sHead1.data(),sHead2.data(),1);
		   			pBinary = new BinaryOutFile ((pHeader->binaryName ()).data ());
			        pInFile->putdtype(dtype);
				    pInFile->convert (*pHeader, *pBinary);
				    delete pInFile;
				    delete pBinary;
					pInFile = new SANSInFile (sNthFile.data (),3);
			        nOutPix = pInFile->pixels ();
			        nOutRast = pInFile->rasters (nOutPix);
					pHeader->WriteHeader(nOutPix,nOutRast,dtype,nFrames,0,2);
					pBinary = new BinaryOutFile ((pHeader->binaryName ()).data ());

				}
				if(dim==1)
				{
			    pInFile->putdtype(dtype);
			    pInFile->convert (*pHeader, *pBinary);
			    delete pInFile;
			    delete pBinary;
			    delete pHeader;
                pInFile = new SANSInFile (sNthFile.data (),2);
			    nOutPix = pInFile->pixels ();
			    nOutRast = pInFile->rasters (nOutPix);
			    pHeader = new BSLHeader(InConvFile::getQAxFileName(sOutFile.data()).data(),nOutPix,nOutRast,dtype,nFrames,sHead1.data(),sHead2.data(),0);
		   	    pBinary = new BinaryOutFile ((pHeader->binaryName ()).data ());
				 }	 
			  } ////////////////////////////

		      else
  			  {
		      pHeader = new BSLHeader(sOutFile.data(),nOutPix,nOutRast,dtype,nFrames,sHead1.data(),sHead2.data(),0);
		      pBinary = new BinaryOutFile ((pHeader->binaryName ()).data ());
		  	  }  
		  
		  }
	      // Convert
	      pInFile->putdtype(dtype);
	      pInFile->convert (*pHeader, *pBinary);
          delete pInFile;
	  }
	  else //convert to tiff image 
      {
	   if (i == nFirst)
		 {
		  // Get the number of pixels from input file object if
	  	  // none were specified from the command line
		   if (nOutPix == 0)
 		   {
	       	nOutPix = pInFile->pixels ();
		    }
	      // Calculate number of rasters if necessary
		   if (nOutRast == 0)
		   {
	         nOutRast = pInFile->rasters (nOutPix);
		    }
		   if(dtype==10)
			{
			txtfile = new txtOutFile(sOutFile.data(),nOutPix,nOutRast);  
			}
		   else{
		     if(tiffseries==1)
		 	 {
		 	 sOutFile=InConvFile::getNthFileName (soFile, 1);
		     }
			 tifffile = new tiffOutFile(sOutFile.data(),nOutPix,nOutRast);  
			 }

		   nFrames = (nLast - nFirst + nInc) / nInc;  
		  
         //tiff multi frame image 
		   if (match(psTypes,nTypes,sType)==TIF &&nFrames==1)
		     {
		       nFrames=pInFile->getdircount();

		       for ( j=0; j<(nFrames-1);j++)
	           {
			     pInFile->putdtype(dtype);
			     if(dtype==10)
			     {
			      pInFile->convert(*txtfile);
			     }
			     else{
				 pInFile->convert(*tifffile);
			      }

			     if(tiffseries==1)
				 {
					 delete  tifffile;					
					 sOutFile=InConvFile::getNthFileName (soFile, j+2);
					 tifffile = new tiffOutFile(sOutFile.data(),nOutPix,nOutRast);  
					
				 }
			   delete pInFile;
			   pInFile = new TiffInFile(sNthFile.data (),(j+1));
			   }
			 }
		  //BSL multi frame image 
		   else if (match(psTypes,nTypes,sType)==BSL &&nFrames==1)
		     {
		      int bslcount;
			   bslcount=0;
			   nFrames=pInFile->getdircount();
		       indice10 =  pInFile->bslind();
			   fileNo =pInFile->bslfilNo();
			   	       
			   while(indice10!=0)
			   {

	            for (  j=0; j<(nFrames-1);j++)
				  {
				     pInFile->putdtype(dtype);
				     if(dtype==10)
					 {
					 pInFile->convert(*txtfile);
					 }
					 else
					 {
					  pInFile->convert(*tifffile);
				     }

				     if(tiffseries==1)
				     {
					  delete  tifffile;
					 sOutFile=InConvFile::getNthFileName (soFile, j+2);
					 tifffile = new tiffOutFile(sOutFile.data(),nOutPix,nOutRast);  
					
					 }
				     delete pInFile;
				     pInFile = new  BslInFile(sNthFile.data (),(j+1),bslcount);
				  }
			      pInFile->putdtype(dtype);
                  if(dtype==10)
				  {
				  pInFile->convert(*txtfile);
				  }
			      else{
				  pInFile->convert(*tifffile);
				  }
				  if(tiffseries==1)
				  {
					  delete  tifffile;
					 sOutFile=InConvFile::getNthFileName (soFile, j+2);
					 tifffile = new tiffOutFile(sOutFile.data(),nOutPix,nOutRast);  
					 
					}
			      delete pInFile;
			    
				  bslcount++;
				  pInFile = new  BslInFile(sNthFile.data (),0,bslcount);
				  nFrames=pInFile->getdircount();
		          indice10 =  pInFile->bslind();
			      fileNo =pInFile->bslfilNo();
				  nOutPix = pInFile->pixels ();
			      nOutRast = pInFile->rasters (nOutPix);
			   }
			  for (  j=0; j<(nFrames-1);j++)
			   {
			     pInFile->putdtype(dtype);
			    if(dtype==10)
			 	{
				 pInFile->convert(*txtfile);
				 }
				 else
				 {
			     pInFile->convert(*tifffile);
				 }
				  if(tiffseries==1)
				 {
					 delete  tifffile;
					 sOutFile=InConvFile::getNthFileName (soFile, j+2);
					 tifffile = new tiffOutFile(sOutFile.data(),nOutPix,nOutRast);  
					 
					}
				   delete pInFile;
				   pInFile = new  BslInFile(sNthFile.data (),(j+1),bslcount);
			   }
				 
			 }
		     //////////////////////////LOQ file///////////////////////
		   else if ((match(psTypes,nTypes,sType)==LOQ1D||match(psTypes,nTypes,sType)==LOQ2D)&&nFrames==1)
				
		      {
                 pInFile->putdtype(dtype);
			 if(dtype==10)
			 {
			 pInFile->convert(*txtfile);
			 }
			 else{
		      pInFile->convert(*tifffile);
			 }
			 
			   
			   //create calibration file 2-for calibration  
			   if (match(psTypes,nTypes,sType)==LOQ1D)
			   {
				 pInFile = new LOQ1dInFile (sNthFile.data (),2);
			   }else //LOQ2D
			   {
				 pInFile = new LOQ2dInFile (sNthFile.data (),2);
			   }
			   nOutPix = pInFile->pixels ();
			   nOutRast = pInFile->rasters (nOutPix);
			  
			   if(dtype==10)
			 {
			 pInFile->convert(*txtfile);
			 }
			 else{
		      pInFile->convert(*tifffile);
			 }
			   delete pInFile;
			   
			   
			  //error of intensities file 3-for error file
				if (match(psTypes,nTypes,sType)==LOQ1D)
			   {
				 pInFile = new LOQ1dInFile (sNthFile.data (),3);
			   }else //LOQ2D
			   {
				 pInFile = new LOQ2dInFile (sNthFile.data (),3);
			   }
               nOutPix = pInFile->pixels ();
			   nOutRast = pInFile->rasters (nOutPix);
				 
			  } 
			   //////////////////////////SANSfile///////////////////////
		    else if (match(psTypes,nTypes,sType)==SANS&&nFrames==1)
				
		      {
			  int error,dim;
               dim=pInFile->rasters();
			   error=pInFile->bslfilNo();			  
				
				
				pInFile->putdtype(dtype);
			 if(dtype==10)
			 {
			 pInFile->convert(*txtfile);
			 }
			 else{
		      pInFile->convert(*tifffile);
			 }
				delete pInFile;
				
			
			   
			  if(dim==1)
			  {
			   pInFile = new SANSInFile (sNthFile.data (),2);
			   nOutPix = pInFile->pixels ();
			   nOutRast = pInFile->rasters (nOutPix);
			 
			  }else if(error==1)
			  {
				pInFile = new SANSInFile (sNthFile.data (),2);
			   nOutPix = pInFile->pixels ();
			   nOutRast = pInFile->rasters (nOutPix);
			   
			  }

			  if((dim==1)&&(error==1))
			  {
				pInFile->putdtype(dtype);
			  if(dtype==10)
			 {
			 pInFile->convert(*txtfile);
			 }
			 else{
		      pInFile->convert(*tifffile);
			 }
			   delete pInFile;
			  

			   pInFile = new SANSInFile (sNthFile.data (),3);
			   nOutPix = pInFile->pixels ();
			   nOutRast = pInFile->rasters (nOutPix);
			  }
	 
			  } ////////////////////////////

		      }
		    pInFile->putdtype(dtype);
		     if(dtype==10)
			 {
			 pInFile->convert(*txtfile);
			 }
			 else{
		      pInFile->convert(*tifffile);
			 }
		          if(tiffseries==1&& i<nLast)
				 {
					 delete  tifffile;
					 sOutFile=InConvFile::getNthFileName (soFile, i+2);
					 tifffile = new tiffOutFile(sOutFile.data(),nOutPix,nOutRast);  
					
					}
                   delete pInFile;
	     }
		 }
	
					inpixptr = new char[10];
	                 inrastptr = new char[10];
	                 sprintf(inpixptr,"%d",nOutPix);
	                 sprintf(inrastptr,"%d",nOutRast);
	                 XtVaSetValues(UxGetWidget(outpixField),XmNvalue,inpixptr,NULL);
	                 XtVaSetValues(UxGetWidget(outrastField),XmNvalue,inrastptr,NULL);
					 sprintf(inpixptr,"%d",pInFile->pixels());
	                 sprintf(inrastptr,"%d",pInFile->rasters());
	                 XtVaSetValues(UxGetWidget(inpixField),XmNvalue,inpixptr,NULL);
	                 XtVaSetValues(UxGetWidget(inrastField),XmNvalue,inrastptr,NULL);
	                 delete[] inpixptr;
	                 delete[] inrastptr;

    if(dtype<10)
     {
     delete pHeader;
	 delete pBinary;
     }
    else if(dtype==10)
	 {
	 delete txtfile;
	 }
	 else{
		 delete tifffile;  
	 }
    
  }
  
  catch (XError& xerr)
    {
      sprintf(error,"Exception thrown: %s",xerr.sReason.data());
	    return 0;
    }
  
#ifdef SOLARIS
	  catch (xalloc& e)
	    {
	      strcpy(error,"Error allocating memory");
	      return 0;
	    }
#endif

	return 1;
	
#endif
}

int _UxCmainWS::CheckOutFile( Environment * pEnv, char *sptr, char *error, Boolean bsl )
{
  if (pEnv)
		pEnv->_major = NO_EXCEPTION;
#ifndef DESIGN_TIME
  
  // **********************************************************************
  // Check that output file has been specified
  // and is writable and a valid BSL filename
  // **********************************************************************

  if(strlen(sptr)==0)
    {
      strcpy(error,"Output file not specified");
      return 0;
    }
  else if(bsl&&!mainWS_Legalbslname(mainWS,&UxEnv,sptr))
    {
      strcpy(error,"Output file: Invalid header filename");
      return 0;
    }
  else if(access(sptr,F_OK)==-1)
    {
      char*mptr,*pptr;
      mptr=new char[strlen(sptr)+1];
      strcpy(mptr,sptr);
      pptr=strrchr(mptr,'/');
      
      if(pptr!=NULL)
	mptr[strlen(sptr)-strlen(pptr)+1]='\0';
      else
	strcpy(mptr,"./");

      if(access(mptr,W_OK)==-1)
	  {
	    strcpy(error,"Output file: ");
	    strcat(error,strerror(errno));
	    delete[] mptr;
	    return 0;
	  }
      else
	{
	  delete[] mptr;
	}
	}
  else if(access(sptr,W_OK)==-1)
    {
      strcpy(error,"Output file: ");
      strcat(error,strerror(errno));
      return 0;
    }
  else
    {
	  char *jptr;
	  jptr=new char[80];
	  strcpy(jptr,"");
	  struct stat buf;
	  if(strchr(sptr,(int)'/')==NULL)
	    strcat(jptr,"./");
	  strcat(jptr,sptr);
	  stat(jptr,&buf);
	  if(S_ISDIR(buf.st_mode))
	  {
	    strcpy(error,"Selection is a directory");
	    delete[] jptr;
	    return 0;
	  }
	  else
	  {
	    delete[] jptr;
	  }
	}
	return 1;

#endif
}

void _UxCmainWS::UpdateData( Environment * pEnv )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	XtVaSetValues(UxGetWidget(datalabel),XmNlabelString,XmStringCreateSimple(dataptr),NULL);
}

void _UxCmainWS::Help( Environment * pEnv )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
#ifndef DESIGN_TIME

	char *helpString;
	helpString=new char[80];

	strcpy(helpString,"netscape -raise -remote ");

	if (ccp13ptr)
	{
	  strcat(helpString," 'openFile (");
	}
	else
	{
	  strcat(helpString," 'openURL (");
	}

	strcat(helpString,helpfile);
	strcat(helpString,")'");

	if ((system (helpString) == -1))
	{
	  ErrorMessage_set(ErrMessage,&UxEnv,"Error opening netscape browser");
	  UxPopupInterface(ErrMessage,no_grab);
	}

	delete[] helpString;

#endif
}

void _UxCmainWS::FieldsEditable( Environment * pEnv, int i )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	XtVaSetValues(UxGetWidget(inpixField),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(inrastField),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(skipField),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(aspectField),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(inpixlabel),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(inrastlabel),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(skiplabel),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(aspectlabel),XmNsensitive,i,NULL);
	if(!strcmp(sType.data(),"id2")||
	   !strcmp(sType.data(),"id3")||
	   !strcmp(sType.data(),"loq_1d")||
	   !strcmp(sType.data(),"loq_2d")||
	   !strcmp(sType.data(),"smv")||
	   !strcmp(sType.data(),"bruker_gfrm")||
	   !strcmp(sType.data(),"bruker_asc")||
	   !strcmp(sType.data(),"bruker_plosto")||
	   !strcmp(sType.data(),"mar345")||
	   !strcmp(sType.data(),"tiff")||
	   !strcmp(sType.data(),"ILL_SANS")||
	   !strcmp(sType.data(),"bsl")
	   )
	XtVaSetValues(UxGetWidget(toggleButton1),XmNsensitive,0,NULL);
	else
	XtVaSetValues(UxGetWidget(toggleButton1),XmNsensitive,1,NULL);

	XtVaSetValues(UxGetWidget(inpixField),XmNcursorPositionVisible,i,NULL);
	XtVaSetValues(UxGetWidget(inrastField),XmNcursorPositionVisible,i,NULL);
	XtVaSetValues(UxGetWidget(skipField),XmNcursorPositionVisible,i,NULL);
	XtVaSetValues(UxGetWidget(aspectField),XmNcursorPositionVisible,i,NULL);
}
void _UxCmainWS::FieldsEditable_out( Environment * pEnv, int i )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	XtVaSetValues(UxGetWidget(optionMenu2),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(label6),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(label19),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(header1Text),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(label20),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(header2Text),XmNsensitive,i,NULL);
}
int _UxCmainWS::GetProfile( Environment * pEnv, char *error )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
#ifndef DESIGN_TIME
	char *sptr,*strptr;
	int i,iflag;

	if(!strcmp(sType.data(),"smar")||
	   !strcmp(sType.data(),"bmar")||
	   !strcmp(sType.data(),"fuji")||
	   !strcmp(sType.data(),"rax2")||
	   !strcmp(sType.data(),"rax4")||
	   !strcmp(sType.data(),"id2")||
	   !strcmp(sType.data(),"id3")||
	   !strcmp(sType.data(),"loq_1d")||
	   !strcmp(sType.data(),"loq_2d")||
	   !strcmp(sType.data(),"smv")||
	   !strcmp(sType.data(),"bruker_gfrm")||
	   !strcmp(sType.data(),"bruker_asc")||
	   !strcmp(sType.data(),"bruker_plosto")||
	   !strcmp(sType.data(),"mar345")||
	   !strcmp(sType.data(),"tiff")||
	   !strcmp(sType.data(),"bsl")||
	   !strcmp(sType.data(),"ILL_SANS")||
	   !strcmp(sType.data(),"psci"))
	{
	  SaveInPix=0;
	  SaveInRast=0;
	  SaveSkip=0;
	  SaveAspect=0;
	}
	else
	{

	  // **********************************************************************
	  // Check input pixels,rasters
	  // **********************************************************************

	  strptr=XmTextFieldGetString(inpixField);
	  sptr=stripws(strptr);
	  nInPix=atoi(sptr);
	  if(strlen(sptr)==0)
	  {
	    SaveInPix=0;
	  }
	  else
	  {
	    for(i=0;i<strlen(sptr);i++)
	    {
	      if(sptr[i]=='.')
	      {
	        strcpy(error,"Input pixels: Integer value expected");
	        XtFree(strptr);
	        return 0;
	      }
	      else if(!isdigit(sptr[i])||nInPix<=0)
	      {
	        strcpy(error,"Invalid number of input pixels");
	        XtFree(strptr);
	        return 0;
	      }
	    }
	  SaveInPix=1;
	  }
	  XtFree(strptr);

	  strptr=XmTextFieldGetString(inrastField);
	  sptr=stripws(strptr);
	  nInRast=atoi(sptr);
	  if(strlen(sptr)==0)
	  {
	    SaveInRast=0;
	  }
	  else
	  {
	    for(i=0;i<strlen(sptr);i++)
	    {
	      if(sptr[i]=='.')
	      {
	        strcpy(error,"Input rasters: Integer value expected");
	        XtFree(strptr);
	        return 0;
	      }
	      else if(!isdigit(sptr[i])||nInRast<=0)
	      {
	        strcpy(error,"Invalid number of input rasters");
	        XtFree(strptr);
	        return 0;
	      }
	    }
	  SaveInRast=1;
	  }
	  XtFree(strptr);



	  // **********************************************************************
	  // Check bytes to skip
	  // **********************************************************************

	  strptr=XmTextFieldGetString(skipField);
	  sptr=stripws(strptr);
	  nSkip=atoi(sptr);
	  if(strlen(sptr)==0)
	  {
	    SaveSkip=0;
	  }
	  else
	  {
	    for(i=0;i<strlen(sptr);i++)
	    {
	      if(sptr[i]=='.')
	      {
	        strcpy(error,"Bytes to skip: Integer value expected");
	        XtFree(strptr);
	        return 0;
	      }
	      else if(!isdigit(sptr[i])||nSkip<0)
	      {
	        strcpy(error,"Invalid number of bytes to skip");
	        XtFree(strptr);
	        return 0;
	      }
	    }
	  SaveSkip=1;
	  }
	  XtFree(strptr);


	  // **********************************************************************
	  // Check aspect ratio
	  // **********************************************************************

	  strptr=XmTextFieldGetString(aspectField);
	  sptr=stripws(strptr);
	  dAspect=atof(sptr);
	  if(strlen(sptr)==0)
	  {
	    SaveAspect=0;
	  }
	  else if(dAspect<=0.)
	  {
	    strcpy(error,"Invalid aspect ratio");
	    XtFree(strptr);
	    return 0;
	   }
	  else
	  {
	    iflag=0;
	    for(i=0;i<strlen(sptr);i++)
	    {
	      if(!isdigit(sptr[i]))
	      {
	        if(sptr[i]="."&&!iflag)
	          iflag=1;
	        else
	        {
	          strcpy(error,"Invalid aspect ratio");
	          XtFree(strptr);
	          return 0;
	        }
	      }
	    }
	  SaveAspect=1;
	  }
	  XtFree(strptr);
	}

	if(!strcmp(sType.data(),"fuji"))
	{
	  // **********************************************************************
	  // Check dynamic range
	  // **********************************************************************

	  strptr=XmTextFieldGetString(rangeField);
	  sptr=stripws(strptr);
	  dRange=atof(sptr);
	  if(strlen(sptr)==0)
	  {
	    SaveRange=0;
	  }
	  else if(dRange<=0.)
	  {
	    strcpy(error,"Invalid dynamic range");
	    XtFree(strptr);
	    return 0;
	   }
	   else
	   {
	     iflag=0;
	     for(i=0;i<strlen(sptr);i++)
	     {
	       if(!isdigit(sptr[i]))
	       {
	         if(sptr[i]="."&&!iflag)
	           iflag=1;
	         else
	         {
	           strcpy(error,"Invalid dynamic range");
	           XtFree(strptr);
	           return 0;
	         }
	      }
	    }
	    SaveRange=1;
	    }
	    XtFree(strptr);
	}
	else
	  SaveRange=0;


	// **********************************************************************
	// Check output pixels,rasters
	// **********************************************************************

	strptr=XmTextFieldGetString(outpixField);
	sptr=stripws(strptr);
	nOutPix=atoi(sptr);
	if(strlen(sptr)==0)
	{
	  SaveOutPix=0;
	}
	else
	{
	  for(i=0;i<strlen(sptr);i++)
	  {
	    if(sptr[i]=='.')
	    {
	      strcpy(error,"Output pixels: Integer value expected");
	      XtFree(strptr);
	      return 0;
	    }
	    else if(!isdigit(sptr[i])||nOutPix<=0)
	    {
	      strcpy(error,"Invalid number of output pixels");
	      XtFree(strptr);
	      return 0;
	    }
	  }
	SaveOutPix=1;
	}
	XtFree(strptr);

	strptr=XmTextFieldGetString(outrastField);
	sptr=stripws(strptr);
	nOutRast=atoi(sptr);
	if(strlen(sptr)==0)
	{
	  SaveOutRast=0;
	}
	else
	{
	  for(i=0;i<strlen(sptr);i++)
	  {
	    if(sptr[i]=='.')
	    {
	      strcpy(error,"Output rasters: Integer value expected");
	      XtFree(strptr);
	      return 0;
	    }
	    else if(!isdigit(sptr[i])||nOutRast<=0)
	    {
	      strcpy(error,"Invalid number of output rasters");
	      XtFree(strptr);
	      return 0;
	    }
	  }
	SaveOutRast=1;
	}
	XtFree(strptr);



	// **********************************************************************
	// Get swap option
	// **********************************************************************

	if(XmToggleButtonGetState(toggleButton1))
	  bSwap=IS_TRUE;
	else
	  bSwap=IS_FALSE;


	// **********************************************************************
	// If everything OK return 1
	// **********************************************************************

	return 1;

#endif
}

void _UxCmainWS::UpdateFields( Environment * pEnv )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	XtVaSetValues(UxGetWidget(inpixField),XmNvalue,inpixptr,NULL);
	XtVaSetValues(UxGetWidget(inrastField),XmNvalue,inrastptr,NULL);
	XtVaSetValues(UxGetWidget(skipField),XmNvalue,skptr,NULL);
	XtVaSetValues(UxGetWidget(aspectField),XmNvalue,asptr,NULL);
	XtVaSetValues(UxGetWidget(rangeField),XmNvalue,rangeptr,NULL);
}

Boolean _UxCmainWS::Legalbslname( Environment * pEnv, char *fptr )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	char *sptr;
	int i;


	/* Strip off path */
	sptr=strrchr(fptr,'/');
	if(sptr!=NULL)
	{
	  fptr=++sptr;
	}



	if(strlen(fptr)!=10)
	{
	  return(FALSE);
	}

	if(isalpha((int)fptr[0]) && isdigit((int)fptr[1]) && isdigit((int)fptr[2]))
	{
	  if (strstr(fptr,"000.")!=fptr+3)
	  {
	    return(FALSE);
	  }
	}
	else
	{
	  return(FALSE);
	}

	if(isalnum((int)fptr[7]) && isalnum((int)fptr[8]) && isalnum((int)fptr[9]))
	{
	  return(TRUE);
	}
	else
	{
	  return(FALSE);
	}
}

int _UxCmainWS::CheckInFile( Environment * pEnv, char *sptr, char *error, Boolean multiple, Boolean bsl )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
#ifndef DESIGN_TIME

	// **********************************************************************
	// Check that input files have been specified
	// and are readable
	// **********************************************************************

	int i;
	char c1,c2;
	c1='#';
	c2='%';

	if(strlen(sptr)==0)
	{
	  strcpy(error,"Input file not specified");
	  return 0;
	}
	else if(multiple&&(strchr(sptr,(int)c1)||strchr(sptr,(int)c2)))
	{
	  for(i=nFirst;i<=nLast;i+=nInc)
	  {
	    sNthFile=InConvFile::getNthFileName(strng(sptr),i);
	    char* mptr=new char[strlen(sNthFile.data())+1];
	    strcpy(mptr,sNthFile.data());
	    if(bsl&&!mainWS_Legalbslname(mainWS,&UxEnv,mptr))
	    {
	      strcpy(error,"Input file ");
	      strcat(error,sNthFile.data());
	      strcat(error," : Invalid header filename");
	      return 0;
	    }
	    else if(access(sNthFile.data(),R_OK)==-1)
	    {
	      strcpy(error,"Input file ");
	      strcat(error,sNthFile.data());
	      strcat(error,": ");
	      strcat(error,strerror(errno));
	      return 0;
	    }
	    else
	    {
	      char *jptr;
	      jptr=new char[80];
	      strcpy(jptr,"");
	      struct stat buf;
	      if(strchr(sNthFile.data(),(int)'/')==NULL)
	        strcat(jptr,"./");
	      strcat(jptr,sNthFile.data());
	      stat(jptr,&buf);
	      if(S_ISDIR(buf.st_mode))
	      {
	        strcpy(error,"Selection: ");
	        strcat(error,sNthFile.data());
	        strcat(error," is a directory");
	        delete[] jptr;
	        return 0;
	      }
	      else
	      {
	        delete[] jptr;
	      }
	    }
	    delete[] mptr;
	  }
	}
	else if(bsl&&!mainWS_Legalbslname(mainWS,&UxEnv,sptr))
	{
	  strcpy(error,"Input file ");
	  strcat(error,sNthFile.data());
	  strcat(error," : Invalid header filename");
	  return 0;
	}
	else if(access(sptr,R_OK)==-1)
	{
	  strcpy(error,"Input file: ");
	  strcat(error,strerror(errno));
	  return 0;
	}
	else
	{
	  char *jptr;
	  jptr=new char[80];
	  strcpy(jptr,"");
	  struct stat buf;
	  if(strchr(sptr,(int)'/')==NULL)
	    strcat(jptr,"./");
	  strcat(jptr,sptr);
	  stat(jptr,&buf);
	  if(S_ISDIR(buf.st_mode))
	  {
	    strcpy(error,"Selection is a directory");
	    delete[] jptr;
	    return 0;
	  }
	  else
	  {
	    delete[] jptr;
	  }
	}

	return 1;

#endif
}

void _UxCmainWS::RangeSensitive( Environment * pEnv, int i )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	XtVaSetValues(UxGetWidget(rangeLabel),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(rangeField),XmNsensitive,i,NULL);

	XtVaSetValues(UxGetWidget(rangeField),XmNcursorPositionVisible,i,NULL);
}

void _UxCmainWS::RunSensitive( Environment * pEnv, int i )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	XtVaSetValues(UxGetWidget(runLabel),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(firstLabel),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(firstField),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(lastLabel),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(lastField),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(incLabel),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(incField),XmNsensitive,i,NULL);

	XtVaSetValues(UxGetWidget(firstField),XmNcursorPositionVisible,i,NULL);
	XtVaSetValues(UxGetWidget(lastField),XmNcursorPositionVisible,i,NULL);
	XtVaSetValues(UxGetWidget(incField),XmNcursorPositionVisible,i,NULL);
}

int _UxCmainWS::FileSelectionOK( Environment * pEnv, int fok, char *sptr, swidget *sw, char *error )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
#ifndef DESIGN_TIME

	gotFile=strng(sptr);

	if(fok)
	  {
	    if(*sw==infileText||*sw==outfileText)
	    {
	       XmTextSetString(UxGetWidget(*sw),sptr);
	       XmTextSetInsertionPosition(UxGetWidget(*sw),strlen(sptr)) ;
	       return 1;
	    }
	    else if(*sw==saveButton)
	    {
	      if(mainWS_SaveProfile(mainWS,&UxEnv,error))
	        return 1;
	      else
	        return 0;
	    }
	    else if(*sw==loadButton)
	    {
	      if(mainWS_LoadProfile(mainWS,&UxEnv,error))
	        return 1;
	      else
	        return 0;
	    }
	  }

#endif
}

int _UxCmainWS::CheckSize( Environment * pEnv, int nrec, int nrast, int nsize )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
#ifndef DESIGN_TIME

	char* jptr;
	struct stat buf;

	jptr=new char[80];
	strcpy(jptr,"");

	if(strchr(sNthFile.data(),(int)'/')==NULL)
	  strcat(jptr,"./");
	strcat(jptr,sNthFile.data());
	stat(jptr,&buf);

	if( buf.st_size<(off_t)(nrec*nrast*nsize+nSkip) )
	{
	  delete[] jptr;
	  return 0;
	}
	else
	{
	  delete[] jptr;
	}

#endif
}

int _UxCmainWS::GetParams( Environment * pEnv, char *error )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
#ifndef DESIGN_TIME
	char *sptr,*strptr;
	int i,iflag;


	// **********************************************************************
	// Check first, last and increment in run no.
	// **********************************************************************

	strptr=XmTextFieldGetString(firstField);
	sptr=stripws(strptr);
	nFirst=atoi(sptr);
	if(strlen(sptr)==0)
	{
	  strcpy(error,"First run number not specified");
	  XtFree(strptr);
	  return 0;
	}
	else
	{
	  for(i=0;i<strlen(sptr);i++)
	  {
	    if(sptr[i]=='.')
	    {
	      strcpy(error,"First run number: Integer value expected");
	      XtFree(strptr);
	      return 0;
	    }
	    else if(!isdigit(sptr[i])||nFirst<0)
	    {
	      strcpy(error,"Invalid first run number");
	      XtFree(strptr);
	      return 0;
	    }
	  }
	}
	XtFree(strptr);

	strptr=XmTextFieldGetString(lastField);
	sptr=stripws(strptr);
	nLast=atoi(sptr);
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Last run number not specified");
	  XtFree(strptr);
	  return 0;
	}
	else
	{
	  for(i=0;i<strlen(sptr);i++)
	  {
	    if(sptr[i]=='.')
	    {
	      strcpy(error,"Last run number: Integer value expected");
	      XtFree(strptr);
	      return 0;
	    }
	    else if(!isdigit(sptr[i])||nLast<nFirst)
	    {
	      strcpy(error,"Invalid last run number");
	      XtFree(strptr);
	      return 0;
	    }
	  }
	}
	XtFree(strptr);

	strptr=XmTextFieldGetString(incField);
	sptr=stripws(strptr);
	nInc=atoi(sptr);
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Run number increment not specified");
	  XtFree(strptr);
	  return 0;
	}
	else
	{
	  for(i=0;i<strlen(sptr);i++)
	  {
	    if(sptr[i]=='.')
	    {
	      strcpy(error,"Run number increment: Integer value expected");
	      XtFree(strptr);
	      return 0;
	    }
	    else if(!isdigit(sptr[i])||nInc<=0||(nLast-nFirst)%nInc!=0)
	    {
	      strcpy(error,"Invalid run number increment");
	      XtFree(strptr);
	      return 0;
	    }
	  }
	}
	XtFree(strptr);


	// **********************************************************************
	// Check that input files have been specified
	// and are readable
	// **********************************************************************

	strptr=XmTextGetString(infileText);
	sptr=stripws(strptr);
	if (strcmp(sType.data(),"bsl"))
	{
		if(mainWS_CheckInFile(mainWS,&UxEnv,sptr,error,TRUE,FALSE))
		{
		  sFile=strng(sptr);
	 	   XtFree(strptr);
		}
		else
		{
		  XtFree(strptr);
		  return 0;
		}
	}else
	{
	if(mainWS_CheckInFile(mainWS,&UxEnv,sptr,error,TRUE,TRUE))
		{
		  sFile=strng(sptr);
	 	 XtFree(strptr);
		}
		else
		{
		  XtFree(strptr);
		  return 0;
		}

	}

	// **********************************************************************
	// Check that output file has been specified
	// and is writable and a valid BSL filename
	// **********************************************************************

	strptr=XmTextGetString(outfileText);
	sptr=stripws(strptr);
	if(dtype<10){
	if(!mainWS_CheckOutFile(mainWS,&UxEnv,sptr,error,TRUE))
	{
	  XtFree(strptr);
	  return 0;
	}
        }/*else(!mainWS_CheckOutFile(mainWS,&UxEnv,sptr,error,FALSE))
	{
	  XtFree(strptr);
	  return 0;
	}*/

	// **********************************************************************
	// Convert characters in output filename to uppercase
	// **********************************************************************

	char* pptr;
	if((pptr=strrchr(sptr,(int)'/'))==NULL)
	  pptr=sptr;
	else
	  pptr++;

	for(i=0;i<=strlen(pptr);i++)
	{
	  if(islower((int)pptr[i]))
	    pptr[i]=toupper((int)pptr[i]);
	}

	sOutFile=strng(sptr);
	XmTextSetString(outfileText,sptr);
	XmTextSetInsertionPosition(outfileText,strlen(sptr));
	XtFree(strptr);

	// **********************************************************************
	// Check input and output pixels,rasters
	// **********************************************************************

	if((strcmp(dataptr,"riso")!=0)&&
	(strcmp(dataptr,"id2")!=0)&&
	(strcmp(dataptr,"bsl")!=0)&&
	(strcmp(dataptr,"tiff")!=0)&&
	(strcmp(dataptr,"id3")!=0)&&
	(strcmp(dataptr,"smv")!=0)&&
	(strcmp(dataptr,"loq_1d")!=0)&&
	(strcmp(dataptr,"loq_2d")!=0)&&
	(strcmp(dataptr,"gfrm")!=0)&&
	(strcmp(dataptr,"asc")!=0)&&
	(strcmp(dataptr,"plosto")!=0)&&
	(strcmp(dataptr,"ILL_SANS")!=0)&&
	(strcmp(dataptr,"mar345")!=0))
	{
	  strptr=XmTextFieldGetString(inpixField);
	  sptr=stripws(strptr);
	  nInPix=atoi(sptr);
	  if(strlen(sptr)==0)
	  {
	    strcpy(error,"Number of input pixels not specified");
	    XtFree(strptr);
	    return 0;
	  }
	  else
	  {
	    for(i=0;i<strlen(sptr);i++)
	    {
	      if(sptr[i]=='.')
	      {
	        strcpy(error,"Input pixels: Integer value expected");
	        XtFree(strptr);
	        return 0;
	      }
	      else if(!isdigit(sptr[i])||nInPix<=0)
	      {
	        strcpy(error,"Invalid number of input pixels");
	        XtFree(strptr);
	        return 0;
	      }
	    }
	  }
	  XtFree(strptr);

	  strptr=XmTextFieldGetString(inrastField);
	  sptr=stripws(strptr);
	  nInRast=atoi(sptr);
	  if(strlen(sptr)==0)
	  {
	    strcpy(error,"Number of input rasters not specified");
	    XtFree(strptr);
	    return 0;
	  }
	  else
	  {
	    for(i=0;i<strlen(sptr);i++)
	    {
	      if(sptr[i]=='.')
	      {
	        strcpy(error,"Input rasters: Integer value expected");
	        XtFree(strptr);
	        return 0;
	      }
	      else if(!isdigit(sptr[i])||nInRast<=0)
	      {
	        strcpy(error,"Invalid number of input rasters");
	        XtFree(strptr);
	        return 0;
	      }
	    }
	  }
	  XtFree(strptr);
	}
	else
	{
	  nInPix=0;
	  nInRast=0;
	}

	strptr=XmTextFieldGetString(outpixField);
	sptr=stripws(strptr);
	nOutPix=atoi(sptr);
	if(strlen(sptr)==0)
	{
	  nOutPix=nInPix;
	  inpixptr=stripws(XmTextFieldGetString(inpixField));
	  XtVaSetValues(UxGetWidget(outpixField),XmNvalue,inpixptr,NULL);
	  XtFree(inpixptr);
	}
	else
	{
	  for(i=0;i<strlen(sptr);i++)
	  {
	    if(sptr[i]=='.')
	    {
	      strcpy(error,"Output pixels: Integer value expected");
	      XtFree(strptr);
	      return 0;
	    }
	    else if(!isdigit(sptr[i])||nOutPix<=0)
	    {
	      strcpy(error,"Invalid number of output pixels");
	      XtFree(strptr);
	      return 0;
	    }
	  }
	}
	XtFree(strptr);

	strptr=XmTextFieldGetString(outrastField);
	sptr=stripws(strptr);
	nOutRast=atoi(sptr);
	if(strlen(sptr)==0)
	{
	  nOutRast=nInRast;
	  inrastptr=stripws(XmTextFieldGetString(inrastField));
	  XtVaSetValues(UxGetWidget(outrastField),XmNvalue,inrastptr,NULL);
	  XtFree(inrastptr);
	}
	else
	{
	  for(i=0;i<strlen(sptr);i++)
	  {
	    if(sptr[i]=='.')
	    {
	      strcpy(error,"Output rasters: Integer value expected");
	      XtFree(strptr);
	      return 0;
	    }
	    else if(!isdigit(sptr[i])||nOutRast<=0)
	    {
	      strcpy(error,"Invalid number of output rasters");
	      XtFree(strptr);
	      return 0;
	    }
	  }
	}
	XtFree(strptr);


	// **********************************************************************
	// Check bytes to skip
	// **********************************************************************

	strptr=XmTextFieldGetString(skipField);
	sptr=stripws(strptr);
	nSkip=atoi(sptr);
	if(strlen(sptr)==0)
	{
	  nSkip=0;
	}
	else
	{
	  for(i=0;i<strlen(sptr);i++)
	  {
	    if(sptr[i]=='.')
	    {
	      strcpy(error,"Bytes to skip: Integer value expected");
	      XtFree(strptr);
	      return 0;
	    }
	    else if(!isdigit(sptr[i])||nSkip<0)
	    {
	      strcpy(error,"Invalid number of bytes to skip");
	      XtFree(strptr);
	      return 0;
	    }
	  }
	}
	XtFree(strptr);


	// **********************************************************************
	// Check aspect ratio
	// **********************************************************************

	strptr=XmTextFieldGetString(aspectField);
	sptr=stripws(strptr);
	dAspect=atof(sptr);
	if(strlen(sptr)==0)
	{
	  dAspect=1.0;
	}
	else if(dAspect<=0.)
	{
	  strcpy(error,"Invalid aspect ratio");
	  XtFree(strptr);
	  return 0;
	 }
	else
	{
	  iflag=0;
	  for(i=0;i<strlen(sptr);i++)
	  {
	    if(!isdigit(sptr[i]))
	    {
	      if(sptr[i]="."&&!iflag)
	        iflag=1;
	      else
	      {
	        strcpy(error,"Invalid aspect ratio");
	        XtFree(strptr);
	        return 0;
	      }
	    }
	  }
	}
	XtFree(strptr);


	// **********************************************************************
	// Check dynamic range
	// **********************************************************************

	if(strcmp(sType.data(),"fuji")==0)
	{
	  strptr=XmTextFieldGetString(rangeField);
	  sptr=stripws(strptr);
	  dRange=atof(sptr);
	  if(strlen(sptr)==0)
	  {
	    strcpy(error,"Dynamic range not specified");
	    XtFree(strptr);
	    return 0;
	  }
	  else if (dRange<=0.)
	  {
	    strcpy(error,"Invalid dynamic range");
	    XtFree(strptr);
	    return 0;
	  }
	  else
	  {
	    iflag=0;
	    for(i=0;i<strlen(sptr);i++)
	    {
	      if(!isdigit(sptr[i]))
	      {
	        if(sptr[i]="."&&!iflag)
	        iflag=1;
	        else
	        {
	          strcpy(error,"Invalid dynamic range");
	          XtFree(strptr);
	          return 0;
	        }
	      }
	    }
	    XtFree(strptr);
	  }
	}
	else
	  dRange=0.;


	// **********************************************************************
	// Get output file headers
	// **********************************************************************

	  sptr=XmTextGetString(header1Text);
	  if(strlen(sptr)==0)
	    sHead1=strng(" ");
	  else
	    sHead1=strng(sptr);
	  XtFree(sptr);
	  sptr=XmTextGetString(header2Text);
	  if(strlen(sptr)==0)
	    sHead2=strng(" ");
	  else
	  sHead2=strng(sptr);
	  XtFree(sptr);


	// **********************************************************************
	// Get swap option
	// **********************************************************************

	  if(XmToggleButtonGetState(toggleButton1))
	    bSwap=IS_TRUE;
	  else
	    bSwap=IS_FALSE;


	// **********************************************************************
	// If everything OK return 1
	// **********************************************************************

	return 1;

#endif
}

void _UxCmainWS::UpdateRange( Environment * pEnv )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	XtVaSetValues(UxGetWidget(rangeField),XmNvalue,rangeptr,NULL);
}

int _UxCmainWS::LoadProfile( Environment * pEnv, char *error )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
#ifndef DESIGN_TIME

	char lstring[81];
	int nstate;

	ifstream in_profile(gotFile.data(),ios::in|ios::skipws);
	if(in_profile.bad())
	{
	  strcpy(error,"Error opening input file");
	  return 0;
	}

	in_profile.getline(lstring,sizeof(lstring));
	if(strcmp(stripws(lstring),"Xconv v1.0 profile")!=0)
	{
	  strcpy(error,"Invalid file format");
	  return 0;
	}

	in_profile.getline(lstring,sizeof(lstring));
	in_profile.getline(lstring,sizeof(lstring));

	sType=strng(lstring);
	if(match(psTypes,nTypes,sType)==-1)
	{
	  strcpy(error,"Profile specifies an invalid data format");
	  sType=strng("");
	  return 0;
	}

	in_profile.getline(lstring,sizeof(lstring));
	inpixptr=strdup(lstring);

	in_profile.getline(lstring,sizeof(lstring));
	inrastptr=strdup(lstring);

	in_profile.getline(lstring,sizeof(lstring));
	skptr=strdup(lstring);

	in_profile.getline(lstring,sizeof(lstring));
	asptr=strdup(lstring);

	in_profile.getline(lstring,sizeof(lstring));
	rangeptr=strdup(lstring);

	in_profile.getline(lstring,sizeof(lstring));
	outpixptr=strdup(lstring);

	in_profile.getline(lstring,sizeof(lstring));
	outrastptr=strdup(lstring);

	in_profile.getline(lstring,sizeof(lstring));
	nstate=atoi(lstring);

	if(!strcmp(sType.data(),"float"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_float,NULL);
	  XtCallCallbacks(optionMenu_p1_float,XmNactivateCallback,0);
	  mainWS_UpdateFields(mainWS,&UxEnv);
	}
	else if(!strcmp(sType.data(),"int"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_int,NULL);
	  XtCallCallbacks(optionMenu_p1_int,XmNactivateCallback,0);
	  mainWS_UpdateFields(mainWS,&UxEnv);
	}
	else if(!strcmp(sType.data(),"short"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_short,NULL);
	  XtCallCallbacks(optionMenu_p1_short,XmNactivateCallback,0);
	  mainWS_UpdateFields(mainWS,&UxEnv);
	}
	else if(!strcmp(sType.data(),"char"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_char,NULL);
	  XtCallCallbacks(optionMenu_p1_char,XmNactivateCallback,0);
	  mainWS_UpdateFields(mainWS,&UxEnv);
	}
	else if(!strcmp(sType.data(),"smar"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_smar,NULL);
	  XtCallCallbacks(optionMenu_p1_smar,XmNactivateCallback,0);
	}
	else if(!strcmp(sType.data(),"bmar"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_bmar,NULL);
	  XtCallCallbacks(optionMenu_p1_bmar,XmNactivateCallback,0);
	}
	else if(!strcmp(sType.data(),"fuji"))
	{
	  char *tmp;
	  tmp=strdup(rangeptr);
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_fuji,NULL);
	  XtCallCallbacks(optionMenu_p1_fuji,XmNactivateCallback,0);
	  rangeptr=tmp;
	  mainWS_UpdateRange(mainWS,&UxEnv);
	}
	else if(!strcmp(sType.data(),"rax2"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_rax2,NULL);
	  XtCallCallbacks(optionMenu_p1_rax2,XmNactivateCallback,0);
	}
	else if(!strcmp(sType.data(),"rax4"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_rax4,NULL);
	  XtCallCallbacks(optionMenu_p1_rax4,XmNactivateCallback,0);
	}
	else if(!strcmp(sType.data(),"psci"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_psci,NULL);
	  XtCallCallbacks(optionMenu_p1_psci,XmNactivateCallback,0);
	}
	else if(!strcmp(sType.data(),"tiff"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_tiff,NULL);
	  XtCallCallbacks(optionMenu_p1_tiff,XmNactivateCallback,0);
	}
	else if(!strcmp(sType.data(),"bsl"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_bsl,NULL);
	  XtCallCallbacks(optionMenu_p1_bsl,XmNactivateCallback,0);
	}
	else if(!strcmp(sType.data(),"smv"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_smv,NULL);
	  XtCallCallbacks(optionMenu_p1_smv,XmNactivateCallback,0);
	}
	
	else if(!strcmp(sType.data(),"id2"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_id2,NULL);
	  XtCallCallbacks(optionMenu_p1_id2,XmNactivateCallback,0);
	}
	else if(!strcmp(sType.data(),"id3"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_id3,NULL);
	  XtCallCallbacks(optionMenu_p1_id3,XmNactivateCallback,0);
	}
	else if(!strcmp(sType.data(),"loq_1d"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_loq_1d,NULL);
	  XtCallCallbacks(optionMenu_p1_loq_1d,XmNactivateCallback,0);
	}
	else if(!strcmp(sType.data(),"loq_2d"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_loq_2d,NULL);
	  XtCallCallbacks(optionMenu_p1_loq_2d,XmNactivateCallback,0);
	}
		else if(!strcmp(sType.data(),"ILL_SANS"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_sans,NULL);
	  XtCallCallbacks(optionMenu_p1_sans,XmNactivateCallback,0);
	}
	else if(!strcmp(sType.data(),"mar345"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_mar345,NULL);
	  XtCallCallbacks(optionMenu_p1_mar345,XmNactivateCallback,0);
	}
	else if(!strcmp(sType.data(),"bruker_gfrm"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_bruker_gfrm,NULL);
	  XtCallCallbacks(optionMenu_p1_bruker_gfrm,XmNactivateCallback,0);
	}
	else if(!strcmp(sType.data(),"bruker_asc"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_bruker_asc,NULL);
	  XtCallCallbacks(optionMenu_p1_bruker_asc,XmNactivateCallback,0);
	}
	else if(!strcmp(sType.data(),"bruker_plosto"))
	{
	  XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_bruker_plosto,NULL);
	  XtCallCallbacks(optionMenu_p1_bruker_plosto,XmNactivateCallback,0);
	}
  
	if(strlen(outpixptr)!=0||strlen(outrastptr)!=0)
	  mainWS_UpdateOutFields(mainWS,&UxEnv);
	XmToggleButtonSetState(toggleButton1,nstate,True);

	return 1;

#endif
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

void  _UxCmainWS::activateCB_pushButton1(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	{
	FileSelection_set(FileSelect,&UxEnv,&infileText,"*","Input file selection",FALSE,TRUE,1,0,0);
	UxPopupInterface(FileSelect,no_grab);
	}
}

void  _UxCmainWS::Wrap_activateCB_pushButton1(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_pushButton1(UxWidget, UxClientData, UxCallbackArg);
}
///////////////////////////////////
void  _UxCmainWS::valueChangedCB_infileText(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	{
	char *sptr,*dumptr;
	char *ptr1="#";
	char *ptr2="%";
	int i,ilen,iflag;

	iflag=0;
	sptr=XmTextGetString(UxWidget);
	dumptr=sptr;
	ilen=(int)strlen(sptr);

	for(i=0;i<ilen;i++)
	{
	  if(strstr(sptr,ptr1)!=NULL||strstr(sptr,ptr2)!=NULL)
	  {
	    mainWS_RunSensitive(UxThisWidget,&UxEnv,1);
	    iflag=1;
	    break;
	  }
	  sptr++;
	}

	if(!iflag)
	{
	  firstptr="1";
	  lastptr="1";
	  incptr="1";
	  mainWS_UpdateRun(UxThisWidget,&UxEnv);
	  mainWS_RunSensitive(UxThisWidget,&UxEnv,0);
	}

	XtFree(dumptr);
	}

      { //update file type
	char *sptr,*dumptr;
	int i,ilen;
	sptr=XmTextGetString(UxWidget);
	ilen=(int)strlen(sptr);

	for(i=0;i<ilen;i++)
	{
	  if(strstr(sptr,".tif")!=NULL||strstr(sptr,".tiff")!=NULL||strstr(sptr,".TIF")!=NULL)
	  {
	    XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_tiff,NULL);
	    XtCallCallbacks(optionMenu_p1_tiff,XmNactivateCallback,0);
	    mainWS_UpdateFields(mainWS,&UxEnv);
	     break;

         }
	if(strstr(sptr,".mar1200")!=NULL||strstr(sptr,".mar1600")!=NULL||strstr(sptr,".mar1800")!=NULL||\
	strstr(sptr,".mar2400")!=NULL||strstr(sptr,".mar2000")!=NULL||strstr(sptr,".mar3000")!=NULL||\
	strstr(sptr,".mar2300")!=NULL||strstr(sptr,".mar3450")!=NULL)
	  {
	    XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_mar345,NULL);
	    XtCallCallbacks(optionMenu_p1_mar345,XmNactivateCallback,0);
	    mainWS_UpdateFields(mainWS,&UxEnv);
	    break;

	  }
        if(strstr(sptr,".smv")!=NULL||strstr(sptr,".SMV")!=NULL)
	  {
	    XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_smv,NULL);
	    XtCallCallbacks(optionMenu_p1_smv,XmNactivateCallback,0);
	    mainWS_UpdateFields(mainWS,&UxEnv);
	    break;

	  }
	if(strstr(sptr,".Q")!=NULL||strstr(sptr,".QQ")!=NULL)
	  {
	    XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_loq_1d,NULL);
	    XtCallCallbacks(optionMenu_p1_loq_1d,XmNactivateCallback,0);
	    mainWS_UpdateFields(mainWS,&UxEnv);
	    break;

	  }
	if(strstr(sptr,".LQA")!=NULL)
	  {
	    XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_loq_2d,NULL);
	    XtCallCallbacks(optionMenu_p1_loq_2d,XmNactivateCallback,0);
	    mainWS_UpdateFields(mainWS,&UxEnv);
	    break;

	  }
        if(strstr(sptr,".gfrm")!=NULL)
	  {
	    XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_bruker_gfrm,NULL);
	    XtCallCallbacks(optionMenu_p1_bruker_gfrm,XmNactivateCallback,0);
	    mainWS_UpdateFields(mainWS,&UxEnv);
	    break;

	  }
	if(strstr(sptr,".asc")!=NULL)
	  {
	    XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_bruker_asc,NULL);
	    XtCallCallbacks(optionMenu_p1_bruker_asc,XmNactivateCallback,0);
	    mainWS_UpdateFields(mainWS,&UxEnv);
	    break;

	  }
	if(strstr(sptr,".osc")!=NULL)
	  {
	    XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_rax4,NULL);
	    XtCallCallbacks(optionMenu_p1_rax4,XmNactivateCallback,0);
	    mainWS_UpdateFields(mainWS,&UxEnv);
	    break;

	  }
	if(strstr(sptr,".BSL")!=NULL)
	  {
	    XtVaSetValues(optionMenu1,XmNmenuHistory,optionMenu_p1_bsl,NULL);
	    XtCallCallbacks(optionMenu_p1_bsl,XmNactivateCallback,0);
	    mainWS_UpdateFields(mainWS,&UxEnv);
	    break;

	  }
	 sptr++;
	}


	}


}

void  _UxCmainWS::Wrap_valueChangedCB_infileText(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->valueChangedCB_infileText(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_float(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	rangeptr="";
	dataptr="float";
#ifndef DESIGN_TIME
	  sType=strng("float");
#endif

	mainWS_UpdateRange(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,1);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}
void  _UxCmainWS::activateCB_optionMenu_p1_BSL_out(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	

	  XtVaSetValues(optionMenu2,XmNmenuHistory,optionMenu_p1_float32,NULL);
	  XtCallCallbacks(optionMenu_p1_float32,XmNactivateCallback,0);
     mainWS_FieldsEditable_out(UxThisWidget,&UxEnv,1);
}
void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_BSL_out(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_BSL_out(UxWidget, UxClientData, UxCallbackArg);
}
void  _UxCmainWS::activateCB_optionMenu_p1_tiff_8out(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
    dtype=11;
	
	mainWS_FieldsEditable_out(UxThisWidget,&UxEnv,0);

}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_tiff_8out(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_tiff_8out(UxWidget, UxClientData, UxCallbackArg);
}
void  _UxCmainWS::activateCB_optionMenu_p1_tiff_16out(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	dtype=12;
	mainWS_FieldsEditable_out(UxThisWidget,&UxEnv,0);

}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_tiff_16out(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_tiff_16out(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_txt_out(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
        dtype=10;
	mainWS_FieldsEditable_out(UxThisWidget,&UxEnv,0);

}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_txt_out(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_txt_out(UxWidget, UxClientData, UxCallbackArg);
}
void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_float(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_float(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_int(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	rangeptr="";
	dataptr="int";
#ifndef DESIGN_TIME
	  sType=strng("int");
#endif

	mainWS_UpdateRange(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,1);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_int(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_int(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_short(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	rangeptr="";
	dataptr="short";
#ifndef DESIGN_TIME
	  sType=strng("short");
#endif

	mainWS_UpdateRange(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,1);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_short(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_short(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_char(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	rangeptr="";
	dataptr="char";
#ifndef DESIGN_TIME
	  sType=strng("char");
#endif

	mainWS_UpdateRange(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,1);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_char(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_char(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_smar(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="1200";
	inrastptr="1200";
	skptr="2400";
	asptr="1.0";
	rangeptr="";
	dataptr="short";
#ifndef DESIGN_TIME
	  sType=strng("smar");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_smar(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_smar(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_bmar(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="2000";
	inrastptr="2000";
	skptr="4000";
	asptr="1.0";
	rangeptr="";
	dataptr="short";
#ifndef DESIGN_TIME
	  sType=strng("bmar");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_bmar(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_bmar(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_fuji(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="2048";
	inrastptr="4096";
	skptr="8192";
	asptr="1.0";
	rangeptr="4.0";
	dataptr="short";

#ifndef DESIGN_TIME
	  sType=strng("fuji");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,1);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_fuji(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_fuji(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_fuji2500(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="2000";
	inrastptr="2500";
	skptr="0";
	asptr="1.0";
	rangeptr="5.0";
	dataptr="short";

#ifndef DESIGN_TIME
	  sType=strng("fuji2500");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_fuji2500(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_fuji2500(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_rax2(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="400";
	inrastptr="1";
	skptr="0";
	asptr="1.0";
	rangeptr="";
	dataptr="short";
#ifndef DESIGN_TIME
	  sType=strng("rax2");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_rax2(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_rax2(UxWidget, UxClientData, UxCallbackArg);
}


void  _UxCmainWS::activateCB_optionMenu_p1_rax4(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="3000";
	inrastptr="3000";
	skptr="6000";
	asptr="1.0";
	rangeptr="";
	dataptr="short";
#ifndef DESIGN_TIME
	  sType=strng("rax4");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_rax4(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_rax4(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_psci(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="768";
	inrastptr="576";
	skptr="0";
	asptr="1.0";
	rangeptr="";
	dataptr="short";
#ifndef DESIGN_TIME
	  sType=strng("psci");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_psci(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_psci(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_riso(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="";
	inrastptr="";
	skptr="";
	asptr="1.0";
	rangeptr="";
	dataptr="riso";
#ifndef DESIGN_TIME
	  sType=strng("riso");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_riso(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_riso(UxWidget, UxClientData, UxCallbackArg);
}
void  _UxCmainWS::activateCB_optionMenu_p1_tiff(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="";
	inrastptr="";
	skptr="";
	asptr="1.0";
	rangeptr="";
	dataptr="tiff";
#ifndef DESIGN_TIME
	  sType=strng("tiff");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_tiff(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_tiff(UxWidget, UxClientData, UxCallbackArg);
}
void  _UxCmainWS::activateCB_optionMenu_p1_bsl(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="";
	inrastptr="";
	skptr="";
	asptr="1.0";
	rangeptr="";
	dataptr="bsl";
#ifndef DESIGN_TIME
	  sType=strng("bsl");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_bsl(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_bsl(UxWidget, UxClientData, UxCallbackArg);
}
void  _UxCmainWS::activateCB_optionMenu_p1_id3(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="";
	inrastptr="";
	skptr="";
	asptr="1.0";
	rangeptr="";
	dataptr="id3";
#ifndef DESIGN_TIME
	  sType=strng("id3");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_id3(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_id3(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_sans(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="";
	inrastptr="";
	skptr="";
	asptr="1.0";
	rangeptr="";
	dataptr="ILL_SANS";
#ifndef DESIGN_TIME
	  sType=strng("ILL_SANS");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_sans(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_sans(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_loq_2d(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="";
	inrastptr="";
	skptr="";
	asptr="1.0";
	rangeptr="";
	dataptr="loq_2d";
#ifndef DESIGN_TIME
	  sType=strng("loq_2d");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_loq_2d(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_loq_2d(UxWidget, UxClientData, UxCallbackArg);
}


void  _UxCmainWS::activateCB_optionMenu_p1_loq_1d(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="";
	inrastptr="";
	skptr="";
	asptr="1.0";
	rangeptr="";
	dataptr="loq_1d";
#ifndef DESIGN_TIME
	  sType=strng("loq_1d");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_loq_1d(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_loq_1d(UxWidget, UxClientData, UxCallbackArg);
}


void  _UxCmainWS::activateCB_optionMenu_p1_smv(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="";
	inrastptr="";
	skptr="";
	asptr="1.0";
	rangeptr="";
	dataptr="smv";
#ifndef DESIGN_TIME
	  sType=strng("smv");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_smv(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_smv(UxWidget, UxClientData, UxCallbackArg);
}


void  _UxCmainWS::activateCB_optionMenu_p1_bruker_gfrm(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="";
	inrastptr="";
	skptr="";
	asptr="1.0";
	rangeptr="";
	dataptr="gfrm";
#ifndef DESIGN_TIME
	  sType=strng("bruker_gfrm");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_bruker_gfrm(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_bruker_gfrm(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_bruker_asc(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="";
	inrastptr="";
	skptr="";
	asptr="1.0";
	rangeptr="";
	dataptr="asc";
#ifndef DESIGN_TIME
	  sType=strng("bruker_asc");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_bruker_asc(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_bruker_asc(UxWidget, UxClientData, UxCallbackArg);
}
void  _UxCmainWS::activateCB_optionMenu_p1_bruker_plosto(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="";
	inrastptr="";
	skptr="";
	asptr="1.0";
	rangeptr="";
	dataptr="plosto";
#ifndef DESIGN_TIME
	  sType=strng("bruker_plosto");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_bruker_plosto(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_bruker_plosto(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_mar345(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="";
	inrastptr="";
	skptr="";
	asptr="1.0";
	rangeptr="";
	dataptr="mar345";
#ifndef DESIGN_TIME
	  sType=strng("mar345");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_mar345(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_mar345(UxWidget, UxClientData, UxCallbackArg);
}
void  _UxCmainWS::activateCB_optionMenu_p1_id2(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	inpixptr="";
	inrastptr="";
	skptr="";
	asptr="1.0";
	rangeptr="";
	dataptr="id2";
#ifndef DESIGN_TIME
	  sType=strng("id2");
#endif

	mainWS_UpdateFields(UxThisWidget,&UxEnv);
	mainWS_UpdateData(UxThisWidget,&UxEnv);
	mainWS_FieldsEditable(UxThisWidget,&UxEnv,0);
	mainWS_RangeSensitive(UxThisWidget,&UxEnv,0);
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_id2(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_id2(UxWidget, UxClientData, UxCallbackArg);
}
void  _UxCmainWS::valueChangedCB_inpixField(
					Widget wgt,
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	{
	/*inpixptr=XmTextFieldGetString(UxWidget);
	XtVaSetValues(UxGetWidget(outpixField),XmNvalue,inpixptr,NULL);
	XtFree(inpixptr);
	*/
	}
}

void  _UxCmainWS::Wrap_valueChangedCB_inpixField(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->valueChangedCB_inpixField(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::valueChangedCB_inrastField(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	{
	/*inrastptr=XmTextFieldGetString(UxWidget);
	XtVaSetValues(UxGetWidget(outrastField),XmNvalue,inrastptr,NULL);
	XtFree(inrastptr);
	*/
	}
}

void  _UxCmainWS::Wrap_valueChangedCB_inrastField(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->valueChangedCB_inrastField(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_pushButton2(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	{
#ifndef DESIGN_TIME
	
	char* error;
	error=new char[80];
	strcpy(error,"");
	
	
	if(!mainWS_GetParams(UxThisWidget,&UxEnv,error))
	{
	  ErrorMessage_set(ErrMessage,&UxEnv,error);
	  UxPopupInterface(ErrMessage,no_grab);
	}
	else
	{
	  XDefineCursor(UxDisplay,XtWindow(mainWS),busyCursor);
	  XFlush(UxDisplay);
	  if(mainWS_Convert(mainWS,&UxEnv,error))
	  {
	    XUndefineCursor(UxDisplay,XtWindow(mainWS));
	    InformationDialog_set(InfoDialog,&UxEnv,"Conversion completed","Confirmation message");
	    UxPopupInterface(InfoDialog,no_grab);
	  }
	  else
	  {
	    XUndefineCursor(UxDisplay,XtWindow(mainWS));
	    ErrorMessage_set(ErrMessage,&UxEnv,error);
	    UxPopupInterface(ErrMessage,no_grab);
	  }
	}
	
	delete []error;
	
#endif
	}
}

void  _UxCmainWS::Wrap_activateCB_pushButton2(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_pushButton2(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_pushButton3(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	{
	XDefineCursor(UxDisplay,XtWindow(mainWS),busyCursor);
	XFlush(UxDisplay);
	mainWS_Help(mainWS,&UxEnv);
	XUndefineCursor(UxDisplay,XtWindow(mainWS));
	}
}

void  _UxCmainWS::Wrap_activateCB_pushButton3(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_pushButton3(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_pushButton4(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	{
	QuestionDialog_set(QuestDialog,&UxEnv,"Do you really want to quit?","Confirm exit");
	UxPopupInterface(QuestDialog,no_grab);
	}
}

void  _UxCmainWS::Wrap_activateCB_pushButton4(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_pushButton4(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_saveButton(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	{
#ifndef DESIGN_TIME
	
	char *error;
	error=new char[80];
	strcpy(error,"");
	
	if(!mainWS_GetProfile(mainWS,&UxEnv,error))
	{
	  ErrorMessage_set(ErrMessage,&UxEnv,error);
	  UxPopupInterface(ErrMessage,no_grab);
	}
	else
	{
	  FileSelection_set(FileSelect,&UxEnv,&saveButton,"*.prf","Save profile",FALSE,TRUE,0,0,0);
	  UxPopupInterface(FileSelect,no_grab);
	}
	
#endif
	}
}

void  _UxCmainWS::Wrap_activateCB_saveButton(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_saveButton(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_loadButton(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	{
#ifndef DESIGN_TIME
	
	FileSelection_set(FileSelect,&UxEnv,&loadButton,"*.prf","Load profile",FALSE,TRUE,1,0,0);
	UxPopupInterface(FileSelect,no_grab);
	
#endif
	}
}

void  _UxCmainWS::Wrap_activateCB_loadButton(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_loadButton(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_pushButton7(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	{
	FileSelection_set(FileSelect,&UxEnv,&outfileText,"*000.*","Output file selection",FALSE,TRUE,1,0,0);
	UxPopupInterface(FileSelect,no_grab);
	}
}

void  _UxCmainWS::Wrap_activateCB_pushButton7(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_pushButton7(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_float32(
					Widget wgt, 
					XtPointer cd,
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	dtype=0;
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_float32(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_float32(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_float64(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	dtype=9;
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_float64(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_float64(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_int16(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	dtype=3;
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_int16(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_int16(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_uint16(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	dtype=4;
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_uint16(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_uint16(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_int32(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	dtype=5;
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_int32(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_int32(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_uint32(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	dtype=6;
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_uint32(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_uint32(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_int64(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	dtype=7;
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_int64(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_int64(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_uint64(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	dtype=8;
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_uint64(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_uint64(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_char8(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	dtype=1;
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_char8(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_char8(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCmainWS::activateCB_optionMenu_p1_uchar8(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	dtype=2;
}

void  _UxCmainWS::Wrap_activateCB_optionMenu_p1_uchar8(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCmainWS              *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCmainWS *) UxGetContext(UxWidget);
	UxContext->activateCB_optionMenu_p1_uchar8(UxWidget, UxClientData, UxCallbackArg);
}

/*******************************************************************************
       The following is the destroyContext callback function.
       It is needed to free the memory allocated by the context.
*******************************************************************************/

static void DelayedDelete( XtPointer obj, XtIntervalId *)
{
	delete ((_UxCmainWS *) obj);
}
void  _UxCmainWS::UxDestroyContextCB(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	((_UxCmainWS *) UxClientData)->UxThis = NULL;
	XtAppAddTimeOut(UxAppContext, 0, DelayedDelete, UxClientData);
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

Widget _UxCmainWS::_build()
{
	Widget		_UxParent;
	Widget		optionMenu_p1_shell;
	Widget		optionMenu_p2_shell;
	Widget		optionMenu_p3_shell;

	// Creation of mainWS
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	mainWS = XtVaCreatePopupShell( "mainWS",
			applicationShellWidgetClass,
			_UxParent,
			XmNheight, 659,
			XmNiconName, "xconv",
			XmNwidth, 800,
			XmNtitle, "CCP13 : xconv v6.0 ",
			XmNx, 0,
			XmNy, 0,
			XmNmaxHeight, 659,
			XmNmaxWidth, 800,
			NULL );
	UxPutContext( mainWS, (char *) this );
	UxThis = mainWS;



	// Creation of bulletinBoard1
	bulletinBoard1 = XtVaCreateManagedWidget( "bulletinBoard1",
			xmBulletinBoardWidgetClass,
			mainWS,
			XmNresizePolicy, XmRESIZE_NONE,
			XmNunitType, XmPIXELS,
			XmNmarginHeight, 0,
			XmNmarginWidth, 0,
			XmNwidth, 800,
			XmNheight, 659,
			XmNnoResize, TRUE,
			XmNx, 2,
			XmNy, -1,
			NULL );
	UxPutContext( bulletinBoard1, (char *) this );


	// Creation of separatorGadget1
	separatorGadget1 = XtVaCreateManagedWidget( "separatorGadget1",
			xmSeparatorGadgetClass,
			bulletinBoard1,
			XmNorientation, XmVERTICAL,
			XmNheight, 574,
			XmNwidth, 10,
			XmNx, 395,
			XmNseparatorType, XmSHADOW_ETCHED_IN,
			XmNy, 5,
			NULL );
	UxPutContext( separatorGadget1, (char *) this );


	// Creation of label1
	label1 = XtVaCreateManagedWidget( "label1",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 169,
			XmNy, 10,
			RES_CONVERT( XmNlabelString, "Input" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--25-180-100-100-p-125-iso8859-1" ),
			NULL );
	UxPutContext( label1, (char *) this );


	// Creation of label2
	label2 = XtVaCreateManagedWidget( "label2",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 566,
			XmNy, 10,
			RES_CONVERT( XmNlabelString, "Output" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--25-180-100-100-p-125-iso8859-1" ),
			NULL );
	UxPutContext( label2, (char *) this );


	// Creation of label3
	label3 = XtVaCreateManagedWidget( "label3",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 20,
			XmNy, 80,
			RES_CONVERT( XmNlabelString, "Filename : " ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( label3, (char *) this );


	// Creation of pushButton1
	pushButton1 = XtVaCreateManagedWidget( "pushButton1",
			xmPushButtonWidgetClass,
			bulletinBoard1,
			XmNx, 310,
			XmNy, 77,
			RES_CONVERT( XmNlabelString, "Browse" ),
			XmNmarginHeight, 5,
			XmNmarginWidth, 5,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton1, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_pushButton1,
		(XtPointer) NULL );

	UxPutContext( pushButton1, (char *) this );


	// Creation of label4
	label4 = XtVaCreateManagedWidget( "label4",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 425,
			XmNy, 80,
			RES_CONVERT( XmNlabelString, "Filename : " ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( label4, (char *) this );


	// Creation of firstLabel
	firstLabel = XtVaCreateManagedWidget( "firstLabel",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 96,
			XmNy, 152,
			RES_CONVERT( XmNlabelString, "First" ),
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( firstLabel, (char *) this );


	// Creation of lastLabel
	lastLabel = XtVaCreateManagedWidget( "lastLabel",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 187,
			XmNy, 152,
			RES_CONVERT( XmNlabelString, "Last" ),
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( lastLabel, (char *) this );


	// Creation of incLabel
	incLabel = XtVaCreateManagedWidget( "incLabel",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 271,
			XmNy, 152,
			RES_CONVERT( XmNlabelString, "Inc" ),
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( incLabel, (char *) this );


	// Creation of firstField
	firstField = XtVaCreateManagedWidget( "firstField",
			xmTextFieldWidgetClass,
			bulletinBoard1,
			XmNwidth, 40,
			XmNx, 137,
			XmNy, 147,
			XmNfontList, UxConvertFontList("9x15" ),
			XmNvalue, "",
			NULL );
	UxPutContext( firstField, (char *) this );


	// Creation of textField4
	textField4 = XtVaCreateManagedWidget( "textField4",
			xmTextFieldWidgetClass,
			bulletinBoard1,
			XmNwidth, 40,
			XmNx, 330,
			XmNy, 177,
			XmNheight, 2,
			NULL );
	UxPutContext( textField4, (char *) this );


	// Creation of runLabel
	runLabel = XtVaCreateManagedWidget( "runLabel",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 20,
			XmNy, 150,
			RES_CONVERT( XmNlabelString, "Run no :" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( runLabel, (char *) this );


	// Creation of scrolledWindowText1
	scrolledWindowText1 = XtVaCreateManagedWidget( "scrolledWindowText1",
			xmScrolledWindowWidgetClass,
			bulletinBoard1,
			XmNscrollingPolicy, XmAPPLICATION_DEFINED,
			XmNvisualPolicy, XmVARIABLE,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNx, 117,
			XmNy, 77,
			NULL );
	UxPutContext( scrolledWindowText1, (char *) this );


	// Creation of infileText
	infileText = XtVaCreateManagedWidget( "infileText",
			xmTextWidgetClass,
			scrolledWindowText1,
			XmNwidth, 183,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( infileText, XmNvalueChangedCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_valueChangedCB_infileText,
		(XtPointer) NULL );

	UxPutContext( infileText, (char *) this );


	// Creation of lastField
	lastField = XtVaCreateManagedWidget( "lastField",
			xmTextFieldWidgetClass,
			bulletinBoard1,
			XmNwidth, 40,
			XmNx, 221,
			XmNy, 147,
			XmNfontList, UxConvertFontList("9x15" ),
			XmNvalue, "",
			NULL );
	UxPutContext( lastField, (char *) this );


	// Creation of label10
	label10 = XtVaCreateManagedWidget( "label10",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 20,
			XmNy, 218,
			RES_CONVERT( XmNlabelString, "File type :" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( label10, (char *) this );


	// Creation of optionMenu_p1
	optionMenu_p1_shell = XtVaCreatePopupShell ("optionMenu_p1_shell",
			xmMenuShellWidgetClass, bulletinBoard1,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	optionMenu_p1 = XtVaCreateWidget( "optionMenu_p1",
			xmRowColumnWidgetClass,
			optionMenu_p1_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( optionMenu_p1, (char *) this );


	// Creation of optionMenu_p1_float
	optionMenu_p1_float = XtVaCreateManagedWidget( "optionMenu_p1_float",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "float" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_float, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_float,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_float, (char *) this );


	// Creation of optionMenu_p1_int
	optionMenu_p1_int = XtVaCreateManagedWidget( "optionMenu_p1_int",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "int" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_int, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_int,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_int, (char *) this );


	// Creation of optionMenu_p1_short
	optionMenu_p1_short = XtVaCreateManagedWidget( "optionMenu_p1_short",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "short" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_short, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_short,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_short, (char *) this );


	// Creation of optionMenu_p1_char
	optionMenu_p1_char = XtVaCreateManagedWidget( "optionMenu_p1_char",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "char" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_char, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_char,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_char, (char *) this );


	// Creation of optionMenu_p1_smar
	optionMenu_p1_smar = XtVaCreateManagedWidget( "optionMenu_p1_smar",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "smar" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_smar, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_smar,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_smar, (char *) this );


	// Creation of optionMenu_p1_bmar
	optionMenu_p1_bmar = XtVaCreateManagedWidget( "optionMenu_p1_bmar",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "bmar" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_bmar, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_bmar,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_bmar, (char *) this );


	// Creation of optionMenu_p1_fuji
	optionMenu_p1_fuji = XtVaCreateManagedWidget( "optionMenu_p1_fuji",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "fuji" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_fuji, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_fuji,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_fuji, (char *) this );


	// Creation of optionMenu_p1_fuji2500
	optionMenu_p1_fuji2500 = XtVaCreateManagedWidget( "optionMenu_p1_fuji2500",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "fuji2500" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_fuji2500, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_fuji2500,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_fuji2500, (char *) this );


	// Creation of optionMenu_p1_rax2
	optionMenu_p1_rax2 = XtVaCreateManagedWidget( "optionMenu_p1_rax2",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "rax2" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_rax2, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_rax2,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_rax2, (char *) this );
	
	// Creation of optionMenu_p1_rax4
	optionMenu_p1_rax4 = XtVaCreateManagedWidget( "optionMenu_p1_rax4",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "rax4" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_rax4, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_rax4,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_rax4, (char *) this );


	// Creation of optionMenu_p1_psci
	optionMenu_p1_psci = XtVaCreateManagedWidget( "optionMenu_p1_psci",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "psci" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_psci, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_psci,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_psci, (char *) this );


	// Creation of optionMenu_p1_riso
	optionMenu_p1_riso = XtVaCreateManagedWidget( "optionMenu_p1_riso",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "riso" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_riso, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_riso,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_riso, (char *) this );
//Creation of optionMenu_p1_tiff
	optionMenu_p1_tiff = XtVaCreateManagedWidget( "optionMenu_p1_tiff",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "tiff" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_tiff, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_tiff,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_tiff, (char *) this );
//Creation of optionMenu_p1_bsl
	optionMenu_p1_bsl = XtVaCreateManagedWidget( "optionMenu_p1_bsl",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "bsl" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_bsl, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_bsl,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_bsl, (char *) this );
//Creation of optionMenu_p1_id2
	optionMenu_p1_id2 = XtVaCreateManagedWidget( "optionMenu_p1_id2",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "ESRF_ID2(KLORA)" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_id2, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_id2,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_id2, (char *) this );
//Creation of optionMenu_p1_loq_1d
	optionMenu_p1_loq_1d = XtVaCreateManagedWidget( "optionMenu_p1_loq_1d",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "LOQ1D" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_loq_1d, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_loq_1d,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_loq_1d, (char *) this );


//Creation of optionMenu_p1_loq_2d
	optionMenu_p1_loq_2d = XtVaCreateManagedWidget( "optionMenu_p1_loq_2d",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "LOQ2D" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_loq_2d, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_loq_2d,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_loq_2d, (char *) this );

//Creation of optionMenu_p1_smv
	optionMenu_p1_smv = XtVaCreateManagedWidget( "optionMenu_p1_smv",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "SMV" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_smv, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_smv,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_smv, (char *) this );
//Creation of optionMenu_p1_id3
	optionMenu_p1_id3 = XtVaCreateManagedWidget( "optionMenu_p1_id3",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "ESRF_ID3" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_id3, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_id3,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_id3, (char *) this );
//Creation of optionMenu_p1_bruker_gfrm
	optionMenu_p1_bruker_gfrm = XtVaCreateManagedWidget( "optionMenu_p1_bruker_gfrm",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			//RES_CONVERT( XmNlabelString, "BRUKER_gfrm" ),
			 RES_CONVERT( XmNlabelString, "BRUKER" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_bruker_gfrm, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_bruker_gfrm,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_bruker_gfrm, (char *) this );
/*
//Creation of optionMenu_p1_bruker_asc
	optionMenu_p1_bruker_asc = XtVaCreateManagedWidget( "optionMenu_p1_bruker_asc",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "BRUKER_asc" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_bruker_asc, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_bruker_asc,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_bruker_asc, (char *) this );

//Creation of optionMenu_p1_bruker_plosto
	optionMenu_p1_bruker_plosto = XtVaCreateManagedWidget( "optionMenu_p1_bruker_plosto",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "BRUKER_plosto" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_bruker_plosto, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_bruker_plosto,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_bruker_plosto, (char *) this );
*/
//Creation of optionMenu_p1_mar345
	optionMenu_p1_mar345 = XtVaCreateManagedWidget( "optionMenu_p1_mar345",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "MAR345" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_mar345, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_mar345,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_mar345, (char *) this );
//Creation of optionMenu_p1_sans
	optionMenu_p1_sans = XtVaCreateManagedWidget( "optionMenu_p1_sans",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "ILL_SANS" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_sans, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_sans,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_sans, (char *) this );
	// Creation of optionMenu1
	optionMenu1 = XtVaCreateManagedWidget( "optionMenu1",
			xmRowColumnWidgetClass,
			bulletinBoard1,
			XmNrowColumnType, XmMENU_OPTION,
			XmNsubMenuId, optionMenu_p1,
			XmNx, 104,
			XmNy, 214,
			XmNmarginHeight, 3,
			XmNmarginWidth, 3,
			NULL );
	UxPutContext( optionMenu1, (char *) this );


	// Creation of inpixlabel
	inpixlabel = XtVaCreateManagedWidget( "inpixlabel",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 20,
			XmNy, 349,
			RES_CONVERT( XmNlabelString, "Pixels :" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( inpixlabel, (char *) this );


	// Creation of inrastlabel
	inrastlabel = XtVaCreateManagedWidget( "inrastlabel",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 165,
			XmNy, 349,
			RES_CONVERT( XmNlabelString, "Rasters :" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( inrastlabel, (char *) this );


	// Creation of inpixField
	inpixField = XtVaCreateManagedWidget( "inpixField",
			xmTextFieldWidgetClass,
			bulletinBoard1,
			XmNwidth, 60,
			XmNx, 85,
			XmNy, 346,
			XmNfontList, UxConvertFontList("9x15" ),
			XmNvalue, "",
			NULL );
	XtAddCallback( inpixField, XmNvalueChangedCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_valueChangedCB_inpixField,
		(XtPointer) NULL );

	UxPutContext( inpixField, (char *) this );


	// Creation of inrastField
	inrastField = XtVaCreateManagedWidget( "inrastField",
			xmTextFieldWidgetClass,
			bulletinBoard1,
			XmNwidth, 60,
			XmNx, 241,
			XmNy, 346,
			XmNfontList, UxConvertFontList("9x15" ),
			XmNvalue, "",
			NULL );
	XtAddCallback( inrastField, XmNvalueChangedCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_valueChangedCB_inrastField,
		(XtPointer) NULL );

	UxPutContext( inrastField, (char *) this );


	// Creation of skiplabel
	skiplabel = XtVaCreateManagedWidget( "skiplabel",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 20,
			XmNy, 419,
			RES_CONVERT( XmNlabelString, "Bytes to skip : " ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( skiplabel, (char *) this );


	// Creation of aspectlabel
	aspectlabel = XtVaCreateManagedWidget( "aspectlabel",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 20,
			XmNy, 469,
			RES_CONVERT( XmNlabelString, "Aspect ratio :" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( aspectlabel, (char *) this );


	// Creation of rangeLabel
	rangeLabel = XtVaCreateManagedWidget( "rangeLabel",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 20,
			XmNy, 519,
			RES_CONVERT( XmNlabelString, "Dynamic range :" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( rangeLabel, (char *) this );


	// Creation of toggleButton1
	toggleButton1 = XtVaCreateManagedWidget( "toggleButton1",
			xmToggleButtonWidgetClass,
			bulletinBoard1,
			XmNx, 205,
			XmNy, 281,
			RES_CONVERT( XmNlabelString, " Swap byte order" ),
			XmNindicatorType, XmONE_OF_MANY,
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			XmNhighlightThickness, 0,
			NULL );
	UxPutContext( toggleButton1, (char *) this );


	// Creation of skipField
	skipField = XtVaCreateManagedWidget( "skipField",
			xmTextFieldWidgetClass,
			bulletinBoard1,
			XmNwidth, 60,
			XmNx, 156,
			XmNy, 416,
			XmNfontList, UxConvertFontList("9x15" ),
			XmNvalue, "",
			NULL );
	UxPutContext( skipField, (char *) this );


	// Creation of aspectField
	aspectField = XtVaCreateManagedWidget( "aspectField",
			xmTextFieldWidgetClass,
			bulletinBoard1,
			XmNwidth, 60,
			XmNx, 156,
			XmNy, 466,
			XmNfontList, UxConvertFontList("9x15" ),
			XmNvalue, "",
			NULL );
	UxPutContext( aspectField, (char *) this );


	// Creation of rangeField
	rangeField = XtVaCreateManagedWidget( "rangeField",
			xmTextFieldWidgetClass,
			bulletinBoard1,
			XmNwidth, 60,
			XmNx, 156,
			XmNy, 516,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( rangeField, (char *) this );


	// Creation of separator1
	separator1 = XtVaCreateManagedWidget( "separator1",
			xmSeparatorWidgetClass,
			bulletinBoard1,
			XmNwidth, 800,
			XmNheight, 10,
			XmNx, 0,
			XmNy, 579,
			NULL );
	UxPutContext( separator1, (char *) this );


	// Creation of label16
	label16 = XtVaCreateManagedWidget( "label16",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 425,
			XmNy, 349,
			RES_CONVERT( XmNlabelString, "Pixels :" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( label16, (char *) this );


	// Creation of label17
	label17 = XtVaCreateManagedWidget( "label17",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 570,
			XmNy, 349,
			RES_CONVERT( XmNlabelString, "Rasters :" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( label17, (char *) this );


	// Creation of outpixField
	outpixField = XtVaCreateManagedWidget( "outpixField",
			xmTextFieldWidgetClass,
			bulletinBoard1,
			XmNwidth, 60,
			XmNx, 490,
			XmNy, 346,
			XmNfontList, UxConvertFontList("9x15" ),
			XmNvalue, "",
			NULL );
	UxPutContext( outpixField, (char *) this );


	// Creation of outrastField
	outrastField = XtVaCreateManagedWidget( "outrastField",
			xmTextFieldWidgetClass,
			bulletinBoard1,
			XmNwidth, 60,
			XmNx, 646,
			XmNy, 346,
			XmNfontList, UxConvertFontList("9x15" ),
			XmNvalue, "",
			NULL );
	UxPutContext( outrastField, (char *) this );


	// Creation of label18
	label18 = XtVaCreateManagedWidget( "label18",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 425,
			XmNy, 218,
			RES_CONVERT( XmNlabelString, "File type : " ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( label18, (char *) this );


	// Creation of label19
	label19 = XtVaCreateManagedWidget( "label19",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 425,
			XmNy, 419,
			RES_CONVERT( XmNlabelString, "Header 1 :" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( label19, (char *) this );


	// Creation of label20
	label20 = XtVaCreateManagedWidget( "label20",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 425,
			XmNy, 519,
			RES_CONVERT( XmNlabelString, "Header 2 :" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( label20, (char *) this );


	// Creation of scrolledWindowText2
	scrolledWindowText2 = XtVaCreateManagedWidget( "scrolledWindowText2",
			xmScrolledWindowWidgetClass,
			bulletinBoard1,
			XmNscrollingPolicy, XmAPPLICATION_DEFINED,
			XmNvisualPolicy, XmVARIABLE,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNx, 514,
			XmNy, 416,
			NULL );
	UxPutContext( scrolledWindowText2, (char *) this );


	// Creation of header1Text
	header1Text = XtVaCreateManagedWidget( "header1Text",
			xmTextWidgetClass,
			scrolledWindowText2,
			XmNwidth, 267,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( header1Text, (char *) this );


	// Creation of scrolledWindowText3
	scrolledWindowText3 = XtVaCreateManagedWidget( "scrolledWindowText3",
			xmScrolledWindowWidgetClass,
			bulletinBoard1,
			XmNscrollingPolicy, XmAPPLICATION_DEFINED,
			XmNvisualPolicy, XmVARIABLE,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNx, 514,
			XmNy, 516,
			NULL );
	UxPutContext( scrolledWindowText3, (char *) this );


	// Creation of header2Text
	header2Text = XtVaCreateManagedWidget( "header2Text",
			xmTextWidgetClass,
			scrolledWindowText3,
			XmNwidth, 267,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( header2Text, (char *) this );


	// Creation of pushButton2
	pushButton2 = XtVaCreateManagedWidget( "pushButton2",
			xmPushButtonWidgetClass,
			bulletinBoard1,
			XmNx, 260,
			XmNy, 602,
			XmNwidth, 100,
			XmNheight, 35,
			RES_CONVERT( XmNlabelString, "Run" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	XtAddCallback( pushButton2, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_pushButton2,
		(XtPointer) NULL );

	UxPutContext( pushButton2, (char *) this );


	// Creation of pushButton3
	pushButton3 = XtVaCreateManagedWidget( "pushButton3",
			xmPushButtonWidgetClass,
			bulletinBoard1,
			XmNx, 680,
			XmNy, 602,
			XmNwidth, 100,
			XmNheight, 35,
			RES_CONVERT( XmNlabelString, "Help" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	XtAddCallback( pushButton3, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_pushButton3,
		(XtPointer) NULL );

	UxPutContext( pushButton3, (char *) this );


	// Creation of pushButton4
	pushButton4 = XtVaCreateManagedWidget( "pushButton4",
			xmPushButtonWidgetClass,
			bulletinBoard1,
			XmNx, 560,
			XmNy, 602,
			XmNwidth, 100,
			XmNheight, 35,
			RES_CONVERT( XmNlabelString, "Quit" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	XtAddCallback( pushButton4, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_pushButton4,
		(XtPointer) NULL );

	UxPutContext( pushButton4, (char *) this );
	// Creation of saveButton
	saveButton = XtVaCreateManagedWidget( "saveButton",
			xmPushButtonWidgetClass,
			bulletinBoard1,
			XmNx, 140,
			XmNy, 602,
			XmNwidth, 100,
			XmNheight, 35,
			RES_CONVERT( XmNlabelString, "Save profile" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	XtAddCallback( saveButton, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_saveButton,
		(XtPointer) NULL );

	UxPutContext( saveButton, (char *) this );


	// Creation of loadButton
	loadButton = XtVaCreateManagedWidget( "loadButton",
			xmPushButtonWidgetClass,
			bulletinBoard1,
			XmNx, 20,
			XmNy, 602,
			XmNwidth, 100,
			XmNheight, 35,
			RES_CONVERT( XmNlabelString, "Load profile" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			XmNsensitive, TRUE,
			NULL );
	XtAddCallback( loadButton, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_loadButton,
		(XtPointer) NULL );

	UxPutContext( loadButton, (char *) this );


	// Creation of incField
	incField = XtVaCreateManagedWidget( "incField",
			xmTextFieldWidgetClass,
			bulletinBoard1,
			XmNwidth, 40,
			XmNx, 298,
			XmNy, 147,
			XmNfontList, UxConvertFontList("9x15" ),
			XmNvalue, "",
			NULL );
	UxPutContext( incField, (char *) this );


	// Creation of scrolledWindowText4
	scrolledWindowText4 = XtVaCreateManagedWidget( "scrolledWindowText4",
			xmScrolledWindowWidgetClass,
			bulletinBoard1,
			XmNscrollingPolicy, XmAPPLICATION_DEFINED,
			XmNvisualPolicy, XmVARIABLE,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNx, 522,
			XmNy, 77,
			NULL );
	UxPutContext( scrolledWindowText4, (char *) this );


	// Creation of outfileText
	outfileText = XtVaCreateManagedWidget( "outfileText",
			xmTextWidgetClass,
			scrolledWindowText4,
			XmNwidth, 183,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( outfileText, (char *) this );


	// Creation of pushButton7
	pushButton7 = XtVaCreateManagedWidget( "pushButton7",
			xmPushButtonWidgetClass,
			bulletinBoard1,
			XmNx, 715,
			XmNy, 77,
			RES_CONVERT( XmNlabelString, "Browse" ),
			XmNmarginHeight, 5,
			XmNmarginWidth, 5,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton7, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_pushButton7,
		(XtPointer) NULL );

	UxPutContext( pushButton7, (char *) this );


	// Creation of label5
	label5 = XtVaCreateManagedWidget( "label5",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 20,
			XmNy, 281,
			RES_CONVERT( XmNlabelString, "Data type :" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( label5, (char *) this );


	// Creation of datalabel
	datalabel = XtVaCreateManagedWidget( "datalabel",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 118,
			RES_CONVERT( XmNlabelString, "float" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			XmNy, 281,
			NULL );
	UxPutContext( datalabel, (char *) this );


	// Creation of label6
	label6 = XtVaCreateManagedWidget( "label6",
			xmLabelWidgetClass,
			bulletinBoard1,
			XmNx, 425,
			XmNy, 281,
			RES_CONVERT( XmNlabelString, "Data type :" ),
			XmNfontList, UxConvertFontList("-adobe-times-medium-r-normal--18-180-75-75-p-94-iso8859-1" ),
			NULL );
	UxPutContext( label6, (char *) this );


	// Creation of optionMenu_p2
	optionMenu_p2_shell = XtVaCreatePopupShell ("optionMenu_p2_shell",
			xmMenuShellWidgetClass, bulletinBoard1,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	optionMenu_p2 = XtVaCreateWidget( "optionMenu_p2",
			xmRowColumnWidgetClass,
			optionMenu_p2_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( optionMenu_p2, (char *) this );
// Creation of optionMenu_p3
	optionMenu_p3_shell = XtVaCreatePopupShell ("optionMenu_p3_shell",
			xmMenuShellWidgetClass, bulletinBoard1,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	optionMenu_p3 = XtVaCreateWidget( "optionMenu_p3",
			xmRowColumnWidgetClass,
			optionMenu_p3_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( optionMenu_p3, (char *) this );




	// Creation of optionMenu_p1_float32
	optionMenu_p1_float32 = XtVaCreateManagedWidget( "optionMenu_p1_float32",
			xmPushButtonWidgetClass,
			optionMenu_p2,
			RES_CONVERT( XmNlabelString, "float32" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_float32, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_float32,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_float32, (char *) this );

// Creation of optionMenu_p1_bsl_out
	optionMenu_p1_BSL_out = XtVaCreateManagedWidget( "optionMenu_p1_BSL_out",
			xmPushButtonWidgetClass,
			optionMenu_p3,
			RES_CONVERT( XmNlabelString, "BSL" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_BSL_out, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_BSL_out,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_BSL_out, (char *) this );
// Creation of optionMenu_p1_tiff_8out
	optionMenu_p1_tiff_8out = XtVaCreateManagedWidget( "optionMenu_p1_tiff_8out",
			xmPushButtonWidgetClass,
			optionMenu_p3,
			RES_CONVERT( XmNlabelString, "Tiff 8bit" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_tiff_8out, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_tiff_8out,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_tiff_8out, (char *) this );
// Creation of optionMenu_p1_tiff_16out
	optionMenu_p1_tiff_16out = XtVaCreateManagedWidget( "optionMenu_p1_tiff_16out",
			xmPushButtonWidgetClass,
			optionMenu_p3,
			RES_CONVERT( XmNlabelString, "Tiff 16bit" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_tiff_16out, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_tiff_16out,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_tiff_16out, (char *) this );

// Creation of optionMenu_p1_txt_out
	optionMenu_p1_txt_out = XtVaCreateManagedWidget( "optionMenu_p1_txt_out",
			xmPushButtonWidgetClass,
			optionMenu_p3,
			RES_CONVERT( XmNlabelString, "Txt" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_txt_out, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_txt_out,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_txt_out, (char *) this );
	// Creation of optionMenu_p1_float64
	optionMenu_p1_float64 = XtVaCreateManagedWidget( "optionMenu_p1_float64",
			xmPushButtonWidgetClass,
			optionMenu_p2,
			RES_CONVERT( XmNlabelString, "float64" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_float64, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_float64,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_float64, (char *) this );


	// Creation of optionMenu_p1_int16
	optionMenu_p1_int16 = XtVaCreateManagedWidget( "optionMenu_p1_int16",
			xmPushButtonWidgetClass,
			optionMenu_p2,
			RES_CONVERT( XmNlabelString, "int16" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_int16, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_int16,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_int16, (char *) this );


	// Creation of optionMenu_p1_uint16
	optionMenu_p1_uint16 = XtVaCreateManagedWidget( "optionMenu_p1_uint16",
			xmPushButtonWidgetClass,
			optionMenu_p2,
			RES_CONVERT( XmNlabelString, "uint16" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_uint16, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_uint16,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_uint16, (char *) this );


	// Creation of optionMenu_p1_int32
	optionMenu_p1_int32 = XtVaCreateManagedWidget( "optionMenu_p1_int32",
			xmPushButtonWidgetClass,
			optionMenu_p2,
			RES_CONVERT( XmNlabelString, "int32" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_int32, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_int32,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_int32, (char *) this );


	// Creation of optionMenu_p1_uint32
	optionMenu_p1_uint32 = XtVaCreateManagedWidget( "optionMenu_p1_uint32",
			xmPushButtonWidgetClass,
			optionMenu_p2,
			RES_CONVERT( XmNlabelString, "uint32" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_uint32, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_uint32,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_uint32, (char *) this );


	// Creation of optionMenu_p1_int64
	optionMenu_p1_int64 = XtVaCreateManagedWidget( "optionMenu_p1_int64",
			xmPushButtonWidgetClass,
			optionMenu_p2,
			RES_CONVERT( XmNlabelString, "int64" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_int64, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_int64,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_int64, (char *) this );


	// Creation of optionMenu_p1_uint64
	optionMenu_p1_uint64 = XtVaCreateManagedWidget( "optionMenu_p1_uint64",
			xmPushButtonWidgetClass,
			optionMenu_p2,
			RES_CONVERT( XmNlabelString, "uint64" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_uint64, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_uint64,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_uint64, (char *) this );


	// Creation of optionMenu_p1_char8
	optionMenu_p1_char8 = XtVaCreateManagedWidget( "optionMenu_p1_char8",
			xmPushButtonWidgetClass,
			optionMenu_p2,
			RES_CONVERT( XmNlabelString, "char8" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_char8, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_char8,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_char8, (char *) this );


	// Creation of optionMenu_p1_uchar8
	optionMenu_p1_uchar8 = XtVaCreateManagedWidget( "optionMenu_p1_uchar8",
			xmPushButtonWidgetClass,
			optionMenu_p2,
			RES_CONVERT( XmNlabelString, "uchar8" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( optionMenu_p1_uchar8, XmNactivateCallback,
		(XtCallbackProc) &_UxCmainWS::Wrap_activateCB_optionMenu_p1_uchar8,
		(XtPointer) NULL );

	UxPutContext( optionMenu_p1_uchar8, (char *) this );


	// Creation of optionMenu2
	optionMenu2 = XtVaCreateManagedWidget( "optionMenu2",
			xmRowColumnWidgetClass,
			bulletinBoard1,
			XmNrowColumnType, XmMENU_OPTION,
			XmNsubMenuId, optionMenu_p2,
			XmNx, 517,
			XmNy, 277,
			XmNmarginHeight, 3,
			XmNmarginWidth, 3,
			NULL );
	UxPutContext( optionMenu2, (char *) this );

// Creation of optionMenu3
	optionMenu3 = XtVaCreateManagedWidget( "optionMenu3",
			xmRowColumnWidgetClass,
			bulletinBoard1,
			XmNrowColumnType, XmMENU_OPTION,
			XmNsubMenuId, optionMenu_p3,
			XmNx, 517,
			XmNy, 214,
			XmNmarginHeight, 3,
			XmNmarginWidth, 3,
			NULL );
	UxPutContext( optionMenu3, (char *) this );


	XtAddCallback( mainWS, XmNdestroyCallback,
		(XtCallbackProc) &_UxCmainWS::UxDestroyContextCB,
		(XtPointer) this);


	return ( mainWS );
}

/*******************************************************************************
       The following function includes the code that was entered
       in the 'Initial Code' and 'Final Code' sections of the
       Declarations Editor. This function is called from the
       'Interface function' below.
*******************************************************************************/

swidget _UxCmainWS::_create_mainWS(void)
{
	Widget                  rtrn;
	UxThis = rtrn = _build();

	// Final Code from declarations editor
	busyCursor=XCreateFontCursor(UxDisplay,XC_watch);
	SetIconImage(UxGetWidget(rtrn));

	FileSelect=create_FileSelection(rtrn);
	ErrMessage=create_ErrorMessage(rtrn);
	QuestDialog=create_QuestionDialog(rtrn);
	InfoDialog=create_InformationDialog(rtrn);

	if ((ccp13ptr =(char*)getenv ("CCP13HOME")))
	{
	    strcpy(helpfile,ccp13ptr);
	    strcat(helpfile,"/doc/xconv.html");
	}
	else
	{
	    strcpy(helpfile,"http://www.ccp13.ac.uk/software/program/xconv5.html");
	}

	infileptr="";
	outfileptr="";
	inpixptr="";
	inrastptr="";
	outpixptr="";
	outrastptr="";
	skptr="0";
	asptr="1.0";
	rangeptr="";
	firstptr="1";
	lastptr="1";
	incptr="1";
	dataptr="float";
	dtype=0;
	

#ifndef DESIGN_TIME
	  nFirst=1;
	  nLast=1;
	  nInc=1;
	  sType=strng("float");
#endif

	mainWS_UpdateFields(rtrn,&UxEnv);
	mainWS_UpdateData(rtrn,&UxEnv);
	mainWS_FieldsEditable(rtrn,&UxEnv,1);
	mainWS_FieldsEditable_out(rtrn,&UxEnv,1);
	mainWS_RangeSensitive(rtrn,&UxEnv,0);
	mainWS_UpdateRun(rtrn,&UxEnv);
	mainWS_RunSensitive(rtrn,&UxEnv,0);

	return(rtrn);
}

/*******************************************************************************
       The following is the destructor function.
*******************************************************************************/

_UxCmainWS::~_UxCmainWS()
{
	if (this->UxThis)
	{
		XtRemoveCallback( UxGetWidget(this->UxThis),
			XmNdestroyCallback,
			(XtCallbackProc) &_UxCmainWS::UxDestroyContextCB,
			(XtPointer) this);
		UxDestroyInterface(this->UxThis);
	}
}

/*******************************************************************************
       The following is the constructor function.
*******************************************************************************/

_UxCmainWS::_UxCmainWS( swidget UxParent )
{
	this->UxParent = UxParent;

	// User Supplied Constructor Code
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

swidget create_mainWS( swidget UxParent )
{
	_UxCmainWS *theInterface =
			new _UxCmainWS( UxParent );
	return (theInterface->_create_mainWS());
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/


/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/
#ifdef WIN32
#include "stdafx.h"
#endif
#include "file.h"


  char* stripws(char*);
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
  strng ("esrf_id2(klora)"),
  strng ("esrf_id3"),
  strng ("loq1d"),
  strng ("loq2d"),
  strng ("smv"),
  strng ("bruker"),
  strng ("bruker_asc"),
  strng ("bruker_plosto"),
  strng ("tiff"),
  strng ("mar345"),
  strng ("bsl"),
  strng ("rax4"),
  strng ("ILL_SANS"),
   };
  static const int CHARW=0;
  static const int SHORTW=1;
  static const int INTW=2;
  static const int FLOATW=3;
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

  static myBool bSwap ,tiffseries;
  static strng sType,sFile,sNthFile,sOutFile,soFile,iType;
  static strng sHead1,sHead2;
  static int nSkip,nInPix,nInRast,nOutPix,nOutRast,dtype;
  static int nFirst,nLast,nInc,nFrames,indice10,fileNo;
  static double dAspect,dRange;
  
/*******************************************************************************
Auxiliary code from the Declarations Editor:
*******************************************************************************/

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

int Convert()
{
	try
	{
		int j;
      BSLHeader* pHeader;
      BinaryOutFile* pBinary;
      InConvFile* pInFile;
      tiffOutFile* tifffile;
	   txtOutFile* txtfile;
    
      // Loop over run numbers
      for (int i = nFirst; i <= nLast; i += nInc)
	{
 
      // Get file name for this run number
	  sNthFile = InConvFile::getNthFileName (sFile, i);
	 
	  // Create an input binary/text file object of the required type
	   switch(match(psTypes,nTypes,sType))
	    {
			 
	    case CHARW: // unsigned char
	      pInFile=new BinInFile<unsigned char>(sNthFile.data(),nInPix,nInRast,bSwap,nSkip,dAspect);
	      break;
	   case SHORTW: // unsigned short
	      pInFile=new BinInFile<unsigned short>(sNthFile.data(),nInPix,nInRast,bSwap,nSkip,dAspect);
	      break;
	      
	    case INTW: // unsigned int
	      pInFile=new BinInFile<unsigned int>(sNthFile.data(),nInPix,nInRast,bSwap,nSkip,dAspect);
	      break;

	    case FLOATW: // float
			
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
	   case   BSL: //BSl file
	       pInFile =new BslInFile(sNthFile.data (),0,0);
	       break;
		 case SANS:
			  pInFile =new SANSInFile (sNthFile.data (),0);
			break;
	    case TIF: // Tif file format
			pInFile = new TiffInFile (sNthFile.data (),0);
			break;
			 
	    default:
#ifdef _CONSOLE	  
	printf ("No matching file format:");
#else
	 AfxMessageBox("No matching file format:");
#endif
   return 0;	     
	
	    }

	   if (pInFile == NULL)
	    {
#ifdef _CONSOLE	  
	printf ("Error allocating memory");
#else
	 AfxMessageBox("Error allocating memory");
#endif
   return 0;

       
	    }
	 
	  
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
   /*/////////////////////////SANSfile///////////////////////
			  else if (match(psTypes,nTypes,sType)==SANS&&nFrames==1)
				
		      {
			  int error,dim;
               dim=pInFile->rasters();
			   error=pInFile->bslfilNo();			  
				if(dim>1&&error==0)
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
				}
			   
			  if(dim==1)
			  {
			   pInFile = new SANSInFile (sNthFile.data (),2);
			   nOutPix = pInFile->pixels ();
			   nOutRast = pInFile->rasters (nOutPix);
			   if (error==1)
			   {
					pHeader->WriteHeader(nOutPix,nOutRast,dtype,nFrames,1,2);
			   }
			   else
			   {
				   pHeader->WriteHeader(nOutPix,nOutRast,dtype,nFrames,0,2);
			   }
			   pBinary = new BinaryOutFile ((pHeader->binaryName ()).data ());
			  }else if(error==1)
			  {
				pInFile = new SANSInFile (sNthFile.data (),2);
			   nOutPix = pInFile->pixels ();
			   nOutRast = pInFile->rasters (nOutPix);
			   pHeader->WriteHeader(nOutPix,nOutRast,dtype,nFrames,0,2);
			   pBinary = new BinaryOutFile ((pHeader->binaryName ()).data ());
			  }

			  if((dim==1)&&(error==1))
			  {
				pInFile->putdtype(dtype);
			   pInFile->convert (*pHeader, *pBinary);
			   delete pInFile;
			   delete pBinary;

			   pInFile = new SANSInFile (sNthFile.data (),3);
			   nOutPix = pInFile->pixels ();
			   nOutRast = pInFile->rasters (nOutPix);
			   pHeader->WriteHeader(nOutPix,nOutRast,dtype,nFrames,0,3);
			   pBinary = new BinaryOutFile ((pHeader->binaryName ()).data ());
			  }
	 
			  } ///////////////////////////*/
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
	    
#ifdef _CONSOLE	  
	printf (xerr.sReason.data());
#else
	AfxMessageBox(xerr.sReason.data());
#endif
   return 0;
	}
 }
/*----------------------------------------------
 * Insert application global declarations here
 *---------------------------------------------*/
#ifndef _CONSOLE	
void Mainw(CString OutFileName, CString InFileName, CString Head1,CString Head2,CString InFileType,int InPixel,\
		   int InRast,int Swap ,int OutPix,int OutRast,int first,int last,int inc,float aratio,float drange,\
		   int Hbyte ,int outdtype )
{  	   
     sHead1=Head1;
     sHead2=Head2;
  	 sFile= InFileName;
	 
	 dtype=outdtype;
	 nFirst=first;
	 nLast=last;
	 nInc=inc;
	 sType=InFileType;
     nInPix=InPixel;
	 nInRast= InRast;
     nSkip=Hbyte;
   	 bSwap=Swap;
	 dAspect=aratio;
	 nOutPix=OutPix;
	 nOutRast=OutRast;
	// outdataptr=outfiletype.GetBuffer();
	 if(dtype<10)
	 {

	 char *sptr,*pptr;
	 sptr=OutFileName.GetBuffer();
 #ifdef WIN32
if( (pptr=strrchr(sptr,'\\')) !=NULL )
#else
  if( (pptr=strrchr(sptr,'/')) !=NULL )
#endif
  {
    pptr++;
  }
  else
    pptr=sptr;
	 
	 

	 for(int i=0;i<=strlen(pptr);i++)
	   {
	   if(islower((int)pptr[i]))
	   pptr[i]=toupper((int)pptr[i]);
    	}
      sOutFile=strng(sptr);
    
	 }else if(dtype>10)
	 {
		 soFile=OutFileName;
		 int nOff; 
		 if ((nOff = soFile.find("#")) != NPS)
		 {
			 tiffseries=1;
		 }
		 else
		 {
			 tiffseries=0;
			 sOutFile=OutFileName;
		 }
	 }
	 else sOutFile=OutFileName;
          
			dRange=drange;

	if( Convert())
	{
	#ifdef _CONSOLE	  
	printf ("Conversion completed");
	#else
	AfxMessageBox("Conversion completed ");
	#endif
	}

}
#else
void main(int argc, char *argv[])
{
	dtype=0;
	char input[256];
    //"Input File Name"
	fgets(input, 80, stdin);
	//fgets(input, 80, stdin);
	sFile=stripws(input);
	//"output File Name"
	fgets(input, 80, stdin);
	sOutFile =stripws(input);
	fgets(input, 80, stdin);
	nInPix=atoi(input);
	fgets(input, 80, stdin);
	nInRast=atoi(input);
	fgets(input, 80, stdin);
	dAspect=atof(input);
	fgets(input, 80, stdin);
	dRange=atof(input);
    fgets(input, 80, stdin);
    sType=stripws(input);
    fgets(input, 80, stdin);
	nSkip=atoi(input);
	fgets(input, 80, stdin);
    bSwap=atoi(input);
	fgets(input, 80, stdin);
	sHead1=stripws(input);
	fgets(input, 80, stdin);
	sHead2=stripws(input);
	fgets(input, 80, stdin);
	nOutPix=atoi(input);
	fgets(input, 80, stdin);
	nOutRast=atoi(input);
	fgets(input, 80, stdin);
	dtype=atoi(input);

	nFirst=1;
	nLast=1;
	nInc=1;
	 if(dtype<10)
	 {

	 char *sptr,*pptr;
	 sptr=strdup(sOutFile.data());

	 if((pptr=strrchr(sptr,(int)'/'))==NULL)
	 {
		 pptr=sptr;
	 }
	 else
	  pptr++;

	/* for(int i=0;i<=strlen(pptr);i++)
	   {
	   if(islower((int)pptr[i]))
	   pptr[i]=toupper((int)pptr[i]);
    	}*/
	  for(int i=0;i<=strlen(pptr);i++)
	   {
	   if(islower((int)pptr[i]))
	   pptr[i]=toupper((int)pptr[i]);
    	}
      sOutFile=strng(sptr);
    
	 }if(dtype>10)
	 {
		 soFile=sOutFile;
		 int nOff; 
		 if ((nOff = soFile.find("#")) != NPS)
		 {
			 tiffseries=1;
		 }
		 else
		 {
			 tiffseries=0;
			 
		 }
	 }
 
	if( Convert())
	{
	printf ("Conversion completed");
	
	}
}
#endif

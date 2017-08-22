#include "file.h"
#include "mainWS.h"
#include "tiffio.h"
#include "pck.h"
inline unsigned char bswap (unsigned char ucIn)
{
  return ucIn;
}

inline unsigned short bswap (unsigned short usIn)
{
  union {
    unsigned char c[2];
    unsigned short s;
  } u;

  unsigned char cTmp;

  u.s = usIn;
  cTmp = u.c[0];
  u.c[0] = u.c[1];
  u.c[1] = cTmp;
  return u.s;
}
inline signed short bswap (signed short sIn)
{
  union {
    unsigned char c[2];
    signed short s;
  } u;
  
  unsigned char cTmp;
  
  u.s = sIn;
  cTmp = u.c[0];
  u.c[0] = u.c[1];
  u.c[1] = cTmp;
  return u.s;
}
inline unsigned int bswap (unsigned int unIn)
{
  union {
    unsigned short s[2];
    unsigned int n;
  } u;

  unsigned short sTmp;
  u.n = unIn;
  sTmp = bswap (u.s[0]);
  u.s[0] = bswap (u.s[1]);
  u.s[1] = sTmp;
  
  return u.n;
}
inline signed int bswap (signed int nIn)
{
  union {
    unsigned short s[2];
    signed int n;
  } u;

  unsigned short sTmp;
  u.n = nIn;
  sTmp = bswap (u.s[0]);
  u.s[0] = bswap (u.s[1]);
  u.s[1] = sTmp;

  return u.n;
}
inline signed long bswap (signed long lIn)
{
  union {
    unsigned int s[2];
    signed long n;
  } u;
  
  unsigned int sTmp;
  u.n = lIn;
  sTmp = bswap (u.s[0]);
  u.s[0] = bswap (u.s[1]);
  u.s[1] = sTmp;

  return u.n;
}
inline unsigned long bswap (unsigned long ulIn)
{
  union {
    unsigned int s[2];
    unsigned long n;
  } u;
  
  unsigned int sTmp;
  u.n = ulIn;
  sTmp = bswap (u.s[0]);
  u.s[0] = bswap (u.s[1]);
  u.s[1] = sTmp;
  
  return u.n;
}
inline float bswap (float fIn)
{
  union {
    unsigned int n;
    float f;
  } u;

  u.f = fIn;
  u.n=bswap(u.n);
  
  return u.f;
}
inline double bswap (double dIn)
{
  union {
    unsigned long n;
    float d;
  } u;
  
  u.d = dIn;
  u.n=bswap(u.n);

  return u.d;
}
Endian ConvFile::getEndian ()
{
  unsigned short one = 1;
  return ((Endian) *(unsigned char *) &one);
}

void ConvFile::putdtype(int type)
{
  dtype=type;
}
/*void ConvFile::putcurrentdir(int dir)
{
   currentdir=dir;
}*/
 int ConvFile:: getdircount()
    {
      return dircount;
    }

void InConvFile::openFile ()
{
  char* errmsg=new char[200];
  if ((pFile = fopen (sFileName.data(), "r")) == 0)
    {
      sprintf(errmsg,"Error opening file %s: %s",sFileName.data(),strerror(errno));
      THROW_ERR(errmsg);
    }
  delete[]errmsg;
  nFileDescriptor = fileno (pFile);
}

strng InConvFile::getNthFileName (const strng& sName, int n)
{
  char cTmp[16];
  ostrstream out (cTmp, sizeof (cTmp));
  size_t nOff;
  strng sN;
  strng sNth = sName;
  int nLen = 1;

  if ((nOff = sNth.find ("%")) != NPS)
    {
      out << n << ends;
      sN = strng (out.str ());
      sNth.replace (nOff, nLen, sN);
    }
  else if ((nOff = sNth.find ("#")) != NPS)
    {
      for (int i = nOff + 1; i < sNth.length (); i++)
	{
	  if (sNth[i] != '#')
	    {
	      nLen = i - nOff;
	      break;
	    }
	}

      out << setfill ('0') << setw (nLen) << n << ends;
      sN = strng (out.str ());
      sNth.replace (nOff, nLen, sN);
    }

  return sNth;
}

BinaryInFile::BinaryInFile (const char* pszN,
			    myBool bSwp = IS_FALSE,
			    int nOff = 0, double dAsp = 1.0) :
  InConvFile (pszN),
  bSwap (bSwp),
  ulOffset ((unsigned long) nOff), dAspect (dAsp)
{
  openFile ();
}

BinaryInFile::BinaryInFile (BinaryInFile& b)
{
  if(pfLine){
    delete[] pfLine;
    pfLine=NULL;
  }
  if(pMap){
    delete pMap;
    pMap = NULL;
  }

  fclose (pFile);

  sFileName = b.sFileName;
  openFile ();

  nInPixels = b.nInPixels;
  nInRasters = b.nInRasters;
  nRecordLength = b.nRecordLength;
  bSwap = b.bSwap;
  ulOffset = b.ulOffset;
  dAspect = b.dAspect;

  pMap = b.map (); // polymorphically overloaded ?
}

template <class T>
BinInFile<T>::BinInFile (const char* pszN, int nInP, int nInR,
			 myBool bSwp, int nOff, double dAsp) :

  BinaryInFile (pszN, bSwp, nOff, dAsp)
{
  nInPixels = nInP;
  nInRasters = nInR;
  nRecordLength = nInPixels;

  if (nInPixels <= 0)
    {
      THROW_ERR("Invalid number of input pixels");
    }

  if (nInRasters <= 0)
    {
      THROW_ERR("Invalid number of input rasters");
    }

  pMap = map ();
}

template <class T>
MemMap* BinInFile<T>::map ()
{

  unsigned long ulSize = (unsigned long)
    (nRecordLength * nInRasters * sizeof (T));

  return new MemMap (pFile, ulSize, ulOffset);

}
///////////////////////tiff///////////
void TiffFile::openFile ()
{

  pFile=NULL;
  char* errmsg=new char[200];

     in =TIFFOpen(sFileName.data(), "r");

     if (!in)
       {
	 sprintf(errmsg,"Error opening file %s: %s",sFileName.data(),strerror(errno));
      THROW_ERR(errmsg);
       }
     delete []errmsg;
}
void TiffFile::TIFFReadDirect()
{  dircount=0;
	 do {
               dircount++;
           } while (TIFFReadDirectory(in));

 }

/// read the tiff data and tags by raj ///
void TiffFile ::readtiff ()
{
  TIFFSetDirectory(in, currentdir);
  uint32 imageWidth, imageLength;
  uint32 row;
  uint16 config;
  uint16 photometric;
  uint16 bps; //bitspersample
   typedef void (*TIFFWarningHandler)(const char* module, const char* fmt, va_list ap);
   TIFFWarningHandler TIFFSetWarningHandler(NULL);


   TIFFGetField(in, TIFFTAG_IMAGEWIDTH, &imageWidth);
   TIFFGetField(in, TIFFTAG_IMAGELENGTH, &imageLength);
   TIFFGetField(in, TIFFTAG_PHOTOMETRIC, &photometric);
   TIFFGetFieldDefaulted(in, TIFFTAG_BITSPERSAMPLE, &bps);
   TIFFGetField(in, TIFFTAG_PLANARCONFIG, &config);

   nInPixels =imageWidth;
   nInRasters =imageLength;
   dAspect=1.0;

   switch (photometric)
     {
    case PHOTOMETRIC_MINISBLACK:
      break;
     case PHOTOMETRIC_MINISWHITE:
       break;
     default:
         THROW_ERR("Can not handle colour tiff image");
         TIFFClose(in);

     }

   switch (bps) {
   case 8:
	datatype=8;
	break;
   case 12:
	datatype=12;
	break;
   case 16:
     datatype=16;
     break;
     // case 24:
	   // tifftype=24;
     // break;
   case 32:
     datatype=32;
     break;
   default:
	   THROW_ERR("Can not handle image tdatatype");
           TIFFClose(in);
   }


   tdata_t  buf;
   buf=(char*)malloc(imageWidth*datatype/8*sizeof(char));
  imagedata=(char*)malloc(imageWidth*imageLength*datatype/8*sizeof(char));
  //buf = _TIFFmalloc(TIFFTileSize(tif));
  //imagedata = _TIFFmalloc(imageWidth*imageLength*datatype/8);

  if (config == PLANARCONFIG_CONTIG) {
    for (row = 0; row < imageLength; row++)
	 {
	   TIFFReadScanline(in, buf,row);
	   memcpy((((unsigned char*)imagedata)+(imageWidth*datatype*row/8)),buf,(imageWidth*datatype/8));

	 }
  }else
	{
	  TIFFClose(in);
	  _TIFFfree(buf);
	  THROW_ERR("Can not handle colour tiff image");
	}


      _TIFFfree(buf);
      TIFFClose(in);

}


/////////////BRUKER////////////

void BrukerFile ::readimage_gfrm()
{

  int i,j=0;

  dAspect=1.0;
   for(i=0; i<3; i++)
     fgets(line,81, pFile) ;

   if(strstr(line,"HDRBLKS")) //read headersezi
     {
	lineptr=line;
	for(i=5;i<sizeof(line);i++)
	  {
	    if(isdigit((int)*lineptr))
	      {
           Header_size=atoi(lineptr);
           break;
	      }//end if
	    else
	      lineptr++;
	  }//end for
      }//end if
   else THROW_ERR("Cannot read  headersezi" );

   for(i=3; i<21; i++)
     fgets(line,81, pFile);
if(strstr(line,"NOVERFL")) //read number of overflow
  {
    lineptr=line;
    for(i=5;i<sizeof(line);i++)
        {
	  if(isdigit((int)*lineptr))
	    {
	      noverfl=atoi(lineptr);
	      break;
          }//end if
	  else
	    lineptr++;
        }//end for
  }//end if
 else THROW_ERR("Cannot read number of overflow" );
 for(i=21; i<40; i++)
   fgets(line,81, pFile);
 
 if(strstr(line,"NPIXELB")) //read number of byte/pixel
   {
	lineptr=line;
	for(i=7;i<sizeof(line);i++)
	  {
	    if(isdigit((int)*lineptr))
	      {
		datatype=atoi(lineptr);
	

		break;
	      }//end if
	    else
	      lineptr++;
	  }//end for
      }//end if
 else THROW_ERR("Cannot read byte/pixel" );
 
 fgets(line,81, pFile);
 if(strstr(line,"NROWS")) //read number of raster
   {
     lineptr=line;
     for(i=5;i<sizeof(line);i++)
        {
	  if(isdigit((int)*lineptr))
	    {
	      nInRasters=atoi(lineptr);
	      break;
	    }//end if
         else
	   lineptr++;
        }//end for
   }//end if
 else THROW_ERR("Cannot read rasters" );

 fgets(line,81, pFile);
 if(strstr(line,"NCOLS")) //read number pixels
   {
     lineptr=line;
       for(i=5;i<sizeof(line);i++)
	 {
	   if(isdigit((int)*lineptr))
          {
	    nInPixels=atoi(lineptr);
	    break;
          }//end if
	   else
	     lineptr++;
	 }//end for
   }//end if
 else  THROW_ERR("Cannot read pixels" );

 memsize=nInPixels*nInRasters*datatype;
 Header_size=Header_size*512;
 imagedata=(char*)malloc(memsize*sizeof(char));
 datatype=datatype*8;
//cout<< nInPixels<<"--"<<nInRasters<<"--"<<Header_size<<"--"<<datatype<<"--"<<memsize<<endl;
 fseek( pFile,Header_size , SEEK_SET );

 if (fread (imagedata, 1,memsize, pFile)!=memsize)
   {
      delete [] (char*)imagedata;
      imagedata=NULL;
      THROW_ERR("Error reading file");
    }

 if ((noverfl>0)&&(datatype<32))
   {
     OFoffset=(long int*)malloc(noverfl*sizeof(long int));
     OFintensity=(int*)malloc(noverfl*sizeof(int));
     for (i=0; i<noverfl; i++ )
       {
	 fscanf(pFile,"%d",(OFintensity+i)) ;
	 fscanf(pFile,"%ld",(OFoffset+i)) ;
       }
   }
 if(ConvFile::getEndian())
   bSwap=0;
 else bSwap=1;

}

void BrukerFile ::readimage_asc()
{
   
  int i,j=0;
  
  dAspect=1.0;
   for(i=0; i<3; i++)
     fgets(line,80, pFile) ;
   
   if(strstr(line,"HDRBLKS")) //read headersezi
     {
	lineptr=line;
	for(i=5;i<sizeof(line);i++)
	  {
	    if(isdigit((int)*lineptr))
	      {
           Header_size=atoi(lineptr);
           break;
	      }//end if
	    else
	      lineptr++;
	  }//end for
      }//end if
   else THROW_ERR("Cannot read  headersezi" );
   
   for(i=3; i<40; i++)
   fgets(line,80, pFile);
 
 if(strstr(line,"NPIXELB")) //read number of byte/pixel
   {
	lineptr=line;
	for(i=5;i<sizeof(line);i++)
	  {
	    if(isdigit((int)*lineptr))
	      {
		datatype=atoi(lineptr);
		break;
	      }//end if
	    else
	      lineptr++;
	  }//end for
      }//end if
 else THROW_ERR("Cannot read byte/pixel" );
 
 fgets(line,80, pFile);
 if(strstr(line,"NROWS")) //read number of raster
   {
     lineptr=line;
     for(i=5;i<sizeof(line);i++)
        {
	  if(isdigit((int)*lineptr))
	    {
	      nInRasters=atoi(lineptr);
	      break;
	    }//end if
         else
	   lineptr++;
        }//end for
   }//end if
 else THROW_ERR("Cannot read rasters" );
  
 fgets(line,80, pFile);
 if(strstr(line,"NCOLS")) //read number pixels
   {
     lineptr=line;
       for(i=5;i<sizeof(line);i++)
	 {
	   if(isdigit((int)*lineptr))
          {
	    nInPixels=atoi(lineptr);
	    break;
          }//end if
	   else
	     lineptr++;
	 }//end for
   }//end if
 else  THROW_ERR("Cannot read pixels" );

 memsize=nInPixels*nInRasters;
 Header_size=Header_size*512;
 
  
OFintensity =(int*)malloc(memsize*sizeof(int));
 datatype=1;

 fseek( pFile,Header_size , SEEK_SET );

    for (i=0; i<(nInPixels*nInRasters); i++ )
       { 
	 fscanf(pFile,"%d",(OFintensity+i)) ;

       }


}



/////////////MAR345////////////

void Mar345File ::readimage()
{
  nInPixels= getimagesize(pFile);
  nInRasters=nInPixels;
  dAspect =1.0;
  datatype=16;
  imagedata=(short int *)openpckfile(pFile);

}
/////////////BSL Input////////////

BslFile::BslFile(const char* pszN,int nfr) : NewBinaryFile(pszN),cFrame(nfr)
{
  char *sptr1,*sptr2;
  sptr1=strdup(sFileName.data());
  if( (sptr2=strrchr(sptr1,'/')) !=NULL )
     sptr2++;
   else
    sptr2=sptr1;
    sptr2[5]='1';
  sBinary = strng(sptr1);
}

void BslFile ::readbslHeader()
{
   char line[255];
   fgets(line,80, pFile);
   fgets(line,80, pFile);

   int para[10];
   for(int i=0; i<10; i++)
   {
     fscanf(pFile,"%d",&para[i]);
     }

    nInPixels=para[0];
    nInRasters=para[1];
    dAspect =1.0;
    datatype=para[4];
    dircount=para[2];
 if(ConvFile::getEndian()&& para[3])
  {
  bSwap=0;
  }
 else bSwap=1;
//cout<<"Inpixel "<<nInPixels<<" raster "<<nInRasters<<" dtype "<<datatype<<" swap "<<bSwap;

fclose(pFile);
char* errmsg=new char[200];
  if ((pFile = fopen (sBinary.data(), "r")) == 0)
    {
      sprintf(errmsg,"Error opening Binary file %s: %s",sBinary.data(),strerror(errno));
      THROW_ERR(errmsg);
    }
  delete[]errmsg;


   switch(datatype)
  {
    case TFLOAT32:
       memsize=nInRasters*nInPixels*sizeof(BSL_FLOAT32);
       break;
    case TCHAR8:
       memsize=nInRasters*nInPixels*sizeof(BSL_CHAR8);
       break;
    case TUCHAR8:
       memsize=nInRasters*nInPixels*sizeof(BSL_UCHAR8);
       break;
    case TINT16:
       memsize=nInRasters*nInPixels*sizeof(BSL_INT16);
       break;
    case TUINT16:
       memsize=nInRasters*nInPixels*sizeof(BSL_UINT16);
       break;
    case TINT32:
	memsize=nInRasters*nInPixels*sizeof(BSL_INT32);
       break;
    case TUINT32:
       memsize=nInRasters*nInPixels*sizeof(BSL_UINT32);
       break;
    case TINT64:
        memsize=nInRasters*nInPixels*sizeof(BSL_INT64);
       break;
    case TUINT64:
        memsize=nInRasters*nInPixels*sizeof(BSL_UINT64);
       break;
    case TFLOAT64:
         memsize=nInRasters*nInPixels*sizeof( BSL_FLOAT64);
       break;

  }
 imagedata=(char*)malloc(memsize*sizeof(char));
//cout<<cFrame<<endl;

 fseek( pFile,(cFrame*memsize), SEEK_SET);

 if (fread(imagedata, 1,memsize, pFile)!=memsize)
   {
     delete [] (char*)imagedata;
     imagedata=NULL;
     THROW_ERR("Error reading file");
   }

}
/////////////LOQ 1D////////////
void LOQFile ::readimage1d()
{
  strp =longtitle1 ;
    if (fgets(strp, MAXLINE + 1, pFile) == NULL)
      {
	THROW_ERR("Cannot read from file" );
      }

    /* Skip less important details of experimental run */
    strp = line1d ;
    for (int i = 2; i < 7; i++) fgets(strp, MAXLINE1D + 1, pFile) ;

    /* Read data */
    nInPixels = 0 ;
    while (fscanf(pFile,"%f%E%E", &q, &c, &ce) != EOF)
       {
	 cross1d[nInPixels] = c ;
	 nInPixels++ ;
       }

    nInRasters=1;
    dAspect =1.0;
    datatype=0;
    imagedata=cross1d;

}
/////////////LOQ 2D////////////

void LOQFile ::readimage2d()
{
    int ncdata = 0, nedata = 0, nlines = 0, nrest = 0 ;
    int mpout = 0, mrout = 1;
    int i,j,k,l;
    int iflag = FIRST_DATA_THEN_ERROR ;

    strp = longtitle1 ;

    if (fgets(strp, MAXLINE + 1, pFile) == NULL)
    {
      THROW_ERR("Cannot read from file ");
    }
      strp = line2d;
      for ( i = 2; i < 9; i++)
       {
	 fgets(strp,(MAXLINE2D+1), pFile) ;
	 if (i == 8)
	   {
             *(line2d + 60) ='\0' ;
	   }
       }

      /* Read x-axis points for 2D data */
      fscanf(pFile,"%d", &mpout) ;
       for (k=0; k < mpout; k++)
	 {
           fscanf(pFile,"%E",&q) ;
           xy[k] = q ;
       }

/* Read y-axis points for 2D data */
       fscanf(pFile,"%d", &mrout) ;
       for ( k=0; k < mrout; k++)
	 {
           fscanf(pFile,"%E",&q) ;
           xy[k+mpout] = q ;
	 }

/* Read 2D cross-sectional data array dependent on 'iflag' option */
       fscanf(pFile,"%d%d%E", &nInPixels, &nInRasters, &scale) ;
       fgets(strp, MAXLINE2D + 1, pFile) ;
       fgets(strp, MAXLINE2D + 1, pFile) ;
       switch (*(line2d + 2))
	 {
         case '1':
	   iflag = DATA_ONLY ;
               break ;
         case '2':
	   iflag = DATA_ERROR_MIXED ;
               break ;
         case '3':
	   iflag = FIRST_DATA_THEN_ERROR ;
               break ;
         default:
	   THROW_ERR("unknown FLAG option ") ;
               break ;
	 }

       /* Check for histogram or point mode */
      if (nInPixels == (mpout - 1) && nInRasters == (mrout - 1))
	{
          for (k=0; k < mpout-1; k++) xy[k] = 0.5*(xy[k] + xy[k+1]) ;
          for (k=mpout, l=mpout-1; k<mpout+mrout-1; k++, l++)
                                      xy[l] = 0.5*(xy[k] + xy[k+1]) ;
	}
      if (iflag == DATA_ONLY || iflag == FIRST_DATA_THEN_ERROR)
	{
         dataptr = cross2d ;
         j = nInRasters * nInPixels ;
         for (i=0; i < j; i++, dataptr++, ncdata++)
         {
	   fscanf(pFile,"%E",dataptr) ;
	 }
       }
      if (iflag == DATA_ERROR_MIXED)
	{
	  for (j=0; j < nInRasters; j++)
         {
           dataptr = cross2d ;
           for (i=0; i < nInPixels; dataptr++,ncdata++) fscanf(pFile,"%E",dataptr) ;
           for (i=0; i < nInPixels; nedata++) fscanf(pFile,"%E",errorptr) ;
	         }
	}

  dAspect =1.0;
  datatype=0;
  imagedata=cross2d;

}
template <class T>
void BinInFile<T>::tiffconvert (tiffOutFile& tiffFile )
{
   int i,j;
  nOutPixels = tiffFile.pixels ();
  nOutRasters = tiffFile.rasters ();
  dRatio = double (nInPixels) / double (nOutPixels);
  pfLine = new float[nOutPixels];
  TIFF *out;
  float min,max,tmp1;
  min=0; max=0;
  out =tiffFile.tiffout_file();
  
      TIFFSetField(out, TIFFTAG_IMAGEWIDTH,nOutPixels );
      TIFFSetField(out, TIFFTAG_IMAGELENGTH,nOutRasters);
      TIFFSetField(out, TIFFTAG_PLANARCONFIG, PLANARCONFIG_CONTIG);
      TIFFSetField(out, TIFFTAG_PHOTOMETRIC,PHOTOMETRIC_MINISBLACK);
      TIFFSetField(out, TIFFTAG_BITSPERSAMPLE,(dtype));

  for ( i = 0; i<nInRasters; i++)
            {
	    for (j = 0; j<nInPixels;j++)
		{
		tmp1=interpolate ((double)i, (double)j);
                if (tmp1>max)
		   max=tmp1;
		 if (tmp1<min)
		   min=tmp1;
		   }
	     }

   if( dtype==8)
      {
      unsigned char*tmp8;
	tmp8=new unsigned char[nOutPixels];
           for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (j = 0; j < nOutPixels; j++)
              {

	        tmp8[j]=(unsigned char)(((*tmp2-min)/(max-min))*(float)255);
                tmp2++;
              }
	       TIFFWriteScanline(out, tmp8,i, 0);
	     }
            if(tmp8){
              delete[] tmp8;
              tmp8=NULL;
	      }
         }
      if( dtype==16)
      {
	unsigned short *tmp16;
	tmp16=new unsigned short[nOutPixels];
           for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for ( j = 0; j < nOutPixels; j++)
              {
	        tmp16[j]=( unsigned short)(((*tmp2-min)/(max-min))*(float)65535);
                tmp2++;
              }
	       TIFFWriteScanline(out, tmp16,i, 0);
	     }
            if(tmp16){
              delete[] tmp16;
              tmp16=NULL;
	      }
         }
	
TIFFWriteDirectory(out);
  if(pfLine){
    delete[] pfLine;
    pfLine=NULL;
  }

}
/////////////////////////////////////////////////////

template <class T>
void BinInFile<T>::convert (BSLHeader& headerFile, BinaryOutFile& binaryFile)
{
  int i;

  BSL_CHAR8* tmpc8;
  BSL_UCHAR8* tmpuc8;
  BSL_INT16* tmpi16;
  BSL_UINT16* tmpui16;
  BSL_INT32* tmpi32;
  BSL_UINT32* tmpui32;
  BSL_INT64* tmpi64;
  BSL_UINT64* tmpui64;
  BSL_FLOAT32* tmpf32;
  BSL_FLOAT64* tmpf64;

  nOutPixels = headerFile.pixels ();
  nOutRasters = headerFile.rasters ();

  dRatio = double (nInPixels) / double (nOutPixels);
  pfLine = new float[nOutPixels];

  switch(dtype)
    {
    case TFLOAT32:
      tmpf32 = new BSL_FLOAT32 [nOutPixels];

      for (i = 0; i < nOutRasters; i++)
	{
	  float *tmp2=transformLine(i);
	  for (int j = 0; j < nOutPixels; j++)
	    {
	      tmpf32[j]=(BSL_FLOAT32)*tmp2;
	      tmp2++;
	    }
              binaryFile.write ((char*) tmpf32, nOutPixels * sizeof (BSL_FLOAT32));
	}
      if(tmpf32){
	delete[] tmpf32;
	tmpf32=NULL;
      }
      break;

    case TCHAR8:
      tmpc8 = new BSL_CHAR8 [nOutPixels];

      for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
		{
                tmpc8[j]=(BSL_CHAR8)*tmp2;
                tmp2++;
		}
              binaryFile.write ((char*) tmpc8, nOutPixels * sizeof (BSL_CHAR8));
            }
            if(tmpc8){
              delete[] tmpc8;
              tmpc8=NULL;
            }
            break;

    case TUCHAR8:
            tmpuc8 = new BSL_UCHAR8 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
	      {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpuc8[j]=(BSL_UCHAR8)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpuc8, nOutPixels * sizeof (BSL_UCHAR8));
	      }
            if(tmpuc8){
              delete[] tmpuc8;
              tmpuc8=NULL;
            }
            break;

    case TINT16:
            tmpi16 = new BSL_INT16 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
	      {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
		{
		  tmpi16[j]=(BSL_INT16)*tmp2;
                tmp2++;
		}
              binaryFile.write ((char*) tmpi16, nOutPixels * sizeof (BSL_INT16));
            }
            if(tmpi16){
              delete[] tmpi16;
              tmpi16=NULL;
            }
            break;

    case TUINT16:
      tmpui16 = new BSL_UINT16 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
	      {
		float *tmp2=transformLine(i);
		for (int j = 0; j < nOutPixels; j++)
              {
                tmpui16[j]=(BSL_UINT16)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpui16, nOutPixels * sizeof (BSL_UINT16));
	      }
            if(tmpui16){
              delete[] tmpui16;
              tmpui16=NULL;
            }
            break;

    case TINT32:
            tmpi32 = new BSL_INT32 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
	      {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
		{
		  tmpi32[j]=(BSL_INT32)*tmp2;
                tmp2++;
		}
              binaryFile.write ((char*) tmpi32, nOutPixels * sizeof (BSL_INT32));
	      }
            if(tmpi32){
              delete[] tmpi32;
              tmpi32=NULL;
            }
            break;

    case TUINT32:
            tmpui32 = new BSL_UINT32 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
	      {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
		{
		  tmpui32[j]=(BSL_UINT32)*tmp2;
                tmp2++;
		}
              binaryFile.write ((char*) tmpui32, nOutPixels * sizeof (BSL_UINT32));
	      }
            if(tmpui32){
              delete[] tmpui32;
              tmpui32=NULL;
            }
            break;

    case TINT64:
      tmpi64 = new BSL_INT64 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
	      {
		float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
		{
		  tmpi64[j]=(BSL_INT64)*tmp2;
		  tmp2++;
		}
              binaryFile.write ((char*) tmpi64, nOutPixels * sizeof (BSL_INT64));
	      }
            if(tmpi64){
              delete[] tmpi64;
              tmpi64=NULL;
            }
            break;

    case TUINT64:
      tmpui64 = new BSL_UINT64 [nOutPixels];
      for (i = 0; i < nOutRasters; i++)
	{
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
		{
                tmpui64[j]=(BSL_UINT64)*tmp2;
                tmp2++;
		}
              binaryFile.write ((char*) tmpui64, nOutPixels * sizeof (BSL_UINT64));
	}
            if(tmpui64){
              delete[] tmpui64;
              tmpui64=NULL;
            }
            break;

    case TFLOAT64:
      tmpf64 = new BSL_FLOAT64 [nOutPixels];
      for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
		{
                tmpf64[j]=(BSL_FLOAT64)*tmp2;
                tmp2++;
		}
              binaryFile.write ((char*) tmpf64, nOutPixels * sizeof (BSL_FLOAT64));
            }
      if(tmpf64){
	delete[] tmpf64;
	tmpf64=NULL;
      }
      break;

    }

  if(pfLine){
    delete[] pfLine;
    pfLine=NULL;
  }
  if(pMap){
    delete pMap;
    pMap=NULL;
  }


}

template <class T>
float* BinInFile<T>::transformLine (int nLine)
{
  double x, y;
  int i;

  y = dAspect * dRatio * (double (nLine) + 0.5) - 0.5;

  for (i = 0; i < nOutPixels; i++)
    {
      x = dRatio * (double (i) + 0.5) - 0.5;

      *(pfLine + i) = interpolate (x, y);

    }

  return pfLine;
}

template <class T>
float BinInFile<T>::interpolate (double x, double y)
{
  T* ptData = (T*) ((*pMap) ());

  int iy = int (y);
  double dy = y - double (iy);
  int ix = int (x);
  double dx = x - double (ix);
  int m = iy * nRecordLength + ix;
  double dInt = 0.0;

  if (ix >= 0 && ix < nInPixels && iy >= 0 && iy < nInRasters)
    {
      dInt += (1.0 - dx) * (1.0 - dy) * extract (*(ptData + m));
    }

  if (ix >= -1 && ix < nInPixels - 1 &&  iy >= 0 && iy < nInRasters)
    {
      dInt += dx * (1.0 - dy) * extract (*(ptData + m + 1));
    }

  if (ix >= 0 && ix < nInPixels && iy >= -1 && iy < nInRasters - 1)
    {
      dInt += (1.0 - dx) * dy * extract (*(ptData + m + nRecordLength));
    }

  if (ix >= -1 && ix < nInPixels - 1 && iy >= -1 && iy < nInRasters - 1)
    {
      dInt += dx * dy * extract (*(ptData + m + nRecordLength + 1));
    }

  return float (dInt);
}

template <class T>
double BinInFile<T>::extract (T t)
{
  return double ((bSwap ? bswap (t) : t));
}

double FujiInFile::extract (unsigned short t)
{
  return pow (10.0, dDynamicRange * BinInFile<unsigned short>::extract (t));
}

double Fuji2500InFile::extract (unsigned short t)
{
  return (0.65535 * pow (10.0, dDynamicRange * BinInFile<unsigned short>::extract (t)));
}

RAxisInFile::RAxisInFile (const char *pszN, myBool bSwp) :
  BinInFile<unsigned short> (pszN, 400, 1, bSwp, 0, 1.0)
{
  unsigned tmp;

  tmp = (unsigned) *((int *) (*pMap)() + 192);
  nInPixels = (bSwap ? bswap (tmp) : tmp);

  tmp = (unsigned) *((int *) (*pMap)() + 193);
  nInRasters = (bSwap ? bswap (tmp) : tmp);
  
  tmp = (unsigned) *((int *) (*pMap)() + 196);
  ulOffset  = (unsigned long) (bSwap ? bswap (tmp) : tmp);
  
  delete pMap;
  pMap=NULL;
  nRecordLength = (int) ulOffset / sizeof (unsigned short);
  map ();
}

///////////////////////////////////////
double RAxisInFile::extract (unsigned short t)
{
  int tmp = (int) short (bSwap ? bswap (t) : t);
  return double (tmp < 0 ? (tmp + 32768)*8 : tmp);
}
///////////////////////////////////////
double RAxis4InFile::extract (unsigned short t)
{
  
  int tmp = (int) short (bSwap ? bswap (t) : t);
  return double (tmp < 0 ? (tmp + 32768)*8 : tmp);

}

//////////ESRF-ID2 image By Rajkumar////////
void MARFile::readimage( )
{
  char *lineptr;
  int i,j=0;
  header_bytes=0;
  nInPixels=0;
  nInRasters=0;
  datatype=-1;
  char line[1024];
  char c;

  do
    {
      fscanf(pFile,"%c",&c) ;
      header_bytes++;
      if (header_bytes>10000)
	THROW_ERR("Error reading header");
    }while(!(c=='}'));
  header_bytes++;
  fseek( pFile,0 , SEEK_SET );
  do
    {
      fgets(line,80, pFile) ;
    // fp.getline(line,255,'\n');
      
      if(strstr(line,"Dim_1")) //read width of the image
      {
	lineptr=strstr(line,"Dim_1")+5;
	for(i=5;i<sizeof(line);i++)
	  {
	    if(isdigit((int)*lineptr))
	      {
		nInPixels=atoi(lineptr);
		break;
	      }//end if
	    else
	      lineptr++;
	  }//end for
      }//end if
      if(strstr(line,"Dim_2")) // read height of the image
	{
	  lineptr=strstr(line,"Dim_2")+5;
	  for(i=5;i<sizeof(line);i++)
	    {
	      if(isdigit((int)*lineptr))
		{
		  nInRasters=atoi(lineptr);
		  break;
		}//end if
	      else
		lineptr++;
	    }//end for
	}//end if
      
	if(strstr(line,"ByteOrder")) // read height of the image
	  {
	    if(strstr(line,"HighByteFirst"))
	      {
		if(ConvFile::getEndian())
		  bSwap=1;
		else bSwap=0;
	      }
	    else 
	{
	  if(ConvFile::getEndian())
	    bSwap=0;
	  else  bSwap=1;
	}
      }//end if
	
	if(strstr(line,"DataType")) //read data type of the image
	  {
	    if((strstr(line,"SignedByte"))||(strstr(line,"ComplexByte")))
	      {datatype=1;
	      bpp=8;
	      }
	    else if (strstr(line,"UnsignedByte"))
	      {datatype=2;
	      bpp=8;
	      }
	    else  if((strstr(line,"SignedShort"))||(strstr(line,"SignedShort")))
	      {datatype=3;
	      bpp=sizeof(short int);
	      }
      else  if(strstr(line,"UnsignedShort"))
	{datatype=4;
	bpp=sizeof(short int);
	}
	    else if((strstr(line,"SignedInteger"))||(strstr(line,"ComplexInteger")))
	      {
		datatype=5;
		bpp=sizeof(int);
	      }
 	else if(strstr(line,"UnsignedInteger"))
	  {
	    datatype=6;
	    bpp=sizeof(int);
	}else if((strstr(line,"Signedlong"))||(strstr(line,"ComplexLongInteger")))
	  {
	    datatype=7;
	    bpp=sizeof(long);
	}
	    else if(strstr(line,"UnsignedLong"))
	      {
		datatype=8;
		bpp=sizeof(long);
	      }
       else if((strstr(line,"FloatValue"))||(strstr(line,"ComplexFloat")))
	 {
	   datatype=9;
	bpp=sizeof(float);
	 }
	    else if((strstr(line,"DoubleValue"))||(strstr(line,"ComplexDouble")))
	      {
	 datatype=10;
	 bpp=sizeof(double);
	      }
	    else
          THROW_ERR("unknown Datathye");
	  }
	
    }while((!strchr(line,'}'))&&(!strlen(line)==0));//end do
  
 dAspect=1.0;
 memsize=nInRasters*nInPixels*bpp;
 imagedata=(char*)malloc(memsize*sizeof(char));
fseek( pFile,header_bytes, SEEK_SET);
 
 if (fread (imagedata, 1,memsize, pFile)!=memsize)
   {
     delete [] (char*)imagedata;
     imagedata=NULL;
     THROW_ERR("Error reading file");
   }
 
}
//////////SMV////////
void SMVFile::readimage( )
{
   char *lineptr;
   int i,j=0;
   header_bytes=0;
   nInPixels=0;
   nInRasters=0;
   datatype=-1;
   char line[255];         
   do
     {
       fgets(line,80, pFile) ;
       if(strstr(line,"HEADER_BYTES")) //read width of the image
      {
	lineptr=strstr(line,"HEADER_BYTES")+12;
	for(i=12;i<sizeof(line);i++)
        {
	  if(isdigit((int)*lineptr))
	    {
	      header_bytes= atoi(lineptr);
	      break;
	    }//end if
	  else
	   lineptr++;
        }//end for
      }//end if
       
       if(strstr(line,"SIZE1")) // read height of the image
	 {
	   lineptr=strstr(line,"SIZE1")+5;
	   for(i=5;i<sizeof(line);i++)
	     {
	       if(isdigit((int)*lineptr))
		 {
		   nInPixels=atoi(lineptr);
		   break;
		 }//end if
	       else
		 lineptr++;
	     }//end for
	 }//end if
       
       
       if(strstr(line,"SIZE2")) // read height of the image
	 {
	   lineptr=strstr(line,"SIZE2")+5;
	   for(i=5;i<sizeof(line);i++)
	     {
	       if(isdigit((int)*lineptr))
		 {
		   nInRasters=atoi(lineptr);
		   break;
		 }//end if
	       else
		 lineptr++;
	     }//end for
	 }//end if
       
    if(strstr(line,"BYTE_ORDER")) // read height of the image
      {
	if(strstr(line,"big_endian"))
	  {
	    if(ConvFile::getEndian())
	      bSwap=1;
	   else bSwap=0;
	  }
	else 
	  {
	    if(ConvFile::getEndian())
	    bSwap=0;
	    else  bSwap=1;
	  }
      }//end if
    
    if(strstr(line,"TYPE")) //read data type of the image
      {
	if (strstr(line,"unsigned_char"))
	{datatype=8;
	bpp=8;
	}
	else  if(strstr(line,"unsigned_short"))
	  {datatype=16;
	  bpp=sizeof(short int);
	}
	else if(strstr(line,"signed_long"))
	  {
	    datatype=32;
	    bpp=sizeof(long);
	}
	else if(strstr(line,"FloatValue"))
	  {
	    datatype=0;
	bpp=sizeof(float);
	}
	else
          THROW_ERR("unknown Datathye");
     }
    
     }while(!strchr(line,'}'));//end do

   dAspect=1.0;
   memsize=nInRasters*nInPixels*bpp;
 imagedata=(char*)malloc(memsize*sizeof(char));
 fseek( pFile,header_bytes, SEEK_SET);
 
 if (fread (imagedata, 1,memsize, pFile)!=memsize)
  {
    delete [] (char*)imagedata;
    imagedata=NULL;
    THROW_ERR("Error reading file");
  }
 
}
void RisoInFile::ReadText()
{
  int i;
  char *lineptr;
  char line[256];
  Title =new char[80];

  dAspect=1.0;

  pIn->getline(line,sizeof(line),'\n');
  strcpy(Title,line);

  for(i=0;i<43;i++)
  {
    pIn->getline(line,sizeof(line),'\n');
  }

  lineptr=line;

  if(!strncmp(line,"#siz",4))
  {
    for(i=0;i<256;i++)
    {
      if(isdigit((int)*lineptr))
      {
        nInPixels=atoi(lineptr);
        break;
      }
      else
        lineptr++;
    }

    while(isdigit((int)*lineptr))
    {
     lineptr++;
    };

    for(i=0;i<256;i++)
    {
      if(isdigit((int)*lineptr))
      {
        nInRasters=atoi(lineptr);
        break;
      }
      else
        lineptr++;
    }

  }
  else
  {
    THROW_ERR("File format not recognised as Riso");
  }

  pIn->getline(line,256,'\n');

  AsciiData=new float[nInPixels*nInRasters];

  for(i=0;i<nInPixels*nInRasters;i++)
  {
  *pIn>>AsciiData[i];
  }
}

void TextInFile::openFile ()
{
  pIn=new ifstream(sFileName.data());
  if(pIn->bad())
      THROW_ERR("Error opening file");
}


///////////////////////////tiff////////////////////////////
void NewBinaryFile::tiffconvert (tiffOutFile& tiffFile)

{
  int i;
  nOutPixels = tiffFile.pixels ();
  nOutRasters = tiffFile.rasters ();
  dRatio = double (nInPixels) / double (nOutPixels);
  pfLine = new float[nOutPixels];
  TIFF *out;
  float min,max,tmp1;
  min=0; max=0;
	out =tiffFile.tiffout_file();

  for (long m = 0; m<nInPixels*nInRasters; m++)
            {
                tmp1=extract((unsigned long )m);
                if (tmp1>max)
		   max=tmp1;
		 if (tmp1<min)
		   min=tmp1;
	     }

     TIFFSetField(out, TIFFTAG_IMAGEWIDTH,nOutPixels );
      TIFFSetField(out, TIFFTAG_IMAGELENGTH,nOutRasters);
      TIFFSetField(out, TIFFTAG_PLANARCONFIG, PLANARCONFIG_CONTIG);
      TIFFSetField(out, TIFFTAG_PHOTOMETRIC,PHOTOMETRIC_MINISBLACK);
      TIFFSetField(out, TIFFTAG_BITSPERSAMPLE,dtype);
	

   if( dtype==8)
      {
      unsigned char*tmp8;
	tmp8=new unsigned char[nOutPixels];
           for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {

	        tmp8[j]=(unsigned char)(((*tmp2-min)/(max-min))*(float)255);
                tmp2++;
              }
	       TIFFWriteScanline(out, tmp8,i, 0);
	     }
            if(tmp8){
              delete[] tmp8;
              tmp8=NULL;
	      }
         }
      if( dtype==16)
      {
	unsigned short *tmp16;
	tmp16=new unsigned short[nOutPixels];
           for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
	        tmp16[j]=( unsigned short)(((*tmp2-min)/(max-min))*(float)65535);
                tmp2++;
              }
	       TIFFWriteScanline(out, tmp16,i, 0);
	     }
            if(tmp16){
              delete[] tmp16;
              tmp16=NULL;
	      }
         }
/*
if( dtype==16)
      {
	unsigned int *tmp32;
	tmp32=new unsigned int[nOutPixels];
           for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
	        tmp32[j]=( unsigned int)(((*tmp2-min)/(max-min))*(float)4294967296);  
                tmp2++;
              }
	       TIFFWriteScanline(out, tmp32,i, 0);
	     }
          	if(tmp32){
              	delete[] tmp32;
              	tmp32=NULL;
	      	}
         }*/
 TIFFWriteDirectory(out);
  if(pfLine){
    delete[] pfLine;
    pfLine=NULL;
  }

}
/////////converter By Raj *******************///////
void NewBinaryFile::convert (BSLHeader& headerFile, BinaryOutFile& binaryFile)
{
  int i;

  BSL_CHAR8* tmpc8;
  BSL_UCHAR8* tmpuc8;
  BSL_INT16* tmpi16;
  BSL_UINT16* tmpui16;
  BSL_INT32* tmpi32;
  BSL_UINT32* tmpui32;
  BSL_INT64* tmpi64;
  BSL_UINT64* tmpui64;
  BSL_FLOAT32* tmpf32;
  BSL_FLOAT64* tmpf64;

  nOutPixels = headerFile.pixels ();
  nOutRasters = headerFile.rasters ();
  dRatio = double (nInPixels) / double (nOutPixels);
  pfLine = new float[nOutPixels];

  switch(dtype)
  {
    case TFLOAT32:

	    tmpf32 = new BSL_FLOAT32 [nOutPixels];

            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpf32[j]=(BSL_FLOAT32)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpf32, nOutPixels * sizeof (BSL_FLOAT32));
            }
            if(tmpf32){
              delete[] tmpf32;
              tmpf32=NULL;
	      }
            break;

    case TCHAR8:
            tmpc8 = new BSL_CHAR8 [nOutPixels];

            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpc8[j]=(BSL_CHAR8)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpc8, nOutPixels * sizeof (BSL_CHAR8));
            }
            if(tmpc8){
              delete[] tmpc8;
              tmpc8=NULL;
            }
            break;

    case TUCHAR8:
            tmpuc8 = new BSL_UCHAR8 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpuc8[j]=(BSL_UCHAR8)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpuc8, nOutPixels * sizeof (BSL_UCHAR8));
            }
            if(tmpuc8){
              delete[] tmpuc8;
              tmpuc8=NULL;
            }
            break;

    case TINT16:
            tmpi16 = new BSL_INT16 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpi16[j]=(BSL_INT16)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpi16, nOutPixels * sizeof (BSL_INT16));
            }
            if(tmpi16){
              delete[] tmpi16;
              tmpi16=NULL;
            }
            break;

    case TUINT16:
            tmpui16 = new BSL_UINT16 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpui16[j]=(BSL_UINT16)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpui16, nOutPixels * sizeof (BSL_UINT16));
            }
            if(tmpui16){
              delete[] tmpui16;
              tmpui16=NULL;
            }
            break;

    case TINT32:
            tmpi32 = new BSL_INT32 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpi32[j]=(BSL_INT32)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpi32, nOutPixels * sizeof (BSL_INT32));
            }
            if(tmpi32){
              delete[] tmpi32;
              tmpi32=NULL;
            }
            break;

    case TUINT32:
            tmpui32 = new BSL_UINT32 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpui32[j]=(BSL_UINT32)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpui32, nOutPixels * sizeof (BSL_UINT32));
            }
            if(tmpui32){
              delete[] tmpui32;
              tmpui32=NULL;
            }
            break;

    case TINT64:
            tmpi64 = new BSL_INT64 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpi64[j]=(BSL_INT64)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpi64, nOutPixels * sizeof (BSL_INT64));
            }
            if(tmpi64){
              delete[] tmpi64;
              tmpi64=NULL;
            }
            break;

    case TUINT64:
            tmpui64 = new BSL_UINT64 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpui64[j]=(BSL_UINT64)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpui64, nOutPixels * sizeof (BSL_UINT64));
            }
            if(tmpui64){
              delete[] tmpui64;
              tmpui64=NULL;
            }
            break;

    case TFLOAT64:
            tmpf64 = new BSL_FLOAT64 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpf64[j]=(BSL_FLOAT64)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpf64, nOutPixels * sizeof (BSL_FLOAT64));
            }
            if(tmpf64){
              delete[] tmpf64;
              tmpf64=NULL;
            }
            break;

  }

  if(pfLine){
    delete[] pfLine;
    pfLine=NULL;
  }

}
float* NewBinaryFile::transformLine (int nLine)
{
  double x, y;
  int i;

  y = dAspect * dRatio * (double (nLine) + 0.5) - 0.5;

  for (i = 0; i < nOutPixels; i++)
    //  for (i = 0; i < nOutRasters; i++)
    {
      x = dRatio * (double (i) + 0.5) - 0.5;

      *(pfLine + i) = interpolate (x, y);

    }

  return pfLine;
}
float NewBinaryFile::interpolate (double x, double y)
{
  int iy = int (y);
  double dy = y - double (iy);
  int ix = int (x);
  double dx = x - double (ix);
  int m = iy * nInPixels + ix;
  double dInt = 0.0;

  if (ix >= 0 && ix < nInPixels && iy >= 0 && iy < nInRasters)
    {
       dInt += (1.0 - dx) * (1.0 - dy) *extract((unsigned long )m);

    }

  if (ix >= -1 && ix < nInPixels - 1 &&  iy >= 0 && iy < nInRasters)
    {
      dInt += dx * (1.0 - dy) *extract(((unsigned long)m +(unsigned long) 1));

    }

  if (ix >= 0 && ix < nInPixels && iy >= -1 && iy < nInRasters - 1)
    {
      dInt += (1.0 - dx) * dy *extract(((unsigned long)m + (unsigned long)nInPixels));

    }

   if (ix >= -1 && ix < nInPixels - 1 && iy >= -1 && iy < nInRasters - 1)
    {
       dInt += dx * dy *extract(((unsigned long)m + (unsigned long)nInPixels +(unsigned long) 1));
       }

  return float (dInt);
}


double NewBinaryFile::extract(unsigned long  p)
{

  unsigned long p1;
  switch (datatype)
     {
       case 0:  //32 bit float type data
       return((double) *(((float*)imagedata)+ p));
       break;
	
     case 8:   //8 bit unsigned char type data
       return((double) *(((unsigned char*)imagedata)+ p));
       break;
     case 12:
        union 
       {
	 unsigned short ab;
	 unsigned char ch[2];
	 }data;
	  
      p1=p*3/2;
      if(ConvFile::getEndian())
	{
          data.ch[1]=*(((unsigned char*)imagedata)+ p1);
          data.ch[0]=*(((unsigned char*)imagedata)+ p1+1); 
      }else
	{
 	  data.ch[0]=*(((unsigned char*)imagedata)+ p1);
          data.ch[1]=*(((unsigned char*)imagedata)+ p1+1);
        }
       if((p%2)!=0)
	  {
	    data.ab=data.ab<<4;
	    }
	    data.ab=data.ab>>4;
	return((double)data.ab);
       break;
     case 16:   //16 bit unsigned short type;
       return((double) *(((unsigned short*)imagedata)+ p));
       break;
     case 32:   //32 bit unsigned integer type;
	return((double) *(((unsigned int*)imagedata)+ p));
       break;
       //default :
       

     }
}


double BrukerFile ::extract(unsigned long  p)
{
  
  int i;
  double tmp; 
  switch (datatype)
     {
     case 1:   //Ascii data
     	return((double) *(OFintensity+ p));
     	break;	

     case 8:   //8 bit unsigned char type data
        if ((*(((unsigned char*)imagedata)+ p)==255)&&(noverfl>0))
        for (i=0; i<noverfl; i++)
         {
           if (p==*(OFoffset+i))
              return((double) *(OFintensity+i));
         }
         else
       return((double) *(((unsigned char*)imagedata)+ p));
       break;
     
     case 16:   //16 bit unsigned short type;
        if ((*(((unsigned char*)imagedata)+ p)==65535)&&(noverfl>0))
        for (i=0; i<noverfl; i++)
         {
           if (p==*(OFoffset+i))
              return((double) *(OFintensity+i));
         }
         else
       return((double)( bSwap ? bswap(*(((unsigned short*)imagedata)+ p)):*(((unsigned short*)imagedata)+ p)));
       break;
     case 32:   //32 bit unsigned integer type;
	return((double) ( bSwap ? bswap(*(((unsigned int*)imagedata)+ p)):*(((unsigned int*)imagedata)+ p)));
       break;
     }
}


double BslFile::extract(unsigned long  p)
{    
  switch(datatype)
  {
    case TFLOAT32:
        return((double) ( bSwap ? bswap(*(((float*)imagedata)+ p)):*(((float*)imagedata)+ p))); 
       break;
    case TCHAR8:
         return((double) *(((char*)imagedata)+ p));
       break;
    case TUCHAR8:
         return((double) *(((unsigned char*)imagedata)+ p));
       break;
    case TINT16:
        return((double)( bSwap ? bswap(*(((signed short*)imagedata)+ p)):*(((signed short*)imagedata)+ p)));
       break;
    case TUINT16:
        return((double)( bSwap ? bswap(*(((unsigned short*)imagedata)+ p)):*(((unsigned short*)imagedata)+ p)));
       break;
    case TINT32:
	 return((double) ( bSwap ? bswap(*(((int*)imagedata)+ p)):*((( int*)imagedata)+ p)));
       break;
    case TUINT32:
      return((double) ( bSwap ? bswap(*(((unsigned int*)imagedata)+ p)):*(((unsigned int*)imagedata)+ p)));
       break;
    case TINT64:
        return((double) ( bSwap ? bswap(*(((signed long*)imagedata)+ p)):*(((signed long*)imagedata)+ p)));
       break;
    case TUINT64:
      return((double) ( bSwap ? bswap(*(((unsigned long*)imagedata)+ p)):*(((unsigned long*)imagedata)+ p)));
       break;
    case TFLOAT64:
      return((double) ( bSwap ? bswap(*(((double*)imagedata)+ p)):*(((double*)imagedata)+ p)));
       break;

  }

}



double MARFile::extract(unsigned long  p)
{

  switch (datatype)
     {
       case 1:   //8 bit signed char type data
        return((double) *(((signed char*)imagedata)+ p));
       break;
       case 2:   //8 bit unsigned char type data
        return((double) *(((unsigned char*)imagedata)+ p));
       break;
       case 3:   //16 bit signed short type;
        return((double)( bSwap ? bswap(*(((signed short*)imagedata)+ p)):*(((signed short*)imagedata)+ p)));
       break;
       case 4:   //16 bit unsigned short type;
        return((double)( bSwap ? bswap(*(((unsigned short*)imagedata)+ p)):*(((unsigned short*)imagedata)+ p)));
       break;
       case 5:   //32 bit signed integer type;
        return((double) ( bSwap ? bswap(*(((signed int*)imagedata)+ p)):*(((signed int*)imagedata)+ p)));
       break;
       case 6:   //32 bit unsigned integer type;
	return((double) ( bSwap ? bswap(*(((unsigned int*)imagedata)+ p)):*(((unsigned int*)imagedata)+ p)));
       break;
       case 7:   //64 bit signed long integer type;
       return((double) ( bSwap ? bswap(*(((signed long*)imagedata)+ p)):*(((signed long*)imagedata)+ p)));
       break;
       case 8:   //64 bit unsigned long integer type;
	return((double) ( bSwap ? bswap(*(((unsigned long*)imagedata)+ p)):*(((unsigned long*)imagedata)+ p)));
       break;
	case 9:  //32 bit float type data
        return((double) ( bSwap ? bswap(*(((float*)imagedata)+ p)):*(((float*)imagedata)+ p)));
       break;
	case 10:  //64 bit Double type data
        return((double) ( bSwap ? bswap(*(((double*)imagedata)+ p)):*(((double*)imagedata)+ p)));
       break;
     }
}

void TextInFile::tiffconvert (tiffOutFile& tiffFile)
{
  int i,j;
  nOutPixels = tiffFile.pixels ();
  nOutRasters = tiffFile.rasters ();
  dRatio = double (nInPixels) / double (nOutPixels);
  pfLine = new float[nOutPixels];
  TIFF *out;
  float min,max,tmp1;
  min=0; max=0;
  out =tiffFile.tiffout_file();
  
       TIFFSetField(out, TIFFTAG_IMAGEWIDTH,nOutPixels );
      TIFFSetField(out, TIFFTAG_IMAGELENGTH,nOutRasters);
      TIFFSetField(out, TIFFTAG_PLANARCONFIG, PLANARCONFIG_CONTIG);
      TIFFSetField(out, TIFFTAG_PHOTOMETRIC,PHOTOMETRIC_MINISBLACK);
      TIFFSetField(out, TIFFTAG_BITSPERSAMPLE,dtype);

  for ( i = 0; i<nInRasters; i++)
            {
	    for (j = 0; j<nInPixels;j++)
		{
		tmp1=interpolate ((double)i, (double)j);
                if (tmp1>max)
		   max=tmp1;
		 if (tmp1<min)
		   min=tmp1;
		   }
	     }

   if( dtype==8)
      {
      unsigned char*tmp8;
	tmp8=new unsigned char[nOutPixels];
           for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (j = 0; j < nOutPixels; j++)
              {

	        tmp8[j]=(unsigned char)(((*tmp2-min)/(max-min))*(float)255);
                tmp2++;
              }
	       TIFFWriteScanline(out, tmp8,i, 0);
	     }
            if(tmp8){
              delete[] tmp8;
              tmp8=NULL;
	      }
         }
      if( dtype==16)
      {
	unsigned short *tmp16;
	tmp16=new unsigned short[nOutPixels];
           for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for ( j = 0; j < nOutPixels; j++)
              {
	        tmp16[j]=( unsigned short)(((*tmp2-min)/(max-min))*(float)65535);
                tmp2++;
              }
	       TIFFWriteScanline(out, tmp16,i, 0);
	     }
            if(tmp16){
              delete[] tmp16;
              tmp16=NULL;
	      }
         }
TIFFWriteDirectory(out);
  if(pfLine){
    delete[] pfLine;
    pfLine=NULL;
  }

}

////////////////////////////////////

void TextInFile::convert (BSLHeader& headerFile, BinaryOutFile& binaryFile)
{
  int i;

  BSL_CHAR8* tmpc8;
  BSL_UCHAR8* tmpuc8;
  BSL_INT16* tmpi16;
  BSL_UINT16* tmpui16;
  BSL_INT32* tmpi32;
  BSL_UINT32* tmpui32;
  BSL_INT64* tmpi64;
  BSL_UINT64* tmpui64;
  BSL_FLOAT32* tmpf32;
  BSL_FLOAT64* tmpf64;

  nOutPixels = headerFile.pixels ();
  nOutRasters = headerFile.rasters ();

  dRatio = double (nInPixels) / double (nOutPixels);
  pfLine = new float[nOutPixels];

  switch(dtype)
  {
    case TFLOAT32:
            tmpf32 = new BSL_FLOAT32 [nOutPixels];

            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpf32[j]=(BSL_FLOAT32)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpf32, nOutPixels * sizeof (BSL_FLOAT32));
            }
            if(tmpf32){
              delete[] tmpf32;
              tmpf32=NULL;
            }
            break;

    case TCHAR8:
            tmpc8 = new BSL_CHAR8 [nOutPixels];

            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpc8[j]=(BSL_CHAR8)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpc8, nOutPixels * sizeof (BSL_CHAR8));
            }
            if(tmpc8){
              delete[] tmpc8;
              tmpc8=NULL;
            }
            break;

    case TUCHAR8:
            tmpuc8 = new BSL_UCHAR8 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpuc8[j]=(BSL_UCHAR8)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpuc8, nOutPixels * sizeof (BSL_UCHAR8));
            }
            if(tmpuc8){
              delete[] tmpuc8;
              tmpuc8=NULL;
            }
            break;

    case TINT16:
            tmpi16 = new BSL_INT16 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpi16[j]=(BSL_INT16)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpi16, nOutPixels * sizeof (BSL_INT16));
            }
            if(tmpi16){
              delete[] tmpi16;
              tmpi16=NULL;
            }
            break;

    case TUINT16:
            tmpui16 = new BSL_UINT16 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpui16[j]=(BSL_UINT16)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpui16, nOutPixels * sizeof (BSL_UINT16));
            }
            if(tmpui16){
              delete[] tmpui16;
              tmpui16=NULL;
            }
            break;

    case TINT32:
            tmpi32 = new BSL_INT32 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpi32[j]=(BSL_INT32)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpi32, nOutPixels * sizeof (BSL_INT32));
            }
            if(tmpi32){
              delete[] tmpi32;
              tmpi32=NULL;
            }
            break;

    case TUINT32:
            tmpui32 = new BSL_UINT32 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpui32[j]=(BSL_UINT32)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpui32, nOutPixels * sizeof (BSL_UINT32));
            }
            if(tmpui32){
              delete[] tmpui32;
              tmpui32=NULL;
            }
            break;

    case TINT64:
            tmpi64 = new BSL_INT64 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpi64[j]=(BSL_INT64)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpi64, nOutPixels * sizeof (BSL_INT64));
            }
            if(tmpi64){
              delete[] tmpi64;
              tmpi64=NULL;
            }
            break;

    case TUINT64:
            tmpui64 = new BSL_UINT64 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpui64[j]=(BSL_UINT64)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpui64, nOutPixels * sizeof (BSL_UINT64));
            }
            if(tmpui64){
              delete[] tmpui64;
              tmpui64=NULL;
            }
            break;

    case TFLOAT64:
            tmpf64 = new BSL_FLOAT64 [nOutPixels];
            for (i = 0; i < nOutRasters; i++)
            {
              float *tmp2=transformLine(i);
              for (int j = 0; j < nOutPixels; j++)
              {
                tmpf64[j]=(BSL_FLOAT64)*tmp2;
                tmp2++;
              }
              binaryFile.write ((char*) tmpf64, nOutPixels * sizeof (BSL_FLOAT64));
            }
            if(tmpf64){
              delete[] tmpf64;
              tmpf64=NULL;
            }
            break;

  }

  if(pfLine){
    delete[] pfLine;
    pfLine=NULL;
  }
}

float* TextInFile::transformLine (int nLine)
{
  double x, y;
  int i;

  y = dAspect * dRatio * (double (nLine) + 0.5) - 0.5;

  for (i = 0; i < nOutPixels; i++)
    {
      x = dRatio * (double (i) + 0.5) - 0.5;

      *(pfLine + i) = interpolate (x, y);

    }

  return pfLine;
}

float TextInFile::interpolate (double x, double y)
{

 float *ptData;

  ptData = AsciiData;

  int iy = int (y);
  double dy = y - double (iy);
  int ix = int (x);
  double dx = x - double (ix);
  int m = iy * nInPixels + ix;
  double dInt = 0.0;

  if (ix >= 0 && ix < nInPixels && iy >= 0 && iy < nInRasters)
    {
      dInt += (1.0 - dx) * (1.0 - dy) * *(ptData + m);
    }

  if (ix >= -1 && ix < nInPixels - 1 &&  iy >= 0 && iy < nInRasters)
    {
      dInt += dx * (1.0 - dy) * *(ptData + m + 1);
    }

  if (ix >= 0 && ix < nInPixels && iy >= -1 && iy < nInRasters - 1)
    {
      dInt += (1.0 - dx) * dy * *(ptData + m + nInPixels);
    }

  if (ix >= -1 && ix < nInPixels - 1 && iy >= -1 && iy < nInRasters - 1)
    {
      dInt += dx * dy * *(ptData + m + nInPixels + 1);
    }

  return float (dInt);
}

BSLHeader::BSLHeader (const char *pszN, int nPix, int nRast, int dtype, int nFram = 1,
		      const char *pszHead1 = 0, const char *pszHead2 = 0) :

  TextOutFile (pszN), sHeader1 (pszHead1), sHeader2 (pszHead2),
  nPixels (nPix), nRasters (nRast), nFrames (nFram)
{
  try
    {
      legalValues ();
    }

  catch (XError& xerr)
    {
      delete pOut;
      pOut=NULL;
      remove (sFileName.data ());
      throw;
    }


  char *sptr1,*sptr2;
  sptr1=strdup(sFileName.data());
  if( (sptr2=strrchr(sptr1,'/')) !=NULL )
    sptr2++;
  else
    sptr2=sptr1;
  sptr2[5]='1';

  sBinary = strng(sptr1);

  pOut->setf (ios::left);
  *pOut << setw(80) << sHeader1 << "\n";
  *pOut << setw(80) << sHeader2 << "\n";

  pOut->unsetf (ios::left);
  *pOut << setw(8) << nPixels << setw(8) << nRasters << setw(8) << nFrames
	<< setw(8) << (int) ConvFile::getEndian() << setw(8) << dtype << setw(8) << (int) 0
	<< setw(8) << (int) 0 << setw(8) << (int) 0 << setw(8) << (int) 0
	<< setw(8) << (int) 0 << "\n";


  *pOut << setw(10) << sptr2 << "\n";
}
void BSLHeader::legalValues () throw (XError)
{
  if (nPixels <= 0 )
    THROW_ERR("Invalid number of pixels in BSL header");

  if (nRasters <= 0 )
    THROW_ERR("Invalid number of rasters in BSL header");

  if (nFrames <= 0 )
    THROW_ERR("Invalid number of frames in BSL header");
}
#ifdef GNU
  template class BinInFile<float>;
  template class BinInFile<unsigned char>;
  template class BinInFile<unsigned short>;
  template class BinInFile<unsigned int>;

#endif

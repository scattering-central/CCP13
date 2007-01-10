#ifndef _CONV_FILE_H
#define _CONV_FILE_H

#include <strstream.h>
#include <fstream.h>
#include <iomanip.h>

#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include <errno.h>
#include <string.h>
#include<iostream.h>

#include "strng.h"
#include "xerror.h"
#include "map.h"
#include "get_types.h"

#include "tiffio.h"

typedef int myBool;
typedef int Endian;

static const int TFLOAT32=0;
static const int TCHAR8=1;
static const int TUCHAR8=2;
static const int TINT16=3;
static const int TUINT16=4;
static const int TINT32=5;
static const int TUINT32=6;
static const int TINT64=7;
static const int TUINT64=8;
static const int TFLOAT64=9;

const int IS_FALSE=0;
const int IS_TRUE=1;
//const int BIG_ENDIAN=1;
//const int LITTLE_ENDIAN=0;

inline unsigned char bswap (unsigned char);
inline unsigned short bswap (unsigned short);
inline unsigned int bswap (unsigned int);
inline float bswap (float);

#define MAXLEN    132  /* max length of strings */
#define MAXLINE    80  /* max length of title lines */
#define MAXLINE1D  80  /* max length of 1D data lines */
#define MAXLINE2D 132  /* max length of 2D data lines */
#define MAXSTRING  20  /* max No. of strings */
#define DATA_ONLY                1  /* how the ASCII data is recorded */
#define DATA_ERROR_MIXED         2  /*              "                 */
#define FIRST_DATA_THEN_ERROR    3  /*              "                 */


class ConvFile
{
 public:
  ConvFile ()
    {
      
    }
  
  ConvFile (const char* pszN) : sFileName (pszN)
    {

    }

  static Endian getEndian ();
  void putdtype(int);
  int getdircount();
  protected:
  int dtype;
  int dircount;
  strng sFileName;
};

class BSLHeader;
class BinaryOutFile;
class tiffOutFile;

class InConvFile : public ConvFile
{
 public:
  InConvFile () : ConvFile ()
    {

    }

  ~InConvFile ()
    {
      if (pFile)
     {
       fclose(pFile);
     }

    }

  InConvFile (const char* pszN) : ConvFile (pszN)
    {

    }

  char *GetTitle()
    {
      return Title;
    }

  virtual void convert(BSLHeader&,BinaryOutFile&) = 0;
  virtual void tiffconvert (tiffOutFile& tiffFile )=0;
  virtual int pixels () = 0;
  virtual int rasters() = 0;
  virtual int rasters (int) =0;

  static strng getNthFileName (const strng&, int);

 protected:
  virtual void openFile ();
  FILE* pFile;
  int nFileDescriptor;
  char* Title;
};

class OutConvFile : public ConvFile
{
 public:
  OutConvFile () : ConvFile ()
    {

    }

  OutConvFile (const char* pszN) : ConvFile (pszN)
    {

    }

protected:
  ofstream* pOut;
};


class BinaryInFile : public InConvFile
{
 public:
  BinaryInFile () : InConvFile ()
    {

    }

  BinaryInFile (const char* pszN, myBool bSwp, int nOff, double dAsp);

  BinaryInFile (BinaryInFile& b);

  virtual ~BinaryInFile ()
    {
      if(pMap){
        delete pMap;
        pMap=NULL;
      }
      if(pfLine){
        delete[] pfLine;
        pfLine=NULL;
      }
    }
  
  virtual void convert (BSLHeader& headerFile, BinaryOutFile& binaryFile) = 0;
   virtual void tiffconvert (tiffOutFile& tiffFile)=0;
  int pixels ()
    {
      return nInPixels;
    }
  
  int rasters ()
    {
      return nInRasters;
    }

  int rasters (int nOutP)
    {
      return int (double (nOutP * nInRasters) /
		  (dAspect * double (nInPixels)) + 0.5);
    }

 int recordlength()
    {
      return nRecordLength;
    }

protected:
  virtual float* transformLine (int nLine) = 0;
  virtual float interpolate (double x, double y) = 0;
  virtual MemMap* map () = 0;

  MemMap* pMap;
  float* pfLine;
  int nInPixels;
  int nInRasters;
  int nOutPixels;
  int nOutRasters;
  int nRecordLength;
  myBool bSwap;
  unsigned long ulOffset;
  double dAspect;
  double dRatio;
};

template <class T>
class BinInFile : public BinaryInFile
{
public:
  BinInFile () : BinaryInFile ()
    {

    }

  BinInFile (const char* pszN, int nInP, int nInR, myBool bSwp, int nOff,
	     double dAsp);

  virtual void convert (BSLHeader& headerFile, BinaryOutFile& binaryFile);
  virtual void tiffconvert (tiffOutFile& tiffFile);

  protected:
  virtual float* transformLine (int nLine);
  virtual float interpolate (double x, double y);
  virtual double extract (T t);
  virtual MemMap* map ();
};

class SMarInFile : public BinInFile<unsigned short>
{
public:
  SMarInFile (const char* pszN, myBool bSwp) :
    BinInFile<unsigned short> (pszN, 1200, 1200, bSwp, 2400, 1.0)
    {

    }
};

class BMarInFile : public BinInFile<unsigned short>
{
public:
  BMarInFile (const char* pszN, myBool bSwp) :
    BinInFile<unsigned short> (pszN, 2000, 2000, bSwp, 4000, 1.0)
    {

    }
};

class FujiInFile : public BinInFile<unsigned short>
{
public:
  FujiInFile (const char* pszN, myBool bSwp, double dR) :
    BinInFile<unsigned short> (pszN, 2048, 4096, bSwp, 8192, 1.0),
    dDynamicRange (dR / 65536.0)
    {

    }

protected:
  virtual double extract (unsigned short t);

  double dDynamicRange;
};

class Fuji2500InFile : public BinInFile<unsigned short>
{
public:
  Fuji2500InFile (const char* pszN, myBool bSwp) :
    BinInFile<unsigned short> (pszN, 2000, 2500, bSwp, 0, 1.0),
    dDynamicRange (5.0 / 65536.0)
    {

    }

protected:
  virtual double extract (unsigned short t);

  double dDynamicRange;
};


/////////////////////////////
class RAxisInFile : public BinInFile<unsigned short>
{
public:
  RAxisInFile (const char* pszN, myBool bSwp);

protected:
  virtual double extract (unsigned short t);
};

///////////////////////////////////
class PSciInFile : public BinInFile<unsigned short>
{
public:
  PSciInFile (const char* pszN, myBool bSwp) :
    BinInFile<unsigned short> (pszN, 768, 576, bSwp, 0, 1.0)
    {

    }
};
//////RAxis4 by Raj/////////////
class RAxis4InFile : public BinInFile<unsigned short>
{
 public:
    RAxis4InFile (const char* pszN, myBool bSwp):
     BinInFile<unsigned short> (pszN, 3000,3000, bSwp, 6000, 1.0)
  {
   }
 protected:
  virtual double extract (unsigned short t);

};


//**************New Binary input formats By Raj ***//
class NewBinaryFile :  public InConvFile
{
 public:
  NewBinaryFile () : InConvFile ()
    {

    }
  NewBinaryFile (const char* pszN) : InConvFile (pszN)
    {
      imagedata=NULL;
      pfLine=NULL;
    }
  ~NewBinaryFile ()
    {
      delete[] pfLine;
      pfLine=NULL;
      if(imagedata){
	delete[] (char*)imagedata;
	imagedata=NULL;
      }

    }
  virtual void convert (BSLHeader& headerFile, BinaryOutFile& binaryFile);
  virtual void tiffconvert (tiffOutFile& tiffFile );
    int pixels ()
    {
      return nInPixels;
    }

  int rasters ()
    {
      return nInRasters;
    }

  int rasters (int nOutP)
    {
      return int (double (nOutP * nInRasters) /
		  (dAspect * double (nInPixels)) + 0.5);
    }
 protected:
 virtual float* transformLine (int nLine);
 virtual float interpolate (double x, double y);
 virtual double extract (unsigned long p);

 int datatype;
 void* imagedata;
 float* pfLine;
 int nInPixels;
 int nInRasters;
 int nOutPixels;
 int nOutRasters;
 double dAspect;
 double dRatio;
};

//************Bsl input file by Raj ************//


class BslFile : public NewBinaryFile
{

 public:
 BslFile (): NewBinaryFile()
{
}
 BslFile (const char* pszN,int cfr);// : NewBinaryFile(pszN);

  ~BslFile ()
    {

      }

 protected:
 virtual  double extract (unsigned long p);
 void readbslHeader();
 myBool bSwap;
 strng sBinary;
 int nFrames;
 int cFrame;
 FILE *BpFile;
 int Header_size;
 long int memsize;

};

class BslInFile : public BslFile
{
 public:
  BslInFile (const char* pszN,int cfr) :  BslFile(pszN,cfr)
    {
    openFile();
    readbslHeader();

    }

};
//********** tiff input file by Raj*************//

class TiffFile : public NewBinaryFile
{

 public:
  TiffFile (const char* pszN,int cdir) : NewBinaryFile(pszN),currentdir(cdir)
    {
      in=NULL;

    }
  ~TiffFile ()
    {
      if (in)
	TIFFClose(in);
      if(imagedata){
	_TIFFfree(imagedata);
      }
    }

 void readtiff();

 protected:
 virtual void openFile();
 void TIFFReadDirect();
 TIFF* in;
 int  currentdir;
};

class TiffInFile : public TiffFile
{
 public:
  TiffInFile (const char* pszN,int cdir) :  TiffFile(pszN,cdir)
    {
      openFile ();
      TIFFReadDirect();
      readtiff();

    }

};

//***************BRUKER class By raj****************//
class BrukerFile : public NewBinaryFile
{
  
 public:
  BrukerFile (const char* pszN) : NewBinaryFile(pszN)
    {
      OFoffset=NULL;
      OFintensity=NULL;
      
    }
  ~BrukerFile ()
    {
      delete[] OFoffset;
      OFoffset=NULL;
      delete[] OFintensity;
      OFintensity=NULL;
    }
  
  void readimage_gfrm();
  void readimage_asc();
 protected:
  virtual  double extract (unsigned long p);
  
  int noverfl;
  int Header_size;
  long int *OFoffset;
  int *OFintensity;
  long int memsize;
  myBool bSwap;
  char *lineptr;
  char line[81];
};
class BrukerInFile : public BrukerFile
{
 public:
  BrukerInFile (const char* pszN) :  BrukerFile(pszN)
    {
      openFile();
      readimage_gfrm();
    }
  
};

/********BRUKER ASC***************/

class BrukerAscInFile : public BrukerFile
{
 public:
  BrukerAscInFile (const char* pszN) :  BrukerFile(pszN)
    {
      openFile();
      readimage_asc();
    }
  
};

/////BRUKER PLOSTO///////////////////////////
/*class BrukerPLOSTOFile : public NewBinaryFile
{
  
 public:
  BrukerPLOSTOFile (const char* pszN) : NewBinaryFile(pszN)
    {
      

    }
  ~BrukerPLOSTOFile ()
    {
      
    }
  
  void readimage();

 protected:
 // virtual  double extract (unsigned long p);
  
  int Header_size;
  long int memsize;
  myBool bSwap;
  char *lineptr;
  char line[80];
};
class BrukerPLOSTOInFile : public BrukerPLOSTOFile
{
 public:
  BrukerPLOSTOInFile (const char* pszN) :  BrukerPLOSTOFile(pszN)
    {
      openFile();
      readimage();
    }
  
};*/
/////EPRSID2///////////////////////////
class MARFile  : public NewBinaryFile
{
 public:
  MARFile (const char* pszN) : NewBinaryFile(pszN)
    {
      
    }
  ~MARFile()
    {
      
    }
 protected:
  void readimage();
  virtual  double extract (unsigned long p);
  int bpp;
  unsigned long memsize;
  int header_bytes;
  myBool bSwap;
};
class MARInFile  : public  MARFile
{
 public:
  MARInFile (const char* pszN) : MARFile(pszN)
    {
      openFile();	
      readimage();
    }
~MARInFile()
  {
    
  }
 
};
/////Smv///////////////////////////
class SMVFile  : public NewBinaryFile
{
 public:
  SMVFile (const char* pszN) : NewBinaryFile(pszN)
    {
      
    }
~SMVFile()
  {
    
  }
 protected:
 void readimage();
 int bpp;
   
 unsigned long memsize;
 int header_bytes;
 myBool bSwap;	
};
class SMVInFile  : public  SMVFile
{
 public:
  SMVInFile (const char* pszN) : SMVFile(pszN)
    {
      openFile();	
      readimage();
    }
  ~SMVInFile()
    {
      
    }

};
/////MAR345///////////////////////////
class Mar345File : public NewBinaryFile
{
  
 public:
  Mar345File (const char* pszN) : NewBinaryFile(pszN)
    {
    }
  ~Mar345File ()
    {
    }
  void readimage();
 protected:
  
};

class Mar345InFile : public Mar345File
{
 public:
  Mar345InFile (const char* pszN) :  Mar345File(pszN)
    {
      openFile();
      readimage();
    }

};

/////LOQ ///////////////////////////
class LOQFile : public NewBinaryFile
{
  
 public:
  LOQFile (const char* pszN) : NewBinaryFile(pszN)
    {
      strp=NULL;
      dataptr=NULL;
      errorptr=NULL;
    }
  ~LOQFile ()
    {
      delete [] strp;
      delete [] dataptr;
      delete [] errorptr;
      strp=NULL;
      dataptr=NULL;
      errorptr=NULL;

    }

void readimage1d();
void readimage2d();

protected:
 char *strp ;
 float *dataptr, *errorptr ;
 char longtitle1[MAXLINE + 1] ;
 float q, c, ce, scale ;
 float cross1d[MAXLEN];
 float xy[2*MAXLEN];
 float cross2d[MAXLEN*MAXLEN];
 char line2d[MAXLINE2D + 1] ;
 char line1d[MAXLINE1D + 1] ;
};
/////LOQ 1D///////////////////////////
class LOQ1dInFile : public LOQFile
{
 public:
  LOQ1dInFile (const char* pszN) : LOQFile(pszN)
    {
      openFile();
      readimage1d();
    }

};
/////LOQ 2D///////////////////////////
class LOQ2dInFile : public LOQFile
{
 public:
  LOQ2dInFile (const char* pszN) :  LOQFile(pszN)
    {
      openFile();
      readimage2d();
    }

};

///////////////////////////////////////
class TextInFile : public InConvFile
{
public:
  TextInFile () : InConvFile ()
    {

    }

  TextInFile (const char* pszN) : InConvFile (pszN)
    {
      pfLine=NULL;
      AsciiData=NULL;
      openFile ();
    }

  ~TextInFile ()
    {
      delete pIn;
      pIn=NULL;

      if(pfLine){
        delete[] pfLine;
        pfLine=NULL;
      }
      if(AsciiData){
        delete[] AsciiData;
        AsciiData=NULL;
      }
    }

void openFile();
virtual void ReadText ()=0;
virtual void convert (BSLHeader& headerFile, BinaryOutFile& binaryFile);
virtual void tiffconvert (tiffOutFile& tiffFile );
virtual float* transformLine (int nLine);
virtual float interpolate (double x, double y);

int pixels ()
{
  return nInPixels;
}

int rasters ()
{
  return nInRasters;
}

int rasters (int nOutP)
{
  return int (double (nOutP * nInRasters) /
             (dAspect * double (nInPixels)) + 0.5);
}

protected:
  ifstream* pIn;
  float* pfLine;
  float *AsciiData;
  int nInPixels;
  int nInRasters;
  int nOutPixels;
  int nOutRasters;
  double dAspect;
  double dRatio;
};
class RisoInFile : public TextInFile
{
public:
  RisoInFile () : TextInFile ()
    {
    }

  RisoInFile (const char *pszN) : TextInFile (pszN)
    {
      ReadText ();
    }
  
  void ReadText ();
};

class BinaryOutFile : public OutConvFile
{
 public:
  BinaryOutFile () : OutConvFile ()
    {
      
    }
  
  BinaryOutFile (const char* pszN) : OutConvFile (pszN)
    {
      pOut = new ofstream (pszN, ios::out);
    }
  
  virtual ~BinaryOutFile ()
    {
      delete pOut;
      pOut=NULL;
    }
  
  void write (const char* pszSource, int nCount)
    {
      pOut->write(pszSource, nCount);
    }
};

class TextOutFile : public OutConvFile
{
 public:
  TextOutFile () : OutConvFile ()
    {

    }

  TextOutFile (const char* pszN) : OutConvFile (pszN)
    {
      pOut = new ofstream (pszN);
    }

  virtual ~TextOutFile ()
    {
      delete pOut;
      pOut=NULL;
    }
};

class BSLHeader : public TextOutFile
{
public:
  BSLHeader () : TextOutFile ()
    {

    }

  BSLHeader (const char *pszN, int nPix, int nRast, int dtype, int nFram,
	     const char *pszHead1, const char *pszHead2);

  const strng& binaryName ()
    {
      return sBinary;
    }

  int pixels ()
    {
      return nPixels;
    }

  int rasters ()
    {
      return nRasters;
    }

protected:
  void legalFileName () throw (XError);
  void legalValues () throw (XError);

  strng sHeader1;
  strng sHeader2;
  strng sBinary;
  int nPixels;
  int nRasters;
  int nFrames;
};

class tiffFile : public OutConvFile
{
 public:
  tiffFile () : OutConvFile ()
    {

    }

  tiffFile (const char* pszN,int nPix, int nRast) : OutConvFile (pszN) ,nPixels(nPix),nRasters(nRast)
    {

    }

  ~tiffFile ()
    {
    }

protected:
TIFF *out;
int nPixels;
int nRasters;

};

class tiffOutFile : public tiffFile
{
 public:
  tiffOutFile () : tiffFile ()
    {

    }

   tiffOutFile (const char* pszN ,int nPix, int nRast ): tiffFile(pszN,nPix,nRast)
{
 out =TIFFOpen(sFileName.data(), "w");
}

  ~tiffOutFile ()
    {
        if (out)
	  TIFFClose(out);
    }
  TIFF* tiffout_file()
  {
   return out;
  }


  int pixels ()
    {
      return nPixels;
    }

  int rasters ()
    {
      return nRasters;
    }
};

#endif

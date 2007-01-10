#ifndef  _MEM_MAP_H
#define  _MEM_MAP_H

#include <stdio.h>
#include <stdlib.h> 
#include <sys/types.h>
#include <sys/stat.h>

#ifdef UNIX
#   include <unistd.h>
#   include <sys/mman.h>
#else
#   define PROT_READ  0
#   define PROT_WRITE 0
#   define MAP_SHARED 0
#endif

#ifdef LINUX
  #include <exception>
#else
#ifdef WIN32
 #include <exception>
typedef char *caddr_t;
#else
  #include <exception>
#endif
#endif
 
#include "xerror.h"

#ifndef PROT_RDWR
#   define PROT_RDWR (PROT_READ|PROT_WRITE)
#endif

class MemMap 
{
public:
  MemMap ()
    {
	dataAddress=NULL;
	mapAddress=NULL;
    }

  MemMap (FILE *fp, unsigned long ulS, unsigned long ulOS, 
	  int nProt = 0, int nShare = 0, caddr_t pAddr = 0) :
  pFile (fp), stMapSize ((size_t) ulS)
{
	dataAddress=NULL;
	mapAddress=NULL;
  init (ulOS, nProt, nShare, pAddr);
}

  MemMap (MemMap& m)
    {
      pFile = m.pFile;
      nFileDescriptor = m.nFileDescriptor;
      mapAddress = m.mapAddress;
      stFileSize = m.stFileSize;
      stMapSize = m.stMapSize;
      otOffset = m.otOffset;
      dataAddress = m.dataAddress;
    }

  ~MemMap ()
    {
		destroy ();
    }
  
  void advise (unsigned long nLen, int nAdvice);

  void* operator() ()
    {
      return dataAddress;
    }

protected:
  size_t getFileSize();

  static const int pageSize;
  FILE *pFile;
  int nFileDescriptor;
  caddr_t mapAddress;
  size_t stFileSize;
  size_t stMapSize;
  off_t otOffset;
  void* dataAddress;

private:
  void destroy ();
  void init (unsigned long, int, int, caddr_t);
};

#endif

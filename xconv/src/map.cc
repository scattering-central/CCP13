#ifdef WIN32
#include "stdafx.h"
#endif
#include "map.h"

#ifdef UNIX
const int MemMap::pageSize = sysconf (_SC_PAGESIZE);
#else
const int MemMap::pageSize = 1;
#endif

void MemMap::init (unsigned long ulOS, int nProt, int nShare, caddr_t pAddr)
{
#ifndef _WIN32
  nFileDescriptor = fileno (pFile);
  stFileSize = getFileSize ();
#endif

#ifdef UNIX

  nProt = (nProt == 0) ? PROT_READ : nProt;
  nShare = (nShare == 0) ? MAP_SHARED : nShare;

  otOffset = (off_t) (ulOS - ulOS % pageSize);

  if (stMapSize == 0)
    {
      stMapSize = stFileSize - otOffset;
    }
  else
    {
      stMapSize += ulOS - otOffset;
    }

  if (otOffset + stMapSize > stFileSize)
    {
      THROW_ERR("Attempting to map area larger than file");
    }
  else
    {
      mapAddress = (caddr_t) mmap (pAddr, stMapSize, nProt, nShare,
				   nFileDescriptor, otOffset);
    }

  if (mapAddress == (caddr_t) -1)
    {
      THROW_ERR("Error mapping file");
    }

  dataAddress = (void *) (mapAddress + ulOS - otOffset);

#else
  
  if (stMapSize == 0)
    {
      stMapSize = stFileSize - ulOS;
    }

  if (fseek (pFile, ulOS, SEEK_SET) == -1)
    {
      THROW_ERR("Improper fseek");
    }

#ifdef SOLARIS
  try 
    {
      mapAddress = new char[stMapSize];
    }

  catch (xalloc& e)
    {
      THROW_ERR("Error allocating memory");
    }
#else
  if ((mapAddress = new char[stMapSize]) == NULL)
    {
      THROW_ERR("Error allocating memory");
    }
#endif
	
#ifdef WIN32
	int c=0;//,totol=0;
//	if ((c= fread (mapAddress, 1, stMapSize, pFile))!=stMapSize)
	if (!fread (mapAddress, 1, stMapSize, pFile))
#else
  if (fread (mapAddress, 1, stMapSize, pFile) != stMapSize)
#endif
    {
      delete[] mapAddress;
       mapAddress=NULL;
      THROW_ERR("Error reading file");
    }

  dataAddress = (void *) mapAddress;

#endif
}

size_t MemMap::getFileSize()
{
  struct stat sb;

  if (fstat (nFileDescriptor, &sb) < 0)
    {
      THROW_ERR("Error getting file status");
    }

  return (size_t) sb.st_size;
}

void MemMap::advise (unsigned long nLen, int nAdvice)
{
#ifndef LINUX
#ifdef UNIX
  if (madvise (mapAddress, (size_t) nLen, nAdvice) < 0)
    {
      THROW_ERR("Error giving map advice");
    }
#endif
#endif
  return;
}

void MemMap::destroy ()
{
#ifdef UNIX
  munmap (mapAddress, stMapSize);
#else
	  delete[] mapAddress;
#endif
}

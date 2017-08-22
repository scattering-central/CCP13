// from MORE C++ for Dummies

// by Stephen R. Davis, IDG Books



// STRNG.CPP - the source code for the strng class

//

// the reference to string.h is to the C include file

// (includes prototypes for strcpy() and strcat()) and

// not the ANSI C++ standard string.h, which has

// string class definitions

#include <string.h> 

#include <ctype.h>



#include "strng.h"



strng::~strng()

{

    delete pszBuffer;

}



// append - append one string onto the end of another

strng& strng::append(const strng& s)

{

    char* pszNewBuffer = 

                       new char[nLength + s.nLength + 1];

    strcpy(pszNewBuffer, "");

    if (data())

    {

        strcat(pszNewBuffer, data());

    }

    if (s.pszBuffer)

    {

        strcat(pszNewBuffer, s.data());

    }



    delete pszBuffer;

    pszBuffer = pszNewBuffer;

    nLength += s.nLength;

    return *this;

}

strng& strng::append(const char* pszS)

{

    if (pszS == 0)

    {

        return *this;

    }

    int nSLength = strlen(pszS);



    char* pszNewBuffer =

                       new char[nLength + nSLength + 1];

    strcpy(pszNewBuffer, "");

    if (data())

    {

        strcat(pszNewBuffer, data());

    }

    strcat(pszNewBuffer, pszS);



    delete pszBuffer;

    pszBuffer = pszNewBuffer;

    nLength += nSLength;

    return *this;

}

strng& strng::append(const char c)

{

    char cLocal[2];

    cLocal[0] = c;

    cLocal[1] = 0;

    return append(cLocal);

}



// assign - copy one string over another

strng& strng::assign(const strng& s)

{

    remove();

    nLength = s.nLength;

    if (nLength)

    {

        pszBuffer = new char[nLength + 1];

        strcpy(pszBuffer, s.data());

    }

    return *this;

}

strng& strng::assign(const char* pszS)

{

    remove();

    if (pszS)

    {

        nLength = strlen(pszS);

        pszBuffer = new char[nLength + 1];

        strcpy(pszBuffer, pszS);

    }

    return *this;

}



// compare - return return -1, 0, or 1 depending on

//           which string is less

int strng::compare(const char* pszS,

                        size_t nPos,

                        size_t nLen)

{

    size_t nLenS = strlen(pszS);

    size_t nS = (nLenS < nLen) ? nLenS : nLen;

    size_t nThis = strlen(data()) - nPos;



    // first compare the strings (as far as they go)

    size_t nCompare = (nThis < nLen) ? nThis : nLen;

    int nResult = memcmp(data() + nPos, pszS, nCompare);

    if (nResult)

    {

        return nResult;

    }



    // okay, the strings looked the same;

    // see if one string is longer than the other

    if (nThis > nS)

    {

        return 1;

    }

    if (nThis < nS)

    {

        return -1;

    }



    // no? okay, they're equal

    return 0;

}



// getline - read a string from the input stream

istream& getline(istream& in, strng& s, char cDelim)

{

    // clear out the string

    s.remove();



    // now extract characters into the string

    char cLocal;

    for(;;)

    {

        in >> cLocal;

        if (!in.good())

        {

            break;

        }

        if (cLocal == cDelim)

        {

            break;

        }

        s.append(cLocal);

    }

    return in;

}



// find - find a smaller string within a strng

size_t strng::find(const char* pszSrc, size_t nOff)

{

    const char* pszTarget = data();



    // use the ANSI strstr() to do the search

    const char* pSubString = 

                      strstr(pszTarget + nOff, pszSrc);



    // if string not found, return NPS

    if (pSubString == 0)

    {

        return NPS;

    }



    // otherwise, return the offset

    return (size_t)(pSubString - pszTarget);

}



// read - read a string from the input stream

//        (this is not an ANSI function - it's

//        used by operator>>())

void strng::read(istream& is)

{

    // clear out the current stream

    remove();



    // get the width out of the stream

    // and clear it

    int nWidth = is.width();

    is.width(0);



    // skip leading white space

    char c;

    is >> c;

    if (is.eof() || is.fail())

    {

        return;

    }



    // now add chars to the string

    // until either white space or width

    // encountered

    do

    {

        // add the current character

        append(c);



        // if there is a width setting...

        if (nWidth)

        {

            // ...then stop when it expires

            if (--nWidth == 0)

            {

                break;

            }

        }



        // otherwise, get another character

        // (use get() because it doesn't skip white space)

        c = (char)is.get();

        if (is.eof() || is.fail())

        {

            break;

        }

    } while (!isspace(c));

}



// remove - clear out the buffer

strng& strng::remove()

{

    delete pszBuffer;

    pszBuffer = 0;

    nLength = 0;

    return *this;

}



// replace - replace a substring within a strng

//           with another string

strng& strng::replace(size_t nOff,

                      size_t nLen,

                      const strng& sNew)

{

    // first, remove the specified section

    char *pT = pszBuffer + nOff;



    // don't remove more characters than are left

    size_t nRemaining = nLength - nOff;

    if (nLen > nRemaining)

    {

        *pT = '\0';

    }

    else

    {

        strcpy(pT, pT + nLen);

    }



    nLength -= nLen;



    // okay, now insert the new string back in

    char* pszNewBuffer = 

                    new char[nLength + sNew.nLength + 1];

    strncpy(pszNewBuffer, pszBuffer, nOff);

    pszNewBuffer[nOff] = '\0';

    strcat(pszNewBuffer, sNew.data());

    strcat(pszNewBuffer, pszBuffer + nOff);



    delete pszBuffer;

    pszBuffer = pszNewBuffer;

    nLength = strlen(pszBuffer);



    return *this;

}



// operator+() - concatenate a string and a string or 

//                      a string and an NTBS

strng strng::operator+(const strng& s) const

{

    strng sL(*this);

    sL += s;

    return sL;

}

strng strng::operator+(const char* pszS) const

{

    strng sL(*this);

    sL += pszS;

    return sL;

}




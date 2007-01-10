// from MORE C++ for Dummies

// by Stephen R. Davis, IDG Books



// STRNG.H - local implementation of the ANSI

//           standard string class

#ifndef _STRNG_

#define _STRNG_


#ifdef WIN32
#include <iostream>
using namespace std;
#else
#include <iostream.h>
#endif
#include <memory.h>



const size_t NPS = (size_t)-1;



class strng

{

  public:

    strng()

    {

        nLength = 0;

        pszBuffer = NULL;

    }

    strng(const char* pszS)

    {

        pszBuffer = 0;

        assign(pszS);

    }

    strng(const strng& s)

    {

        pszBuffer = 0;

        assign(s);

    }

    ~strng();



    // simple access functions

    const char* data() const

    {

        return pszBuffer;

    }

    int length() const

    {

        return nLength;

    }



    // manipulation functions

    strng& assign(const strng& s);

    strng& assign(const char* pszS);



    strng& append(const strng& s);

    strng& append(const char* pszS);

    strng& append(const char c);



    int    compare(const char* pszS, size_t nPos = 0,

                                      size_t nLen = NPS);

    int    compare(const strng& s, size_t nPos = 0,

                                      size_t nLen = NPS)

    {

        return compare(s.data(), nPos, nLen);

    }



    // read (this is called by the operator>>

    void read(istream& is);



    // clear out the string

    strng& remove();



    // replace a portion of one string with another

    strng& replace(size_t nOff, size_t nLen,

                   const strng& sNew);





    // overloaded operators

    strng& operator+=(const strng& s)

    {

        return append(s);

    }

    strng& operator+=(const char* pszS)

    {

        return append(pszS);

    }



    strng operator+(const strng& s) const;

    strng operator+(const char* pszS) const;



    strng& operator=(const strng& s)

    {

        return assign(s);

    }

    strng& operator=(const char* pszS)

    {

        return assign(pszS);

    }

    char operator[](int nIndex) const

    {

        return pszBuffer[nIndex];

    }

    char& operator[](int nIndex)

    {

        return pszBuffer[nIndex];

    }



    // search operators

    size_t find(const char* pszS, size_t nOff = 0);

    size_t find(const strng& s, size_t nOff = 0)

    {

        return find(s.data(), nOff);

    }



    // comparison operators

    int operator<(const strng& s)

    {

        return (compare(s) < 0);

    }

    int operator<=(const strng& s)

    {

        return (compare(s) <= 0);

    }

    int operator==(const strng& s)

    {

        return (compare(s) == 0);

    }

    int operator>(const strng& s)

    {

        return (compare(s) > 0);

    }

    int operator>=(const strng& s)

    {

        return (compare(s) >= 0);

    }



protected:

    int  nLength;

    char *pszBuffer;

};



inline ostream& operator<<(ostream& out, const strng& s)

{

    out << s.data();

    return out;

}



inline istream& operator>>(istream& is, strng& s)

{

    s.read(is);

    return is;

}



istream& getline(istream& in, strng& s,

                                   char cDelim = '\n');


#endif




// XError.h - the C++ exception class hierarchy



#ifndef _XERROR_H

#define _XERROR_H



#include <iostream.h>

#include "strng.h"



// XError - the base class for locally generated

//          exceptions

class XError

{

  public:

    XError(const char* pszFile, // file of error

           const int   nL,      // line of error

           const char* pszReason) : // problem descr

       sFile(pszFile), nLine(nL), sReason(pszReason)

    {

    }



    // display - output appropriate error message; each

    //           subclass of XError overloads this in its

    //           own image


#ifdef DEBUG

    virtual void display(ostream& out) const

    {

        out << "@" << sFile 
 
            << ":" << nLine 
 
            << " - " << sReason

	    << "\n";
 
    }

#else

    virtual void display(ostream& out) const

    {
     
        out << "Exception thrown: " << sReason << "\n";

    }

#endif

  public:

    const strng sFile;

    const int   nLine;

    const strng sReason;

};



inline ostream& operator<<(ostream& out, XError& xerr)

{

    xerr.display(out);

    return out;

}


#define THROW_ERR(x) (throw XError(__FILE__, __LINE__, x))


#endif


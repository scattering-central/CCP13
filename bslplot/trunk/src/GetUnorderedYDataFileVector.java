import java.io.*;
import java.util.Stack.*;
import java.util.*;

/**
 * This class recieves a filename for a data text file 
 * Returns a vector of XYDataPoints for that file 
 *  
 * @see XYDataPoint.java  
 */
public class GetUnorderedYDataFileVector
  {
  private Vector rtn;

  /**
   * Returns the vector to the calling object - vector is composed
   * of XYDataPoint elements - XYDataPoints are very simple structures
   * that contain an "x" public double and a "y" public double. 
   * In _THIS_ instance we are only interested in using the structure
   * for convenience - we only have 1-D data.
   */
  public Vector getVector ()
    {
    return rtn;
    }

  public GetUnorderedYDataFileVector (String filename)
    {
    ReadTextFile rtf = new ReadTextFile(filename);
    Vector v ;
    Object dummy_object;
    String dummy_string;
   
    rtn = new Vector ();
    v = rtf.getTextFileVector(); 

    // Ok - we have the vector with the strings containing
    // our double. Have to create a vector of classes (the
    // classes being simple XY data structures.

    Enumeration e = v.elements ();

    while (e.hasMoreElements ())
      {
      XYDataPoint xydp = new XYDataPoint();
      double this_x,this_y;
      GetDouble gd;

      dummy_object = e.nextElement();

      if (dummy_object instanceof String)
        {
	dummy_string = (String) dummy_object;
        gd = new GetDouble(dummy_string);
        xydp.x = gd.this_double ;
	  
        // Next assignment is of no consequence - we are
        // just using the existing XYDataPoint as a convenient
        // structure to store/order our 1-D data vector
        // we will ignore the Y values of the XYDataPoints at the
        // calling end.
        xydp.y = 0.0 ;
        rtn.addElement(xydp);
	}
      }
    } 
  } 









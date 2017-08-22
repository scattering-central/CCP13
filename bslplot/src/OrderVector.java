import java.io.*;
import java.util.Stack.*;
import java.util.*;

/**
 * This class recieves a filename for a data text file 
 * (consisting of just two space-separated doubles per line) and forms an
 * ordered data file vector to return to the calling object.
 *  
 * The data file vector returned is composed entirely 
 * of XYDataPoint elements - XYDataPoints are very simple structures
 * that contain just an "x" public double and a "y" public double. 
 *  
 * @see XYDataPoint.class 
 */
public class OrderVector
  {
  private Vector rtn;

  public Vector getVector ()
    {
    return rtn;
    }

  private int get_lowest_element (Vector v)
    {
    // finds the element of vector v with lowest x value
    double dummy; 
    int sz,rtn, i;
    Enumeration e = v.elements();
    sz = v.size();
    i = 0;
    XYDataPoint xydp = (XYDataPoint) v.firstElement ();
    dummy = xydp.x; 
    ++i;
    rtn = 0;

    while (i < sz)
      {
      xydp = (XYDataPoint) v.elementAt (i);
      if (xydp.x < dummy)
        {
	dummy = xydp.x;
        rtn = i;
        }
      ++i;
      }
    return rtn;
    }

  public OrderVector (Vector v)
    {
    rtn = new Vector ();
    order_vector(v);
    }

  // This method takes care of forming the rtn vector (ordered)
  // and simultaneously removing elements from the passed-in vector
  // - which is unordered data. Data is ordered in "rtn" in
  // ascending x value.
  private void order_vector (Vector v)
    {
    int dummy_idx = get_lowest_element (v);
    XYDataPoint xydp = (XYDataPoint) v.elementAt (dummy_idx);
    rtn.addElement(xydp);
    v.remove(dummy_idx);
    if (v.size () > 0) 
      order_vector (v); 
    }
  } 




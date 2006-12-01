import java.io.*;
import java.util.Stack.*;
import java.util.*;

/**
 * This class recieves a filename for a data text file 
 * (consisting of just two space-separated doubles per line) and forms an
 * unordered data file vector to return to the calling object.
 * To be of any real use, the data file vector would need to be
 * ordered (i.e., data points listed in ascending x-value). This
 * class does *NO SUCH ORDERING*. 
 *  
 * @see XYDataPoint.java  
 */
public class GetUnorderedXYDataFileVector
  {
  private Vector rtn;


  /**
   * Returns the vector to the calling object - vector is composed
   * of XYDataPoint elements - XYDataPoints are very simple structures
   * that contain an "x" public double and a "y" public double. 
   */
  public Vector getVector ()
    {
    return rtn;
    }

  public GetUnorderedXYDataFileVector (String filename)
    {
    ReadTextFile rtf = new ReadTextFile(filename);
    Vector v ;
    Object dummy_object;
    String dummy_string;
   
    rtn = new Vector ();
    v = rtf.getTextFileVector(); 

    // Ok - we have the vector with the strings containing
    // numbers in it. Have to create a vector of classes (the
    // classes being simple XY data structures.

    Enumeration e = v.elements ();

    while (e.hasMoreElements ())
      {
      XYDataPoint xydp = new XYDataPoint();
      double this_x,this_y;
      GetDoublePairs gdp;

      dummy_object = e.nextElement();

      if (dummy_object instanceof String)
        {
	dummy_string = (String) dummy_object;
        gdp = new GetDoublePairs(dummy_string);
	if (gdp.ok() )
	  {
	  xydp.x = gdp.getFirstDouble ();
	  xydp.y = gdp.getSecondDouble ();
          rtn.addElement(xydp);
	  }
	}
      }
    } 
  } 









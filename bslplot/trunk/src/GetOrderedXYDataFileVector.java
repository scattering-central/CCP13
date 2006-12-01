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
public class GetOrderedXYDataFileVector
  {
  private Vector rtn;

  /**
   * Returns the ordered data file vector to the calling object. 
   */
  public Vector getVector ()
    {
    return rtn;
    }

  public GetOrderedXYDataFileVector (String filename)
    {
    GetUnorderedXYDataFileVector g = new GetUnorderedXYDataFileVector 
                                           (filename);
    Vector v = g.getVector ();
    OrderVector ov = new OrderVector (v);
    rtn = ov.getVector ();
    } 
  } 









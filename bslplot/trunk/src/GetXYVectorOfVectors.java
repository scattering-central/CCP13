import java.io.*;
import java.util.Stack.*;
import java.util.*;

/**
 * This class recieves a filename for a data text file 
 * - this data file is merely an ordered list of data files - one
 * for every curve pertaining to a three-D plot.
 * Job of this procedure is to return a vector-of-vectors i.e.,
 * a sequential list of vectors - each vector in the list
 * corresponding to the data contained in the file pointed
 * to by the filenames in the original list. The vector
 * of vectors is ordered - i.e., first filename in original list
 * corresponds to first vector in vector of vectors.
 *
 * Furthermore, the data in each vector is ordered - in ascending
 * x-value.
 * 
 * @see XYDataPoint.class 
 */
public class GetXYVectorOfVectors 
  {
  private Vector rtn;
  private Vector filelist;
  /**
   * Returns the ordered vector of vectors to the calling object. 
   */
  public Vector getVector ()
    {
    return rtn;
    }

  public GetXYVectorOfVectors (String filename)
    {
    ReadTextFile rtf = new ReadTextFile(filename);
    Object dummy;

    rtn = new Vector();
    filelist = rtf.getTextFileVector ();  
    Enumeration e = filelist.elements ();

    while (e.hasMoreElements ())
      {
      dummy = e.nextElement ();
      if (dummy instanceof String)
        {
	GetOrderedXYDataFileVector g = new GetOrderedXYDataFileVector 
                                           ((String)dummy);
        rtn.addElement(g.getVector());
	}
      }
    }
  } 



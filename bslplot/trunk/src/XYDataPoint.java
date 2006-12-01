import java.util.Vector;

/**
 * This is the basic structure used in storing XY data for the class
 * "GetOrderedXYDataFileVector" - which reads a data file composed 
 * of two space-separated doubles per line, and then returns a vector - 
 * the elements of which are simple instances of this class - 
 * the instances being in ascending x-value order. 
 *

 * @param x This is the "x" value from the data file 
 *
 * @param y This is the "y" value from the data file
 */

public class XYDataPoint 
  {
  public double x;
  public double y;
  public int plot_x;
  public int plot_y;
  public boolean plottable;
  public Vector FullPointCurve;
  } 


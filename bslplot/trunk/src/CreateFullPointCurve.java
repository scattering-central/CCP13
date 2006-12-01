import java.util.*;
import java.util.Vector;
import java.awt.*;
import java.awt.event.*;
import java.util.Stack;
import java.io.*;
import javax.swing.*;
import java.lang.Boolean;


/**
 * Class accepts a vector of vectors - each vector being a list
 * (ordered) of XYDataPoints structures - purpose of this
 * class is to set the 'plottable' property of each
 * XYDataPoint element - and to set the plot_x and plot_y
 * values, given the general plot parameters.  */
public class CreateFullPointCurve  
  {
  private Vector rtn; 
  private int err = 0;
  private int Min_x;
  private int Max_x; 
  private int Min_y;  
  private int Max_y;  
  private double Min_data_x;  
  private double Max_data_x;  
  private double Min_data_y;  
  private double Max_data_y;  

  public Vector getFullPointCurve ()
    { 
    return rtn;
    }

  private double get_gradient (double x0,
                               double y0,
                	       double x1,
     	                       double y1)
    {
    err = 0;
   
    if (x1 == x0)
      {
      err = -1;
      return 0.0;
      }
    else
      {
      return ( (y1 - y0)/(x1 - x0)); 
      }
    }
  
  private double get_intercept (double x0,
                                double y0,
	                        double x1,
	                        double y1)
    {
    err = 0;
    
    if (x1 == x0)
      {
      err = -1;
      return 0.0;
      }
    else
      {
      return (y0 - x0*(y1 - y0)/(x1 - x0)); 
      }
    }

  private int get_plot_y (double y)
    {
    double d = (Max_y - Min_y)*
                  ((y - Min_data_y)/(Max_data_y - Min_data_y));
    return (Max_y - Min_y - (int)d);
    }
  
  private int get_plot_x (double x)
    {
    double d = (Max_x - Min_x)*
                  ((x - Min_data_x)/(Max_data_x - Min_data_x));
    return (Min_x + (int)d);
    }
 
  private void set_plot_x_and_plot_y (XYDataPoint xy)
    {
    xy.plot_x = get_plot_x(xy.x);
    xy.plot_y = get_plot_y(xy.y);
    }

  public CreateFullPointCurve (Vector curve,
                               int min_x,
                               int max_x,
                               int min_y,
                               int max_y,
                               double min_data_x,
                               double max_data_x,
                               double min_data_y,
                               double max_data_y) 
    {
    Enumeration e = curve.elements ();
    XYDataPoint xydp, prev, prev2;
    double gradient,intercept;
    int i;
    rtn = new Vector (); 
    Min_x       = min_x;
    Max_x       = max_x; 
    Min_y       = min_y;
    Max_y       = max_y; 
    Min_data_x  = min_data_x;  
    Max_data_x  = max_data_x;  
    Min_data_y  = min_data_y;  
    Max_data_y  = max_data_y;   
   
    prev = (XYDataPoint) e.nextElement();
    xydp = prev2 = prev;
    set_plot_x_and_plot_y(prev);

    while (e.hasMoreElements ())
      {
      xydp = (XYDataPoint) e.nextElement();
      set_plot_x_and_plot_y(xydp);
 //       System.out.println(
// "prev.plot_x " + prev.plot_x + ", prev.plot_y = " + prev.plot_y  );
//        System.out.println(
// "xydp.plot_x " + xydp.plot_x + ", xydp.plot_y = " + xydp.plot_y  );
   
      if (prev != xydp)
        {
        gradient = get_gradient((double)prev.plot_x,
                                (double)prev.plot_y,
                                (double)xydp.plot_x,
                                (double)xydp.plot_y); 
        intercept = get_intercept((double)prev.plot_x,
                                (double)prev.plot_y,
                                (double)xydp.plot_x,
                                (double)xydp.plot_y); 
        
  //      System.out.println(
// "add_data_point:grad= " + gradient + ", int = " + intercept + ", err= " + err);
        for (i = prev.plot_x; i < xydp.plot_x; ++i)
          add_data_point(i,prev,xydp,gradient,intercept);  
        } 
      prev2 = prev;
      prev = xydp;
      }     
    
    // Finally, add very last data point that would have been missed
    // by while loop 
    //rtn.addElement (xydp);
    }
 
  private void add_data_point (int x, 
	                       XYDataPoint prev,
	                       XYDataPoint xydp,
                           double gradient,
                           double intercept)
    {
    if (err != -1)
	  {
      if (err != -1)
        {
        // Ok - got the gradient and intercept okay
        XYDataPoint pt = new XYDataPoint ();
        pt.plot_x      = x;
        pt.plot_y      = (int)(gradient*x + intercept);
        System.out.println(
 "pt.plot_x " + pt.plot_x + ", pt.plot_y = " + pt.plot_y  );
    
        rtn.addElement (pt);
        }
      }
    }
  }
      



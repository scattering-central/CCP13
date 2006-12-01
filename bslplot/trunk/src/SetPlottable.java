// Import essential modules
import java.awt.*;
import javax.swing.*;
import java.util.Stack;
import java.awt.event.*;
import java.util.*;
import java.io.*;
import java.lang.Boolean;


/**
 * Class accepts a vector of vectors - each vector being a list
 * (ordered) of XYDataPoints structures - purpose of this
 * class is to set the 'plottable' property of each
 * XYDataPoint element - and to set the plot_x and plot_y
 * values, given the general plot parameters.  */
public class SetPlottable 
  {
  public boolean is_point_plottable (int prev_x1,
                                     int prev_y1,
                                     int prev_x2,
                                     int prev_y2,
                                     int this_x,
                                     int this_y)
    {
    // This proc checks the x,y values of a data point against
    // the x and y values of two data points of a previous curve
    // to see if this new data point should be plotted. The idea
    // is that the new data point should only be plotted if it is
    // legitimately above the previous curve.

    double prev_gradient, prev_intercept;

    if (prev_x2 == prev_x1)
      {
      // This is an unusual case: we cannot treat the same way as other
      // points as we will get a divide-by-zero error.
      if (prev_y1 > prev_y2)
        return (this_y > prev_x1);  
      else
        return (this_y > prev_x2);  
      }

    // Find out what the gradient is of the line defined by the two
    // data points prev1 and prev2.
    prev_gradient = (int)((prev_y2 - prev_y1)/(prev_x2 - prev_x1));

    // Now find the intercept of the line defined by the two previous
    // points.
    prev_intercept = (int)(prev_y1 - prev_gradient*prev_x1); 

    // Ok - we now have the equation of the line defined by the two
    // previous points.

    return (this_y < (int)((prev_gradient*this_x + prev_intercept)));  
    }

  public SetPlottable (Vector plot_vector, 
                       double max_data_x,
                       double max_data_y,
                       double min_data_x,
                       double min_data_y,
                       int max_x,
                       int max_y,
                       int x_start,
	               int y_start,
	               int first_curve_z_offset,
	               int z_axis_step_size)
    {
    Enumeration curve_enum, e = plot_vector.elements ();
    Object dummy,dummy2; 
    XYDataPoint xydp;
    int this_idx = 0;
    
    while (e.hasMoreElements ())
      {
      dummy = e.nextElement ();
      if (dummy instanceof Vector)
        {
        Vector dummy_vector =  (Vector) dummy;      
        curve_enum = dummy_vector.elements();
        while (curve_enum.hasMoreElements ())
          {
          xydp = (XYDataPoint) curve_enum.nextElement();
          GetPlotXFromX gx = new GetPlotXFromX(xydp.x,
	                                       max_data_x,
					       min_data_x,
					       this_idx,
					       max_x,
					       x_start,
					       first_curve_z_offset,
					       z_axis_step_size);
          xydp.plot_x = gx.plot_x;
          GetPlotYFromY gy = new GetPlotYFromY(xydp.y,
	                                       max_data_y,
					       min_data_y,
					       this_idx,
					       max_y,
					       y_start,
					       first_curve_z_offset,
					       z_axis_step_size);
          xydp.plot_y = gy.plot_y;

          if (this_idx == 0)
	    xydp.plottable = true; // first curve is always plotted whole
          else
            set_if_point_can_be_plotted(plot_vector,this_idx,xydp);
          }
	    }  
     ++this_idx;
     }
   } 
 
  private boolean check_each_curve (Vector curve, XYDataPoint xydp)
    {
    // This method *ABSOLUTELY DEMANDS* that the curves are
    // ordered in ascending x-value!
    Enumeration curve_enum = curve.elements();
    XYDataPoint prev; 
    int prev_x_y_set = 0;
      
    prev = (XYDataPoint) curve.elementAt(0);
    while (curve_enum.hasMoreElements ())
      {
      XYDataPoint this_xydp = (XYDataPoint) curve_enum.nextElement();
      if (prev_x_y_set == 0)  
	prev_x_y_set = 1;
      else if (prev.plot_x > xydp.plot_x)
        return true; 
      else
        {
        if ((xydp.plot_x >= prev.plot_x) &&
            (xydp.plot_x <= this_xydp.plot_x) ) 
	  return (is_point_plottable(prev.plot_x,
                                         prev.plot_y,
                                         this_xydp.plot_x,
                                         this_xydp.plot_y,
                                         xydp.plot_x,
                                         xydp.plot_y)); 
	}
      prev = this_xydp ; 
      }
    return true; 
    }

  private void set_if_point_can_be_plotted (Vector plot_vector, 
                                           int curve_idx,
                                           XYDataPoint xydp)  
    {
    Enumeration e = plot_vector.elements(), curve_enum;
    Object dummy, dummy_object2;
    int rtn = 0, this_idx = 0;
    Vector dummy_vector;
    int prev_x = 0, prev_y = 0;
    int this_x, this_y;
    int prev_x_y_set = 0;
    double x,y;
 
    xydp.plottable = false;
    while (e.hasMoreElements ())
      {
      dummy = e.nextElement ();
      if (dummy instanceof Vector)
        {
        //System.out.println("Point x = " + xydp.plot_x ); 
        if (this_idx == curve_idx)
	  {
	  xydp.plottable = true;
          //System.out.println("Point x = " + xydp.plot_x + " is plottable. "); 
	  return ;
          } 
	if (! check_each_curve((Vector)dummy, xydp) ) 
	  return ;
	}
      ++this_idx;
      }
    return ; 
    }
  }








// Import essential modules
import java.awt.*;
import javax.swing.*;
import java.util.Stack;
import java.awt.event.*;
import java.util.*;
import java.io.*;
import java.lang.Boolean;

public class bslp extends JFrame
  {
  int Error = 0; // default state 

  // These will hold the extrema values for the data sets.
  double Max_data_x;
  double Max_data_y;
  double Min_data_x;
  double Min_data_y;
  int Min_max_data_set = 0;

  // Z axis offset plottable for the first (smallest min x) curve
  int First_curve_z_offset;
  
  // Max length of z axis
  static int Max_z_axis_len = 400;

  // This holds the number of curves to be plotted
  int Num_curves_to_plot ;

  // This holds the value of the gap between curves on the z-axis 
  int Z_axis_step_size;

  // This is the default z-axis step-size 
  static int Default_z_axis_step_size  = 10 ;

  // These are for setting whether num plots is even or odd
  int Plot_even_odd_mode ; 
  static int Plot_mode_even = 0;
  static int Plot_mode_odd  = 1;

  static int Max_x = 440;
  static int Max_y = 440;
  static int X_start = 10;
  static int Y_start = 30;
  static int Lower_panel_gap = 40;
  static String Prog_name = "BSLPlot";

  // Read-only possible values for data point characters.
  static String Data_point_char_plus      = "+";
  static String Data_point_char_dot       = ".";
  static String Data_point_char_cross     = "x";
  static String Data_point_char_minus     = "-";
  static String Data_point_char_star      = "*";
 
  // Indices for above characters. 
  static int Data_point_char_plus_idx     = 0;
  static int Data_point_char_dot_idx      = 1;
  static int Data_point_char_cross_idx    = 2;
  static int Data_point_char_minus_idx    = 3;
  static int Data_point_char_star_idx     = 4;
  String Data_point_char ;

  static int BSLPlot_colour_red_idx    = 0;
  static int BSLPlot_colour_green_idx  = 1;
  static int BSLPlot_colour_blue_idx   = 2;
  static int BSLPlot_colour_black_idx  = 3;
  static int BSLPlot_colour_white_idx  = 4;

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

  public int get_curve_idx (Vector plot_vector, Vector curve)
    {
    // This procedure accepts a plot_vector and returns the index
    // (the number corresponding to this specific curve in the plot)
    // for the curve 'curve'
    Enumeration e = plot_vector.elements();
    Object dummy;
    int rtn = 0;
    Vector dummy_vector;
 
    while (e.hasMoreElements ())
      {
      dummy = e.nextElement ();
      if (dummy instanceof Vector)
        {
        dummy_vector =  (Vector) dummy;      
        if (dummy_vector == curve)
          return rtn;
        }
      ++rtn;
      }
    return -1;
    }

  public boolean is_odd( int i)
    {
    // Returns yes if i is odd 
    return ((i % 2) > 0);
    }

  public void plot_curves (Graphics g, Vector plot_vector)
    {
    // This is the main function for plotting a whole series
    // of curves. Function recieves a vector, whose elements are
    // in turn vectors - curve vectors. First vector in
    // plot_vector is first (lowermost z-axis) curve. This curve is
    // always plotted without consideration of any other curves.
    // All subsequent curves are plotted with reference to previous
    // curves - if the data point of a curve is below the data point of 
    // a previous curve, it is not plotted.

    Vector dummy_curve;
    int prev_idx, this_idx,i;
    Enumeration plot_vector_enum, curve_enum;
    Object dummy_object,dummy_object2;
    String dummy_string;
    double x,y;
    i = 0;
    // Now set the max min parameters for the plot as a whole.
    set_min_max_x_y(plot_vector);
    set_z_axis_curve_offset(plot_vector);
 
    plot_vector_enum = plot_vector.elements();
    
    while (plot_vector_enum.hasMoreElements())
      {
      dummy_object = plot_vector_enum.nextElement ();
     // System.out.println("Iteration i=" + i + ", and plot_vector has " +
     //  plot_vector.size()); 
          
      if (dummy_object instanceof Vector)
        {
        // dummy object IS a vector
        dummy_curve = (Vector) dummy_object; 
        curve_enum = dummy_curve.elements();
     // System.out.println("dummy_curve has " + dummy_curve.size() + " elements." ); 
       
        while (curve_enum.hasMoreElements ())
          {
          dummy_object2 = curve_enum.nextElement();
          x = get_x_value_from_object(dummy_object2);
          y = get_y_value_from_object(dummy_object2);
        
          this_idx = get_curve_idx(plot_vector,dummy_curve);
          draw_data_point(g,x,y,this_idx,plot_vector);
        //  System.out.println("Drawing point x=" + x + ", y=" + y + "idx=" +
	 //  this_idx);
          }
        }
      ++i; 
      set_data_point_colour_green(g); 
      }
    } 

  public void check_for_min_max_x_y (Vector plot_curve)
    {
    // Accepts a curve 
    Enumeration plot_vector_enum, curve_enum;
    curve_enum = plot_curve.elements();
    double x,y;
    Object dummy_object2;
   
    while (curve_enum.hasMoreElements ())
      {
      dummy_object2 = curve_enum.nextElement();
      x = get_x_value_from_object(dummy_object2);
      y = get_y_value_from_object(dummy_object2);

      if (Min_max_data_set == 0)
        {
        Min_data_x = x;
        Max_data_x = x;
        Min_data_y = y;
        Max_data_y = y;

        // This only ever has to be done once, so now we can
        // set it to '1' for ever.
        Min_max_data_set = 1;
        }
      else
        {
        if (x < Min_data_x)
          Min_data_x = x;
        else if (x > Max_data_x)
          Max_data_x = x;  
        
        if (y < Min_data_y)
          Min_data_y = y;
        else if (y > Max_data_y)
          Max_data_y = y;  
        }
      }
    }      

  public void set_min_max_x_y (Vector plot_vector)
    { 
    // This proc goes through every data point in every curve and
    // sets the min, max for x,y - which are global to the set of
    // curves - this is neccessary for getting plot dimensions.
    // Note: there are one set of x_min,x_max,y_min,y_max for ALL
    // the curves - i.e. it is defined for the plot as a whole.

    Vector dummy_curve;
    int prev_idx, this_idx;
    Enumeration plot_vector_enum, curve_enum;
    Object dummy_object,dummy_object2;
    String dummy_string;
    double x,y;

    // This next command ensures that we are going to reset our
    // extremal values.
    Min_max_data_set = 0;
    
    // Form plot enumeration
    plot_vector_enum = plot_vector.elements();
        
    while (plot_vector_enum.hasMoreElements ())
      {
      dummy_object = plot_vector_enum.nextElement(); 
      if (dummy_object instanceof Vector)
        {
        // Ok - it *is* a vector
        dummy_curve = (Vector) dummy_object;
        check_for_min_max_x_y(dummy_curve);
        }
      }
    }

  public void set_z_axis_curve_offset ( Vector plot_vector )
    {
    // This func works out the z-axis separation of the curves -
    // it accepts a vector - plot_vector, which is a list of curves - 
    // these curves should already be ordered and ready to plot.
 
    double dummy;

    // First, work out the number of curves to be plotted.
    Num_curves_to_plot =  plot_vector.size(); 
  //  System.out.println("Num curves to plot is " + Num_curves_to_plot  );
    
    if (Num_curves_to_plot > 
               (Max_z_axis_len/Default_z_axis_step_size)) 
      // We cannot use the default z-axis step-size... 
      // - have to evaluate the new step size
      Z_axis_step_size = (int) (Max_z_axis_len/Num_curves_to_plot);
    else
      // Ok - we don't have too many curves... we can use our default
      // z-axis step size. 
      Z_axis_step_size = Default_z_axis_step_size;
  
    // Now, we have to work out if the number of curves is even or odd
    if (is_odd(Num_curves_to_plot))
      {
      // Ok - there is an odd number of curves. The middle one should be 
      // plotted as central (on the z-axis). 
      Plot_even_odd_mode = Plot_mode_odd;
      First_curve_z_offset = ((Num_curves_to_plot - 1)/2)*Z_axis_step_size; 
      }
   else
      {
      // Ok - there is an even number of curves. The two middle ones should be 
      // plotted either side of the x-axis. 
      Plot_even_odd_mode = Plot_mode_even;
      dummy = ((double) (Num_curves_to_plot - 1)/2);
    //  System.out.println("dummy = " + dummy  );
      
      dummy = dummy*Z_axis_step_size; 
    //  System.out.println("dummy = " + dummy  );
      First_curve_z_offset = (int)dummy; 
  //  System.out.println("First_curve_z_offset is " + First_curve_z_offset  );
  //  System.out.println("Z_axis_step_size is " + Z_axis_step_size  );
  //  System.out.println("plot_even_odd_mode " + Plot_even_odd_mode  );
      }     
    }     

  public boolean plot_is_even (  )
    {
    return ( Plot_even_odd_mode == Plot_mode_even);
    }

  public double get_y_value_from_object (Object o)
    {
    // accepts a object (from data point vector) -
    // returns y value therein.
    String dummy_string, first_float_string, second_float_string;
    int space_idx;
    double rtn;

    if (o instanceof String)
      {
      dummy_string =  (String) o;      
      
      // Now get the index of the first space char
      space_idx  = dummy_string.indexOf(' ');    
      
      // Extract first string from buffer.
      first_float_string = dummy_string.substring(0,space_idx);

      // Extract second string from buffer.
      second_float_string = dummy_string.substring(space_idx+1);  
      
      // Cast string into double
      rtn = Double.valueOf(second_float_string).doubleValue();      
      return rtn;
      }
    
    Error = -1;  // indicate problem
    return 0.0; // default rtn value. 
    } 

  public double get_x_value_from_object (Object o)
    {
    // accepts a object (from data point vector) -
    // returns x value therein.
    String dummy_string, first_float_string, second_float_string;
    int space_idx;
    double rtn;

    if (o instanceof String)
      {
      dummy_string =  (String) o;      
      
      // Now get the index of the first space char
      space_idx  = dummy_string.indexOf(' ');    
      
      // Extract first string from buffer.
      first_float_string = dummy_string.substring(0,space_idx);

      // Extract second string from buffer.
      // second_float_string = dummy_string.substring(space_idx+1);  
      
      // Cast string into double
      rtn = Double.valueOf(first_float_string).doubleValue();      
      return rtn;
      }
    
    Error = -1;  // indicate problem
    return 0.0; // default rtn value. 
    } 

  public int get_lowest_data_point_vector_index (Vector v)
    {
    // Gets the index of the vector element which has the lowest x-value
    int rtn,idx, lowest_int, dummy_int,v_size;
    Object lowest, dummy;
    double lowest_double, dummy_double;
   
    lowest = v.firstElement(); 
    v_size = v.size();
    lowest_double = get_x_value_from_object(lowest) ; 
    idx = 0;
    rtn = idx;
 
    Enumeration e = v.elements();
    
    while (e.hasMoreElements ())
      {
      dummy = e.nextElement ();
      dummy_double = get_x_value_from_object(dummy) ; 
      
      if (Error == -1)
        {
        // There was a problem with finding the last double value.
        // must handle it here

        }
      else
        {
        if ( dummy_double < lowest_double)
          {
          lowest_double = dummy_double;
          rtn = idx;
          } 
        }
      idx++;
      } 
    return rtn;
    } 

  public Vector get_ordered_data_point_vector (Stack s)
    {
    // Recieves a stack of unordered data points - returns a Vector
    // of ordered points, starting from lowest x-value.
    Vector rtn = new Vector();
    Vector unordered = new Vector ();
    int idx;
    Object o;

    // First, stick all elements of stack into an unordered Vector
    while (!s.empty())
      unordered.addElement(s.pop());
      
    while ((unordered.size() > 0) && 
           (Error != -1))  // while there's elements left
      {
      idx = get_lowest_data_point_vector_index(unordered); 
      o = unordered.elementAt (idx);
      rtn.addElement(o);
      unordered.removeElement(o);
      } 
     idx = 0;
     Enumeration e = rtn.elements();
     //while (e.hasMoreElements())
     // {
      // System.out.println("Element " + idx + " is " + e.nextElement() );
     // ++idx; 
     // }
    return rtn;
    }

  public Vector create_stack ()
    {
    Stack s = new Stack ();
    Stack s1 = new Stack ();
    Stack s11 = new Stack ();
    Vector master_v,v1,v2,v3,v4;

    master_v = new Vector();

    s.push ( "1.0 34.5");
    s.push ( "2.0 35.5");
    s.push ( "3.0 36.5");
    s.push ( "4.0 37.5");
    s.push ( "5.0 38.5");
    s.push ( "6.0 39.5");
    s.push ( "7.0 40.5");
    s.push ( "8.0 41.5");
    s.push ( "9.0 41.3");
    s.push ( "10.0 41.2");
    s.push ( "11.0 41.1");
    s.push ( "12.0 41.0");
    s.push ( "13.0 40.9");
    s.push ( "14.0 40.85");
    s.push ( "15.0 40.83");
    s.push ( "16.0 40.7");
    s.push ( "17.0 40.67");
    s.push ( "18.0 40.60");
    s.push ( "19.0 40.55");
    s.push ( "20.0 40.32");
    s.push ( "21.0 39.4");
    s.push ( "22.0 39.3");
    s.push ( "23.0 39.3");
    s.push ( "24.0 38.7");
    s.push ( "25.0 35.6");
    s.push ( "26.0 33.1");
    s.push ( "27.0 30.0");
    s.push ( "28.0 27.6");
    s.push ( "29.0 25.5");
    
    s.push ( "30.0  25.3 ");
    s.push ( "31.0  25.1"  );
    s.push ( "32.0  25.05 ");
    s.push ( "33.0  24.96");
    s.push ( "34.0  24.90");
    s.push ( "35.0  24.8");
    s.push ( "36.0  24.5");
    s.push ( "37.0  24.1");
    s.push ( "38.0  24.0");
    s.push ( "39.0  23.5");
    s.push ( "40.0  23.3");
    s.push ( "41.0  23.1");
    s.push ( "42.0  22.6");
    s.push ( "43.0  22.5");
    s.push ( "44.0  22.45");
    s.push ( "45.0  22.9");
    s.push ( "46.0  22.98");
    s.push ( "47.0  22.94");
    s.push ( "48.0  22.9");
    s.push ( "49.0  22.8");
    s.push ( "50.0  22.78");
    s.push ( "51.0  22.7");
    s.push ( "52.0  22.56");
    s.push ( "53.0  22.45");
    s.push ( "55.0  22.32");
    s.push ( "56.0  22.1");
    s.push ( "57.0  21.9");
    s.push ( "58.0  21.89");
    s.push ( "59.0  21.7");
    s.push ( "60.0  21.6");
    s.push ( "61.0  21.6");
    s.push ( "62.0  21.8");
    s.push ( "63.0  21.4");
    s.push ( "64.0  21.3");
    s.push ( "65.0  21.3");
    s.push ( "66.0  21.4");
    s.push ( "67.0  21.3");
    s.push ( "68.0  21.54");
    s.push ( "69.0  21.43");
    s.push ( "70.0  21.4");
    s.push ( "71.0  21.4");
    s.push ( "72.0  21.1");
    s.push ( "73.0  20.1");
    s.push ( "74.0  22.3");
    s.push ( "75.0  22.1");
    s.push ( "76.0  22.4");
    s.push ( "77.0  22.3");
    s.push ( "78.0  22.1");
    s.push ( "79.0  22.1");
    s.push ( "80.0  22.3");
    s.push ( "81.0  22.4");
    s.push ( "82.0  22.1");
    s.push ( "83.0  22.2");
    s.push ( "84.0  22.5");
    s.push ( "85.0  22.5");
    s.push ( "86.0  22.7");
    s.push ( "87.0  22.78");
    s.push ( "88.0  22.79");
    s.push ( "89.0  22.80");
    s.push ( "90.0  22.90");
    s.push ( "91.0  22.90");
    s.push ( "92.0  22.91");
    s.push ( "93.0  22.03");
    s.push ( "94.0  22.12");
    s.push ( "95.0  22.76");
    s.push ( "96.0  22.12");
    s.push ( "97.0  22.2");
    s.push ( "98.0  22.4");
    s.push ( "99.0  22.4");
    s.push ( "100.0 22.43");
    s.push ( "101.0 22.3");
    s.push ( "102.0  22.0");
    s.push ( "103.0  22.0");
    s.push ( "104.0  21.0");
    s.push ( "105.0  20.0");
    s.push ( "106.0  10.0");
    
    s1.push ( "1.0 34.5");
    s1.push ( "2.0 35.5");
    s1.push ( "3.0 36.5");
    s1.push ( "4.0 37.5");
    s1.push ( "5.0 38.5");
    s1.push ( "6.0 39.5");
    s1.push ( "7.0 40.5");
    s1.push ( "8.0 41.5");
    s1.push ( "9.0 41.3");
    s1.push ( "10.0 41.2");
    s1.push ( "11.0 41.1");
    s1.push ( "12.0 41.0");
    s1.push ( "13.0 40.9");
    s1.push ( "14.0 40.85");
    s1.push ( "15.0 40.83");
    s1.push ( "16.0 40.7");
    s1.push ( "17.0 40.67");
    s1.push ( "18.0 40.60");
    s1.push ( "19.0 40.55");
    s1.push ( "20.0 40.32");
    s1.push ( "21.0 39.4");
    s1.push ( "22.0 39.3");
    s1.push ( "23.0 39.3");
    s1.push ( "24.0 38.7");
    s1.push ( "25.0 35.6");
    s1.push ( "26.0 33.1");
    s1.push ( "27.0 30.0");
    s1.push ( "28.0 27.6");
    s1.push ( "29.0 25.5");
    s1.push ( "30.0  25.3 ");
    s1.push ( "31.0  25.1"  );
    s1.push ( "32.0  25.05 ");
    s1.push ( "33.0  24.96");
    s1.push ( "34.0  24.90");
    s1.push ( "35.0  24.8");
    s1.push ( "36.0  24.5");
    s1.push ( "37.0  24.1");
    s1.push ( "38.0  24.0");
    s1.push ( "39.0  23.5");
    s1.push ( "40.0  23.3");
    s1.push ( "41.0  23.1");
    s1.push ( "42.0  22.6");
    s1.push ( "43.0  22.5");
    s1.push ( "44.0  22.45");
    s1.push ( "45.0  22.9");
    s1.push ( "46.0  22.98");
    s1.push ( "47.0  22.94");
    s1.push ( "48.0  22.9");
    s1.push ( "49.0  22.8");
    s1.push ( "50.0  22.78");
    s1.push ( "51.0  22.7");
    s1.push ( "52.0  22.56");
    s1.push ( "53.0  22.45");
    s1.push ( "55.0  22.32");
    s1.push ( "56.0  22.1");
    s1.push ( "57.0  21.9");
    s1.push ( "58.0  21.89");
    s1.push ( "59.0  21.7");
    s1.push ( "60.0  21.6");
    s1.push ( "61.0  21.6");
    s1.push ( "62.0  21.8");
    s1.push ( "63.0  21.4");
    s1.push ( "64.0  21.3");
    s1.push ( "65.0  21.3");
    s1.push ( "66.0  21.4");
    s1.push ( "67.0  21.3");
    s1.push ( "68.0  21.54");
    s1.push ( "69.0  21.43");
    s1.push ( "70.0  21.4");
    s1.push ( "71.0  21.4");
    s1.push ( "72.0  21.1");
    s1.push ( "73.0  20.1");
    s1.push ( "74.0  22.3");
    s1.push ( "75.0  22.1");
    s1.push ( "76.0  22.4");
    s1.push ( "77.0  22.3");
    s1.push ( "78.0  22.1");
    s1.push ( "79.0  22.1");
    s1.push ( "80.0  22.3");
    s1.push ( "81.0  22.4");
    s1.push ( "82.0  22.1");
    s1.push ( "83.0  22.2");
    s1.push ( "84.0  22.5");
    s1.push ( "85.0  22.5");
    s1.push ( "86.0  22.7");
    s1.push ( "87.0  22.78");
    s1.push ( "88.0  22.79");
    s1.push ( "89.0  22.80");
    s1.push ( "90.0  22.90");
    s1.push ( "91.0  22.90");
    s1.push ( "92.0  22.91");
    s1.push ( "93.0  22.03");
    s1.push ( "94.0  22.12");
    s1.push ( "95.0  22.76");
    s1.push ( "96.0  22.12");
    s1.push ( "97.0  22.2");
    s1.push ( "98.0  22.4");
    s1.push ( "99.0  22.4");
    s1.push ( "100.0 22.43");
    s1.push ( "101.0 22.3");
    s1.push ( "102.0  22.0");
    s1.push ( "103.0  22.0");
    s1.push ( "104.0  21.0");
    s1.push ( "105.0  20.0");
    s1.push ( "106.0  10.0");

    s11.push ( "1.0 34.5");
    s11.push ( "2.0 35.5");
    s11.push ( "3.0 36.5");
    s11.push ( "4.0 37.5");
    s11.push ( "5.0 38.5");
    s11.push ( "6.0 39.5");
    s11.push ( "7.0 40.5");
    s11.push ( "8.0 41.5");
    s11.push ( "9.0 41.3");
    s11.push ( "10.0 41.2");
    s11.push ( "11.0 41.1");
    s11.push ( "12.0 41.0");
    s11.push ( "13.0 40.9");
    s11.push ( "14.0 40.85");
    s11.push ( "15.0 40.83");
    s11.push ( "16.0 40.7");
    s11.push ( "17.0 40.67");
    s11.push ( "18.0 40.60");
    s11.push ( "19.0 40.55");
    s11.push ( "20.0 40.32");
    s11.push ( "21.0 39.4");
    s11.push ( "22.0 39.3");
    s11.push ( "23.0 39.3");
    s11.push ( "24.0 38.7");
    s11.push ( "25.0 35.6");
    s11.push ( "26.0 33.1");
    s11.push ( "27.0 30.0");
    s11.push ( "28.0 27.6");
    s11.push ( "29.0 25.5");
    s11.push ( "30.0  25.3 ");
    s11.push ( "31.0  25.1"  );
    s11.push ( "32.0  25.05 ");
    s11.push ( "33.0  24.96");
    s11.push ( "34.0  24.90");
    s11.push ( "35.0  24.8");
    s11.push ( "36.0  24.5");
    s11.push ( "37.0  24.1");
    s11.push ( "38.0  24.0");
    s11.push ( "39.0  23.5");
    s11.push ( "40.0  23.3");
    s11.push ( "41.0  23.1");
    s11.push ( "42.0  22.6");
    s11.push ( "43.0  22.5");
    s11.push ( "44.0  22.45");
    s11.push ( "45.0  22.9");
    s11.push ( "46.0  22.98");
    s11.push ( "47.0  22.94");
    s11.push ( "48.0  22.9");
    s11.push ( "49.0  22.8");
    s11.push ( "50.0  22.78");
    s11.push ( "51.0  22.7");
    s11.push ( "52.0  22.56");
    s11.push ( "53.0  22.45");
    s11.push ( "55.0  22.32");
    s11.push ( "56.0  22.1");
    s11.push ( "57.0  21.9");
    s11.push ( "58.0  21.89");
    s11.push ( "59.0  21.7");
    s11.push ( "60.0  21.6");
    s11.push ( "61.0  21.6");
    s11.push ( "62.0  21.8");
    s11.push ( "63.0  21.4");
    s11.push ( "64.0  21.3");
    s11.push ( "65.0  21.3");
    s11.push ( "66.0  21.4");
    s11.push ( "67.0  21.3");
    s11.push ( "68.0  21.54");
    s11.push ( "69.0  21.43");
    s11.push ( "70.0  21.4");
    s11.push ( "71.0  21.4");
    s11.push ( "72.0  21.1");
    s11.push ( "73.0  20.1");
    s11.push ( "74.0  22.3");
    s11.push ( "75.0  22.1");
    s11.push ( "76.0  22.4");
    s11.push ( "77.0  22.3");
    s11.push ( "78.0  22.1");
    s11.push ( "79.0  22.1");
    s11.push ( "80.0  22.3");
    s11.push ( "81.0  22.4");
    s11.push ( "82.0  22.1");
    s11.push ( "83.0  22.2");
    s11.push ( "84.0  22.5");
    s11.push ( "85.0  22.5");
    s11.push ( "86.0  22.7");
    s11.push ( "87.0  22.78");
    s11.push ( "88.0  22.79");
    s11.push ( "89.0  22.80");
    s11.push ( "90.0  22.90");
    s11.push ( "91.0  22.90");
    s11.push ( "92.0  22.91");
    s11.push ( "93.0  22.03");
    s11.push ( "94.0  22.12");
    s11.push ( "95.0  22.76");
    s11.push ( "96.0  22.12");
    s11.push ( "97.0  22.2");
    s11.push ( "98.0  22.4");
    s11.push ( "99.0  22.4");
    s11.push ( "100.0 22.43");
    s11.push ( "101.0 22.3");
    s11.push ( "102.0  22.0");
    s11.push ( "103.0  22.0");
    s11.push ( "104.0  21.0");
    s11.push ( "105.0  20.0");
    s11.push ( "106.0  10.0");
    v1 = get_ordered_data_point_vector(s);
    v2 = get_ordered_data_point_vector(s1);
    v3 = get_ordered_data_point_vector(s11);
    master_v.add(v1); 
    master_v.add(v2); 
    master_v.add(v3); 
    return (master_v); 
    }

  public void set_colour (Graphics g, int idx)
    {
    // Set colour for graphics context - default is black 

    if (idx == BSLPlot_colour_red_idx)
      g.setColor(new Color(255,0,0));
    else if (idx == BSLPlot_colour_green_idx)
      g.setColor(new Color(0,255,0));
    else if (idx == BSLPlot_colour_blue_idx)
      g.setColor(new Color(0,0,255));
    else if (idx == BSLPlot_colour_white_idx)
      g.setColor(new Color(255,255,255));
    else 
      g.setColor(new Color(0,0,0));  //  Default colour. 
    }

  public void set_data_point_char (int idx)
    {
    // This function sets the global data point character, given 
    // a passed-in index, "idx" 

    if (idx == Data_point_char_plus_idx)
      Data_point_char = Data_point_char_plus;
    else if (idx == Data_point_char_dot_idx)
      Data_point_char = Data_point_char_dot;     
    else if (idx == Data_point_char_cross_idx)
      Data_point_char = Data_point_char_cross;     
    else if (idx == Data_point_char_minus_idx)
      Data_point_char = Data_point_char_minus;     
    else if (idx == Data_point_char_star_idx)
      Data_point_char = Data_point_char_star;     
    }

  public void draw_bounding_box (Graphics g)
    {
    g.drawLine(X_start, Y_start, X_start + Max_x, Y_start);
    g.drawLine(X_start, Y_start, X_start , Y_start + Max_y);
    g.drawLine(X_start + Max_x, Y_start, X_start + Max_x, Y_start + Max_y);
    g.drawLine(X_start, Y_start + Max_y, X_start + Max_x, Y_start + Max_y);
    }

  public void draw_x_axis (Graphics g, int x)
    {
    // This draws the x axis for plot   
    int j;
    g.drawLine(X_start,x,X_start + Max_x,x);
    
    for (j=0; j<20; ++j)
      {
      // Drawing tic line 
      g.drawLine(X_start + j*22,x,X_start + j*22 , x + 4);
      }
    } 

  public void draw_y_axis (Graphics g, int x)
    {
    // This draws the x axis for plot   
    int j;
    g.drawLine(x,Y_start,x,Y_start + Max_y);
    for (j=0; j<20; ++j)
      {
      // Drawing tic line 
      g.drawLine(x - 4,Y_start + j*22,x ,Y_start + j*22);
      }
    } 
 
  public int get_idx_shift (int idx)
    {
    return ( (int)(First_curve_z_offset - 
                         idx*Z_axis_step_size  )  );
    }

  public int get_plot_x_from_x (double x, int curve_idx)
    {
    int idx_shift = get_idx_shift(curve_idx);
 //   System.out.println( "idx=" + curve_idx + ", idx_shift=" +
  //     idx_shift );
    
    return ( (int)(0.2*(Max_x - X_start)) + 
             (int)(0.6*((Max_x - 2*X_start)*((x - Min_data_x)/
             (Max_data_x - Min_data_x)))) -  
             idx_shift);  
    }

  public int get_plot_y_from_y (double y, int curve_idx)
    {
    return ( (int)(0.2*(Max_y - Y_start)) + 
            (int)(0.6*(Max_y - ((Max_y - 2*Y_start) *(y - Min_data_y)
              /(Max_data_y - Min_data_y)))) + 
             get_idx_shift(curve_idx));  
    }
 
  public int check_if_point_can_be_plotted (Vector plot_vector, 
                                            int curve_idx,
                                            int plot_x,
                                            int plot_y)
    {
    Enumeration e = plot_vector.elements(), curve_enum;
    Object dummy, dummy_object2;
    int rtn = 0, this_idx = 0;
    Vector dummy_vector;
    int prev_x = 0, prev_y = 0;
    int this_x, this_y;
    int prev_x_y_set = 0;
    double x,y;
 
    while (e.hasMoreElements ())
      {
      dummy = e.nextElement ();
      if (dummy instanceof Vector)
        {
        dummy_vector =  (Vector) dummy;      
        if (this_idx == curve_idx)
          return 1;
        
        // This curve *is* lower than our curve - must check each data point
        curve_enum = dummy_vector.elements();
       
        while (curve_enum.hasMoreElements ())
          {
          dummy_object2 = curve_enum.nextElement();
          x = get_x_value_from_object(dummy_object2);
          y = get_y_value_from_object(dummy_object2);
          this_x = get_plot_x_from_x(x, this_idx); 
          this_y = get_plot_y_from_y(y, this_idx); 
       
          if (prev_x_y_set == 0)  
            prev_x_y_set = 1;
          else
            {
            if ((plot_x >= prev_x) &&
                (plot_x <= this_x) ) 
                 
              {
              if (!is_point_plottable(prev_x,
                                     prev_y,
                                     this_x,
                                     this_y,
                                     plot_x,
                                     plot_y))  
                {

              //  System.out.println("prev_x=" + prev_x +
              //                     ",prev_y=" + prev_y +
               //                    ",this_x=" + this_x +
                //                   ",this_y=" + this_y +
                 //                  ",plot_x=" + plot_x +
                  //                 ",plot_y=" + plot_y );  

                return 0;
                } 
              } 
            }
          prev_x = this_x; 
          prev_y = this_y; 
          }
        }
      ++this_idx;
      }
    return 1;  // Yes, we *can* plot this point.  
    }  

  public void draw_data_point (Graphics g, double x, double y, int curve_idx,
                                Vector plot_vector) 
    {
    // Draws data point denoted by coords x,y  
    // Must convert doubles x,y into plottable integers - have to refer
    // to Max and Mins of x,y : curve_idx is the index into the plot_vector
    // of this curve - first curve in plot_vector is curve_idx == 0. 
    int plot_x, plot_y;

    // Now we must correct x,y coords for its position with regard to 
    // z offset
    plot_x = get_plot_x_from_x(x, curve_idx); 
    plot_y = get_plot_y_from_y(y, curve_idx); 
   
     if ((0 == curve_idx ) || 
         (1 == 
          check_if_point_can_be_plotted(plot_vector,curve_idx,plot_x,plot_y))) 
      {
   //   System.out.println( "Will plot -> plotx=" + plot_x + ", plot-y=" 
    //    + plot_y + ", and idx=" + curve_idx);
      g.drawString(Data_point_char,plot_x,plot_y);
      }
    }

  public void set_axis_colour (Graphics g)
    {
    // Sets axis colour  
    set_colour(g,BSLPlot_colour_blue_idx);
    }

  public void set_bounding_box_colour (Graphics g)
    {
    // Sets axis colour  
    set_colour(g,BSLPlot_colour_black_idx);
    } 
 
  public void set_data_point_colour (Graphics g)
    {
    // Sets data point colour  
    set_colour(g,BSLPlot_colour_red_idx);
    }
 
  public void set_data_point_colour_red (Graphics g)
    {
    // Sets data point colour  
    set_colour(g,BSLPlot_colour_red_idx);
    }
  
  public void set_data_point_colour_blue (Graphics g)
    {
    // Sets data point colour  
    set_colour(g,BSLPlot_colour_blue_idx);
    }
  
  public void set_data_point_colour_green (Graphics g)
    {
    // Sets data point colour  
    set_colour(g,BSLPlot_colour_green_idx);
    }
  
  public void plot_stack (Graphics g, Stack s)
    {
    System.out.println( s.pop());
    } 
 
  public bslp()
    {
    // Entry point to class. 
    super(Prog_name);
    setSize(Max_x + 2*X_start,Max_y + 2*Y_start + Lower_panel_gap);
    setLocation(100,100);
    show();
    }

  public void paint (Graphics g)
    {
    // Fill in what to do here when the window needs a repaint. 
    Stack s = new Stack();
    Vector v; 
    s.push("banana"); 
    plot_stack(g,s); 
    set_axis_colour(g);  
    set_bounding_box_colour(g);  
    set_data_point_char (Data_point_char_cross_idx);  
    // draw_x_axis(g,150);
    // draw_y_axis(g,150); 
    set_data_point_colour_blue(g);
    // draw_data_point(g, 356,123);
    draw_bounding_box(g);
    v = create_stack(); 
    plot_curves(g, v); 
    }

  public static void main (String args[])
    {
    // Create a new bslp object and allocate a WindowListener 
    // dummy d = new dummy();
    // d.print_banana(); 

    bslp app = new bslp();
    WindowAdapter wa = 
           new WindowAdapter() 
             {
             // Overide windowClosing method.
             public void windowClosing (WindowEvent e)
               {
               System.exit(0);
               }
             }; 
    app.addWindowListener(wa); 
    }
  }









// Import essential modules
import java.awt.*;
import javax.swing.*;
import java.util.Stack;
import java.awt.event.*;
import java.util.*;
import java.io.*;
import java.lang.Boolean;

public class bslp_panel extends JPanel 
  {
  int Error = 0; // default state 

  // These ints are for joining up points on plot - 
  // need to store info on previous point to make joining line
  private int prev_was_drawn = -1;
  private int prev_curve_idx = -1;
  private int prev_curve_x;
  private int prev_curve_y;

  // These will hold the extrema values for the data sets.
  double Max_data_x;
  double Max_data_y;
  double Min_data_x;
  double Min_data_y;
  int Min_max_data_set = 0;

  // Z axis offset plottable for the first (smallest min x) curve
  int First_curve_z_offset;
  
  // Max length of z axis
  static int Max_z_axis_len = 200;

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
  static int Default_data_point_char_idx  = Data_point_char_dot_idx; 

  String Data_point_char ;

  int Data_point_char_set = 0;

  static int BSLPlot_colour_red_idx    = 0;
  static int BSLPlot_colour_green_idx  = 1;
  static int BSLPlot_colour_blue_idx   = 2;
  static int BSLPlot_colour_black_idx  = 3;
  static int BSLPlot_colour_white_idx  = 4;

  static int Default_data_point_primary_colour_idx   = BSLPlot_colour_blue_idx;
  static int Default_data_point_secondary_colour_idx = BSLPlot_colour_green_idx;

  int Data_point_primary_colour;
  int Data_point_secondary_colour;

  int Data_point_primary_colour_set = 0;
  int Data_point_secondary_colour_set = 0;

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
    set_data_point_colour_to_primary(g); 
    
    while (plot_vector_enum.hasMoreElements())
      {
      dummy_object = plot_vector_enum.nextElement ();
          
      if (dummy_object instanceof Vector)
        {
        // dummy object IS a vector
        dummy_curve = (Vector) dummy_object; 
        curve_enum = dummy_curve.elements();
        // System.out.println
        //("dummy_curve has " + dummy_curve.size() + " elements." ); 
       
        while (curve_enum.hasMoreElements ())
          {
         // dummy_object2 = curve_enum.nextElement();
          XYDataPoint xydp = (XYDataPoint) curve_enum.nextElement ();
	  x = xydp.x;
	  y = xydp.y;
//	 x = get_x_value_from_object(dummy_object2);
 //         y = get_y_value_from_object(dummy_object2);
        
          this_idx = get_curve_idx(plot_vector,dummy_curve);
          draw_data_point(g,x,y,this_idx,plot_vector);
          //System.out.println("Drawing point x=" + x + ", y=" + y + "idx=" +
	  // this_idx);
          }
        }
      ++i; 
      set_data_point_colour_to_secondary(g); 
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
               (int)(Max_z_axis_len/Default_z_axis_step_size)) 
      // We cannot use the default z-axis step-size... 
      // - have to evaluate the new step size
      {
      Z_axis_step_size = (int) (Max_z_axis_len/Num_curves_to_plot);
      if (Z_axis_step_size == 0)
        {
	    System.out.println
         ("Too many curves to plot - procedure cannot cope.");  
	    System.exit(0);
	    }
      }
    else
      // Ok - we don't have too many curves... we can use our default
      // z-axis step size. 
      Z_axis_step_size = Default_z_axis_step_size;
 
    System.out.println
    ("Z_axis..=" + Z_axis_step_size + ", Num_curves=" + Num_curves_to_plot);
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

    //if (o instanceof String)
    if (false)
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
    else
      {
      XYDataPoint xydp = (XYDataPoint)o;
      return xydp.y;
      }
    
    // Error = -1; 
    // return 0.0; 
    } 

  public double get_x_value_from_object (Object o)
    {
    // accepts a object (from data point vector) -
    // returns x value therein.
    String dummy_string, first_float_string, second_float_string;
    int space_idx;
    double rtn;

    // if (o instanceof String)
    if (false)
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
    XYDataPoint xydp = (XYDataPoint)o;
    return xydp.x;
    // Error = -1;  
    //return 0.0;  
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
    GetXYVectorOfVectors gvv = new GetXYVectorOfVectors("datafile");
    Vector master_v = gvv.getVector();
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

  public void set_data_point_primary_colour (Graphics g)
    {
    set_colour(g, Data_point_primary_colour);
    }

  public void set_data_point_secondary_colour (Graphics g)
    {
    set_colour(g, Data_point_secondary_colour);
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
    set_background_colour(g); 
    g.fillRect(X_start, Y_start, Max_x, Max_y);
    set_bounding_box_colour(g); 
    g.drawRect(X_start, Y_start, Max_x, Max_y);
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

    int x_offset = 17;
    int y_offset = 15;
    // Now we must correct x,y coords for its position with regard to 
    // z offset
    plot_x = get_plot_x_from_x(x, curve_idx) ; 
    plot_y = get_plot_y_from_y(y, curve_idx) ; 
   
     if ((0 == curve_idx ) || 
         (1 == 
          check_if_point_can_be_plotted(plot_vector,curve_idx,plot_x,plot_y))) 
      {
   //   System.out.println( "Will plot -> plotx=" + plot_x + ", plot-y=" 
    //    + plot_y + ", and idx=" + curve_idx);
      
      g.drawString(Data_point_char,
                   plot_x + x_offset,
                   plot_y + y_offset);
      if ((prev_curve_idx == curve_idx) && (prev_was_drawn == 1) ) 
	    g.drawLine(prev_curve_x + x_offset, 
                   prev_curve_y + y_offset, 
                   plot_x + x_offset, 
                   plot_y + y_offset);
      prev_was_drawn = 1; 
      }
    else
      prev_was_drawn = 0; 
    prev_curve_idx = curve_idx;
    prev_curve_x = plot_x;
    prev_curve_y = plot_y;
    }

  public void set_axis_colour (Graphics g)
    {
    // Sets axis colour  
    set_colour(g,BSLPlot_colour_blue_idx);
    }

  public void set_background_colour (Graphics g)
    {
    set_colour(g,BSLPlot_colour_white_idx);
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

  public void set_data_point_colour_to_primary (Graphics g)
    {
    set_colour(g,Data_point_primary_colour);
    }

  public void set_data_point_colour_to_secondary (Graphics g)
    {
    set_colour(g,Data_point_secondary_colour);
    }

  public void set_data_point_primary_colour (int idx)
    {
    Data_point_primary_colour = idx  ;
    }

  public void set_data_point_secondary_colour (int idx)
    {
    Data_point_secondary_colour  = idx  ;
    }
  
  public void set_data_point_secondary_colour_red ()
    {
    set_data_point_secondary_colour(BSLPlot_colour_red_idx);
    }
  
  public void set_data_point_secondary_colour_green ()
    {
    set_data_point_secondary_colour(BSLPlot_colour_green_idx);
    }
 
  public void set_data_point_secondary_colour_blue ()
    {
    set_data_point_secondary_colour(BSLPlot_colour_blue_idx);
    }

  public void set_data_point_secondary_colour_black ()
    {
    set_data_point_secondary_colour(BSLPlot_colour_black_idx);
    }

  public void set_data_point_primary_colour_red ()
    {
    set_data_point_primary_colour(BSLPlot_colour_red_idx);
    }
  
  public void set_data_point_primary_colour_green ()
    {
    set_data_point_primary_colour(BSLPlot_colour_green_idx);
    }
 
  public void set_data_point_primary_colour_blue ()
    {
    set_data_point_primary_colour(BSLPlot_colour_blue_idx);
    }

  public void set_data_point_primary_colour_black ()
    {
    set_data_point_primary_colour(BSLPlot_colour_black_idx);
    }

  public void set_data_point_colour_red (Graphics g)
    {
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
 
//  public bslp()
 //   {
    // Entry point to class. 
  //  super(Prog_name);
   // setSize(Max_x + 2*X_start,Max_y + 2*Y_start + Lower_panel_gap);
   // setLocation(100,100);
   // show();
   // }

  public void set_default_data_point_primary_colour ()
    {
    if (Data_point_primary_colour_set == 0)
      {
      Data_point_primary_colour_set = 1;
      set_data_point_primary_colour (Default_data_point_primary_colour_idx);  
      }
    }

  public void set_default_data_point_secondary_colour ()
    {
    if (Data_point_secondary_colour_set == 0)
      {
      Data_point_secondary_colour_set = 1;
      set_data_point_secondary_colour 
           (Default_data_point_secondary_colour_idx);  
      }
    }

  public void set_default_data_point_char ()
    {
    // Although this will be called for every repaint, we only
    // ever need to do anything once - the first time it is called - 
    // just so default data point char is set. 

    if (Data_point_char_set == 0)
      {
      Data_point_char_set = 1;
      set_data_point_char (Default_data_point_char_idx);  
      }
    }

  public void set_data_point_cross ()
    {
    set_data_point_char (Data_point_char_cross_idx);  
    }

  public void set_data_point_plus ()
    {
    set_data_point_char (Data_point_char_plus_idx);  
    }
  
  public void set_data_point_dot ()
    {
    set_data_point_char (Data_point_char_dot_idx);  
    }
 
  public void set_data_point_minus ()
    {
    set_data_point_char (Data_point_char_minus_idx);  
    }

  public void set_data_point_star ()
    {
    set_data_point_char (Data_point_char_star_idx);  
    }
  
  public void paintComponent (Graphics g)
    {
    super.paintComponent(g); 
    // Fill in what to do here when the window needs a repaint. 
    // Stack s = new Stack();
    Vector v; 
    //s.push("banana"); 
    //plot_stack(g,s); 
    //set_axis_colour(g);  
    set_default_data_point_char ();  
    set_default_data_point_primary_colour ();  
    set_default_data_point_secondary_colour ();  
    // draw_x_axis(g,150);
    // draw_y_axis(g,150); 
    draw_bounding_box(g);
    v = create_stack(); 
    plot_curves(g, v); 
    }

  public Dimension getPreferredSize()
    {
    return new Dimension (500,500);
    }

  public Dimension getMinimumSize()
    {
    return getPreferredSize();
    }

  public void redraw_plot ()
    {
    repaint();
    }

  //public static void main (String args[])
//    {

    // Create a new bslp object and allocate a WindowListener 
    // dummy d = new dummy();
    // d.print_banana(); 

  //  bslp app = new bslp();
   // WindowAdapter wa = 
    //       new WindowAdapter() 
     //        {
             // Overide windowClosing method.
      //       public void windowClosing (WindowEvent e)
       //        {
        //       System.exit(0);
         //      }
          //   }; 
   // app.addWindowListener(wa); 
  //  }
  }









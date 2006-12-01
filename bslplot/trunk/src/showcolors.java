
// Import essential modules
import java.awt.*;
import javax.swing.*;
import java.util.Stack;
import java.awt.event.*;
import java.util.*;
import java.io.*;
import java.lang.Boolean;

public class ShowColors extends JFrame
  {
  int Error = 0; // default state 

  // These will hold the extrema values for the data sets.
  int Max_data_x;
  int Max_data_y;
  int Min_data_x;
  int Min_data_y;

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


  public boolean is_point_plottable (double prev_x1,
                                     double prev_y1,
                                     double prev_x2,
                                     double prev_y2,
                                     double this_x,
                                     double this_y)
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
    prev_gradient = (prev_y2 - prev_y1)/(prev_x2 - prev_x1);

    // Now find the intercept of the line defined by the two previous
    // points.
    prev_intercept = prev_y1 - prev_gradient*prev_x1; 

    // Ok - we now have the equation of the line defined by the two
    // previous points.

    return (this_y > (prev_gradient*this_x + prev_intercept));  
    }

  public int get_curve_index (Vector plot_vector, Vector curve)
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
    int prev_idx, this_idx;
    Enumeration plot_vector_enum, curve_enum;
    Object dummy_object,dummy_object2;
    String dummy_string;
    double x,y;
 
    plot_vector_enum = plot_vector.elements();
    dummy_object = plot_vector_enum.nextElement ();
    
    // Now plot primary curve
    if (dummy_object instanceof Vector)
      {
      // dummy object IS a vector
      dummy_curve = (Vector) dummy_object; 
      curve_enum = dummy_curve.elements();
       
      while (curve_enum.hasMoreElements ())
        {
        dummy_object2 = curve_enum.nextElement();

        // get x, y values here...
        draw_data_point(g,x,y);
        }
      }
    else
      {
      //Error plotting primary curve
      Error = -1;
      return ;
      }

         
    while (e.hasMoreElements ())
      {
      dummy = e.nextElement ();
    
  public void check_for_min_max_x_y (Vector plot_curve)
    {
    // Accepts a curve 

  public void set_min_max_x_y (Vector plot_vector)
    { 
    // This proc goes through every data point in every curve and
    // sets the min, max for x,y - which are global to the set of
    // curves - this is neccessary for getting plot dimensions.

    Vector dummy_curve;
    int prev_idx, this_idx;
    Enumeration plot_vector_enum, curve_enum;
    Object dummy_object,dummy_object2;
    String dummy_string;
    double x,y;

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
 

 

// Now plot primary curve
    if (dummy_object instanceof Vector)
      {
      // dummy object IS a vector
      dummy_curve = (Vector) dummy_object; 
      curve_enum = dummy_curve.elements();
       


  public void set_z_axis_curve_offset ( Vector plot_vector )
    {
    // This func works out the z-axis separation of the curves -
    // it accepts a vector - plot_vector, which is a list of curves - 
    // these curves should already be ordered and ready to plot.
  
    // First, work out the number of curves to be plotted.
    Num_curves_to_plot =  plot_vector.size(); 

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
      First_curve_z_offset = (int)
                ((Num_curves_to_plot - 1)/2)*Z_axis_step_size; 
      }     
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
     while (e.hasMoreElements())
      {
      System.out.println("Element " + idx + " is " + e.nextElement() );
      ++idx; 
      }
    return rtn;
    }

  public void create_stack ()
    {
    Stack s = new Stack ();
    Vector v;
 
    s.push ( "1.2 34.5");
    s.push ( "8.2 34.5");
    s.push ( "3.2 34.5");
    s.push ( "0.2 34.5");

    v = get_ordered_data_point_vector(s);
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

  public void draw_data_point (Graphics g, double x, double y)
    {
    // Draws data point denoted by coords x,y  
    // Must convert doubles x,y into plottable integers - have to refer
    // to Max and Mins of x,y  
   
    g.drawString(Data_point_char,x,y);
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
 
  public void plot_stack (Graphics g, Stack s)
    {
    System.out.println( s.pop());
    } 
 
  public ShowColors()
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
    s.push("banana"); 
    plot_stack(g,s); 
    set_axis_colour(g);  
    set_bounding_box_colour(g);  
    set_data_point_char (Data_point_char_cross_idx);  
    draw_x_axis(g,150);
    draw_y_axis(g,150); 
    set_data_point_colour(g);
    draw_data_point(g, 356,123);
    draw_bounding_box(g);
    create_stack(); 
    }

  public static void main (String args[])
    {
    // Create a new ShowColors object and allocate a WindowListener 
    // dummy d = new dummy();
    // d.print_banana(); 

    ShowColors app = new ShowColors();
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

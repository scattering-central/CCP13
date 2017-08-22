// Import essential modules
import java.awt.*;
import javax.swing.*;
import java.util.Stack;
import java.awt.event.*;
import java.util.*;
import java.io.*;
import java.lang.Boolean;

public class bslp_panel_test extends JPanel 
  {
  int Error = 0; // default state 

  private Vector PlotVector;

  private int Global_x_offset = 17;
  private int Global_y_offset = 15;

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
  static int Min_x = 10;
  static int Min_y = 30;
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
    XYDataPoint prev = null;
    int prev_initialized = 0;

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
       
        while (curve_enum.hasMoreElements ())
          {
         // dummy_object2 = curve_enum.nextElement();
          XYDataPoint xydp = (XYDataPoint) curve_enum.nextElement ();

          if (0 == prev_initialized)
	    {
	    // first time 'round - must init prev to xydp
	    prev = xydp;
	    prev_initialized = 1; 
	    }

	  draw_this_point(g,xydp,prev); 
	  prev = xydp;
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
    XYDataPoint dummy_object2;
   
    while (curve_enum.hasMoreElements ())
      {
      dummy_object2 = (XYDataPoint)curve_enum.nextElement();
     // x = get_x_value_from_object(dummy_object2);
     // y = get_y_value_from_object(dummy_object2);
      x = dummy_object2.x;
      y = dummy_object2.y;
      
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
      dummy = dummy*Z_axis_step_size; 
      First_curve_z_offset = (int)dummy; 
      }     
    }     

  public boolean plot_is_even (  )
    {
    return ( Plot_even_odd_mode == Plot_mode_even);
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
    g.fillRect(Min_x, Min_y, Max_x, Max_y);
    set_bounding_box_colour(g); 
    g.drawRect(Min_x, Min_y, Max_x, Max_y);
    }

  public void draw_x_axis (Graphics g, int x)
    {
    // This draws the x axis for plot   
    int j;
    g.drawLine(Min_x,x,Min_x + Max_x,x);
    
    for (j=0; j<20; ++j)
      {
      // Drawing tic line 
      g.drawLine(Min_x + j*22,x,Min_x + j*22 , x + 4);
      }
    } 

  public void draw_y_axis (Graphics g, int x)
    {
    // This draws the x axis for plot   
    int j;
    g.drawLine(x,Min_y,x,Min_y + Max_y);
    for (j=0; j<20; ++j)
      {
      // Drawing tic line 
      g.drawLine(x - 4,Min_y + j*22,x ,Min_y + j*22);
      }
    } 
 
  private void draw_this_point (Graphics g, XYDataPoint xydp, 
                                XYDataPoint prev)
    {
    if (xydp.plottable)
      {
      if ((prev == xydp) ||  
          prev.plottable ) 
        g.drawLine( prev.plot_x + Global_x_offset,
                  prev.plot_y + Global_y_offset,
                  xydp.plot_x + Global_x_offset,
                  xydp.plot_y + Global_y_offset);  
      
      g.drawString(Data_point_char,
                 xydp.plot_x + Global_x_offset,
                 xydp.plot_y + Global_y_offset);
      }
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

  public bslp_panel_test ()
    {
    PlotVector = create_stack(); 
    // Now set the max min parameters for the plot as a whole.
    set_min_max_x_y(PlotVector);
    set_z_axis_curve_offset(PlotVector);
    
    SetPlottable sp = new SetPlottable(PlotVector,
                                       Max_data_x,
				       Max_data_y,
				       Min_data_x,
				       Min_data_y,
				       Max_x,
				       Max_y,
				       Min_x,
				       Min_y,
                                       First_curve_z_offset,
				       Z_axis_step_size);
    }

  public void paintComponent (Graphics g)
    {
    super.paintComponent(g); 
    set_default_data_point_char ();  
    set_default_data_point_primary_colour ();  
    set_default_data_point_secondary_colour ();  
    // draw_x_axis(g,150);
    // draw_y_axis(g,150); 
    draw_bounding_box(g);
    plot_curves(g, PlotVector); 
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
  }









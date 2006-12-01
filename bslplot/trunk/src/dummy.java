// Import essential modules
import java.awt.*;
import javax.swing.*;
import java.util.Stack;
import java.awt.event.*;
import java.util.*;
import java.io.*;

public class dummy 
  {
  public void get_x_value_from_object (Object o)
    {
    // accepts a object (from data point vector) -
    // returns x value therein.
      System.out.println("in function");
    String dummy_string, first_float_string, second_float_string;
    int space_idx;

    if (o instanceof String)
      {
      dummy_string =  (String) o;      
      space_idx  = dummy_string.indexOf(' ');    
      first_float_string = dummy_string.substring(0,space_idx);
      second_float_string = dummy_string.substring(space_idx+1);  
      System.out.println("first bit is " + first_float_string);
      System.out.println("second bit is " + second_float_string);
      double d1 = Double.valueOf(first_float_string).doubleValue(); 
      //double d1 = Double.valueOf(first_float_string).doubleValue(); 
      System.out.println("first double is is " + d1);
      }
    } 

  public dummy()
    {
    String s = new String("3.2 4.5"); 
    get_x_value_from_object (s);
    } 
  
  public static void main (String [] args )
    {
    dummy d = new dummy(); 
    }    
  }

import java.io.*;
import java.util.Stack;
import java.util.*;


public class tester
  {
  public static void main (String[] args)  
    {
    GetOrderedXYDataFileVector g = new GetOrderedXYDataFileVector ("data");
    Vector v = g.getVector ();

    Enumeration e = v.elements();
    while (e.hasMoreElements ())
      {
      XYDataPoint xydp ; 
      xydp = (XYDataPoint) e.nextElement ();

      System.out.println("this x=" + xydp.x + ", y=" + xydp.y); 
      }
    GetDouble gd = new GetDouble("   4.5  ");
    System.out.println("Double = " + gd.this_double);
    }
  }

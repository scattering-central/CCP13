// Import essential modules
import java.awt.*;
import javax.swing.*;
import java.util.Stack;
import java.awt.event.*;
import java.util.*;
import java.io.*;


/**  Purpose of class is to recieve a string containing two space-
 *   seperated doubles, and to split them to form individual doubles.
 *   Note: only two doubles allowed in string - and they _must_ be
 *   separated by a space.
 * 
 *   For error checking, you must observe that the ok() method
 *   return true before trying to extract your 2 doubles.
 *
 *   Also, procedure is reasonably tolerant with the format
 *   of the passed-in string - whitespaces before, between and
 *   after the doubles should not cause a problem - as long as the
 *   string _does_ consist of two space-separated doubles!! 
 *   (An integer and a double, for example, would not be parsed correctly.)
 *
 *   @author Matthew Rodman 
 *
 */
public class GetDoublePairs 
  {
  private double first_double  = 0.0; 
  private double second_double = 0.0; 
  private boolean ok = false;


  private int reset_num_if_necc (String s, int dummy, int mychar)
    {
    int dummy2 = s.indexOf(mychar);
    
    if (dummy == -1)
      return dummy2;

    if ((dummy2 < dummy) && (dummy2 != -1))  
      return dummy2;
    return dummy;
    } 

   private int get_idx_of_first_numeric_char (String s)
    {
    // method recieves a String - purpose is to return the index
    // in string of first numeric char.
    int dummy = s.indexOf('-');
    dummy = reset_num_if_necc(s,dummy,'0');
    dummy = reset_num_if_necc(s,dummy,'1');
    dummy = reset_num_if_necc(s,dummy,'2');
    dummy = reset_num_if_necc(s,dummy,'3');
    dummy = reset_num_if_necc(s,dummy,'4');
    dummy = reset_num_if_necc(s,dummy,'5');
    dummy = reset_num_if_necc(s,dummy,'6');
    dummy = reset_num_if_necc(s,dummy,'7');
    dummy = reset_num_if_necc(s,dummy,'8');
    dummy = reset_num_if_necc(s,dummy,'9');
    return dummy;
    }

  /**
   *  Returns first double in space-separated double string.
   *
   *  @return double
   */
  public double getFirstDouble ()
    {
    return first_double;
    }

  /**
   *  Returns second double in space-separated double string.
   *
   *  @return double
   */
  public double getSecondDouble ()
    {
    return second_double;
    }

  /**
   * This method is invoked prior to extracting doubles (via getFirstDouble,
   * for example) in order to make sure that the passed-in string
   * passes muster.
   */
  public boolean ok ()
    {
    return ok;
    } 
  
  private void split_string (String s)
    {
    // accepts a object (from data point vector) -
    // returns x value therein.
    String dummy_string, first_float_string, second_float_string;
    int space_idx;
    int first_num_char;

    first_num_char = get_idx_of_first_numeric_char(s);

    if (first_num_char == -1)
      {
      // return - string not suitable
      return ;
      } 

    dummy_string = s.substring(first_num_char);
    
    // Note: the indexOf method returns -1 if char cannot be found
    space_idx  = dummy_string.indexOf(' ');  
   
    if (space_idx == -1)
      {
      return ;
      }
 
    // Use space to separate doubles 
    first_float_string  = dummy_string.substring(0,space_idx);
    second_float_string = dummy_string.substring(space_idx+1);  
    
    first_double  = Double.valueOf(first_float_string).doubleValue(); 
    second_double = Double.valueOf(second_float_string).doubleValue(); 

    ok = true; 
    } 

  public GetDoublePairs(String s)
    {
    split_string (s);
    } 
  }


/**  Purpose of class is to recieve a string containing 
 *   double and to retrieve it. 
 *
 */
public class GetDouble
  {
  public double this_double  = 0.0; 

  private void parse_double (String s)
    {
    String float_string  = s.substring(0);
    this_double  = Double.valueOf(float_string).doubleValue(); 
    } 

  public GetDouble(String s)
    {
    parse_double (s);
    } 
  }

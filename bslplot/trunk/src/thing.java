import javax.swing.JOptionPane;



/**
 * Example javadoc thingy.
 * 
 *
 * @author  Mongo Spungo
 */

public class thing
  {
  public static void main ( String args[])
    {
    data d = new data();


    String s = new String("banana  1.0      3.4    ");
    GetDoublePairs gdp = new GetDoublePairs(s);


    System.out.println("dthingy1 = " + d.thingy2);

    if (gdp.ok())
      {
      double d1 = gdp.getFirstDouble(); 
      double d2 = gdp.getSecondDouble(); 

    System.out.println("d1 = " + d1 + ", d2 = " + d2);

     }

//    JOptionPane.showMessageDialog(null,
 //                                 "Get at ofit\n");
    System.exit(0);
    }
  } 





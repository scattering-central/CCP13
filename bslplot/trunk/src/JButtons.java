import java.awt.*;
import javax.swing.*;

private class ExitListener extends WindowAdapter {
   public void windowClosing(WindowEvent event) { System.exit(0);
   }
  }
/** A few utilities that simplify using windows in Swing. * 1998-99 Marty Hall, http://www.apl.jhu.edu/~hall/java/ */
private class WindowUtilities
  {
  /** Tell system to use native look and feel, as in previous * releases.
   *    Metal (Java) LAF is the default otherwise. */
  public static void setNativeLookAndFeel()
    {
    try
      { UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
      }
    catch(Exception e)
      {
      System.out.println("Error setting native LAF: " + e);
      }
    }
    public static void setJavaLookAndFeel()
      {
      try
        {
        UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());
        }
      catch(Exception e)
        {
        System.out.println("Error setting Java LAF: " + e);
        }
      }
      public static void setMotifLookAndFeel()
        {
        try
          {
          UIManager.setLookAndFeel("com.sun.java.swing.plaf.motif.MotifLookAndFeel");
          }
        catch(Exception e)
          {
          System.out.println("Error setting Motif LAF: " + e);
          }
        }
      /** A simplified way to see a JPanel or other Container. *
       *  Pops up a JFrame with specified Container as the content pane. */
       public static JFrame openInJFrame(Container content, int width, int height, String title, Color bgColor)
         {
         JFrame frame = new JFrame(title);
         frame.setBackground(bgColor);
         content.setBackground(bgColor);
         frame.setSize(width, height);
         frame.setContentPane(content);
         frame.addWindowListener(new ExitListener());
         frame.setVisible(true);
         return(frame);
         }
      /** Uses Color.white as the background color. */
      public static JFrame openInJFrame(Container content, int width, int height, String title)
        {
        return(openInJFrame(content, width, height, title, Color.white));
        }
      /** Uses Color.white as the background color,
       *  and the * name of the Container's class as the JFrame title. */
       public static JFrame openInJFrame(Container content, int width, int height)
         {
         return(openInJFrame(content, width, height, content.getClass().getName(), Color.white));
         }
      }

public class JButtons extends JFrame {
  public static void main(String[] args) {
    new JButtons();
  }

  public JButtons() {
    super("Using JButton");
    WindowUtilities.setNativeLookAndFeel();
    addWindowListener(new ExitListener());
    Container content = getContentPane();
    content.setBackground(Color.white);
    content.setLayout(new FlowLayout());
    JButton button1 = new JButton("Java");
    content.add(button1);
    ImageIcon cup = new ImageIcon("images/cup.gif");
    JButton button2 = new JButton(cup);
    content.add(button2);
    JButton button3 = new JButton("Java", cup);
    content.add(button3);
    JButton button4 = new JButton("Java", cup);
    button4.setHorizontalTextPosition(SwingConstants.LEFT);
    content.add(button4);
    pack();
    setVisible(true);
  }
}

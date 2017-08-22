import java.io.*;
import java.util.Stack;
import java.util.*;

// This is my basis class for text file reading - 
// simply pass the name of the file, and you can retrieve
// a vector (sequentially) of every line in the text file.


public class ReadTextFile
  {  
  private Vector rtn; 
 
  public void initVector ()
    {
    rtn = new Vector ();
    }

  public Vector getTextFileVector ()
    {
    // rtn should be built of sequential lines from input text file 
    return rtn; 
    }
 
  public void addLineToVector (String line)
    {
    rtn.addElement(line); 
    } 

  public ReadTextFile (String arg) 
    {    
    initVector (); 
    
    // We want to let the user specify which file we should open    
    // on the command-line.  E.g., 'java TextIO TextIO.java'.    
    if(arg.length() == 0) 
      {      
      System.err.println
        ("error: ReadTextFile expects a filename argument");      
      System.exit(1);    
      }    
  
    // We're going to read lines from 'input', which will be attached    
    // to a text-file opened for reading.    
    BufferedReader input = null;     
    try 
      {      
      FileReader file = new FileReader(arg); // Open the file.      
      input = new BufferedReader(file); // Tie 'input' to this file.    
      }    
    catch(FileNotFoundException x) 
      { 
      // The file may not exist.      
      System.err.println("File not found: " + arg);      
      System.exit(2);    
      }    
 
    // Now we read the file, line by line, echoing each line to    
    // the terminal.    
    try 
      {      
      String line;      
      while( (line = input.readLine()) != null ) 
        {        
        // System.out.println(line);      
        addLineToVector(line);
        }    
      }    
    catch(IOException x) 
      {      
      x.printStackTrace();    
      }  
    }
  }

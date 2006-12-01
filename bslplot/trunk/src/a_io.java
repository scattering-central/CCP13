import java.io.* ;


class read_r
  {
  int x;

  void read (RandomAccessFile raf) throws IOException
    {
    x = raf.readInt();
    }
  void set_x (double passed_x)
    {
    //this.x = passed_x;
    }
  int get_x ()
    {
    return x;
    }
  }
   
 class a_io
  {
  public static void main (String [] args)
    {
    DataInputStream dis = null;
    int d_x;
    int my_byte;
    RandomAccessFile raf = null;

    try
      {
      raf = new RandomAccessFile("data","rw");
      read_r rr = new read_r();
     rr.read(raf);
  //    raf.seek(0); 

    //  FileInputStream fis = new FileInputStream("data");
   //   BufferedInputStream bis = new BufferedInputStream(fis);
    //  my_byte = bis.read();
     // FileInputStream fis = new FileInputStream("c:\\stuff\\data");
      //dis = new DataInputStream(fis);
      //XY xy = (XY) dis.readObject (); 
      // my_byte = System.in.read();
      d_x = rr.get_x();

      System.out.println(d_x);
  
      String s = new String ("6");
      
      d_x = Integer.parseInt(s);
      System.out.println(d_x);
      }
    catch (IOException e)
      {
      System.out.println(e.getMessage());
      System.out.println("thingy");
      return; 
      }
    }
  }






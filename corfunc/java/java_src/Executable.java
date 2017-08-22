import java.io.*;
import java.util.*;

public class Executable extends Observable implements Runnable {
    private BufferedReader in, err;
    private PrintWriter out;
    private Thread inThread, errThread;
    private String message;
    private Process prog;
    private boolean stop, read_in, read_err;
    private String progName;
    private InputStream prog_in, prog_err;

    public Executable (String progName, boolean read_in, boolean read_err) throws Exception {
        this.read_in=read_in;
        this.read_err=read_err;
        this.progName=progName;
        stop=false;
        prog = Runtime.getRuntime().exec(progName);
        prog_in=prog.getInputStream();
        prog_err=prog.getErrorStream();
        in = new BufferedReader(new InputStreamReader(prog_in));
        err = new BufferedReader(new InputStreamReader(prog_err));
        out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(
                              prog.getOutputStream())),true);
        if(read_in)
            readFromApp();
        if(read_err)
            readAppError();
    }

    public void writeToApp (String message) throws IOException {
        out.println(message);
        setChanged();
        notifyObservers(message);
    }

    public void readFromApp () throws Exception {
        inThread = new Thread(this,"inThread");
        inThread.start();
    }

    public void readAppError () throws Exception {
        errThread = new Thread(this,"errThread");
        errThread.start();
    }

    public void kill() throws Exception {
        stop=true;
        if(prog!=null)prog.destroy();
        in.close();
        err.close();
        out.close();
        Thread.currentThread().yield();
    }

    public void run () {
        if(Thread.currentThread().getName().equals("inThread")) {
            try {

                while(!stop){		
                    	Thread.currentThread().sleep(5);

			//added by dwf - begin
			if (progName.equals("tropus")) {
				StringBuffer buffer = new StringBuffer();
				InputStream is = prog.getInputStream();
				int character = 0;
				int counter = 0;

				while ( character != -1 ) {
				        try{
					          character = is.read();
        				} catch (Exception e) {character = -1;}

					if ( character != -1 ) {
          					char c = (char)character;
						buffer.append(c);    //message += character;

						if (character == '?') counter++;

						if (counter > 0) {
							if (buffer.toString().startsWith(" Extrap")) {
                        			
						        	//first line of tropus output has 4x '?'
								if (counter == 4) {
									message = buffer.toString();
									setChanged();
		        	        				notifyObservers(message);
									break;
								}//end if
							} else {
                                        			message = buffer.toString();
                                        			setChanged();
                                        			notifyObservers(message);
                                        			break;
	
        	                			}//end if
	
						} else {
							message = buffer.toString();
	
        	               				if (message.indexOf(".TXT") != -1) {                         				
                	         				setChanged();
                        	 				notifyObservers(message);
                         					break;
                       					}//end if
						}//end if
	
					}//end if
				}//end while

			} else {
			//dwf end

	                	if ((message=in.readLine())==null) {				
	                    		setChanged();
        	            		notifyObservers(message);
        	                	break;
				}//end if
				setChanged();
	        	        notifyObservers(message);
			}//end if

                    	Thread.currentThread().yield();

                }//end while
            } catch (Exception e) {}

        } else  if(Thread.currentThread().getName().equals("errThread")) {
            try {
                while(!stop){
                    Thread.currentThread().sleep(5);
                    if ((message=err.readLine())==null)
                        break;
                    setChanged();
                    notifyObservers(message);
                    Thread.currentThread().yield();
                }
            } catch (Exception e) {}
        } //end if
    }//end method run



}//end class

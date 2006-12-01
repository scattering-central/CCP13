import java.io.*;
import java.util.*;

// Otoko DataSet class contains methods for reading and writing Otoko files
public class OtokoDataSet {
    File headerFile;
    File dataFile;
    float[] data;
    int[] flags = new int[10];
    String header1;
    String header2;
    String headerFileName;
    String dataFileName;
    private int dataStart;

    public OtokoDataSet(File inFile) throws Exception {
        headerFile = inFile;
        readHeader();
        if(headerFile.getParent()!=null)
          dataFile = new File(headerFile.getParent()+File.separatorChar+dataFileName);
        else
            dataFile = new File("."+File.separatorChar+dataFileName);
        readData();
    }

    public OtokoDataSet(String inFileName) throws Exception {
        File inFile = new File(inFileName);
        headerFile = inFile;
        readHeader();
        if(headerFile.getParent()!=null)
            dataFile = new File(headerFile.getParent()+File.separatorChar+dataFileName);
        else
            dataFile = new File("."+File.separatorChar+dataFileName);
        readData();
    }

    public OtokoDataSet(File inFile, String type) throws Exception {
        if(type.equals("ascii")) {
            readAscii(inFile);
        }
    }


//method added by dwf
    public OtokoDataSet(String inFileName, String type, String axis) throws Exception {
        File inFile = new File(inFileName);
        if(type.equals("corfunc")) {
		    	readCorfunc(inFile, axis);
	}//end if
    }


//method added by dwf
public void readCorfunc(File inFile, String strAxis) throws Exception {
        int axis = 0;
		//System.out.println("in readCorfunc");	      
	//read file
	FileReader fileReader = null;
	BufferedReader bufferedReader = null;
	Vector dataVector = new Vector();

	if (strAxis.equalsIgnoreCase("y"))
		axis = 1;

	try {
		fileReader = new FileReader(inFile);
	      	bufferedReader = new BufferedReader(fileReader);
		String line = "";
		StringBuffer buffer = new StringBuffer();

	      	while((line = bufferedReader.readLine()) != null){
        		buffer.append(line);
	      	}//end while

		StringTokenizer strTok = new StringTokenizer(buffer.toString());
		


		while(strTok.hasMoreTokens()) {
			if (axis == 0) {
				dataVector.add(strTok.nextToken());
				strTok.nextToken();strTok.nextToken();
			} else {
				strTok.nextToken();strTok.nextToken();
				dataVector.add(strTok.nextToken());
			}//end if	

		}//end while

		data = new float[dataVector.size()];

		for (int i=0; i<dataVector.size(); i++) {
			//System.out.println((String)dataVector.get(i));
			data[i] = new Float((String)dataVector.get(i)).floatValue();
		}//end for

	} catch(IOException e) {
		e.printStackTrace();
	} finally {
		try {
			fileReader.close();
			bufferedReader.close();
      		} catch(IOException e) {
			e.printStackTrace();
      		}//end try/catch
    	}//end finally

        flags[0]=dataVector.size();
        flags[1]=1;
        flags[2]=1;
        for(int i=3;i<10;i++) {
            flags[i]=0;
        }//end for
    }








    public OtokoDataSet(String inFileName, String type) throws Exception {
        File inFile = new File(inFileName);
        if(type.equals("ascii")) {
            readAscii(inFile);
        }
    }

    public OtokoDataSet(String header1, String header2,
                        int nChannels, int nFrames, float[] data,
                        String headerFileName) throws Exception {
        //Set up flags
        flags[0]=nChannels;
        flags[1]=nFrames;
        flags[2]=1;
        for(int i=3;i<10;i++) {
            flags[i]=0;
        }

        this.header1=header1;
        this.header2=header2;
        this.data=data;
        this.headerFileName=headerFileName;
    }

    public void writeOtokoFile () throws Exception {

        StringBuffer sFlagsBuffer = new StringBuffer(80);
        int length = (String.valueOf(flags[0])).length();
        for (int i=0; i<(8-length);i++) {
            sFlagsBuffer.append(' ');
        }
        sFlagsBuffer.append(flags[0]);

        length = (String.valueOf(flags[1])).length();
        for (int i=0; i<(8-length);i++) {
            sFlagsBuffer.append(' ');
        }
        sFlagsBuffer.append(flags[1]);

        for(int i=0; i<8; i++) {
            sFlagsBuffer.append("       ");
            sFlagsBuffer.append("0");
        }

        //Create the data filename(less path)
        String sTemp = headerFileName.substring(headerFileName.lastIndexOf((int)File.separatorChar)+1
                                                ,headerFileName.length());
        StringBuffer sbTemp = new StringBuffer(sTemp);
        sbTemp.setCharAt(5,'1');
        String dataFileNameLessPath = sbTemp.toString();
        String dataFileName = headerFileName.substring(0,headerFileName.lastIndexOf((int)File.separatorChar)+1)
                              .concat(dataFileNameLessPath);

        //Write the header file
        FileWriter fileWriter = new FileWriter(headerFileName);
        BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
        bufferedWriter.write(header1);
        bufferedWriter.newLine();
        bufferedWriter.write(header2);
        bufferedWriter.newLine();
        bufferedWriter.write(sFlagsBuffer.toString());
        bufferedWriter.newLine();
        bufferedWriter.write(dataFileNameLessPath);
        bufferedWriter.close();

        //Write the data file
        FileOutputStream fileOutput = new FileOutputStream(dataFileName);
        DataOutputStream dataOutput = new DataOutputStream(fileOutput);
        for(int i=0;i<flags[0]*flags[1];i++) {
            dataOutput.writeFloat(data[i]);
        }
        fileOutput.close();
        dataOutput.close();
    }

    private void readHeader() throws Exception {
        FileReader fileReader = new FileReader(headerFile);
        BufferedReader bufferedReader = new BufferedReader(fileReader);

        if((header1 = bufferedReader.readLine())==null)
          throw new Exception("Error reading header file");
        else
          header1=header1.trim();
        if((header2 = bufferedReader.readLine())==null)
          throw new Exception("Error reading header file");
        else
          header2=header2.trim();

        String flagsLine;
        if((flagsLine=bufferedReader.readLine())==null)
          throw new Exception("Error reading header file");
          StringTokenizer st = new StringTokenizer(flagsLine);
          for(int i=0; i<10; i++) {
              flags[i]=new Integer(st.nextToken()).intValue();
          }

        if((dataFileName = bufferedReader.readLine())==null)
          throw new Exception("Error reading header file");
        else
          dataFileName=dataFileName.trim();

        fileReader.close();
        bufferedReader.close();
    }

    private void readData () throws Exception {
        //Read data into byte array
        int size = flags[0]*flags[1];
        FileInputStream fileInput = new FileInputStream(dataFile);
        BufferedInputStream bufferedInput = new BufferedInputStream(fileInput);
        byte[] bbuf = new byte[size*4];
        bufferedInput.read(bbuf,0,size*4);

        //Swap if necessary
        if(flags[3]==1) {
            byte[] tempbuf = new byte[size*4];
            for(int i=0;i<size*4;i+=4) {
                tempbuf[i+3]=bbuf[i];
                tempbuf[i+2]=bbuf[i+1];
                tempbuf[i+1]=bbuf[i+2];
                tempbuf[i]=bbuf[i+3];
            }
            bbuf=tempbuf;
        }

        //Read the data into array of floats
        data = new float[size];
        ByteArrayInputStream byteStream = new ByteArrayInputStream(bbuf);
        DataInputStream dataInput = new DataInputStream(byteStream);
        for(int i=0;i<size;i++) {
            data[i]=dataInput.readFloat();
        }
        dataInput.close();
        byteStream.close();
    }

    public void readAscii(File inFile) throws Exception {
        String line;
        int i,j,nFrames,nChannels;
        FileReader fileReader = new FileReader(inFile);
        BufferedReader bufferedReader = new BufferedReader(fileReader);
        nFrames=0;
        nChannels=0;
        Vector dataVector = new Vector(512,10);

        do {
            if((line = bufferedReader.readLine())!=null){
                nChannels++;
                line=line.replace(',',' ');
                StringTokenizer st = new StringTokenizer(line);
                i=0;
                while (st.hasMoreTokens()) {
                    dataVector.addElement(st.nextToken());
                    i++;
                }
                if(nFrames==0) {
                    nFrames=i;
                }
                else {
                   if(i!=nFrames) {
                        throw new Exception("Error: Each channel in data must contain the same number of frames");
                   }
                }
            }
            else {
                break;
            }
        }while(true);
        data = new float[dataVector.size()];
        int ij=0;
        for(j=0;j<nChannels;j++) {
            for(i=0;i<nFrames;i++) {
                data[(i*nChannels)+j]=new Float((String)dataVector.elementAt(ij)).floatValue();
                ij++;
            }
        }

        fileReader.close();
        bufferedReader.close();
        flags[0]=nChannels;
        flags[1]=nFrames;
        flags[2]=1;
        for(i=3;i<10;i++) {
            flags[i]=0;
        }
    }

    public int getChannels () {
        return flags[0];
    }

    public int getFrames () {
        return flags[1];
    }

    public float[] getData () {
        return data;
    }

    public float getData(int i) {
        return data[i];
    }

    public int getDataStart () {
        double q0;

        if(data[0]==0.0)
            q0=Double.MIN_VALUE;
        else
            q0=data[0];
        for(int i=1;i<flags[0]-1;i++) {
            if((data[i]>10*q0)&&(data[i]>data[i+1])) {
              return i;
            }
        }
        if(flags[0]/8>0)
            return flags[0]/8;
        else
            return 1;
    }
}
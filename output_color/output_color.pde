import processing.serial.*;
String val;
Serial myPort;
//define all tags of interest
//String[] tagslist = 
String[] mattagslist = 
//{"e2001d8710411310eec","e2001d87113722406cf0","e2001d87112622405da3","e2001d87116222408951"};
//{"f20019748130188056da","e20019748158183058f5","e2001974817418305915", "e20019748164183058f8"};
{"e2001d87102813086","e2001d871015131019f","e2001d8710401310cfc","e2001d87112622405da3"};
//String[] boxtagslist = ;
//define data buffer for each tag
int buffer = 2000;
//create 2d array to contain tag rssi data
int[][] tagData = new int[mattagslist.length][buffer];


String[] incoming; //data coming in from serial port


void setup(){
  size( 600, 500 );
  String portName = Serial.list()[0];
  myPort = new Serial(this, "COM5", 115200);
}

void draw(){
  background( 255 );

  
  //read incoming data from serial
  if(myPort.available()>0){
    val = myPort.readStringUntil('\n');
  }
  
  //if the data coming in from serial is legit
if(val != null){
  //print that data
   println(val);
   
   
  //and if the data matches the format for incoming RFID tag info, populate incoming array
  //incoming array format == [tagID,RSSI]
  //if not about RFID tag, return whatever the message is
  if(val.length() == 26 || val.length() == 25){ //this may need to be changed if EPC value is shorter on the tags used.
    incoming = split(val, ",");
  }else{
    println(val);
  }
  
  float xOff;
  xOff = ((float) width/buffer);

  
  //make sure incoming has a value
  if(incoming!=null && incoming[0].length()>3){
    int indexVal;
    //printArray(incoming);
    
   
      for(int i=0; i<mattagslist.length; i++){
        incoming[1]=incoming[1].replaceAll("\\s","");
        //println(tagData[0][0]);
        
         //println(i);
      
       
        //println(incoming[1]);
        //println(indexVal);
        
        //println(Integer.parseInt(incoming[1]));
        for(int j=1; j<buffer; j++){
          if(mattagslist[i].equals(incoming[0])){
           indexVal = i;
          tagData[indexVal][j]=tagData[indexVal][j-1];
        tagData[indexVal][0] = Integer.parseInt(incoming[1]);       
        //printArray(tagData[indexVal][4]);    
        
      }
     
    }; 
    // printArray(tagData);
     //println(tagData[0].length);
     //println(tagData[1][0]);
     //println(tagData[2][0]);
    
}

}

  //drawLines(xOff);
  drawBoxes();
}
}
 
 void drawLines(float xSpace){
//loop through however many active tags you've listed (mattagslist.length);
         for(int i=0; i<mattagslist.length; i++){
        stroke(i*70, 100+i*20,200);
        //draw a line from top of canvas to mapped value
   
      for(int j=1;j<buffer; j++){
             line(i+(xSpace*j), 0, i+(xSpace*j), map(tagData[i][j], -65,-30,height,0));  
      }
      
    };     
};

void drawBoxes(){
  fill(map(tagData[0][0], -65,-30,255,0),150,0);
  rect(0,0,width/2,height/2);
fill(map(tagData[1][0], -65,-30,255,0),150,0);
  rect(width/2,0,width,height/2);
fill(map(tagData[2][0], -65,-30,255,0),150,0);
  rect(0,height/2,width/2,height);
fill(map(tagData[3][0], -65,-30,255,0),150,0);
  rect(width/2,height/2,width,height);
  
};
   
 

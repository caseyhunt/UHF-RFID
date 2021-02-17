import processing.serial.*;
String val;
Serial myPort;
//define all tags of interest
String[] tagslist = {"f20019748130188056da","e20019748158183058f5","e2001974817418305915", "e20019748164183058f8"};
//define data buffer for each tag
int buffer = 2000;
//create 2d array to contain tag rssi data
int[][] tagData = new int[tagslist.length][buffer];


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
  
  //and the data matches the format for incoming RFID tag info, populate incoming array
  //if not an RFID tag, return whatever the message is
  if(val.length() == 26){
    incoming = split(val, ",");
    
  }else{
    println(val);
    println(val.length());
  }
  
  float xOff;
  xOff = ((float) width/buffer);

  
  //make sure incoming has a value
  if(incoming!=null && incoming[0].length()>3){
    int indexVal;
    //printArray(incoming);
    
   
      for(int i=0; i<tagslist.length; i++){
        incoming[1]=incoming[1].replaceAll("\\s","");
        //println(tagData[0][0]);
        
         //println(i);
      
       
        //println(incoming[1]);
        //println(indexVal);
        
        //println(Integer.parseInt(incoming[1]));
        for(int j=1; j<buffer; j++){
          if(tagslist[i].equals(incoming[0])){
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

  drawLines(xOff,4);
}
}
 
 void drawLines(float xSpace, float yOff){
         for(int i=0; i<tagslist.length; i++){
        //incoming[1]=incoming[1].replaceAll("\\s","");
        //println(tagData[0][0]);
        
         //println(i);
        float xSpacing;
        //= (width/buffer);
        
        xSpacing=xSpace;
       
        //println(incoming[1]);
        //println(indexVal);
        
        //println(Integer.parseInt(incoming[1]));
        for(int j=1;j<buffer; j++){
          //line(width-(xSpacing*j),map(tagData[0][j], -60,-30,height,0),width-(xSpacing*(j-1)),map(tagData[0][j-1], -60,-30,height,0));
            stroke(i*70, 100+i*20,200);
            line(10+i*100, 0, 10+i*100, map(tagData[i][j-1], -60,-30,height,0));
          //point(width,(map(tagData[i][buffer-j], -60,-30,height,0)+yOff));
          //point(width-(xSpacing*(j)),(map(tagData[i][buffer-j-1], -60,-30,height,0)+yOff));
          //if(tagslist[i].equals(incoming[0])){       
        //printArray(tagData[indexVal][4]);    
        
      };
     
     
    }; 
    // printArray(tagData);
     //println(tagData[0].length);
     //println(tagData[1][0]);
     //println(tagData[2][0]);
    
};
   
 

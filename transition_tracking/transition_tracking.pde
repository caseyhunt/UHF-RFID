import processing.serial.*;
String val;
Serial myPort;
//define all tags of interest
//String[] tagslist = 
String[] mattagslist = 
{"e2001d8712171320c120","e2001d871271320b9f","e2001d8712461320db93", "e2001d8712401320d4a0"};
//String[] boxtagslist = ;
//define data buffer for each tag
int buffer = 40;
//create 2d array to contain tag rssi data
int[][] tagData = new int[mattagslist.length][buffer];
String[] storage = new String[4];
boolean reading = true;
boolean recording = false;


//String[] incoming = new String[4]; //data coming in from serial port



void setup(){
  size( 600, 500 );
  //String portName = Serial.list()[0];
  //myPort = new Serial(this, "COM5", 115200);
}


void draw(){
  fill(255);
  rect(25,25,50,50);
  //println(recording);
  //println(hour(), minute(), second(), millis());
  String timeString = hour() + " " + minute() + " " + second() + " " + millis();
  String tagID = "tagID";
  String[] incoming = {timeString, tagID, "RSSI", "Phase"};
  
//  if(myPort.available()>0){
//    val = hour(), minute(), second(), millis(), "," myPort.readStringUntil('\n');
//  }
  
//  //if the data coming in from serial is legit
//if(val != null){
//  //print that data
////   println(val);
   
   
//  //and if the data matches the format for incoming RFID tag info, populate incoming array
//  //incoming array format == [tagID,RSSI,phase]
//  //if not about RFID tag, return whatever the message is
//  if(val.length() > 20 && val.length() < 34){ //this may need to be changed if EPC value is shorter on the tags used.
//    incoming = split(val, ",");
//    print(incoming);
//  }else{
//   // println(val);
//  }


////after populating the incoming array,
////push the data from the array into the data storage array
////the storage array is formatted as groups of four values streamed into a single giant array
////[time of arrival, tagID, RSSI, phase, time of arrival, tagID, RSSI, phase.....]
////this block of code will return an error if there is a mismatch between the incoming length and the length being added to the array each time.
if(incoming[1]!=null){
  if(storage ==null){
    storage = incoming;
  }else{
    int l = storage.length;
    l = l + 4;
    if (l%4 == 0){
      storage = add_element(l, storage, incoming);
      printArray(storage);
      incoming[1] = null; // set the first position of incoming to null so this isn't triggered until the next reading comes in from the RFID reader
     
    }else{
      println("!Corruption error: problem committing data to storage. Restart run and try again.");
    }
    
  }
  

}

}

void mouseClicked(){
  println("clicked");
  if (reading == true && recording == false){
    recording = true;   
  } 
  else if (reading == true && recording == true){
    recording = false;
  }
}

//void draw(){
//  background( 255 );

//startRecord();
  
//  //read incoming data from serial
//  if(myPort.available()>0){
//    val = myPort.readStringUntil('\n');
//  }
  
//  //if the data coming in from serial is legit
//if(val != null){
//  //print that data
//   println(val);
   
   
//  //and if the data matches the format for incoming RFID tag info, populate incoming array
//  //incoming array format == [tagID,RSSI]
//  //if not about RFID tag, return whatever the message is
//  if(val.length() > 20 && val.length() < 34){ //this may need to be changed if EPC value is shorter on the tags used.
//    incoming = split(val, ",");
//  }else{
//   // println(val);
//  }
  
//  float xOff;
//  xOff = ((float) width/buffer);


// if(recording == 1){
//  //make sure incoming has a value
//  if(incoming!=null && incoming[0].length()>3){
//    int indexVal =0;
//    boolean isIndex = false;
//    //printArray(incoming);
    


//      for(int i=0; i<mattagslist.length; i++){
//        incoming[1]=incoming[1].replaceAll("\\s","");
        
//        //println(tagData[0][0]);
        
//         //println(i);
      
       
//        //println(incoming[1]);
//        //println(indexVal);
        
//        //println(Integer.parseInt(incoming[1]));
//          if(mattagslist[i].equals(incoming[0])){
           
//           indexVal = i;
//           isIndex = true;
//           println("yes!, " + indexVal);
//          }else{
//            isIndex = false;
//          }
//   if(isIndex = true){
//        for(int j=1; j<buffer; j++){
//          tagData[indexVal][j]=tagData[indexVal][j-1];
            
         
        
        
//      }
//       tagData[indexVal][0] = Integer.parseInt(incoming[1]);  
//       println(indexVal);
//        printArray(tagData[indexVal]);   
//        isIndex=false;
     
//    }; 
//     //println(tagData[0].length);
//     //println(tagData[1][0]);
//     //println(tagData[2][0]);
    
//}
//  }

//}else if(tagData.length>1){
//  printArray(tagData);
//}

//  //drawLines(xOff);
//  drawBoxes();
//}
//}

 
// void drawLines(float xSpace){
////loop through however many active tags you've listed (mattagslist.length);
//         for(int i=0; i<mattagslist.length; i++){
//        stroke(i*70, 100+i*20,200);
//        //draw a line from top of canvas to mapped value
   
//      for(int j=1;j<buffer; j++){
//             line(i+(xSpace*j), 0, i+(xSpace*j), map(tagData[i][j], -65,-30,height,0));  
//      }
      
//    };     
//};

////void drawBoxes(){
////  fill(map(tagData[0][0], -65,-30,255,0),150,0);
////  rect(0,0,width/2,height/2);
////fill(map(tagData[1][0], -65,-30,255,0),150,0);
////  rect(width/2,0,width,height/2);
////fill(map(tagData[2][0], -65,-30,255,0),150,0);
////  rect(0,height/2,width/2,height);
////fill(map(tagData[3][0], -65,-30,255,0),150,0);
////  rect(width/2,height/2,width,height);
  
////};
   
//   void drawBoxes(){
////  fill(map(tagData[0][0], -65,-50,255,0),150,0);
////  rect(0,0,width,height/2);
////fill(map(tagData[1][0], -65,-50,255,0),150,0);
////  rect(0,height/2,width,height);

//  fill(map(tagData[0][0], -65,-50,255,0),150,0);
//  rect(0,0,width,height/4);
//fill(map(tagData[1][0], -65,-50,255,0),150,0);
//  rect(0,height/4,width,(2*height/4));
//  fill(map(tagData[2][0], -65,-50,255,0),150,0);
//  rect(0,(2*height/4),width,(3*height/4));
//  fill(map(tagData[3][0], -65,-50,255,0),150,0);
//  rect(0,(3*height/4),width,(height));
  
//};

//  void startRecord(){
//       if (mousePressed && (mouseButton == LEFT)) {
//    recording = 1;
//  } else if (mousePressed && (mouseButton == RIGHT)) {
//    recording = 0;
//  }
//  };

//function to add element to array in Java

    public static String[] add_element(int n, String[] myarray, String[] ele) 
    { 
     if( n != (ele.length + myarray.length)){
      println("!Data Loss Warning: 'add_element' function mismatch between n param and array length"); 
     }
 
         String[] newArray = new String[n]; 
        //copy original array into new array
        for (int i = 0; i < myarray.length ; i++) {
              newArray[i] = myarray[i]; 
        }
        for(int i = 0; i < ele.length; i++){
          newArray[myarray.length+i] = ele[i];
        }
 
 
        return newArray; 
    } 
   
 

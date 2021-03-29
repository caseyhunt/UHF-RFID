import processing.serial.*;
String val;
String serRaw;
Serial myPort;
//define all tags of interest
//String[] tagslist = 


//list of tags that data will be collected on.
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
boolean incomingTD = false;

String[] incoming = new String[4];



Table table;


//String[] incoming = new String[4]; //data coming in from serial port



void setup(){
  size( 600, 500 );
  table = new Table();
  
  table.addColumn("time");
  table.addColumn("id");
  table.addColumn("RSSI");
  table.addColumn("phase");
  String portName = Serial.list()[0];
  myPort = new Serial(this, "COM5", 115200);
}


void draw(){
  fill(255);
  rect(25,25,50,50);
  //println(recording);
  //println(hour(), minute(), second(), millis());
  String timeString = hour() + " " + minute() + " " + second() + " " + millis();
  incoming = null;
  
  
  //if serial is available
  //import incoming data as String val = H M S MS, Incoming Serial Data
if(myPort.available()>0){
    serRaw = myPort.readStringUntil('\n');
    val = timeString + "," + serRaw;
  }
  
  //if there is raw data coming in from serial...
  //this function should contain all of the code you want to run when the serial port is actively reading values
if(serRaw != null){
  
  
 //populate incoming array from serial data. 
   incoming = split(val, ",");
   printArray(incoming);
   
 //if the incoming serial data is in the format you're looking for make incomingTD = true
  if(incoming.length>3){ 
    printArray(incoming);
    incomingTD = true;
    recordData();
  }else{
    incomingTD = false;
    println(serRaw);
    println(incoming.length);
    println("!Alert: incoming value not recorded as tag data. Is this a tag? If so, see if incoming.length matches your expected value. Ln62"); //this alert should show for all non-tag data i.e. "BAD CRC", etc.
  }






}
}

//this little function basically starts recording when the mouse button is clicked once
//stops recording when the mouse button is clicked twice.
//then, writes the data collected during the recording period to a .csv file
void mouseClicked(){
  println("recording started");
  if (reading == true && recording == false){
    recording = true;   
  } 
  else if (reading == true && recording == true){
    recording = false;
    println("recording stopped");
    //for(int i=0;i<9;i++){
    //println(storage[i]);
    //}
    pushToTable(storage);
    saveTable(table, "new.csv");
  }
}



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
    
void pushToTable(String[] data){
  int nRows = data.length/incoming.length;
  for(int i = 0; i<data.length;i+=incoming.length){
    TableRow newRow = table.addRow();
    newRow.setString("time", data[i]);
    newRow.setString("id", data[i+1]);
    newRow.setString("RSSI", data[i+2]);
    newRow.setString("phase", data[i+3]);
    
  }
  
}

void recordData() {
//if recording is true
if(recording){
  
  //if there's nothing in storage yet, add incoming 1:1
  if(storage ==null){
    storage = incoming;
  }else{   //otherwise use add_element to lengthen storage appropriately and add the incoming data
    int l = storage.length;
    l = l + incoming.length;
    //if the length of the new storage array is not divisible by length of incoming array, this indicates that there is a mismatch between the current length of the storage array and the length of the incoming array.
    //Likely caused by data not being recorded, restart the trial. 
    if (l%incoming.length == 0){
      storage = add_element(l, storage, incoming);      
    }else{
      println("!Corruption error: problem committing data to storage. Restart run and try again.");
    }
    
  }
  

}
}
 

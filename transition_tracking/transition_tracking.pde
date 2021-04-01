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
String[] runStorage = new String[4];
boolean reading = false;
boolean recording = false;
boolean incomingTD = false;

int[] fillColor = {255,0,0};

String[] incoming = new String[4];

int recordingCount = 0;

Table table;
Table runTable;

//change this for each test.
String testType = "baseline";


//String[] incoming = new String[4]; //data coming in from serial port



void setup(){
  size( 600, 500 );
  table = new Table();
  
  table.addColumn("time");
  table.addColumn("id");
  table.addColumn("RSSI");
  table.addColumn("phase");
  
  
   runTable = new Table();
  
  runTable.addColumn("time");
  runTable.addColumn("id");
  runTable.addColumn("RSSI");
  runTable.addColumn("phase");
  String portName = Serial.list()[0];
  myPort = new Serial(this, "COM5", 115200);
}


void draw(){
  fill(fillColor[0],fillColor[1],fillColor[2]);
  background(100,100,100);
  rect(100,50,375,100);
  fill(0);
  if(reading==true){
  text("recording started", 120,110);
  }else{text("not recording", 120,110);}
  fill(255);
  textSize(40);
  text("recording number:",50,250);
  text(recordingCount+1,450,250);
  //println(recording);
  //println(hour(), minute(), second(), millis());
  String timeString = hour() + " " + minute() + " " + second() + " " + millis();
  incoming = null;
  
  
  //if serial is available
  //import incoming data as String val = H M S MS, Incoming Serial Data
if(myPort.available()>0){
    serRaw = myPort.readStringUntil('\n');
    val = timeString + "," + serRaw;
    print(val);
  }
  
  //if there is raw data coming in from serial...
  //this function should contain all of the code you want to run when the serial port is actively reading values
if(serRaw != null){
  
  
 //populate incoming array from serial data. 
   incoming = split(val, ",");
  // printArray(incoming);
   
 //if the incoming serial data is in the format you're looking for make incomingTD = true
  if(incoming.length>3 && incoming[1] != null){ 
    //printArray(incoming);
    incomingTD = true;
    recordData();
  }else{
    incomingTD = false;

    //println(incoming.length);
    println("!Alert: incoming value not recorded as tag data. Is this a tag? If so, see if incoming.length matches your expected value. Ln62"); //this alert should show for all non-tag data i.e. "BAD CRC", etc.
  }






}
}

//this little function basically starts recording when the mouse button is clicked once
//stops recording when the mouse button is clicked twice.
//then, writes the data collected during the recording period to a .csv file
void mouseClicked(){
  if((100<mouseX  && mouseX <475) && (mouseY >50 && mouseY<150) && reading ==false){
    reading = true;
    fillColor[0] = 0;
    fillColor[1] = 255;
    fillColor[2] = 0;
    pushToTable(runStorage, runTable);
  }else if((mouseX >100 && mouseX <475) && (mouseY >50 && mouseY<150) && reading ==true){
    reading = false;
    fillColor[0] = 255;
    fillColor[1] = 0;
    fillColor[2] = 0;
    pushToTable(runStorage, runTable);
    String fileName2 = testType + "/runData" + ".csv";
    saveTable(runTable, fileName2);
  }else{
  
  //if not recording and mouse is clicked: change state of recording to true, triggering the record protocols
  if (recording == false){
    recording = true;   
    println("recording started");
    //if the table still has stuff in it, clear it out to start with a fresh one for the run.
      table.clearRows();
     
      storage = null;
  } 
  else if (recording == true){ //if the mouse is clicked and recording is already happening, turn off recording and run pushToTable function! Then, save that table.
    recording = false;
    recordingCount += 1;
    println("recording stopped");
    //for(int i=0;i<9;i++){
    //println(storage[i]);
    //}
    pushToTable(storage, table);
    String fileName = testType + "/" + recordingCount + ".csv";
    saveTable(table, fileName);

  }
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
    
//function to add data to table. Usually done before saving the table.
void pushToTable(String[] data, Table tbl){
  if(incomingTD == true){
  for(int i = 0; i<data.length;i+=incoming.length){
    TableRow newRow = tbl.addRow();
    newRow.setString("time", data[i]);
    newRow.setString("id", data[i+1]);
    newRow.setString("RSSI", data[i+2]);
    newRow.setString("phase", data[i+3]);
  }
  }
  
}

//function to record data

void recordData() {
//if recording is true
if(recording){
  
  //if there's nothing in storage yet, add incoming 1:1
  if(incomingTD == true){
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
  

}}
if(reading){
  if(incomingTD == true){
  if(runStorage ==null){
    runStorage = incoming;
  }else{   //otherwise use add_element to lengthen storage appropriately and add the incoming data
    int m = runStorage.length;
    m = m + incoming.length;
    //if the length of the new storage array is not divisible by length of incoming array, this indicates that there is a mismatch between the current length of the storage array and the length of the incoming array.
    //Likely caused by data not being recorded, restart the trial. 
    if (m%incoming.length == 0){
      runStorage = add_element(m, runStorage, incoming);      
    }else{
      println("!Corruption error: problem committing data to storage. Restart run and try again.");
    }
    
  }
}
}
}

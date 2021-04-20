import processing.serial.*;
String val;
String serRaw;

String[] list = new String[3];
int k = 5;
int y0=110, dy0=120;
int wide = 900;
float counter;
float[] data = new float[wide];
float[] data1 = new float[wide];
float[] data2 = new float[wide];
float[] data3 = new float[wide];
float[] smoothed = new float[wide];

//int[] lastVal = new int[4];
int[] lastVal = {-55,-55,-55,-55};

String[] tagslist = 
{"e2001d8712171320c120","e2001d871271320b9f", "e2001d8712401320d4a0", "e2001d8712461320db93"};

Serial myPort;
String[] incoming = new String[4];
boolean incomingTD = false;

void setup(){
 size(1200,900);
 background(200,200,0);
 
  String portName = Serial.list()[0];
  myPort = new Serial(this, "COM5", 115200);

}

void draw(){  // if new data from arduino Ain raw as string:
 background(0,0,0);

String timeString = hour() + " " + minute() + " " + second() + " " + millis();

  //if serial is available
  //import incoming data as String val = H M S MS, Incoming Serial Data
if(myPort.available()>0){
    serRaw = myPort.readStringUntil('\n');
    val = timeString + "," + serRaw;
    //print(val);
  
  
 //populate incoming array from serial data. 
   incoming = split(val, ",");
   
 // printArray(incoming);
   
 //if the incoming serial data is in the format you're looking for make incomingTD = true
  if(incoming.length>3 && incoming[1] != null){ 
    //printArray(incoming);
    incomingTD = true;
    recordData();
    //print("incoming tag");
    //printArray(incoming);
  }else{
    incomingTD = false;

    //println(incoming.length);
    println("!Alert: incoming value not recorded as tag data. Is this a tag? If so, see if incoming.length matches your expected value. Ln62"); //this alert should show for all non-tag data i.e. "BAD CRC", etc.
  }}

noStroke();
fill(255,255,255);
rect(150,10,k,200);
rect(150,220,k,200);
rect(150,430,k,200);
rect(150,640,k,200);
stroke(0,0,0);
noFill();

//beginShape();
//for(int i=0; i<k;i++){
//  float y = map(data[i],-60,-50,0,100);
//  //println(data[0]);
//  vertex(i+150,y+60);
  
//}
//endShape();

//beginShape();
//for(int i=0; i<k;i++){
//  float y = map(data1[i],-60,-50,0,100);
//  //println(y);
//  vertex(i+150,y+270);
  
//}
//endShape();

//beginShape();
//for(int i=0; i<k;i++){
//  float y = map(data2[i],-60,-50,0,100);
//  //println(y);
//  vertex(i+150,y+480);
  
//}
//endShape();

//beginShape();
//for(int i=0; i<k;i++){
//  float y = map(data3[i],-60,-50,0,100);
//  //println(y);
//  vertex(i+150,y+690);
  
//}
//endShape();





beginShape();
for(int i=3; i<k;i++){
  smoothed[i] = (data[i]+data[i-1]+data[i-2]+data[i-3])/4;
  float y = map(smoothed[i], -60,-50,0,120);
  //float y = map(data[i],-60,-50,0,100);
  //println(data[0]);
  vertex(i+150,y+20);
  
}
endShape();

beginShape();
for(int i=3; i<k;i++){
  smoothed[i] = (data1[i]+data1[i-1]+data1[i-2]+data1[i-3])/4;
  float y = map(smoothed[i], -60,-45,0,120);
  //float y = map(data1[i],-60,-50,0,120);
  //println(y);
  vertex(i+150,y+230);
  
}
endShape();

beginShape();
for(int i=3; i<k;i++){
  smoothed[i] = (data2[i]+data2[i-1]+data2[i-2]+data2[i-3])/4;
  float y = map(smoothed[i], -60,-45,0,120);
  //float y = map(data2[i],-60,-50,0,120);
  //println(y);
  vertex(i+150,y+440);
  
}
endShape();

beginShape();
for(int i=3; i<k;i++){
  smoothed[i] = (data3[i]+data3[i-1]+data3[i-2]+data3[i-3])/4;
  float y = map(smoothed[i], -60,-45,0,120);
  //float y = map(data3[i],-60,-50,0,120);
  //println(y);
  vertex(i+150,y+650);
  
}
endShape();




//line(k,y0+0*dy0,k,y0+0*dy0-val1);
//line(k,y0+1*dy0,k,y0+1*dy0-val2);
//line(k,y0+2*dy0,k,y0+2*dy0-val3);
//stroke(255);
//line(k+1,y0+0*dy0,k+1,y0+0*dy0-100);
//line(k+1,y0+1*dy0,k+1,y0+1*dy0-100);
//line(k+1,y0+2*dy0,k+1,y0+2*dy0-100);



}


 

void recordData() {
  




  
    println(incoming[1], incoming[2]);
  if ( k< wide ){

if(incoming[1].equals(tagslist[0])){
  data[k] = float(incoming[2]);
  lastVal[0] = int(incoming[2]);
  noFill();
  strokeWeight(10);
  stroke(0,255,0);
    rect(150,10,wide,200);
        strokeWeight(1);
  
  }else{
    if(incoming[1].equals(tagslist[1])){
        noFill();
        strokeWeight(10);
        stroke(0,255,0);
        rect(150,220,wide,200);
            strokeWeight(1);
        
    data1[k] = float(incoming[2]);
    lastVal[1] = int(incoming[2]);
    } else {
      if(incoming[1].equals(tagslist[2])){
         noFill();
        strokeWeight(10);
        stroke(0,255,0);
       rect(150,430,wide,200);
           strokeWeight(1);
          data2[k] = float(incoming[2]);
          lastVal[2] = int(incoming[2]);
      } else{
          data2[k] = lastVal[2];
          if(incoming[1].equals(tagslist[3])){
              noFill();
        strokeWeight(10);
        stroke(0,255,0);
    rect(150,640,wide,200);
        strokeWeight(1);
             data3[k] = float(incoming[2]);
             lastVal[3] = int(incoming[2]);
          }
          else{
            data3[k] = lastVal[3];
          }
      }
      data1[k] = lastVal[1];
    }
    data[k] = lastVal[0];
    
  }

  
  k++;
}else{


  if(incoming[1].equals(tagslist[0])){
  data[wide-1] = float(incoming[2]);
  lastVal[0] = int(incoming[2]);
  noFill();
  strokeWeight(10);
  stroke(0,255,0);
    rect(150,10,wide,200);
        strokeWeight(1);
  
  }else{
    if(incoming[1].equals(tagslist[1])){
        noFill();
        strokeWeight(10);
        stroke(0,255,0);
        rect(150,220,wide,200);
            strokeWeight(1);
        
    data1[wide-1] = float(incoming[2]);
    lastVal[1] = int(incoming[2]);
    } else {
      if(incoming[1].equals(tagslist[2])){
         noFill();
        strokeWeight(10);
        stroke(0,255,0);
       rect(150,430,wide,200);
           strokeWeight(1);
          data2[wide-1] = float(incoming[2]);
          lastVal[2] = int(incoming[2]);
      } else{
          data2[wide-1] = lastVal[2];
          if(incoming[1].equals(tagslist[3])){
              noFill();
        strokeWeight(10);
        stroke(0,255,0);
    rect(150,640,wide,200);
        strokeWeight(1);
             data3[wide-1] = float(incoming[2]);
             lastVal[3] = int(incoming[2]);
          }
          else{
            data3[wide-1] = lastVal[3];
          }
      }
      data1[wide-1] = lastVal[1];
    }
    data[wide-1] = lastVal[0];
    
  }

  for(int i=0; i<wide-1;i++){
  data[i] = data[i+1];
  data1[i] = data1[i+1];
  data2[i] = data2[i+1];
  data3[i] = data3[i+1];
  }
}
}

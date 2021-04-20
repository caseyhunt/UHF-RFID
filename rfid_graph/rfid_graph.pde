String[] list = new String[3];
int k = 5;
int y0=110, dy0=120;
int wide = 300;
float counter;
float[] data = new float[wide];
float[] data1 = new float[wide];
float[] data2 = new float[wide];
float[] data3 = new float[wide];

void setup(){
 size(600,450);
 background(200,200,0);

}

void draw(){  // if new data from arduino Ain raw as string:
 background(200,200,0);
list[0] = "1000";
list[1] = "200";
list[2] = "50";
counter +=.1;

noStroke();
fill(255,255,255);
rect(150,10,k,100);
rect(150,120,k,100);
rect(150,230,k,100);
rect(150,340,k,100);
stroke(0,0,0);
noFill();
beginShape();
for(int i=0; i<k;i++){
  float y = map(data[i],-1,1,0,70);
  println(y);
  vertex(i+150,y+30);
  
}
endShape();

beginShape();
for(int i=0; i<k;i++){
  float y = map(data1[i],-1,1,0,70);
  println(y);
  vertex(i+150,y+140);
  
}
endShape();

beginShape();
for(int i=0; i<k;i++){
  float y = map(data2[i],-1,1,0,70);
  println(y);
  vertex(i+150,y+250);
  
}
endShape();

beginShape();
for(int i=0; i<k;i++){
  float y = map(data3[i],-1,1,0,70);
  println(y);
  vertex(i+150,y+360);
  
}
endShape();



float val2 = map(int(list[1]),0,1023,0,100);
float val3 = map(int(list[2]),0,1023,0,100);

//line(k,y0+0*dy0,k,y0+0*dy0-val1);
//line(k,y0+1*dy0,k,y0+1*dy0-val2);
//line(k,y0+2*dy0,k,y0+2*dy0-val3);
//stroke(255);
//line(k+1,y0+0*dy0,k+1,y0+0*dy0-100);
//line(k+1,y0+1*dy0,k+1,y0+1*dy0-100);
//line(k+1,y0+2*dy0,k+1,y0+2*dy0-100);


if ( k< wide ){

  data[k] = sin(counter);
  data1[k] = cos(counter);
  data2[k] = sin(counter/2);
  data3[k] = cos(counter/2);

  
  k++;
}else{
  data[wide-1] = sin(counter);
  data1[wide-1] = cos(counter);
  data2[wide -1] = sin(counter/2);
  data3[wide-1] = cos(counter/2);
  for(int i=0; i<wide-1;i++){
  data[i] = data[i+1];
  data1[i] = data1[i+1];
  data2[i] = data2[i+1];
  data3[i] = data3[i+1];
  }
}
}

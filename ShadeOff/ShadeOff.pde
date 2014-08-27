/*
Brightness measuring
Floor Experiment

Brightness measuring from Floor.
A selection of arcs allows for measuring specific regions.
Designed for Design Tech program at Pasadena City College.

Author: Alberto Tam Yong
Date: 08-27-14
Note: The first code was written back in 2013. This is an attempt for its publication.
*/

import processing.video.*; //Webcam

Capture video; //Webcam

PrintWriter output; //File output
PFont f; //Text on screen

double brightestValue = 0; // Brightness of the brightest video pixel
int pictureVar = 1;
int ellipseVar = 0;
float startX,startY,diameter;
float[] tempPrevX = new float[20];
float[] tempPrevY = new float[20];
int[] diameterInt = new int[20];
int[] areaData = new int[20];
float[] brightnessFloat = new float[20];
float angleStart = 0;
float angleEnd = HALF_PI; //Clockwise
int arcIndex=0;
int[] textX = new int[20];
int[] textY = new int[20];

void setup() {
  String[] cameras = Capture.list();
  size(640,480, P2D); // Change size to 320 x 240 if too slow at 640 x 480
  // Uses the default video input, see the reference if this causes an error
  for(int i=0;i<cameras.length;i++)
  {
    print(i);
    print("\t");
    println(cameras[i]);
  }
  
  video = new Capture(this, cameras[39]); //Choose the camera that fits best for you
  video.start();
  
  for(int i=0; i<10; i++)
  {
    textX[i] = 0;
    textY[i] = 0;
  }
  
  stroke(0);
  smooth();
  f=createFont("Arial",20,true);
  
  //Create text file for some datalog
  output = createWriter("Room-"+String.valueOf(year())+String.valueOf(month())+String.valueOf(day())+".txt");
}

void draw()
{
  if(video.available())
  {
    video.read();
    image(video,0,0,width,height);
    video.loadPixels();
    
    textFont(f,20);
    
    int arcPrinted = 1; //Counts arcs
    while(arcIndex != arcPrinted && arcIndex > 0)
    {
      text(brightnessFloat[arcPrinted],textX[arcPrinted],textY[arcPrinted]);
      arc(startX,startY,diameterInt[arcPrinted],diameterInt[arcPrinted],angleStart,angleEnd);
      arcPrinted++;
    }
    //print("("+mouseX+","+mouseY+") ");
    //print(brightness((mouseY-1)*width + mouseX));
    //println();
  }
}

void circleBrightness(int arcNumber)
{
  int index = 0;
  int xTempLengthOut;
  int xTempLengthInner;
  int oX = int(startX);
  int oY = int(startY);
  int pX = int(tempPrevX[arcNumber-1]);
  int pY = int(tempPrevY[arcNumber-1]);
  int radius = diameterInt[arcNumber]/2;
  int pradius = diameterInt[arcNumber-1]/2;
  double pixelPos;
  int target;
  
  //Identify (x,y) quadrant
  //Quadrant I
  if(int(startX) > width/2 && int(startY) < height/2)
  {
    brightestValue = 0;
    //Calculate brightness average
  for (int b = (oY); b < (oY+radius); b++)
  {
    xTempLengthOut = int(sqrt(sq(radius)-sq(oY-b)));
    if(pY > b)
    {
      xTempLengthInner = int(sqrt(sq(pradius)-sq(oY-b)));
    }
    else
    {
      xTempLengthInner = 0;
    }
    
    for (int a = (oX-xTempLengthOut); a < (oX-xTempLengthInner); a++)
    {
      print("("+a+","+b+")");
      print("\t");
      pixelPos = ((b-1)*width)+(a-1);
      //print(pixelPos);
      //print("\t");
      target = (int)pixelPos;
      // Get the color stored in the pixel
      int pixelValue = video.pixels[target];
      // Determine the brightness of the pixel
      float pixelBrightness = brightness(pixelValue);
      // If that value is brighter than any previous, then store the
      // brightness of that pixel, as well as its (x,y) location
        
      brightestValue += pixelBrightness;
        
      index++;
    }
  }
  noFill();
  brightestValue = brightestValue/index;
  brightnessFloat[arcIndex] = (float)brightestValue;
  }
  
  //Quadrant II
  else if(int(startX) < width/2 && int(startY) < height/2)
  {
    brightestValue = 0;
    //Calculate brightness average
  for (int b = (oY); b < (oY+radius); b++)
  {
    xTempLengthOut = int(sqrt(sq(radius)-sq(oY-b)));
    if(pY > b)
    {
      xTempLengthInner = int(sqrt(sq(pradius)-sq(oY-b)));
    }
    else
    {
      xTempLengthInner = 0;
    }
    
    for (int a = (oX+xTempLengthInner); a < (oX+xTempLengthOut); a++)
    {
      print("("+a+","+b+")");
      print("\t");
      pixelPos = ((b-1)*width)+(a-1);
      //print(pixelPos);
      //print("\t");
      target = (int)pixelPos;
      // Get the color stored in the pixel
      int pixelValue = video.pixels[target];
      // Determine the brightness of the pixel
      float pixelBrightness = brightness(pixelValue);
      // If that value is brighter than any previous, then store the
      // brightness of that pixel, as well as its (x,y) location
        
      brightestValue = brightestValue + pixelBrightness;
        
      index++;
    }
  }
  noFill();
  brightestValue = brightestValue/index;
  brightnessFloat[arcIndex] = (float)brightestValue;
  }
  
  //Quadrant III
  else if(int(startX) < width/2 && int(startY) > height/2)
  {
    brightestValue = 0;
    //Calculate brightness average
  for (int b = (oY-radius); b < (oY); b++)
  {
    xTempLengthOut = int(sqrt(sq(radius)-sq(oY-b)));
    if(pY < b)
    {
      xTempLengthInner = int(sqrt(sq(pradius)-sq(oY-b)));
    }
    else
    {
      xTempLengthInner = 0;
    }
    
    for (int a = (oX+xTempLengthInner); a < (oX+xTempLengthOut); a++)
    {
      print("("+a+","+b+")");
      print("\t");
      pixelPos = ((b-1)*width)+(a-1);
      //print(pixelPos);
      //print("\t");
      target = (int)pixelPos;
      // Get the color stored in the pixel
      int pixelValue = video.pixels[target];
      // Determine the brightness of the pixel
      float pixelBrightness = brightness(pixelValue);
      // If that value is brighter than any previous, then store the
      // brightness of that pixel, as well as its (x,y) location
        
      brightestValue = brightestValue + pixelBrightness;
        
      index++;
    }
  }
  noFill();
  brightestValue = brightestValue/index;
  brightnessFloat[arcIndex] = (float)brightestValue;
  }
  
  //Quadrant IV
  else if(int(startX) > width/2 && int(startY) > height/2)
  {
    brightestValue = 0;
    //Calculate brightness average
  for (int b = (oY-radius); b < (oY); b++)
  {
    xTempLengthOut = int(sqrt(sq(radius)-sq(oY-b)));
    if(pY < b)
    {
      xTempLengthInner = int(sqrt(sq(pradius)-sq(oY-b)));
    }
    else
    {
      xTempLengthInner = 0;
    }
    
    for (int a = (oX-xTempLengthOut); a < (oX-xTempLengthInner); a++)
    {
      print("("+a+","+b+")");
      print("\t");
      pixelPos = ((b-1)*width)+(a-1);
      //print(pixelPos);
      //print("\t");
      target = (int)pixelPos;
      // Get the color stored in the pixel
      int pixelValue = video.pixels[target];
      // Determine the brightness of the pixel
      float pixelBrightness = brightness(pixelValue);
      // If that value is brighter than any previous, then store the
      // brightness of that pixel, as well as its (x,y) location
        
      brightestValue = brightestValue + pixelBrightness;
        
      index++;
    }
  }
  noFill();
  brightestValue = brightestValue/index;
  brightnessFloat[arcIndex] = (float)brightestValue;
  }
}

void mousePressed()
{
  if(mouseButton == RIGHT && ellipseVar == 0)
  {
    //noStroke();
    startX=mouseX;
    startY=mouseY;
    tempPrevX[0] = mouseX;
    tempPrevY[0] = mouseY;
    ellipseVar=1;
    arcIndex = 1;
    diameterInt[0] = 0;
  }
  else if(mouseButton == RIGHT && ellipseVar == 1)
  {
    stroke(0);
    diameter=(2*(sqrt(sq(abs(startX-mouseX))+sq(abs(startY-mouseY)))));
    diameterInt[arcIndex] = int(diameter);
    
    //Quadrant I
    if(int(startX) > width/2 && int(startY) < height/2)
    {
      textX[arcIndex] = 100;
      textY[arcIndex] = 200 + arcIndex*25;
      angleStart = HALF_PI;
      angleEnd = PI;
      tempPrevX[arcIndex] = startX-(diameterInt[arcIndex-1]/2);
      tempPrevY[arcIndex] = startY+(diameterInt[arcIndex-1]/2);
    }
    
    //Quadrant II
    else if(int(startX) < width/2 && int(startY) < height/2)
    {
      textX[arcIndex] = 500;
      textY[arcIndex] = 200 + arcIndex*25;
      angleStart = 0;
      angleEnd = HALF_PI;
      tempPrevX[arcIndex] = startX+(diameterInt[arcIndex-1]/2);
      tempPrevY[arcIndex] = startY+(diameterInt[arcIndex-1]/2);
    }
    
    //Quadrant III
    else if(int(startX) < width/2 && int(startY) > height/2)
    {
      textX[arcIndex] = 500;
      textY[arcIndex] = 50 + arcIndex*25;
      angleStart = PI+HALF_PI;
      angleEnd = 2*PI;
      tempPrevX[arcIndex] = startX+(diameterInt[arcIndex-1]/2);
      tempPrevY[arcIndex] = startY-(diameterInt[arcIndex-1]/2);
    }
    
    //Quadrant IV
    else if(int(startX) > width/2 && int(startY) > height/2)
    {
      textX[arcIndex] = 100;
      textY[arcIndex] = 50 + arcIndex*25;
      angleStart = PI;
      angleEnd = PI + HALF_PI;
      tempPrevX[arcIndex] = startX-(diameterInt[arcIndex-1]/2);
      tempPrevY[arcIndex] = startY-(diameterInt[arcIndex-1]/2);
    }
    
    circleBrightness(arcIndex);
    arcIndex++;
  }
  else
  {
    //Compose file name
    String picName = "Room-";
    String picNumber = strTimeRetrieval();;
    String picFormat = ".jpeg";
    
    String fileName = picName + picNumber + picFormat;
  
    //Store log in text file
    output.print(fileName);
    for(int i = 1; i < arcIndex; i++)
    {
      output.print("\t");
      output.print("("+i+")"+brightnessFloat[arcIndex]);
    }
    output.println();
    
    //Take snapshot and save
    save(fileName);
  }
}

void keyPressed()
{
  //Exit protocol
  if(key == ESC)
  {
    output.flush();
    output.close();
    exit();
  }
  else if(key == 'r')
  {
    for(int i = 0; i <= arcIndex; i++)
    {
      brightnessFloat[arcIndex] = 0;
    }
    brightestValue = 0;
    arcIndex = 0;
    ellipseVar = 0;
  }
}

String strTimeRetrieval()
{
  //Compose a String with date and time stamp
  String year,month,day,hour,minute,second;
  year = String.valueOf(year());
  month = (month() < 10? "0" + String.valueOf(month()) : String.valueOf(month()));
  day = (day() < 10? "0" + String.valueOf(day()) : String.valueOf(day()));
  hour = String.valueOf(hour());
  minute = String.valueOf(minute());
  second = String.valueOf(second());
  return year+month+day+hour+minute+second;
}


/*
Brightness measuring
Wall Experiment

Brightness measuring from Walls. Measures and draws it.
Designed for Design Tech program at Pasadena City College.

Author: Alberto Tam Yong
Date: 08-27-14
Note: The first code was written back in 2013. This is an attempt for its publication.
*/

import processing.video.*; //Required for Capture, webcam features

Capture video; //Object used for webcam
PrintWriter output; //Used to write to write to file
PFont f; //Required for writing text
double brightestValue = 0; // Brightness of the brightest video pixel

int sideRight_currentLine = 0;
int numberOfSideRightLines = 20;
int[] sideRightLines = new int[numberOfSideRightLines];
int sideRight_fontSize = (8*height)/(10*numberOfSideRightLines);
int sideRight_marginX = 10;

void setup() {
  String[] cameras = Capture.list(); //Retrieve list of available camera devices and modes
  size(640,480, P2D); // Change size to 320 x 240 if too slow at 640 x 480
  
  for(int i=0;i<cameras.length;i++)
  {
    //Show numbered list of cameras and modes available
    print(i);
    print("\t");
    println(cameras[i]);
  }
  
  //Select camera and mode. Change the number inside cameras[ ] for selection.
  video = new Capture(this, cameras[37]);
  video.start();
  
  fill(255,255,255);
  noStroke();
  smooth();
  background(0,0,0); //RGB Color Black for background
  
  f = createFont("Arial",20,true);
  output = createWriter(String.valueOf(year())+String.valueOf(month())+String.valueOf(day())+".txt");
  
  for(int i=0; i < numberOfSideRightLines; i++)
  {
    sideRightLines[i] = i*height/numberOfSideRightLines;
  }
}

void draw() {
  if (video.available()) {
    video.read();
    image(video, 0, 0, 8*width/10, 8*height/10); // Draw the webcam video onto the screen
    //Modified to use only 80% of the screen
    int brightestX = 0; // X-coordinate of the brightest video pixel
    int brightestY = 0; // Y-coordinate of the brightest video pixel
    
    // Search for the brightest pixel: For each row of pixels in the video image and
    // for each pixel in the yth row, compute each pixel's index in the video
    video.loadPixels();
    int index = 0;
    brightestValue = 0;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
        // Get the color stored in the pixel
        int pixelValue = video.pixels[index];
        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);
        // If that value is brighter than any previous, then store the
        // brightness of that pixel, as well as its (x,y) location
        
        /*if (pixelBrightness > brightestValue) {
          brightestValue = pixelBrightness;
          brightestY = y;
          brightestX = x;
        }*/
        
        brightestValue = brightestValue + pixelBrightness;
        
        index++;
      }
    }
    // Draw a large, yellow circle at the brightest pixel
    //fill(255, 204, 0, 128);
    noFill();
    brightestValue = brightestValue/index;
    
    textFont(f,20);
    fill(255,255,255);
    float temp = (float)brightestValue;
    text(temp,100,100);
    //output.println(brightestValue);
    //ellipse(brightestX, brightestY, 200, 200);
  }
}

void mousePressed()
{
  //Compose file name
  String picName = "Wall ";
  String picNumber = strTimeRetrieval();;
  String picFormat = ".jpeg";
  
  String fileName = picName + picNumber + picFormat;
  
  //Store log in text file
  output.print(fileName);
  output.print("\t");
  output.println(brightestValue);
  
  //Isolate camera. Take snapshot and save
  
  save(fileName);
  
  //Show new file on Side Right panel
  //textFont(f,8/10*height/numberOfSideRightLines);
  textFont(f,sideRight_fontSize);
  text(fileName,(8/10*width)+sideRight_marginX,sideRightLines[sideRight_currentLine]+sideRight_fontSize);
  if(sideRight_currentLine <= numberOfSideRightLines)
  {
    sideRight_currentLine++;
  }
  else
  {
    sideRight_currentLine = 0;
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
  

void keyPressed()
{
  //Exit protocol
  if(key == ESC)
  {
    output.flush();
    output.close();
    exit();
  }
}



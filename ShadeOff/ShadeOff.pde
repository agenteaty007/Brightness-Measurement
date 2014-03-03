/*
Brightness measuring measures and draws it

Original File Version: Brightness_Measurement_v109
*/

import processing.video.*;

Capture video;

PrintWriter output;

PFont f;

double brightestValue = 0; // Brightness of the brightest video pixel
int pictureVar = 1;
int ellipseVar = 0;
float startX,startY,diameter;
float[] tempPrevX = new float[10];
float[] tempPrevY = new float[10];
int[] diameterInt = new int[10];
int[] areaData = new int[10];
float[] brightnessFloat = new float[10];
float angleStart = 0;
int arcIndex=0;

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
  video = new Capture(this, cameras[3]);
  //Lenovo
  //#3 for external webcam
  //#1 for embedded webcam
  video.start();  
  stroke(0);
  smooth();
  f=createFont("Arial",20,true);
  output = createWriter("brightness.txt");
}

void draw() {
  if (video.available()) {
    video.read();
    image(video, 0, 0, width, height); // Draw the webcam video onto the screen
    int brightestX = 0; // X-coordinate of the brightest video pixel
    int brightestY = 0; // Y-coordinate of the brightest video pixel
    
    // Search for the brightest pixel: For each row of pixels in the video image and
    // for each pixel in the yth row, compute each pixel's index in the video
    video.loadPixels();
    
    /*
    int index = 0;
    float xTempLength;
    float oX = startX;
    float oY = startY;
    int target;
    for (float y = (oY-radius); y < (oY+radius); y++)
    {
      xTempLength = sqrt(sq(radius)-sq(oY-y));
      for (float x = (oX-xTempLength); x < (oX+xTempLength); x++)
      {
        target = int(((y-1)*width)+(x+1));
        
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
    
    // Draw a large, yellow circle at the brightest pixel
    //fill(255, 204, 0, 128);
    noFill();
    brightestValue = brightestValue/index;
    
    */
    
    textFont(f,20);
    //text(brightnessFloat,100,50);
    int arcPrinted = 1;
    while(arcIndex != arcPrinted && arcIndex > 0)
    {
      text(brightnessFloat[arcPrinted],500,50+(arcPrinted*25));
      //text(diameterInt[arcPrinted]/2,50,50+(arcPrinted*25));
      arc(startX,startY,diameterInt[arcPrinted],diameterInt[arcPrinted], angleStart,angleStart+HALF_PI);
      arcPrinted++;
    
    }
    //output.println(brightestValue);
    //ellipse(brightestX, brightestY, 200, 200);
  }
}

void circleBrightness(int arcNumber)
{
  int index = 0;
    int xTempLength;
    int xTempLengthInner;
    int oX = int(startX);
    int oY = int(startY);
    int pX = int(tempPrevX[arcNumber-1]);
    int pY = int(tempPrevY[arcNumber-1]);
    int radius = diameterInt[arcNumber]/2;
    int pradius = diameterInt[arcNumber-1]/2;
    double pixelPos;
    int target;
    for (int b = (oY); b < (oY+radius); b++)
    {
      //print(b);
      //print("\t");
      xTempLength = int(sqrt(sq(radius)-sq(oY-b)));
      if(pY < b)
      {
        xTempLengthInner = int(sqrt(sq(pradius)-sq(oY-b)));
      }
      else
      {
        xTempLengthInner = 0;
      }
      //print(xTempLength);
      //print("\t");
      for (int a = (oX+xTempLengthInner); a < (oX+xTempLength); a++)
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
    
    // Draw a large, yellow circle at the brightest pixel
    //fill(255, 204, 0, 128);
    noFill();
    brightestValue = brightestValue/index;
    brightnessFloat[arcIndex] = (float)brightestValue;
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
    diameter=(2*(sqrt(sq(startX-mouseX)+sq(startY-mouseY))));
    diameterInt[arcIndex] = int(diameter);
    tempPrevX[arcIndex] = startX+(diameterInt[arcIndex-1]/2);
    tempPrevY[arcIndex] = startY-(diameterInt[arcIndex-1]/2);
    //ellipseVar=0;
    circleBrightness(arcIndex);
    arcIndex++;
  }
  else
  {
    String picName = "Sample";
    String picNumber = str(pictureVar);
    String picFormat = ".jpeg";
    output.print(picName+picNumber);
    output.print("\t");
    output.println(brightestValue);
    save(picName+picNumber+picFormat);
    //output.flush();
    //output.close();
    //exit();
    pictureVar++;
  }
}

void keyPressed()
{
  //output.println(brightestValue);
  output.flush();
  output.close();
  exit();
}

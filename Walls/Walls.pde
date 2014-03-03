/*
Brightness measuring

Original File Version: Brightness_Measurement_v102
*/


import processing.video.*;

Capture video;

PrintWriter output;

PFont f;

double brightestValue = 0; // Brightness of the brightest video pixel
int pictureVar = 1;

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
  video.start();  
  noStroke();
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
    float temp = (float)brightestValue;
    text(temp,100,100);
    //output.println(brightestValue);
    //ellipse(brightestX, brightestY, 200, 200);
  }
}

void mousePressed()
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

void keyPressed()
{
  //output.println(brightestValue);
  output.flush();
  output.close();
  exit();
}

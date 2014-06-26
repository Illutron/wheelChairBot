/**
 * <p>Ketai Sensor Library for Android: http://KetaiProject.org</p> https://code.google.com/p/ketai/
 *
 * <p>Ketai Camera Features:
 * <ul>
 * <li>Interface for built-in camera</li>
 * <li></li>
 * </ul>
 * <p>Updated: 2012-10-21 Daniel Sauter/j.duran</p>
 */

import ketai.camera.*;
import ketai.cv.facedetector.*;

PImage a;  // Declare variable "a" of type PImage
PImage myImage;
int MAX_FACES = 20;
KetaiSimpleFace[] faces = new KetaiSimpleFace[MAX_FACES];

KetaiCamera cam;

void setup() {
  orientation(LANDSCAPE);

  cam = new KetaiCamera(this, 320, 240, 24);
  cam.setCameraID(1);
  
}

void draw() {
  image(cam,0,0);
  
  faces = KetaiFaceDetector.findFaces(cam, MAX_FACES); 
 
  for (int i=0; i < faces.length; i++)
  {
    //We only get the distance between the eyes so we base our bounding box off of that 
    rect(faces[i].location.x, faces[i].location.y, 2.5*faces[i].distance, 3*faces[i].distance);
  }
}

void onCameraPreviewEvent()
{
  cam.read();
}

// start/stop camera preview by tapping the screen
void mousePressed()
{
  if (cam.isStarted())
  {
    cam.stop();
  }
  else
    cam.start();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == MENU) {
      if (cam.isFlashEnabled())
        cam.disableFlash();
      else
        cam.enableFlash();
    }
  }
}

void onPause()
{
  super.onPause();
  // Make sure to releae the camera when we go
  // to sleep otherwise it stays locked
  if (cam != null && cam.isStarted())
    cam.stop();
}

void exit() {
  cam.stop();
}


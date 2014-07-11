import ketai.camera.*;
import ketai.cv.facedetector.*;


PImage a;  // Declare variable "a" of type PImage
PImage myImage;
int MAX_FACES = 20;
KetaiSimpleFace[] faces = new KetaiSimpleFace[MAX_FACES];
int numFaces = 0;
KetaiCamera cam;

void cam_setup() {
  cam = new KetaiCamera(this, 640, 480, 24);
  cam.setCameraID(1);
  cam.start();
}

void cam_update() {
  image(cam, 0, 0);

  faces = KetaiFaceDetector.findFaces(cam, MAX_FACES); 
  int largestFace = -1;
  int largestFaceID = 0;
  for (int i=0; i < faces.length; i++)
  {
    //We only get the distance between the eyes so we base our bounding box off of that 
    rect(faces[i].location.x, faces[i].location.y, 2.5*faces[i].distance, 3*faces[i].distance);
    if (faces[i].distance > largestFace)
    {
      largestFace = (int)faces[i].distance;
      largestFaceID = i;
    }
  }
  if (faces.length >0)
  {
    com_sendData(P_FACECOUNT, faces.length);
    com_sendData(P_FACEX, faces[largestFaceID].location.x);
    com_sendData(P_FACEY, faces[largestFaceID].location.y);
    com_sendData(P_FACEZ, faces[largestFaceID].distance);
    numFaces = faces.length;
  }
  if(numFaces > 0 && faces.length == 0)
  {
      com_sendData(P_FACECOUNT, 0);
  }
}

void onCameraPreviewEvent()
{
  cam.read();
}


/*
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
 */

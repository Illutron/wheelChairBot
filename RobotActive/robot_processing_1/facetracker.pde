import ketai.camera.*;
import ketai.cv.facedetector.*;


PImage a;  // Declare variable "a" of type PImage
PImage myImage;
int MAX_FACES = 20;
KetaiSimpleFace[] faces = new KetaiSimpleFace[MAX_FACES];
float numFaces = 0;
float numFacesOld = 0;
KetaiCamera cam;
int largestFace = -1;
int largestFaceID = 0;


void cam_setup() {
  cam = new KetaiCamera(this, 320, 240, 24);
  cam.setCameraID(1);
  
  cam.start();
  faces = KetaiFaceDetector.findFaces(cam, MAX_FACES); 
}

void cam_update() {
  image(cam, 0, 0);
  
  for (int i=0; i < faces.length; i++)
    {
      //We only get the distance between the eyes so we base our bounding box off of that 
      rect(faces[i].location.x, faces[i].location.y, 2.5*faces[i].distance, 3*faces[i].distance);
     
    }
}

int cam_refresh = 0;
void onCameraPreviewEvent()
{
  cam.read();
  cam_refresh = (cam_refresh+1 ) % 6;
  if (cam_refresh ==0)
  {
    faces = KetaiFaceDetector.findFaces(cam, MAX_FACES); 
    largestFace = -1;
    largestFaceID = 0;
    for (int i=0; i < faces.length; i++)
    {
      //We only get the distance between the eyes so we base our bounding box off of that 
      if (faces[i].distance > largestFace)
      {
        largestFace = (int)faces[i].distance;
        largestFaceID = i;
      }
    }
    if (faces.length >0)
    {

      com_sendData(P_FACEX, camNorm(faces[largestFaceID].location.x));
      com_sendData(P_FACEY, camNorm(faces[largestFaceID].location.y));
      com_sendData(P_FACEZ, camNorm(faces[largestFaceID].distance));
      debug_set_value(7, camNorm(faces[largestFaceID].distance));
    }
    numFaces = numFaces * 0.80f + faces.length*0.20f;
    if (numFaces < 0.3f && numFacesOld>= 0.3f)
    {

      
    }
    if (round(numFaces) != round(numFacesOld))
    {
      com_sendData(P_FACECOUNT, round(numFaces) );
   
    }
    numFacesOld = numFaces;
  }
}

short camNorm(float value)
{
  return (short)constrain(round(map(value, 0, cam.width, 0, 1000)), 0, 1000);
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

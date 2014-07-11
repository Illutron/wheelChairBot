
import android.util.Log;

void setup()
{
  orientation(PORTRAIT);
  et_begin();
  cam_setup();
  sampler_begin();

  textSize(40);
}


void draw()
{ 
  //LOGIC
  com_statemachine();

  // DRAW
  background(100);

  debug_set_value(0, (int)millis());
  debug_set_value(1, numFaces);
  cam_update();
  debug_draw(displayHeight/2, displayHeight/2+20);

  // Hearbeat
  if ((long)(myMillis()/1000) % 2 == 0)
  {
    fill(255, 0, 0);
    ellipse(100, 100, 50, 50);
  }
}

void mouseMoved()
{
}

/*
void onResume()
 {
 cam.start();
 }
 
 void onPause()
 {
 super.onPause();
 // Make sure to releae the camera when we go
 // to sleep otherwise it stays locked
 if (cam != null && cam.isStarted())
 cam.stop();
 usb_found = false;
 }
 
 void exit() {
 cam.stop();
 }
 */
long myMillis()
{
  return System.currentTimeMillis();
}


// Easytransfer
/*
  while (et_receive ())
 {
 data.param=1;
 
 et_send(data);
 
 
 
 noStroke();
 
 ellipse(((pos++))%displayWidth, data.value+500, 2, 2);
 }
 */

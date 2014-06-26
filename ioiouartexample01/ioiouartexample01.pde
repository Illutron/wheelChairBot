/* IOIO Test 2 -
 * Toggling the onboard LED on the IOIO board and changing rectangle size through Processing in Android mode
 * by Ben Leduc-Mills
 * This code is Beerware - feel free to reuse and credit me, and if it helped you out and we meet someday, buy me a beer.
 */
 
//import apwdidgets
import apwidgets.*;
 
//import ioio
import ioio.lib.util.*;
import ioio.lib.impl.*;
import ioio.lib.api.*;
import ioio.lib.api.exception.*;
import ioio.lib.api.Uart;
import ioio.lib.api.IOIO;
import ioio.lib.api.DigitalOutput;

import java.io.InputStream;
import java.io.OutputStream;

import android.util.Log;

import java.util.Random;

String receivedData;
//make a widget container and a button
APWidgetContainer widgetContainer;
APButton button1;
 
//our rectangle size
int rectSize = 100;
 
 int BYTE_COUNT = 2000;
 final int SEED = 17;
 
//boolean to turn the light on or off
boolean lightOn = false;

int bytesVerified_;

//create a IOIO instance
IOIO ioio = IOIOFactory.create();
 
//create a thread for our IOIO code
myIOIOThread thread1; 
 
void setup() {
 
  //instantiate our thread
  thread1 = new myIOIOThread("thread1", 100);
  //start our thread
  thread1.start();
 
  size(480, 800);
  smooth();
  noStroke();
  fill(255);
  rectMode(CENTER);     //This sets all rectangles to draw from the center point
 
  //create new container for widgets
  widgetContainer = new APWidgetContainer(this); 
 
  //create new button from x- and y-pos. and label. size determined by text content
  button1 = new APButton(10, 10, "Toggle LED"); 
 
  //place button in container
  widgetContainer.addWidget(button1);
  
  
  text("hi", 40, 40);
}
 
void draw() {
  background(#FF9900);
  rect(width/2, height/2, rectSize, rectSize);
}
 
//onClickWidget is called when a widget is clicked/touched
void onClickWidget(APWidget widget) {
 
  if (widget == button1) { //if it was button1 that was clicked
    //rectSize = 100; //set the smaller size
 
    if (lightOn == true) {
      lightOn = false;
      rectSize = 50;
    }
    else if (lightOn == false) {
      lightOn = true;
      rectSize = 100;
    }
  }
}


/* This is our thread class, it's a subclass of the standard thread class that comes with Processing
 * we're not really doing anything dramatic, just using the start and run methods to control our interactions with the IOIO board
 */
 
class myIOIOThread extends Thread {
 
  boolean running;  //is our thread running?
  String id; //in case we want to name our thread
  int wait; //how often our thread should run
  DigitalOutput led;  //DigitalOutput type for the onboard led
  Uart uart;
  int rxPin = 10;
  int txPin = 11;
  int baud = 115200;
  InputStream in;
  OutputStream out;
  
  int count; //if we wanted our thread to timeout, we could put a counter on it, I don't use it in this sketch
 
  //our constructor
  myIOIOThread(String s, int w) {
    id = s;
    wait = w;
    running = false;
    count = 0;
  }
 
  //override the start method
  void start() {
    running = true;
 
    //try connecting to the IOIO board, handle the case where we cannot or the connection is lost
    try {
      IOIOConnect();  //this function is down below and not part of the IOIO library
    }
    catch (ConnectionLostException e) {
    }
 
    //try setting our led pin to the onboard led, which has a constant 'LED_PIN' associated with it
    try {
      
      led = ioio.openDigitalOutput(IOIO.LED_PIN);
      //ioio.openDigitalOutput(ioio.lib.api.DigitalOutput.Spec.Mode.OPEN_DRAIN, txPin);
      
      uart = ioio.openUart(rxPin, txPin, baud, Uart.Parity.NONE, Uart.StopBits.ONE, OP_OPEN_DRAIN);
      
      //uart = ioio.openUart("uart",rxPin,Uart.IP_FLOATING,txPin,Uart.OP_OPEN_DRAIN, baud, Uart.Parity.NONE,Uart.StopBits.ONE);
      
      print("Opening uart");
        
      in  = uart.getInputStream();
      out = uart.getOutputStream();
      
      Random rand = new Random(SEED);
      
      Thread reader = new ReaderThread(in, SEED, BYTE_COUNT);
      reader.start();
       
    }
    catch (ConnectionLostException e) {
    }
 
    //don't forget this
    super.start();
  }
 
  //start automatically calls run for you
  void run() {
 
    //while our sketch is running, keep track of the lightOn boolean, and turn on or off the led accordingly
    while (running) {
      //count++;
 
      //again, we have to catch a bad connection exception
      try {
        led.write(lightOn);
        if(lightOn) {
          out.write(0xFF);
        } else {
          out.write('b');
        }
      }
      catch (ConnectionLostException e) {
      }
      catch (IOException e) {
        print(e);
      }
 
      try {
        //sleep((long)(wait));
      }
      catch (Exception e) {
      }
      
    }
  }
 
 //often we may want to quit or stop or thread, so I include this here but I'm not using it in this sketch
  void quit() {
    running = false;
    uart.close();
    ioio.disconnect();
    interrupt();
  }
 
//a simple little method to try connecting to the IOIO board
  void IOIOConnect() throws ConnectionLostException {
 
    try {
      ioio.waitForConnect();
    }
    catch (IncompatibilityException e) {
    }
  }
}


class ReaderThread extends Thread {
    private InputStream in_;
    private Random rand_;
    private int count_;

    public ReaderThread(InputStream in, int seed, int count) {
      in_ = in;
      rand_ = new Random(seed);
      count_ = count;
    }

    @Override
    public void run() {
      super.run();
      try {
        while (count_-- > 0) {
          int expected = rand_.nextInt() & 0xFF;
          int read = in_.read();
          if (read != expected) {
            Log.e("IOIOTortureTest", "Expected: " + expected + " got: " + read);
            return;
          } else {
            bytesVerified_++;
          }
        }
      } catch (IOException e) {
      }
    }
}


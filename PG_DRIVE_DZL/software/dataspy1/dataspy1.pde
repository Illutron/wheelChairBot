/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */


import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port

void setup() 
{
  size(200, 200);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
//  myPort = new Serial(this, portName, 19200);
  myPort = new Serial(this, Serial.list()[0], 19200,'E',8,1.0);  
}

int t0=0;
int icmp=0;

boolean sync=false;
int counter=0;

int dptr=0;
int data[]=new int[100];

void draw()
{
  while ( myPort.available () > 0)
  {  // If data is available,
    val = myPort.read();         // read it and store it in val
    if (sync==true)
    {
//      print(val+"\t");
      if (counter<9)
      {
//        print(hex(val,2));
//        print(" ");
        counter++;

        data[counter]=val;

      }
      else
      {
//        print(millis()-t0);
        t0=millis();

        for(int i=0;i<11;i++)
        {
          print(hex(data[i],2));
          print(" ");
        }
        
        int crc=data[0]+data[1]+data[2]+data[3];
        print(hex(0xffff-crc,4));
        print(" ");


        println(" "+icmp);
        icmp++;

        counter=0;
        sync=false;
      }
    }
    else
    {
      if (val==0x6A)
      {
        counter=0;
        data[counter]=val;
        sync=true;

      }
    }
  }
}





/*

 // Wiring / Arduino Code
 // Code for sensing a switch status and writing the value to the serial port.
 
 int switchPin = 4;                       // Switch connected to pin 4
 
 void setup() {
 pinMode(switchPin, INPUT);             // Set pin 0 as an input
 Serial.begin(9600);                    // Start serial communication at 9600 bps
 }
 
 void loop() {
 if (digitalRead(switchPin) == HIGH) {  // If switch is ON,
 Serial.write(1);               // send 1 to Processing
 } else {                               // If the switch is not ON,
 Serial.write(0);               // send 0 to Processing
 }
 delay(100);                            // Wait 100 milliseconds
 }
 
 */

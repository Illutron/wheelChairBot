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

int sync=0;
int counter=0;

int dptr=0;
int data[]=new int[100];

void draw()
{
  while ( myPort.available () > 0)
  {  // If data is available,
    val = myPort.read();         // read it and store it in val

    switch(sync)
    {
      case 0:
        if(val==0x6A)
        {
          sync=1;
          counter=0;
          data[counter++]=val;
        }
      break;
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
        sync++;
        data[counter++]=val;
      break;

      case 9:
        sync=0;
        data[counter++]=val;
  
      for(int i=0;i<10;i++)
        {
          print(hex(data[i],2));
          print(" ");
          if(i==5)
          {
           print(" CRC:");
           print(hex(0xffff-(data[0]+data[1]+data[2]+data[3]+data[4]),2 )) ;       
           print("  ");
          }
        }
        print("CRC:");
        
        print(hex(0xffff-(data[6]+data[7]+data[8]),2 )) ;       
        
        println();
    
    
    
        
      break;
    
    
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

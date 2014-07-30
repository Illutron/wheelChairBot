#include <easycom.h>

#define SET(x,y) (x |=(1<<y))
#define CLR(x,y) (x &= (~(1<<y)))
#define CHK(x,y) (x & (1<<y))
#define TOG(x,y) (x^=(1<<y))

#define PGP_ENABLE 6
#define PGP_ACTUATOR 7

easyCom com;  //-Create instance of radio (only one supported )


void setup() {
  Serial.begin(19200, SERIAL_8E1);
  com.begin();
  pinMode(PGP_ENABLE, OUTPUT);
  pinMode(PGP_ACTUATOR, OUTPUT);
  delay(1000);
  digitalWrite(PGP_ENABLE, HIGH);
  unsigned char nodeID[] = {
    0x65, 0x65, 0x65, 0x65, 0x65
  };//-I used this ID for getting the ID from the handset. Handset returns a,b,c,d,0x56,0xaa,0x40,0x00 ID to use is then: a,b,c,d,0xC1
  //  unsigned char nodeID[]={0x69,0x80,0x55,0x11,0xc1}; //-My handset had this ID
  com.setID(nodeID);
  com.setChannel(0x3C);  //-The HCD base channel (you may choose something different)
}

unsigned long timer = 0;
unsigned long timer1 = 0;
unsigned char data[255];
unsigned char cphase = 0;
unsigned int control = 0b0000010000000000;//0x0400 bit need to be set for drive relay other bits control actuators and lights
unsigned char cptr = 0;

int drive = 0;
int turn = 0;

boolean bound = false;

void loop()
{

  //***********************************************************
  //  Generate and send drive data packet
  //***********************************************************

  if (millis() >= timer)
  {
    timer += 20;
    //    int drive = (analogRead(0) - 512) / 5;                    //-Read joystick pot
    //    int turn = (analogRead(1) - 512) / 5;                     //-Read joystick pot

    if (drive > 100)
      drive = 100;
    if (drive < -100)
      drive = -100;

    if (turn > 100)
      turn = 100;
    if (turn < -100)
      turn = -100;

    data[0] = 0x6A;                                            //-Datagram always start with 0x6A
    data[1] = drive;                                           //-Drive +-100
    data[2] = turn;                                            //-Turn +-100
    data[3] = 0;                                               //-TBD
    data[4] = 0x0c;                                            //-Drive mode: 0x0c=fastest
    data[5] = 0xff - (data[0] + data[1] + data[2] + data[3] + data[4]); //-Checksum

    for (unsigned char i = 0; i < 6; i++)
    {
      Serial.write(data[i]);
    }
    timer1 = micros() + 100;                                   //-Start sending actuator packet
    cphase = 0;                                                //
  }





  if (cphase == 4)
  {

    unsigned char n = com.available();      //-Get buffer length
    if (n)                                  //-If anything available we _must_ call getBuffer() or read the individual bytes using read()
    {
      unsigned char *p = com.getBuffer();  //-Note buffer only available until next com.available() call
      if (!bound)
      {
        if (n == 8)
        {
          unsigned char nodeID[] = {
            0, 0, 0, 0, 0xC1
          };
          nodeID[0] = p[0];
          nodeID[1] = p[1];
          nodeID[2] = p[2];
          nodeID[3] = p[3];
          com.setID(nodeID);
          //        Serial.println("Found handset");
          bound = true;
        }
      }
      else
      {
        if (p[7] & 0x10)
        {
          if(p[3]>138)
            control|=0b0000000000001000;
          else if(p[3]<108)
            control|=0b0000000000000100;
          else
            control&=0b1111111111110011;
          
          if(p[4]>138)
            control|=0b0000000000000010;
          else if(p[4]<108)
            control|=0b0000000000000001;
          else
            control&=0b1111111111111100;

          if(p[1]>138)
            control|=0b0000000010000000;
          else if(p[1]<108)
            control|=0b0000000001000000;
          else
            control&=0b1111111100111111;


          if(p[0]>128)
          {
            control|=0b1100000000000000;
          }
          else if(p[0]<108)
          {
            control|=0b0000100000000000;
          }
          else
          {
            control&=0b0011011111111111;
          }


/*
          if(p[4]>138)
            control|=0b0000000000000000;
          if(p[4]>108)
            control&=0b1111111111111111;
*/

          drive =0;
          turn = 0;
        }
        else
        {
          drive = ((int)p[3] - 128);
          turn = -((int)p[4] - 128);
        }






        //     float dtrim = (float)((int)p[5] - 64) * 0.1;
        //      float ttrim = (float)((int)p[2] - 64) * 0.1;

        //      drive(d, t, dtrim, ttrim);

        /*      Serial.print(n);                     //-Print buffer length
         Serial.print(" ");
         for(unsigned char i=0;i<n;i++)       //-Print bytes
         {
         Serial.print(p[i],HEX);
         Serial.print(",");
         }
         Serial.println();
         */
      }
    }

  }





  //***********************************************************
  //  Generate actuator packet (wierd interface)
  //***********************************************************

  if (micros() >= timer1)
  {
    switch (cphase++)
    {
      case 0:
        if (cptr < 16)
        {
          digitalWrite(PGP_ACTUATOR, LOW);
          timer1 += 320;
        }
        else
        {
          digitalWrite(PGP_ACTUATOR, LOW);
          TOG(PORTB, 3);
          timer1 += 320;
          cptr = 0;
          cphase = 3;
        }
        break;
      case 1:
        digitalWrite(PGP_ACTUATOR, HIGH);
        timer1 += 160;
        break;
      case 2:
        timer1 += 160;

        cphase = 0;
        if (control & (0x8000 >> cptr))
        {
          digitalWrite(PGP_ACTUATOR, LOW);
        }
        cptr++;
        break;

      case 3:
        digitalWrite(PGP_ACTUATOR, HIGH);
        cphase = 4;
        timer1 += 48000;
        break;
    }
  }
}

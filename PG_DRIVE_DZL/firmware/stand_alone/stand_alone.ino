#define SET(x,y) (x |=(1<<y))
#define CLR(x,y) (x &= (~(1<<y)))
#define CHK(x,y) (x & (1<<y))
#define TOG(x,y) (x^=(1<<y))


void setup() {
  Serial.begin(19200, SERIAL_8E1);
  pinMode(13, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(11, OUTPUT);

}

unsigned long timer = 0;
unsigned long timer1 = 0;


unsigned char data[255];

unsigned char cphase = 0;

unsigned int control = 0b0000010000000000;//0x0400;
unsigned char cptr = 0;

void loop()
{
  
  if(millis()>=timer)
  {
    timer+=20;
    int drive=(analogRead(0)-512)/5;
    int turn=(analogRead(1)-512)/5;

    if(drive>100)
      drive=100;
    if(drive<-100)
      drive=-100;

    if(turn>100)
      turn=100;
    if(turn<-100)
      turn=-100;

    data[0]=0x6A;
    data[1]=drive;
    data[2]=turn;
    data[3]=0;
    data[4]=0x0c;
    data[5]=0xff-(data[0]+data[1]+data[2]+data[3]+data[4]);

    for(unsigned char i=0;i<6;i++)
    {
      Serial.write(data[i]);
    }

    timer1=micros()+100;
    cphase=0;
  }

  

  if (micros() >= timer1)
  {
    switch (cphase++)
    {
      case 0:
        if (cptr < 16)
        {
          digitalWrite(12, LOW);
          timer1 += 320;
        }
        else
        {
          digitalWrite(12, LOW);
          TOG(PORTB, 3);
          timer1 += 320;
          cptr = 0;
          cphase = 3;
        }
        break;
      case 1:
        digitalWrite(12, HIGH);
        timer1 += 160;
        break;
      case 2:
        timer1 += 160;

          cphase = 0;
          if (control & (0x8000 >> cptr))
          {
            digitalWrite(12, LOW);
          }
          cptr++;
        break;

      case 3:
        digitalWrite(12, HIGH);
        cphase = 4;
        timer1 += 48000;
        break;
    }
  }
}

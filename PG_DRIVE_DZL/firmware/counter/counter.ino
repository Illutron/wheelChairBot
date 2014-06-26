#define SET(x,y) (x |=(1<<y))
#define CLR(x,y) (x &= (~(1<<y)))
#define CHK(x,y) (x & (1<<y))
#define TOG(x,y) (x^=(1<<y))


void setup() {
  Serial.begin(19200,SERIAL_8E1);
  pinMode(13,OUTPUT);
  pinMode(12,OUTPUT);
}

unsigned long timer=0;

int counter=0;

void loop()
{
  while(Serial.available())
  {
    unsigned char c=Serial.read();
    Serial.write(c);
    TOG(PORTB,4);
    if(millis()-timer>2)
    {
      digitalWrite(13,LOW);    
    }
    else
      digitalWrite(13,HIGH);    
    timer=millis();    
  }
  
  
}

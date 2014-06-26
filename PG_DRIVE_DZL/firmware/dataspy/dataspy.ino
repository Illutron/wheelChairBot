void setup() {
  Serial.begin(19200,SERIAL_8E1);
  pinMode(13,OUTPUT);
}

unsigned long timer=0;

void loop()
{
  while(Serial.available())
  {
    unsigned char c=Serial.read();
    Serial.write(c);

    if(millis()-timer>2)
    {
      digitalWrite(13,LOW);    
    }
    else
      digitalWrite(13,HIGH);    
    timer=millis();    
  }
  
  
}

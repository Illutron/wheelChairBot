void setup() {
  Serial.begin(19200,SERIAL_8E1);
  pinMode(13,OUTPUT);
}

unsigned long timer=0;


unsigned char data[255];


void loop()
{
  if(millis()>=timer)
  {
    timer+=10;
    int drive=(analogRead(0)-512)/8;
    int turn=(analogRead(1)-512)/8;
    
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

   
    
  }  
  /*
  
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
  
  */
}

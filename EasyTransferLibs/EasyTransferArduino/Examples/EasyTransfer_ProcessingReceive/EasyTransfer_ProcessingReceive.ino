#include <EasyTransfer.h>

//create object
EasyTransfer ET; 

struct DATA_STRUCTURE{
  //put your variable definitions here for the data you want to receive
  //THIS MUST BE EXACTLY THE SAME ON THE OTHER ARDUINO
  int param;
  int value;
};

//give a name to the group of data
DATA_STRUCTURE mydata;
int delayBlink = 1;
void setup(){
  Serial.begin(115200);
  //start the library, pass in the data details and the name of the serial port. Can be Serial, Serial1, Serial2, etc. 
  ET.begin(details(mydata), &Serial);

  pinMode(13, OUTPUT);

}

void loop(){
  //check and see if a data packet has come in. 
  if(ET.receiveData())
  {
    if(mydata.param==1 )
    {
      delayBlink = mydata.value;
      mydata.param=2;
      analogWrite(11,delayBlink);
     // Serial.println(sizeof(mydata));
  
      ET.sendData();
      
    }
    //   

   

  }



}



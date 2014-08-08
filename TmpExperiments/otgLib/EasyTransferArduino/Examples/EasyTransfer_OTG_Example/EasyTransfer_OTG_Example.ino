#include <EasyTransfer.h>

//create object
EasyTransfer ET; 

struct SEND_DATA_STRUCTURE{
  //put your variable definitions here for the data you want to send
  //THIS MUST BE EXACTLY THE SAME ON THE OTHER ARDUINO
  int param;
  int value;
};

#define P_FACEX 1
#define P_FACEY 2
#define P_FACEZ 3
#define P_SOUND 4
#define P_RESET 5
#define P_STOP 6
#define P_FACECOUNT 7
#define P_DEBUG_CHAR 8
#define P_DEBUG_PARAM 9 
#define P_DEBUG_CLEAR 20

//give a name to the group of data
SEND_DATA_STRUCTURE mydata;

void setup(){
  Serial.begin(115200);
  //start the library, pass in the data details and the name of the serial port. Can be Serial, Serial1, Serial2, etc.
  ET.begin(details(mydata), &Serial);

  pinMode(13, OUTPUT);

  randomSeed(analogRead(0));

}

int value = 0;
long time = 0;

void loop(){
  //this is how you access the variables. [name of the group].[variable name]

  if(time < millis())
  {
    mydata.param = P_DEBUG_PARAM+4;
    mydata.value = (value ++ ) % 250;
    ET.sendData();
    time = millis()+25;
    
  
  }

  //send the data


    if(ET.receiveData()){
    if(mydata.param==1)
    {
      analogWrite(11,mydata.value);
    }
  }




}


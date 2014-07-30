#include <EasyTransfer.h>

#define P_FACEX 1 // face tracker vlaues are 0-1000
#define P_FACEY 2
#define P_FACEZ 3
#define P_SOUND 4
#define P_RESET 5
#define P_STOP 6
#define P_FACECOUNT 7
#define P_DEBUG_CHAR 8
#define P_DEBUG_PARAM 9 

#define SOUND_GOODBYE 0
#define SOUND_SING 1
#define SOUND_HELLO 2

#define STATE_EMERGENCY_STOP 0
#define STATE_HAS_TARGET 1
#define STATE_SEARCHING_FOR_TARGET 2

#define MOOD_STATE_CURIOUS 1   // asking questions, seeking out people
#define MOOD_STATE_TIRED 2     // staying away not saying much, heavy breathing
#define MOOD_STATE_CONFUSED 3  // move around a lot ask confused questions
#define MOOD_STATE_EXCITED 4   // greet people a lot HI HI HI - approach move jiggle 

int approachAfterTime  = 80000;
int getBoredAfterTime  = 120000;
int moodShiftAfterTime = 140000;

void(* resetFunc) (void) = 0;//declare reset function at address 0

//create object
EasyTransfer ET; 

struct SEND_DATA_STRUCTURE{
  // put your variable definitions here for the data you want to send
  // THIS MUST BE EXACTLY THE SAME ON THE OTHER ARDUINO
  int param;
  int value;
};

#define SET(x,y) (x |=(1<<y))
#define CLR(x,y) (x &= (~(1<<y)))
#define CHK(x,y) (x & (1<<y))
#define TOG(x,y) (x^=(1<<y))

#define PGP_ENABLE 6
#define PGP_ACTUATOR 7

// param 9 //  //turns statusled on and off 
bool statusLed = false;

// Coordinate of face in camera frame // -1 is no face detected
int faceX = 0;
int faceY = 0;
int faceZ = 0; 
int faceCount = 0;
int selectSound = 0;
bool emergencyStopActive = false; 
int stateTime = 0;
int moodStateTime = 0;

unsigned long driveTime = 0;

unsigned long headTiltTime  = 0;
unsigned long baseTiltTime  = 0;
unsigned long baseLevelTime = 0;

unsigned long headTurnTime = 0;

int headTiltDriveTime  = 2000;
int baseLevelDriveTime = 2000;
int baseTiltDriveTime  = 2000;

int headTurnDriveTime  = 2000;

int headTiltIdleTime   = 4000;
int baseLevelIdleTime  = 4000;
int baseTiltIdleTime  = 4000;

int headTurnIdleTime   = 4000;

int moodState = MOOD_STATE_CURIOUS;
int state = STATE_SEARCHING_FOR_TARGET;

long time = 0;

//give a name to the group of data
SEND_DATA_STRUCTURE mydata;

// robot control variables
unsigned long timer = 0;
unsigned long timer1 = 0;
unsigned char data[255];
unsigned char cphase = 0;
unsigned int control = 0b0000010000000000;//0x0400 bit need to be set for drive relay other bits control actuators and lights
// todo other bits for actuators

unsigned char cptr = 0;

int drive = 0;
int turn = 0;

int headTurn  = 0; // 0 off, 1 and 2 are directions
int headTilt  = 0;
int baseLevel = 0;
int baseTilt = 0;

bool lightsOn = false;

// we have a few different actuators too
bool bound = false;

/*float robotSpeedX = 0;
float robotSpeedY = 0;
float robotSpeedZ = 0;*/

// Virtual fence variables
int cornerFrontLeftHeat;
int cornerFrontRightHeat;
int cornerRearLeftHeat;
int cornerRearRightHeat;

void setup(){
  
  // drive
  Serial1.begin(19200, SERIAL_8E1);
  
  Serial.begin(115200);
  //start the library, pass in the data details and the name of the serial port. Can be Serial, Serial1, Serial2, etc.
  ET.begin(details(mydata), &Serial);
  
  pinMode(13, OUTPUT); // status led
  randomSeed(analogRead(0));
  
  pinMode(PGP_ENABLE, OUTPUT);
  pinMode(PGP_ACTUATOR, OUTPUT);
  delay(1000);
  digitalWrite(PGP_ENABLE, HIGH);
  unsigned char nodeID[] = {
    0x65, 0x65, 0x65, 0x65, 0x65
  };//-I used this ID for getting the ID from the handset. Handset returns a,b,c,d,0x56,0xaa,0x40,0x00 ID to use is then: a,b,c,d,0xC1
  //  unsigned char nodeID[]={0x69,0x80,0x55,0x11,0xc1}; //-My handset had this ID
  // com.setID(nodeID);
  //com.setChannel(0x3C);  //-The HCD base channel (you may choose something different)

}


void loop(){
  
  stateTime += 1;
  moodStateTime += 1;
  
  analogWrite(13, statusLed);
  
  if(ET.receiveData()){
    
    switch (mydata.param) {
      case P_FACEX:
        faceX = mydata.value;
        break;
      case P_FACEY:
        faceY = mydata.value;
        break;
      case P_FACEZ:
        faceZ = mydata.value;
        break;
      case P_RESET:
        if(mydata.value) {
          reset();
        }
        break;
      case P_STOP:
         if(mydata.value == 1) {
           state = STATE_EMERGENCY_STOP;
           stateTime = 0;
         }
        break;
      case P_FACECOUNT:
        
        if(mydata.value > faceCount) faceFound(mydata.value);
        
        if(mydata.value < faceCount) faceLost(mydata.value);  
        
        break;
      case P_DEBUG_PARAM:
        break;
    }
  }
  
  // Shift mode after set time and only if we are alone
  if(moodStateTime > moodShiftAfterTime && STATE_SEARCHING_FOR_TARGET) {
    moodStateTime = 0;
    
    moodState = int(random(4));
    
  }
  
  if(state == STATE_EMERGENCY_STOP) {
     drive = 0;
     turn = 0;
     headTilt = 0;
     headTurn = 0;
     // stop all other actuators
     
  } else if (state == STATE_SEARCHING_FOR_TARGET) {    
    
    drive = 0;
    turn  = 0;
    
    if(millis() - headTiltTime > headTiltIdleTime && headTilt == 0) { // move head after 4 seconds not moving head
      headTilt = random(1,3);
      headTiltTime = millis();
      headTiltDriveTime = random(100,2000);
    }
    
    if(millis() - headTiltTime > headTiltDriveTime && headTilt != 0) {
      headTilt = 0;
      headTiltTime = millis();
      headTiltIdleTime = random(100,20000);
    }
    
    /*
    if(millis() - headTurnTime > headTurnIdleTime && headTurn == 0) { // move head after 4 seconds not moving head
      headTurn = random(1,3);
      headTurnTime = millis();
      headTurnDriveTime = random(1000,40000);
    }
    
    if(millis() - headTurnTime > headTurnDriveTime && headTurn != 0) {
      headTurn = 0;
      headTurnTime = millis();
      headTurnIdleTime = random(100,10000);
    }
    */
    
    if(millis() - baseTiltTime > baseTiltIdleTime && baseTilt == 0) { // move head after 4 seconds not moving head
      baseTilt = random(1,3);
      baseTiltTime = millis();
      baseTiltDriveTime = random(100,2000);
    }
    
    if(millis() - baseTiltTime > baseTiltDriveTime && baseTilt != 0) {
      baseTilt = 0;
      baseTiltTime = millis();
      baseTiltIdleTime = random(100,20000);
    }
    
    if(millis() - baseLevelTime > baseLevelIdleTime && baseLevel == 0) { // move head after 4 seconds not moving head
      baseLevel = random(1,3);
      baseLevelTime = millis();
      baseLevelDriveTime = random(100,2000);
    }
    
    if(millis() - baseLevelTime > baseLevelDriveTime && baseLevel != 0) {
      baseLevel = 0;
      baseLevelTime = millis();
      baseLevelIdleTime = random(100,20000);
    }   
    
    
    // chooses direction, set timestamp
    
    // drive until virtualfence or timediff
      // then turn and repeat
      
    // turn head periodically
    
    // play sounds periodically
    
    
  } else if (state == STATE_HAS_TARGET) {
    // control actuators to point at target dont move base
    // scan target, curios 
    
    drive = 20;
    
    bool inBullseye = true;
    
    if(faceX > 550) {
      // face is to to the right
      inBullseye = false;
      turn = -40;
    
    } else if( faceX < 450) {
      // face is to the left
      inBullseye = false;
      turn = 40;
    }
    
    if(faceY > 550) {
      // face is up
       inBullseye = false;
    
    } else if(faceY < 450) {
      // face is down
       inBullseye = false;
    }
    
    
    if(inBullseye) {
      turn = 0;
      drive = 5;
      
    }
    
    if(stateTime > approachAfterTime) {
      // after time - maybe approach target cautiusly
      //drive = 80;
      // if distance is  over threshold 
          // approach
    }
    
    if(stateTime > getBoredAfterTime) {
      //drive = 0;
      // turn head away see if there is someone new
      
      // drive off 
      
      // look up or down
      
    }
    
    // after more time - search for someone new 
  }
  
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
      Serial1.write(data[i]);
    }
    timer1 = micros() + 100;                                   //-Start sending actuator packet
    cphase = 0;                                                //
  }
  
  
  if (cphase == 4) {
    
    if(baseLevel == 1) {
       control|=0b0000000000001000;
    } else if(baseLevel == 2) {
       control|=0b0000000000000100;
    } else {
       control&=0b1111111111110011;
    }
    
    if(headTilt == 1) {
       control|=0b0000000000000010;
    } else if(headTilt == 2) {
       control|=0b0000000000000001;
    } else {
       control&=0b1111111111111100;
    }
    
    
    if(baseTilt == 1) {
       control|=0b0000000010000000;
    } else if(baseTilt == 2) {
       control|=0b0000000001000000;
    } else {
       control&=0b1111111100111111;
    }

         /* if(p[1]>138)
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
          }*/         
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
  
  if(time < millis())
  {
    // Send data every 30 millis
    time = millis()+30;
    sendData(2, 1);
     
  }
}

void faceFound(int _faceCount) {
   if(faceCount == 0) {
     // we were alone before
     state = STATE_HAS_TARGET;
     stateTime = 0;
     sendData(P_SOUND, 0);
     
   }
   faceCount = _faceCount;
}

void faceLost(int _faceCount) {
   faceCount = _faceCount;
   
   if(faceCount == 0) {
     // ahh we lost all our friends sound
     state = STATE_SEARCHING_FOR_TARGET;
     stateTime = 0;
     
   } else {
     // someone left but there is still people
   }
   
}

void reset() {
  resetFunc();
}


void playSound() {
}

void sendData(int param, int value) {
 ET.sendData(); 
}



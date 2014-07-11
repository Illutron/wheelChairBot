/*
#define P_FACEX 1
 #define P_FACEY 2
 #define P_FACEZ 3
 #define P_SOUND 4
 #define P_RESET 5
 #define P_STOP 6
 #define P_FACECOUNT 7
 #define P_DEBUG_CHAR 8
 #define P_DEBUG_PARAM 9 
 
 */
short P_FACECOUNT = 7;
short P_FACEX = 1;
short P_FACEY = 2;
short  P_FACEZ = 3;
short P_SOUND = 4;
short P_RESET = 5;
short P_STOP = 6;

short P_DEBUG_CHAR = 8;
short P_DEBUG_PARAM = 9;
short P_DEBUG_CLEAR = 20;

void com_statemachine()
{
  if (data.param ==P_SOUND) {
  } 
  else if (data.param == P_DEBUG_CHAR)
  {
    debug_add((char) data.param);
  }
  else if(data.param >= P_DEBUG_PARAM && data.param >= P_DEBUG_PARAM + 10)
  {
    debug_set_value(data.param - P_DEBUG_PARAM, data.value);
  }
  else if(data.param == P_SOUND)
  {
     sampler_play(data.value);
   }
   else if(data.param == P_DEBUG_CLEAR)
   {
     debug_clear_prompt();
   }
}

void com_sendData(int param, int value)
{
  data.param = (short)param;
  data.value = (short)value;
  et_send(data);
}

void com_sendData(int param, float value)
{
  data.param = (short)param;
  data.value = (short)value;
  et_send(data);
}

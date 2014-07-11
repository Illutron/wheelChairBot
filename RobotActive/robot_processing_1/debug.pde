
String debug_prompt = "salkfdj lakdsjf slkjdf ";
int[] debug_values = new int[10];

void debug_draw(int _height,int y)
{
  pushMatrix();
  translate(0,y);
  color(0);
  fill(0);
  textSize(20);
  
  noStroke();
  rect(0,0,displayWidth,_height);
  fill(255);
  text(debug_prompt,0,0,displayWidth,_height/2);
  for (int i = 0; i < 10;i++)
  {
     text(debug_values[i], 10,_height/2+20*i);
     
  }
  popMatrix();
}

void debug_set_value(int i, int _value)
{
   debug_values[i] = _value;
  
}
void debug_add(char _char)
{
  debug_prompt = debug_prompt + _char; 
  
}

void debug_clear_prompt()
{
  debug_prompt = ""; 
  
}



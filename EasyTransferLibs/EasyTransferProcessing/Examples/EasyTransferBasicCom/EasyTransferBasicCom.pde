import processing.serial.*;
import java.io.Serializable;
import struct.*;
import java.nio.ByteOrder;

// DATA STRUCTURE FOR EasyTRansfer (Can only be type short (8bit)

DATA_STRUCTURE data = new DATA_STRUCTURE();
@StructClass
public class DATA_STRUCTURE {

  @StructField(order = 0)
    public short param;

  @StructField(order = 1)
    public short value;
}

//*************************



void setup()
{

  String portName = Serial.list()[7]; 
  et_begin(new Serial(this, portName, 115200));
  size(800, 600);
}

void draw()
{

  if (et_receive())
  {
    if (data.param==2)
    {
      background((data.value+20)*10, 0, 0);
    }
  }
}

void mouseMoved()
{
  et_send(data);
  data.value = (short)map((short)mouseX, 0, width, 0, 255);
   println(data.value);
  data.param = 1;

}


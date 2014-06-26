
import processing.serial.*;
import java.io.Serializable;
import struct.*;
import java.nio.ByteOrder;

@StructClass
public class Foo {
  @StructField(order = 0)
    public short b;
  @StructField(order = 1)
    public short i;
}
void setup()
{

  try {
    // Pack the class as a byte buffer
    Foo f = new Foo();
    f.b = (int)14;
    f.i = 12;
    byte[] b = JavaStruct.pack(f, ByteOrder.LITTLE_ENDIAN );
    byte[] c = new byte[b.length];
  /*  for(int i =0; i < b.length;i++)
    {
      c[i] = b[b.length -i-1];
       
    }*/
    for(int i=0; i < b.length-1;i=i+2)
    {
      c[i] = b[i+1];
      c[i+1] = b[i];
    }
    // Unpack it into an object
    Foo f2 = new Foo();
    JavaStruct.unpack(f2, c );
    println(f2.b);
  }
  catch(StructException e) {
  }
}

void draw()
{
}


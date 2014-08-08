

//*********************************************
// USB ON THE GO LIB BY Mads hobye // hobye.dk
// Based on https://github.com/mik3y/usb-serial-for-android
// it should not be neccesary to change anything below
//*********************************************

import java.io.Serializable;
import struct.*;
import java.nio.ByteOrder;


import com.hoho.android.usbserial.driver.*;
import android.hardware.usb.*;
import android.hardware.usb.UsbManager.*;
import java.util.*;


boolean usb_found = false;
UsbManager manager ;
List<UsbSerialDriver> availableDrivers;
List<UsbSerialPort> ports;
UsbSerialPort port;
int bytes_in_buffer = 0;
int buffer_pointer = 0;
byte buffer[] = new byte[1000];

int usb_avaliable()
{
  if (!usb_found) 
  {
    usb_connect();
  }
  if (usb_found) 
  {
    if (bytes_in_buffer > buffer_pointer)
    {
      return bytes_in_buffer - buffer_pointer;
    } else 
    {
      try {

        bytes_in_buffer = port.read(buffer, 100);

        buffer_pointer = 0;
        return bytes_in_buffer;
      } 
      catch (IOException e) {
        println("Could not read");
        usb_found = false;
      } 
      finally {
      }
    }
  }

  return 0;
}


byte usb_read_wait()
{
 while( usb_avaliable() == 0)
 {
 
 }
   return usb_read(); 
}
byte usb_read()
{
  if (bytes_in_buffer > buffer_pointer)
  {
    byte tmp = buffer[buffer_pointer];
    buffer_pointer ++;
    return tmp;
  } else
  {
    background(255, 0, 0);
    Log.v("illutron", "Buffer empty!");
    return 0;
  }
}



void usb_connect()
{

  if (!usb_found) {
    // Find all available drivers from attached devices.
    manager = (UsbManager) getSystemService(this.USB_SERVICE);
    availableDrivers = UsbSerialProber.getDefaultProber().findAllDrivers(manager);
    if (!availableDrivers.isEmpty()) {


      // Open a connection to the first available driver.
      UsbSerialDriver driver = availableDrivers.get(0);
      UsbDeviceConnection connection = manager.openDevice(driver.getDevice());
      if (connection != null) {



        // Read some data! Most have just one port (port 0).
        ports = driver.getPorts();
        port = ports.get(0);

        try {

          port.open(connection);
          port.setParameters(115200, 8, UsbSerialPort.STOPBITS_1, UsbSerialPort.PARITY_NONE);
          usb_found= true;
        }
        catch (IOException e) {
          println("Could not connect");
        }
      }
    }
  }
}

void close()
{
  try {

    port.close();
  }
  catch (IOException e) {
  }
}


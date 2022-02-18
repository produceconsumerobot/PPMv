// ppmvReceiver
// Written by Sean Montgomery 2022-02-17
// Displays year and PPMv data from udp messages

import hypermedia.net.*; // import UDP library

// ****************************************** //
// **** Variabiables that can be changed ****
int rcvPort = 6100;
String yearLabel = "year";
String ppmvLabel = "ppmv";
String delimiter = ",";

// ****************************************** //
// global storage varaibles
int year = -1;
int ppmv = -1;
UDP udp;  // define the UDP object

// ****************************************** //
void setup() 
{
  size(320, 240);
  
  textSize(28);
  
  udp = new UDP( this, rcvPort );
  udp.listen( true );
}

// ****************************************** //
void draw() 
{
  background(51);
  
  // Draw data to window
  text(yearLabel + ": " + year, 40, 40); 
  text(ppmvLabel + ": " + ppmv, 40, 80); 
}

// receive incoming udp messages
void receive( byte[] data, String ip, int port ) 
{  
  String message = new String( data );
  String[] splitMsg = split(message, delimiter);
  for (int i = 0; i < splitMsg.length - 1; i+=2)
  {
    if (splitMsg[i].equals(yearLabel))
    {
      year = int(splitMsg[i+1]);
    }
    if (splitMsg[i].equals(ppmvLabel))
    {
      ppmv = int(splitMsg[i+1]);
    }
  }
  //println( "receive: \""+message+"\" from "+ip+" on port "+port );
}

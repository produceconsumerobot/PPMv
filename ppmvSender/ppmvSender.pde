// ppmvSender
// Written by Sean Montgomery 2022-02-17
// Reads PPMv data from a CSV file and sends over UDP
// Takes joystick and button input to control data reading

import hypermedia.net.*; // import UDP library

// ****************************************** //
// **** Variabiables that can be changed ****
int rowIncr = 1;  // Number of rows to increment each time through loop
float jystkRowIncrMult = 2;  // rows increment multiplier when joystick toggled
int playbackFrequency = 10; //Hz
int[] buttonYears = {1900, 1950};  // jump-to years for buttons
String dataFilename = "ppmvData.csv";
String[] ipAddresses = {"localhost"};
int sendPort = 6100;
int rcvPort = 6000;
String yearLabel = "year";
String ppmvLabel = "ppmv";
String delimiter = ",";

// ****************************************** //
// global storage varaibles
int year;
int ppmv;
Table table;
int row = 0;
UDP udp;  // define the UDP object

// ****************************************** //
void setup() 
{
  size(320, 240);
  table = loadTable(dataFilename, "header");
  println(table.getRowCount() + " total rows in table");
  
  textSize(28);
  
  udp = new UDP( this, rcvPort );
  udp.listen( false );
}

// ****************************************** //
void draw() 
{
  background(51);
  year = table.getRow(row).getInt(yearLabel);
  ppmv = table.getRow(row).getInt(ppmvLabel);
  
  // Draw data to window
  text(yearLabel + ": " + year, 40, 40); 
  text(ppmvLabel + ": " + ppmv, 40, 80); 
 
  // Send data over UDP
  String message = yearLabel + delimiter + year + delimiter + ppmvLabel + delimiter + ppmv; // formats the message
  for (String ip : ipAddresses) 
  {
    udp.send( message, ip, sendPort ); // send the message
  }
  
  
  // Read joystick/buttons
  
  
  // increment data row
  row = row + rowIncr; // Go to the next row in the table
  if (row >= table.getRowCount()) 
  {
    row = 0; // start over at the beginning of the table
  }
  
  delay(int(1000/playbackFrequency)); // playback data at specific frequency
}


// receive incoming udp messages
void receive( byte[] data, String ip, int port ) 
{  
  String message = new String( data );
  
  // print the result
  println( "receive: \""+message+"\" from "+ip+" on port "+port );
}

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

import hypermedia.net.*;

UDP udp;  // define the UDP object
Minim minim;
//AudioPlayer song;
AudioPlayer[] song = new AudioPlayer[6];
FFTEffect[] effect = new FFTEffect[6];
PitchEffect processor;



///UDP Variables
String ip       = "127.0.0.1";  // the remote IP address
int port        = 12000;    // the destination port


float buffer = 0.05;
float shiftRate = 1.00;
float max = 1.3;
float min = 0.7;
//float t = 0;


void setup() {
  println("Local Host: " + ip);
  size(1500, 1000);
  leap = new LeapMotion(this);
  // create a new datagram connection on port 6000
  // and wait for incomming message
  udp = new UDP( this, 6100 );
  //udp.log( true );     // <-- printout the connection activity
  minim = new Minim(this);

  udp.listen( true );

  processor = new PitchEffect();
  for (int i = 0; i<6; i++) {
    song[i] = minim.loadFile(str(i+1) + ".wav");
    effect[i] = new FFTEffect(song[i].bufferSize(), song[i].sampleRate(), processor);
    effect[i].setPrecision(3);
    song[i].addEffect(effect[i]);
  }
}

void draw() {
  background(255);
  handTracking();
  if (pitchState == 0) {
    if (shiftRate < 1.0) {
      shiftRate = shiftRate + buffer;
    } else if (shiftRate > 1.0) {
      shiftRate = shiftRate - buffer;
    } else if (shiftRate == 1.00) {
      shiftRate = 1.00;
    }
  } else if (pitchState == 2) {
    if (shiftRate > min) {
      shiftRate = shiftRate - buffer;
    } else if (shiftRate == min) {
      shiftRate = min;
    }
  } else if (pitchState == 1) {
    if (shiftRate < max) {
      shiftRate = shiftRate + buffer;
    } else if (shiftRate == max) {
      shiftRate = max;
    }
  }
  //println("Shift Rate is " + shiftRate);
  processor.setShiftRate(shiftRate);
}

void keyPressed() {

  String message  = str( key );  // the message to send
  //String ip       = "169.254.15.203";  // the remote IP address
  //int port        = 12000;    // the destination port

  // formats the message for Pd
  message = message+";\n";
  // send the message
  udp.send( message, ip, port );
}

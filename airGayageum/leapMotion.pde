/////Leap Motion Controller - Hand Tracking & Play the Gayaguem for each finger

import de.voidplus.leapmotion.*;
import hypermedia.net.*;
//import processing.sound.*;

//SoundFile file;
LeapMotion leap;

int rightHand = 0;
int temp = 0;
int pitchState = 0;


void handTracking() {
  //int fps = leap.getFrameRate();
  for (Hand hand : leap.getHands ()) {


    // ==================================================
    // 2. Hand

    //int     handId             = hand.getId();
    //PVector handPosition       = hand.getPosition();
    //PVector handStabilized     = hand.getStabilizedPosition();
    //PVector handDirection      = hand.getDirection();
    //PVector handDynamics       = hand.getDynamics();
    float   handRoll           = hand.getRoll();
    float   handPitch          = hand.getPitch();
    float   handYaw            = hand.getYaw();
    boolean handIsLeft         = hand.isLeft();
    boolean handIsRight        = hand.isRight();
    //float   handGrab           = hand.getGrabStrength();
    //float   handPinch          = hand.getPinchStrength();
    //float   handTime           = hand.getTimeVisible();
    //PVector spherePosition     = hand.getSpherePosition();
    //float   sphereRadius       = hand.getSphereRadius();

    // ==================================================
    // 3. Finger

    Finger  fingerThumb        = hand.getThumb();
    Finger  fingerIndex        = hand.getIndexFinger();
    Finger  fingerMiddle       = hand.getMiddleFinger();
    Finger  fingerRing         = hand.getRingFinger();
    Finger  fingerPink         = hand.getPinkyFinger();


    // --------------------------------------------------
    // Drawing
    hand.draw();

    ////print value
    if (handIsLeft == true) {

      if (handRoll < -40) {
        pitchState = 1;
      } else if (handRoll < -10 && handRoll > -30) {
        pitchState = 0;
      } else if (handRoll > 0) {
        pitchState = 2;
      }
      ////println("Left Hand Roll: " + handRoll);
      ////println("Pitch State is " + pitchState);
      
      
      //println("Left Hand Pitch: " + handPitch);
      //println("Left Hand Yaw: " + handYaw);
    } else if (handIsRight == true) {

      for (Finger finger : hand.getOutstretchedFingers()) {
        // or              hand.getOutstretchedFingers();
        // or              hand.getOutstretchedFingersByAngle();

        //int     fingerId         = finger.getId();
        //PVector fingerPosition   = finger.getPosition();
        //PVector fingerStabilized = finger.getStabilizedPosition();
        //PVector fingerVelocity   = finger.getVelocity();
        //PVector fingerDirection  = finger.getDirection();
        //float   fingerTime       = finger.getTimeVisible();

        boolean thumb = fingerThumb.isExtended();
        boolean index = fingerIndex.isExtended();
        boolean middle = fingerMiddle.isExtended();
        boolean ring = fingerRing.isExtended();
        boolean pink = fingerPink.isExtended();

        // Velocity of tip????
        PVector thumbVelocity = fingerThumb.getVelocity();
        PVector indexVelocity = fingerIndex.getVelocity();
        PVector middleVelocity = fingerMiddle.getVelocity();
        PVector ringVelocity = fingerRing.getVelocity();
        PVector pinkVelocity = fingerPink.getVelocity();



        if (handIsRight == true) {
          if (thumb && index && middle && ring && pink) 
            rightHand = 0;
          else if (thumb == false && index && middle && ring && pink) 
            rightHand = 1;
          else if (thumb && index == false && middle && ring && pink)
            rightHand = 2;
          else if (thumb && index && middle && ring == false && pink)
            rightHand = 4;
          else if (thumb && index && middle == false && ring ==false && pink)
            rightHand = 3;
          else if (thumb && index && middle && ring && pink ==false)
            rightHand = 5;
          else if (thumb && index && middle && ring==false && pink==false)
            rightHand = 6;
        }
        //
        //println("Right Hand finger: " + rightHand);
        //println("Velocity: " + indexVelocity);
      }

      if (temp == rightHand) {
        break;
      }



      String message  = "0";  // the message to send
      message = message+";\n";
      //String ip       = "192.168.43.34";  // the remote IP address
      udp.send( message, ip, port );
      println("Message is " + message);
      //checker = false;
      if (rightHand >0 ) {
        //file = new SoundFile(this, str(rightHand) + ".wav");
        //file.play();
        //song = minim.loadFile(str(rightHand) + ".wav", 2048);
        //song = minim.loadFile("1.wav",512);
        //song.play();


        song[rightHand-1].loop(0);
        //song[rightHand-1] = minim.loadFile(str(rightHand-1) + ".wav");

        message = "1";
        message = message+";\n";
        udp.send( message, ip, port );
        println("Message is " + message);
        //checker = true;
      } else {
        temp =0;
      }
      temp = rightHand;
    }
  }
}

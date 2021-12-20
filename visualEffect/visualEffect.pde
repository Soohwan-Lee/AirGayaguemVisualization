////////////Screen Size////////////
//// Full screen: width = 8000, height = 2000
//// Small screen: width = 1000, height = 500

import hypermedia.net.*;
import processing.net.*;
boolean myServerRunning;
Server myServer;

UDP udp;

String ip       = "localhost";  // the remote IP address
int port        = 6100;    // the destination port

int viewport_w = 8000;
int viewport_h = 2000;
//int viewport_w = 1000;
//int viewport_h = 500;
int fluidgrid_scale = 1;

int gui_w = 200;
int gui_x = 20;
int gui_y = 20;

float px;
float py;
float theta;
float squiggliness = 1/200;
float scale = 1.0;

boolean checker = false;

void settings() {
  size(viewport_w, viewport_h, P2D);
  smooth(2);
}

void setup() {
  udp = new UDP( this, 12000 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
  myServerRunning = false;
  println("Server Running:" + "t" + myServerRunning);


  // main library context
  DwPixelFlow context = new DwPixelFlow(this);
  context.print();
  context.printGL();

  // fluid simulation
  fluid = new DwFluid2D(context, viewport_w, viewport_h, fluidgrid_scale);

  // set some simulation parameters
  fluid.param.dissipation_density     = 0.999f;
  fluid.param.dissipation_velocity    = 0.99f;
  fluid.param.dissipation_temperature = 0.80f;
  fluid.param.vorticity               = 0.10f;

  // interface for adding data to the fluid simulation
  MyFluidData cb_fluid_data = new MyFluidData();
  fluid.addCallback_FluiData(cb_fluid_data);


  // pgraphics for fluid
  pg_fluid = (PGraphics2D) createGraphics(viewport_w, viewport_h, P2D);
  pg_fluid.smooth(4);
  pg_fluid.beginDraw();
  pg_fluid.background(BACKGROUND_COLOR);
  pg_fluid.endDraw();


  // pgraphics for obstacles
  pg_obstacles = (PGraphics2D) createGraphics(viewport_w, viewport_h, P2D);
  pg_obstacles.smooth(0);
  pg_obstacles.beginDraw();
  pg_obstacles.clear();



  // circle-obstacles
  pg_obstacles.strokeWeight(10);
  pg_obstacles.noFill();
  pg_obstacles.noStroke();
  pg_obstacles.fill(64);
  float radius;
  radius = 100;
  pg_obstacles.ellipse(1*width/3f, 2*height/3f, radius, radius);
  radius = 150;
  pg_obstacles.ellipse(2*width/3f, 2*height/4f, radius, radius);
  radius = 200;
  pg_obstacles.stroke(64);
  pg_obstacles.strokeWeight(10);
  pg_obstacles.noFill();
  pg_obstacles.ellipse(1*width/2f, 1*height/4f, radius, radius);


  // border-obstacle
  pg_obstacles.strokeWeight(20);
  pg_obstacles.stroke(64);
  pg_obstacles.noFill();
  pg_obstacles.rect(0, 0, pg_obstacles.width, pg_obstacles.height);
  pg_obstacles.endDraw();



  // class, that manages interactive drawing (adding/removing) of obstacles
  obstacle_painter = new ObstaclePainter(pg_obstacles);

  createGUI();
  frameRate(60);
}

void draw() {
  px = random(width);
  py = random(height);
  //theta = noise(px * squiggliness, py * squiggliness)*PI*4;
  theta = random(2*PI);
  fluid();
}

void mousePressed() {
  // If the mouse clicked the myServer changes status
  println("click");
  if (myServerRunning) {
    // N.B. This produces an error which kills the sketch.
    myServerRunning = false;
    myServer.stop();
    myServer = null;
  } else {
    myServer = new Server(this, port); // Starts a server on port 10002
    myServerRunning = true;
    println(Server.ip());
  }
  background(0);
  println("Server Status:" + "t" + myServerRunning);
}



////Fluid function
void fluid() {
  if (UPDATE_FLUID) {
    fluid.addObstacles(pg_obstacles);
    fluid.update();
  }
  // clear render target
  pg_fluid.beginDraw();
  pg_fluid.background(BACKGROUND_COLOR);
  pg_fluid.endDraw();

  // render fluid stuff
  if (DISPLAY_FLUID_TEXTURES) {
    // render: density (0), temperature (1), pressure (2), velocity (3)
    fluid.renderFluidTextures(pg_fluid, DISPLAY_fluid_texture_mode);
  }

  if (DISPLAY_FLUID_VECTORS) {
    // render: velocity vector field
    fluid.renderFluidVectors(pg_fluid, 10);
  }

  // display
  image(pg_fluid, 0, 0);
  image(pg_obstacles, 0, 0);

  obstacle_painter.displayBrush(this.g);

  // info
  String txt_fps = String.format(getClass().getName()+ "   [size %d/%d]   [frame %d]   [fps %6.2f]", fluid.fluid_w, fluid.fluid_h, fluid.simulation_step, frameRate);
  surface.setTitle(txt_fps);
}


String message;
////UDP Receiver
void receive( byte[] data, String ip, int port ) {  // <-- extended handler


  // get the "real" message =
  // forget the ";\n" at the end <-- !!! only for a communication with Pd !!!
  data = subset(data, 0, data.length-2);
  message = new String( data );

  // print the result
  println( "receive: \""+message+"\" from "+ip+" on port "+port );
  println(message.charAt(0));
  char f = '0';
  char t = '1';
  
  if (message.charAt(0) == f) {
    checker = false;
    println("Checker is fucking false");
  } else if (message.charAt(0) == t) {
    checker = true;
    println("Checker is fucking true");
  }
}
void keyPressed(){
  checker = true;
}

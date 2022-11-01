/**
 * 
 * PixelFlow | Copyright (C) 2016 Thomas Diewald - http://thomasdiewald.com
 * 
 * A Processing/Java library for high performance GPU-Computing (GLSL).
 * MIT License: https://opensource.org/licenses/MIT
 * 
 */
import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;

import controlP5.Accordion;
import controlP5.ControlP5;
import controlP5.Group;
import controlP5.RadioButton;
import controlP5.Toggle;
import processing.core.*;
import processing.opengl.PGraphics2D;


// This example shows a very basic fluid simulation setup. 
// Multiple emitters add velocity/temperature/density each iteration.
// Obstacles are added at startup, by just drawing into a usual PGraphics object.
// The same way, obstacles can be added/removed dynamically.
//
// additionally some locations add temperature to the scene, to show how
// buoyancy works.
//
//
// controls:
//
// LMB: add Density + Velocity
// MMB: draw obstacles
// RMB: clear obstacles


public class MyFluidData implements DwFluid2D.FluidData {
  //float px;
  //float py;
  public void setting() {
    //px = random(width);
    //py = random(height);
  }
  // update() is called during the fluid-simulation update step.
  @Override
    public void update(DwFluid2D fluid) {

    //float px, py, vx, vy, radius, vscale, r, g, b, intensity, temperature;
    float vx, vy, radius, vscale, r, g, b, intensity, temperature;
    //float squiggliness = 1/200;
    //float theta;
    float dist = 1;
    PVector v;

    //// add impulse: density + temperature
    //intensity = 1.0f;
    //px = 1*width/3;
    //py = 0;
    //radius = 100;
    //r = 0.0f;
    //g = 0.3f;
    //b = 1.0f;
    //fluid.addDensity(px, py, radius, r, g, b, intensity);

    //if ((fluid.simulation_step) % 200 == 0) {
    //  temperature = 50f;
    //  fluid.addTemperature(px, py, radius, temperature);
    //}

    //// add impulse: density + temperature
    //float animator = sin(fluid.simulation_step*0.01f);

    //intensity = 1.0f;
    //px = 2*width/3f;
    //py = 150;
    //radius = 50;
    //r = 1.0f;
    //g = 0.0f;
    //b = 0.3f;
    //fluid.addDensity(px, py, radius, r, g, b, intensity);

    //temperature = animator * 20f;
    //fluid.addTemperature(px, py, radius, temperature);


    //// add impulse: density 
    //px = 1*width/3f;
    //py = height-2*height/3f;
    //radius = 50.5f;
    //r = g = b = 64/255f;
    //intensity = 1.0f;
    //fluid.addDensity(px, py, radius, r, g, b, intensity, 3);


    //boolean mouse_input = !cp5.isMouseOver() && mousePressed && !obstacle_painter.isDrawing();

    //// add impulse: density + velocity
    //if (mouse_input && mouseButton == LEFT) {
    //  radius = 15;
    //  vscale = 15;
    //  px     = mouseX;
    //  py     = height-mouseY;
    //  vx     = (mouseX - pmouseX) * +vscale;
    //  vy     = (mouseY - pmouseY) * -vscale;

    //  fluid.addDensity(px, py, radius, 0.0f, 0.0f, 0.0f, 5.0f);
    //  fluid.addVelocity(px, py, radius, vx, vy);
    //}

    //println("Checker is " + checker);
    if (checker) {
      ///// Draw the Black Ink
      //radius = 200;
      //vscale = 3000;
      radius = 30 * random(5,8);
      vscale = 1000 * random(1,10);
      
      
      //px     = width/2;
      //py     = height/2;
      //px       = random(width);
      //py       = random(height);

      //vx     = (mouseX - pmouseX) * +vscale;
      //vy     = (mouseY - pmouseY) * -vscale;


      //theta = noise(px * squiggliness, py * squiggliness)*PI*4;
      //theta = random(2*PI);

      v      = PVector.fromAngle(theta);
      //vx     = (v.x - px) * +vscale;
      //vy     = (v.y - py) * -vscale;

      fluid.addDensity(px, py, radius, 0.0f, 0.0f, 0.0f, 5.0f);
      fluid.addVelocity(px, py, radius, v.x*vscale, v.y*vscale);
      //println("Scale: " + v.x*vscale);
      //px = v.x;
      //py = v.y;
      //v.x    = v.x*0.1;
      //v.y    = v.y*0.1;
      checker = false;
    }
  }
}


DwFluid2D fluid;
ObstaclePainter obstacle_painter;

// render targets
PGraphics2D pg_fluid;
//texture-buffer, for adding obstacles
PGraphics2D pg_obstacles;

// some state variables for the GUI/display
int     BACKGROUND_COLOR           = 255;
boolean UPDATE_FLUID               = true;
boolean DISPLAY_FLUID_TEXTURES     = true;
boolean DISPLAY_FLUID_VECTORS      = false;
int     DISPLAY_fluid_texture_mode = 0;

/*
public void mousePressed() {
  //if (mouseButton == CENTER ) obstacle_painter.beginDraw(1); // add obstacles
  //if (mouseButton == RIGHT  ) obstacle_painter.beginDraw(2); // remove obstacles
}
*/

public void mouseDragged() {
  obstacle_painter.draw();
}

public void mouseReleased() {
  obstacle_painter.endDraw();
}


public void fluid_resizeUp() {
  fluid.resize(width, height, fluidgrid_scale = max(1, --fluidgrid_scale));
}
public void fluid_resizeDown() {
  fluid.resize(width, height, ++fluidgrid_scale);
}
public void fluid_reset() {
  fluid.reset();
}
public void fluid_togglePause() {
  UPDATE_FLUID = !UPDATE_FLUID;
}
public void fluid_displayMode(int val) {
  DISPLAY_fluid_texture_mode = val;
  DISPLAY_FLUID_TEXTURES = DISPLAY_fluid_texture_mode != -1;
}
public void fluid_displayVelocityVectors(int val) {
  DISPLAY_FLUID_VECTORS = val != -1;
}

public void keyReleased() {
  if (key == 'p') fluid_togglePause(); // pause / unpause simulation
  if (key == '+') fluid_resizeUp();    // increase fluid-grid resolution
  if (key == '-') fluid_resizeDown();  // decrease fluid-grid resolution
  if (key == 'r') fluid_reset();       // restart simulation

  if (key == '1') DISPLAY_fluid_texture_mode = 0; // density
  if (key == '2') DISPLAY_fluid_texture_mode = 1; // temperature
  if (key == '3') DISPLAY_fluid_texture_mode = 2; // pressure
  if (key == '4') DISPLAY_fluid_texture_mode = 3; // velocity

  if (key == 'q') DISPLAY_FLUID_TEXTURES = !DISPLAY_FLUID_TEXTURES;
  if (key == 'w') DISPLAY_FLUID_VECTORS  = !DISPLAY_FLUID_VECTORS;
}



ControlP5 cp5;

public void createGUI() {
  cp5 = new ControlP5(this);

  int sx, sy, px, py, oy;

  sx = 100; 
  sy = 14; 
  oy = (int)(sy*1.5f);


  ////////////////////////////////////////////////////////////////////////////
  // GUI - FLUID
  ////////////////////////////////////////////////////////////////////////////
  Group group_fluid = cp5.addGroup("fluid");
  {
    group_fluid.setHeight(20).setSize(gui_w, 300)
      .setBackgroundColor(color(16, 180)).setColorBackground(color(16, 180));
    group_fluid.getCaptionLabel().align(CENTER, CENTER);

    px = 10; 
    py = 15;

    cp5.addButton("reset").setGroup(group_fluid).plugTo(this, "fluid_reset"     ).setSize(80, 18).setPosition(px, py);
    cp5.addButton("+"    ).setGroup(group_fluid).plugTo(this, "fluid_resizeUp"  ).setSize(39, 18).setPosition(px+=82, py);
    cp5.addButton("-"    ).setGroup(group_fluid).plugTo(this, "fluid_resizeDown").setSize(39, 18).setPosition(px+=41, py);

    px = 10;

    cp5.addSlider("velocity").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=(int)(oy*1.5f))
      .setRange(0, 1).setValue(fluid.param.dissipation_velocity).plugTo(fluid.param, "dissipation_velocity");

    cp5.addSlider("density").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 1).setValue(fluid.param.dissipation_density).plugTo(fluid.param, "dissipation_density");

    cp5.addSlider("temperature").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 1).setValue(fluid.param.dissipation_temperature).plugTo(fluid.param, "dissipation_temperature");

    cp5.addSlider("vorticity").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 1).setValue(fluid.param.vorticity).plugTo(fluid.param, "vorticity");

    cp5.addSlider("iterations").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 80).setValue(fluid.param.num_jacobi_projection).plugTo(fluid.param, "num_jacobi_projection");

    cp5.addSlider("timestep").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 1).setValue(fluid.param.timestep).plugTo(fluid.param, "timestep");

    cp5.addSlider("gridscale").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 50).setValue(fluid.param.gridscale).plugTo(fluid.param, "gridscale");

    RadioButton rb_setFluid_DisplayMode = cp5.addRadio("fluid_displayMode").setGroup(group_fluid).setSize(80, 18).setPosition(px, py+=(int)(oy*1.5f))
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(2)
      .addItem("Density", 0)
      .addItem("Temperature", 1)
      .addItem("Pressure", 2)
      .addItem("Velocity", 3)
      .activate(DISPLAY_fluid_texture_mode);
    for (Toggle toggle : rb_setFluid_DisplayMode.getItems()) toggle.getCaptionLabel().alignX(CENTER);

    cp5.addRadio("fluid_displayVelocityVectors").setGroup(group_fluid).setSize(18, 18).setPosition(px, py+=(int)(oy*2.5f))
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
      .addItem("Velocity Vectors", 0)
      .activate(DISPLAY_FLUID_VECTORS ? 0 : 2);
  }


  ////////////////////////////////////////////////////////////////////////////
  // GUI - DISPLAY
  ////////////////////////////////////////////////////////////////////////////
  Group group_display = cp5.addGroup("display");
  {
    group_display.setHeight(20).setSize(gui_w, 50)
      .setBackgroundColor(color(16, 180)).setColorBackground(color(16, 180));
    group_display.getCaptionLabel().align(CENTER, CENTER);

    px = 10; 
    py = 15;

    cp5.addSlider("BACKGROUND").setGroup(group_display).setSize(sx, sy).setPosition(px, py)
      .setRange(0, 255).setValue(BACKGROUND_COLOR).plugTo(this, "BACKGROUND_COLOR");
  }


  ////////////////////////////////////////////////////////////////////////////
  // GUI - ACCORDION
  ////////////////////////////////////////////////////////////////////////////
  cp5.addAccordion("acc").setPosition(gui_x, gui_y).setWidth(gui_w).setSize(gui_w, height)
    .setCollapseMode(Accordion.MULTI)
    .addItem(group_fluid)
    .addItem(group_display)
    .open(4);
}






public class ObstaclePainter {

  // 0 ... not drawing
  // 1 ... adding obstacles
  // 2 ... removing obstacles
  public int draw_mode = 0;
  PGraphics pg;

  float size_paint = 15;
  float size_clear = size_paint * 2.5f;

  float paint_x, paint_y;
  float clear_x, clear_y;

  int shading = 64;

  public ObstaclePainter(PGraphics pg) {
    this.pg = pg;
  }

  public void beginDraw(int mode) {
    paint_x = mouseX;
    paint_y = mouseY;
    this.draw_mode = mode;
    if (mode == 1) {
      pg.beginDraw();
      pg.blendMode(REPLACE);
      pg.noStroke();
      pg.fill(shading);
      pg.ellipse(mouseX, mouseY, size_paint, size_paint);
      pg.endDraw();
    }
    if (mode == 2) {
      clear(mouseX, mouseY);
    }
  }

  public boolean isDrawing() {
    return draw_mode != 0;
  }

  public void draw() {
    paint_x = mouseX;
    paint_y = mouseY;
    if (draw_mode == 1) {
      pg.beginDraw();
      pg.blendMode(REPLACE);
      pg.strokeWeight(size_paint);
      pg.stroke(shading);
      pg.line(mouseX, mouseY, pmouseX, pmouseY);
      pg.endDraw();
    }
    if (draw_mode == 2) {
      clear(mouseX, mouseY);
    }
  }

  public void endDraw() {
    this.draw_mode = 0;
  }

  public void clear(float x, float y) {
    clear_x = x;
    clear_y = y;
    pg.beginDraw();
    pg.blendMode(REPLACE);
    pg.noStroke();
    pg.fill(0, 0);
    pg.ellipse(x, y, size_clear, size_clear);
    pg.endDraw();
  }

  public void displayBrush(PGraphics dst) {
    if (draw_mode == 1) {
      dst.strokeWeight(1);
      dst.stroke(0);
      dst.fill(200, 50);
      dst.ellipse(paint_x, paint_y, size_paint, size_paint);
    }
    if (draw_mode == 2) {
      dst.strokeWeight(1);
      dst.stroke(200);
      dst.fill(200, 100);
      dst.ellipse(clear_x, clear_y, size_clear, size_clear);
    }
  }
}

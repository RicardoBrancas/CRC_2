import processing.pdf.*;

import controlP5.*;
import java.util.*;

ControlP5 cp5;

Grid g;
DropdownList d1;

boolean setup = false, running = false, save_frame = true;
int log_tps = 2;
int tps = (int) Math.pow(10, log_tps);
long nanos = (long) ((float) 1000000000 / tps);
long current_time = 0;
long lastTime;

long t = 0;

int selected = 0;

void setup() {
  size(1366, 768);
  frameRate(60);
  
  cp5 = new ControlP5(this);
  
  cp5.begin(height + 20, 100);
  
  setup_binary();
  
  cp5.addButton("generate")
     .linebreak();
  
  cp5.addButton("run")
     .hide();
     
  cp5.addButton("pause")
     .hide();
  
  cp5.addSlider("log_tps")
     .setRange(0, 8)
     .setNumberOfTickMarks(9)
     .setLabel("Speed")
     .linebreak()
     ;
     
  cp5.addButton("save_f")
     .setLabel("Save Frame");
  
  thread("ticks");
  
}

void save_f() {
  save_frame = true;
}

void disable() {
  setup = false;
  running = false;
  
  cp5.get("run").hide();
  cp5.get("pause").hide();
}

void enable() {
  setup = true;
  
  cp5.get("run").show();
  cp5.get("pause").show();
}

void generate() {
  running = false;
  
  g = new BinaryGrid(_n, _r, _p, _R_1, _R_2, _dyn, _smt);
  g.distribute();
  enable();
  
  t = 0;
}

void run() {
  running = true;
  lastTime = System.nanoTime();
}

void pause() {
  running = false;
}

void draw() {
  if (save_frame)
    beginRecord(PDF, "frame-######.pdf");
  
  background(30);
  
  if (setup) {
    g.paint();
  }
  
  ellipseMode(CORNER);
  noStroke();
  
  fill(veryPoor);
  rect(width - height / 2, height - 200, 10, 10);
  
  fill(poor);
  rect(width - height / 2, height - 180, 10, 10);
  
  fill(rich);
  rect(width - height / 2, height - 160, 10, 10);
  
  fill(veryRich);
  rect(width - height / 2, height - 140, 10, 10);
  
  fill(coop);
  ellipse(width - height / 2, height - 120, 10, 10);
  
  fill(defect);
  ellipse(width - height / 2, height - 100, 10, 10);
  
  
  fill(255);
  text("very poor", width - height / 2 + 20, height - 200 + 8.25);
  text("poor", width - height / 2 + 20, height - 180 + 8.25);
  text("rich", width - height / 2 + 20, height - 160 + 8.25);
  text("very rich", width - height / 2 + 20, height - 140 + 8.25);
  text("cooperator", width - height / 2 + 20, height - 120 + 8.25);
  text("defector", width - height / 2 + 20, height - 100 + 8.25);
  
  
  text(Long.toString(t) + " updates", height + 20, height - 40);
  
  text("b:" + Float.toString(2f/_r), height + 20, height - 80);
  text("c:" + Float.toString(((float)_R_2 - _R_1) / _R_1), height + 20, height - 60);
  
  if (save_frame)
    endRecord();
  save_frame = false;
}

void ticks() {
  while (true) {
    tps = (int) Math.pow(10, log_tps);
    nanos = (long) ((float) 1000000000 / tps);
    
    long time = System.nanoTime();
    current_time += time - lastTime;
    lastTime = time;
    
    if (current_time >= nanos) {
      current_time = 0;
      
      if (running) {
        t++;
        g.tick();
      }
    } 
  } 
}

import processing.pdf.*;

import controlP5.*;
import java.util.*;
import java.text.SimpleDateFormat;
import java.text.DecimalFormat;

ControlP5 cp5;

Grid g;

boolean setup       = false,
        running     = false,
        was_running = false,
        save_frame  = false;

int log_tps = 2;
int tps = (int) Math.pow(10, log_tps);
long nanos = (long) ((float) 1000000000 / tps);
long current_time = 0;
long lastTime;
long t = 0;

String start;

PGraphics pdf;
DecimalFormat df = new DecimalFormat();

void setup() {
  size(1366, 768, P2D);
  frameRate(60);
  
  df.setMaximumFractionDigits(2);
  
  cp5 = new ControlP5(this);
  cp5.begin(height + 20, 100);
  
  setup_binary();
  
  cp5.addButton("generate")
     .linebreak();
  
  cp5.addButton("run")
     .hide();
     
  cp5.addButton("pause")
     .hide()
     .linebreak();
  
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

void run() {
  running = true;
  lastTime = System.nanoTime();
}

void pause() {
  running = false;
}

void generate() {
  running = false;
  
  switch (UpdateType.values()[_update_type]) {
    case ORIGINAL:
      g = new OriginalGrid(_n, _r, _p, _R_1, _R_2, _dyn);
      break;
    case REPLICATOR:
      g = new ReplicatorGrid(_n, _r, _p, _R_1, _R_2, _dyn);
      break;
   case SOFTMAX:
      g = new SoftmaxGrid(_n, _r, _p, _R_1, _R_2, _dyn);
      break;
  }
  
  g.distribute();
  enable();
  
  start = Integer.toString(_n);
  start += "u" + UpdateType.values()[_update_type].toString();
  start += _dyn ? "DYN" : "";
  start += "p" + df.format(_p).replace(".","_");
  start += "b" + df.format(2f/_r).replace(".","_");
  start += "c" + df.format((_R_2 - _R_1) / _R_1).replace(".","_");
  
  t = 0;
  save_frame = true;
}

void draw() {
  boolean saving = false;
  if (save_frame) {
    pdf = createGraphics(height, height, PDF, start + "-" + Long.toString(t) + ".pdf");
    beginRecord(pdf);
    saving = true;
  }
  
  background(30);
  
  if (setup) {
    g.paint();
  }
  
  ellipseMode(CORNER);
  noStroke();
  
  fill(veryPoor);
  ellipse(width - height / 2, height - 200, 10, 10);
  
  fill(poor);
  ellipse(width - height / 2, height - 180, 10, 10);
  
  fill(rich);
  ellipse(width - height / 2, height - 160, 10, 10);
  
  fill(veryRich);
  ellipse(width - height / 2, height - 140, 10, 10);
  
  fill(coop);
  rect(width - height / 2, height - 120, 10, 10);
  
  fill(defect);
  rect(width - height / 2, height - 100, 10, 10);
  
  
  fill(255);
  text("very poor", width - height / 2 + 20, height - 200 + 8.5);
  text("poor", width - height / 2 + 20, height - 180 + 8.5);
  text("rich", width - height / 2 + 20, height - 160 + 8.5);
  text("very rich", width - height / 2 + 20, height - 140 + 8.5);
  text("cooperator", width - height / 2 + 20, height - 120 + 8.5);
  text("defector", width - height / 2 + 20, height - 100 + 8.5);
  
  text(Long.toString(t) + " updates", height + 20, height - 40);
  
  text("b:" + Float.toString(2f/_r), height + 20, height - 80);
  text("c:" + Float.toString(((float)_R_2 - _R_1) / _R_1), height + 20, height - 60);
  
  if (saving) {
    endRecord();
    save_frame = false;
    if (was_running) {
      running = true;
      was_running = false;
    }
  }
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
        
        if (t == 1000 || t == 10000 || t == 100000 || t == 1000000 || t == 10000000 || t == 100000000 || t == 1000000000) {
          save_frame = true;
          running = false;
          was_running = true;
        }
        
        g.tick();
      }
    } 
  } 
}

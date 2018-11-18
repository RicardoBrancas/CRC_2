import controlP5.*;
import java.util.*;

ControlP5 cp5;

Grid g;
DropdownList d1;

boolean setup = false, running = false;
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
  
  cp5.addScrollableList("dist_selection")
     .setSize(200, 100)
     .setPosition(height + 20, 20)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(Arrays.asList("Binary Distribution"))
     .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
     ;
  
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
     ;
  
  cp5.addTextlabel("t");
  
  
  
  thread("ticks");
  
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

void dist_selection(int n) {
  selected = n;
  
  Map item = cp5.get(ScrollableList.class, "dist_selection").getItem(n);
  
  disable_binary();
  
  switch ((String) item.get("text")) {
    case "Binary Distribution":
      enable_binary();
      break;
  }
  
  t = 0;
}

void generate() {
  Map item = cp5.get(ScrollableList.class, "dist_selection").getItem(selected);
  running = false;
  
  switch ((String) item.get("text")) {
    case "Binary Distribution":
      g = new BinaryGrid(64, _r, _p, _R_1, _R_2);
      g.distribute();
      enable();
      break;
  }
  
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
  background(30);
  
  if (setup) {
    g.paint();
  }
  
  fill(255);
  text(Long.toString(t) + " updates", height + 20, height - 40);
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

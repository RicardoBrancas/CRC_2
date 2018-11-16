import controlP5.*;
import java.util.*;

ControlP5 cp5;

Grid g;
DropdownList d1;

boolean setup = false, running = false;
int tps = 1000;
long nanos = (long) ((float) 1000000000 / tps);
long current_time = 0;
long lastTime;

long t = 0;

void setup() {
  size(1366, 768);
  
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
  
  cp5.addButton("run");
  cp5.addButton("pause");
  
  cp5.addTextlabel("t");
  
  thread("ticks");
  
}

void dist_selection(int n) {
  Map item = cp5.get(ScrollableList.class, "dist_selection").getItem(n);
  
  switch ((String) item.get("text")) {
    case "Binary Distribution":
      g = new BinaryGrid(64, 1.17, .9, 1, 1);
      g.distribute();
      setup = true;
      break;
  }
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

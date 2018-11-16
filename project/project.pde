import controlP5.*;
import java.util.*;

ControlP5 cp5;

Grid g;
DropdownList d1;

boolean setup = false, running = false;
int tps = 1;
long millis = (long) ((float) 1000 / tps);
long current_time = 0;
long lastTime;

void setup() {
  size(1024, 512);
  
  cp5 = new ControlP5(this);
  
  cp5.addScrollableList("dist_selection")
     .setSize(200, 100)
     .setPosition(512 + 20, 20)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(Arrays.asList("Binary Distribution"))
     .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
     ;
  
  cp5.begin(512 + 20, 100);
  
  cp5.addButton("run");
  
  cp5.addButton("pause");
  
}

void dist_selection(int n) {
  Map item = cp5.get(ScrollableList.class, "dist_selection").getItem(n);
  
  switch ((String) item.get("text")) {
    case "Binary Distribution":
      g = new BinaryGrid(64, 1.2, 0.9, 0.1);
      g.distribute();
      setup = true;
      break;
  }
}

void run() {
  running = true;
  lastTime = System.currentTimeMillis();
}

void pause() {
  running = false;
}

void draw() {
  background(30);
  
  if (setup) {
    g.paint();
  }
  
  long time = System.currentTimeMillis();
  current_time += time - lastTime;
  lastTime = time;
  
  if (current_time >= millis) {
    current_time -= millis;
    if (running) {
      g.step();
    }
  }
  
  
}

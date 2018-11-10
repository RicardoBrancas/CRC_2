
Grid g;

void setup() {
  size(512, 512);
  
  g = new BinaryGrid(100, 1.2, 0.9, 0.1);
  g.distribute();
  
}

void draw() {
  g.paint();
}

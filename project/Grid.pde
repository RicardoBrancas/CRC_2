import javafx.util.*;

color veryPoor = #4FB71C;
color poor = color(1,1,1,0);
color rich = #FFC905;
color veryRich = #8B7015;

color coop = #12A3DB;
color defect = #D81414;

color loglerp(color c1, color c2, color c3, color c4, float amnt, float m1, float m2) {
  
  if (amnt > m1 && amnt < m2) {
    return lerpColor(c2, c3, norm(amnt, m1, m2));
  
  } else if (amnt < m1) {
    return lerpColor(c2, c1, abs(.001 * (amnt - m1) / (1 + abs(.001 * (amnt - m1)))));
    
  } else {
    return lerpColor(c3, c4, abs(.001 * (amnt - m2) / (1 + abs(.001 * (amnt - m2)))));
  
  }
}

abstract class Grid {
  
  int n;
  
  float ratio;
  
  float r;
  
  float wealth[][];
  boolean player[][];
  
  public Grid(int n, float r) {
    this.n = n;
    this.r = r;
    
    ratio = (float) height / n;
    
    wealth = new float[n][n];
    player = new boolean[n][n];
  }
  
  public void distribute() {
    distribute_wealth();
    distribute_players();
  }
  
  abstract public void distribute_wealth();
  
  abstract public void distribute_players();
  
  public void paint() {    
    ellipseMode(CORNER);
    noStroke();
    
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        fill(player[i][j] ? coop : defect);
        rect(i * ratio, j * ratio, ratio, ratio);
        
        fill(loglerp(veryPoor, poor, rich, veryRich, wealth[i][j], 1, 22));
        ellipse((i + .3) * ratio, (j + .3) * ratio, ratio * .4, ratio * .4);
      }
    }
  }
  
  abstract public void tick();
}

import javafx.util.*;

color veryPoor = #0C1C74;
color poor = #12A3DB;
color rich = #F51616;
color veryRich = #6C1313;

color coop = #FFFFFF;
color defect = #000000;

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
        
        fill(loglerp(veryPoor, poor, rich, veryRich, wealth[i][j], 1, 22));
        rect(i * ratio, j * ratio, ratio, ratio);
        
        fill(player[i][j] ? coop : defect);
        ellipse((i + .3) * ratio, (j + .3) * ratio, ratio * .4, ratio * .4);
      }
    }
  }
  
  abstract public void tick();
}

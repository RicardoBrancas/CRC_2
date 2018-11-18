import javafx.util.*;

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
  
  color rich = #5695E5;
  color poor = #F51D11;
  
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
    
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        noStroke();
        fill(loglerp(#0C1C74, #12A3DB, #F51616, #6C1313, wealth[i][j], 0, 50));
        rect(i * ratio, j * ratio, ratio, ratio);
        
        fill(player[i][j] ? #FFFFFF : #000000);
        ellipse((i + .3) * ratio, (j + .3) * ratio, ratio * .4, ratio * .4);
      }
    }
  }
  
  abstract public void tick();
}

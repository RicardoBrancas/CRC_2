import javafx.util.*;

abstract class Grid {
  
  int n;
  
  float ratio;
  
  float r;
  
  float wealth[][];
  boolean players[][];
  
  color rich = #5695E5;
  color poor = #F51D11;
  
  public Grid(int n, float r) {
    this.n = n;
    this.r = r;
    
    ratio = (float) height / n;
    
    wealth = new float[n][n];
    players = new boolean[n][n];
  }
  
  public void distribute() {
    distribute_wealth();
    distribute_players();
  }
  
  abstract public void distribute_wealth();
  
  abstract public void distribute_players();
  
  public void paint() {
    float w_min = Float.POSITIVE_INFINITY, w_max = Float.NEGATIVE_INFINITY;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        w_min = min(w_min, wealth[i][j]);
        w_max = max(w_max, wealth[i][j]);
      }
    }
    
    
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        noStroke();
        fill(lerpColor(rich, poor, norm(wealth[i][j], 0, 50)));
        rect(i * ratio, j * ratio, ratio, ratio);
        
        ellipseMode(CORNER);
        fill(players[i][j] ? #FFFFFF : #000000);
        ellipse((i + .3) * ratio, (j + .3) * ratio, ratio * .4, ratio * .4);
      }
    }
  }
  
  public void tick() {
    HashSet<Pair<Pair<Integer, Integer>, Pair<Integer, Integer>>> done = new HashSet<Pair<Pair<Integer, Integer>, Pair<Integer, Integer>>>();
    
    int i = Math.round(random(0, n-1));
    int j = Math.round(random(0, n-1));
    
    for (int di = -1; di <= 1; di++) {
      for (int dj = -1; dj <= 1; dj++) {
        if (!(abs(di) == 1 && abs(dj) == 1)) {
          int i2 = i + di;
          int j2 = j + dj;
          
          if (i2 >= 0 && i2 < n && j2 >= 0 && j2 < n) {
          
            if (!done.contains(new Pair(new Pair(i, j), new Pair(i2, j2))) && !done.contains(new Pair(new Pair(i2, j2), new Pair(i, j)))) {
              done.add(new Pair(new Pair(i, j), new Pair(i2, j2)));
              
              int count = 0;
              float pool = 0;
              
              if(players[i][j]) {
                pool += wealth[i][j];
                wealth[i][j] *= 0;
                count += 1;
              }
              
              if (players[i2][j2]) {
                pool += wealth[i2][j2];
                wealth[i2][j2] *= 0;
                count += 1;
              }
              
              pool *= r;
              
              if(players[i][j]) {
                wealth[i][j] += pool / count;
              }
              if (players[i2][j2]) {
                wealth[i2][j2] += pool / count;
              }
            }
          }
        }
      }
    }
  }
  
}

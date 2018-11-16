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
    
    ratio = (float) 512 / n;
    
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
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        noStroke();
        fill(lerpColor(rich, poor, wealth[i][j]));
        rect(i * ratio, j * ratio, ratio, ratio);
      }
    }
  }
  
  public void step() {
    HashSet<Pair<Pair<Integer, Integer>, Pair<Integer, Integer>>> done = new HashSet<Pair<Pair<Integer, Integer>, Pair<Integer, Integer>>>();
    
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        for (int di = -1; di <= 1; di++) {
          for (int dj = -1; dj <= 1; dj++) {
            if (!(abs(di) == 1 && abs(dj) == 1)) {
              int i2 = i + di;
              int j2 = j + dj;
              
              if (i2 >= 0 && i2 < n && j2 >= 0 && j2 < n) {
              
              if (!done.contains(new Pair(new Pair(i, j), new Pair(i2, j2))) && !done.contains(new Pair(new Pair(i2, j2), new Pair(i, j)))) {
                done.add(new Pair(new Pair(i, j), new Pair(i2, j2)));
                
                if(wealth[i2][j2] * random(2) > .5) {
                  float pool = 0;
                  
                  pool += wealth[i][j] * .1;
                  pool += wealth[i2][j2] * .1;
                  
                  wealth[i][j] *= .9;
                  wealth[i2][j2] *= .9;
                  
                  wealth[i][j] += pool / 2;
                  wealth[i2][j2] += pool / 2;
                }
              }
              }
            
            }
          }
        }
      }
    }
  }
  
}

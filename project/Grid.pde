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
    
    ratio = 600 / n;
    
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
  
}

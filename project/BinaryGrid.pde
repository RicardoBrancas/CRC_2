class BinaryGrid extends Grid {
  
  float R_1, R_2;
  float p;
  float b, c;
  
  public BinaryGrid(int n, float r, float p, float R_1, float R_2) {
    super(n, r);
    
    this.R_1 = R_1;
    this.R_2 = R_2;
    this.p = p;
    
    b = 2f/r;
    c = (R_2 - R_1) / R_1;
  }
  
  
  public void distribute_wealth() {
     
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        
        if (random(1) < p)
          wealth[i][j] = R_1;
          
        else
          wealth[i][j] = R_2;
      }
    }
    
  }
  
  public void distribute_players() {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
          players[i][j] = random(1) < .5;
      }
    }
  }
  
  
}

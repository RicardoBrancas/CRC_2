class BinaryGrid extends Grid {
  
  float R_1, R_2;
  
  public BinaryGrid(int n, float r, float R_1, float R_2) {
    super(n, r);
    
    this.R_1 = R_1;
    this.R_2 = R_2;
  }
  
  
  public void distribute_wealth() {
     
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        
        if (random(1) > .5)
          wealth[i][j] = R_1;
          
        else
          wealth[i][j] = R_2;
      }
    }
    
  }
  
  public void distribute_players() {
    
  }
  
  
}

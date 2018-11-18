float _r, _p, _R_1, _R_2;

void setup_binary() {
  cp5.addNumberbox("_r")
     .setScrollSensitivity(.1)
     .setRange(0, 5)
     .setValue(1.1)
     ;
  
  cp5.addNumberbox("_p")
     .setScrollSensitivity(.07)
     .setValue(.9)
     .setRange(0,1)
     ;
     
  cp5.addNumberbox("_R_1")
     .setScrollSensitivity(1)
     .setValue(2)
     ;
     
  cp5.addNumberbox("_R_2")
     .setScrollSensitivity(1)
     .setValue(40)
     ;
}

void enable_binary() {
  
}

void disable_binary() {
  
}

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
          player[i][j] = random(1) > .5;
      }
    }
  }
  
  public void tick() {
    
    int i = Math.round(random(0, n-1));
    int j = Math.round(random(0, n-1));
    
    float x = 0;
    float N = 0;
    //float avgWealth = 0;
    
    for (int i2 = i-2; i2 <= i+2; i2++) {
      for (int j2 = j-2; j2 <= j+2; j2++) {
        
        if (i2 >= 0 && i2 < n && j2 >= 0 && j2 < n) {
          N++;
          
          if (player[i2][j2])
            x++;
          
          //avgWealth += wealth[i2][j2];
        }
      }
    }
    
    //avgWealth /= N;
    
    //float c = abs((wealth[i][j] - avgWealth) / avgWealth);
    //float b = 2/r;
    
    float c = ((float)_R_2 - (float)_R_1) / (float)_R_1;
    float b = (float)2 / r;
    
    float z = wealth[i][j] == _R_2 ? (c - b*c - b + 1) : (-b + 1);
    
    float beta = 10;
    
    float rand = random(1);
    
    if (player[i][j] && (rand < (1f / (1f + Math.exp(beta * z)))))
      player[i][j] = false;
      
    if (!player[i][j] && (rand < (1f / (1f + Math.exp(-beta * z)))))
      player[i][j] = true;
    
    //for (Pair<Integer, Integer> e : Arrays.asList(new Pair(i-1, j-1), new Pair(i+1, j-1), new Pair(i-1, j+1), new Pair(i+1, j+1))) {
    //  int i2 = e.getValue();
    //  int j2 = e.getKey();
      
    //  if (i2 >= 0 && i2 < n && j2 >= 0 && j2 < n) {
    //    c = abs((wealth[i][j] - wealth[i2][j2]) / wealth[i2][j2]);
    //    b = 2/r;
        
    //    boolean p1 = player[i][j], p2 = player[i2][j2];
        
    //    if (p1 && p2) {
    //      wealth[i][j] += b - c;
    //      wealth[i2][j2] += b - c;
        
    //    } else if (p1 && !p2) {
          
    //      wealth[i][j] -= c;
    //      wealth[i2][j2] += 2*b;
          
    //    } else if (!p1 && p2) {
          
    //      wealth[i2][j2] += 2*b;
    //      wealth[i][j] -= c;
          
    //    } else {
    //      wealth[i][j] += 0;
    //      wealth[i2][j2] += 0;
    //    }
    //  }
    //} 
  }
  
  
}

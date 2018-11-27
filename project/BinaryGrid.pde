import java.util.concurrent.ThreadLocalRandom;

int _n;
float _r, _p, _R_1, _R_2;
boolean _dyn, _smt;

Textlabel label_b, label_c;

void setup_binary() {
  cp5.addNumberbox("_n")
     .setScrollSensitivity(1)
     .setRange(10, 256)
     .setValue(64)
     ;
  
  cp5.addNumberbox("_r")
     .setScrollSensitivity(.05)
     .setRange(1, 2)
     .setValue(1.81)
     ;
  
  cp5.addNumberbox("_p")
     .setScrollSensitivity(.07)
     .setValue(.1)
     .setRange(0,1)
     ;
     
  cp5.addNumberbox("_R_1")
     .setScrollSensitivity(1)
     .setValue(2)
     ;
     
  cp5.addNumberbox("_R_2")
     .setScrollSensitivity(1)
     .setValue(22)
     .linebreak()
     ;
     
  cp5.addToggle("_dyn")
     .setValue(false)
     ;
     
   cp5.addToggle("_smt")
     .setValue(false)
     .linebreak();
}

class BinaryGrid extends Grid {
  
  int visibility = 1;
  int m = 10;
  
  float R_1, R_2;
  float p;
  float b, c;
  boolean dynamic;
  
  float[][][][] payoff;
  
  public BinaryGrid(int n, float r, float p, float R_1, float R_2, boolean dyn, boolean smt) {
    super(n, r);
    
    this.R_1 = R_1;
    this.R_2 = R_2;
    this.p = p;
    this.dynamic = dyn;
    
    b = 2f/r;
    c = (R_2 - R_1) / R_1;
    
    payoff = new float[][][][] { /* rich */
                                   { /* rich */ 
                                       { {2*c+1      , c          },
                                         {b*c + b + c, b*c + b - 1}
                                       },
                                     /* poor */
                                       { {c + 1  , c          },
                                         {b*c + b, b*c + b - 1}
                                       }},
                                /* poor */
                                   { /* rich */
                                       { {c+1, 0  },
                                         {b+c, b-1}
                                       },
                                     /* poor */ 
                                       { {1, 0  },
                                         {b, b-1}}}};
  }
  
  
  public void distribute_wealth() {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        
        if (random(1) < p)
          wealth[i][j] = R_2;
          
        else
          wealth[i][j] = R_1;
      }
    }
  }
  
  public void distribute_players() {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
          player[i][j] = random(1) < .5;
      }
    }
  }
  
  public float ply(int i1, int j1, int i2, int j2) {
    int richness_1 = wealth[i1][j1] == R_2 ? 0 : 1;
    int richness_2 = wealth[i2][j2] == R_2 ? 0 : 1;
    int coop_1 = player[i1][j1] ? 0 : 1;
    int coop_2 = player[i2][j2] ? 0 : 1;
    
    return payoff[richness_1][richness_2][coop_1][coop_2];
  }
  
  public float play(int i, int j) {
    float A = 0;
    
    for (Pair<Integer, Integer> e : Arrays.asList(new Pair(i-1, j-1), new Pair(i+1, j-1), new Pair(i-1, j+1), new Pair(i+1, j+1))) {
      int i2 = ((e.getKey() % n) + n) % n;
      int j2 = ((e.getValue() % n) + n) % n;

      A += ply(i, j, i2, j2);
    }
     
    return A;
  }
  
  public void tick() {
    int i = ThreadLocalRandom.current().nextInt(0, n);
    int j = ThreadLocalRandom.current().nextInt(0, n);
    
    float num = 0;
    float den = 0;
    
    List<Pair> neigh = Arrays.asList(new Pair(i, j), new Pair(i-1, j-1), new Pair(i+1, j-1), new Pair(i-1, j+1), new Pair(i+1, j+1));
    for (Pair<Integer, Integer> e : neigh) {
      int i2 = ((e.getKey() % n) + n) % n;
      int j2 = ((e.getValue() % n) + n) % n;
        
      float Ai = play(i2, j2);
      float si = player[i2][j2] ? 1 : 0;
      
      num += Math.pow(Ai, m) * si;
      den += Math.pow(Ai, m);
    }
    
    float P = num / den;
    
    player[i][j] = random(1) < P;
    
    //float x = 0;
    //float N = 0;
    //float minW = Float.MAX_VALUE, maxW = Float.MIN_VALUE;
    
    //for (int i2 = i-visibility; i2 <= i+visibility; i2++) {
    //  for (int j2 = j-visibility; j2 <= j+visibility; j2++) {
        
    //    if (i2 >= 0 && i2 < n && j2 >= 0 && j2 < n) {
    //      N++;
    //      x += player[i2][j2];
          
    //      minW = min(minW, wealth[i2][j2]);
    //      maxW = max(maxW, wealth[i2][j2]);
    //    }
    //  }
    //}
    
    //float c = (maxW - minW) / minW;
    //float b = 2f / r;
    
    ////float z = wealth[i][j] >= ((maxW - minW)/2) ? -(c - b*c - b + 1) : -(-b + 1);
    //float z = -c;
    
    //float beta = 10;
    
    //float rand = random(1);
    
    //if (random(1) < .05) {
    //  float nP = player[i][j] + random(-0.05, 0.05);
    //  player[i][j] = constrain(nP, 0, 1);
    //}
    
    //player[i][j] -= (1f / (1f + Math.exp(beta * z)));
    
    if (dynamic) {
      for (Pair<Integer, Integer> e : Arrays.asList(new Pair(i-1, j-1), new Pair(i+1, j-1), new Pair(i-1, j+1), new Pair(i+1, j+1))) {
      int i2 = e.getValue();
      int j2 = e.getKey();
      
      if (i2 >= 0 && i2 < n && j2 >= 0 && j2 < n) {
        c = abs(wealth[i][j] - wealth[i2][j2]) / max(wealth[i][j], wealth[i2][j2]);
        b = 2f/r;
        
        boolean p1 = player[i][j], p2 = player[i2][j2];
        
        if (p1 && p2) {
          wealth[i][j] += b - c;
          wealth[i2][j2] += b - c;
        
        } else if (!p1 && p2) {
          
          wealth[i][j] -= c;
          wealth[i2][j2] += b;
          
        } else if (p1 && !p2) {
          
          wealth[i2][j2] += b;
          wealth[i][j] -= c;
          
        } else {
          wealth[i][j] += 0;
          wealth[i2][j2] += 0;
        }
      }
    } 
    }
  }
  
}

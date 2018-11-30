import java.util.concurrent.ThreadLocalRandom;

int _n;
int _update_type;
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
     
  cp5.addScrollableList("_update_type")
     .setPosition(height + 200, 140)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(Arrays.toString(UpdateType.values()).replaceAll("^.|.$", "").split(", "))
     .close()
     .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
     ;
     
  cp5.addToggle("_dyn")
     .setValue(false)
     .linebreak();
}

enum UpdateType {
  ORIGINAL, REPLICATOR, SOFTMAX; 
}

class BinaryGrid extends Grid {
  
  int visibility = 2;
  int m = 10;
  float beta = 1e-5;
  float eta = .5;
  
  float R_1, R_2;
  float p;
  float b, c;
  UpdateType update_type;
  
  boolean dynamic;
  
  float[][][][] payoff;
  
  public BinaryGrid(int n, float r, float p, float R_1, float R_2, boolean dyn, UpdateType type) {
    super(n, r);
    
    this.R_1 = R_1;
    this.R_2 = R_2;
    this.p = p;
    this.dynamic = dyn;
    this.update_type = type;
    
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
    if (!dynamic) {
      int richness_1 = wealth[i1][j1] == R_2 ? 0 : 1;
      int richness_2 = wealth[i2][j2] == R_2 ? 0 : 1;
      int coop_1 = player[i1][j1] ? 0 : 1;
      int coop_2 = player[i2][j2] ? 0 : 1;
      
      return payoff[richness_1][richness_2][coop_1][coop_2];
    } else {
        
      if (player[i1][j1] && player[i2][j2])
        return (wealth[i1][j1] + wealth[i2][j2]) / 2 * (r - 1);
      
      else if (player[i1][j1] && !player[i2][j2])
        return -(wealth[i1][j1] + wealth[i2][j2]) * (r - 1);
      
      else if (!player[i1][j1] && player[i2][j2])
        return (wealth[i1][j1] + wealth[i2][j2]) * (r - 1);
        
      else
        return 0;
    }
    
    
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
    
    float fC = 0, fD = 0;
    float Z = 0, k = 0;
    
    List<Pair> neigh = null;
    
    switch (update_type) {
      case ORIGINAL:
        neigh = Arrays.asList(new Pair(i, j), new Pair(i-1, j-1), new Pair(i+1, j-1), new Pair(i-1, j+1), new Pair(i+1, j+1));
        break;
      
      case SOFTMAX:
      case REPLICATOR:
        neigh = new ArrayList<Pair>();
        for (int x = i - visibility; x <= i + visibility; x++){
          for (int y = j - visibility; y <= j + visibility; y++) {
            neigh.add(new Pair(x, y));
          }
        }
        break;
    }
    
    
    for (Pair<Integer, Integer> e : neigh) {
      int i2 = ((e.getKey() % n) + n) % n;
      int j2 = ((e.getValue() % n) + n) % n;
        
      float Ai = play(i2, j2);
      float si = player[i2][j2] ? 1 : 0;
      
      num += Math.pow(Ai, m) * si;
      den += Math.pow(Ai, m);
      
      if (player[i2][j2])
        fC += Ai;
      else
        fD += Ai;
      
      Z++;
      k += si;
      
      if (dynamic) {
        wealth[i][j] += ply(i, j, i2, j2);
        wealth[i2][j2] += ply(i2, j2, i, j);
      }
    }
    
    switch (update_type) {
      case ORIGINAL:
        player[i][j] = random(1) < num / den;
        break;
      case SOFTMAX:
        player[i][j] = random(1) < (Math.exp(eta * fC) / (Math.exp(eta * fC) + Math.exp(eta * fD)));
        break;
      case REPLICATOR:
        player[i][j] = (k / Z) * ((Z - k)/ Z) * Math.tanh(beta / 2 * (fC - fD)) > 0;
        break;
      
    }
  }
}

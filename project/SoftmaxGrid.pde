class SoftmaxGrid extends BinaryGrid<Pair<Boolean, Double>> {
  
  int visibility = 2;
  float eta = .5;
  
  public SoftmaxGrid(int n, float r, float p, float R_1, float R_2, boolean dyn) {
    super(n, r, p, R_1, R_2, dyn);
  }
  
  public List<Pair> neighbours(int i, int j) {
    ArrayList<Pair> neigh = new ArrayList<Pair>();
    
    for (int x = i - visibility; x <= i + visibility; x++){
      for (int y = j - visibility; y <= j + visibility; y++) {
        neigh.add(new Pair(x, y));
      }
    }
    
    return neigh;
  }
  
  public Pair<Boolean, Double> step(int i, int j) {
    return new Pair<Boolean, Double>(player[i][j], play(i,j));
  }
  
  public void update(Collection<? extends Pair<Boolean, Double>> values, int i, int j) {
    double fC = 0, fD = 0;
    
    for (Pair<Boolean, Double> value : values) {
      if (value.getKey())
        fC += value.getValue();
      else
        fD += value.getValue();
    }
    
    player[i][j] = random(1) < (Math.exp(eta * fC) / (Math.exp(eta * fC) + Math.exp(eta * fD)));
  }
  
}

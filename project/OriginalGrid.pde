class OriginalGrid extends BinaryGrid<Pair<Double, Double>> {
  
  int m = 10;
  
  public OriginalGrid(int n, float r, float p, float R_1, float R_2, boolean dyn) {
    super(n, r, p, R_1, R_2, dyn);
  }
  
  public List<Pair> neighbours(int i, int j) {
    return Arrays.asList(new Pair(i, j), new Pair(i-1, j), new Pair(i+1, j), new Pair(i, j+1), new Pair(i, j-1));
  }
  
  public Pair<Double, Double> step(int i, int j) {
    double Ai = play(i, j);
    double si = player[i][j] ? 1 : 0;
    
    return new Pair<Double, Double>(Math.pow(Ai, m) * si, Math.pow(Ai, m));
  }
  
  public void update(Collection<? extends Pair<Double, Double>> values, int i, int j) {
    double n = 0, d = 0;
    
    for (Pair<Double, Double> value : values) {
      n += value.getKey();
      d += value.getValue();
    }
    
    player[i][j] = random(1) < n / d;
  } 
}

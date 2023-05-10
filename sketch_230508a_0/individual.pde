class Individual {

  float fitness;
  ArrayList<Float> genes;

  int maxShapes;

  Individual(int _maxShapes) {
    maxShapes = _maxShapes;
    int currentShapes = floor(random(1, _maxShapes));
    randomize(currentShapes);
  }

  Individual(ArrayList _genes, int _maxShapes) {
    genes = _genes;
    maxShapes = _maxShapes;
  }

  void randomize(int nShapes) { //imgId, x, y, scale, rot

    int nGenes = nShapes * 5;
    genes = new ArrayList<Float>();

    for (int i = 0; i < nGenes; i++) {
      genes.add(random(1));
    }
  }

  Individual onePointCrossover(Individual partner) {
    Individual child = new Individual(maxShapes);
    int crossover_point = int(random(1, genes.size() - 1));
    for (int i = 0; i < child.genes.size(); i++) {
      if (i < crossover_point && i < genes.size()) {
        child.genes.set(i, genes.get(i));
      } else if (i < partner.genes.size()) {
        child.genes.set(i, partner.genes.get(i));
      } else {
        break;
      }
    }
    return child;
  }

  void mutate(float rate) {
    for (int i = 0; i < genes.size(); i++) {
      if (random(1) <= rate) {
        genes.set(i, constrain(genes.get(i) + random(-0.1, 0.1), 0, 1));
      }
    }
    if (random(1) <= rate/2) {
      
      if (random(1) < 0.5) removeShape();
      else addShape();
    }
  }

  void addShape() {
    if (getNShapes() >= maxShapes) return;
    for (int i = 0; i < 5; i++) {
      genes.add(random(1));
    }
  }

  void removeShape() {
    if (getNShapes() <= 1) return;
    for (int i = 0; i < 5; i++) {
      genes.remove(genes.size()-1);
    }
  }

  PImage getPhenotype(int resolution) {
    PGraphics canvas = createGraphics(resolution, resolution);
    canvas.beginDraw();
    //canvas.background(255);
    render(canvas, canvas.width / 2, canvas.height / 2, canvas.width, canvas.height);
    canvas.endDraw();
    return canvas;
  }

  void render(PGraphics canvas, float x, float y, float w, float h) {
    canvas.pushMatrix();
    canvas.translate(x, y);
    canvas.noStroke();
    canvas.fill(255 - fitness*fitness*4, fitness*10, 255/5*fitness);
    canvas.circle(0, 0, w/(maxShapes*5) * fitness);
    canvas.popMatrix();
  }

  int getNShapes() {
    return genes.size()/5;
  }

  void setFitness(float _fitness) {
    fitness = _fitness;
  }

  float getFitness() {
    return fitness;
  }

  Individual getCopy() {
    Individual copy = new Individual(genes, maxShapes);
    copy.setFitness(fitness);
    return copy;
  }

  ArrayList<Float> getGenes() {
    return new ArrayList<Float>(genes);
  }
}

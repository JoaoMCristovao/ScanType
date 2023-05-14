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
    //if(true) return;
    for (int i = 0; i < genes.size(); i++) {
      //if (random(1) <= rate) {
        if (random(1) <= rate) {
        genes.set(i, constrain(genes.get(i) + random(-0.1, 0.1), 0, 1));
      }
    }
    /*
    if (random(1) <= rate/2) {
      if (random(1) < 0.5) removeShape();
      else addShape();
    }*/
  }

  void addShape() {
    if (getNShapes() >= maxShapes) return;
    for (int i = 0; i < 5; i++) {
      genes.add(random(1));
    }
  }

  void removeShape() {
    if (getNShapes() <= 1) return;
    int index = floor(random (getNShapes())) * 5;
    for (int i = index; i < index+5; i++) {
      genes.remove(index);
    }
  }

  PImage getPhenotype(boolean res, boolean hasBG) {
    int resolution = objectResolutionLow;
    if(res) resolution = objectResolutionHigh;
    PGraphics canvas = createGraphics(resolution, resolution);
    canvas.beginDraw();
    if(hasBG) canvas.background(255);
    render(canvas, canvas.width, canvas.height, res);
    canvas.endDraw();
    return canvas;
  }

  void render(PGraphics canvas, float w, float h, boolean res) { //imgId, x, y, scale, rot
    canvas.noStroke();
    for(int i = 0; i < getNShapes(); i++){
      int index = i * 5;
      canvas.pushMatrix();
      int imgIndex = constrain(floor(genes.get(index) * objectsHighRes.length), 0, objectsHighRes.length-1);
      canvas.fill(0);
      canvas.translate(genes.get(index + 1) * w,genes.get(index + 2) * h);
      canvas.scale(genes.get(index + 3));
      canvas.rotate(genes.get(index + 4) * TWO_PI);
      if(!res) canvas.image(objectsLowRes[imgIndex], 0, 0);
      else  canvas.image(objectsHighRes[imgIndex], 0, 0);
      
      canvas.popMatrix();
    }
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
    copy.fitness = fitness;
    return copy;
  }

  ArrayList<Float> getGenes() {
    return new ArrayList<Float>(genes);
  }
}

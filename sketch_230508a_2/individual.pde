class Individual {

  int genesPerShape = 6;
  int nLayers = 3;

  float fitness;
  ArrayList<Float> genes;

  int maxShapes;

  Individual(int _maxShapes) {
    maxShapes = _maxShapes;
    int currentShapes = floor(random(1, _maxShapes));
    randomize(currentShapes);
  }

  Individual(ArrayList<Float> _genes, int _maxShapes) {
    genes = new ArrayList<Float>();
    for (int i = 0; i < _genes.size(); i++) {
      genes.add(_genes.get(i));
    }
    maxShapes = _maxShapes;
  }

  void randomize(int nShapes) { //imgId, x, y, scale, rot

    int nGenes = nShapes * genesPerShape;
    genes = new ArrayList<Float>();

    for (int i = 0; i < nGenes; i++) {
      genes.add(random(1));
    }
  }

  Individual onePointCrossover(Individual partner) {
    Individual child = new Individual(maxShapes);
    int crossoverPoint = int(random(1, genes.size() - 1));   

    for (int i = 0; i < child.genes.size(); i++) {
      if (i < crossoverPoint) {
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
    for (int i = 0; i < genesPerShape; i++) {
      genes.add(random(1));
    }
  }

  void removeShape() {
    if (getNShapes() <= 1) return;
    int index = floor(random (getNShapes())) * genesPerShape;
    for (int i = index; i < index + genesPerShape; i++) {
      genes.remove(index);
    }
  }

  PImage getPhenotype(boolean res, boolean hasBG) {
    int resolution = objectResolutionLow;
    if (res) resolution = objectResolutionHigh;
    PGraphics canvas = createGraphics(resolution, resolution);
    canvas.beginDraw();
    canvas.background(255);
    render(canvas, canvas.width, canvas.height, res);
    canvas.endDraw();
    return canvas;
  }

  void render(PGraphics canvas, float w, float h, boolean res) { //imgId, x, y, scale, rot, layer
    canvas.noStroke();
    canvas.blendMode(MULTIPLY);

    for (int i = 0; i < getNShapes(); i++) {
      int index = i * genesPerShape;
      canvas.pushMatrix();
      int imgIndex = constrain(floor(genes.get(index) * objectsHighRes.length), 0, objectsHighRes.length-1);

      canvas.translate(genes.get(index + 1) * w, genes.get(index + 2) * h);

      canvas.scale( 0.2 + genes.get(index + 3) * 0.4);

      canvas.rotate(genes.get(index + 4) * TWO_PI);


      int layer = floor(genes.get(index + 5) * nLayers);

      switch(layer) {
      case 0: 
        canvas.tint(255, 0, 0);
        break;
      case 1: 
        canvas.tint(0, 255, 0);
        break;
      case 2: 
        canvas.tint(0, 0, 255);
        break;
      }

      if (!res) canvas.image(objectsLowRes[imgIndex], 0, 0);
      else  canvas.image(objectsHighRes[imgIndex], 0, 0);

      canvas.popMatrix();
    }
  }

  float getLayerDistribution() { //higher value means layers are being used more evenly
    float distributionValue;
    int[] nOfEachLayer = new int[nLayers];
    int modeNTimes = 1; //times the mode is repeated
    int optimalModeNTimes = ceil(float(getNShapes()) / float(nLayers));

    for (int i = 0; i < nLayers; i++) {
      nOfEachLayer[i] = 0;
    }

    for (int i = 0; i < getNShapes(); i++) {
      int index = i * genesPerShape;
      int layer = constrain(floor(genes.get(index + 5) * nLayers), 0, nLayers-1);
      nOfEachLayer[layer]++;
    }

    for (int i = 0; i < nLayers; i++) {
      if (nOfEachLayer[i] > modeNTimes) modeNTimes = nOfEachLayer[i];
    }

    distributionValue = float(optimalModeNTimes) / float(modeNTimes);

    return distributionValue;
  }

  int getNShapes() {
    return genes.size()/genesPerShape;
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

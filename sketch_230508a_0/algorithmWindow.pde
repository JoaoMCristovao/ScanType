class AlgorithmWindow {

  float x, y, w, h;
  Slider[] sliders;

  AlgorithmWindow(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    sliders = createSliders();
  }

  void update() {
    updateSliders();
  }

  void show() {
    pushMatrix();
    translate(x, y);
    showExplanation();
    showSliders();
    popMatrix();
  }

  void updateSliders() {
    pushMatrix();
    translate(x, y);
    translate(w/2 + gap*2, 0);
    for (int i = 0; i < sliders.length; i++) {
      sliders[i].update();
      translate(0, sliders[i].h);
    }
    int currentPopulationSize = int(sliders[0].getValue());
    sliders[3].maxVal = constrain(ceil(currentPopulationSize/4), 1, 1000);
    popMatrix();
  }

  void showExplanation() {
    
  }

  void showSliders() {
    pushMatrix();
    translate(w/2 + gap*2, 0);
    for (int i = 0; i < sliders.length; i++) {
      sliders[i].show();
      translate(0, sliders[i].h);
    }
    popMatrix();
  }


  Slider[] createSliders() {
    Slider[] newSliders = new Slider[6];
    
    float sliderW = w/2 - gap * 4;
    float sliderH = (h - gap * 2) / newSliders.length;

    newSliders[0] = new Slider(false, "Population Size", 1, 200, sliderW, sliderH);

    newSliders[1] = new Slider(true, "Mutation Rate", 0, 100, sliderW, sliderH);

    newSliders[2] = new Slider(true, "Crossover Rate", 0, 100, sliderW, sliderH);

    newSliders[3] = new Slider(false, "Tournament Size", 1, 25,sliderW, sliderH);

    newSliders[4] = new Slider(false, "Elitism", 0, 3, sliderW, sliderH);

    newSliders[5] = new Slider(false, "Maximum Shapes", 1, 10, sliderW, sliderH);

    return newSliders;
  }
  
  float getPopulation(){
    return sliders[0].getValue();
  }
  
  float getMutationRate(){
    return sliders[1].getValue()/100;
  }
  
  float getCrossoverRate(){
    return sliders[2].getValue()/100;
  }
  
  float getTournamentSize(){
    return sliders[3].getValue();
  }
  
  float getElitism(){
    return sliders[4].getValue();
  }
  
  float getMaximumShapes(){
    return sliders[5].getValue();
  }
  
}

class AlgorithmWindow {

  float x, y, w, h;
  float inputX;
  Slider[] sliders;
  Button coloursButton;

  AlgorithmWindow(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;

    inputX = w/2 + gap*2;

    sliders = createSliders();

    coloursButton = createButton();
    coloursButton.setEnabledState(false);
  }

  void update() {
    updateSliders();
    updateButton();
  }

  void show() {
    pushMatrix();
    translate(x, y);
    showExplanation();
    showSliders();
    showButton();
    popMatrix();
  }

  void updateSliders() {
    pushMatrix();
    translate(x, y);
    translate(inputX, 0);
    for (int i = 0; i < sliders.length; i++) {
      sliders[i].update();
      translate(0, sliders[i].h);
    }
    int currentPopulationSize = int(sliders[0].getValue());
    sliders[3].maxVal = constrain(ceil(currentPopulationSize/4), 1, 1000);

    int currentMaxShapes = int(sliders[6].getValue());
    sliders[5].maxVal = currentMaxShapes;

    float currentMaxShapeSize = sliders[8].getValue();
    sliders[7].maxVal = currentMaxShapeSize;

    popMatrix();
  }

  void showExplanation() {

    String explanation = 
      "■Population Size" +
      "\nNumber of individuals in your population." +
      "\n" +
      "\n■Mutation rate" +
      "\nThis value controls the probability of introducing random changes in an individual's chromosome in order to maintain diversity in the population and explore new solutions in the search space." +
      "\n" +
      "\n■Crossover rate" +
      "\nAlso known as recombination rate, this value refers to the probability that crossover will occur between two parent individuals during the reproduction process. It determines the likelihood of exchanging genetic material between individuals to create an offspring." +
      "\n" +
      "\n■Tournament Size" +
      "\nThis value refers to the number of individuals selected from the population to participate in a tournament, with the individual having the best fitness being chosen as a parent." +
      "\n" +
      "\n■Elitism" +
      "\nThis value defines the number of individuals from one generation that are directly carried over to the next generation without undergoing any genetic operations such as crossover or mutation." +
      "\n" +
      "\n■Maximum shapes" +
      "\nNumber of maximum shapes being used to draw individuals.";
    textSize(fontSizeSmall);
    textAlign(LEFT);
    textLeading(18);
    text(explanation, 0, 40, inputX - gap * 5, h);
  }

  void showSliders() {

    pushMatrix();
    translate(inputX, 0);
    for (int i = 0; i < sliders.length; i++) {
      sliders[i].show();
      translate(0, sliders[i].h);
    }
    popMatrix();
  }

  void updateButton() {
    pushMatrix();
    translate(inputX, 0);
    coloursButton.update();
    if (coloursButton.getSelected()) {
      coloursButton.setSelectedState(false);
      if (coloursButton.getEnabled()) {
        coloursButton.setText("Black");
      } else {
        coloursButton.setText("Coloured");
      }
      coloursButton.toggleEnabledState();
    }
    popMatrix();
  }

  void showButton() {
    pushMatrix();
    translate(inputX, 0);
    coloursButton.show();
    popMatrix();
  }

  Slider[] createSliders() {
    Slider[] newSliders = new Slider[9];

    float sliderW = w/2 - gap * 4;
    float sliderH = (h - gap * 10) / newSliders.length;

    newSliders[0] = new Slider(false, "Population Size", 5, 200, sliderW, sliderH, 0.8, true);

    newSliders[1] = new Slider(true, "Mutation Rate", 0, 100, sliderW, sliderH, 0.5, true);

    newSliders[2] = new Slider(true, "Crossover Rate", 0, 100, sliderW, sliderH, 0.85, true);

    newSliders[3] = new Slider(false, "Tournament Size", 1, 25, sliderW, sliderH, 0.25, true);

    newSliders[4] = new Slider(false, "Elitism", 1, 4, sliderW, sliderH, 0, true);

    newSliders[5] = new Slider(false, "Minimum Shapes", 1, 10, sliderW, sliderH, 0, true);

    newSliders[6] = new Slider(false, "Maximum Shapes", 1, 15, sliderW, sliderH, 0.8, true);

    newSliders[7] = new Slider(false, "Minimum Shape Size", 0, 1, sliderW, sliderH, 0, false);

    newSliders[8] = new Slider(false, "Maximum Shape Size", 0, 1, sliderW, sliderH, 0.4, false);

    return newSliders;
  }

  Button createButton() {
    float buttonY = (sliders[0].h * sliders.length) + gap * 3;
    float buttonW = gap * 15;
    float buttonH = h - buttonY;
    float buttonX = 0;
    return new Button("Coloured", true, buttonX, buttonY, buttonW, buttonH, fontSizeSmall);
  }

  float getPopulation() {
    return sliders[0].getValue();
  }

  float getMutationRate() {
    return sliders[1].getValue()/100;
  }

  float getCrossoverRate() {
    return sliders[2].getValue()/100;
  }

  float getTournamentSize() {
    return sliders[3].getValue();
  }

  float getElitism() {
    return sliders[4].getValue();
  }

  float getMinimumShapes() {
    return sliders[5].getValue();
  }

  float getMaximumShapes() {
    return sliders[6].getValue();
  }

  float getMinimumShapeSize() {
    return sliders[7].getValue();
  }

  float getMaximumShapeSize() {
    return sliders[8].getValue();
  }

  boolean getColouredState() {
    return  coloursButton.getEnabled();
  }
}

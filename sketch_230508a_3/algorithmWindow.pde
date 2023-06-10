class AlgorithmWindow {

  float x, y, w, h;
  float inputX;
  Slider[] sliders;
  Button coloursButton;
  float boxLeftPadding = gap * 3;

  AlgorithmWindow(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;

    inputX = w/2 + gap*2;

    sliders = createSliders();

    coloursButton = createButton();
    coloursButton.setEnabledState(true);
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
    popMatrix();
  }

  void showExplanation() {

    textSize(fontSizeSmall);
    fill(black);
    textAlign(LEFT, TOP);
    text("Evolutionary Algorithm Overview", 0, boxLeftPadding - 30);
    
    
    String explanation_text = 
      "Population Size" +
      "\nNumber of individuals in your population." +
      "\n\nMutation rate" +
      "\nThis value controls the probability of introducing random changes in an individual's chromosome in order to maintaining diversity in the population and exploring new solutions in the search space." +
      "\n\nCrossover rate" +
      "\nAlso known as recombination rate, this value refers to the probability that crossover will occur between two parent individuals during the reproduction process. It determines the likelihood of exchanging genetic material between individuals to create offspring." +
      "\n\nTournament Size" +
      "\nThis value refers to the number of individuals selected from the population to participate in a tournament for the purpose of selecting parents for reproduction, with the individual having the best fitness being chosen as a parent." +
      "\n\nElitism" +
      "\nThis value defines the number of individuals from one generation that are directly carried over to the next generation without undergoing any genetic operations such as crossover or mutation.  The purpose of elitism is to preserve the best solutions found so far, ensuring they are not lost during the evolutionary process." +
      "\n\nMaximum shapes" +
      "\nNumber of maximum shapes being used to draw individuals.";
      push();
      textSize(12.5);
      //textFont(fontWeightRegular);
      text(explanation_text, 0, boxLeftPadding * 1.5, 530, 1100);
      pop();
   
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
        coloursButton.setText("Press to activate Coloring Layers");
      } else {
        coloursButton.setText("Press to deactivate Coloring Layers");
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
    Slider[] newSliders = new Slider[6];

    float sliderW = w/2 - gap * 4;
    float sliderH = (h - gap * 12) / newSliders.length;

    newSliders[0] = new Slider(false, "Population Size", 5, 200, sliderW, sliderH, 0.5);

    newSliders[1] = new Slider(true, "Mutation Rate", 0, 100, sliderW, sliderH, 0.5);

    newSliders[2] = new Slider(true, "Crossover Rate", 0, 100, sliderW, sliderH, 0.85);

    newSliders[3] = new Slider(false, "Tournament Size", 1, 25, sliderW, sliderH, 0.25);

    newSliders[4] = new Slider(false, "Elitism", 1, 4, sliderW, sliderH, 0);

    newSliders[5] = new Slider(false, "Maximum Shapes", 1, 10, sliderW, sliderH, 0.8);

    return newSliders;
  }

  Button createButton() {
    float buttonY = (sliders[0].h * sliders.length) + gap * 6;
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

  float getMaximumShapes() {
    return sliders[5].getValue();
  }
  
  boolean getColouredState() {
     return  coloursButton.getEnabled();
  }
}

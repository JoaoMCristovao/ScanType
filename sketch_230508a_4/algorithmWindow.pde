class AlgorithmWindow {

  float x, y, w, h;
  float inputX;
  Slider[] sliders;
  Button coloursButton;

  PVector[] colorPickerLocations;
  ColorPicker [] colorPickers;

  AlgorithmWindow(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;

    inputX = w/2 + gap*2;

    sliders = createSliders();

    coloursButton = createButton();
    coloursButton.setEnabledState(false);

    colorPickerLocations = calculateColorPickerLocations(3, w - inputX - coloursButton.w - gap * 6, gap*3);
    colorPickers = createColorPickers(colorPickerLocations);
  }

  void update() {
    updateSliders();
    updateButton();
    if (coloursButton.getEnabled()) updateColorPickers();
  }

  void show() {
    pushMatrix();
    translate(x, y);
    showExplanation();
    showSliders();
    showButton();
    if (coloursButton.getEnabled()) showColorPickers();
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
    popMatrix();
    
    int currentPopulationSize = int(sliders[1].getValue());
    sliders[4].maxVal = constrain(ceil(currentPopulationSize/4), 1, 1000);

    int currentMaxShapes = int(sliders[6].getValue());
    sliders[7].maxVal = currentMaxShapes;

    float currentMaxShapeSize = sliders[8].getValue();
    sliders[9].maxVal = currentMaxShapeSize;

  }

  void showExplanation() {

    String explanation =
      "■ Population Size" +
      "\nNumber of individuals in your population." +
      "\n" +
      "\n ■Mutation rate" +
      "\nThis value controls the probability of introducing random changes in an individual's chromosome in order to maintain diversity in the population and explore new solutions in the search space." +
      "\n" +
      "\n ■Crossover rate" +
      "\nAlso known as recombination rate, this value refers to the probability that crossover will occur between two parent individuals during the reproduction process. It determines the likelihood of exchanging genetic material between individuals to create an offspring." +
      "\n" +
      "\n ■Tournament Size" +
      "\nThis value refers to the number of individuals selected from the population to participate in a tournament, with the individual having the best fitness being chosen as a parent." +
      "\n" +
      "\n ■Elitism" +
      "\nThis value defines the number of individuals from one generation that are directly carried over to the next generation without undergoing any genetic operations such as crossover or mutation." +
      "\n" +
      "\n ■Maximum shapes" +
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

  void updateColorPickers() {
    pushMatrix();
    translate(x, y);
    translate(inputX + coloursButton.w + gap * 4, coloursButton.y);
    for (int i = 0; i < colorPickers.length; i++) {
      pushMatrix();
      translate(colorPickerLocations[i].x, 0);
      colorPickers[i].update();
      popMatrix();
    }
    popMatrix();
  }

  void showColorPickers() {
    pushMatrix();
    translate(inputX + coloursButton.w + gap * 4, coloursButton.y);
    for (int i = 0; i < colorPickers.length; i++) {
      pushMatrix();
      translate(colorPickerLocations[i].x, 0);
      colorPickers[i].show();
      popMatrix();
    }
    popMatrix();
  }

  //x is x, y is w
  PVector[] calculateColorPickerLocations(int _nColorPickers, float _availableW, float _gapW) {
    PVector[] colorPickerValues = new PVector[_nColorPickers];

    int nGaps = _nColorPickers - 1;

    float totalColorPickerW = _availableW - (nGaps * _gapW);

    float colorPickerW = totalColorPickerW / _nColorPickers;

    for (int i = 0; i < _nColorPickers; i++)
    {
      float previousX = 0;
      float currentX = 0;
      if (i > 0) {
        previousX = colorPickerValues[i - 1].x;
        currentX += previousX + colorPickerW + _gapW;
      }

      colorPickerValues[i] = new PVector(currentX, colorPickerW);
    }

    return colorPickerValues;
  }

  Slider[] createSliders() {
    Slider[] newSliders = new Slider[10];

    float sliderW = w/2 - gap * 4;
    float sliderH = (h - gap * 10) / newSliders.length;
    
    newSliders[0] = new Slider(false, "Maximum Generation", 50, 1000, sliderW, sliderH, 1, true);

    newSliders[1] = new Slider(false, "Population Size", 5, 200, sliderW, sliderH, 0.5, true);

    newSliders[2] = new Slider(true, "Mutation Rate", 0, 100, sliderW, sliderH, 0.20, true);

    newSliders[3] = new Slider(true, "Crossover Rate", 0, 100, sliderW, sliderH, 0.30, true);

    newSliders[4] = new Slider(false, "Tournament Size", 1, 25, sliderW, sliderH, 0.25, true);

    newSliders[5] = new Slider(false, "Elitism", 0, 4, sliderW, sliderH, 0.25, true);
    
    newSliders[6] = new Slider(false, "Maximum Shapes", 1, 40, sliderW, sliderH, 0.8, true);

    newSliders[7] = new Slider(false, "Minimum Shapes", 1, 10, sliderW, sliderH, 0, true);
    
    newSliders[8] = new Slider(false, "Maximum Shape Size", 0, 1, sliderW, sliderH, 0.4, false);

    newSliders[9] = new Slider(false, "Minimum Shape Size", 0, 1, sliderW, sliderH, 0.3, false);

    return newSliders;
  }

  Button createButton() {
    float buttonY = (sliders[0].h * sliders.length) + gap * 3;
    float buttonW = gap * 15;
    float buttonH = h - buttonY;
    float buttonX = 0;
    return new Button("Black", true, buttonX, buttonY, buttonW, buttonH, fontSizeSmall);
  }

  ColorPicker[] createColorPickers(PVector[] _locations) {
    int nColorPickers = _locations.length;
    ColorPicker[] newColorPickers = new ColorPicker[nColorPickers];
    for (int i = 0; i < nColorPickers; i ++) {
      newColorPickers[i] = new ColorPicker(_locations[i].y, coloursButton.h);
    }

    return newColorPickers;
  }
  
  float getMaxGeneration() {
    return sliders[0].getValue();
  }

  float getPopulation() {
    return sliders[1].getValue();
  }

  float getMutationRate() {
    return sliders[2].getValue()/100;
  }

  float getCrossoverRate() {
    return sliders[3].getValue()/100;
  }

  float getTournamentSize() {
    return sliders[4].getValue();
  }

  float getElitism() {
    return sliders[5].getValue();
  }

  float getMinimumShapes() {
    return sliders[7].getValue();
  }

  float getMaximumShapes() {
    return sliders[6].getValue();
  }

  float getMinimumShapeSize() {
    return sliders[9].getValue();
  }

  float getMaximumShapeSize() {
    return sliders[8].getValue();
  }

  boolean getColouredState() {
    return  coloursButton.getEnabled();
  }

  color[] getColors() {
    color[] colors= new color[colorPickers.length];
    for (int i = 0; i < colorPickers.length; i++) {
      colors[i] = colorPickers[i].getCurrentColor();
    }
    return colors;
  }
}

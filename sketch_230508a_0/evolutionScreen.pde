class EvolutionScreen {

  //main
  float w, h;

  //box left
  float boxLeftW = 0.25;
  float boxLeftPadding = gap * 3;
  Button evoStartButton;
  Button saveButton;

  //algorithm window
  AlgorithmWindow algorithmWindow;

  //abc buttons
  Button[][] alphabetButtons;
  float alphabetH;
  float alphabetW;

  //evolution
  boolean evolving;
  PVector evoGridPos;
  PVector[][] evoGrid;
  Population evoPopulation;

  EvolutionScreen(float _w, float _h) {
    w = _w;
    h = _h;

    //Button(String _buttonText, boolean _type, float _x, float _y, float _w, float _h, float _fontSize)
    evoStartButton = new Button("Start Evolving", true, 0, h - gap * 7, w * boxLeftW, gap * 7, fontSizeMedium);
    saveButton = new Button("Save glyph to archive", true, w * boxLeftW - gap * 24 - boxLeftPadding, h - gap * 14, gap * 24, gap * 4, fontSizeSmall);

    alphabetButtons = createAlphabetButtons();

    evoGridPos = new PVector(boxLeftW * w + mainPadding, alphabetH + mainPadding);
    

    algorithmWindow = new AlgorithmWindow(evoGridPos.x, evoGridPos.y, w - evoGridPos.x, h - evoGridPos.y);
  }

  void update() {
    evoStartButton.update();

    if (evoStartButton.getSelected() && !evoStartButton.getEnabled()) {
      evoStartButton.setSelectedState(false);
      evoStartButton.setEnabledState(true);
      startNewEvolution();
      evoStartButton.setText("Stop Evolving");
      evolving = true;
    } else if (evoStartButton.getSelected() && evoStartButton.getEnabled()) {
      evoStartButton.setSelectedState(false);
      evoStartButton.setEnabledState(false);
      evoStartButton.setText("Start Evolving");
      console.setMessage("Stopped Evolving");
      evolving = false;
    } else if (evoPopulation != null && evoStartButton.getEnabled()) evoPopulation.evolve();
    else if (!evolving) algorithmWindow.update();
  }

  void show() {
    showAlphabetButtons();
    showBoxLeft();
    if (!evolving) showAlgorithmWindow();
    else showEvolutionGrid();
  }

  void showBoxLeft() {
    noFill();
    stroke(black);
    strokeWeight(1);
    rect(0, 0, w * boxLeftW, h);

    showSettings();
    showBestIndividual();
    evoStartButton.show();
  }

  void showBestIndividual() {
    noFill();
    stroke(black);

    float sideSize = w * boxLeftW - gap * 6;
    float bestX = boxLeftPadding;
    float bestY = saveButton.y - gap - sideSize;

    if (evoPopulation != null) {
      image(evoPopulation.getIndiv(0).getPhenotype(true, false), bestX, bestY, sideSize, sideSize);
    }

    square(bestX, bestY, sideSize);

    saveButton.show();
  }

  void showSettings() {
    String info;

    if (evoPopulation != null) {
      info = "Current Generation: " + evoPopulation.getGenerations() +
        "\n\nMax Shapes: " + evoPopulation.maxShapes +
        "\nPopulation Size: " + evoPopulation.individuals.length +
        "\nMutation Rate: " + evoPopulation.mutationRate*100 + "%" + 
        "\nCrossover Rate: " + evoPopulation.crossoverRate*100 + "%" + 
        "\nTournament Size: " + evoPopulation.tournamentSize +
        "\nElitism: " + evoPopulation.eliteSize +
        "\n\nBest Fitness: " + evoPopulation.getIndiv(0).getFitness();
    } else {
      info = "Current Generation: -" +
         "\n\nMax Shapes: -" +
        "\nPopulation Size: -" +
        "\nMutation Rate: -" +
        "\nCrossover Rate: -" +
        "\nTournament Size: -"+
        "\nElitism: -" +
        "\n\nBest Fitness: _";
    }

    textSize(fontSizeSmall);
    fill(black);
    textAlign(LEFT, TOP);
    text(info, boxLeftPadding, boxLeftPadding);
  }

  void showAlgorithmWindow() {
    algorithmWindow.show();
  }

  void showEvolutionGrid() {
    int row = 0, col = 0;
    for (int i = 0; i < evoPopulation.individuals.length; i++) {
      if (i == 0) fill(white);
      else fill(lightGray);
      if (mouseX > screenX(evoGrid[row][col].x, 0) && mouseX < screenX(evoGrid[row][col].x + evoGrid[row][col].z, 0) 
        && mouseY > screenY(0, evoGrid[row][col].y) && mouseY < screenY(0, evoGrid[row][col].y + evoGrid[row][col].z)) strokeWeight(2);
      else  strokeWeight(1);
      stroke(black);
      rect(evoGrid[row][col].x, evoGrid[row][col].y, evoGrid[row][col].z, evoGrid[row][col].z);
      if (evoPopulation != null) image(evoPopulation.getIndiv(i).getPhenotype(false, false), evoGrid[row][col].x, evoGrid[row][col].y, evoGrid[row][col].z, evoGrid[row][col].z);
      col += 1;
      if (col >= evoGrid[row].length) {
        row += 1;
        col = 0;
      }
    }
  }

  void showAlphabetButtons() {
    for (int i = 0; i < alphabetButtons.length; i++) {
      for (int j = 0; j < alphabetButtons[0].length; j++) { 
        alphabetButtons[i][j].show();
      }
    }
  }

  void startNewEvolution() {
    String glyphToEvolve = "Z";
    for (int i = 0; i < alphabetButtons.length; i++) {
      for (int j = 0; j < alphabetButtons[0].length; j++) { 
        if (alphabetButtons[i][j].getEnabled()) glyphToEvolve = alphabetButtons[i][j].buttonText;
      }
    }
    PImage referenceImage = loadImage("/references/" + glyphToEvolve + ".png");

    int popSize = int(algorithmWindow.getPopulation());
    int maxShapes = int(algorithmWindow.getMaximumShapes());
    int eliteSize = int(algorithmWindow.getElitism());
    float mutation = algorithmWindow.getMutationRate();
    float crossover = algorithmWindow.getCrossoverRate();
    int tournamentSize = int(algorithmWindow.getTournamentSize());
    
    evoGrid = calculateGrid(popSize, evoGridPos.x, evoGridPos.y, w - evoGridPos.x, h - evoGridPos.y, 0, gap, gap, true);
    
    // Population         (PImage _referenceImage, int _populationSize, int _maxShapes, int _eliteSize, float _mutationRate, float _crossoverRate, int _tournamentSize) {
    evoPopulation = new Population(referenceImage,             popSize,      maxShapes,      eliteSize,            mutation,            crossover,      tournamentSize);
    console.setMessage("Started evolution towards letter " + glyphToEvolve);
  }

  Button[][] createAlphabetButtons() {
    int nColumns = 26;
    int nRows = 2;

    Button[][] newButtons = new Button[nColumns][nRows];

    String alphabet = "abcdefghijklmnopqrstuvwxyz";

    alphabetW = w - (w * boxLeftW + mainPadding);

    float initialX = w * boxLeftW + mainPadding;
    float currentX = initialX;
    float currentY = 0;

    float xInc = alphabetW / nColumns;
    float yInc = xInc;

    alphabetH = yInc * 2;

    for (int i = 0; i < nRows; i++) {  
      for (int j = 0; j < nColumns; j++) {
        String currentLetter = str(alphabet.charAt(j));
        if (i == 0) currentLetter = currentLetter.toUpperCase();

        newButtons[j][i] = new Button(currentLetter, true, currentX, currentY, xInc, yInc, fontSizeSmall);
        currentX += xInc;
      }
      currentX = initialX;
      currentY += yInc;
    }

    newButtons[0][0].setEnabledState(true);

    return newButtons;
  }
}

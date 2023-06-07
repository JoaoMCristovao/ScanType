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
  int evolutionStartTimeMS;

  EvolutionScreen(float _w, float _h) {
    w = _w;
    h = _h;

    evoStartButton = new Button("Start Evolving", true, 0, h - gap * 7, w * boxLeftW, gap * 7, fontSizeMedium);
    saveButton = new Button("Save glyph to archive", true, w * boxLeftW - gap * 24 - boxLeftPadding, h - gap * 14, gap * 24, gap * 4, fontSizeSmall);

    alphabetButtons = createAlphabetButtons();

    evoGridPos = new PVector(boxLeftW * w + mainPadding, alphabetH + mainPadding);

    algorithmWindow = new AlgorithmWindow(evoGridPos.x, evoGridPos.y, w - evoGridPos.x, h - evoGridPos.y);
  }

  void update() {
    evoStartButton.update();

    if (evoStartButton.getSelected() && !evoStartButton.getEnabled()) { //Started evolving
      evoStartButton.setSelectedState(false);
      if (!startNewEvolution()) return;
      evoStartButton.setEnabledState(true);
      disableAlphabetButtons(true);
      evoStartButton.setText("Stop Evolving");
      evolving = true;
    } else if (evoStartButton.getSelected() && evoStartButton.getEnabled()) { //Stopped evolving
      evoStartButton.setSelectedState(false);
      evoStartButton.setEnabledState(false);
      evoStartButton.setText("Start Evolving");
      console.setMessage("Stopped Evolving");
      println(evoPopulation.getIndiv(0).genes);
      disableAlphabetButtons(false);
      evolving = false;
    } else if (evoPopulation != null && evoStartButton.getEnabled()) evoPopulation.evolve(); //Is evolving
    else if (!evolving) { //Not evolving
      algorithmWindow.update();
      updateAlphabetButtons();
    }
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

    imageMode(CORNER);

    if (evoPopulation != null) {
      image(evoPopulation.getIndiv(0).getPhenotype(true, false), bestX, bestY, sideSize, sideSize);
    }

    tint(255, 20);
    image(getReferenceImage(getGlyphToEvolve()), bestX, bestY, sideSize, sideSize);
    noTint();

    square(bestX, bestY, sideSize);

    saveButton.show();
  }

  void showSettings() {
    String info;

    textFont(fontWeightRegular);

    if (evoPopulation != null) {
      info = 
        "Current Generation: " + evoPopulation.getGenerations() +
        "\nElapsed Time: " + evoPopulation.getElapsedTime() +
        "\n\nMax Shapes: " + evoPopulation.maxShapes +
        "\nPopulation Size: " + evoPopulation.individuals.length +
        "\nMutation Rate: " + evoPopulation.mutationRate*100 + "%" + 
        "\nCrossover Rate: " + evoPopulation.crossoverRate*100 + "%" + 
        "\nTournament Size: " + evoPopulation.tournamentSize +
        "\nElitism: " + evoPopulation.eliteSize +
        "\n\nBest Fitness: " + evoPopulation.getIndiv(0).getFitness();
    } else {
      info = 
        "Current Generation: -" +
        "\nElapsed Time: -" +
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

  void showEvolutionGrid() { //
    imageMode(CORNER);
    int row = 0, col = 0;
    for (int i = 0; i < evoPopulation.individuals.length; i++) {
      if (evoPopulation != null) image(evoPopulation.getIndiv(i).getPhenotype(false, false), evoGrid[row][col].x, evoGrid[row][col].y, evoGrid[row][col].z, evoGrid[row][col].z);
      noFill();
      if (mouseX > screenX(evoGrid[row][col].x, 0) && mouseX < screenX(evoGrid[row][col].x + evoGrid[row][col].z, 0) 
        && mouseY > screenY(0, evoGrid[row][col].y) && mouseY < screenY(0, evoGrid[row][col].y + evoGrid[row][col].z)) strokeWeight(2);
      else  strokeWeight(1);
      stroke(black);
      rect(evoGrid[row][col].x, evoGrid[row][col].y, evoGrid[row][col].z, evoGrid[row][col].z);
      col += 1;
      if (col >= evoGrid[row].length) {
        row += 1;
        col = 0;
      }
    }
  }

  void updateAlphabetButtons() {
    for (int i = 0; i < alphabetButtons.length; i++) {
      for (int j = 0; j < alphabetButtons[0].length; j++) { 
        alphabetButtons[i][j].update();
        if (alphabetButtons[i][j].getSelected()) {
          alphabetButtons[i][j].setSelectedState(false);
          alphabetButtons[i][j].setEnabledState(true);
          enableAlphabetButtons(i, j, false);
        }
      }
    }
  }

  void enableAlphabetButtons(int c, int r, boolean state) {
    for (int i = 0; i < alphabetButtons.length; i++) {
      for (int j = 0; j < alphabetButtons[0].length; j++) {
        if (i != c || j != r) {
          alphabetButtons[i][j].setEnabledState(state);
        }
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

  void disableAlphabetButtons(boolean state) {
    for (int i = 0; i < alphabetButtons.length; i++) {
      for (int j = 0; j < alphabetButtons[0].length; j++) { 
        if (!alphabetButtons[i][j].getEnabled())alphabetButtons[i][j].setDisabledState(state);
      }
    }
  }

  String getGlyphToEvolve () {
    String glyph = "Z";
    for (int i = 0; i < alphabetButtons.length; i++) {
      for (int j = 0; j < alphabetButtons[0].length; j++) { 
        if (alphabetButtons[i][j].getEnabled()) {
          glyph = alphabetButtons[i][j].buttonText;
          if (j > 0) glyph += "_";
        }
      }
    }

    return glyph;
  }

  PImage getReferenceImage(String glyph) {
    return loadImage("/references/" + glyph + ".png");
  }

  boolean startNewEvolution() {
    PImage[] savedShapes = scanScreen.getEnabledSavedShaped(); //TODO todo enable only these shapes
    if (savedShapes == null) {
      console.setMessage("No shapes enabled. Select some in the scan screen to start evolving.");
      return false;
    }

    String glyphToEvolve = getGlyphToEvolve();
    PImage referenceImage = getReferenceImage(glyphToEvolve);

    int popSize = int(algorithmWindow.getPopulation());
    int maxShapes = int(algorithmWindow.getMaximumShapes());
    int eliteSize = int(algorithmWindow.getElitism());
    float mutation = algorithmWindow.getMutationRate();
    float crossover = algorithmWindow.getCrossoverRate();
    int tournamentSize = int(algorithmWindow.getTournamentSize());

    evoGrid = calculateGrid(popSize, evoGridPos.x, evoGridPos.y, w - evoGridPos.x, h - evoGridPos.y, 0, gap, gap, true);

    evoPopulation = new Population(referenceImage, popSize, maxShapes, eliteSize, mutation, crossover, tournamentSize);
    if (glyphToEvolve.length() > 1) glyphToEvolve = glyphToEvolve.substring( 0, glyphToEvolve.length()-1 );
    console.setMessage("Started evolution towards letter " + glyphToEvolve);
    evolutionStartTimeMS = millis();
    return true;
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

  void exportIndividual() {
  }
}

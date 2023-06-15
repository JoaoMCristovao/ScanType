class EvolutionScreen {

  //main
  float w, h;

  //box left
  float boxLeftW = 0.25;
  float boxLeftPadding = gap * 3;
  Button evoStartButton;
  Button exportButton;

  //algorithm window
  AlgorithmWindow algorithmWindow;
  PVector algorithmWindowPos;

  //abc buttons
  Button[][] alphabetButtons;
  float alphabetH;
  float alphabetW;

  //font buttons
  Button[] fontButtons;

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
    exportButton = new Button("Save glyph to archive", true, w * boxLeftW - gap * 24 - boxLeftPadding, h - gap * 14, gap * 24, gap * 4, fontSizeSmall);

    alphabetButtons = createAlphabetButtons();
    fontButtons = createFontButtons();

    evoGridPos = new PVector(boxLeftW * w + mainPadding, 0);
    algorithmWindowPos = new PVector(boxLeftW * w + mainPadding, alphabetH + mainPadding);

    algorithmWindow = new AlgorithmWindow(algorithmWindowPos.x, algorithmWindowPos.y, w - algorithmWindowPos.x, h - algorithmWindowPos.y);
  }

  void update() {
    evoStartButton.update();
    updateExportButton();

    if (evoStartButton.getSelected() && !evoStartButton.getEnabled()) { //Started evolving
      evoStartButton.setSelectedState(false);
      if (!startNewEvolution()) return;
      evoStartButton.setEnabledState(true);
      disableAlphabetButtons(true);
      evoStartButton.setText("Stop Evolving");
      evolving = true;
    } else if ((evoStartButton.getSelected() && evoStartButton.getEnabled()) || (evoPopulation != null && evoPopulation.generations >= evoPopulation.maxGeneration && evoStartButton.getEnabled())) { //Stopped evolving
      evoStartButton.setSelectedState(false);
      evoStartButton.setEnabledState(false);
      evoStartButton.setText("Start Evolving");
      console.setMessage("Stopped Evolving");
      disableAlphabetButtons(false);
      evolving = false;
    } else if (evoPopulation != null && evoStartButton.getEnabled()) evoPopulation.evolve(); //Is evolving
    else if (!evolving) { //Not evolving
      algorithmWindow.update();
      updateAlphabetButtons();
      runFontButtons();
    }
  }

  void show() {

    showBoxLeft();
    if (!evolving) {
      showAlgorithmWindow();
      showAlphabetButtons();
    } else showEvolutionGrid();
  }

  void showBoxLeft() {
    noFill();
    stroke(darkGray);
    strokeWeight(1);
    rect(0, 0, w * boxLeftW, h);

    showBestIndividual();
    showSettings();
    evoStartButton.show();
  }

  void updateExportButton() {
    exportButton.update();
    if (exportButton.getSelected()) {
      exportButton.setSelectedState(false);
      exportIndividual(0);
    }
  }

  void showBestIndividual() {
    noFill();
    stroke(darkGray);

    float sideSize = w * boxLeftW - gap * 6;
    float bestX = boxLeftPadding;
    float bestY = exportButton.y - gap - sideSize;

    imageMode(CORNER);

    if (evoPopulation != null) {
      image(evoPopulation.getIndiv(0).getPhenotype(true), bestX, bestY, sideSize, sideSize);
    }

    tint(255, 20);
    image(getReferenceImage(getGlyphToEvolve()), bestX, bestY, sideSize, sideSize);
    noTint();

    square(bestX, bestY, sideSize);

    exportButton.show();
  }

  void showSettings() {
    String info;

    textFont(fontWeightRegular);

    if (evoPopulation != null) {
      info =
        "Generation: " + evoPopulation.getGenerations() + " / " + evoPopulation.maxGeneration +
        "\nElapsed Time: " + evoPopulation.getElapsedTime() +
        "\n\nNumber of Shapes: " + evoPopulation.minShapes + " – " + evoPopulation.maxShapes +
        "\nSize of Shapes: " + nf(evoPopulation.minShapeSize, 0, 2) + " – " + nf(evoPopulation.maxShapeSize, 0, 2) +
        "\nPopulation Size: " + evoPopulation.individuals.length +
        "\nMutation Rate: " + int(evoPopulation.mutationRate*100) + "%" +
        "\nCrossover Rate: " + int(evoPopulation.crossoverRate*100) + "%" +
        "\nTournament Size: " + evoPopulation.tournamentSize +
        "\nElitism: " + evoPopulation.eliteSize +
        "\n\nBest Fitness: " + evoPopulation.getIndiv(0).getFitness();
    } else {
      info =
        "Generation: - / -" +
        "\nElapsed Time: -" +
        "\n\nNumber of Shapes: -" +
        "\nSize of Shapes: -" +
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
    noFill();
    strokeWeight(1);
    stroke(black);
    int row = 0, col = 0;
    for (int i = 0; i < evoPopulation.individuals.length; i++) {
      if (evoPopulation != null) image(evoPopulation.getIndiv(i).getPhenotype(false), evoGrid[row][col].x, evoGrid[row][col].y, evoGrid[row][col].z, evoGrid[row][col].z);
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
  
  //run = update + show
  void runFontButtons() {
    pushMatrix();

    translate(w * boxLeftW + mainPadding, gap*2 + alphabetH);
    for (int i = 0; i < fontButtons.length; i ++) {

      fontButtons[i].update();
      if (fontButtons[i].getSelected() && !fontButtons[i].getEnabled()) {
        fontButtons[i].setSelectedState(false);
        fontButtons[i].setEnabledState(true);
        enableFontButtons(i, false);
      }
      fontButtons[i].show();
    }

    popMatrix();
  }

  void enableFontButtons (int index, boolean state) {
    for (int i = 0; i < fontButtons.length; i ++) {
      if (i != index) fontButtons[i].setEnabledState(state);
    }
  }

  void disableFontButtons(boolean state) {
    for (int i = 0; i < fontButtons.length; i ++) {
      fontButtons[i].setDisabledState(state);
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
    return loadImage("/references/" + getEnabledFontFolder() + "/" + glyph + ".png");
  }

  String getEnabledFontFolder() {
    for (int i = 0; i < fontButtons.length; i++) {
      if (fontButtons[i].getEnabled()) {
        return fontButtons[i].buttonText;
      }
    }
    return fontButtons[0].buttonText;
  }

  boolean startNewEvolution() {
    if (enabledShapeIndexes.length < 1) {
      console.setMessage("No shapes enabled. Select some in the scan screen to start evolving.");
      return false;
    }

    String glyphToEvolve = getGlyphToEvolve();
    PImage referenceImage = getReferenceImage(glyphToEvolve);

    int maxGeneration = int(algorithmWindow.getMaxGeneration());
    int popSize = int(algorithmWindow.getPopulation());
    int minShapes = int(algorithmWindow.getMinimumShapes());
    int maxShapes = int(algorithmWindow.getMaximumShapes());
    float minShapeSize = algorithmWindow.getMinimumShapeSize();
    float maxShapeSize = algorithmWindow.getMaximumShapeSize();
    int eliteSize = int(algorithmWindow.getElitism());
    float mutation = algorithmWindow.getMutationRate();
    float crossover = algorithmWindow.getCrossoverRate();
    int tournamentSize = int(algorithmWindow.getTournamentSize());
    
    boolean isColoured = algorithmWindow.getColouredState();
    color[] colors = algorithmWindow.getColors();

    evoGrid = calculateGrid(popSize, evoGridPos.x, evoGridPos.y, w - evoGridPos.x, h - evoGridPos.y, 0, gap, gap, true);

    evoPopulation = new Population(glyphToEvolve, referenceImage, maxGeneration, popSize, minShapes, maxShapes, minShapeSize, maxShapeSize, eliteSize, mutation, crossover, tournamentSize, isColoured, colors);
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

  Button[] createFontButtons() {
    String directory = "/references";

    File f = dataFile(directory);
    String[] names = f.list();

    Button[] newButtons = new Button[names.length];

    for (int i = 0; i < 3; i ++) {
      float buttonWidth = names[i].length()* gap * 1.3;
      float previousButtonX = 0;
      float previousButtonW = 0;

      if (i>0) {
        previousButtonX = newButtons[i-1].x + gap * 3;
        previousButtonW = newButtons[i-1].w;
      }

      newButtons[i] = new Button(names[i], true, previousButtonX + previousButtonW, 0, buttonWidth, gap * 3, fontSizeSmall);
    }

    newButtons[0].setEnabledState(true);

    return newButtons;
  }

  void exportIndividual(int index) {
    if (evoPopulation == null || index >= evoPopulation.getSize()) {
      console.setMessage("Individual not found. Try starting an evolution first.");
      return;
    }
    
    String filename = evoPopulation.targetGlyph + "-gen_" + evoPopulation.getGenerations() + "-pop_" + evoPopulation.getPopulationSize() + "-mut_" + nf(evoPopulation.mutationRate, 0, 2) + 
    "-co_" + nf(evoPopulation.crossoverRate, 0, 2) + "-tou_" + evoPopulation.tournamentSize + "-nSh_" + evoPopulation.minShapes + "_" + evoPopulation.maxShapes + "-shS_" + nf(evoPopulation.minShapeSize, 0, 2) + "_" + nf(evoPopulation.maxShapeSize, 0, 2);
    String path = sketchPath("data/outputs/" + filename);

    evoPopulation.getIndiv(index).getPhenotype(true).save(path + ".png");

    console.setMessage("Exported to folder outputs: " + filename);
  }
}

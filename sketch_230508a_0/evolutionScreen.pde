class EvolutionScreen {

  //main
  float w, h;

  //box left
  float boxLeftW = 0.25;
  Button evoStartButton;

  //abc buttons
  Button[][] alphabetButtons;
  float alphabetH;
  float alphabetW;

  //evolution
  PVector evoGridPos;
  PVector[][] evoGrid;
  int evoPopulationSize = floor(random(20, 500));
  Population evoPopulation;

  EvolutionScreen(float _w, float _h) {
    w = _w;
    h = _h;

    //Button(String _buttonText, boolean _type, float _x, float _y, float _w, float _h, float _fontSize)
    evoStartButton = new Button("Start Evolving", true, 0, h - gap * 7, w * boxLeftW, gap * 7, fontSizeSmall);

    alphabetButtons = createAlphabetButtons();

    evoGridPos = new PVector(boxLeftW * w + mainPadding, alphabetH + mainPadding);
    evoGrid = calculateGrid(evoPopulationSize, evoGridPos.x, evoGridPos.y, w - evoGridPos.x, h - evoGridPos.y, 0, gap, gap, true);
  }

  void update() {
    evoStartButton.update();
    if (evoStartButton.getSelected()) {
      evoStartButton.setSelectedState(false);
      startNewEvolution(evoPopulationSize);
    } else if(evoPopulation != null) evoPopulation.evolve();
  }

  void show() {
    showAlphabetButtons();
    showEvolutionGrid();
    showBoxLeft();
  }

  void showBoxLeft() {
    noFill();
    stroke(black);
    strokeWeight(1);
    rect(0, 0, w * boxLeftW, h);

    evoStartButton.show();
  }

  void showEvolutionGrid() {
    int row = 0, col = 0;
    for (int i = 0; i < evoPopulationSize; i++) {
      if (i == 0) fill(white);
      else fill(lightGray);
      if (mouseX > screenX(evoGrid[row][col].x, 0) && mouseX < screenX(evoGrid[row][col].x + evoGrid[row][col].z, 0) 
        && mouseY > screenY(0, evoGrid[row][col].y) && mouseY < screenY(0, evoGrid[row][col].y + evoGrid[row][col].z)) strokeWeight(2);
      else  strokeWeight(1);
      stroke(black);
      rect(evoGrid[row][col].x, evoGrid[row][col].y, evoGrid[row][col].z, evoGrid[row][col].z);
      if(evoPopulation != null) image(evoPopulation.getIndiv(i).getPhenotype(100), evoGrid[row][col].x, evoGrid[row][col].y, evoGrid[row][col].z, evoGrid[row][col].z);
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

  void startNewEvolution(int _populationSize) {
    //Population(int _populationSize, int _maxShapes, int _eliteSize, float _mutationRate, float _crossoverRate, int _tournamentSize)
    evoPopulation = new Population(_populationSize, floor(random(1,10)), floor(random(1,4)), random(0.5), random(0.5), floor(random(3,10)));
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

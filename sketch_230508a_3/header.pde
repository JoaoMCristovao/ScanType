class Header {

  float h;
  boolean state;
  int page;

  Button scanButton, evolutionButton, archiveButton;
  Button[] headerButtons = new Button[2];

  Header(float _h) {
    h = _h;

    headerButtons[0] = new Button("Scan Object", false, width - 72*gap, 0, 37*gap, h, fontSizeBig);
    headerButtons[1] = new Button("Evolve Letters", false, width - 36*gap, 0, 37*gap, h, fontSizeBig);

    headerButtons[0].setEnabledState(true);
  }

  void update() {
    updateButtons();
    detectClicks();
  }

  void show() {
    stroke(black);
    strokeWeight(1);

    line(mainPadding, h, width - mainPadding, h);

    showTitle();
    showButtons();
  }
  
  void showTitle(){
    textFont(fontWeightBold);
    
    fill(black);
    textSize(fontSizeBig);
    textAlign(LEFT, CENTER);

    text("SCAN TYPE", mainPadding, h/2 - fontSizeMedium/6);
  }

  void updateButtons() {
    for (int i = 0; i < headerButtons.length; i++)
    {
      headerButtons[i].update();
    }
  }

  void showButtons() {
    for (int i = 0; i < headerButtons.length; i++)
    {
      headerButtons[i].show();
    }
  }

  void detectClicks() {
    for (int i = 0; i < headerButtons.length; i++)
    {
      if (headerButtons[i].getSelected()) {
        setCurrentScreen(i);
        headerButtons[i].setEnabledState(true);
        headerButtons[i].setSelectedState(false);
        for (int j = 0; j < headerButtons.length; j++)
        {
          if(j != i) headerButtons[j].setEnabledState(false);
        }
        return;
      }
    }
  }

  void setCurrentScreen(int screenID) {
    currentScreen = screenID;
  }
}

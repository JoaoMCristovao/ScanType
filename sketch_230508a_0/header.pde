class Header {

  float boxHeight;
  boolean state;
  int page;

  Button scanButton, evolutionButton, archiveButton;

  Header(float h) {
    boxHeight = h;
    scanButton = new Button("Scan Object", false, width - 600, 0, 100, boxHeight, fontSizeMedium);
    evolutionButton = new Button("Evolving Letters", false, width - 400, 0, 100, boxHeight, fontSizeMedium);
    archiveButton = new Button("Letter Archive", false, width - 200, 0, 100, boxHeight, fontSizeMedium);
  }

  void update(){

  }

  void show() {
    noStroke();
    fill(lightGray);
    rect(0, 0, width, boxHeight);
    
    scanButton.show();
    evolutionButton.show();
    archiveButton.show();
  }
}

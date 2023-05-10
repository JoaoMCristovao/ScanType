//colisao -> 0/1 soma
//questionarios 

//colors

color white = color(255);
color black = color(0);
color lightGray = color(200);
color gray = color (130);
color darkGray = color(50);

//measurements

int gap = 8; //measurement unit
int mainPadding = gap * 4;

//typography

int fontSizeTiny = 10;
int fontSizeSmall = 24;
int fontSizeMedium = 32;
int fontSizeBig = 46;
int fontSizeHuge = 72;

PFont fontWeightLight;
PFont fontWeightRegular;
PFont fontWeightBold;

//major components
Header header;
Console console;

ScanScreen scanScreen;
EvolutionScreen evolutionScreen;
ArchiveScreen archiveScreen;

int currentScreen = 0;


void settings() {
  //size(1080, 720);
  fullScreen();
}

void setup() {
  //gap = width/240;
  loadFonts();

  textFont(fontWeightRegular);

  float headerHeight = gap * 12;
  float consoleHeight = gap * 6;

  float screenWidth = width - mainPadding * 2;
  float screenHeight = height - headerHeight - consoleHeight - mainPadding * 2;

  scanScreen = new ScanScreen(screenWidth, screenHeight);
  evolutionScreen = new EvolutionScreen(screenWidth, screenHeight);
  archiveScreen = new ArchiveScreen(screenWidth, screenHeight);

  header = new Header(headerHeight);
  console = new Console(consoleHeight);
}

void draw() {
  background(white);

  header.update();

  pushMatrix();
  translate(mainPadding, header.h + mainPadding);
  switch(currentScreen) {
  case 0: 
    scanScreen.update();
    scanScreen.show();
    break;
  case 1: 
    evolutionScreen.update();
    evolutionScreen.show();
    break;
  case 2: 
    archiveScreen.update();
    archiveScreen.show();
    break;
  }
  popMatrix();

  header.show();
  console.show();
}

void mousePressed() {
  
}

void keyPressed() { //sliders / shortcuts
}

void loadFonts() {
  String directory = "fonts/WorkSans-";
  String fileType = ".ttf";
  int fontSize = 32;

  fontWeightLight = createFont(directory + "Light" + fileType, fontSize);
  fontWeightRegular = createFont(directory + "Regular" + fileType, fontSize);
  fontWeightBold = createFont(directory + "Bold" + fileType, fontSize);
}

PVector[][] calculateGrid(int cells, float x, float y, float w, float h, float margin_min, float gutter_h, float gutter_v, boolean align_top) {
  int cols = 0, rows = 0;
  float cell_size = 0;
  while (cols * rows < cells) {
    cols += 1;
    cell_size = ((w - margin_min * 2) - (cols - 1) * gutter_h) / cols;
    rows = floor((h - margin_min * 2) / (cell_size + gutter_v));
  }
  if (cols * (rows - 1) >= cells) {
    rows -= 1;
  }
  float margin_hor_adjusted = ((w - cols * cell_size) - (cols - 1) * gutter_h) / 2;
  if (rows == 1 && cols > cells) {
    margin_hor_adjusted = ((w - cells * cell_size) - (cells - 1) * gutter_h) / 2;
  }
  float margin_ver_adjusted = ((h - rows * cell_size) - (rows - 1) * gutter_v) / 2;
  if (align_top) {
    margin_ver_adjusted = min(margin_hor_adjusted, margin_ver_adjusted);
  }
  PVector[][] positions = new PVector[rows][cols];
  for (int row = 0; row < rows; row++) {
    float row_y = y + margin_ver_adjusted + row * (cell_size + gutter_v);
    for (int col = 0; col < cols; col++) {
      float col_x = x + margin_hor_adjusted + col * (cell_size + gutter_h);
      positions[row][col] = new PVector(col_x, row_y, cell_size);
    }
  }
  return positions;
}

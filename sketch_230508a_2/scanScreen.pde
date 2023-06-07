class ScanScreen {

  float w, h;

  //capture
  float captureY = gap * 30;
  float captureW = gap * 70; //70
  PGraphics captureImg;
  Button saveShapeButton;

  //filter
  float filterH = gap * 10;
  Button[] filterButtons = new Button[3];
  float buttonW = gap * 30;
  float buttonH = gap * 3;

  //slider
  Slider thresholdSlider;

  //saved
  float savedW;
  PVector[][] savedGrid;
  Button[] shapeButtons;

  ScanScreen(float _w, float _h) {
    w = _w;
    h = _h;

    thresholdSlider = new Slider(false, "Threshold", 0, 255, captureW, gap * 10, 0.5);

    filterButtons[0] = new Button("Binarize Image", false, 0, buttonH * 1.2, buttonW, buttonH, fontSizeSmall, LEFT, TOP);
    filterButtons[1] = new Button("Canny Edge Detector", false, 0, buttonH * 1.2 * 2, buttonW, buttonH, fontSizeSmall, LEFT, TOP);
    filterButtons[2] = new Button("Sobel Edge Detector", false, 0, buttonH * 1.2 * 3, buttonW, buttonH, fontSizeSmall, LEFT, TOP);

    filterButtons[0].setEnabledState(true);

    saveShapeButton = new Button("SAVE SHAPE", true, 0, 0, buttonW, buttonH*2, fontSizeSmall, CENTER, CENTER);

    savedW = w - captureW - mainPadding * 2;
    calculateSavedObjectsGrid();
    createShapesButtons();
  }

  void update() {
  }

  void show() {
    showCapture();
    showSaveButton();
    runFilterSelection();
    runSlider();
    updateShapeButtons();
    showShapeButtons();
  }

  void showCapture() {
    pushMatrix();
    translate(0, captureY);

    square(0, 0, captureW);
    if (video.available()) {
      video.read();
    }

    captureImg = cropToSquare(video, captureW);

    image(captureImg, 0, 0, captureW, captureW);

    noFill();
    stroke(black);
    square(0, 0, captureW);

    popMatrix();
  }

  void showSaveButton() {
    pushMatrix();

    translate(0, captureY + captureW + gap * 2);

    saveShapeButton.update();
    if (saveShapeButton.getSelected()) {
      saveShapeButton.setSelectedState(false);
      saveShape();
    }
    saveShapeButton.show();
    popMatrix();
  }

  void runFilterSelection() {
    pushMatrix();

    translate(0, 0);
    textFont(fontWeightRegular);
    textSize(fontSizeSmall);
    textAlign(LEFT, TOP);
    fill(black);
    text("FILTER", 0, 0);

    for (int i = 0; i < filterButtons.length; i++) {
      filterButtons[i].update();
      if (filterButtons[i].getSelected()) {
        filterButtons[i].setSelectedState(false);
        filterButtons[i].setEnabledState(true);
        enableFalseFilterButtons(i);
      }
      filterButtons[i].show();
    }

    popMatrix();
  }

  void runSlider() {
    pushMatrix();

    translate(0, filterH + mainPadding);
    thresholdSlider.update();
    thresholdSlider.show();

    popMatrix();
  }
  
  void updateShapeButtons(){
    for (int i = 0; i < shapeButtons.length; i++) {
      shapeButtons[i].update();
      if(shapeButtons[i].selected){
        shapeButtons[i].setSelectedState(false);
        shapeButtons[i].toggleEnabledState();
        return;
      }
    }
  }

  void showShapeButtons() {
    noStroke();
    fill(gray);

    pushMatrix();
    translate(w-savedW, 0);

    int row = 0, col = 0;
    for (int i = 0; i < shapeButtons.length; i++) {
      
      shapeButtons[i].show();
      
      col += 1;
      if (col >= savedGrid[row].length) {
        row += 1;
        col = 0;
      }
    }

    popMatrix();
    noTint();
  }

  void enableFalseFilterButtons(int index) {
    for (int i = 0; i < filterButtons.length; i++) {

      if (index != i) filterButtons[i].setEnabledState(false);
    }
  }

  PGraphics cropToSquare(PImage src, float _res) {
    int res = int(_res);
    PGraphics canvas = createGraphics(res, res);

    imageMode(CORNER);

    canvas.beginDraw();
    canvas.pushMatrix();
    canvas.translate(canvas.width, 0);
    canvas.scale(-1, 1);
    canvas.imageMode(CENTER);
    canvas.image(src, canvas.width/2, canvas.height/2);
    canvas.popMatrix();
    canvas.filter(THRESHOLD, thresholdSlider.currentValue);
    canvas.filter(INVERT);
    canvas.endDraw();

    return canvas;
  }

  void saveShape() {
    PGraphics toExport = captureImg;
    toExport.filter(INVERT);
    toExport.loadPixels();
    for (int i = 0; i < toExport.width * toExport.height; i++) {
      if (brightness(toExport.pixels[i]) < 230) toExport.pixels[i] = color(0, 0, 0, 0);
    }
    toExport.updatePixels();

    File f = dataFile("/objects");
    String[] fileNames = f.list();

    toExport.save("/data/objects/shape" + (fileNames.length + 1) + ".png");
    console.setMessage("New object saved");
    loadObjects();
    calculateSavedObjectsGrid();
    createShapesButtons();
  }

  void calculateSavedObjectsGrid() {
    savedGrid = calculateGrid(objectsLowRes.length, 0, 0, savedW, h, 0, gap, gap, true);
  }

  void createShapesButtons() {
    Button[] newShapeButtons = new Button[objectsLowRes.length];

    int row = 0, col = 0;

    for (int i = 0; i < objectsLowRes.length; i++) {
      newShapeButtons[i] = new Button(objectsLowRes[i], savedGrid[row][col].x, savedGrid[row][col].y, savedGrid[row][col].z, savedGrid[row][col].z);
      
      if(shapeButtons != null && i < shapeButtons.length) newShapeButtons[i].setEnabledState(shapeButtons[i].getEnabled());
      
      col += 1;
      if (col >= savedGrid[row].length) {
        row += 1;
        col = 0;
      }
    }
    
    shapeButtons = newShapeButtons;
  }
  
  PImage[] getEnabledSavedShaped(){
   ArrayList<PImage> enabledShapes = new ArrayList<PImage>();
   PImage[] finalEnabledShapes;
   
   for(int i = 0; i < shapeButtons.length; i++){
     if(shapeButtons[i].getEnabled()) enabledShapes.add(shapeButtons[i].buttonImage);
   }
   
   if(enabledShapes.size() < 1) return null;
   
   finalEnabledShapes = new PImage[enabledShapes.size()];
   
   for(int i = 0; i < enabledShapes.size(); i ++){
     finalEnabledShapes[i] = enabledShapes.get(i);
   }
   
   return finalEnabledShapes;
  }
  
  
}

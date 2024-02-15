class ScanScreen {

  float w, h;

  //capture
  float captureY = gap * 8 + mainPadding;
  float captureW = gap * 50; //70
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
  
  //state all shape
  Button enableAllButton;
  Button disableAllButton;

  ScanScreen(float _w, float _h) {
    w = _w;
    h = _h;

    thresholdSlider = new Slider(false, "Threshold", 0, 255, captureW, gap * 10, 0.5, true);

    filterButtons[0] = new Button("Binarize Image", false, 0, buttonH * 1.2, buttonW, buttonH, fontSizeSmall, LEFT, TOP);
    filterButtons[1] = new Button("Canny Edge Detector", false, 0, buttonH * 1.2 * 2, buttonW, buttonH, fontSizeSmall, LEFT, TOP);
    filterButtons[2] = new Button("Sobel Edge Detector", false, 0, buttonH * 1.2 * 3, buttonW, buttonH, fontSizeSmall, LEFT, TOP);

    filterButtons[0].setEnabledState(true);

    saveShapeButton = new Button("SAVE SHAPE", true, 0, 0, buttonW, buttonH*2, fontSizeSmall, CENTER, CENTER);

    //enableAllButton = new Button("Enable All", true, w - buttonW*2 - gap * 6, buttonH, fontSizeSmall, CENTER, CENTER);
    //disableAllButton = new Button("Disable All", true, w - buttonW, buttonH, fontSizeSmall, CENTER, CENTER);
    
                           //Button(String _buttonText, boolean _boxed, float _x, float _y, float _w, float _h, float _fontSize) {
    enableAllButton = new Button("Enable All", true, w - buttonW - gap * 2, h - buttonH, buttonW/2, buttonH*1.5, fontSizeSmall);
    disableAllButton = new Button("Disable All", true, w - buttonW/2, h - buttonH, buttonW/2, buttonH*1.5, fontSizeSmall);

    savedW = w - captureW - mainPadding * 2;
    calculateSavedObjectsGrid();
    createShapesButtons();
    enableOnlyNShapeButtons(3);
    setEnabledShapeIndexes();
  }

  void update() {
    enableAllButton.update();
    if(enableAllButton.getSelected()){
        enableAllButton.setSelectedState(false);
        enableStateAllShapebuttons(true);
        setEnabledShapeIndexes();
    }
    disableAllButton.update();
    if(disableAllButton.getSelected()){
        disableAllButton.setSelectedState(false);
        enableStateAllShapebuttons(false);
        setEnabledShapeIndexes();
    }
  }

  void show() {
    if(video != null){
      showCapture();
      showSaveButton();
      //runFilterSelection();
      runSlider();
    }
    updateShapeButtons();
    showShapeButtons();
    enableAllButton.show();
    disableAllButton.show();
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
    stroke(darkGray);
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

    translate(0, -gap*2);
    thresholdSlider.update();
    thresholdSlider.show();

    popMatrix();
  }

  void updateShapeButtons() {
    for (int i = 0; i < shapeButtons.length; i++) {
      shapeButtons[i].update();
      if (shapeButtons[i].selected) {
        shapeButtons[i].setSelectedState(false);
        shapeButtons[i].toggleEnabledState();
        setEnabledShapeIndexes();
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
      if (brightness(toExport.pixels[i]) < 230) toExport.pixels[i] = color(0, 0, 0, 0); //perguntar
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
    savedGrid = calculateGrid(objectsLowRes.length, 0, 0, savedW, h - buttonH*1.5 + gap*4, 0, gap, gap, true);
  }

  void createShapesButtons() {
    Button[] newShapeButtons = new Button[objectsLowRes.length];

    int row = 0, col = 0;

    for (int i = 0; i < objectsLowRes.length; i++) {
      newShapeButtons[i] = new Button(objectsLowRes[i], savedGrid[row][col].x, savedGrid[row][col].y, savedGrid[row][col].z, savedGrid[row][col].z);

      if (shapeButtons != null && i < shapeButtons.length) newShapeButtons[i].setEnabledState(shapeButtons[i].getEnabled());

      col += 1;
      if (col >= savedGrid[row].length) {
        row += 1;
        col = 0;
      }
    }

    shapeButtons = newShapeButtons;
  }
  
  void enableOnlyNShapeButtons(int _n){
    if(shapeButtons.length < _n) return;
        
    ArrayList <Integer> indexes = new ArrayList<Integer>();
    ArrayList <Integer> chosenIndexes = new ArrayList<Integer>();
    
    
    for(int i = 0; i < shapeButtons.length; i++){
      indexes.add(i);
    }
    
    for(int i = 0; i < _n; i++){ 
       chosenIndexes.add(indexes.get(floor(random(indexes.size()))));
    }
    
    enableStateAllShapebuttons(false);
    
    for(int i = 0; i < chosenIndexes.size(); i++){
       shapeButtons[chosenIndexes.get(i)].setEnabledState(true);
    }
  }
  
  void enableStateAllShapebuttons(boolean state){
    for(int i = 0; i < shapeButtons.length; i++){
       shapeButtons[i].setEnabledState(state); 
    }
  }

  void setEnabledShapeIndexes() {
    ArrayList<Integer> enabledShapesIndexes = new ArrayList<Integer>();
    int[] finalEnabledShapesIndexes;

    for (int i = 0; i < shapeButtons.length; i++) {
      if (shapeButtons[i].getEnabled()) enabledShapesIndexes.add(i);
    }

    finalEnabledShapesIndexes = new int[enabledShapesIndexes.size()];

    for (int i = 0; i < enabledShapesIndexes.size(); i ++) {
      finalEnabledShapesIndexes[i] = enabledShapesIndexes.get(i);
    }

    enabledShapeIndexes = finalEnabledShapesIndexes;
  }
}

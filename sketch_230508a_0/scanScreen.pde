class ScanScreen {

  float w, h;

  //capture
  float captureW = gap * 70; //70
  PGraphics captureImg;

  //filter
  float filterH = gap * 10;
  Button[] filterButtons = new Button[3];
  float buttonW = gap * 30;
  float buttonH = gap * 3;

  //slider
  Slider thresholdSlider;

  //saved
  float savedW = gap * 70;
  PVector[][] savedGrid;

  ScanScreen(float _w, float _h) {
    w = _w;
    h = _h;

    thresholdSlider = new Slider(false, "Threshold", 0, 255, w - captureW - savedW - mainPadding * 2, gap * 10);

    filterButtons[0] = new Button("Binarize Image", false, 0, buttonH * 1.2, buttonW, buttonH, fontSizeSmall, LEFT, TOP);
    filterButtons[1] = new Button("Canny Edge Detector", false, 0, buttonH * 1.2 * 2, buttonW, buttonH, fontSizeSmall, LEFT, TOP);
    filterButtons[2] = new Button("Sobel Edge Detector", false, 0, buttonH * 1.2 * 3, buttonW, buttonH, fontSizeSmall, LEFT, TOP);

    filterButtons[0].setEnabledState(true);

    savedGrid = calculateGrid(objectsLowRes.length, 0, 0, savedW, h, 0, gap, gap, true);
  }

  void update() {
  }

  void show() {
    showCapture();
    runFilterSelection();
    runSlider();
    showSaved();
  }

  void showCapture() {

    //square(0, 0, captureW);
    if (video.available()) {
      video.read();
    }

    captureImg = cropToSquare(video, captureW);

    //image(captureImg, 0, 0, captureW, captureW);
  }

  void runFilterSelection() {
    pushMatrix();

    translate(captureW + mainPadding, 0);
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

    translate(captureW + mainPadding, filterH + mainPadding);
    thresholdSlider.update();
    thresholdSlider.show();

    popMatrix();
  }

  void showSaved() {
    noStroke();
    fill(gray);
    //rect(w-savedW, 0, savedW, h);

    pushMatrix();
    translate(w-savedW, 0);

    int row = 0, col = 0;
    for (int i = 0; i < objectsLowRes.length; i++) {
      fill(lightGray);
      stroke(black);
      strokeWeight(1);
      rect(savedGrid[row][col].x, savedGrid[row][col].y, savedGrid[row][col].z, savedGrid[row][col].z);
      pushMatrix();
      
      float toScale = 0;
      if(objectsLowRes[i].width > objectsLowRes[i].height){
        toScale = objectsLowRes[i].width / savedGrid[row][col].z;
      } else {
        toScale = objectsLowRes[i].height / savedGrid[row][col].z;
      }
      toScale = 1/toScale;
      scale(toScale);
      
      translate((savedGrid[row][col].x+savedGrid[row][col].z/2)/toScale, (savedGrid[row][col].y+savedGrid[row][col].z/2)/toScale);
      
      imageMode(CENTER);
      
      image(objectsLowRes[i], 0,0, savedGrid[row][col].z, savedGrid[row][col].z);
      popMatrix();
      col += 1;
      if (col >= savedGrid[row].length) {
        row += 1;
        col = 0;
      }
    }

    popMatrix();
  }

  void enableFalseFilterButtons(int index) {
    for (int i = 0; i < filterButtons.length; i++) {

      if (index != i) filterButtons[i].setEnabledState(false);
    }
  }

  /*PGraphics cropToSquare(PImage src, float _res) {
   int res = int(_res);
   PGraphics canvas = createGraphics(res, res);
   
   int w = src.width;
   int h = src.height;
   
   float aspectRatio = w / h;
   
   if (w >= h) {
   src.resize(res, floor(res/aspectRatio));
   } else {
   src.resize(floor(res*aspectRatio), res);
   }
   
   canvas.beginDraw();
   canvas.image(src, 0, 0);
   canvas.endDraw();
   
   return canvas;
   }*/

  PGraphics cropToSquare(PImage src, float _res) {
    int res = int(_res);
    PGraphics canvas = createGraphics(res, res);

    /*int w = src.width;
    int h = src.height;

    float aspectRatio = w / h;

    if (w >= h) {
      src.resize(res, floor(res/aspectRatio));
    } else {
      src.resize(floor(res*aspectRatio), res);
    }*/
    
    //imageMode(CENTER);

    canvas.beginDraw();
    canvas.image(src, res/2, res/2);
    canvas.endDraw();

    return canvas;
  }
}

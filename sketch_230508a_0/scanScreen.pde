class ScanScreen {

  float w, h;
  
  //capture
  float captureW = gap * 70;
  
  //filter
  float filterH = gap * 10;
  Button[] filterButtons = new Button[3];
  float buttonW = gap * 20;
  float buttonH = gap * 3;
  
  //slider
  Slider thresholdSlider;
  
  //saved
  float savedW = gap * 70;
  
  ScanScreen(float _w, float _h){
    w = _w;
    h = _h;
    
    thresholdSlider = new Slider(false, "Threshold", 0, 255, w - captureW - savedW - mainPadding * 2, gap * 10);
    //                          (String _buttonText, boolean _type, float _x, float _y   , float _w, float _h, float _fontSize) {
    filterButtons[0] = new Button("Binarize Image",  false        , 0       , buttonH    , buttonW,  buttonH,  fontSizeSmall, CENTER, TOP);
    filterButtons[1] = new Button("Binarize Image",  false        , 0       , buttonH* 2 , buttonW,  buttonH,  fontSizeSmall, CENTER, TOP);
    filterButtons[2] = new Button("Binarize Image",  false        , 0       , buttonH* 3 , buttonW,  buttonH,  fontSizeSmall, CENTER, TOP);
    
    filterButtons[0].setEnabledState(true);
  }
  
  void update() {
    
  }

  void show() {
    
    
    showCapture();
    runFilterSelection();
    runSlider();
    showSaved();
  }
  
  void showCapture(){
    fill(gray);
    square(0,0, captureW);
  }
  
  void runFilterSelection(){
    pushMatrix();
    
    translate(captureW + mainPadding, 0);
        textFont(fontWeightRegular);
    textSize(fontSizeSmall);
    textAlign(LEFT, TOP);
    fill(black);
    text("FILTER", 0, 0);
    
    for(int i = 0; i < filterButtons.length; i++){
      filterButtons[i].update();
      if(filterButtons[i].getSelected()){
        filterButtons[i].setEnabledState(true);
        enableFalseFilterButtons(i);
      }
      filterButtons[i].show();
    }
    
    popMatrix();
  }
  
  void runSlider(){
    pushMatrix();
    
    translate(captureW + mainPadding, filterH + mainPadding);
    thresholdSlider.update();
    thresholdSlider.show();
    
    popMatrix();
  }
  
  void showSaved(){
    noStroke();
    fill(gray);
    rect(w-savedW, 0, savedW, h);
  }
  
  void enableFalseFilterButtons(int index){
    for(int i = 0; i < filterButtons.length; i++){
      if(index != i) filterButtons[i].setEnabledState(false); 
    }
  }
  
  
}

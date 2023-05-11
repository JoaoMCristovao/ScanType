class Slider {
  boolean isPercentage;
  String legend;
  int minVal;
  int maxVal;
  float w, h;

  float currentValue = random(1);
  float lineWeight = gap;
  float sidePadding = 5 * gap;
  boolean hovered;
  float lineHeight;

  Slider(boolean _isPercentage, String _legend, int _minVal, int _maxVal, float _w, float _h) {
    isPercentage = _isPercentage;
    legend = _legend;
    minVal = _minVal;
    maxVal = _maxVal;
    w = _w;
    h = _h;
    
    lineHeight = h - h/6;
  }

  void update() {
    hovered = detectHover();
    if(mousePressed && hovered){
     float inputValue =  map(mouseX,  screenX(sidePadding, 0), screenX(w-sidePadding, 0), 0, 1);
     currentValue = constrain(inputValue, 0, 1);
    }
  }

  void show() {
    fill(black);
    textFont(fontWeightRegular);
    textSize(fontSizeSmall);
    textAlign(LEFT, CENTER);
    String currentLegend = legend + ": " + nf(getValue(), 0, 0);
    if(isPercentage) currentLegend += "%";
    text(currentLegend, 0, h/2);
    
    textSize(fontSizeTiny);
    textAlign(LEFT, CENTER);
    text(minVal, 0, lineHeight - fontSizeTiny/5);
    
    
    textAlign(RIGHT, CENTER);
    text(maxVal, w, lineHeight - fontSizeTiny/5);
    
    float lineLength = w - sidePadding*2;
    strokeWeight(lineWeight);
    stroke(lightGray);
    line(sidePadding, lineHeight, w-sidePadding, lineHeight);
    
    float selectedLength = lineLength * currentValue;
    if(!hovered) stroke(darkGray);
    else stroke(black);
    line(sidePadding, lineHeight, sidePadding + selectedLength, lineHeight);
}

  float getValue() {
    float val = (maxVal - minVal) * currentValue + minVal;
    return int(val);
  }

  void setMin(int val) {
    minVal = val;
  }

  void setMax(int val) {
    maxVal = val;
  }
  
  boolean detectHover() {
    if (mouseX < screenX(sidePadding, 0))return false; //screenX and screenY because of translations
    if (mouseX > screenX(w-sidePadding, 0))return false;
    if (mouseY < screenY(0, lineHeight - lineWeight*2)) return false;
    if (mouseY > screenY(0, lineHeight + lineWeight*2)) return false;

    return true;
  }
}

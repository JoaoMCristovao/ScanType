class Slider {
  boolean isPercentage;
  String legend;
  float minVal;
  float maxVal;
  float w, h;

  float currentValue;
  float lineWeight = gap;
  float sidePadding = 5 * gap;
  boolean hovered;
  float lineHeight;

  boolean isInt;
  boolean showText = true;

  Slider(boolean _isPercentage, String _legend, float _minVal, float _maxVal, float _w, float _h, float _initialVal, boolean _isInt) {
    isPercentage = _isPercentage;
    legend = _legend;
    minVal = _minVal;
    maxVal = _maxVal;
    w = _w;
    h = _h;
    currentValue = _initialVal;
    isInt = _isInt;

    lineHeight = h - h/6;
  }

  void update() {
    if(!showText) sidePadding = lineWeight/2;
    hovered = detectHover();
    if (mousePressed && hovered) {
      float inputValue =  map(mouseX, screenX(sidePadding, 0), screenX(w-sidePadding, 0), 0, 1);
      currentValue = constrain(inputValue, 0, 1);
    }
  }

  void show() {

    float lineLength = w - sidePadding*2;
    strokeWeight(lineWeight);
    stroke(lightGray);
    line(sidePadding, lineHeight, w-sidePadding, lineHeight);

    float selectedLength = lineLength * currentValue;
    if (!hovered) stroke(darkGray);
    else stroke(darkGray);
    line(sidePadding, lineHeight, sidePadding + selectedLength, lineHeight);

    if (!showText) return;

    fill(black);
    textFont(fontWeightRegular);
    textSize(fontSizeSmall);
    textAlign(LEFT, CENTER);
    String currentLegend = legend + ": " + nf(getValue(), 0, 0);
    if (isPercentage) currentLegend += "%";
    text(currentLegend, 0, h/2);

    //minValue
    textSize(fontSizeTiny);
    textAlign(LEFT, CENTER);
    if (isInt)text(int(minVal), 0, lineHeight - fontSizeTiny/5);
    else text(nf(minVal, 0, 2), 0, lineHeight - fontSizeTiny/5);

    //maxValue
    textAlign(RIGHT, CENTER);
    if (isInt)text(int(maxVal), w, lineHeight - fontSizeTiny/5);
    else text(nf(maxVal, 0, 2), w, lineHeight - fontSizeTiny/5);
  }

  float getValue() {
    float val = (maxVal - minVal) * currentValue + minVal;
    if (isInt) return int(val);
    else return val;
  }

  void setMin(int val) {
    minVal = val;
  }

  void setMax(int val) {
    maxVal = val;
  }

  boolean detectHover() {
    if (mouseX < screenX(0, 0))return false; //screenX and screenY because of translations
    if (mouseX > screenX(w, 0))return false;
    if (mouseY < screenY(0, lineHeight - lineWeight*5)) return false;
    if (mouseY > screenY(0, lineHeight + lineWeight*5)) return false;

    return true;
  }

  void setShowText(boolean _state) {
    showText = _state;
  }
}

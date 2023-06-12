class ColorPicker {

  float ratioSliderHeight = 0.3;
  Slider hueSlider;

  float w, h;

  int maxHSVValue = 360;

  float currentHue;
  float saturation = maxHSVValue;
  float brightness = maxHSVValue;
  color currentColor;

  ColorPicker(float _w, float _h) {
    w = _w;
    h = _h;

    hueSlider = createHueSlider();
  }

  void update() {
    pushMatrix();
    translate(0, h * (1 - ratioSliderHeight));
    hueSlider.update();
    popMatrix();

    currentHue = hueSlider.getValue();
  }

  void show() {
    strokeWeight(1);
    colorMode(HSB, maxHSVValue);
    
    currentColor = color(currentHue, saturation, brightness);
    stroke(0, 0, 0);
    fill(currentColor);
    
    colorMode(RGB, 255, 255, 255);
    
    blendMode(SUBTRACT);
    rect(0, 0, w, h * (1 - ratioSliderHeight));
    blendMode(BLEND);
    
    pushMatrix();
    translate(0, h * (1 - ratioSliderHeight));
    hueSlider.show();
    popMatrix();
  }

  Slider createHueSlider() {
    //Slider                     (boolean _isPercentage, String _legend, float _minVal, float _maxVal, float _w, float _h, float _initialVal, boolean _isInt) {
    Slider newSlider = new Slider(false, "", 0, maxHSVValue, w, h * ratioSliderHeight, random(1), false);

    newSlider.setShowText(false);

    return newSlider;
  }
  
  color getCurrentColor(){  
    return currentColor;
  }
}

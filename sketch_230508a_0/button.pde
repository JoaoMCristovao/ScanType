class Button {

  String buttonText;
  boolean type; //if box or not
  boolean selected = false;
  boolean enabled = false;
  boolean disabled = false;
  float x, y;
  float w, h;
  float fontSize;

  boolean hovered;

  Button(String _buttonText, boolean _type, float _x, float _y, float _w, float _h, float _fontSize) {
    buttonText = _buttonText;
    type = _type;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    fontSize = _fontSize;
  }

  void update() {
    if (hovered && mousePressed) {
      if (disabled) console.setMessage("Button Disabled");
      selected = true;
    }
  }

  void show() {
    hovered = detectHover();

    if (type) {
      stroke(black);
      if (enabled) {
        textFont(fontWeightBold); 
        fill(darkGray);
      } else {
        fill(lightGray);
        textFont(fontWeightRegular);
        if (hovered)fill(gray);
      }
      rect(x, y, w, h);
      if (enabled) fill(white);
      else fill(black);
    } else {
      /*fill(255, 0, 0);
       strokeWeight(1);
       rect(x, y, w, h);*/
      if (!enabled) textFont(fontWeightRegular);
      else textFont(fontWeightBold);
      fill(black);
    }

    textSize(fontSize);
    textAlign(CENTER, CENTER);

    text(buttonText, x + w/2, y + h/2 - fontSize/6);
  }

  void setSelectedState(boolean state) {
    selected = state;
  }

  void setEnabledState(boolean state) {
    enabled = state;
  }

  void setText(String _text) {
    buttonText = _text;
  }

  boolean getSelected() {
    return selected;
  }

  boolean detectHover() {
    if (mouseX < screenX(x, 0))return false;
    if (mouseX > screenX(x + w, 0))return false;
    if (mouseY < screenY(0, y)) return false;
    if (mouseY > screenY(0, y + h)) return false;

    return true;
  }
}

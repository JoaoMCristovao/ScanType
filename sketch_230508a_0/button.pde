class Button {

  String buttonText;
  boolean type; //if box or not
  boolean selected = false; //is was selected recently
  boolean enabled = false; //if is toggled on
  boolean disabled = false; //if can be used
  float x, y;
  float w, h;
  float fontSize;
  
  int alignHorizontal = CENTER;
  int alignVertical = CENTER;

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
  
  Button(String _buttonText, boolean _type, float _x, float _y, float _w, float _h, float _fontSize, int _alignHorizontal, int _alignVertical) {
    buttonText = _buttonText;
    type = _type;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    fontSize = _fontSize;
    alignHorizontal = _alignHorizontal;
    alignVertical = _alignVertical;
  }

  void update() {
    if (hovered && mousePressed) {
      pressedButton = this; //
    }
  }

  void selected() {
    if (disabled) return;
    selected = true;
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
      if (disabled)fill(gray);
      rect(x, y, w, h);
      if (enabled) fill(white);
      else fill(black);
    } else {
      if (!enabled) textFont(fontWeightRegular);
      else textFont(fontWeightBold);
      fill(black);
    }

    textSize(fontSize);
    textAlign(alignHorizontal, alignVertical);

    text(buttonText, x + w/2, y + h/2 - fontSize/6);
  }

  void setSelectedState(boolean state) {
    selected = state;
  }

  void setEnabledState(boolean state) {
    enabled = state;
  }

  void setDisabledState(boolean state) {
    disabled = state;
  }

  void setText(String _text) {
    buttonText = _text;
  }

  boolean getSelected() {
    return selected;
  }

  boolean getEnabled() {
    return enabled;
  }

  boolean detectHover() {
    if (mouseX < screenX(x, 0))return false; //screenX and screenY because of translations
    if (mouseX > screenX(x + w, 0))return false;
    if (mouseY < screenY(0, y)) return false;
    if (mouseY > screenY(0, y + h)) return false;

    return true;
  }
}

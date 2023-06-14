class Button {

  String buttonText;
  PImage buttonImage;
  boolean boxed;
  boolean selected = false; //is was selected
  boolean enabled = false; //if is toggled on
  boolean disabled = false; //if can be used
  float x, y;
  float w, h;
  float fontSize;

  int alignHorizontal = CENTER;
  int alignVertical = CENTER;

  boolean hovered;

  Button(String _buttonText, boolean _boxed, float _x, float _y, float _w, float _h, float _fontSize) {
    buttonText = _buttonText;
    boxed = _boxed;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    fontSize = _fontSize;
  }

  Button(String _buttonText, boolean _boxed, float _x, float _y, float _w, float _h, float _fontSize, int _alignHorizontal, int _alignVertical) {
    buttonText = _buttonText;
    boxed = _boxed;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    fontSize = _fontSize;
    alignHorizontal = _alignHorizontal;
    alignVertical = _alignVertical;
  }

  Button(PImage _buttonImage, float _x, float _y, float _w, float _h) {
    buttonImage = _buttonImage;
    x = _x;
    y = _y;
    w = _w;
    h = _h;

    enabled = true;
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

    if (buttonImage != null) {
      showImageButton();
      return;
    }

    if (boxed) {
      strokeWeight(1);
      stroke(darkGray);

      if (enabled) {
        textFont(fontWeightBold); 
        fill(darkGray);
      } else {
        fill(lightGray);
        textFont(fontWeightRegular);
        if (hovered) fill(gray);
      }

      if (disabled) fill(gray);
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

    float xPos = 0;

    if (alignHorizontal == LEFT) xPos = 0;
    else if (alignHorizontal == CENTER) xPos = x + w/2;
    else if (alignHorizontal == RIGHT) xPos = x + w;

    text(buttonText, xPos, y + h/2 - fontSize/6);
  }

  void showImageButton() {    
    pushMatrix();

    if (hovered)fill(gray);
    else fill(lightGray);
    strokeWeight(1);
    stroke(darkGray);

    rect(x, y, w, h);

    float toScale = 0;
    if (buttonImage.width > buttonImage.height) {
      toScale = buttonImage.width / (h * 0.6);
    } else {
      toScale = buttonImage.height / (w * 0.6);
    }
    toScale = 1/toScale;
    scale(toScale);

    translate((x+w/2)/toScale, (y+h/2)/toScale);

    imageMode(CENTER);
    if (enabled)tint(0);
    else tint(0, 20);

    image(buttonImage, 0, 0);

    popMatrix();
  }

  void setSelectedState(boolean _state) {
    selected = _state;
  }

  void setEnabledState(boolean _state) {
    enabled = _state;
  }

  void setDisabledState(boolean _state) {
    disabled = _state;
  }

  void setText(String _text) {
    buttonText = _text;
  }
  
  void toggleEnabledState(){
    enabled = !enabled;
  }

  boolean getSelected() {
    return selected;
  }

  boolean getEnabled() {
    return enabled;
  }

  boolean detectHover() {
    if (mouseX < screenX(x, 0))return false; //screenX and screenY because of matrix transformations
    if (mouseX > screenX(x + w, 0))return false;
    if (mouseY < screenY(0, y)) return false;
    if (mouseY > screenY(0, y + h)) return false;

    return true;
  }
}

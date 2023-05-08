class Button {

  String buttonText;
  boolean type; //if box or not
  boolean selected;
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

  void show() {
    hovered = detectHover();

    if (type) {
      fill(lightGray);
      stroke(black);
      if(!hovered)strokeWeight(1);
      else strokeWeight(5);
      rect(x, y, w, h);
      fill(black);
    } else {
      fill(black);
    }
    
    textSize(fontSize);
    textAlign(CENTER, CENTER);
    text(buttonText, x + w/2, y + h/2);
  }
  
  void mousePressed(){
    if(hovered) println(buttonText + " clicked");
  }

  boolean detectHover() {
    if(mouseX < x)return false;
    if(mouseX > x + w)return false;
    if(mouseY < y) return false;
    if(mouseY > y + h) return false;
    
    return true;
  }
}

class Console {

  String message = "Welcome to SCAN TYPE!";
  String messageTime;
  Float boxHeight;

  Console(float h) {
    boxHeight = h;
    setMessageTime();
  }

  void setMessage(String msg){
    message = msg;
    setMessageTime();
  }
  
  void setMessageTime(){
    messageTime = hour() + ":" + minute() + ":" + second();
  }

  void show() {
    fill(black);
    rect(0, height- boxHeight, width, boxHeight);
    fill(255);
    textSize(fontSizeTiny);
    textAlign(LEFT, CENTER);
    text(messageTime + " - " + message, mainPadding/2, height- boxHeight/2);
    
    textAlign(LEFT, CENTER);
    text("Frame rate: " + int(frameRate), width - mainPadding * 3, height- boxHeight/2);
  }
}

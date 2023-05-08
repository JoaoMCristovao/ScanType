class Console {

  String message = "Welcome to the App!";
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
    text(messageTime + " - " + message, gap, height- boxHeight/2);
  }
}

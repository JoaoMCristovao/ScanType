//colisao -> 0/1 soma
//questionarios 

//colors

color white = color(255);
color black = color(0);
color lightGray = color(200);
color gray = color (130);
color darkGray = color(50);

//typography

int fontSizeTiny = 10;
int fontSizeSmall = 24;
int fontSizeMedium = 32;
int fontSizeBig = 46;
int fontSizeHuge = 72;

PFont fontWeightNormal;
PFont fontWeightBold;

//measurements

int gap = 8;

//major components
Header header;
Console console;

//minor components


void setup(){
  fullScreen();
  
  header = new Header(gap * 12);
  console = new Console(gap*6);
}

void draw(){
  background(white);
  header.show();
  console.show();
}

void mousePressed(){
  console.setMessage("consola");
}

void keyPressed(){ //sliders / shortcuts
  
}

import net.sourceforge.tess4j.*;
import java.awt.image.BufferedImage;
 
Tesseract ocr;
BufferedImage img;
PImage pimg;
String res, show;
int idx;
 
void setup() {
  size(400, 600);
  background(0);
  ocr = new Tesseract();
  ocr.setDatapath(dataPath(""));
  ocr.setTessVariable("tessedit_char_whitelist","ABCDEFGHIJKLMNOPQRSTUVWXYZ");
  ocr.setPageSegMode(10);
  pimg = loadImage("testing.png");
  img = (BufferedImage) pimg.getNative();
  show = "";
  idx = 0;
  try {
    res = ocr.doOCR(img);

    

    println(res);
  } 
  catch (TesseractException e) {
    println(e.getMessage());
  }
  frameRate(25);
}
 
void draw() {
  background(0);
  image(pimg, 0, 0);
  if (idx < res.length()) {
    show += res.charAt(idx);
    idx++;
  } else {
    noLoop();
  }
  text(show, 20, pimg.height+30);
}

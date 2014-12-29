import sojamo.drop.*;
SDrop drop;

import java.util.Calendar;

PImage logoGeorges;
PImage backgroundImage;

int tileCountX = 20;
int tileCountY = 20;
int tileCount = tileCountX*tileCountY;
PImage[] imageTiles = new PImage[tileCount];

int tileWidth, tileHeight;

int cropX = 0;
int cropY = 0;

boolean selectMode = true;
boolean randomMode = true; 
int logoColor = 0; // 0 = white, 1 = black, 2 = nologo

float randomfactor = 1.6;

int windowSize = 0;


void setup() {
  println(windowSize);

  // max size security
  if (displayHeight <= 1079) {
    windowSize = 800;
    size(windowSize, windowSize);
  } else {
    windowSize = 1000;
    size(windowSize, windowSize);
  }

  noCursor();

  tileWidth = width/tileCountY;
  tileHeight = height/tileCountX;

  backgroundImage = loadImage("background.png");

  printLogo(0);
  drop = new SDrop(this);
}


void draw() {
  if (selectMode == true) {
    
    if (backgroundImage.width >= width) {
    backgroundImage.resize(width, backgroundImage.height * (height/backgroundImage.height));
}
    image(backgroundImage, 0, 0);

    // in selection mode, a white selection rectangle is drawn over the image
    cropX = constrain(mouseX, 0, width-tileWidth);
    cropY = constrain(mouseY, 0, height-tileHeight);

    noFill();
    stroke(255);
    rect(cropX, cropY, tileWidth, tileHeight);
  } else {
    // reassemble image
    int i = 0;
    for (int gridY = 0; gridY < tileCountY; gridY++) {
      for (int gridX = 0; gridX < tileCountX; gridX++) {
        image(imageTiles[i], gridX*tileWidth, gridY*tileHeight);
        i++;
      }
    }
  }

  image(logoGeorges, 0, 0, windowSize, windowSize);
}

void cropTiles() {
  tileWidth = width/tileCountY;
  tileHeight = height/tileCountX;
  tileCount = tileCountX * tileCountY;
  imageTiles = new PImage[tileCount];

  int i = 0;
  for (int gridY = 0; gridY < tileCountY; gridY++) {
    for (int gridX = 0; gridX < tileCountX; gridX++) {
      if (randomMode) {
        cropX = (int) random(mouseX-tileWidth/randomfactor, mouseX+tileWidth/randomfactor);
        cropY = (int) random(mouseY-tileHeight/randomfactor, mouseY+tileHeight/randomfactor);
      }
      cropX = constrain(cropX, 0, width-tileWidth);
      cropY = constrain(cropY, 0, height-tileHeight);
      imageTiles[i++] = backgroundImage.get(cropX, cropY, tileWidth, tileHeight);
    }
  }
}

void printLogo(int logoColor) {
  if (logoColor == 0) {
    logoGeorges = loadImage("logo-white.png");
  }
  if (logoColor == 1) {
    logoGeorges = loadImage("logo-black.png");
  }
  if (logoColor == 2) {
    logoGeorges = loadImage("nologo.png");
  }
}

void dropEvent(DropEvent theDropEvent) {
  println("");
  println("isFile()\t"+theDropEvent.isFile());
  println("isImage()\t"+theDropEvent.isImage());
  println("isURL()\t"+theDropEvent.isURL());

  // if the dropped object is an image, then 
  // load the image into our PImage.
  if (theDropEvent.isImage()) {
    println("### loading image ...");  
    backgroundImage = theDropEvent.loadImage();
  }
}

void mouseMoved() {
  selectMode = true;
}

void mouseReleased() {
  selectMode = false; 
  cropTiles();
}

void keyReleased() {
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_##.png");
  if (key == 'b' || key == 'B') printLogo(0);
  if (key == 'n' || key == 'N') printLogo(1);
  if (key == ',' || key == '?') printLogo(2);
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}


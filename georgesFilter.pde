import sojamo.drop.*;
SDrop drop;

import java.util.Calendar;

PImage logoGeorges;
PImage backgroundImage;

int tileCountX = 10;
int tileCountY = 10;
int tileCount = tileCountX*tileCountY;
PImage[] imageTiles = new PImage[tileCount];

int tileWidth, tileHeight;

int cropX = 0;
int cropY = 0;

boolean selectMode = true;
boolean randomMode = true; 


void setup() {
  size(500, 500); 
  backgroundImage = loadImage("georgesBeta.jpg");
  noCursor();

  tileWidth = width/tileCountY;
  tileHeight = height/tileCountX;

  drop = new SDrop(this);
}


void draw() {


  if (selectMode == true) {
    // in selection mode, a white selection rectangle is drawn over the image
    cropX = constrain(mouseX, 0, width-tileWidth);
    cropY = constrain(mouseY, 0, height-tileHeight);    

    if (backgroundImage !=null) {
      image(backgroundImage, 0, 0);
    }



    //   image(backgroundImage, 0, 0);
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
        cropX = (int) random(mouseX-tileWidth/1.6, mouseX+tileWidth/1.6);
        cropY = (int) random(mouseY-tileHeight/1.6, mouseY+tileHeight/1.6);
      }
      cropX = constrain(cropX, 0, width-tileWidth);
      cropY = constrain(cropY, 0, height-tileHeight);
      imageTiles[i++] = backgroundImage.get(cropX, cropY, tileWidth, tileHeight);
    }
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
}


// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
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




















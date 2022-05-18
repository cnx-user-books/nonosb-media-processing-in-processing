int NRINGS = 15;
float Xe = 6;  // step between rings
float Ye = 9;
int X = 8;     // downsampling increment
int Y = 11;
color BG = 250;
PFont carattere;

void setup(){
size(200,200);
background(BG);
ellipseMode(CENTER_RADIUS);
noStroke();
carattere = loadFont("Helvetica_Neue_Light.vlw");
textFont(carattere, 38);
}

void draw(){

}

void keyReleased(){
  if (keyCode == UP)
    Y = Y * 2;
  else if (keyCode == DOWN)
    Y = Y / 2;
  else if (keyCode == RIGHT)
    X = X * 2;
  else if (keyCode == LEFT)
    X = X / 2;
  if (X < 1) X = 1;
  if (Y < 1) Y = 1;
}

void mousePressed(){
  background(BG);
  for (int i=0; i< NRINGS; i++) {
    fill(i*10, (NRINGS-i)*10);
    ellipse(mouseX,mouseY,i*Xe,i*Ye);
    }
}

void mouseReleased(){
loadPixels();
for (int x=0; x<width; x++)
  for (int y=0; y<height; y++) {
    int loc = x + y*width;
    pixels[loc] = pixels[loc - x%X - (y%Y)*width ];
    }
updatePixels();
fill(0);
text("X =" + X + "; Y = " + Y, 10, 25);

}

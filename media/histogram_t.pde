
int D1, D2;
int X, Y;
int c1x, c1y, c2x, c2y;
int DOTS = 180; //multiple of 3 here
                //determines requantization
int grayValues = 256;
float[] map = new float[DOTS];
int[] xi = new int[grayValues];
int[] hist = new int[grayValues]; 
PImage a, b; 


void setup() {
  c1x = 88;
  c1y = 256-88;
  c2x = 128;
  c2y = 128;
  background(200);
  stroke(0,0,0);
  size(300, 420); 
  colorMode(RGB, width); 
  framerate(5);
  a = loadImage("lena.jpg"); 
  image(a, 0, 0);
  loadPixels();
  b = loadImage("lena.jpg");
}


void draw() {
  updatePixels();
  //background(255, 255, 255);

  if (mousePressed == true) {
    X = mouseX; 
    Y = mouseY;
    // selezione del punto che si modifica
    D1 = (X - c1x)*(X - c1x) + (Y - c1y)*(Y - c1y); 
    D2 = (X - c2x)*(X - c2x) + (Y - c2y)*(Y - c2y);
    if (D1 < D2) {
    c1x = X; c1y = Y;
    }
    else {
     c2x = X; c2y = Y;
     }
    }
  
  stroke(250,0,0);
  strokeWeight(1);

  //curve(0, 255, 0, 255, c1x, c1y, 255, 0);
  //curve(0, 255, c1x, c1y, 255, 0, 255, 0);
  beginShape(LINE_STRIP);
  curveVertex(0, 255);
  curveVertex(0, 255);
  curveVertex(c1x, c1y);
  curveVertex(c2x, c2y);
  curveVertex(255, 0);
  curveVertex(255, 0);
  endShape();
  ellipseMode(CENTER); 
  int steps = DOTS/3; 
  int k = 0;
  for (int i = 0; i < steps; i++) { 
    float t = i / float(steps); 
    float x = curvePoint(0, 0, c1x, c2x, t); 
    float y = curvePoint(255, 255, c1y, c2y, t); 
    ellipse(x, y, 5, 5);
    map[i] = 255 - y;
    while ((k < floor(x)) &&(k<grayValues))
      xi[k++] = i;
  }
  for (int i = DOTS/3; i < 2*steps; i++) { 
    float t = (i - DOTS/3) / float(steps); 
    float x = curvePoint(0, c1x, c2x, 255, t); 
    float y = curvePoint(255, c1y, c2y, 0, t); 
    ellipse(x, y, 5, 5);
    map[i] = 255 - y;
    while ((k < floor(x)) &&(k<grayValues))
      xi[k++] = i;
  } 
  for (int i = 2*DOTS/3; i < 3*steps; i++) { 
    float t = (i - 2*DOTS/3) / float(steps); 
    float x = curvePoint(c1x, c2x, 255, 255, t); 
    float y = curvePoint(c1y, c2y, 0, 0, t); 
    ellipse(x, y, 5, 5);
    map[i] = 255 - y;
    while ((k < floor(x)) &&(k<grayValues))
      xi[k++] = i;
  } 
  while (k < grayValues) 
    xi[k++] = DOTS-1;
  strokeWeight(4);
  point(c1x,c1y);
  point(c2x,c2y);

  stroke(0, 0, 255); //blue
  strokeWeight(1);
  for (int i=0; i<grayValues; i++)
    point(i, 255 - map[xi[i]]);

  // redefine grays and calculate the histogram 
  for (int i=0; i<width; i++) { 
    for (int j=0; j<height; j++) { 
      int grigio = int(constrain(red(a.get(i, j)), 0, grayValues-1));
      int xii = xi[grigio]; 
      // int c = constrain(int(map[xii]) + int(random(10)) - 5, 0, grayValues-1);
      int c = constrain(int(map[xii]), 0, grayValues-1);
      pixels[i+j*width] = color(c, 100);
      hist[c]++;
    } 
  } 

  // Find the largest value in the histogram 
  float maxval = 0; 
  for (int i=0; i<grayValues; i++) { 
    if(hist[i] > maxval) { 
      maxval = hist[i]; 
    }  
  } 

  // Normalize the histogram to values between 0 and "height" 
  for (int i=0; i<grayValues; i++) { 
    hist[i] = int(hist[i]/maxval * height); 
  } 

  // Draw half of the histogram (skip every second value) 
  stroke(50, 250, 0); 
  strokeWeight(2);
  for (int i=0; i<grayValues; i+=2) { 
    line(i, height, i, height-hist[i]); 
  } 
}

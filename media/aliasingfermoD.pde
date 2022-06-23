import pitaru.sonia_v2_9.*;


int L = 1024; // lunghezza della tabella
int Lmezzi = int(L/2);
int sr = 44100;
int H = 10; //numero delle armoniche
float[] data; 
float[] Data;
float freq = 10.00; // frequenza fondamentale
Sample mySample; 

int barWidth = 10;
int saturation = 0;
int ampiezza = 0; 
float oneCycle = TWO_PI/L;

int interrompi = 0; 
int modality = 1;

// Buttons

color baseColor; 
color currentcolor;
CircleButton circle1, circle2, circle3, circleNoir1, circleNoir2, circleNoir3;
boolean locked = false;  
    
        
void setup() { 

  size(L,200);
  colorMode(HSB, 1724, height, height);  
  frameRate(5); 
  
  Sonia.start(this); 


for (int i=0; i<=(width-barWidth); i+=barWidth) { 
    noStroke();
    if ((mouseX > i) && (mouseX < i+barWidth)) {
      saturation = height-mouseY;
    }
    fill(i+1000, 200, height/1.5);
    rect(i, 0, barWidth, height);  
  } 

  mySample = new Sample(L); // Create an empty sample with L frames. 
  data = new float[L]; // create an array with as many frames as as sample. 
  Data = new float[L]; // create an array with as many frames as as sample.
  
// BUTTONS

  // Define and create circle button
  int x = 830;
  int y = 30;
  int size = 24;
  color buttoncolor = color(281, 200, 163);
  color highlight = color(280, 102, 180);
  ellipseMode(CENTER);
  circle1 = new CircleButton(x, y, size, buttoncolor, highlight);
  
  // Define and create circle button
  x = 860;
  y = 30; 
  size = 24;
  buttoncolor = color(585, 153, 150);
  highlight = color(464, 250, 255); 
  circle2 = new CircleButton(x, y, size, buttoncolor, highlight);
  
  // Define and create circle button
  x = 890;
  y = 30; 
  size = 24;
  buttoncolor = color(954, 154, 150);
  highlight = color(803, 250, 255); 
  circle3 = new CircleButton(x, y, size, buttoncolor, highlight);    
        
  x = 830;
  y = 30; 
  size = 11;
  buttoncolor = color(954, 154, 150);
  highlight = color(255); 
  circleNoir1 = new CircleButton(x, y, size, buttoncolor, highlight);
  
  x = 860;
  y = 30; 
  size = 11;
  buttoncolor = color(281, 200, 163);
  highlight = color(255); 
  circleNoir2 = new CircleButton(x, y, size, buttoncolor, highlight);
  
  x = 890;
  y = 30; 
  size = 11;
  buttoncolor = color(585, 153, 150);
  highlight = color(255); 
  circleNoir3 = new CircleButton(x, y, size, buttoncolor, highlight);
  
} 


void draw() {

if (mouseX > 0 && mouseX < L) {

// controllo dei colori del background %%%%%%%%%%%%%%%%%%%%%%%%%%
if (keyPressed == false) {
    for (int i=0; i<=(width-barWidth); i+=barWidth) { 
    noStroke();
    if ((mouseX > i) && (mouseX < i+barWidth)) {
      saturation = height-mouseY;
    }
    fill(i+1000, saturation, height/1.5);
    rect(i, 0, barWidth, height);  
  }
 } 
 else {
    for (int i=0; i<=(width-barWidth); i+=barWidth) { 
    noStroke();
    fill(i+1000, saturation, height/1.5);
    rect(i, 0, barWidth, height);  
  }
 }   
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     

if (interrompi == 0) { // se interrompi == 0, genera nuove note e calcola lo spettro

if (keyPressed == false) { 
  // controllo del ritmo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  frameRate(int(ceil(float(mouseX)/100)));
  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

  // controllo della ricchezza spettrale %%%%%%%%%%%%%%%%%%%%%%%%%%%
  H = int((height-mouseY)/20);  //CONTROLLO DEL NUMERO DI ARMONICHE
  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
}

  // sintesi additiva %%%%%%%%%%%%%%%%%%%%%%%%%%%
  freq = int(random(0,1023)/2);  // variazione casuale della frequenza fondamentale
  println(freq*sr/L + " Hz");

    for(int i = 0; i < L; i++){ 
    data[i] = sin(i*oneCycle*freq)/20;
      for(int k = 2; k <=H; k++){       // SINTESI ADDITIVA   
      data[i] = data[i]+sin(i*oneCycle*freq*k)/20; 
      }
    }

  mySample.write(data); // write the data from the 'data' array into the sample  
  mySample.repeat(); // N.B. la riproduzione continua anche quando "interrompi=1"

  mySample.getSpectrum(Lmezzi);  //FFT
}
else if (modality == 1) {  // se interrompi == 1, fermo immagine e nota tenuta
       }
else if (modality == 2) {  // se interrompi == 1, fermo immagine e silenzio
       mySample.stop();
       }
                           // fermo immagine
       
else  {  //if(modality == 3)   // se interrompi == 1, fermo immagine
                               

  // sintesi additiva %%%%%%%%%%%%%%%%%%%%%%%%%%%
  freq = int(random(0,1023)/2);  // variazione casuale della frequenza fondamentale
  println(freq*sr/L + " Hz");

    for(int i = 0; i < L; i++){ 
    data[i] = sin(i*oneCycle*freq)/20;
      for(int k = 2; k <=H; k++){       // SINTESI ADDITIVA   
      data[i] = data[i]+sin(i*oneCycle*freq*k)/20; 
      }
    }

  mySample.write(data); // write the data from the 'data' array into the sample 
  mySample.repeat();
  }


// disegno lo spettro %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  strokeWeight(0); 
  stroke(255); 
  for ( int i = 1; i < Lmezzi; i++){
    ampiezza = int(mySample.spectrum[i]*Lmezzi);
    line(i*2, height, i*2, height - 2*ampiezza/(0.003*i));
  }  
}


// Buttons
  stroke(255);
  update(mouseX, mouseY);
  circle1.display();
  circle2.display();
  circle3.display();
  if (modality == 1) {
      circleNoir1.display();
      }
  if (modality == 2) {
      circleNoir2.display();
      }
  if (modality == 3) {
      circleNoir3.display();
      }    
}

void mousePressed() { 
    interrompi = 1;
//  mySample.saveFile("d:/cose/DIDATTICA/Verona-Venezia/Software processing/processing-0068/sketchbook/default/aliasing/ciccio"); // N.B. slash
    } 
void mouseReleased() {interrompi = 0;}


// Buttons

void update(int x, int y)
{
  if(locked == false) {
    circle1.update();
    circle2.update();
    circle3.update();
  } else {
    locked = false;
  }
  
 if(mousePressed) {          // detection of a mouse click
    if(circle1.pressed()) {  // selection of the button 
      modality = 1;
    } else if(circle2.pressed()) {
      modality = 2;
    } else if(circle3.pressed()) {
      modality = 3;
    }
  }
}


////////////////////////////////////////////////////////////

class Button
{
  int x, y;
  int size;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;
  boolean pressed = false;   
  
  void update() 
  {
    if(over()) {
      currentcolor = highlightcolor;
    } else {
      currentcolor = basecolor;
    }
  }
  
  boolean pressed() 
  {
    if(over) {
      locked = true;
      return true;
    } else {
      locked = false;
      return false;
    }    
  }
  
  boolean over()   // overloaded
  { 
    return true; 
  }
  
  void display()   // overloaded
  { 
  
  }
}

class CircleButton extends Button
{ 
  CircleButton(int _x, int _y, int _size, color _color, color _highlight) 
  {
    x = _x;
    y = _y;
    size = _size;
    basecolor = _color;
    highlightcolor = _highlight;
    currentcolor = basecolor;
  }

  boolean over() 
  {
    if( overCircle(x, y, size) ) {
      over = true;
      return true;
    } else {
      over = false;
      return false;
    }
  }

  void display() 
  {
    stroke(255);
    fill(currentcolor);
    ellipse(x, y, size, size);
  }
}

boolean overCircle(int x, int y, int diameter) 
{
  float disX = x - mouseX;
  float disY = y - mouseY;
  if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}



// safely stop the Sonia engine upon shutdown. 
public void stop(){ 
  Sonia.stop(); 
  super.stop(); 
} 



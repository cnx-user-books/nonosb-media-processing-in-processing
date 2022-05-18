import beads.*; // import the beads library
import beads.Buffer;
import beads.BufferFactory;

AudioContext ac; 
PowerSpectrum ps;

WavePlayer wavetableSynthesizer;
Glide frequencyGlide;
Envelope gainEnvelope;
Gain synthGain;

int L = 16384; // buffer size
int H = 10; //number of harmonics
float freq = 10.00; // fundamental frequency [Hz]
Buffer dSB;

int barWidth = 10;
int saturation = 0;
int ampiezza = 0; 
float oneCycle = TWO_PI/L;

int interrompi = 0; 
int modality = 1;

// Buttons
color baseColor; 
color currentcolor;
CircleButton circle1, circle2, circleNoir1, circleNoir2, circleNoir3;
boolean locked = false;  

void setup() { 
  size(1024, 200);
  colorMode(HSB, 1724, height, height);  
  frameRate(5); 

  ac = new AudioContext();  // initialize AudioContext and create buffer

  frequencyGlide = new Glide(ac, 200, 10); // initial freq, and transition time
  dSB = new DiscreteSummationBuffer().generateBuffer(L, H, 0.5);
  wavetableSynthesizer = new WavePlayer(ac, frequencyGlide, dSB);  
  
  gainEnvelope = new Envelope(ac, 0.0); // standard gain control of AudioContext
  synthGain = new Gain(ac, 1, gainEnvelope);
  synthGain.addInput(wavetableSynthesizer); 
  ac.out.addInput(synthGain);

  // Short-Time Fourier Analysis
  ShortFrameSegmenter sfs = new ShortFrameSegmenter(ac);
  sfs.addInput(ac.out);
  FFT fft = new FFT();
  sfs.addListener(fft);
  ps = new PowerSpectrum();
  fft.addListener(ps);
  ac.out.addDependent(sfs);

  ac.start(); // start audio processing 
  gainEnvelope.addSegment(0.8, 50); // attack envelope

  for (int i=0; i<=(width-barWidth); i+=barWidth) { 
    noStroke();
    if ((mouseX > i) && (mouseX < i+barWidth)) {
      saturation = height-mouseY;
    }
    fill(i+1000, 200, height/1.5);
    rect(i, 0, barWidth, height);
  } 

  int x = 830; // first button
  int y = 30;
  int size = 24;
  color buttoncolor = color(281, 200, 163);
  color highlight = color(280, 102, 180);
  ellipseMode(CENTER);
  circle1 = new CircleButton(x, y, size, buttoncolor, highlight);

  x = 860; // second button
  y = 30; 
  size = 24;
  buttoncolor = color(585, 153, 150);
  highlight = color(464, 250, 255); 
  circle2 = new CircleButton(x, y, size, buttoncolor, highlight);

/*  // Define and create circle button
  x = 890;
  y = 30; 
  size = 24;
  buttoncolor = color(954, 154, 150);
  highlight = color(803, 250, 255); 
  circle3 = new CircleButton(x, y, size, buttoncolor, highlight);    */

  x = 830; // first button marker
  y = 30; 
  size = 11;
  buttoncolor = color(954, 154, 150);
  highlight = color(255); 
  circleNoir1 = new CircleButton(x, y, size, buttoncolor, highlight);

  x = 860;  // second button marker
  y = 30; 
  size = 11;
  buttoncolor = color(281, 200, 163);
  highlight = color(255); 
  circleNoir2 = new CircleButton(x, y, size, buttoncolor, highlight);

} 

void draw() {
  frequencyGlide.setValue(float(mouseX)/width*22050/10); // set the fundamental frequency
                                                         // the 10 factor is empirically found
  if (mouseX > 0 && mouseX < L) { // control background color
     if (!mousePressed){
      saturation = height-mouseY;
        for (int i=0; i<=(width-barWidth); i+=barWidth) { 
          noStroke();
          fill(i+1000, saturation, height/1.5);
          rect(i, 0, barWidth, height);
        }
     }      
  
    if (!((modality == 2) && (mousePressed))) { // trigger note sequence
        frameRate(int(ceil(float(mouseX)/100))); // pace control
        H = round(float(height-mouseY)/20); // spectral bandwidth
      gainEnvelope.addSegment(0.0, 50);
      println("rewrite table with " + H + " partials");
      freq = int(random(0, 1023)/2); // random frequency variation
      for (int i = 0; i < dSB.buf.length; i++) {
        dSB.buf[i] = 0;
      }
      for (int k = 0; k <= H; k++) { //additive synthesis
        for (int i = 0; i < dSB.buf.length; i++) {
          dSB.buf[i] = dSB.buf[i] + (float)Math.sin(i*2*Math.PI*freq*k/dSB.buf.length)/20;
          }
      }
      gainEnvelope.addSegment(0.8, 50); // attack envelope    
    }

    if (interrompi==0){
      strokeWeight(0); // drawing spectrum
      stroke(255); 
      float[] features = ps.getFeatures(); // from Beads analysis library  
      // It will contain the PowerSpectrum: 
      // array with the power of 256 spectral bands.
      if (features != null) { // if any features are returned
        for (int x = 0; x < width; x++) {
          int featureIndex = (x * features.length) / width;
          int barHeight = Math.min((int)(features[featureIndex] * 0.01 *
            height), height - 1);
          stroke(255);
          line(x, height, x, height - barHeight);
        }
      }
    }
  }


  // Buttons
  stroke(255);
  update(mouseX, mouseY);
  circle1.display();
  circle2.display();
  if (modality == 1) {
    circleNoir1.display();
  }
  if (modality == 2) {
    circleNoir2.display();
  }
}

void mousePressed() { 
  interrompi = 1;} 
  
void mouseReleased() {
  interrompi = 0;
}

void update(int x, int y)
{
  if (locked == false) {
    circle1.update();
    circle2.update();
  } 
  else {
    locked = false;
  }

  if (mousePressed) {          // detection of a mouse click
    if (circle1.pressed()) {   // selection of the button 
      modality = 1;
      println("modality = " + modality);
    } 
    else if (circle2.pressed()) {
      modality = 2;
      println("modality = " + modality);
    } 
  }
}


class Button
{
  int x, y;
  int size;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;
  boolean pressed = false;   

  void update() {
    if (over()) {
      currentcolor = highlightcolor;
    } 
    else {
      currentcolor = basecolor;
    }
  }

  boolean pressed() {
    if (over) {
      locked = true;
      return true;
    } 
    else {
      locked = false;
      return false;
    }
  }

  boolean over() {   // overloaded
    return true;
  }

  void display() {   // overloaded
  }
}

class CircleButton extends Button
{ 
  CircleButton(int _x, int _y, int _size, color _color, color _highlight) {
    x = _x;
    y = _y;
    size = _size;
    basecolor = _color;
    highlightcolor = _highlight;
    currentcolor = basecolor;
  }

  boolean over() {
    if ( overCircle(x, y, size) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() {
    stroke(255);
    fill(currentcolor);
    ellipse(x, y, size, size);
  }
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } 
  else {
    return false;
  }
}


public class DiscreteSummationBuffer extends BufferFactory {
  public Buffer generateBuffer(int bufferSize) { //Beads generic buffer
    return generateBuffer(bufferSize, 10, 0.9f); //default values
  }
  public Buffer generateBuffer(int bufferSize, int numberOfHarmonics, float amplitude)
  {
    Buffer b = new Buffer(bufferSize);

    println("generate H=" + numberOfHarmonics);
    double amplitudeCoefficient = amplitude / (2.0 * (double)numberOfHarmonics);
    double theta = 0.0;
    for (int k = 0; k <= numberOfHarmonics; k++) { //additive synthesis
      for (int i = 0; i < b.buf.length; i++) {
        b.buf[i] = b.buf[i] + (float)Math.sin(i*2*Math.PI*freq*k/b.buf.length)/20;
      }
    }
    return b;
  }
  public String getName() { //mandatory method implementation
    return "DiscreteSummation";
  }
}


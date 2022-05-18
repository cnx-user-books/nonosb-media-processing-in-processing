import beads.*; // import the beads library

AudioContext ac; 

PImage outim;
int range = 256; //8 bits
int rangeAudio = 32768; //16 bits with sign 
int bits = 4;
int quanta = (int) pow(2, bits);
PFont carattere;
PImage b;
int npixels;

SamplePlayer sp, spi;
Gain g;
Glide gainValue;

Sample barcarola, barcarolai;
float[][] barcarolaData;

void setup()
{
  ac = new AudioContext(); // create our AudioContext
  try {
    barcarola = new Sample(createInput("data/so_fisso.wav"));    
    barcarolai = new Sample(createInput("data/so_fisso.wav"));
    barcarolaData = new float[1][(int)barcarola.getNumFrames()];
    barcarola.getFrames(0, barcarolaData);
    sp = new SamplePlayer(ac, barcarola);
    spi = new SamplePlayer(ac, barcarolai);
  } catch(Exception e) {
      println("Exception while attempting to load sample!");
      e.printStackTrace(); // print description of the error
      exit(); // and exit the program
      }
  spi.setKillOnEnd(false);
  gainValue = new Glide(ac, 0.0, 20);
  g = new Gain(ac, 1, gainValue);
  g.addInput(spi); // connect the SamplePlayer to the Gain
  ac.out.addInput(g); // connect the Gain to the AudioContext
  ac.start(); // begin audio processing

  size(400,300);
  carattere = loadFont("Helvetica_Neue_Light.vlw");
  textFont(carattere, 38);
  b = loadImage("gondoliers.jpg");
  PImage bi = loadImage("gondoliers.jpg");  
  npixels = b.width*b.height;
  for (int i = 0; i < npixels; i++) {
    bi.pixels[i] = color(quant(red(b.pixels[i]), range, quanta), quant(green(b.pixels[i]), range, quanta), quant(blue(b.pixels[i]), range, quanta));
  }
  for (int i = 0; i < barcarola.getNumFrames(); i++) {
     barcarolaData[0][i] = quant(barcarolaData[0][i]*rangeAudio, rangeAudio, quanta)/rangeAudio;
  } 
  barcarolai.putFrames(0, barcarolaData);
  image(bi, 0, 0, 400, 300);
  gainValue.setValue(0.9);
  spi.setToLoopStart();
  spi.start(); // play the audio file
  text("Bits = " + bits, 10, 25); text("Hit: <-  ->", 150, 50);
}

void draw(){
}

float quant(float value, int range, int quanta) { //quantize to a given number of bits
  int quanto = (range / quanta);
  return (float)((int)value - (int)value % quanto);
}

void keyReleased(){
  PImage bi = loadImage("gondoliers.jpg");
  text("processing...", 150, 25);
  if (keyCode == RIGHT)
  bits = bits + 1;
  else if (keyCode == LEFT)
  bits = bits - 1;
  bits = constrain(bits, 1, 8);
  quanta = (int) pow(2, bits); 
  for (int i = 0; i < npixels; i++) {
    bi.pixels[i] = color(quant(red(b.pixels[i]), range, quanta), quant(green(b.pixels[i]), range, quanta), quant(blue(b.pixels[i]), range, quanta));
  }
  background(0,0,0);
  barcarola.getFrames(0, barcarolaData);
  for (int i = 0; i < barcarola.getNumFrames(); i++) {
     barcarolaData[0][i] = quant(barcarolaData[0][i]*rangeAudio, rangeAudio, quanta)/rangeAudio;
  } 
  barcarolai.putFrames(0, barcarolaData);
  image(bi, 0, 0, 400, 300);
  spi.setToLoopStart();
  spi.start(); // play the audio file
  text("Bits = " + bits, 10, 25);
}

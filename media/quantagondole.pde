import pitaru.sonia_v2_9.*;

PImage outim;
int range = 256; //8 bits
int rangeAudio = 32768; //16 bits with sign 
int bits = 4;
int quanta = (int) pow(2, bits);
PFont carattere;
PImage b;
int npixels;
Sample barcarola, barcarolai;
float[] barcarolaData;

void setup()
{
  Sonia.start(this);
  barcarola = new Sample("so_fisso.aiff");
  barcarolai = new Sample("so_fisso.aiff");
  barcarolaData = new float[barcarola.getNumFrames()];
  barcarola.read(barcarolaData);
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
     barcarolaData[i] = quant(barcarolaData[i]*rangeAudio, rangeAudio, quanta)/rangeAudio;
  }
  barcarolai.write(barcarolaData);
  image(bi, 0, 0, 400, 300);
  barcarolai.play();
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
  barcarola.read(barcarolaData);
  background(0,0,0);
   for (int i = 0; i < barcarola.getNumFrames(); i++) {
    barcarolaData[i] = quant(barcarolaData[i]*rangeAudio, rangeAudio, quanta)/rangeAudio;
  }
  barcarolai.write(barcarolaData);
  image(bi, 0, 0, 400, 300);
  barcarolai.play();
  text("Bits = " + bits, 10, 25);
}

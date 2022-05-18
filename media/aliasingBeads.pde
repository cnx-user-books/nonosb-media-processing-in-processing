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

void setup() {
  size(1024,200);

  frameRate(20);

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
}

void mouseReleased(){
  println("mouseX = " + mouseX);
}

void draw()
{
  background(0); 
  
  text("click and move the pointer", 800, 20); 
  frequencyGlide.setValue(float(mouseX)/width*22050/10); // set the fundamental frequency
                                                         // the 10 factor is empirically found
  float[] features = ps.getFeatures(); // from Beads analysis library  
  // It will contain the PowerSpectrum: 
  // array with the power of 256 spectral bands.
  if (features != null) { // if any features are returned
    for (int x = 0; x < width; x++){
      int featureIndex = (x * features.length) / width;
      int barHeight = Math.min((int)(features[featureIndex] * 0.05 *
        height), height - 1);
      stroke(255);
      line(x, height, x, height - barHeight);
    }
  }
}

public class DiscreteSummationBuffer extends BufferFactory {
  public Buffer generateBuffer(int bufferSize) { //Beads generic buffer
    return generateBuffer(bufferSize, 10, 0.9f); //default values
  }
  public Buffer generateBuffer(int bufferSize, int numberOfHarmonics, float amplitude)
  {
    Buffer b = new Buffer(bufferSize);

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

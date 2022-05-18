import pitaru.sonia_v2_9.*;

int L = 1024; // lunghezza della FFT (frequenze positive)
int L2 = int(L*4); // lunghezza della tabella

int sr = 44100;
int H = 10; //numero delle armoniche
int ampiezza;

float[] Data;
float freq = 10.00; // frequenza fondamentale [Hz]
Sample mySample;
float oneCycle = TWO_PI/L; // TWO_PI/L;

void setup() {
  size(1024,200);

  framerate(1);

  colorMode(HSB, 360, height, height);

  Sonia.start(this);

  mySample = new Sample(L2); // Create an empty sample with L2 frames.
  Data = new float[L2]; // create an array with as many frames as sample.

  //populate the array with sample data, a sine wave in this case
  for(int k = 1; k <=H; k++){      // SINTESI ADDITIVA
    for(int i = 0; i < L2; i++){
      Data[i] = Data[i] + sin(i*oneCycle*freq*k)/10;
    }
  }

  mySample.write(Data); // write the data from the 'Data' array into the sample
  mySample.repeat(); // loop the sample */
}

void draw()
{
  background(0,20,0);
  strokeWeight(0);
  stroke(0,230,0);

  mySample.getSpectrum(L);  // FFT
  stroke(255); //println();
  for ( int i = 1; i < L; i++){
    ampiezza = int(mySample.spectrum[i]*L);
    line(i, height, i, height - 2*ampiezza/(0.003*i));
  }
}

void mouseReleased()
{
  freq = (float)(mouseX/2);  // permette di cambiare la frequenza fondamentale
  println(freq + " Hz");
  for (int i = 0; i < L2; i++) Data[i] = 0;
  for(int k = 1; k <=H; k++){      // SINTESI ADDITIVA
    for(int i = 0; i < L2; i++){
      Data[i] = Data[i] + sin(i*oneCycle*freq*k)/20;
    }
  }
  mySample.write(Data); // write the data from the 'data' array into the sample
  mySample.repeat(); // loop the sample
}

// safely stop the Sonia engine upon shutdown.
public void stop(){
  Sonia.stop();
  super.stop();
}

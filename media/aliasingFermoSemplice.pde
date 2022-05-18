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

void setup() {

  size(L,200);
  colorMode(HSB, 1724, height, height);
  framerate(5);

  Sonia.start(this);

  // DISEGNO DELLO SFONDO (setup) %%%%%%%%

  for (int i=0; i<=(width-barWidth); i+=barWidth) {
    noStroke();
    if ((mouseX > i) && (mouseX < i+barWidth)) {
      saturation = height;
    }
    fill(i+1000, 200, height/1.5);
    rect(i, 0, barWidth, height);
  }

  // Allocazione delle variabili

  mySample = new Sample(L); // Create an empty sample with L frames.
  data = new float[L]; // create an array with as many frames as as sample.
  Data = new float[L]; // create an array with as many frames as as sample.
}

void draw() {

  // DISEGNO DELLO SFONDO (draw) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  if (mouseX > 0 && mouseX < L) {

    // controllo dei colori del background %%%%%%%%%%%%%%%%%%%%%%%%%%
    if (keyPressed == false) {   // se premo un tasto qualsiasi (keyPressed == true)
      // non eseguo questa parte di codice e quindi
      // la saturazione non è più variabile (vedi linea 65 sgg. del codice)
      for (int i=0; i<=(width-barWidth); i+=barWidth) {
        noStroke();
        if ((mouseX > i) && (mouseX < i+barWidth)) {
          saturation = height-mouseY;
        }
        fill(i+1000, saturation, height/1.5);
        rect(i, 0, barWidth, height);
      }
    }
    else {  // se premo un tasto qualsiasi, la saturazione non è più variabile
      for (int i=0; i<=(width-barWidth); i+=barWidth) {
        noStroke();
        fill(i+1000, saturation, height/1.5);
        rect(i, 0, barWidth, height);
      }
    }
    // GENERAZIONE DEI SUONI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if (interrompi == 0) { // se interrompi == 0, genera nuove note e calcola lo spettro

      // CONTROLLI MEDIANTE LA POSIZIONE DEL MOUSE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if (keyPressed == false) { // se premo un tasto qualsiasi (keyPressed == true)
        // non eseguo questa parte di codice e quindi
        // il framerate e il numero di armoniche H
        // non sono più variabili con la posizione del mouse, ma restano fissi.
        // controllo del metronomo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        framerate(int(ceil(float(mouseX)/100)));
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

    else if (key == 'b' || key == 'B') { // se interrompi == 1 e, in particolare, premo il tasto 'b',
      // ottengo un fermo immagine e nota tenuta.
      // Ovvero non viene eseguita nè una nuova sintesi additiva
      // nè il calcolo dello spettro, ma l'ultimo campione generato prima del
      // click del mouse resta in loop (vedi linea 103 del codice)
      // e il suo spettro viene disegnato (vedi linea 146 sgg. del codice).
    }

    else if (key == 'v' || key == 'V') { // se interrompi == 1, e, in particolare, premo il tasto 'v',
      // ottengo  fermo immagine e silenzio.
      // Ovvero non viene eseguita nè una nuova sintesi additiva
      // nè il calcolo dello spettro e la riproduzione dell'ultimo campione
      // generato prima del click del mouse viene interrotta (stop).
      mySample.stop();
    }

    else  {   // se interrompi == 1 e non premo nè b nè v, ottengo solo un fermo immagine.
      // Ovvero la sintesi additiva viene eseguita egualmente, ma NON il calcolo del nuovo spettro.

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

    // DISEGNO DELLO SPETTRO  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    strokeWeight(0);
    stroke(255);
    for ( int i = 1; i < Lmezzi; i++){
      ampiezza = int(mySample.spectrum[i]*Lmezzi);
      line(i*2, height, i*2, height - 2*ampiezza/(0.003*i));
    }
  }
}

// RILEVAMENTO DEL CLICK DEL MOUSE %%%%%%%%%%%%%%%%%%%%%%
void mousePressed() {
  interrompi = 1;
  //  mySample.saveFile("d:/cose/DIDATTICA/Verona-Venezia/Software processing/processing-0068/sketchbook/default/aliasing/ciccio"); // N.B. slash
}
void mouseReleased() {interrompi = 0;}

// safely stop the Sonia engine upon shutdown.
public void stop(){
  Sonia.stop();
  super.stop();
}


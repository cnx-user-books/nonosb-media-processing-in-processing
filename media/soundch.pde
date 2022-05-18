Sample mySample1, mySample2, mySample3, mySample4; 
Sample mySample1F, mySample2F, mySample3F, mySample4F;

float[] data1, data2, data3, data4;
float[] data1F, data2F, data3F, data4F; 

float ro;
float roLin;
float wc;

int sr = 44100;


void setup() 
{
  size(200, 200);
  colorMode(HSB, 360, height, height);  
  Sonia.start(this);
 
  mySample1 = new Sample("flauto.aif");
  mySample2 = new Sample("oboe.wav");
  mySample3 = new Sample("tromba.wav");
  mySample4 = new Sample("violinoREW.wav");  
  
  mySample1F = new Sample("flauto.aif");
  mySample2F = new Sample("oboe.wav");
  mySample3F = new Sample("tromba.wav");
  mySample4F = new Sample("violinoREW.wav");
  
  data1  = new float[mySample1.getNumFrames()]; //creates a new array the length of the sample
   data2  = new float[mySample2.getNumFrames()]; 
    data3  = new float[mySample3.getNumFrames()]; 
     data4  = new float[mySample4.getNumFrames()]; 

  data1F  = new float[mySample1.getNumFrames()]; //creates a new array the length of the sample
   data2F  = new float[mySample2.getNumFrames()]; 
    data3F  = new float[mySample3.getNumFrames()]; 
     data4F  = new float[mySample4.getNumFrames()];
  
 
  mySample1.read(data1);
  mySample2.read(data2);
  mySample3.read(data3);
  mySample4.read(data4);
  
} 
 
void loop() 
{
    stroke(255);
    strokeWeight(1);
    fill(0, 88, 88);
    ellipseMode(CORNER);
    ellipse(50,50,100,100);
    
    beginShape(LINES); 
      vertex(50, 100); 
      vertex(90, 100); 
 
      vertex(110, 100); 
      vertex(150, 100);
      
      vertex(100, 50); 
      vertex(100, 90); 
      
      vertex(100, 110); 
      vertex(100, 150);    
    endShape(); 
}



void mouseReleased() 
{
 
// FLAUTO
if ((mouseX > 95) && (mouseX < 105)&& (mouseY > 50)&& (mouseY < 90)) {
     
    roLin = (mouseY-49.99)/40;
    ro = pow(roLin,.33);
    println("ciccio=" + ro + "   "+ "Y=" + mouseY);
    wc = 298*(TWO_PI/sr);
    filtra(data1F, data1, wc, ro);  

    mySample1F.write(data1F);
    mySample1F.play();
    }
     
// OBOE
if ((mouseX > 110) && (mouseX < 149)&& (mouseY > 95)&& (mouseY < 105)) {
    
    roLin = (149.99-mouseX)/40;
    ro = pow(roLin,.33);
    println("ciccio=" + ro + "   "+ "X=" + mouseX);
    wc = 220*(TWO_PI/sr);
    filtra(data2F, data2, wc, ro);  

    mySample2F.write(data2F);
    mySample2F.play();
    }
      
// TROMBA    
if ((mouseX > 95) && (mouseX < 105)&& (mouseY > 110)&& (mouseY < 149)) {
    
    roLin = float((149.99-mouseY)/40);
    ro = pow(roLin,.33);
    println("ciccio=" + ro + "   "+ "Y=" + mouseY);
    wc = 347*(TWO_PI/sr);
    filtra(data3F, data3, wc, ro);  

    mySample3F.write(data3F);
    mySample3F.play();
    }  

// VIOLINO        
if ((mouseX > 50) && (mouseX < 90)&& (mouseY > 95)&& (mouseY < 105)) {
    
    roLin = (mouseX-49.99)/40; 
    ro = pow(roLin,.33);
    println("ciccio=" + ro + "   "+ "X=" + mouseX);
    wc = 294*(TWO_PI/sr);
    filtra(data4F, data4, wc, ro);  

    mySample4F.write(data4F);
    mySample4F.play();
    }  
}


//filtra = new function
void filtra(float[] DATAF, float[] DATA, float WC, float RO) {

    float G;
    float RO2;  
    RO2 = pow(RO, 2);
    G = (1-RO)*sqrt(1-2*RO*cos(2*WC)+RO2)*4; // (*4) is for having it louder
    println("ro=" + RO +" "+ "wc=" + WC);   

    for(int i = 3; i < DATA.length; i++){ 
      DATAF[i] = G*DATA[i]+2*RO*cos(WC)*DATAF[i-1]-RO2*DATAF[i-2];//filtraggio ricorsivo      
      }
}


// safely stop the Sonia engine upon shutdown. 
public void stop(){ 
  Sonia.stop(); 
  super.stop(); 
} 

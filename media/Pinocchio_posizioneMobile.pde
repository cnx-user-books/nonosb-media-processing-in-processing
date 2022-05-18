Puppet pinocchio, pinocchio2, pinocchio3, pinocchio4, pinocchio5;
float Scala1, Scala2, Scala3, Scala4, Scala5;
float scala1, scala2, scala3, scala4, scala5;
float incrScala1, incrScala2, incrScala3, incrScala4, incrScala5;

void setup() {
  size(500,500);
  background(0);
  color tempcolor = color(255,0,0);
  pinocchio = new Puppet(tempcolor);
  pinocchio2 = new Puppet(tempcolor);
  pinocchio3 = new Puppet(tempcolor);
  pinocchio4 = new Puppet(tempcolor);
  pinocchio5 = new Puppet(tempcolor);

  Scala1 = .5;
  Scala2 = .4;
  Scala3 = .3;
  Scala4 = .2;
  Scala5 = .15;
  
  scala1 = Scala1;
  scala2 = Scala2;
  scala3 = Scala3;
  scala4 = Scala4;
  scala5 = Scala5;

  incrScala1 = .008;
  incrScala2 = .006;
  incrScala3 = .004;
  incrScala4 = .002;
  incrScala5 = .001;

framerate(30);
}

void draw() {
  background(0);
  scala1=scala1+incrScala1;
  pinocchio.disegna(20, 20, scala1);
    if(scala1 > 2*Scala1) {
    scala1 = .5;
  }
  scala2=scala2+incrScala2;
  pinocchio2.disegna(100, 50, scala2);
    if(scala2 > 2*Scala2) {
    scala2 = .4;
  }
  scala3=scala3+incrScala3;
  pinocchio3.disegna(180, 300, scala3);
    if(scala3 > 2*Scala3) {
    scala3 = .3;
  }
  scala4=scala4+incrScala4;
  pinocchio4.disegna(300, 200, scala4);
    if(scala4 > 2*Scala4) {
    scala4 = .2;
  }
  scala5=scala5+incrScala5;
  pinocchio5.disegna(80, 200, scala5);
println(scala1);
  if(scala5 > 2*Scala5) {
    scala5 = .15;
  }
}

/////////////////////////////////

class Puppet {
  color colore;
  int xpos;
  int ypos;
  float riscala;
  float incrRiscala;

  Puppet(color c_) {
    colore = c_;
  }

  void disegna (int pippo, int ciccio, float pappa) {
    xpos = pippo;
    ypos = ciccio;
    riscala = pappa;
    //incrRiscala = peppo;
    stroke(255);
    strokeWeight(1);

    translate(xpos, ypos); // MANIPOLAZIONE DELLE COORDINATE
    scale(riscala);

    ellipseMode(CORNER);  // DISEGNO
    ellipse(72,100,110,130);    // FACCIA
    stroke(colore);
    beginShape(TRIANGLES);      // NASO
    vertex(114, 180);
    vertex(mouseX, mouseY);
    vertex(140, 180);
    endShape();
    strokeWeight(4);
    line(96,150,112,150);        // OCCHI
    line(150,150,166,150);

    scale(1/riscala);        //RISCALAMENTO IN CONFIGURAZIONE BASE
    translate(-xpos, -ypos); //RIPOSIZIONAMENTO IN CONFIGURAZIONE BASE

  }

}

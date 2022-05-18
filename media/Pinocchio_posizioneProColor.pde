Puppet pinocchio, pinocchio2, pinocchio3, pinocchio4, pinocchio5;


void setup() {
size(500,500);
background(0);
color tempcolor = color(255,0,0);
pinocchio = new Puppet(tempcolor);
color tempcolor2 = color(0,255,0);
pinocchio2 = new Puppet(tempcolor2);
pinocchio3 = new Puppet(color(0,255,255));
pinocchio4 = new Puppet(color(255,0,255));
pinocchio5 = new Puppet(color(255,255,0));

}

void draw() {
background(0);
pinocchio.disegna(20, 20, .01+float(mouseX)/500);
pinocchio2.disegna(100, 50, .04+float(mouseX)/1500);
pinocchio3.disegna(180, 300, .08+float(mouseX)/1500+float(mouseY)/1500);
pinocchio4.disegna(300, 200, .12+float(mouseY)/2500);
pinocchio5.disegna(80, 200, .2+float(mouseY)/3500);
}

/////////////////////////////////

class Puppet {
color colore;
int xpos;
int ypos;
float riscala;

Puppet(color c_) {
colore = c_;
}

void disegna (int pippo, int ciccio, float pappa) {
xpos = pippo;
ypos = ciccio;
riscala = pappa;
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

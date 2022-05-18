Puppet pinocchio;
Puppet pinocchio2;
Puppet pinocchio3;
Puppet pinocchio4;
Puppet pinocchio5;

void setup() {
size(500,500);
background(0);
color tempcolor = color(255,0,0);
pinocchio = new Puppet(tempcolor, 20, 20, .5);
pinocchio2 = new Puppet(tempcolor, 250, 20, .4);
pinocchio3 = new Puppet(tempcolor, -40, -20, .3);
pinocchio4 = new Puppet(tempcolor, 40, 90, .2);
pinocchio5 = new Puppet(tempcolor, 60, 120, .1);
}
void draw() {
background(0);
pinocchio.draw();
pinocchio2.draw();
pinocchio3.draw();
pinocchio4.draw();
pinocchio5.draw();
}

/////////////////////////////////

class Puppet {
color colore;
float xpos;
float ypos;
float riscala;
float delay = 60.0;

Puppet(color c_, float xpos_, float ypos_, float riscala_) {
colore = c_;
xpos = xpos_;
ypos = ypos_;
riscala = riscala_;
}

void draw () {
stroke(255);
strokeWeight(1);

  float dx = mouseX - xpos;
  if(abs(dx) > 1) {
    xpos = xpos + dx/delay;
  }
  float dy = mouseY - ypos;
  if(abs(dy) > 1) {
    ypos = ypos + dy/delay;
  }

translate(xpos, ypos);
scale(riscala);
ellipseMode(CORNER);
ellipse(72,100,110,130);
stroke(colore);
beginShape(TRIANGLES);
vertex(114, 180);
vertex(mouseX, mouseY);
vertex(140, 180);
endShape();
strokeWeight(4);
line(96,150,112,150);
line(150,150,166,150);
translate(-xpos, -ypos);
scale(1/riscala);
}
}

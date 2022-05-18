void setup() {
  size(256,256);
  background(0);
  }
  
void draw() {
  stroke(255);
  strokeWeight(1);
  ellipseMode(CORNER);
  ellipse(72,100,110,130);
  triangle(88,100,168,100,128,50);
  stroke(140);
   beginShape(TRIANGLES); 
    vertex(114, 180); 
    vertex(mouseX, mouseY); 
    vertex(140, 180); 
  endShape(); 
  strokeWeight(4);
  line(96,150,112,150);
  line(150,150,166,150);
  line(120,200,136,200);
}

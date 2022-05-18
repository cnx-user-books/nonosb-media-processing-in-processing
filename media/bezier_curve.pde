                
void setup() {
  c1x = 120;
  c1y = 110;
  c2x = 50;
  c2y = 70;
  background(200);
  stroke(0,0,0);
  size(200, 200);
}

int D1, D2;
int X, Y;
int c1x, c1y, c2x, c2y;

void draw() {
  if (mousePressed == true) {
    X = mouseX; Y = mouseY;
    // selezione del punto che si modifica
    D1 = (X - c1x)*(X - c1x) + (Y - c1y)*(Y - c1y); 
    D2 = (X - c2x)*(X - c2x) + (Y - c2y)*(Y - c2y);
    if (D1 < D2) {
    c1x = X; c1y = Y;
    }
    else {
     c2x = X; c2y = Y;
     }
    }
    background(200);
    stroke(0,0,0);
    strokeWeight(1);
    
    noFill();
    beginShape(); 
    curveVertex(10,  10); 
    curveVertex(10,  10); 
    curveVertex(c2x, c2y); 
    curveVertex(c1x, c1y); 
    curveVertex(190, 190); 
    curveVertex(190, 190); 
    endShape(); 
       
    stroke(255,30,0);
    bezier(10,10,c2x,c2y,c1x,c1y,190,190);
    strokeWeight(4);
    point(c1x,c1y);
    point(c2x,c2y);
}
                      
            

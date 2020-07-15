float dispScale = 200;

void setup(){
  //fullScreen();
  size(500, 500);
  textSize(20);
  translate(width/2, height/2);
}

void draw(){
  background(255);
  translate(width/2, height/2);
  //float bdist = map(mouseX, 0, width, -1, 1);
  noFill();marker(0, 0, 1, "poincare disk");
  PVector A = new PVector(map(mouseX, 0, width, -1, 1), 0.3f);
  PVector B = new PVector(0.25f, 0.05f);
  PVector C = new PVector(0.25f, 0.05f);
  PVector translated = translatePoint(B, A);
  marker(translated, 10/dispScale, "");
  translated = translatePoint(B, translated);
  marker(translated, 10/dispScale, "");
  translated = translatePoint(B, translated);
  marker(translated, 10/dispScale, "");
  translated = translatePoint(B, translated);
  marker(translated, 10/dispScale, "");
  translated = translatePoint(B, translated);
  marker(translated, 10/dispScale, "");
  translated = translatePoint(C, A);
  marker(translated, 10/dispScale, "AC");
  
  marker(new PVector(0, 0), 10/dispScale, "center");
  marker(A, 10/dispScale, "A");
  
}

PVector translatePoint(PVector A, PVector B) {//translate vector A origin to B in hyperbolic geometry and return point of vector A
  // z = (z + t) / (1 + z * conj(t))

  // first the denominator
  float denX = (A.x * B.x) + (A.y * B.y) + 1;
  float denY = (A.y * B.x) - (A.x * B.y);
  float dd   = (denX * denX) + (denY * denY);

  // and the numerator
  float numX = A.x + B.x;
  float numY = A.y + B.y;

  // then the division (bell)
  float x = ((numX * denX) + (numY * denY)) / dd;
  float y = ((numY * denX) - (numX * denY)) / dd;
  return new PVector(x, y);
}
// (x, y)=pos z=radius
void marker(PVector o, String s){//! r = radius
  int fc = g.fillColor;//get current fill color
  ellipse(o.x*dispScale, o.y*dispScale, o.z*dispScale*2, o.z*dispScale*2);
  fill(0);
  text(s, o.x*dispScale, (o.y-o.z)*dispScale);
  fill(fc);
}

void marker(PVector p, float r, String s){//! r = radius
  marker(new PVector(p.x , p.y, r), s);
}

void marker(float x, float y, float r, String s){//! r = radius
  marker(new PVector(x, y), r, s);
}

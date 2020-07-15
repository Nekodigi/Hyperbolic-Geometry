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

void line(PVector a, PVector b){
  line(a.x*dispScale, a.y*dispScale, b.x*dispScale, b.y*dispScale);
}

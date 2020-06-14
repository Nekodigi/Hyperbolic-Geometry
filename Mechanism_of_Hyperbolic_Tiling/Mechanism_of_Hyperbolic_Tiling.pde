int p = 5;
int q = 4;
float rotang = 0;
float d;
float dispScale = 200;

void setup(){
  //fullScreen();
  size(1000, 1000);
  textSize(20);
  translate(width/2, height/2);
  //calc const
  d = sqrt((tan(HALF_PI - PI / q) - tan(PI / p)) / (tan(HALF_PI - PI / q) + tan(PI / p)));
}

void draw(){
  background(255);
  float bdist = map(mouseX, 0, width, -1, 1);
  //float bangle = map(mouseY, 0, height, 0, TWO_PI);
  float bangle = 0;
  translate(width/2, height/2);
  //hypCircle
  PVector cc = hypCircle(PVector.fromAngle(bangle).mult(bdist), new PVector(0, 0));
  PVector dc = hypCircle(new PVector(0, 0), PVector.fromAngle(bangle).mult(bdist));
  //intersection
  PVector[] ip = circleIntersection(cc, dc);
  fill(255, 0, 0);marker(ip[0], 10/dispScale, "ip1");
  fill(255, 0, 0);marker(ip[1], 10/dispScale, "ip2");
  //invert iP[0]
  PVector invip = mobiusInverse(new PVector(0,0), 1.0, ip[0]);
  fill(255, 0, 0);marker(invip, 10/dispScale, "invip");
  //circle passing through ip1, ip2, invip
  PVector pc = circleThreePoints(ip[0], ip[1], invip);
  noFill();marker(pc, "passing through ip1, ip2, invip");
  //create polygon vertex
  PVector[] positions = new PVector[p];
  PVector[] ipositions = new PVector[p];
  
  if(mousePressed){ //For easy visualization
  for(int i=0; i<p; i++){
    PVector pos = PVector.fromAngle(TWO_PI / p * i + rotang).mult(d);
    fill(255, 0, 0);marker(pos, 10/dispScale, "rawpos");
    if(bdist != 0){
      pos = mobiusInverse(new PVector(pc.x, pc.y), pc.z, pos);
      fill(255, 0, 0);marker(pos, 10/dispScale, "pos");
    }
    PVector inv = mobiusInverse(new PVector(0, 0), 1.0, pos);
    fill(255, 0, 0);marker(inv, 10/dispScale, "invpos");
    positions[i] = pos;
    ipositions[i] = inv;
  }
  }
}

PVector hypCircle(PVector a, PVector b){
  //x, y, rad
  PVector o;//out
  PVector a2 = mobiusInverse(new PVector(0, 0), 1.0, a);
  PVector cpos = PVector.add(a, a2).mult(0.5);
  float crad = PVector.dist(a, cpos);
  PVector b2 = mobiusInverse(cpos, crad, b);
  PVector mid = PVector.add(b, b2).mult(0.5);
  if(a.x == 0 && a.y == 0){
    o = new PVector(0, 0, b.mag());
  }else{
    o = new PVector(mid.x, mid.y, PVector.dist(mid, b));
  }
  noFill();marker(0, 0, 1, "poincare disk");
  noFill();marker(o, "hypCircle");
  noFill();marker(a, 20/dispScale, "a");
  noFill();marker(b, 10/dispScale, "b");
  noFill();marker(cpos, crad, "cCircle");
  fill(255, 0, 0);
  marker(a2, 20/dispScale, "a2");
  marker(b2, 10/dispScale, "b2");
  //ellipse(ocen.x*1000, ocen.y*1000, orad*1000, orad*1000);
  return o;
}

PVector[] circleIntersection(PVector o1, PVector o2){
  float rad1 = o1.z;
  float rad2 = o2.z;
  o1 = new PVector(o1.x, o1.y);
  o2 = new PVector(o2.x, o2.y);
  PVector[] out = new PVector[2];
  
  float d = PVector.dist(o1, o2);
  
  float a = (rad1 * rad1 - rad2 * rad2 + d * d) / (2 * d);
  PVector p = PVector.add(o1, PVector.sub(o2, o1).mult(a / d));
  float h = sqrt(rad1 * rad1 - a * a);
  
  out[0]  = new PVector(p.x + h * (o2.y - o1.y) / d, p.y - h * (o2.x - o1.x)/ d);
  out[1]  = new PVector(p.x - h * (o2.y - o1.y) / d, p.y + h * (o2.x - o1.x)/ d);
  return out;
}

PVector circleThreePoints(PVector a, PVector b, PVector c){
  PVector ta = a.copy(), tb = b.copy(), tc = c.copy();
  if(a.x == b.x || a.y == b.y){
    tc = b;
    tb = c;
  }
  
  float ma = (tb.y - ta.y) / (tb.x - ta.x);
  float mb = (tc.y - tb.y) / (tc.x - tb.x);
  
  float x = (ma * mb * (ta.y - tc.y) + mb * (ta.x + tb.x) - ma * (tb.x + tc.x)) / (2 * (mb - ma));
  float y = -1.0 / ma * (x - (ta.x + tb.x) / 2.0) + (ta.y + tb.y) / 2.0;
  //(x, y)=pos z=radius
  PVector o = new PVector(x, y);
  o.z = PVector.dist(o, a);
  return o;
}

PVector mobiusInverse(PVector o, float r, PVector p){//Same as inverse function
  PVector d = PVector.sub(p, o);
  float a = r * r / d.magSq();
  return new PVector(a * d.x + o.x, a * d.y + o.y);
}

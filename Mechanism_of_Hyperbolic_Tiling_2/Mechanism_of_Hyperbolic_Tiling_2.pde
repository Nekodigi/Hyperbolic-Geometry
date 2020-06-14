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
  //user input
  float bdist = map(mouseX, 0, width, -1, 1);
  //float bangle = map(mouseY, 0, height, 0, TWO_PI);
  float bangle = 0;
  translate(width/2, height/2);
  //base element visualize
  noFill();marker(0, 0, 1, "poincare disk");
  //hypCircle
  PVector cc = hypCircle(PVector.fromAngle(bangle).mult(bdist), new PVector(0, 0));
  PVector dc = hypCircle(new PVector(0, 0), PVector.fromAngle(bangle).mult(bdist));
  //intersection
  PVector[] ip = circleIntersection(cc, dc);
  //invert iP[0]
  PVector invip = mobiusInverse(new PVector(0,0), 1.0, ip[0]);
  //circle passing through ip1, ip2, invip
  PVector pc = circleThreePoints(ip[0], ip[1], invip);
  //create polygon vertex
  PVector[] positions = new PVector[p];
  PVector[] ipositions = new PVector[p];


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
  //create curve edge
  
  for(int i=0; i<positions.length; i++){
    PVector pos1 = positions[i];
    PVector pos2 = positions[(i+1) % positions.length];
    PVector pos3 = ipositions[i];
    
    PVector o = circleThreePoints(pos1, pos2, pos3);
    float rad = o.z;
    strokeWeight(1);stroke(0);
    noFill();marker(o, "circle for edge");
    
    float tang1 = (atan2(pos1.y - o.y, pos1.x - o.x) + PI * 2) % (PI * 2);
    float tang2 = (atan2(pos2.y - o.y, pos2.x - o.x) + PI * 2) % (PI * 2);
    float ang1, ang2;
    
    if(tang1 > tang2){
        ang1 = tang2;
        ang2 = tang1;
    }else{
        ang1 = tang1;
        ang2 = tang2;
    }
    
    
    float ang = (ang2 - ang1);
    if(ang > PI ){
        ang -= 2 * PI;
    }
    noFill();beginShape();
    int res = 10;//resolution of arc
    for(int n=0; n<res; n++){
        float nang = ang1 + ang / float(res - 1) * n;
        PVector apos = new PVector(o.x + rad * cos(nang), o.y + rad * sin(nang));
        stroke(255, 0, 0);strokeWeight(5);
        vertex(apos.x*dispScale, apos.y*dispScale);
    }
    endShape();
  }
  strokeWeight(1);stroke(0);
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

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
//            (x,y)=pos,z=radius
PVector mobiusInverse(PVector o, PVector p){//Same as inverse function
  return mobiusInverse(new PVector(o.x, o.y), o.z, p);
}

PVector mobiusInverse(PVector o, float r, PVector p){//Same as inverse function
  PVector d = PVector.sub(p, o);
  float a = r * r / d.magSq();
  return new PVector(a * d.x + o.x, a * d.y + o.y);
}

int p = 5;
int q = 4;
float rotang = 0;
float d;
float dispScale = 400;
Polygon polygon = new Polygon();
int gpid = 0;

void setup(){
  //fullScreen();
  size(1000, 1000);
  colorMode(HSB, 360, 100, 100);
  textSize(20);
  translate(width/2, height/2);
  //calc const
  d = sqrt((tan(HALF_PI - PI / q) - tan(PI / p)) / (tan(HALF_PI - PI / q) + tan(PI / p)));
}

void draw(){
  background(360);
  //base element visualize
  textSize(50);textAlign(LEFT, TOP);
  fill(0);
  text("p="+p, 0, 0);
  text("q="+q, 0, 50);
  textSize(20);textAlign(CENTER, BOTTOM);
  
  polygon = new Polygon();
  //user input
  float bdist = map(mouseX, 0, width, -1, 1);
  //float bangle = map(mouseY, 0, height, 0, TWO_PI);
  float bangle = float(frameCount)/100;
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
    if(bdist != 0){
      pos = mobiusInverse(new PVector(pc.x, pc.y), pc.z, pos);
    }
    PVector inv = mobiusInverse(new PVector(0, 0), 1.0, pos);
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
    int res = 10;//resolution of arc
    Edge edge = new Edge(o);
    for(int n=0; n<res; n++){
        float nang = ang1 + ang / float(res - 1) * n;
        PVector apos = new PVector(o.x + rad * cos(nang), o.y + rad * sin(nang));
        edge.addV(apos.x, apos.y);//addV with id increment
    }
    polygon.edges.add(edge);
  }
  fill(255, 0, 0);
  polygon.genChild();
  polygon.genChild();
  polygon.genChild();
  polygon.show();
}

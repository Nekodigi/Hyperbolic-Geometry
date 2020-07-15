class Edge{
  ArrayList<Point> vertices = new ArrayList<Point>();
  //(x,y)=pos, z=radius
  PVector o;
  
  Edge(PVector o){
    this.o = o;
  }
  
  void addV(float x, float y){
    vertices.add(new Point(x, y));
  }
  
  void addV(Point p){//ref gvid
    vertices.add(p);
  }
  
  void show(){
    noFill();
    beginShape();
    for(Point v : vertices){
      vertex(v.p.x*dispScale, v.p.y*dispScale);
    }
    endShape();
  }
  
  Edge mobiusInverseE(PVector oi){
    //marker(oi, "oi");
    PVector op = new PVector(o.x, o.y);
    PVector invO = mobiusInverse(oi, op);
    Edge edge = new Edge(invO);
    for(Point p : vertices){
      PVector invP = mobiusInverse(oi, p.p);
      edge.addV(invP.x, invP.y);
    }
    Point v0 = edge.vertices.get(0);
    Point v1 = edge.vertices.get(ceil(edge.vertices.size()/2));
    Point v2 = edge.vertices.get(edge.vertices.size()-1);
    edge.o = circleThreePoints(v0.p, v1.p, v2.p);
    //edge.o.z = PVector.dist(o, v0.p);//set radius
    //marker(edge.o, 10/dispScale, "o");
    //marker(invO, 10/dispScale, "invO");
    //marker(edge.o, "no");
    return edge;
  }
}

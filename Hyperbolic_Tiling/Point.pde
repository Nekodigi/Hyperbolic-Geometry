class Point{
  PVector p;
  int id;
  
  Point(float x, float y){//merge by distance?
    p = new PVector(x, y);
    id = gpid;
    gpid++;
  }
}

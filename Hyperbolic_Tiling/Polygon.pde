class Polygon{
  ArrayList<Edge> edges = new ArrayList<Edge>();
  ArrayList<Polygon> children = null;
  
  void genChild(){
    if(children == null){
      children = new ArrayList<Polygon>();
      ////for(Edge oe : edges){
      //  Edge oe = edges.get(0);
      //  Polygon polygon = new Polygon();
      ////  for(Edge e : edges){
      //  Edge e = edges.get(2);
      //    if(oe == e){
      //      polygon.edges.add(e);
      //    }else{
      //      Edge invEdge = e.mobiusInverseE(oe.o);
      //      polygon.edges.add(invEdge);
      //    }
      //  //}
      //  children.add(polygon);
      ////}
      
      //T2
      
      for(Edge oe : edges){
        Polygon polygon = new Polygon();
        for(Edge e : edges){
          if(oe == e){
            polygon.edges.add(e);
          }else{
            Edge invEdge = e.mobiusInverseE(oe.o);
            polygon.edges.add(invEdge);
          }
        }
        children.add(polygon);
      }
    }else{
      for(Polygon polygon : children){
        polygon.genChild();
      }
    }
  }
  
  void show(){
    PVector center = new PVector();
    int count = 0;
    for(Edge e : edges){
      for(Point p : e.vertices){
        center.add(p.p.x, p.p.y);
        count++;
      }
    }
    center.div(count);
    fill(0, 100-center.mag()*100, 100);
    beginShape();
    //connect edges
    Point prev = null;
    for(int i=0; i<edges.size(); i++){
      for(Edge e : edges){
        Point start = e.vertices.get(0);
        Point end = e.vertices.get(e.vertices.size()-1);
        if(prev == null){
          for(Point p : e.vertices){
            vertex(p.p.x*dispScale, p.p.y*dispScale);
          }
          prev = end;
        }else if(PVector.dist(prev.p, end.p) < 0.001){
          for(int j = e.vertices.size()-1; j >= 0; j--){
            Point p = e.vertices.get(j);
            vertex(p.p.x*dispScale, p.p.y*dispScale);
          }
          prev = start;
        }else if(PVector.dist(prev.p, start.p) < 0.001){
          for(Point p : e.vertices){
            vertex(p.p.x*dispScale, p.p.y*dispScale);
          }
          prev = end;
        }
      }
    }
    endShape();
    if(children != null){
      for(Polygon polygon : children){
        polygon.show();
      }
    }
    //for(Edge edge : edges){
    //  edge.show();
    //}
  }
}

class Node{
  String name = "";
  float angle = 0;//polar coordinate in hyperbolic geometry
  float len;
  PVector poss = new PVector();//screen position
  ArrayList<Node> children = new ArrayList<Node>();
  Node parent;
  
  Node(){}
  
  Node(String name_, float angle_, float len, boolean isRelativeAngle, Node parent){
    this(angle_, len, isRelativeAngle, parent);
    this.name = name_;
  }
  
  Node(float angle_, float len, boolean isRelativeAngle, Node parent){
    this.parent = parent;
    if(isRelativeAngle)setRelativeAngle(angle_);
    else this.angle = angle_;
    this.len = len;
  }
  
  void setRelativeAngle(float angle_){
    if(parent != null) ;
    this.angle = parent.angle + angle_;
  }
  
  void addChild(String name, float angle, float len, boolean isRelativeAngle){
    Node child = new Node(name, angle, len, isRelativeAngle, this);
    children.add(child);
  }
  
  void addChild(float angle, float len, boolean isRelativeAngle){
    Node child = new Node(angle, len, isRelativeAngle, this);
    children.add(child);
  }
  
  void calcScreenPos(){
    if(parent != null){
      PVector posh = PVector.fromAngle(angle).mult(len);
      PVector pose = projectionHtoE(posh);//to euclidian geometry
      poss = translatePoint(pose, parent.poss);
    }
  }
  
  void update(){
    calcScreenPos();
    
    for(Node child : children){//call recursive
      child.update();
    }
  }
  
  void show(){
    calcScreenPos();
    for(Node child : children){
      child.show();
    }
    stroke(173, 127, 0);
    strokeWeight(10);
    if(parent != null){ line(poss, parent.poss);println();}
    strokeWeight(1);
    stroke(0);
    fill(0);
    marker(poss, 20/dispScale, name);
    fill(255);
  }
}
